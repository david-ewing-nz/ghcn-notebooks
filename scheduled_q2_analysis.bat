@echo off
echo ========================================
echo SCHEDULED Q2 ANALYSIS - FULLY AUTOMATED
echo ========================================
echo.

echo Running automated Q2 coverage analysis...
python automate_q2_analysis.py > q2_analysis_log.txt 2>&1

echo.
echo Analysis completed. Log saved to q2_analysis_log.txt

echo.
echo Sending notification...
python send_notification.py "Q2 Analysis Complete" "Automated analysis finished. Check q2_coverage_report.txt for results."

echo.
echo ========================================
echo AUTOMATION COMPLETE
echo ========================================