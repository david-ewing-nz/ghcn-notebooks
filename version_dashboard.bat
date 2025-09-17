@echo off
echo ========================================
echo NOTEBOOK VERSION MANAGEMENT DASHBOARD
echo ========================================
echo.

REM Get today's date
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
set TODAY=%datetime:~0,8%

echo Current Date: %TODAY%
echo.

echo === EXISTING VERSIONS ===
echo.

REM List all versions by date
echo Recent versions:
dir /b /o-n code\2025*_Build.ipynb 2>nul
if %ERRORLEVEL% NEQ 0 echo No notebook versions found.

echo.
echo === VERSION ACTIONS ===
echo.
echo [1] Create new version from current
echo [2] Switch automation to different version
echo [3] Compare two versions
echo [4] Archive old versions
echo [5] View version history
echo [6] Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" (
    echo.
    call notebook_versioner.bat
    goto end
)

if "%choice%"=="2" (
    echo.
    echo Available versions:
    dir /b code\2025*_Build.ipynb
    echo.
    set /p version="Enter version to switch to (e.g., 20250918A_Build.ipynb): "
    echo Switching automation to %version%...
    powershell -Command "(Get-Content q2_automation_config.ini) -replace 'notebook_path = .*', 'notebook_path = code/%version%' | Set-Content q2_automation_config.ini"
    echo ✓ Automation switched to %version%
    goto end
)

if "%choice%"=="3" (
    echo.
    echo Available versions:
    dir /b code\2025*_Build.ipynb
    echo.
    set /p v1="Enter first version: "
    set /p v2="Enter second version: "
    echo.
    echo Comparing %v1% vs %v2%:
    REM Basic file comparison
    fc code\%v1% code\%v2% | find /c "*****" > temp_compare.txt
    set /p diff_count=<temp_compare.txt
    echo Differences found: %diff_count%
    del temp_compare.txt
    goto end
)

if "%choice%"=="4" (
    echo.
    echo This will move old versions to archive folder.
    echo Continue? (y/n)
    set /p confirm="Enter y or n: "
    if "%confirm%"=="y" (
        if not exist "archive" mkdir archive
        forfiles /p code /m "2025*_Build.ipynb" /d -30 /c "cmd /c move @file ..\archive"
        echo ✓ Old versions archived
    )
    goto end
)

if "%choice%"=="5" (
    echo.
    if exist "VERSION_HISTORY.md" (
        start VERSION_HISTORY.md
    ) else (
        echo Version history not found.
    )
    goto end
)

if "%choice%"=="6" (
    goto end
)

echo Invalid choice.
goto end

:end
echo.
echo ========================================
echo DASHBOARD COMPLETE
echo ========================================
pause