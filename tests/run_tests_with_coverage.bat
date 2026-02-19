@echo off
setlocal enabledelayedexpansion
REM Run Tlang tests with gcov coverage (Windows)
REM Requires: tlangc (or cargo), gcc with gcov

set COVERAGE_DIR=coverage_out
if not "%1"=="" set COVERAGE_DIR=%1

cd /d "%~dp0"
if not exist "%COVERAGE_DIR%" mkdir "%COVERAGE_DIR%"
del /q "%COVERAGE_DIR%\*.gcda" "%COVERAGE_DIR%\*.gcno" "%COVERAGE_DIR%\*.c" "%COVERAGE_DIR%\*.gcov" 2>nul

where tlangc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Using: cargo run --
    set TLANG_CMD=cargo run --
) else (
    set TLANG_CMD=tlangc
)

set TESTS=test_core_features.tl test_control_flow.tl test_data_structures.tl test_functions_errors.tl test_advanced_features.tl test_error_propagation.tl
set PASSED=0
set FAILED=0

echo ==========================================
echo Tlang tests with coverage (gcov)
echo ==========================================
echo.

for %%f in (%TESTS%) do (
    set "base=%%~nf"
    set "cfile=%COVERAGE_DIR%\%%~nf.c"
    set "binary=%COVERAGE_DIR%\%%~nf"
    echo ----------------------------------------
    echo Compile and run: %%f
    echo ----------------------------------------

    %TLANG_CMD% compile %%f "!cfile!" >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo FAIL: %%f - Tlang compile
        set /a FAILED+=1
    ) else (
        gcc -fprofile-arcs -ftest-coverage -o "!binary!.exe" "!cfile!" -lm -lssl -lcrypto >nul 2>&1
        if %ERRORLEVEL% NEQ 0 (
            echo FAIL: %%f - gcc compile
            set /a FAILED+=1
        ) else (
            "!binary!.exe" >nul 2>&1
            if !ERRORLEVEL! NEQ 0 (
                echo FAIL: %%f - test exit non-zero
                set /a FAILED+=1
            ) else (
                echo PASS: %%f
                set /a PASSED+=1
            )
        )
    )
    echo.
)

echo ----------------------------------------
echo Coverage report (gcov)
echo ----------------------------------------
cd "%COVERAGE_DIR%"
for %%c in (*.c) do gcov -n "%%c" 2>nul
cd ..

echo.
echo Summary: %PASSED% passed, %FAILED% failed
echo Coverage files in: %COVERAGE_DIR%\
if %FAILED% GTR 0 exit /b 1
exit /b 0
