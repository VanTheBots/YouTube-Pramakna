$ErrorActionPreference = 'Stop'
$python = Join-Path $PSScriptRoot 'venv-store\Scripts\python.exe'
if (-not (Test-Path -LiteralPath $python)) { throw 'Python aplikasi belum siap. Jalankan INSTALL.bat dari paket versi 3.' }
Write-Output 'Memperbarui yt-dlp nightly dan komponen koneksi browser dari PyPI resmi...'
& $python -I -m pip --isolated install --upgrade --pre --index-url https://pypi.org/simple --only-binary=:all: --disable-pip-version-check "yt-dlp[default,curl-cffi]"
if ($LASTEXITCODE -ne 0) { throw 'Pemasangan yt-dlp gagal. Periksa koneksi internet atau lihat pesan di atas.' }
& $python -I -m yt_dlp --ignore-config --version
if ($LASTEXITCODE -ne 0) { throw 'Paket yt-dlp belum bisa dijalankan.' }
& $python -I -c 'from curl_cffi import requests; print(requests.__name__)'
if ($LASTEXITCODE -ne 0) { throw 'Komponen koneksi browser gagal dimuat. Kirim screenshot pesan; jangan ubah perlindungan Windows.' }
& $python -I -m yt_dlp --ignore-config --list-impersonate-targets
if ($LASTEXITCODE -ne 0) { throw 'Pemeriksaan koneksi browser gagal.' }
Write-Output 'Mesin dan komponen koneksi siap. Smart App Control tidak diubah.' 
