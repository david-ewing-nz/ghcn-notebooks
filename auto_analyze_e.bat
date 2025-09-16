@echo off
REM Automated Analysis Script for E Version (Tier 1 - Sample Data)
REM Executes notebook and extracts diagnostic results

echo [%date% %time%] Starting automated analysis of E version...

REM Activate virtual environment
call .venv\Scripts\activate.bat

REM Execute the diagnostic cells in the notebook
echo [%date% %time%] Executing diagnostic cells...

REM Use nbconvert to execute the notebook
jupyter nbconvert --to notebook --execute --inplace code/20250916E_Build.ipynb

REM Extract diagnostic output
echo [%date% %time%] Extracting diagnostic results...
python auto_extract_diagnostics.py code/20250916E_Build.ipynb E

REM Save results summary
echo [%date% %time%] Analysis complete. Results saved to results\E_analysis_summary.txt

REM Push results back to repository
echo [%date% %time%] Pushing results to repository...
call auto_push_results.bat

REM Deactivate virtual environment
call deactivate

echo [%date% %time%] E version analysis and push completed successfully!