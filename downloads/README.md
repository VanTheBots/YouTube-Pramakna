# SirVan Downloader v3 untuk Windows

[Unduh SirVan Downloader v3 (ZIP)](https://github.com/VanTheBots/YouTube-Pramakna/raw/refs/heads/sirvan-downloader-windows/downloads/SirVan-Downloader-Windows-v3.zip)

1. Buka **Microsoft Store**, cari **Python 3.13** dengan penerbit **Python Software Foundation**, lalu klik **Get/Install**.
2. Ekstrak ZIP baru ke folder baru, lalu klik dua kali **INSTALL.bat**.
3. Tunggu selesai. Shortcut **SirVan Downloader** muncul di Desktop.
4. Tempel link video TikTok, pilih folder, klik **Download**.

Jika Python Store belum dipasang, pemasang membuka pencarian Store dan berhenti dengan petunjuk. Setelah Python terpasang, jalankan INSTALL.bat lagi.

## Perbaikan versi 3

Versi 1 gagal karena executable yt-dlp diblokir Application Control. Versi 2 telah memverifikasi tanda tangan pemasang Python, tetapi Windows tetap memblokir komponen PythonBA.dll di dalamnya. Versi 3 menggunakan distribusi Python 3.13 Microsoft Store yang dipasang pengguna, lalu memasang paket yt-dlp dari PyPI dalam virtual environment aplikasi. Pemasang tidak menjalankan pemasang Python .exe, tidak mengubah Smart App Control, dan tidak mematikan antivirus.

Memerlukan Windows 10/11 64-bit, Microsoft Store, dan internet. Kualitas mengikuti file gabungan terbaik yang tersedia; versi tanpa watermark tidak selalu tersedia. Folder terakhir diingat, duplikat yang telah tercatat dilewati, pembaruan mesin dan log tersedia.

## Validasi dan batasan

Sintaks seluruh skrip PowerShell dan worker dengan simulasi sukses/gagal lolos. Paket yt-dlp dari PyPI bisa dipasang dan dijalankan di Linux. Instalasi Microsoft Store, virtual environment Windows Store, UI Windows, dan unduhan TikTok nyata belum diuji. Kompatibilitas dengan Smart App Control pengguna belum terbukti; jika diblokir lagi, kirim screenshot pesan tanpa mematikan perlindungan.

[Kode sumber](../tools/sirvan-downloader/)
