@echo off
echo ========================================
echo Q2 AUTOMATION CONTROL CENTER
echo ========================================
echo.
echo Welcome to fully automated Q2 analysis!
echo No "Allow" buttons required!
echo.

:menu
echo Choose your option:
echo.
echo [1] Run Q2 analysis NOW (immediate results)
echo [2] Setup automatic daily execution
echo [3] Check automation status
echo [4] View latest results
echo [5] View automation logs
echo [6] Run silent background analysis
echo [7] Exit
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" (
    echo.
    echo Running immediate Q2 analysis...
    call fully_automated_q2.bat
    goto menu
)

if "%choice%"=="2" (
    echo.
    echo Setting up automatic execution...
    call setup_automated_q2.bat
    goto menu
)

if "%choice%"=="3" (
    echo.
    echo Checking automation status...
    call q2_status.bat
    goto menu
)

if "%choice%"=="4" (
    echo.
    if exist "q2_coverage_report.txt" (
        echo Opening latest report...
        start q2_coverage_report.txt
    ) else (
        echo No report found. Run analysis first.
    )
    goto menu
)

if "%choice%"=="5" (
    echo.
    if exist "automated_schedule.log" (
        echo Opening automation log...
        start automated_schedule.log
    ) else (
        echo No log found.
    )
    goto menu
)

if "%choice%"=="6" (
    echo.
    echo Running silent background analysis...
    start /b silent_q2_automation.bat
    echo Analysis started in background. Check logs for results.
    goto menu
)

if "%choice%"=="7" (
    echo.
    echo Goodbye! Your Q2 analysis is fully automated.
    echo.
    pause
    exit
)

echo Invalid choice. Please try again.
goto menu