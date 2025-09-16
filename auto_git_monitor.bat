@echo off
REM Auto-Git Monitor - Runs automatically without user interaction
cd /d d:\github\ghcn-notebooks

:start_monitor
echo [%date% %time%] Auto-monitoring for PySpark results...

REM Check for updates every 30 seconds
:check_updates
git fetch >nul 2>&1

REM Check if we're behind remote
git status | findstr "behind" >nul
if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo 🔥 PYSPARK RESULTS DETECTED!
    echo ========================================
    echo [%date% %time%] Pulling new test results...
    
    REM Pull the changes
    git pull
    
    echo.
    echo 📊 NEW RESULTS ANALYSIS:
    echo ========================================
    
    REM Check for specific test files
    if exist "code\20250916E_Build.ipynb" (
        echo ✅ TIER 1: 20250916E_Build.ipynb detected
        echo    📈 Sample data diagnostics completed
    )
    
    if exist "code\20250916F_Build.ipynb" (
        echo ✅ TIER 2: 20250916F_Build.ipynb detected  
        echo    📈 Filtered real data diagnostics completed
    )
    
    if exist "code\20250916G_Build.ipynb" (
        echo ✅ TIER 3: 20250916G_Build.ipynb detected
        echo    📈 Full diagnostic completed
    )
    
    echo.
    echo 📝 LATEST COMMIT:
    git log --oneline -1
    echo ========================================
    
    REM Optional: Send notification or trigger analysis
    echo 🎯 Results ready for analysis!
    echo.
)

REM Wait 30 seconds before next check
timeout /t 30 /nobreak >nul
goto check_updates

REM This will run indefinitely until manually stopped
pause