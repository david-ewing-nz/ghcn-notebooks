@echo off
REM Smart Q2 analysis - only runs when notebook has changed
cd /d "%~dp0"

REM Check if notebook has been modified recently
for %%A in ("code\20250916D_Build.ipynb") do set filetime=%%~tA

if "%filetime%"=="%LAST_RUN_TIME%" (
    echo [%DATE% %TIME%] No changes detected, skipping analysis >> smart_automation.log
    exit /b 0
)

echo [%DATE% %TIME%] Changes detected, running analysis >> smart_automation.log
set LAST_RUN_TIME=%filetime%

REM Run analysis
python automate_q2_analysis.py >> smart_automation.log 2>&1

if %ERRORLEVEL% EQU 0 (
    echo [%DATE% %TIME%] SUCCESS: Smart analysis completed >> smart_automation.log
    python send_notification.py "Q2 Analysis Update" "Notebook changes detected. Analysis completed." >> smart_automation.log 2>&1
) else (
    echo [%DATE% %TIME%] ERROR: Smart analysis failed >> smart_automation.log
)

echo [%DATE% %TIME%] Smart automation cycle complete >> smart_automation.log