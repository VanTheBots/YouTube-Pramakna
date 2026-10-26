@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0Install.ps1"
if errorlevel 1 (
  echo.
  echo Instalasi belum selesai. Foto pesan di atas untuk bantuan.
  pause
)
