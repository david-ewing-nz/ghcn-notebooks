@echo off
echo ========================================
echo Q2 ANALYSIS STATUS CHECKER
echo ========================================
echo.

echo Checking automation status...
echo.

REM Check if scheduled task exists
schtasks /query /tn "Q2_Analysis_Automation" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✓ Scheduled task is ACTIVE
    echo   - Runs daily at 9:00 AM
    echo   - No user intervention required
) else (
    echo ✗ Scheduled task is NOT set up
    echo   Run 'setup_automated_q2.bat' to enable automatic execution
)

echo.

REM Check for recent results
if exist "q2_coverage_report.txt" (
    echo ✓ Analysis report exists
    for %%A in ("q2_coverage_report.txt") do echo   - Last modified: %%~tA
) else (
    echo ✗ No analysis report found
    echo   Run analysis to generate report
)

echo.

REM Check for logs
if exist "automated_schedule.log" (
    echo ✓ Automation log exists
    for %%A in ("automated_schedule.log") do echo   - Last modified: %%~tA
) else (
    echo ✗ No automation log found
)

echo.

REM Show next scheduled run
echo Next scheduled run:
schtasks /query /tn "Q2_Analysis_Automation" /fo list | find "Next Run Time"

echo.
echo ========================================
echo QUICK ACTIONS
echo ========================================
echo.
echo [1] Run analysis now (immediate)
echo [2] Setup automatic scheduling
echo [3] View latest report
echo [4] View automation log
echo.
set /p choice="Choose action (1-4) or press Enter to exit: "

if "%choice%"=="1" (
    echo.
    echo Running analysis now...
    call fully_automated_q2.bat
)

if "%choice%"=="2" (
    echo.
    echo Setting up automatic scheduling...
    call setup_automated_q2.bat
)

if "%choice%"=="3" (
    echo.
    if exist "q2_coverage_report.txt" (
        start q2_coverage_report.txt
    ) else (
        echo No report found. Run analysis first.
    )
)

if "%choice%"=="4" (
    echo.
    if exist "automated_schedule.log" (
        start automated_schedule.log
    ) else (
        echo No log found.
    )
)

echo.
pause