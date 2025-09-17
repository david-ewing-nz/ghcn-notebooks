@echo off
echo ========================================
echo ENHANCED AUTOMATION SETUP
echo ========================================
echo.
echo Choose your automation frequency:
echo.
echo [1] Every 2 hours (during work hours)
echo [2] Every 4 hours (balanced)
echo [3] Every hour (very frequent)
echo [4] Custom schedule
echo [5] Cancel
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo Setting up 2-hour schedule (9 AM - 5 PM)...
    schtasks /create /tn "Q2_Analysis_Enhanced" /tr "\"%~dp0enhanced_q2_automation.bat\"" /sc hourly /mo 2 /st 09:00 /et 17:00 /rl highest /f
    set schedule="Every 2 hours, 9 AM - 5 PM"
)

if "%choice%"=="2" (
    echo Setting up 4-hour schedule...
    schtasks /create /tn "Q2_Analysis_Enhanced" /tr "\"%~dp0enhanced_q2_automation.bat\"" /sc hourly /mo 4 /rl highest /f
    set schedule="Every 4 hours"
)

if "%choice%"=="3" (
    echo Setting up hourly schedule...
    schtasks /create /tn "Q2_Analysis_Enhanced" /tr "\"%~dp0enhanced_q2_automation.bat\"" /sc hourly /mo 1 /rl highest /f
    set schedule="Every hour"
)

if "%choice%"=="4" (
    echo.
    echo Custom schedule options:
    echo schtasks /create /tn "Q2_Analysis_Custom" /tr "\"%~dp0enhanced_q2_automation.bat\""
    echo Add your preferred /sc and timing parameters
    echo.
    pause
    exit
)

if "%choice%"=="5" (
    echo Cancelled.
    pause
    exit
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ SUCCESS: Enhanced automation scheduled!
    echo ✓ Frequency: %schedule%
    echo ✓ No user intervention required
    echo.
    echo To modify: schtasks /change /tn "Q2_Analysis_Enhanced" [parameters]
    echo To stop: schtasks /delete /tn "Q2_Analysis_Enhanced"
) else (
    echo.
    echo ✗ FAILED: Could not create enhanced schedule
    echo You may need Administrator privileges
)

echo.
pause