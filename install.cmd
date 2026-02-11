@echo off
REM Tlang single-link install for Windows CMD
REM Usage: curl -fsSL https://raw.githubusercontent.com/vasuvanka/tlang/main/install.cmd -o install.cmd && install.cmd && del install.cmd
REM Or run install.cmd directly after downloading.

if "%TLANG_INSTALL_URL%"=="" set "TLANG_INSTALL_URL=https://raw.githubusercontent.com/vasuvanka/tlang/main"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -UseBasicParsing -Uri '%TLANG_INSTALL_URL%/install.ps1' | Invoke-Expression"
exit /b %ERRORLEVEL%
