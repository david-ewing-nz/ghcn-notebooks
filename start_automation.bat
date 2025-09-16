@echo off
REM Startup Script for Automated Cross-Environment Diagnostics
REM Initializes the complete automation workflow

echo ========================================
echo AUTOMATED CROSS-ENVIRONMENT DIAGNOSTICS
echo ========================================
echo [%date% %time%] Initializing automation system...

REM Check if virtual environment exists
if not exist ".venv" (
    echo [%date% %time%] Creating virtual environment...
    python -m venv .venv
)

REM Activate virtual environment
echo [%date% %time%] Activating virtual environment...
call .venv\Scripts\activate.bat

REM Install/update required packages
echo [%date% %time%] Installing required packages...
pip install --upgrade pip
pip install jupyter nbconvert pandas numpy matplotlib

REM Create results directory
if not exist "results" mkdir results

REM Start the master orchestrator
echo [%date% %time%] Starting master orchestrator...
start /B auto_orchestrator.bat

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