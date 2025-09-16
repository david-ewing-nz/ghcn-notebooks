#!/bin/bash
# Auto-monitor for PySpark test results

echo "=== Auto-Monitor: PySpark Test Results Watcher ==="
echo "Monitoring for E/F/G version pushes..."
echo "Press Ctrl+C to stop monitoring"
echo

cd /d d:\github\ghcn-notebooks 2>/dev/null || cd d:/github/ghcn-notebooks

LAST_COMMIT=$(git rev-parse HEAD)

while true; do
    echo "[$(date '+%H:%M:%S')] Checking for updates..."
    
    # Fetch latest changes
    git fetch >/dev/null 2>&1
    
    # Check if we're behind remote
    CURRENT_COMMIT=$(git rev-parse HEAD)
    REMOTE_COMMIT=$(git rev-parse origin/main)
    
    if [ "$CURRENT_COMMIT" != "$REMOTE_COMMIT" ]; then
        echo
        echo "🔥 NEW PYSPARK RESULTS DETECTED!"
        echo "📥 Pulling changes..."
        git pull
        
        echo
        echo "📊 NEW COMMIT DETAILS:"
        git log --oneline -1
        
        echo
        echo "📁 CHECKING FOR TEST RESULTS:"
        
        # Check for E version
        if [ -f "code/20250916E_Build.ipynb" ]; then
            echo "✅ TIER 1: 20250916E_Build.ipynb found!"
            echo "   📈 Sample data diagnostics results available"
        fi
        
        # Check for F version  
        if [ -f "code/20250916F_Build.ipynb" ]; then
            echo "✅ TIER 2: 20250916F_Build.ipynb found!"
            echo "   📈 Filtered real data diagnostics results available"
        fi
        
        # Check for G version
        if [ -f "code/20250916G_Build.ipynb" ]; then
            echo "✅ TIER 3: 20250916G_Build.ipynb found!"
            echo "   📈 Full diagnostic results available"
        fi
        
        echo
        echo "🎯 READY FOR ANALYSIS!"
        echo "New test results are downloaded and ready for review."
        echo
        echo "Press Enter to continue monitoring, or Ctrl+C to exit..."
        read -r || true
        
        LAST_COMMIT=$REMOTE_COMMIT
    fi
    
    sleep 15
done