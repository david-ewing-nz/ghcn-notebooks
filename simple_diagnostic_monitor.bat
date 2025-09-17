@echo off
REM Simplified Diagnostic Monitor - Just monitors for results
REM Runs continuously and notifies when diagnostic results are found

echo ================================================
echo DIAGNOSTIC RESULTS MONITOR
echo ================================================
echo [%date% %time%] Starting diagnostic monitoring...
echo This will continuously check for diagnostic results in Build files
echo Press Ctrl+C to stop
echo ================================================

:monitor_loop
    echo [%date% %time%] Checking for diagnostic results...

    REM Check E Build file
    if exist "code\20250916E_Build.ipynb" (
        echo [%date% %time%] Checking E Build file...
        python auto_extract_diagnostics.py "code\20250916E_Build.ipynb" "E" >nul 2>&1
        if %errorlevel% equ 0 (
            echo ================================================
            echo [!] SUCCESS: Diagnostic results found in E Build file!
            echo ================================================
            REM Send notification
            python send_notification.py "E" "results\E_analysis_summary.txt"
            echo [%date% %time%] E Build results detected >> diagnostic_alert.log
        )
    )

    REM Check F Build file
    if exist "code\20250916F_Build.ipynb" (
        echo [%date% %time%] Checking F Build file...
        python auto_extract_diagnostics.py "code\20250916F_Build.ipynb" "F" >nul 2>&1
        if %errorlevel% equ 0 (
            echo ================================================
            echo [!] SUCCESS: Diagnostic results found in F Build file!
            echo ================================================
            python send_notification.py "F" "results\F_analysis_summary.txt"
            echo [%date% %time%] F Build results detected >> diagnostic_alert.log
        )
    )

    REM Check G Build file
    if exist "code\20250916G_Build.ipynb" (
        echo [%date% %time%] Checking G Build file...
        python auto_extract_diagnostics.py "code\20250916G_Build.ipynb" "G" >nul 2>&1
        if %errorlevel% equ 0 (
            echo ================================================
            echo [!] SUCCESS: Diagnostic results found in G Build file!
            echo ================================================
            python send_notification.py "G" "results\G_analysis_summary.txt"
            echo [%date% %time%] G Build results detected >> diagnostic_alert.log
        )
    )

    REM Check for any new Build files
    for %%f in (code\20250916*_Build.ipynb) do (
        echo [%date% %time%] Found Build file: %%~nf
        REM Extract version from filename
        for /f "tokens=1 delims=." %%v in ("%%~nf") do (
            setlocal enabledelayedexpansion
            set "version=%%v"
            set "version=!version:~-1!"
            python auto_extract_diagnostics.py "%%f" "!version!" >nul 2>&1
            if !errorlevel! equ 0 (
                echo ================================================
                echo [!] SUCCESS: Diagnostic results found in !version! Build file!
                echo ================================================
                python send_notification.py "!version!" "results\!version!_analysis_summary.txt"
                echo [%date% %time%] !version! Build results detected >> diagnostic_alert.log
            )
            endlocal
        )
    )

    echo [%date% %time%] Check complete. Waiting 30 seconds...
    timeout /t 30 /nobreak >nul

goto monitor_loop