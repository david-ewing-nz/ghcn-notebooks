@echo off
REM Automated Git Monitor for Cross-Environment Diagnostics
REM Monitors for new test results and triggers automated analysis

echo Starting automated Git monitoring...
echo Monitoring for new test result pushes from PySpark environment

:monitor_loop
    echo [%date% %time%] Checking for new changes...
    
    REM Check if there are new commits to pull
    git fetch origin main >nul 2>&1
    
    REM Check if we're behind origin
    for /f %%i in ('git rev-list HEAD..origin/main --count') do set BEHIND=%%i
    
    if %BEHIND% gtr 0 (
        echo [%date% %time%] New changes detected! Pulling updates...
        
        REM Pull the changes
        git pull origin main
        
        REM Check for new test result notebooks
        if exist "code\20250916E_Build.ipynb" (
            echo [%date% %time%] E version detected - triggering analysis...
            call auto_analyze_e.bat
        )
        
        if exist "code\20250916F_Build.ipynb" (
            echo [%date% %time%] F version detected - triggering analysis...
            call auto_analyze_f.bat
        )
        
        if exist "code\20250916G_Build.ipynb" (
            echo [%date% %time%] G version detected - triggering analysis...
            call auto_analyze_g.bat
        )
    ) else (
        echo [%date% %time%] No new changes detected
    )
    
    REM Wait 30 seconds before next check
    timeout /t 30 /nobreak >nul
    
goto monitor_loop