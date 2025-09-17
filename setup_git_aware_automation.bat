@echo off
echo ========================================
echo GIT-AWARE Q2 AUTOMATION SETUP
echo ========================================
echo.
echo This will set up automation that triggers on git events:
echo.
echo [1] Git Status Monitor (checks for local changes)
echo [2] Git Push Monitor (checks for remote pushes)
echo [3] Post-Commit Hook (runs after every commit)
echo [4] Combined Setup (all of the above)
echo [5] Cancel
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo Setting up git status monitoring...
    schtasks /create /tn "Q2_Git_Status_Monitor" /tr "\"%~dp0git_aware_q2_automation.bat\"" /sc minute /mo 5 /rl highest /f
    echo ✓ Git status monitor created (runs every 5 minutes)
)

if "%choice%"=="2" (
    echo Setting up git push monitoring...
    schtasks /create /tn "Q2_Git_Push_Monitor" /tr "\"%~dp0git_aware_q2_automation.bat\"" /sc minute /mo 10 /rl highest /f
    echo ✓ Git push monitor created (runs every 10 minutes)
)

if "%choice%"=="3" (
    echo Setting up post-commit hook...
    if exist ".git\hooks" (
        copy "post-commit-hook.sh" ".git\hooks\post-commit"
        echo ✓ Post-commit hook installed
        echo Note: You may need to make the hook executable on Linux/Mac
    ) else (
        echo ✗ .git\hooks directory not found
        echo Make sure you're in a git repository
    )
)

if "%choice%"=="4" (
    echo Setting up combined git-aware automation...
    schtasks /create /tn "Q2_Git_Combined" /tr "\"%~dp0git_aware_q2_automation.bat\"" /sc minute /mo 5 /rl highest /f

    if exist ".git\hooks" (
        copy "post-commit-hook.sh" ".git\hooks\post-commit"
        echo ✓ Combined setup complete
        echo   - Status monitoring every 5 minutes
        echo   - Post-commit hook installed
    ) else (
        echo ✓ Status monitoring set up (post-commit hook requires git repo)
    )
)

if "%choice%"=="5" (
    echo Cancelled.
    pause
    exit
)

echo.
echo ========================================
echo GIT-AWARE SETUP COMPLETE
echo ========================================
echo.
echo Your Q2 analysis will now trigger on git events!
echo.
echo To modify schedules:
echo schtasks /change /tn "Q2_Git_Combined" /mo [minutes]
echo.
echo To remove:
echo schtasks /delete /tn "Q2_Git_*"
echo.
pause