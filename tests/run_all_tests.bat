@echo off
REM Run all test suites for Tlang (Windows)

echo ==========================================
echo Tlang Comprehensive Test Suite
echo ==========================================
echo.

REM Check if tlangc is available
where tlangc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Warning: tlangc not found in PATH
    echo Using cargo run -- instead...
    set TLANG_CMD=cargo run --
) else (
    set TLANG_CMD=tlangc
)

REM Test files
set TESTS=test_core_features.tl test_control_flow.tl test_data_structures.tl test_functions_errors.tl test_advanced_features.tl

set PASSED=0
set FAILED=0
set TOTAL=0

for %%f in (%TESTS%) do (
    set /a TOTAL+=1
    echo ----------------------------------------
    echo Running: %%f
    echo ----------------------------------------
    
    REM Compile Tlang file
    %TLANG_CMD% compile %%f > test_output.txt 2>&1
    if %ERRORLEVEL% EQU 0 (
        REM Compile the generated C code
        gcc -o test_binary.exe output.c -lm -lssl -lcrypto > test_output.txt 2>&1
        if %ERRORLEVEL% EQU 0 (
            REM Run the test
            test_binary.exe >> test_output.txt 2>&1
            set TEST_EXIT=%ERRORLEVEL%
            type test_output.txt
            if %TEST_EXIT% EQU 0 (
                echo [PASSED] %%f
                set /a PASSED+=1
            ) else (
                echo [FAILED] %%f ^(exit code: %TEST_EXIT%^)
                set /a FAILED+=1
            )
        ) else (
            echo [FAILED] %%f ^(C compilation error^)
            type test_output.txt
            set /a FAILED+=1
        )
    ) else (
        echo [FAILED] %%f ^(Tlang compilation error^)
        type test_output.txt
        set /a FAILED+=1
    )
    echo.
)

echo ==========================================
echo Test Summary
echo ==========================================
echo Total:  %TOTAL%
echo Passed: %PASSED%
echo Failed: %FAILED%
echo.

if %FAILED% EQU 0 (
    echo All tests passed!
    exit /b 0
) else (
    echo Some tests failed
    exit /b 1
)
