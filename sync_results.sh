#!/bin/bash
# Auto-sync script for cross-environment collaboration

echo "🔄 Checking for updates from PySpark environment..."

# Navigate to project directory
cd /d d:\github\ghcn-notebooks 2>/dev/null || cd d:/github/ghcn-notebooks

# Check for remote changes
echo "📡 Fetching latest changes..."
git fetch

# Check if there are updates
if git status | grep -q "Your branch is behind"; then
    echo "✨ New changes detected from PySpark environment!"
    echo "📥 Pulling changes..."
    git pull

    # Show what changed
    echo "📋 Recent changes:"
    git log --oneline -3

    # Check for new notebook files
    echo "📓 Checking for new test results..."
    ls -la code/20250916*.ipynb 2>/dev/null | tail -5

    echo "✅ Sync complete! Ready to analyze results."
else
    echo "📭 No new changes from PySpark environment."
fi

echo "🔍 Current status:"
git status --short