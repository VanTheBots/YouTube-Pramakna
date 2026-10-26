Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()
$root = $PSScriptRoot
$settings = Join-Path $root 'settings.json'
$script:process = $null
$script:request = $null
$form = New-Object Windows.Forms.Form
$form.Text = 'SirVan Downloader - TikTok'
$form.Size = New-Object Drawing.Size(780,690)
$form.MinimumSize = $form.Size
$form.StartPosition = 'CenterScreen'
$form.Font = New-Object Drawing.Font('Segoe UI',10)
function Label($text,$x,$y,$w,$h) {
    $c=New-Object Windows.Forms.Label; $c.Text=$text; $c.SetBounds($x,$y,$w,$h); $form.Controls.Add($c); return $c
}
function Button($text,$x,$y,$w) {
    $c=New-Object Windows.Forms.Button; $c.Text=$text; $c.SetBounds($x,$y,$w,34); $form.Controls.Add($c); return $c
}
$null=Label 'SIRVAN / FOOTAGE DOWNLOADER' 20 16 720 28
$null=Label 'Tempel link TikTok. Satu link per baris. Pilih folder proyek, lalu Download.' 20 48 720 30
$links=New-Object Windows.Forms.TextBox
$links.Multiline=$true; $links.ScrollBars='Vertical'; $links.SetBounds(20,84,720,135)
$form.Controls.Add($links)
$paste=Button 'Tempel clipboard' 20 228 155
$null=Label 'Folder tujuan (diingat otomatis)' 20 274 720 24
$folder=New-Object Windows.Forms.TextBox; $folder.SetBounds(20,303,585,28)
$folder.Text=Join-Path ([Environment]::GetFolderPath('MyVideos')) 'SirVan Footage'
if(Test-Path -LiteralPath $settings){try{$folder.Text=(Get-Content -LiteralPath $settings -Raw | ConvertFrom-Json).folder}catch{}}
$form.Controls.Add($folder)
$choose=Button 'Pilih folder' 615 300 125
$download=Button 'Download' 20 346 150
$open=Button 'Buka folder' 180 346 140
$update=Button 'Perbarui mesin' 330 346 150
$logs=Button 'Buka log' 490 346 120
$status=Label 'Siap.' 20 390 720 25
$logBox=New-Object Windows.Forms.TextBox; $logBox.Multiline=$true; $logBox.ReadOnly=$true
$logBox.ScrollBars='Vertical'; $logBox.SetBounds(20,421,720,155); $form.Controls.Add($logBox)
$null=Label 'Kualitas terbaik yang tersedia sebagai satu file, tanpa kompresi ulang. Watermark yang sudah menyatu dalam sumber tidak dihapus.' 20 585 720 48
$paste.Add_Click({if([Windows.Forms.Clipboard]::ContainsText()){$links.AppendText([Windows.Forms.Clipboard]::GetText()+[Environment]::NewLine)}})
$choose.Add_Click({
    $d=New-Object Windows.Forms.FolderBrowserDialog
    $d.Description='Pilih atau buat folder footage proyek'; $d.SelectedPath=$folder.Text
    if($d.ShowDialog() -eq 'OK'){$folder.Text=$d.SelectedPath}; $d.Dispose()
})
$open.Add_Click({
    try { New-Item -ItemType Directory -Path $folder.Text -Force -ErrorAction Stop | Out-Null
        Start-Process explorer.exe -ArgumentList ('"'+$folder.Text+'"')
    } catch { [Windows.Forms.MessageBox]::Show($_.Exception.Message,'Folder tidak dapat dibuka') }
})
function Start-Work($mode,$urls) {
    try {
        if($script:process -and -not $script:process.HasExited){return}
        $target=$folder.Text.Trim()
        if($mode -eq 'download') {
            if(-not [IO.Path]::IsPathRooted($target)){throw 'Pilih folder tujuan dengan tombol Pilih folder.'}
            New-Item -ItemType Directory -Path $target -Force -ErrorAction Stop | Out-Null
            @{folder=$target} | ConvertTo-Json | Set-Content -LiteralPath $settings -Encoding UTF8
        }
        $runDir=Join-Path $root 'logs'; New-Item -ItemType Directory -Path $runDir -Force | Out-Null
        $id=Get-Date -Format 'yyyyMMdd-HHmmss-fff'
        $script:request=@{mode=$mode; folder=$target; urls=@($urls); log=(Join-Path $runDir "$id.log"); result=(Join-Path $runDir "$id.result.json")}
        $reqPath=Join-Path $runDir "$id.request.json"
        $script:request | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $reqPath -Encoding UTF8
        $worker=Join-Path $root 'Worker.ps1'
        $exe="$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
        $argLine='-NoLogo -NoProfile -ExecutionPolicy Bypass -File "'+$worker+'" -RequestPath "'+$reqPath+'"'
        $script:process=Start-Process -FilePath $exe -ArgumentList $argLine -WindowStyle Hidden -PassThru
        $download.Enabled=$false; $update.Enabled=$false; $choose.Enabled=$false; $folder.Enabled=$false
        $status.Text=if($mode -eq 'update'){'Memperbarui mesin...'}else{'Mengunduh...'}
        $logBox.Text='Proses dimulai...'
    } catch { [Windows.Forms.MessageBox]::Show($_.Exception.Message,'Tidak bisa memulai') }
}
$download.Add_Click({
    $urls=@($links.Lines | ForEach-Object {$_.Trim()} | Where-Object {$_} | Select-Object -Unique)
    if($urls.Count -eq 0){[Windows.Forms.MessageBox]::Show('Tempel link video TikTok terlebih dahulu.');return}
    foreach($url in $urls){
        $uri=$null
        if(-not [Uri]::TryCreate($url,[UriKind]::Absolute,[ref]$uri) -or $uri.Scheme -ne 'https' -or
            -not ($uri.Host -eq 'tiktok.com' -or $uri.Host.EndsWith('.tiktok.com')) -or $uri.UserInfo){
            [Windows.Forms.MessageBox]::Show('Gunakan link HTTPS TikTok saja, satu link per baris. Baris bermasalah: '+$url);return
        }
        if($uri.Host -in @('tiktok.com','www.tiktok.com','m.tiktok.com') -and $uri.AbsolutePath -notmatch '/(video/\d+|t/[^/]+)'){
            [Windows.Forms.MessageBox]::Show('Tempel link video, bukan profil atau halaman pencarian: '+$url);return
        }
    }
    Start-Work 'download' $urls
})
$update.Add_Click({Start-Work 'update' @()})
$logs.Add_Click({
    $dir=Join-Path $root 'logs'; New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Start-Process explorer.exe -ArgumentList ('"'+$dir+'"')
})
$timer=New-Object Windows.Forms.Timer; $timer.Interval=750
$timer.Add_Tick({
    if($script:process){
        if(Test-Path -LiteralPath $script:request.log){
            try{$logBox.Text=(Get-Content -LiteralPath $script:request.log -Tail 100 -ErrorAction Stop) -join [Environment]::NewLine
                $logBox.SelectionStart=$logBox.TextLength; $logBox.ScrollToCaret()}catch{}
        }
        if($script:process.HasExited){
            $status.Text='Proses berhenti. Lihat log untuk detail.'
            if(Test-Path -LiteralPath $script:request.result){
                try{$r=Get-Content -LiteralPath $script:request.result -Raw | ConvertFrom-Json
                    $status.Text=if($r.ok){'Selesai.'}else{'Ada kegagalan. Lihat log di bawah.'}
                    $logBox.AppendText([Environment]::NewLine+$r.message)
                }catch{}
            }
            $script:process.Dispose(); $script:process=$null
            $download.Enabled=$true; $update.Enabled=$true; $choose.Enabled=$true; $folder.Enabled=$true
        }
    }
})
$form.Add_FormClosing({param($sender,$e)
    if($script:process -and -not $script:process.HasExited){
        $e.Cancel=$true
        [Windows.Forms.MessageBox]::Show('Proses masih berjalan. Tunggu sampai selesai sebelum menutup aplikasi.')
    }
})
$timer.Start()
[void]$form.ShowDialog()
$timer.Stop(); $timer.Dispose(); $form.Dispose()
