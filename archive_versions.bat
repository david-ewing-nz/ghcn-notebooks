@echo off
REM Archive old versions to keep folder manageable
cd /d "%~dp0"

echo ========================================
echo ARCHIVE OLD VERSIONS
echo ========================================
echo.

REM Create archive directory if it doesn't exist
if not exist "archive" (
    mkdir archive
    echo ✓ Created archive directory
)

echo Current versions in code/:
dir /b code\2025*_Build.ipynb | findstr /r "2025"
echo.

echo Select archiving strategy:
echo.
echo [1] Archive versions older than 7 days
echo [2] Archive versions older than 30 days  
echo [3] Archive all except last 3 versions
echo [4] Manual selection
echo [5] Cancel
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo Archiving versions older than 7 days...
    forfiles /p code /m "2025*_Build.ipynb" /d -7 /c "cmd /c move @file ..\archive"
    echo ✓ Archived versions older than 7 days
)

if "%choice%"=="2" (
    echo Archiving versions older than 30 days...
    forfiles /p code /m "2025*_Build.ipynb" /d -30 /c "cmd /c move @file ..\archive"
    echo ✓ Archived versions older than 30 days
)

if "%choice%"=="3" (
    echo Archiving all except last 3 versions...
    REM Get list of files sorted by date, skip first 3, move rest
    for /f "skip=3 delims=" %%i in ('dir /b /o-d code\2025*_Build.ipynb') do (
        move "code\%%i" "archive\%%i"
    )
    echo ✓ Archived all except 3 most recent versions
)

if "%choice%"=="4" (
    echo Available versions:
    dir /b code\2025*_Build.ipynb
    echo.
    set /p version="Enter version to archive: "
    if exist "code\%version%" (
        move "code\%version%" "archive\%version%"
        echo ✓ Archived %version%
    ) else (
        echo Version not found.
    )
)

if "%choice%"=="5" (
    echo Cancelled.
    goto end
)

echo.
echo Archive contents:
dir /b archive\2025*_Build.ipynb 2>nul
if %ERRORLEVEL% NEQ 0 echo No archived versions.

echo.
echo To restore from archive:
echo move archive\VERSION_NAME.ipynb code\

:end
echo.
pause