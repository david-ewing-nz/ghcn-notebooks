#!/usr/bin/env python3
"""
PySpark Result Capture Script
Captures probe_universe results and saves them to JSON for automation
"""

import json
from datetime import datetime
from pathlib import Path


def capture_probe_results(daily, stations, inv_agg, tag="capture"):
    """
    Capture probe_universe results and save to JSON file

    Args:
        daily: Daily DataFrame
        stations: Stations DataFrame
        inv_agg: Inventory aggregated DataFrame
        tag: Identifier for this capture
    """
    print(f"[{datetime.now()}] Capturing probe_universe results " f"with tag: {tag}")

    # Execute probe_universe function
    result = probe_universe(daily, stations, inv_agg, tag=tag)

    # Create results directory
    results_dir = Path("results")
    results_dir.mkdir(exist_ok=True)

    # Save results to JSON
    results_file = results_dir / f"{tag}_probe_results.json"
    with open(results_file, "w") as f:
        json.dump(
            {"tag": tag, "timestamp": datetime.now().isoformat(), "result": result},
            f,
            indent=2,
        )

    print(f"Results saved to: {results_file}")
    print(f"Captured result: {result}")

    return result


def load_probe_results(tag="capture"):
    """
    Load previously captured probe results from JSON file

    Args:
        tag: Identifier for the capture to load

    Returns:
        dict: The captured results or None if not found
    """
    results_file = Path("results") / f"{tag}_probe_results.json"

    if not results_file.exists():
        print(f"No results file found for tag: {tag}")
        return None

    try:
        with open(results_file, "r") as f:
            data = json.load(f)
        print(f"Loaded results for tag: {tag}")
        return data
    except Exception as e:
        print(f"Error loading results: {e}")
        return None


# Usage examples:
# In PySpark environment:
# result = capture_probe_results(daily, stations, inv_agg, tag="good_notebook")
#
# In local environment:
# data = load_probe_results(tag="good_notebook")
# if data:
#     print(data["result"])
