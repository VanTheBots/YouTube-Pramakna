@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0Repair.ps1"
if errorlevel 1 (
 echo.
 echo Foto pesan di atas untuk bantuan. Jangan matikan perlindungan Windows.
 pause
)
