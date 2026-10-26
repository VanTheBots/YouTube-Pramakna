$ErrorActionPreference = 'Stop'
try {
    $dest = Join-Path $env:LOCALAPPDATA 'SirVanDownloader'
    $python = Join-Path $dest 'venv-store\Scripts\python.exe'
    if (-not (Test-Path -LiteralPath $python)) { throw 'Versi 3 belum terpasang. Jalankan INSTALL.bat dari paket lengkap dahulu.' }
    Write-Host 'Tutup SirVan Downloader sebelum melanjutkan.' -ForegroundColor Yellow
    Read-Host 'Setelah ditutup, tekan Enter' | Out-Null
    foreach ($name in @('Update.ps1','Worker.ps1','App.ps1')) {
        $installed = Join-Path $dest $name
        if (Test-Path -LiteralPath $installed) { Copy-Item -LiteralPath $installed -Destination ($installed + '.before-network-repair.bak') -Force }
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) -Destination $dest -Force
    }
    & (Join-Path $dest 'Update.ps1')
    Write-Host 'Perbaikan terpasang. Membuka aplikasi...' -ForegroundColor Green
    $app = Join-Path $dest 'App.ps1'
    Start-Process "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList ('-NoLogo -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -STA -File "' + $app + '"')
} catch {
    Write-Host ('Perbaikan belum selesai: ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
}
