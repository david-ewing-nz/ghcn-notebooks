@echo off
REM Fully Automated Cell Addition System
REM This script automatically adds core cells to new notebooks without user intervention

echo ========================================
echo FULLY AUTOMATED CELL ADDITION SYSTEM
echo ========================================
echo.

REM Configuration - Update these paths as needed
set REFERENCE_NOTEBOOK=code\20250916D_Build.ipynb
set LOG_FILE=automation_log.txt

echo [%DATE% %TIME%] Starting automated cell addition process >> "%LOG_FILE%"

REM Find all Build notebooks that might need updating
for %%f in (code\202509*Build.ipynb) do (
    if not "%%f"=="%REFERENCE_NOTEBOOK%" (
        echo Checking %%f...

        REM Run the automation script
        python automate_cell_addition.py "%REFERENCE_NOTEBOOK%" "%%f" >> "%LOG_FILE%" 2>&1

        if errorlevel 1 (
            echo ❌ Failed to process %%f
            echo [%DATE% %TIME%] ERROR: Failed to process %%f >> "%LOG_FILE%"
        ) else (
            echo ✅ Successfully processed %%f
            echo [%DATE% %TIME%] SUCCESS: Processed %%f >> "%LOG_FILE%"
        )
    )
)

echo.
echo [%DATE% %TIME%] Automated process complete >> "%LOG_FILE%"
echo ========================================
echo AUTOMATION COMPLETE
echo Check %LOG_FILE% for detailed results
echo ========================================