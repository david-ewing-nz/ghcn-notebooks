@echo off
REM Git-aware Q2 analysis - triggers on git changes
cd /d "%~dp0"

echo [%DATE% %TIME%] Checking for git changes... >> git_aware_automation.log

REM Check git status for changes
git status --porcelain > temp_git_status.txt 2>&1

REM Check if there are any changes
for /f %%i in ("temp_git_status.txt") do set size=%%~zi
if %size% gtr 0 (
    echo [%DATE% %TIME%] Git changes detected, running analysis >> git_aware_automation.log

    REM Run analysis
    python automate_q2_analysis.py >> git_aware_automation.log 2>&1

    if %ERRORLEVEL% EQU 0 (
        echo [%DATE% %TIME%] SUCCESS: Git-triggered analysis completed >> git_aware_automation.log
        python send_notification.py "Q2 Analysis Update" "Git changes detected. Analysis completed." >> git_aware_automation.log 2>&1
    ) else (
        echo [%DATE% %TIME%] ERROR: Git-triggered analysis failed >> git_aware_automation.log
    )
) else (
    echo [%DATE% %TIME%] No git changes detected, skipping analysis >> git_aware_automation.log
)

REM Check for remote changes (pushes from other locations)
git fetch origin >nul 2>&1
git status -uno | find "behind" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [%DATE% %TIME%] Remote changes detected, pulling and analyzing >> git_aware_automation.log
    git pull >> git_aware_automation.log 2>&1

    REM Run analysis after pull
    python automate_q2_analysis.py >> git_aware_automation.log 2>&1

    if %ERRORLEVEL% EQU 0 (
        echo [%DATE% %TIME%] SUCCESS: Post-pull analysis completed >> git_aware_automation.log
        python send_notification.py "Q2 Analysis Update" "Remote changes pulled. Analysis completed." >> git_aware_automation.log 2>&1
    )
)

REM Cleanup
del temp_git_status.txt 2>nul

echo [%DATE% %TIME%] Git-aware automation cycle complete >> git_aware_automation.log