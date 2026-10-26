# SirVan Downloader v3.1 untuk Windows

[Unduh SirVan Downloader v3.1 (ZIP)](https://github.com/VanTheBots/YouTube-Pramakna/raw/refs/heads/sirvan-downloader-windows/downloads/SirVan-Downloader-Windows-v3.1.zip)

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

## Perbaikan untuk pengguna v3 yang sudah bisa membuka aplikasi

[Unduh paket perbaikan koneksi TikTok](https://github.com/VanTheBots/YouTube-Pramakna/raw/refs/heads/sirvan-downloader-windows/downloads/SirVan-Perbaikan-TikTok.zip). Tutup aplikasi, ekstrak ZIP, klik **PERBAIKI.bat**, lalu tekan Enter. Tidak perlu memasang ulang Python.

Paket lama hanya memasang yt-dlp dasar. Perbaikan menambahkan default dependencies dan curl_cffi, serta memperbarui ke nightly sesuai panduan resmi yt-dlp. Versi mesin dan daftar dukungan browser dicatat pada log. Ini memperbaiki kekurangan setup; belum mengonfirmasi akar penyebab atau keberhasilan unduhan video yang dilaporkan pengguna.

Validasi tambahan: semua skrip lolos parser, simulasi worker sukses dan kegagalan parsial lolos, curl_cffi aktif di Linux, seluruh wheel Windows x64 Python 3.13 berhasil diunduh. Eksekusi Windows dan respons TikTok dari laptop pengguna masih perlu diuji. Akses TikTok tidak diizinkan oleh kebijakan jaringan lingkungan pengembangan.

[Sumber panduan dependensi](https://github.com/yt-dlp/yt-dlp#impersonation) · [Panduan kanal pembaruan](https://github.com/yt-dlp/yt-dlp#update-channels)
