#!/usr/bin/env python3
"""
Project Status Summary for AI Agent Continuity
Run this script to get immediate understanding of current project state
"""

import json
import os
from datetime import datetime
from pathlib import Path


def check_file_exists(filepath, description):
    """Check if file exists and return status"""
    exists = Path(filepath).exists()
    status = "✅" if exists else "❌"
    print(f"{status} {description}: {filepath}")
    return exists


def analyze_notebook(filepath):
    """Analyze a notebook and return key information"""
    if not Path(filepath).exists():
        return None

    with open(filepath, "r", encoding="utf-8") as f:
        nb = json.load(f)

    cells = nb["cells"]
    code_cells = [cell for cell in cells if cell["cell_type"] == "code"]

    # Check for core cells
    imports_found = helpers_found = variables_found = False
    q2_cells = 0

    for cell in code_cells:
        source = "".join(cell["source"])
        if "from IPython.display" in source and "from math" in source:
            imports_found = True
        if "HELPER / DIAGNOSTIC FUNCTIONS" in source:
            helpers_found = True
        if "SECTION 1: ENVIRONMENT SETUP" in source:
            variables_found = True
        if "Q2" in source:
            q2_cells += 1

    return {
        "total_cells": len(cells),
        "code_cells": len(code_cells),
        "imports": imports_found,
        "helpers": helpers_found,
        "variables": variables_found,
        "q2_cells": q2_cells,
    }


def main():
    print("🤖 AI AGENT CONTINUITY STATUS")
    print("=" * 50)
    print(f"Report Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print()

    # Check critical files
    print("📁 CRITICAL FILES STATUS:")
    critical_files = [
        ("code/20250918A_Build.ipynb", "Current Working Notebook"),
        ("code/20250916D_Build.ipynb", "Reference Notebook"),
        ("code/20250907_GOOD_Processing.ipynb", "GOOD Reference (archived)"),
        ("automate_cell_addition.py", "Cell Addition Automation"),
        ("notebook_cell_manager.py", "Advanced Cell Manager"),
        ("auto_git_monitor_enhanced.bat", "Git Automation"),
        ("start_full_automation.bat", "Master Automation"),
        ("AUTOMATION_README.md", "Automation Documentation"),
        ("AI_AGENT_CONTINUITY_GUIDE.md", "This Continuity Guide"),
    ]

    all_critical_present = True
    for filepath, description in critical_files:
        if not check_file_exists(filepath, description):
            all_critical_present = False

    print()

    # Analyze current working notebook
    print("📊 CURRENT NOTEBOOK ANALYSIS:")
    current_nb = "code/20250918A_Build.ipynb"
    analysis = analyze_notebook(current_nb)

    if analysis:
        print(f"✅ Notebook: {current_nb}")
        print(f"   Total cells: {analysis['total_cells']}")
        print(f"   Code cells: {analysis['code_cells']}")
        print(
            f"   Core cells present: {sum([analysis['imports'], analysis['helpers'], analysis['variables']])}/3"
        )
        print(f"   Q2 cells: {analysis['q2_cells']}")
        print(
            f"   Ready for work: {'✅' if all([analysis['imports'], analysis['helpers'], analysis['variables']]) else '❌'}"
        )
    else:
        print(f"❌ Could not analyze {current_nb}")

    print()

    # Check automation systems
    print("⚙️ AUTOMATION SYSTEMS STATUS:")
    automation_scripts = [
        "auto_add_cells.bat",
        "quick_verify.bat",
        "setup_auto_cell_addition.bat",
        "full_auto_cell_addition.bat",
    ]

    automation_ready = True
    for script in automation_scripts:
        if not check_file_exists(script, f"Automation: {script}"):
            automation_ready = False

    print()

    # Overall status
    print("🎯 OVERALL PROJECT STATUS:")
    print(
        f"Critical files: {'✅ All Present' if all_critical_present else '❌ Some Missing'}"
    )
    print(
        f"Current notebook: {'✅ Ready' if analysis and all([analysis['imports'], analysis['helpers'], analysis['variables']]) else '❌ Issues'}"
    )
    print(
        f"Automation systems: {'✅ Ready' if automation_ready else '❌ Some Missing'}"
    )
    print(
        f"Q2 coverage: {'✅ Present' if analysis and analysis['q2_cells'] > 0 else '❌ Missing'}"
    )

    print()
    print("📋 NEXT STEPS FOR NEW AGENT:")
    print("1. Read AI_AGENT_CONTINUITY_GUIDE.md")
    print("2. Run quick_verify.bat to confirm status")
    print("3. Read AUTOMATION_README.md for system details")
    print("4. Continue with Q2 analysis in 18A notebook")
    print("5. Use existing automation scripts, don't rebuild")

    print()
    print("🚨 REMEMBER:")
    print("- DO NOT modify GOOD notebook")
    print("- DO NOT delete automation scripts")
    print("- ALWAYS backup before changes")
    print("- Use automation instead of manual processes")


if __name__ == "__main__":
    main()
