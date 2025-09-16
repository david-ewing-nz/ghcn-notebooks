@echo off
echo === GitHub Sync Monitor ===
echo Checking for updates from PySpark environment...
cd /d d:\github\ghcn-notebooks
git fetch
git status
echo.
echo If there are changes, run: git pull
echo.
pause