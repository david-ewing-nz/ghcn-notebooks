@echo off
REM Automated Notebook Cleanup Script
REM This script runs the automated cleanup process for the D notebook

echo ========================================
echo Automated Notebook Cleanup
echo ========================================
echo.

cd /d "%~dp0"

echo Checking Python environment...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python and try again
    pause
    exit /b 1
)

echo.
echo Starting automated cleanup of 20250916D_Build.ipynb...
echo.

python automate_notebook_cleanup.py

if errorlevel 1 (
    echo.
    echo ERROR: Cleanup script failed!
    echo Check the error messages above.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Cleanup completed successfully!
echo ========================================
echo.
echo Summary:
echo - Removed duplicate Q4(b)58 cells
echo - Removed test/debugging cells
echo - Kept only essential analysis cells
echo.
echo The notebook is now ready for the next phase.
echo.

pause