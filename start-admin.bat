@echo off
:: Re-launch elevated if not admin
net session >nul 2>&1
if errorlevel 1 (
  echo Meminta hak Administrator...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

title PC Optimizer Pro (Administrator)
cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js belum terpasang. Jalankan install.bat terlebih dahulu.
  pause
  exit /b 1
)

if not exist "node_modules\" (
  call npm install
)

echo.
echo  PC Optimizer Pro v1.1.0  [Administrator]
echo  Membuka http://localhost:3000
echo  Fitur penuh: Clean, Service, Repair, Restore, Tweaks HKLM
echo  Tekan Ctrl+C untuk menghentikan.
echo.
start "" "http://localhost:3000"
call npm run dev
