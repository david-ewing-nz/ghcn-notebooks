@echo off
REM Notebook versioning system
cd /d "%~dp0"

echo ========================================
echo NOTEBOOK VERSIONING SYSTEM
echo ========================================
echo.

REM Get today's date in YYYYMMDD format
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
set TODAY=%datetime:~0,8%

echo Today's date: %TODAY%
echo.

REM List existing versions for today
echo Existing versions for %TODAY%:
dir /b code\%TODAY%*_Build.ipynb 2>nul
if %ERRORLEVEL% NEQ 0 echo No existing versions found for today.
echo.

REM Find next available letter
set LETTERS=ABCDEFGHIJKLMNOPQRSTUVWXYZ
set NEXT_LETTER=

for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if not exist "code\%TODAY%%%L_Build.ipynb" (
        set NEXT_LETTER=%%L
        goto :found_letter
    )
)

:found_letter
if "%NEXT_LETTER%"=="" (
    echo ERROR: All letters A-Z used for today. Consider using numbers or starting new day.
    pause
    exit /b 1
)

echo Next available version: %TODAY%%NEXT_LETTER%_Build.ipynb
echo.

REM Ask user which notebook to version
echo Which notebook would you like to create a new version from?
echo.
echo [1] Current D notebook (20250916D_Build.ipynb)
echo [2] Specify custom source notebook
echo [3] Cancel
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    set SOURCE=code\20250916D_Build.ipynb
    echo Using source: %SOURCE%
)

if "%choice%"=="2" (
    echo.
    echo Available notebooks:
    dir /b code\*_Build.ipynb
    echo.
    set /p SOURCE="Enter source notebook name: "
    set SOURCE=code\%SOURCE%
)

if "%choice%"=="3" (
    echo Cancelled.
    pause
    exit
)

if not exist "%SOURCE%" (
    echo ERROR: Source notebook %SOURCE% not found!
    pause
    exit /b 1
)

REM Create new version
set TARGET=code\%TODAY%%NEXT_LETTER%_Build.ipynb

echo.
echo Creating new version...
copy "%SOURCE%" "%TARGET%"

if %ERRORLEVEL% EQU 0 (
    echo ✓ SUCCESS: Created %TODAY%%NEXT_LETTER%_Build.ipynb
    echo   Source: %SOURCE%
    echo   Target: %TARGET%
    echo.
    
    REM Update version history
    echo Updating version history...
    call update_version_history.bat "%TODAY%%NEXT_LETTER%_Build.ipynb" "Created from %SOURCE%"
    
    echo.
    echo Would you like to:
    echo [1] Update automation to use new version
    echo [2] Open new version in VS Code
    echo [3] Just show version info
    echo.
    set /p next_choice="Enter choice (1-3): "

    if "%next_choice%"=="1" (
        echo Updating automation configuration...
        REM Update config file to point to new version
        powershell -Command "(Get-Content q2_automation_config.ini) -replace 'notebook_path = .*', 'notebook_path = code/%TODAY%%NEXT_LETTER%_Build.ipynb' | Set-Content q2_automation_config.ini"
        echo ✓ Automation updated to use new version
    )

    if "%next_choice%"=="2" (
        echo Opening new version in VS Code...
        code "%TARGET%"
    )

) else (
    echo ✗ ERROR: Failed to create new version
)

echo.
echo ========================================
echo VERSIONING COMPLETE
echo ========================================
echo.
echo New version: %TODAY%%NEXT_LETTER%_Build.ipynb
echo.
pause