@echo off
REM Enhanced Automated Git Monitor for Cross-Environment Diagnostics
REM Monitors for new test results and triggers automated analysis with robust error handling

echo Starting enhanced automated Git monitoring...
echo Monitoring for new test result pushes from PySpark environment

:monitor_loop
    echo [%date% %time%] Checking for new changes...

    REM Check if there are new commits to pull
    git fetch origin main >nul 2>&1

    REM Check if we're behind origin
    for /f %%i in ('git rev-list HEAD..origin/main --count') do set BEHIND=%%i

    if %BEHIND% gtr 0 (
        echo [%date% %time%] New changes detected! Processing updates...

        REM Pull the changes
        git pull origin main

        REM Check for new test result notebooks and process them
        if exist "code\20250916E_Build.ipynb" (
            echo [%date% %time%] Processing E version...
            call auto_process_e.bat
        )

        if exist "code\20250916F_Build.ipynb" (
            echo [%date% %time%] Processing F version...
            call auto_process_f.bat
        )

        if exist "code\20250916G_Build.ipynb" (
            echo [%date% %time%] Processing G version...
            call auto_process_g.bat
        )

        echo [%date% %time%] Processing complete!
    ) else (
        echo [%date% %time%] No new changes detected
    )

    REM Wait 60 seconds before next check (increased for stability)
    timeout /t 60 /nobreak >nul

goto monitor_loop