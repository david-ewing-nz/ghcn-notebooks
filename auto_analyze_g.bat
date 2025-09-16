@echo off
REM Automated Analysis Script for G Version (Tier 3 - Full Data)
REM Executes notebook and extracts diagnostic results

echo [%date% %time%] Starting automated analysis of G version...

REM Activate virtual environment
call .venv\Scripts\activate.bat

REM Execute the diagnostic cells in the notebook
echo [%date% %time%] Executing diagnostic cells...
jupyter nbconvert --to notebook --execute --inplace code/20250916G_Build.ipynb

REM Extract diagnostic output
echo [%date% %time%] Extracting diagnostic results...
python auto_extract_diagnostics.py code/20250916G_Build.ipynb G

REM Save results summary
echo [%date% %time%] Analysis complete. Results saved to results\G_analysis_summary.txt

REM Push results back to repository
echo [%date% %time%] Pushing results to repository...
call auto_push_results.bat

REM Deactivate virtual environment
call deactivate

echo [%date% %time%] G version analysis and push completed successfully!