@echo off
REM Automated Analysis Script for F Version (Tier 2 - Filtered Data)
REM Executes notebook and extracts diagnostic results

echo [%date% %time%] Starting automated analysis of F version...

REM Activate virtual environment
call .venv\Scripts\activate.bat

REM Execute the diagnostic cells in the notebook
echo [%date% %time%] Executing diagnostic cells...
jupyter nbconvert --to notebook --execute --inplace code/20250916F_Build.ipynb

REM Extract diagnostic output
echo [%date% %time%] Extracting diagnostic results...
python auto_extract_diagnostics.py code/20250916F_Build.ipynb F

REM Save results summary
echo [%date% %time%] Analysis complete. Results saved to results\F_analysis_summary.txt

REM Push results back to repository
echo [%date% %time%] Pushing results to repository...
call auto_push_results.bat

REM Deactivate virtual environment
call deactivate

echo [%date% %time%] F version analysis and push completed successfully!