@echo off
REM Fully automated Q2 analysis - runs silently in background
REM No user interaction required

cd /d "%~dp0"

echo [%DATE% %TIME%] Starting automated Q2 analysis >> automated_schedule.log
python automate_q2_analysis.py >> automated_schedule.log 2>&1

if %ERRORLEVEL% EQU 0 (
    echo [%DATE% %TIME%] SUCCESS: Analysis completed >> automated_schedule.log
    python send_notification.py "Scheduled Q2 Analysis Complete" "Automated analysis finished. Results in q2_coverage_report.txt" >> automated_schedule.log 2>&1
) else (
    echo [%DATE% %TIME%] ERROR: Analysis failed with code %ERRORLEVEL% >> automated_schedule.log
    python send_notification.py "Scheduled Q2 Analysis Failed" "Check automated_schedule.log for details" >> automated_schedule.log 2>&1
)

echo [%DATE% %TIME%] Automation cycle complete >> automated_schedule.log