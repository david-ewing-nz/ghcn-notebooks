@echo off
echo ========================================
echo FULLY AUTOMATED Q2 ANALYSIS SYSTEM
echo ========================================
echo.

echo Starting fully automated analysis...
echo No user intervention required!

REM Run the analysis silently
python automate_q2_analysis.py > automated_q2_log.txt 2>&1

REM Check if analysis completed successfully
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ Analysis completed successfully!
    echo ✓ Report generated: q2_coverage_report.txt
    echo ✓ Log saved: automated_q2_log.txt
    echo.
    echo Sending completion notification...
    python send_notification.py "Q2 Analysis Complete" "Automated analysis finished successfully. Check q2_coverage_report.txt for results."
) else (
    echo.
    echo ✗ Analysis failed with error code %ERRORLEVEL%
    echo Check automated_q2_log.txt for details
    python send_notification.py "Q2 Analysis Failed" "Automated analysis encountered an error. Check automated_q2_log.txt"
)

echo.
echo ========================================
echo AUTOMATION COMPLETE - NO APPROVAL NEEDED
echo ========================================
echo.
echo The system ran completely automatically!
echo Check q2_coverage_report.txt for your results.
echo.