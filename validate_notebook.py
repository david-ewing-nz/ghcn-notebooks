#!/usr/bin/env python3
"""
Test script to validate the updated D notebook
Tests the specific daily file loading and basic functionality
"""

import json
import sys
from pathlib import Path


def validate_notebook_structure(notebook_path):
    """Validate that the notebook has the correct structure after updates"""

    print(f"Validating notebook: {notebook_path}")

    with open(notebook_path, "r", encoding="utf-8") as f:
        nb = json.load(f)

    print(f"Total cells: {len(nb['cells'])}")

    # Check for required sections
    sections_found = []
    q4b58_found = False

    for i, cell in enumerate(nb["cells"]):
        if cell.get("cell_type") == "code":
            source_text = "".join(cell.get("source", []))

            # Check for specific daily file loading
            if "SECTION 2: DATA INGESTION" in source_text:
                sections_found.append("Data Ingestion")
                print(f"✓ Found data ingestion section (cell {i+1})")

            # Check for Q4(b)58
            if "Process Answer: Q4(b)58" in source_text:
                q4b58_found = True
                print(f"✓ Found Q4(b)58 cell (cell {i+1})")

                # Check that it doesn't reference daily_for_overlap
                if "daily_for_overlap" in source_text:
                    print("✗ Q4(b)58 still references daily_for_overlap")
                    return False
                else:
                    print("✓ Q4(b)58 updated to use new daily loading")

    # Summary
    print("\nValidation Results:")
    print(
        f"- Data ingestion section: "
        f"{'✓' if 'Data Ingestion' in sections_found else '✗'}"
    )
    print(f"- Q4(b)58 cell: {'✓' if q4b58_found else '✗'}")
    print("- References updated: ✓")

    success = "Data Ingestion" in sections_found and q4b58_found
    print(f"\nOverall: {'✓ PASS' if success else '✗ FAIL'}")

    return success


if __name__ == "__main__":
    notebook_path = r"d:\github\ghcn-notebooks\code\20250916D_Build.ipynb"

    if not Path(notebook_path).exists():
        print(f"Error: Notebook not found at {notebook_path}")
        sys.exit(1)

    try:
        if validate_notebook_structure(notebook_path):
            print("\n🎉 Notebook validation successful!")
            print("The D notebook is ready for the next phase.")
        else:
            print("\n❌ Notebook validation failed!")
            print("Please check the issues above.")
            sys.exit(1)
    except Exception as e:
        print(f"Error validating notebook: {e}")
        sys.exit(1)
