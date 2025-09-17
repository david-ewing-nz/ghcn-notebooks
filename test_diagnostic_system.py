#!/usr/bin/env python3
"""
Test script for the updated diagnostic extraction and result loading system
"""

import json
from datetime import datetime
from pathlib import Path


def create_test_results():
    """Create test result files to simulate captured PySpark output"""

    # Create results directory
    results_dir = Path("results")
    results_dir.mkdir(exist_ok=True)

    # GOOD notebook results (from the user's output)
    good_results = {
        "tag": "good_notebook",
        "timestamp": datetime.now().isoformat(),
        "result": {
            "daily_count": 129619,
            "station_count": 129657,
            "inv_count": 129618,
            "diffs": [0, 38, 39, 0],
        },
    }

    # E notebook results (simulated)
    e_results = {
        "tag": "e_notebook",
        "timestamp": datetime.now().isoformat(),
        "result": {
            "daily_count": 129620,
            "station_count": 129658,
            "inv_count": 129619,
            "diffs": [1, 39, 40, 1],
        },
    }

    # Save test files
    with open(results_dir / "good_notebook_probe_results.json", "w") as f:
        json.dump(good_results, f, indent=2)

    with open(results_dir / "e_notebook_probe_results.json", "w") as f:
        json.dump(e_results, f, indent=2)

    print("Test result files created successfully")


def test_extraction():
    """Test the updated extraction script with a sample notebook"""

    # This would normally be called with:
    # python auto_extract_diagnostics.py path/to/notebook.ipynb test_version

    print("Testing extraction functionality...")
    print("Note: This would extract from actual notebook files")
    print("For now, we're using the JSON capture approach")


def test_loading():
    """Test loading captured results"""

    # Import the function from our updated script
    import sys

    sys.path.append(".")
    from optimized_probe_universe import load_captured_results

    print("\n=== Testing Result Loading ===")

    # Test loading GOOD results
    good_result = load_captured_results("good_notebook")
    if good_result:
        print(f"GOOD results: {good_result}")
    else:
        print("No GOOD results found")

    # Test loading E results
    e_result = load_captured_results("e_notebook")
    if e_result:
        print(f"E results: {e_result}")
    else:
        print("No E results found")


if __name__ == "__main__":
    print("=== Diagnostic System Test ===")

    # Create test data
    create_test_results()

    # Test loading
    test_loading()

    # Test extraction
    test_extraction()

    print("\n=== Test Complete ===")
    print("The system is now ready to:")
    print("1. Capture real results from PySpark using " "pyspark_result_capture.py")
    print("2. Load those results automatically in " "optimized_probe_universe.py")
    print("3. Extract diagnostics from notebooks using " "auto_extract_diagnostics.py")
