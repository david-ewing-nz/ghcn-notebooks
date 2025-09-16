@echo off
REM Automated Results Push Script
REM Pushes analysis results back to repository

echo [%date% %time%] Preparing to push analysis results...

REM Check if there are new results to push
if exist "results\*.txt" (
    echo [%date% %time%] New results found - staging and pushing...

    REM Add results to git
    git add results\*.txt

    REM Check if there are changes to commit
    git diff --cached --quiet
    if %ERRORLEVEL% neq 0 (
        REM Commit the results
        git commit -m "Automated analysis results - %date% %time%"

        REM Push the results
        git push origin main

        echo [%date% %time%] Results pushed successfully!
    ) else (
        echo [%date% %time%] No new results to push
    )
) else (
    echo [%date% %time%] No results directory found
)

echo [%date% %time%] Push operation completed