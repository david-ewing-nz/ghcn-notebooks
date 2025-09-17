@echo off
REM Master Automation Script - Fully Automated Cross-Environment Diagnostics
REM Combines Git monitoring with diagnostic result detection
REM Runs continuously without user intervention

echo ================================================
echo MASTER AUTOMATION: Cross-Environment Diagnostics
echo ================================================
echo [%date% %time%] Starting fully automated monitoring...
echo This will run continuously - monitoring for:
echo - New Git commits with test results
echo - Diagnostic results in Build files
echo - Automated analysis and notifications
echo ================================================

REM Start both monitoring processes in parallel
start "Git Monitor" /b auto_git_monitor_enhanced.bat
start "Diagnostic Monitor" /b auto_diagnostic_monitor.bat

echo [%date% %time%] Both monitoring processes started successfully!
echo The system is now running fully automated.
echo Check the console windows for status updates.
echo Press Ctrl+C in each window to stop individual monitors.

REM Keep this script running to show status
:status_loop
    echo [%date% %time%] System Status: ACTIVE
    echo Git Monitor: Running (check other window)
    echo Diagnostic Monitor: Running (check other window)

    REM Check if alert log exists and show recent alerts
    if exist "diagnostic_alert.log" (
        echo Recent Alerts:
        powershell -command "Get-Content diagnostic_alert.log -Tail 5"
    )

    REM Wait 5 minutes before next status update
    timeout /t 300 /nobreak >nul

goto status_loop