@echo off
REM Automated Analysis Script for E Version (Tier 1 - Sample Data)
REM Executes notebook analysis, extracts results, and updates hardcoded values

echo [%date% %time%] Starting automated analysis of E version...

REM Activate virtual environment
call .venv\Scripts\activate.bat

REM Extract diagnostic results from the E notebook
echo [%date% %time%] Extracting diagnostic results from E notebook...
python auto_extract_diagnostics.py "code\20250916E_Build.ipynb" "E"
if %errorlevel% equ 0 (
    echo [%date% %time%] SUCCESS: Diagnostic results found and extracted from E notebook!
) else (
    echo [%date% %time%] No diagnostic results found in E notebook.
)

REM Extract results from the E notebook and update hardcoded values
echo [%date% %time%] Extracting results and updating optimized_probe_universe.py...
python code/auto_extract_and_update.py

REM Save results summary
echo [%date% %time%] Results extraction and update complete.

REM Push results back to repository
echo [%date% %time%] Pushing updated code to repository...
call auto_push_results.bat

REM Deactivate virtual environment
call deactivate

echo [%date% %time%] E version analysis, update, and push completed successfully!