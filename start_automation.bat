@echo off
REM Enhanced Startup Script for Fully Automated Cross-Environment Diagnostics
REM Initializes the complete hands-off automation workflow

echo ========================================
echo    FULLY AUTOMATED CROSS-ENVIRONMENT DIAGNOSTICS
echo ========================================
echo [%date% %time%] Initializing enhanced automation system...

REM Check if virtual environment exists
if not exist ".venv" (
    echo [%date% %time%] ERROR: Virtual environment not found!
    echo Please run environment setup first.
    echo.
    pause
    exit /b 1
)

REM Check for configuration file
if not exist "automation_config.ini" (
    echo [%date% %time%] Creating default configuration file...
    echo # Configuration file for automated result extraction > automation_config.ini
    echo # Update these values with your actual E run results >> automation_config.ini
    echo [RESULTS] >> automation_config.ini
    echo daily_count = 120000 >> automation_config.ini
    echo station_count = 25000 >> automation_config.ini
    echo inv_count = 25000 >> automation_config.ini
    echo diffs = [0, 0, 0, 0] >> automation_config.ini
    echo values_updated = false >> automation_config.ini
    echo. >> automation_config.ini
    echo # Automation settings >> automation_config.ini
    echo auto_commit = true >> automation_config.ini
    echo auto_push = true >> automation_config.ini
    echo monitoring_interval_seconds = 60 >> automation_config.ini
)

REM Activate virtual environment
echo [%date% %time%] Activating virtual environment...
call .venv\Scripts\activate.bat

REM Test the automation components
echo [%date% %time%] Testing automation components...
python code/auto_extract_and_update.py

REM Create results directory
if not exist "results" mkdir results

REM Start the enhanced monitor
echo [%date% %time%] Starting enhanced automated monitor...
start "GHCN Full Automation" /B auto_git_monitor_final.bat

echo.
echo ========================================
echo        AUTOMATION IS NOW ACTIVE!
echo ========================================
echo.
echo System Status: FULLY AUTOMATED
echo Monitoring: Every 60 seconds for Git changes
echo Processing: Automatic extraction, update, commit, push
echo.
echo To customize:
echo 1. Edit automation_config.ini with your actual values
echo 2. Set values_updated = true for real results
echo 3. The system runs completely hands-off
echo.
echo To stop: Close the "GHCN Full Automation" window
echo.
echo You are now OUTSIDE THE LOOP - full automation achieved!
echo.

pause

echo.
echo ========================================
echo AUTOMATION SYSTEM INITIALIZED
echo ========================================
echo.
echo The system is now running in the background and will:
echo - Monitor for new test results from PySpark environment
echo - Automatically pull changes when detected
echo - Execute notebooks and extract diagnostic results
echo - Generate comprehensive analysis reports
echo.
echo Results will be saved to the 'results' directory
echo Check results\final_report.txt for complete analysis
echo.
echo Press Ctrl+C to stop monitoring...
echo.

REM Keep the terminal open for status monitoring
pause