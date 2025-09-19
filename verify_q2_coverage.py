#!/usr/bin/env python3
"""
Automated Q2 Coverage Verifier
Checks that all Q2-related cells are present and prints their content for review.
"""
import json
from pathlib import Path


def verify_q2_coverage(notebook_path):
    if not Path(notebook_path).exists():
        print(f"❌ Notebook not found: {notebook_path}")
        return False
    with open(notebook_path, "r", encoding="utf-8") as f:
        nb = json.load(f)
    cells = nb["cells"]
    q2_cells = []
    for i, cell in enumerate(cells):
        if cell["cell_type"] == "code":
            source = "".join(cell["source"])
            if "Q2" in source:
                q2_cells.append((i + 1, source))
    print(f"Q2 cells found: {len(q2_cells)}")
    for cell_num, content in q2_cells:
        print(f"\n--- Q2 CELL {cell_num} ---")
        print(content[:1000])
        if len(content) > 1000:
            print("... (truncated)")
    if len(q2_cells) == 0:
        print("❌ No Q2 cells found!")
        return False
    print("\n✅ Q2 coverage check complete.")
    return True


if __name__ == "__main__":
    verify_q2_coverage("code/20250918A_Build.ipynb")
