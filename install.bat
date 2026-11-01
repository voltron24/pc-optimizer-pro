@echo off
title PC Optimizer Pro - Setup
cd /d "%~dp0"
echo ========================================
echo   PC Optimizer Pro v1.1.0 - Install
echo ========================================
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js tidak ditemukan.
  echo Install Node.js 18+ dari https://nodejs.org lalu jalankan install.bat lagi.
  pause
  exit /b 1
)

echo Node.js:
node -v
echo.
echo Menginstal dependensi...
call npm install
if errorlevel 1 (
  echo [ERROR] npm install gagal.
  pause
  exit /b 1
)

echo.
echo [OK] Instalasi selesai.
echo Jalankan start.bat  atau  start-admin.bat  (disarankan).
echo.
pause
