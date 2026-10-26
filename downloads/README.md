# SirVan Downloader v2 untuk Windows

[Unduh SirVan Downloader v2 (ZIP)](https://github.com/VanTheBots/YouTube-Pramakna/raw/refs/heads/sirvan-downloader-windows/downloads/SirVan-Downloader-Windows-v2.zip)

1. Unduh ZIP baru, lalu klik kanan **Extract All / Ekstrak Semua** ke folder baru.
2. Buka folder hasil ekstrak, lalu klik dua kali **INSTALL.bat**.
3. Tunggu pemasangan Python resmi dan mesin pengunduh selesai. Shortcut **SirVan Downloader** muncul di Desktop.
4. Tempel link video TikTok, pilih folder, lalu klik **Download**.

Versi ini menggunakan paket Python `yt-dlp`, menggantikan executable mandiri `yt-dlp.exe` yang diblokir pada laptop pengguna. Pemasang tidak mengubah Smart App Control atau menonaktifkan antivirus. Kompatibilitas dengan kebijakan Windows laptop pengguna belum terbukti; jika komponen tetap diblokir, hentikan dan kirim screenshot pesan.

Python 64-bit yang sudah terpasang dan memiliki tanda tangan Python Software Foundation yang valid digunakan jika sesuai. Jika belum ada, pemasang mengambil Python 3.14.7 resmi dari python.org, memeriksa SHA256 dari manifest Microsoft WinGet dan tanda tangan Authenticode, lalu memasangnya untuk pengguna saat ini. yt-dlp dipasang dari PyPI resmi dalam virtual environment aplikasi. Tidak ada perubahan PATH atau kebutuhan mengetik perintah.

Memerlukan Windows 10/11 64-bit dan internet. Unduhan beberapa link, ingatan folder terakhir, arsip unduhan per folder, pembaruan mesin, dan log tersedia. Kualitas mengikuti file gabungan terbaik yang tersedia; versi tanpa watermark tidak dijamin tersedia.

## Validasi

- Sintaks semua skrip PowerShell lolos parser.
- Worker: simulasi sukses dan kegagalan parsial lolos, termasuk pemanggilan `python -I -m yt_dlp`.
- Instalasi paket PyPI dan pemanggilan versi yt-dlp berhasil di lingkungan Linux.
- Pemasangan Python Windows, pemeriksaan Authenticode, UI Windows, dan unduhan TikTok nyata belum diuji. Akses python.org dari lingkungan pengembangan dibatasi; verifikasi pemasang dilakukan saat pemasangan di laptop.

[Sumber checksum Python: Microsoft WinGet](https://github.com/microsoft/winget-pkgs/blob/master/manifests/p/Python/Python/3/14/3.14.7/Python.Python.3.14.installer.yaml)

[Kode sumber pemasang dan aplikasi](../tools/sirvan-downloader/)
