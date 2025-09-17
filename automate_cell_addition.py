#!/usr/bin/env python3
"""
Automate adding the three core cells (imports, helper functions, variables) to any notebook.

This script extracts the three essential cells from a reference notebook and adds them
to a target notebook if they're missing or need updating.

Usage:
    python automate_cell_addition.py <reference_notebook> <target_notebook>

Example:
    python automate_cell_addition.py code/20250916D_Build.ipynb code/20250918A_Build.ipynb
"""

import json
import sys
from pathlib import Path
from typing import Any, Dict, List


def load_notebook(filepath: str) -> Dict[str, Any]:
    """Load a Jupyter notebook from file."""
    with open(filepath, "r", encoding="utf-8") as f:
        return json.load(f)


def save_notebook(notebook: Dict[str, Any], filepath: str) -> None:
    """Save a Jupyter notebook to file."""
    with open(filepath, "w", encoding="utf-8") as f:
        json.dump(notebook, f, indent=1, ensure_ascii=False)


def extract_core_cells(reference_nb: Dict[str, Any]) -> Dict[str, List[Dict[str, Any]]]:
    """Extract the three core cells from the reference notebook."""
    cells = reference_nb["cells"]

    core_cells = {"imports": None, "helper_functions": None, "variables": None}

    # Find imports cell (Cell 5 in reference)
    if len(cells) > 4 and cells[4]["cell_type"] == "code":
        imports_source = "".join(cells[4]["source"])
        if "from IPython.display" in imports_source and "from math" in imports_source:
            core_cells["imports"] = cells[4].copy()

    # Find helper functions cell (Cell 6 in reference)
    if len(cells) > 5 and cells[5]["cell_type"] == "code":
        helpers_source = "".join(cells[5]["source"])
        if "HELPER / DIAGNOSTIC FUNCTIONS" in helpers_source:
            core_cells["helper_functions"] = cells[5].copy()

    # Find variables cell (Cell 8 in reference)
    if len(cells) > 7 and cells[7]["cell_type"] == "code":
        vars_source = "".join(cells[7]["source"])
        if "SECTION 1: ENVIRONMENT SETUP" in vars_source:
            core_cells["variables"] = cells[7].copy()

    return core_cells


def find_existing_core_cells(target_nb: Dict[str, Any]) -> Dict[str, int]:
    """Find existing core cells in the target notebook and return their indices."""
    cells = target_nb["cells"]
    existing = {}

    for i, cell in enumerate(cells):
        if cell["cell_type"] == "code":
            source = "".join(cell["source"])

            if (
                "from IPython.display" in source
                and "from math" in source
                and "imports" not in existing
            ):
                existing["imports"] = i
            elif (
                "HELPER / DIAGNOSTIC FUNCTIONS" in source
                and "helper_functions" not in existing
            ):
                existing["helper_functions"] = i
            elif (
                "SECTION 1: ENVIRONMENT SETUP" in source and "variables" not in existing
            ):
                existing["variables"] = i

    return existing


def add_missing_cells(
    target_nb: Dict[str, Any], core_cells: Dict[str, List[Dict[str, Any]]]
) -> bool:
    """Add missing core cells to the target notebook. Returns True if changes were made."""
    existing = find_existing_core_cells(target_nb)
    cells = target_nb["cells"]
    changes_made = False

    # Define the desired order and positions
    desired_order = [
        ("imports", 4),  # Should be at position 4 (after the spark setup cells)
        ("helper_functions", 5),  # Should be at position 5
        ("variables", 7),  # Should be at position 7 (after the empty cell)
    ]

    for cell_type, desired_pos in desired_order:
        if cell_type not in existing and core_cells[cell_type] is not None:
            print(f"Adding missing {cell_type} cell at position {desired_pos}")

            # Insert the cell at the desired position
            if desired_pos >= len(cells):
                cells.append(core_cells[cell_type])
            else:
                cells.insert(desired_pos, core_cells[cell_type])

            changes_made = True

            # Update existing indices for subsequent insertions
            for key in existing:
                if existing[key] >= desired_pos:
                    existing[key] += 1

        elif cell_type in existing:
            current_pos = existing[cell_type]
            if current_pos != desired_pos:
                print(
                    f"Moving {cell_type} cell from position {current_pos} to {desired_pos}"
                )

                # Remove from current position
                cell = cells.pop(current_pos)

                # Insert at desired position
                if desired_pos >= len(cells):
                    cells.append(cell)
                else:
                    cells.insert(desired_pos, cell)

                changes_made = True

                # Update existing indices
                existing[cell_type] = desired_pos
                for key in existing:
                    if key != cell_type and existing[key] > current_pos:
                        existing[key] -= 1
                    if existing[key] >= desired_pos:
                        existing[key] += 1

    return changes_made


def main():
    if len(sys.argv) != 3:
        print(
            "Usage: python automate_cell_addition.py <reference_notebook> <target_notebook>"
        )
        print(
            "Example: python automate_cell_addition.py code/20250916D_Build.ipynb code/20250918A_Build.ipynb"
        )
        sys.exit(1)

    reference_path = sys.argv[1]
    target_path = sys.argv[2]

    # Check if files exist
    if not Path(reference_path).exists():
        print(f"Error: Reference notebook '{reference_path}' not found.")
        sys.exit(1)

    if not Path(target_path).exists():
        print(f"Error: Target notebook '{target_path}' not found.")
        sys.exit(1)

    print(f"Processing notebooks...")
    print(f"Reference: {reference_path}")
    print(f"Target: {target_path}")
    print()

    # Load notebooks
    try:
        reference_nb = load_notebook(reference_path)
        target_nb = load_notebook(target_path)
    except Exception as e:
        print(f"Error loading notebooks: {e}")
        sys.exit(1)

    # Extract core cells from reference
    print("Extracting core cells from reference notebook...")
    core_cells = extract_core_cells(reference_nb)

    found_cells = [k for k, v in core_cells.items() if v is not None]
    print(f"Found core cells: {', '.join(found_cells)}")

    if not found_cells:
        print("Warning: No core cells found in reference notebook!")
        sys.exit(1)

    # Check existing cells in target
    existing = find_existing_core_cells(target_nb)
    print(f"Existing core cells in target: {list(existing.keys())}")

    # Add missing cells
    print("\nAdding/updating core cells...")
    changes_made = add_missing_cells(target_nb, core_cells)

    if changes_made:
        # Save the updated notebook
        try:
            save_notebook(target_nb, target_path)
            print(f"\n✅ Successfully updated {target_path}")
            print("Core cells have been added/positioned correctly.")
        except Exception as e:
            print(f"Error saving notebook: {e}")
            sys.exit(1)
    else:
        print(
            "\n✅ No changes needed. All core cells are already present and correctly positioned."
        )

    print("\nAutomation complete!")


if __name__ == "__main__":
    main()
