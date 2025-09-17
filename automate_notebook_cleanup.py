#!/usr/bin/env python3
"""
Automated notebook cleanup script for 20250916D_Build.ipynb
Removes duplicate cells and test/debugging content
"""

import json
import sys
from pathlib import Path


def clean_notebook(notebook_path):
    """Clean the notebook by removing duplicates and test cells"""

    print(f"Loading notebook: {notebook_path}")

    # Load the notebook
    with open(notebook_path, "r", encoding="utf-8") as f:
        nb = json.load(f)

    print(f"Original cell count: {len(nb['cells'])}")

    # Track cells to keep
    cells_to_keep = []
    seen_q4b58 = False
    removed_count = 0

    for i, cell in enumerate(nb["cells"]):
        should_keep = True
        reason = ""

        # Check if it's a code cell
        if cell.get("cell_type") == "code":
            source_text = "".join(cell.get("source", []))

            # Remove duplicate Q4(b)58 cells (keep only the first one)
            if "Process Answer: Q4(b)58" in source_text:
                if seen_q4b58:
                    should_keep = False
                    reason = "Duplicate Q4(b)58 cell"
                else:
                    seen_q4b58 = True
                    reason = "First Q4(b)58 cell (keeping)"

            # Remove test/debugging cells
            elif any(
                test_pattern in source_text
                for test_pattern in [
                    "Tier 1 sample data test",
                    "Tier 2 sample data test",
                    "Tier 3 sample data test",
                    "diagnostic testing strategy",
                    "Test the probe_universe function",
                    "SECTION 2: DATA INGESTION",
                    "wildcard daily data loading",
                    "*.csv.gz",
                ]
            ):
                should_keep = False
                reason = "Test/debugging cell"

        if should_keep:
            cells_to_keep.append(cell)
            if reason:
                print(f"Keeping cell {i+1}: {reason}")
        else:
            removed_count += 1
            print(f"Removing cell {i+1}: {reason}")

    # Update the notebook
    nb["cells"] = cells_to_keep

    # Save the cleaned notebook
    with open(notebook_path, "w", encoding="utf-8") as f:
        json.dump(nb, f, indent=1, ensure_ascii=False)

    print(f"Cleanup complete:")
    print(f"- Original cells: {len(nb['cells']) + removed_count}")
    print(f"- Cells kept: {len(nb['cells'])}")
    print(f"- Cells removed: {removed_count}")
    print(f"- Q4(b)58 cells remaining: {1 if seen_q4b58 else 0}")

    return len(nb["cells"]), removed_count


if __name__ == "__main__":
    notebook_path = r"d:\github\ghcn-notebooks\code\20250916D_Build.ipynb"

    if not Path(notebook_path).exists():
        print(f"Error: Notebook not found at {notebook_path}")
        sys.exit(1)

    try:
        kept, removed = clean_notebook(notebook_path)
        print(
            f"Successfully cleaned notebook: "
            f"{kept} cells kept, {removed} cells removed"
        )
    except Exception as e:
        print(f"Error cleaning notebook: {e}")
        sys.exit(1)
