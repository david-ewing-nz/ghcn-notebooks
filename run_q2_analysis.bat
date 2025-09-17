@echo off
echo ========================================
echo AUTOMATED Q2 ANALYSIS - NO APPROVAL NEEDED
echo ========================================
echo.

echo Starting automated analysis...
python automate_q2_analysis.py

echo.
echo ========================================
echo ANALYSIS COMPLETE
echo ========================================
echo.

echo Report saved to: q2_coverage_report.txt
echo.

echo Opening report...
start q2_coverage_report.txt

echo.
echo Process completed successfully - no user intervention required!
pause