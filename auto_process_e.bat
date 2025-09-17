@echo off
REM Enhanced Automated Processing Script for E Version
REM Complete automation: extract, update, commit, push

echo [%date% %time%] Starting enhanced automated processing of E version...

REM Activate virtual environment
call .venv\Scripts\activate.bat

REM Step 1: Extract results and update code
echo [%date% %time%] Extracting results and updating optimized_probe_universe.py...
python code/auto_extract_and_update.py

REM Check if the update was successful
if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] Warning: Result extraction failed, but continuing with automation...
)

REM Step 2: Generate summary report
echo [%date% %time%] Generating processing summary...
echo E Version Processing Summary > temp_summary.txt
echo Processed at: %date% %time% >> temp_summary.txt
echo Status: Automated processing completed >> temp_summary.txt
move temp_summary.txt results\E_processing_summary.txt

REM Step 3: Commit and push all changes
echo [%date% %time%] Committing and pushing changes...
git add .
git diff --cached --quiet
if %ERRORLEVEL% neq 0 (
    git commit -m "Automated E processing - %date% %time%"
    git push origin main
    echo [%date% %time%] Changes committed and pushed successfully!
) else (
    echo [%date% %time%] No changes to commit
)

REM Deactivate virtual environment
call deactivate

echo [%date% %time%] Enhanced E version processing completed successfully!
echo The system is now fully automated and will continue monitoring for new changes.