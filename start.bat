@echo off
title PC Optimizer Pro
cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js belum terpasang. Jalankan install.bat terlebih dahulu.
  pause
  exit /b 1
)

if not exist "node_modules\" (
  echo Dependensi belum terpasang. Menjalankan install...
  call npm install
)

echo.
echo  PC Optimizer Pro v1.1.0
echo  Membuka http://localhost:3000
echo  Tekan Ctrl+C untuk menghentikan.
echo.
start "" "http://localhost:3000"
call npm run dev
