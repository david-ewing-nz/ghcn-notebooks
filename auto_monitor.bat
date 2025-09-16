@echo off
echo === Auto-Monitor: Checking for PySpark Test Results ===
cd /d d:\github\ghcn-notebooks

:check_loop
echo [%date% %time%] Checking for updates...
git fetch >nul 2>&1

git status --porcelain | findstr /C:"behind" >nul
if %errorlevel% equ 0 (
    echo.
    echo 🔄 NEW RESULTS DETECTED FROM PYSPARK!
    echo 📥 Pulling latest changes...
    git pull
    echo.
    echo 📊 Analyzing new test results...
    
    REM Check for new E/F/G files
    if exist "code\20250916E_Build.ipynb" (
        echo ✅ Found: 20250916E_Build.ipynb (Tier 1 Results)
        echo 📈 Ready to analyze Tier 1 performance!
    )
    if exist "code\20250916F_Build.ipynb" (
        echo ✅ Found: 20250916F_Build.ipynb (Tier 2 Results)  
        echo 📈 Ready to analyze Tier 2 performance!
    )
    if exist "code\20250916G_Build.ipynb" (
        echo ✅ Found: 20250916G_Build.ipynb (Tier 3 Results)
        echo 📈 Ready to analyze Tier 3 performance!
    )
    
    echo.
    echo 🎯 Analysis complete! Check results above.
    echo Press any key to continue monitoring...
    pause >nul
    goto check_loop
)

timeout /t 30 /nobreak >nul
goto check_loop