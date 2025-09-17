#!/bin/bash
# Git post-commit hook for Q2 analysis
# Place this file in .git/hooks/post-commit

echo "Post-commit hook triggered - running Q2 analysis..."

# Navigate to the project root (assuming hook is in .git/hooks/)
cd "$(git rev-parse --show-toplevel)"

# Run the analysis
python automate_q2_analysis.py > q2_post_commit_analysis.log 2>&1

if [ $? -eq 0 ]; then
    echo "Q2 analysis completed successfully after commit"
    # Optional: Send notification
    python send_notification.py "Q2 Analysis Complete" "Post-commit analysis finished. Check q2_coverage_report.txt"
else
    echo "Q2 analysis failed after commit - check q2_post_commit_analysis.log"
fi

echo "Post-commit analysis complete"