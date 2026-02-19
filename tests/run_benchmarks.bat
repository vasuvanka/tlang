@echo off
setlocal enabledelayedexpansion
REM Run Tlang benchmark programs (use std/benchmark).
REM Use run_tests_and_benchmarks.bat to run both tests and benchmarks.

cd /d "%~dp0"

where tlangc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Using: cargo run --
    set TLANG_CMD=cargo run --
) else (
    set TLANG_CMD=tlangc
)

set BENCHMARKS=bench_math.tl
set PASSED=0
set FAILED=0

echo ==========================================
echo Tlang benchmarks
echo ==========================================
echo.

for %%f in (%BENCHMARKS%) do (
    if exist "%%f" (
        echo ----------------------------------------
        echo Run: %%f
        echo ----------------------------------------
        %TLANG_CMD% compile %%f output.c >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            gcc -o bench_binary.exe output.c -lm -lssl -lcrypto >nul 2>&1
            if !ERRORLEVEL! EQU 0 (
                bench_binary.exe >nul 2>&1
                if !ERRORLEVEL! EQU 0 (
                    echo PASS: %%f
                    set /a PASSED+=1
                ) else (
                    echo FAIL: %%f - non-zero exit
                    set /a FAILED+=1
                )
                del bench_binary.exe output.c 2>nul
            ) else (
                echo FAIL: %%f - gcc error
                set /a FAILED+=1
            )
        ) else (
            echo FAIL: %%f - Tlang compile error
            set /a FAILED+=1
        )
        echo.
    )
)

echo Summary: %PASSED% passed, %FAILED% failed
if %FAILED% GTR 0 exit /b 1
exit /b 0
