#!/usr/bin/env python3
"""
Comprehensive Notebook Cell Management System

This system provides automated management of core cells across multiple notebooks,
integrating with the versioning system and providing batch processing capabilities.

Features:
- Add core cells to single or multiple notebooks
- Validate notebook structure
- Backup before modifications
- Integration with versioning system
- Batch processing for multiple notebooks

Usage:
    python notebook_cell_manager.py [command] [options]

Commands:
    add-cells     Add core cells to notebooks
    validate      Validate notebook structure
    backup        Create backups of notebooks
    batch-add     Add cells to multiple notebooks

Examples:
    python notebook_cell_manager.py add-cells --reference code/20250916D_Build.ipynb --target code/20250918A_Build.ipynb
    python notebook_cell_manager.py validate code/20250918A_Build.ipynb
    python notebook_cell_manager.py batch-add --reference code/20250916D_Build.ipynb --pattern "code/202509*Build.ipynb"
"""

import argparse
import glob
import json
import sys
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional


class NotebookCellManager:
    """Manages core cells across Jupyter notebooks."""

    def __init__(self):
        self.core_cell_types = ["imports", "helper_functions", "variables"]

    def load_notebook(self, filepath: str) -> Dict[str, Any]:
        """Load a Jupyter notebook from file."""
        with open(filepath, "r", encoding="utf-8") as f:
            return json.load(f)

    def save_notebook(self, notebook: Dict[str, Any], filepath: str) -> None:
        """Save a Jupyter notebook to file."""
        with open(filepath, "w", encoding="utf-8") as f:
            json.dump(notebook, f, indent=1, ensure_ascii=False)

    def create_backup(self, filepath: str) -> str:
        """Create a backup of the notebook with timestamp."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_path = f"{filepath}.backup_{timestamp}"

        import shutil

        shutil.copy2(filepath, backup_path)

        print(f"Backup created: {backup_path}")
        return backup_path

    def extract_core_cells(
        self, reference_nb: Dict[str, Any]
    ) -> Dict[str, Optional[Dict[str, Any]]]:
        """Extract the three core cells from the reference notebook."""
        cells = reference_nb["cells"]

        core_cells = {"imports": None, "helper_functions": None, "variables": None}

        # Find imports cell (typically Cell 5)
        if len(cells) > 4 and cells[4]["cell_type"] == "code":
            imports_source = "".join(cells[4]["source"])
            if (
                "from IPython.display" in imports_source
                and "from math" in imports_source
            ):
                core_cells["imports"] = cells[4].copy()

        # Find helper functions cell (typically Cell 6)
        if len(cells) > 5 and cells[5]["cell_type"] == "code":
            helpers_source = "".join(cells[5]["source"])
            if "HELPER / DIAGNOSTIC FUNCTIONS" in helpers_source:
                core_cells["helper_functions"] = cells[5].copy()

        # Find variables cell (typically Cell 8)
        if len(cells) > 7 and cells[7]["cell_type"] == "code":
            vars_source = "".join(cells[7]["source"])
            if "SECTION 1: ENVIRONMENT SETUP" in vars_source:
                core_cells["variables"] = cells[7].copy()

        return core_cells

    def find_existing_core_cells(self, target_nb: Dict[str, Any]) -> Dict[str, int]:
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
                    "SECTION 1: ENVIRONMENT SETUP" in source
                    and "variables" not in existing
                ):
                    existing["variables"] = i

        return existing

    def add_missing_cells(
        self,
        target_nb: Dict[str, Any],
        core_cells: Dict[str, Optional[Dict[str, Any]]],
        create_backup: bool = True,
    ) -> bool:
        """Add missing core cells to the target notebook. Returns True if changes were made."""
        existing = self.find_existing_core_cells(target_nb)
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

    def validate_notebook_structure(self, notebook_path: str) -> Dict[str, Any]:
        """Validate the structure of a notebook and return validation results."""
        results = {
            "valid": True,
            "issues": [],
            "core_cells_present": [],
            "total_cells": 0,
        }

        try:
            nb = self.load_notebook(notebook_path)
            cells = nb["cells"]
            results["total_cells"] = len(cells)

            existing = self.find_existing_core_cells(nb)
            results["core_cells_present"] = list(existing.keys())

            # Check for missing core cells
            missing_cells = [
                cell_type
                for cell_type in self.core_cell_types
                if cell_type not in existing
            ]
            if missing_cells:
                results["valid"] = False
                results["issues"].append(
                    f"Missing core cells: {', '.join(missing_cells)}"
                )

            # Check cell order
            expected_positions = {"imports": 4, "helper_functions": 5, "variables": 7}
            for cell_type, expected_pos in expected_positions.items():
                if cell_type in existing:
                    actual_pos = existing[cell_type]
                    if actual_pos != expected_pos:
                        results["issues"].append(
                            f"{cell_type} cell at position {actual_pos}, expected {expected_pos}"
                        )

        except Exception as e:
            results["valid"] = False
            results["issues"].append(f"Error loading notebook: {str(e)}")

        return results

    def add_cells_to_notebook(
        self,
        reference_path: str,
        target_path: str,
        create_backup: bool = True,
        verbose: bool = True,
    ) -> bool:
        """Add core cells from reference to target notebook."""
        if verbose:
            print(f"Processing notebooks...")
            print(f"Reference: {reference_path}")
            print(f"Target: {target_path}")
            print()

        # Validate inputs
        if not Path(reference_path).exists():
            print(f"Error: Reference notebook '{reference_path}' not found.")
            return False

        if not Path(target_path).exists():
            print(f"Error: Target notebook '{target_path}' not found.")
            return False

        # Load notebooks
        try:
            reference_nb = self.load_notebook(reference_path)
            target_nb = self.load_notebook(target_path)
        except Exception as e:
            print(f"Error loading notebooks: {e}")
            return False

        # Create backup if requested
        if create_backup:
            self.create_backup(target_path)

        # Extract core cells from reference
        if verbose:
            print("Extracting core cells from reference notebook...")
        core_cells = self.extract_core_cells(reference_nb)

        found_cells = [k for k, v in core_cells.items() if v is not None]
        if verbose:
            print(f"Found core cells: {', '.join(found_cells)}")

        if not found_cells:
            print("Warning: No core cells found in reference notebook!")
            return False

        # Check existing cells in target
        existing = self.find_existing_core_cells(target_nb)
        if verbose:
            print(f"Existing core cells in target: {list(existing.keys())}")

        # Add missing cells
        if verbose:
            print("\nAdding/updating core cells...")
        changes_made = self.add_missing_cells(
            target_nb, core_cells, create_backup=False
        )

        if changes_made:
            # Save the updated notebook
            try:
                self.save_notebook(target_nb, target_path)
                if verbose:
                    print(f"\n✅ Successfully updated {target_path}")
                    print("Core cells have been added/positioned correctly.")
                return True
            except Exception as e:
                print(f"Error saving notebook: {e}")
                return False
        else:
            if verbose:
                print(
                    "\n✅ No changes needed. All core cells are already present and correctly positioned."
                )
            return True

    def batch_add_cells(
        self, reference_path: str, pattern: str, create_backups: bool = True
    ) -> Dict[str, bool]:
        """Add core cells to multiple notebooks matching a pattern."""
        results = {}

        # Find all matching notebooks
        matching_files = glob.glob(pattern)

        if not matching_files:
            print(f"No notebooks found matching pattern: {pattern}")
            return results

        print(f"Found {len(matching_files)} notebooks matching pattern: {pattern}")

        for notebook_path in matching_files:
            if notebook_path == reference_path:
                print(f"Skipping reference notebook: {notebook_path}")
                continue

            print(f"\n--- Processing {notebook_path} ---")
            success = self.add_cells_to_notebook(
                reference_path, notebook_path, create_backups, verbose=False
            )
            results[notebook_path] = success

            if success:
                print(f"✅ {notebook_path}")
            else:
                print(f"❌ {notebook_path}")

        return results


def main():
    parser = argparse.ArgumentParser(description="Notebook Cell Management System")
    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # Add cells command
    add_parser = subparsers.add_parser("add-cells", help="Add core cells to a notebook")
    add_parser.add_argument(
        "--reference", required=True, help="Reference notebook path"
    )
    add_parser.add_argument("--target", required=True, help="Target notebook path")
    add_parser.add_argument(
        "--no-backup", action="store_true", help="Skip creating backup"
    )

    # Validate command
    validate_parser = subparsers.add_parser(
        "validate", help="Validate notebook structure"
    )
    validate_parser.add_argument("notebook", help="Notebook to validate")

    # Batch add command
    batch_parser = subparsers.add_parser(
        "batch-add", help="Add cells to multiple notebooks"
    )
    batch_parser.add_argument(
        "--reference", required=True, help="Reference notebook path"
    )
    batch_parser.add_argument(
        "--pattern", required=True, help="Glob pattern for target notebooks"
    )
    batch_parser.add_argument(
        "--no-backups", action="store_true", help="Skip creating backups"
    )

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return

    manager = NotebookCellManager()

    if args.command == "add-cells":
        create_backup = not args.no_backup
        success = manager.add_cells_to_notebook(
            args.reference, args.target, create_backup
        )
        sys.exit(0 if success else 1)

    elif args.command == "validate":
        results = manager.validate_notebook_structure(args.notebook)

        print(f"Validation Results for {args.notebook}:")
        print(f"Valid: {results['valid']}")
        print(f"Total cells: {results['total_cells']}")
        print(f"Core cells present: {', '.join(results['core_cells_present'])}")

        if results["issues"]:
            print("Issues found:")
            for issue in results["issues"]:
                print(f"  - {issue}")
        else:
            print("No issues found.")

        sys.exit(0 if results["valid"] else 1)

    elif args.command == "batch-add":
        create_backups = not args.no_backups
        results = manager.batch_add_cells(args.reference, args.pattern, create_backups)

        successful = sum(1 for success in results.values() if success)
        total = len(results)

        print(
            f"\nBatch processing complete: {successful}/{total} notebooks updated successfully"
        )
        sys.exit(0 if successful == total else 1)


if __name__ == "__main__":
    main()
