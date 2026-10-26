param([string]$RequestPath)
$ErrorActionPreference = 'Stop'
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['Add-Content:Encoding'] = 'utf8'
$request = Get-Content -LiteralPath $RequestPath -Raw | ConvertFrom-Json
try {
    if ($request.mode -eq 'update') {
        & (Join-Path $PSScriptRoot 'Update.ps1') *>> $request.log
        if (-not $?) { throw 'Pembaruan gagal.' }
    } else {
        $exe = Join-Path $PSScriptRoot 'venv-store\Scripts\python.exe'
        if (-not (Test-Path -LiteralPath $exe)) { throw 'Mesin pengunduh belum terpasang. Klik Perbarui mesin.' }
        New-Item -ItemType Directory -Path $request.folder -Force | Out-Null
        $failed = 0
        foreach ($url in $request.urls) {
            Add-Content -LiteralPath $request.log -Value "`r`nMengunduh: $url"
            # Arguments are passed directly, never interpreted as shell commands.
            # TikTok normally supplies combined audio/video files; avoid conversion.
            $argsList = @('--ignore-config','--no-playlist','--newline','--no-colors','--windows-filenames',
                '--no-overwrites','--socket-timeout','30','--retries','3',
                '--download-archive',(Join-Path $request.folder '.sirvan-downloaded.txt'),
                '--format','best[ext=mp4]/best',
                '--paths',$request.folder,'--output','%(uploader).60B_%(id)s.%(ext)s',
                '--print','after_move:TERSIMPAN: %(filepath)s','--', $url)
            # Native stderr contains useful progress and must not become a terminating PS 5.1 error.
            $ErrorActionPreference = 'Continue'
            & $exe -I -m yt_dlp @argsList >> $request.log 2>&1
            $code = $LASTEXITCODE
            $ErrorActionPreference = 'Stop'
            if ($code -ne 0) {
                $failed++
                Add-Content -LiteralPath $request.log -Value 'GAGAL untuk link ini. Coba Perbarui mesin; video privat/dihapus atau pembatasan TikTok juga bisa menjadi penyebab.'
            }
        }
        if ($failed -gt 0) { throw "$failed link gagal. Lihat log; unduhan lain yang berhasil tetap tersimpan." }
    }
    @{ok=$true; message='Selesai. Video yang sudah tercatat dalam folder ini dilewati otomatis.'} | ConvertTo-Json | Set-Content -LiteralPath $request.result -Encoding UTF8
} catch {
    Add-Content -LiteralPath $request.log -Value ('ERROR: ' + $_.Exception.Message)
    @{ok=$false; message=$_.Exception.Message} | ConvertTo-Json | Set-Content -LiteralPath $request.result -Encoding UTF8
}
