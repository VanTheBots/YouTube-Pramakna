$ErrorActionPreference = 'Stop'
$python = Join-Path $PSScriptRoot 'venv-store\Scripts\python.exe'
if (-not (Test-Path -LiteralPath $python)) { throw 'Python aplikasi belum siap. Jalankan INSTALL.bat dari paket versi 3.' }
Write-Output 'Memasang/memperbarui yt-dlp dari PyPI resmi...'
& $python -I -m pip --isolated install --upgrade --index-url https://pypi.org/simple --only-binary=:all: --disable-pip-version-check yt-dlp
if ($LASTEXITCODE -ne 0) { throw 'Pemasangan yt-dlp gagal. Periksa koneksi internet atau lihat pesan di atas.' }
& $python -I -m yt_dlp --ignore-config --version
if ($LASTEXITCODE -ne 0) { throw 'Paket yt-dlp belum bisa dijalankan.' }
Write-Output 'Mesin siap. Smart App Control tidak diubah.'
