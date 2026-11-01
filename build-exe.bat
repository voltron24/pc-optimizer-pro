@echo off
title Build PC Optimizer Pro EXE
cd /d "%~dp0"
echo ========================================
echo   Build PC Optimizer Pro .exe
echo ========================================
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js tidak ditemukan. Install dari https://nodejs.org
  pause
  exit /b 1
)

echo [1/4] npm install ...
call npm install
if errorlevel 1 (
  echo [ERROR] npm install gagal
  pause
  exit /b 1
)

echo.
echo [2/4] Build frontend + server ...
call npm run build
if errorlevel 1 (
  echo [ERROR] Build gagal - pastikan tidak ada error TypeScript/Vite
  pause
  exit /b 1
)

if not exist "dist\server.cjs" (
  echo [ERROR] dist\server.cjs tidak ada. Build server gagal.
  pause
  exit /b 1
)

echo.
echo [3/4] Packaging Windows EXE ...
echo     (signAndEditExecutable=false agar tidak macet di code signing)
set CSC_IDENTITY_AUTO_DISCOVERY=false
call npx electron-builder --win portable nsis --x64 --config.win.signAndEditExecutable=false
if errorlevel 1 (
  echo.
  echo [WARN] Packaging penuh gagal. Mencoba dari win-unpacked saja...
  if exist "release\win-unpacked" (
    call npx electron-builder --win portable nsis --x64 --prepackaged release/win-unpacked --config.win.signAndEditExecutable=false
  )
)

echo.
echo [4/4] Hasil:
echo.
dir /b release\*.exe 2>nul
if errorlevel 1 (
  echo.
  echo Belum ada .exe installer/portable.
  echo Anda TETAP bisa menjalankan aplikasi dari:
  echo   release\win-unpacked\PC Optimizer Pro.exe
  echo.
  echo Cek error di terminal di atas, atau buka:
  echo   release\builder-debug.yml
) else (
  echo.
  echo [OK] File .exe berhasil dibuat di folder release\
)

echo.
explorer release
pause
