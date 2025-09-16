@echo off
REM Final Report Generator
REM Compiles all diagnostic results into comprehensive summary

echo [%date% %time%] Generating final diagnostic report...

REM Create final report
echo ======================================== > results\final_report.txt
echo CROSS-ENVIRONMENT DIAGNOSTICS FINAL REPORT >> results\final_report.txt
echo ======================================== >> results\final_report.txt
echo Generated: %date% %time% >> results\final_report.txt
echo. >> results\final_report.txt

echo EXECUTIVE SUMMARY: >> results\final_report.txt
echo ================= >> results\final_report.txt

REM Check E results
if exist "results\E_analysis_summary.txt" (
    echo E VERSION (Tier 1 - Sample Data): COMPLETED >> results\final_report.txt
    findstr "daily_stations\|stations_stations\|strict_filtering" results\E_analysis_summary.txt >> results\final_report.txt
) else (
    echo E VERSION (Tier 1 - Sample Data): PENDING >> results\final_report.txt
)

echo. >> results\final_report.txt

REM Check F results
if exist "results\F_analysis_summary.txt" (
    echo F VERSION (Tier 2 - Filtered Data): COMPLETED >> results\final_report.txt
    findstr "daily_stations\|stations_stations\|strict_filtering" results\F_analysis_summary.txt >> results\final_report.txt
) else (
    echo F VERSION (Tier 2 - Filtered Data): PENDING >> results\final_report.txt
)

echo. >> results\final_report.txt

REM Check G results
if exist "results\G_analysis_summary.txt" (
    echo G VERSION (Tier 3 - Full Data): COMPLETED >> results\final_report.txt
    findstr "daily_stations\|stations_stations\|strict_filtering" results\G_analysis_summary.txt >> results\final_report.txt
) else (
    echo G VERSION (Tier 3 - Full Data): PENDING >> results\final_report.txt
)

echo. >> results\final_report.txt
echo DETAILED RESULTS: >> results\final_report.txt
echo ================ >> results\final_report.txt

REM Append detailed results
if exist "results\E_analysis_summary.txt" (
    echo. >> results\final_report.txt
    echo E VERSION DETAILS: >> results\final_report.txt
    echo ------------------ >> results\final_report.txt
    type results\E_analysis_summary.txt >> results\final_report.txt
)

if exist "results\F_analysis_summary.txt" (
    echo. >> results\final_report.txt
    echo F VERSION DETAILS: >> results\final_report.txt
    echo ------------------ >> results\final_report.txt
    type results\F_analysis_summary.txt >> results\final_report.txt
)

if exist "results\G_analysis_summary.txt" (
    echo. >> results\final_report.txt
    echo G VERSION DETAILS: >> results\final_report.txt
    echo ------------------ >> results\final_report.txt
    type results\G_analysis_summary.txt >> results\final_report.txt
)

echo. >> results\final_report.txt
echo ======================================== >> results\final_report.txt
echo REPORT GENERATION COMPLETE >> results\final_report.txt
echo ======================================== >> results\final_report.txt

echo [%date% %time%] Final report generated successfully!
echo [%date% %time%] Report saved to results\final_report.txt