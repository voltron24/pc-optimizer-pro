@echo off
title Pack dari win-unpacked
cd /d "%~dp0"
echo Membuat Portable + Setup dari folder win-unpacked yang sudah ada...
echo.

if not exist "release\win-unpacked\PC Optimizer Pro.exe" (
  if not exist "release\win-unpacked" (
    echo [ERROR] Folder release\win-unpacked tidak ada.
    echo Jalankan build-exe.bat dulu.
    pause
    exit /b 1
  )
  echo [INFO] Cari file .exe di dalam win-unpacked:
  dir /s /b "release\win-unpacked\*.exe"
)

set CSC_IDENTITY_AUTO_DISCOVERY=false
call npx electron-builder --win portable nsis --x64 --prepackaged release/win-unpacked --config.win.signAndEditExecutable=false

echo.
echo Hasil:
dir /b release\*.exe 2>nul
echo.
explorer release
pause
