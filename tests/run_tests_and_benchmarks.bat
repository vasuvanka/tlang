@echo off
REM Run all tests then all benchmarks (unified runner).
cd /d "%~dp0"

echo ========== 1/2 Tests ==========
call run_all_tests.bat
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
echo.
echo ========== 2/2 Benchmarks ==========
call run_benchmarks.bat
exit /b %ERRORLEVEL%
