@echo off
echo ========================================
echo SETTING UP FULLY AUTOMATED Q2 ANALYSIS
echo ========================================
echo.

echo This will set up Windows Task Scheduler to run Q2 analysis automatically
echo No manual intervention will be required after setup!
echo.

REM Get the current directory
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

echo Script directory: %SCRIPT_DIR%
echo.

REM Create the scheduled task
echo Creating scheduled task...
schtasks /create /tn "Q2_Analysis_Automation" /tr "\"%SCRIPT_DIR%\silent_q2_automation.bat\"" /sc daily /st 09:00 /rl highest /f

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ SUCCESS: Scheduled task created!
    echo ✓ Task will run daily at 9:00 AM
    echo ✓ No user interaction required
    echo.
    echo To modify the schedule:
    echo schtasks /change /tn "Q2_Analysis_Automation" /st HH:MM
    echo.
    echo To run immediately:
    echo schtasks /run /tn "Q2_Analysis_Automation"
    echo.
    echo To delete the task:
    echo schtasks /delete /tn "Q2_Analysis_Automation"
) else (
    echo.
    echo ✗ FAILED: Could not create scheduled task
    echo You may need to run this as Administrator
    echo.
    echo Alternative: Run 'silent_q2_automation.bat' manually when needed
)

echo.
echo ========================================
echo SETUP COMPLETE
echo ========================================
echo.
echo Your Q2 analysis will now run automatically every day at 9:00 AM
echo Results will be saved to q2_coverage_report.txt
echo Logs will be saved to automated_schedule.log
echo.
pause