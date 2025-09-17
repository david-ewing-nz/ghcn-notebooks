@echo off
REM Setup for Scheduled Automated Cell Addition
REM This creates a scheduled task to run cell addition automatically

echo ========================================
echo SETTING UP AUTOMATED CELL ADDITION
echo ========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running as administrator - can create scheduled task
) else (
    echo NOT running as administrator
    echo Please run as administrator to create scheduled task
    goto :eof
)

set TASK_NAME=GHCN_Auto_Cell_Addition
set SCRIPT_PATH=%~dp0full_auto_cell_addition.bat

echo Creating scheduled task: %TASK_NAME%
echo This will run daily at 9:00 AM

schtasks /create /tn "%TASK_NAME%" /tr "\"%SCRIPT_PATH%\"" /sc daily /st 09:00 /ru "%USERNAME%" /rl highest /f

if errorlevel 1 (
    echo ❌ Failed to create scheduled task
) else (
    echo ✅ Scheduled task created successfully
    echo.
    echo Task Details:
    echo - Name: %TASK_NAME%
    echo - Runs: Daily at 9:00 AM
    echo - Script: %SCRIPT_PATH%
    echo.
    echo You can modify this task in Task Scheduler
)

echo.
echo To run manually: full_auto_cell_addition.bat
echo To remove task: schtasks /delete /tn "%TASK_NAME%" /f