@echo off
REM Master Automation Orchestrator for Cross-Environment Diagnostics
REM Coordinates the entire automated workflow

echo ========================================
echo CROSS-ENVIRONMENT DIAGNOSTICS AUTOMATION
echo ========================================
echo [%date% %time%] Starting master automation orchestrator...

REM Create results directory
if not exist "results" mkdir results

REM Start the enhanced Git monitor in background
echo [%date% %time%] Starting Git monitoring service...
start /B auto_git_monitor_enhanced.bat

REM Main orchestration loop
:orchestrate_loop
    echo [%date% %time%] Checking system status...
    
    REM Check if any analysis is currently running
    tasklist /FI "IMAGENAME eq jupyter.exe" 2>NUL | find /I /N "jupyter.exe">NUL
    if %ERRORLEVEL% EQU 0 (
        echo [%date% %time%] Jupyter analysis in progress...
    ) else (
        echo [%date% %time%] System ready for new analysis
    )
    
    REM Check for completed results and generate summary
    if exist "results\E_analysis_summary.txt" (
        if exist "results\F_analysis_summary.txt" (
            if exist "results\G_analysis_summary.txt" (
                echo [%date% %time%] All tiers completed! Generating final report...
                call generate_final_report.bat
                goto :complete
            )
        )
    )
    
    REM Wait 60 seconds before next status check
    echo [%date% %time%] Waiting for next status check...
    timeout /t 60 /nobreak >nul
    
goto orchestrate_loop

:complete
echo [%date% %time%] All diagnostic tiers completed successfully!
echo [%date% %time%] Final report generated in results\final_report.txt
echo [%date% %time%] Automation cycle complete.

REM Keep the orchestrator running for monitoring
echo [%date% %time%] Entering monitoring mode...
:monitor_mode
    timeout /t 300 /nobreak >nul
    echo [%date% %time%] System monitoring active...
goto monitor_mode