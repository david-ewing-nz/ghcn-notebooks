@echo off
REM Automated Results Push Script
REM Pushes analysis results and updated code back to repository

echo [%date% %time%] Preparing to push analysis results and updated code...

REM Add results and updated code to git
git add results\*.txt
git add optimized_probe_universe.py
git add code/auto_extract_and_update.py

REM Check if there are changes to commit
git diff --cached --quiet
if %ERRORLEVEL% neq 0 (
    REM Commit the results and updated code
    git commit -m "Automated analysis results and code updates - %date% %time%"

    REM Push the results
    git push origin main

    echo [%date% %time%] Results and code updates pushed successfully!
) else (
    echo [%date% %time%] No new changes to push
)

echo [%date% %time%] Push operation completed