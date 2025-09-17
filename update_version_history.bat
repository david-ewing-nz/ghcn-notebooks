@echo off
REM Update version history automatically
cd /d "%~dp0"

if "%~1"=="" (
    echo ERROR: Please provide version name as parameter
    echo Usage: update_version_history.bat VERSION_NAME [DESCRIPTION]
    pause
    exit /b 1
)

set VERSION=%~1
set DESCRIPTION=%~2

REM Get today's date
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
set TODAY=%datetime:~0,8%
set FORMATTED_DATE=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%

echo [%DATE% %TIME%] Updating version history for %VERSION% >> version_update.log

REM Create backup of current history
copy VERSION_HISTORY.md VERSION_HISTORY.md.backup >nul 2>&1

REM Update the version history using PowerShell
powershell -Command "
$content = Get-Content 'VERSION_HISTORY.md' -Raw
$content = $content -replace '### Today''s Date: \d{4}-\d{2}-\d{2}', '### Today''s Date: %FORMATTED_DATE%'
$content = $content -replace '(### Current Versions:)', ('$1' + '`n- **%VERSION%** - %DESCRIPTION%')
$content | Set-Content 'VERSION_HISTORY.md'
"

if %ERRORLEVEL% EQU 0 (
    echo [%DATE% %TIME%] Version history updated successfully >> version_update.log
) else (
    echo [%DATE% %TIME%] ERROR: Failed to update version history >> version_update.log
    REM Restore backup
    copy VERSION_HISTORY.md.backup VERSION_HISTORY.md >nul 2>&1
)

REM Clean up backup after successful update
timeout /t 5 /nobreak >nul 2>&1
if exist VERSION_HISTORY.md.backup del VERSION_HISTORY.md.backup