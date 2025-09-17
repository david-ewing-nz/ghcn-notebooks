@echo off
REM Automated Diagnostic Results Monitor
REM Monitors Build files for specific diagnostic results and notifies when found

echo [%date% %time%] Starting automated diagnostic results monitoring...

:monitor_loop
    echo [%date% %time%] Checking for diagnostic results in Build files...

    REM Check E Build file
    if exist "code\20250916E_Build.ipynb" (
        echo [%date% %time%] Checking E Build file for results...
        python auto_extract_diagnostics.py "code\20250916E_Build.ipynb" "E"
        if %errorlevel% equ 0 (
            echo [%date% %time%] SUCCESS: Diagnostic results found in E Build file!
            REM Send notification
            python send_notification.py "E" "results\E_analysis_summary.txt"
            echo Diagnostic results detected in E Build file >> diagnostic_alert.log
            echo [%date% %time%] E Build results detected >> diagnostic_alert.log
        )
    )

    REM Check F Build file
    if exist "code\20250916F_Build.ipynb" (
        echo [%date% %time%] Checking F Build file for results...
        python auto_extract_diagnostics.py "code\20250916F_Build.ipynb" "F"
        if %errorlevel% equ 0 (
            echo [%date% %time%] SUCCESS: Diagnostic results found in F Build file!
            python send_notification.py "F" "results\F_analysis_summary.txt"
            echo Diagnostic results detected in F Build file >> diagnostic_alert.log
            echo [%date% %time%] F Build results detected >> diagnostic_alert.log
        )
    )

    REM Check G Build file
    if exist "code\20250916G_Build.ipynb" (
        echo [%date% %time%] Checking G Build file for results...
        python auto_extract_diagnostics.py "code\20250916G_Build.ipynb" "G"
        if %errorlevel% equ 0 (
            echo [%date% %time%] SUCCESS: Diagnostic results found in G Build file!
            python send_notification.py "G" "results\G_analysis_summary.txt"
            echo Diagnostic results detected in G Build file >> diagnostic_alert.log
            echo [%date% %time%] G Build results detected >> diagnostic_alert.log
        )
    )

    REM Check for any new Build files with pattern
    for %%f in (code\20250916*_Build.ipynb) do (
        echo [%date% %time%] Found Build file: %%f
        REM Extract version from filename (e.g., E, F, G from 20250916E_Build.ipynb)
        for /f "tokens=1 delims=." %%v in ("%%~nf") do (
            set "version=%%v"
            setlocal enabledelayedexpansion
            set "version=!version:~-1!"
            python auto_extract_diagnostics.py "%%f" "!version!"
            if !errorlevel! equ 0 (
                echo [%date% %time%] SUCCESS: Diagnostic results found in !version! Build file!
                python send_notification.py "!version!" "results\!version!_analysis_summary.txt"
                echo Diagnostic results detected in !version! Build file >> diagnostic_alert.log
                echo [%date% %time%] !version! Build results detected >> diagnostic_alert.log
            )
            endlocal
        )
    )

    REM Check if alert log has new entries and notify
    if exist "diagnostic_alert.log" (
        for /f %%i in ('type diagnostic_alert.log ^| find /c "Diagnostic results detected"') do set ALERT_COUNT=%%i
        if !ALERT_COUNT! gtr 0 (
            echo [%date% %time%] ALERT: New diagnostic results detected!
            echo Check diagnostic_alert.log for details
            REM You can add email notification here, e.g.:
            REM powershell -command "Send-MailMessage -To 'your-email@example.com' -Subject 'GHCN Diagnostic Results Found' -Body 'Check diagnostic_alert.log' -SmtpServer 'smtp.example.com'"
        )
    )

    echo [%date% %time%] Monitoring cycle complete. Waiting 60 seconds...
    timeout /t 60 /nobreak >nul

goto monitor_loop