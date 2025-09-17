@echo off
REM Automated Cell Addition Batch Script
REM This script automates adding the three core cells to any notebook

echo ========================================
echo Automated Cell Addition System
echo ========================================
echo.

if "%~2"=="" (
    echo Usage: %0 ^<reference_notebook^> ^<target_notebook^>
    echo Example: %0 code\20250916D_Build.ipynb code\20250918A_Build.ipynb
    echo.
    echo This will add the three core cells (imports, helper functions, variables)
    echo from the reference notebook to the target notebook if they're missing.
    goto :eof
)

set REFERENCE=%1
set TARGET=%2

echo Reference notebook: %REFERENCE%
echo Target notebook: %TARGET%
echo.

if not exist "%REFERENCE%" (
    echo ERROR: Reference notebook '%REFERENCE%' not found!
    goto :eof
)

if not exist "%TARGET%" (
    echo ERROR: Target notebook '%TARGET%' not found!
    goto :eof
)

echo Running automation script...
python automate_cell_addition.py "%REFERENCE%" "%TARGET%"

echo.
echo ========================================
echo Process Complete!
echo ========================================