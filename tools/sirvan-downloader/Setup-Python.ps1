$ErrorActionPreference = 'Stop'
# Use the Store-distributed Python. Do not retry the blocked python.org installer.
$packages = @(Get-AppxPackage -Name 'PythonSoftwareFoundation.Python.3.13' -ErrorAction SilentlyContinue |
    Where-Object { $_.SignatureKind -eq 'Store' -and $_.Status -eq 'Ok' })
if ($packages.Count -eq 0) {
    Write-Host 'Satu langkah diperlukan: pasang Python 3.13 dari Microsoft Store.' -ForegroundColor Yellow
    Write-Host 'Pilih penerbit Python Software Foundation, klik Get/Install. Setelah selesai, jalankan INSTALL.bat ini lagi.'
    try { Start-Process 'ms-windows-store://search/?query=Python%203.13' } catch {}
    throw 'Python 3.13 dari Microsoft Store belum terpasang. Smart App Control tidak perlu diubah.'
}
$package = $packages | Sort-Object Version -Descending | Select-Object -First 1
$candidates = @(
    (Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\python3.13.exe'),
    (Join-Path $package.InstallLocation 'python3.13.exe'),
    (Join-Path $package.InstallLocation 'python.exe')
)
$python = $null
foreach ($candidate in $candidates) {
    if (-not (Test-Path -LiteralPath $candidate)) { continue }
    try {
        & $candidate -I -c 'import sys; sys.exit(0 if sys.version_info[:2] == (3,13) and sys.maxsize > 2**32 else 1)' | Out-Null
        if ($LASTEXITCODE -eq 0) { $python = $candidate; break }
    } catch {
        throw 'Windows menolak menjalankan Python Store. Kirim screenshot pesan; jangan ubah perlindungan Windows.'
    }
}
if (-not $python) { throw 'Python Store terdeteksi tetapi belum bisa dijalankan sebagai Python 3.13 64-bit. Buka Python 3.13 dari Start satu kali, tutup, lalu coba lagi.' }
$venv = Join-Path $PSScriptRoot 'venv-store'
$venvPython = Join-Path $venv 'Scripts\python.exe'
if (-not (Test-Path -LiteralPath $venvPython)) {
    Write-Output 'Menyiapkan lingkungan aplikasi dengan Python Microsoft Store...'
    & $python -I -m venv $venv
    if ($LASTEXITCODE -ne 0) { throw 'Gagal membuat lingkungan aplikasi. Kirim pesan di atas untuk diperiksa.' }
}
& $venvPython -I -c 'import sys; print(sys.version.split()[0])'
if ($LASTEXITCODE -ne 0) { throw 'Python aplikasi gagal dijalankan. Kirim screenshot pesan untuk diperiksa.' }
