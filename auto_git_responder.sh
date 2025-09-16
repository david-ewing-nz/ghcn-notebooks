#!/bin/bash
# Auto-Git Responder - Automatically handles PySpark pushes

echo "=== Auto-Git Responder Started ==="
echo "Monitoring for PySpark test results..."
echo "Will automatically pull and analyze when detected"
echo

cd /d d:\github\ghcn-notebooks 2>/dev/null || cd d:/github/ghcn-notebooks

# Store initial commit hash
LAST_COMMIT=$(git rev-parse HEAD)

while true; do
    # Fetch updates silently
    git fetch >/dev/null 2>&1
    
    # Check current vs remote
    CURRENT_COMMIT=$(git rev-parse HEAD)
    REMOTE_COMMIT=$(git rev-parse origin/main)
    
    if [ "$CURRENT_COMMIT" != "$REMOTE_COMMIT" ]; then
        echo
        echo "=========================================="
        echo "🚨 PYSPARK PUSH DETECTED!"
        echo "=========================================="
        echo "Timestamp: $(date)"
        
        # Pull the changes
        echo "📥 Pulling changes..."
        git pull
        
        echo
        echo "📊 RESULTS ANALYSIS:"
        echo "=========================================="
        
        # Get commit details
        echo "📝 Latest Commit:"
        git log --oneline -1
        echo
        
        # Check for test files and analyze
        NEW_FILES=$(git diff --name-only $LAST_COMMIT HEAD)
        echo "📁 Files changed:"
        echo "$NEW_FILES"
        echo
        
        # Specific analysis for our test files
        if echo "$NEW_FILES" | grep -q "20250916E_Build.ipynb"; then
            echo "✅ TIER 1 COMPLETE: Sample Data Diagnostics"
            echo "   📊 Ready for performance analysis"
        fi
        
        if echo "$NEW_FILES" | grep -q "20250916F_Build.ipynb"; then
            echo "✅ TIER 2 COMPLETE: Filtered Real Data Diagnostics"  
            echo "   📊 Ready for scaling analysis"
        fi
        
        if echo "$NEW_FILES" | grep -q "20250916G_Build.ipynb"; then
            echo "✅ TIER 3 COMPLETE: Full Diagnostic"
            echo "   📊 Ready for final validation"
        fi
        
        echo
        echo "🎯 AUTO-ANALYSIS COMPLETE"
        echo "=========================================="
        echo
        
        # Update last commit
        LAST_COMMIT=$REMOTE_COMMIT
        
        # Optional: Trigger additional analysis here
        echo "🔄 Ready for detailed analysis..."
        echo
    fi
    
    # Wait 15 seconds before next check
    sleep 15
done