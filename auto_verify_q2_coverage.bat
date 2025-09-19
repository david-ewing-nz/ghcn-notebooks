@echo off
REM Automated Q2 Coverage Verification
REM Runs verify_q2_coverage.py and logs output

echo ========================================
echo Q2 COVERAGE VERIFICATION
echo ========================================
python verify_q2_coverage.py > q2_coverage_report.txt

type q2_coverage_report.txt

echo ========================================
echo Q2 COVERAGE CHECK COMPLETE
echo ========================================