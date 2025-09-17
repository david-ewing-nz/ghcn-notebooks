@echo off
REM Enhanced automation with multiple daily runs
cd /d "%~dp0"

echo [%DATE% %TIME%] Starting enhanced Q2 analysis >> enhanced_automation.log

REM Run analysis
python automate_q2_analysis.py >> enhanced_automation.log 2>&1

if %ERRORLEVEL% EQU 0 (
    echo [%DATE% %TIME%] SUCCESS: Enhanced analysis completed >> enhanced_automation.log
    REM Only send notification if there are significant changes
    python send_notification.py "Q2 Analysis Update" "Enhanced analysis completed. Check q2_coverage_report.txt" >> enhanced_automation.log 2>&1
) else (
    echo [%DATE% %TIME%] ERROR: Enhanced analysis failed >> enhanced_automation.log
)

echo [%DATE% %TIME%] Enhanced automation cycle complete >> enhanced_automation.log