$ErrorActionPreference = 'Stop'
try {
    if (-not [Environment]::Is64BitOperatingSystem) { throw 'Paket ini memerlukan Windows 10/11 64-bit.' }
    $dest = Join-Path $env:LOCALAPPDATA 'SirVanDownloader'
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    foreach ($name in @('App.ps1','Update.ps1','Worker.ps1','BACA DULU.txt')) {
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) -Destination $dest -Force
    }
    Write-Host 'Memasang mesin pengunduh resmi. Tunggu sampai selesai...' -ForegroundColor Cyan
    & (Join-Path $dest 'Update.ps1')
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'SirVan Downloader.lnk'))
    $shortcut.TargetPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
    $shortcut.Arguments = '-NoLogo -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -STA -File "' + (Join-Path $dest 'App.ps1') + '"'
    $shortcut.WorkingDirectory = $dest
    $shortcut.Description = 'Tempel link TikTok dan simpan footage ke folder proyek.'
    $shortcut.Save()
    Write-Host 'Selesai. Shortcut SirVan Downloader sudah ada di Desktop.' -ForegroundColor Green
    Start-Process -FilePath $shortcut.TargetPath -ArgumentList $shortcut.Arguments
} catch {
    Write-Host ('Gagal: ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
}
