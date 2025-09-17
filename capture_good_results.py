# Capture GOOD notebook results for comparison
# Run this in your PySpark environment after executing the GOOD notebook

import json
from pathlib import Path


def capture_probe_universe_results():
    """Capture the results from the GOOD notebook's probe_universe call"""

    # Execute the same probe_universe call as in the GOOD notebook
    # Note: This assumes daily, stations, inv_agg are already loaded
    result = probe_universe(daily, stations, inv_agg, tag="GOOD-notebook-capture")

    # Save to a JSON file that both environments can access
    results_file = "/path/to/shared/results/good_notebook_results.json"

    # Create directory if it doesn't exist
    Path(results_file).parent.mkdir(parents=True, exist_ok=True)

    with open(results_file, "w") as f:
        json.dump(result, f, indent=2)

    print(f"GOOD notebook results saved to: {results_file}")
    print("Results:", result)

    return result


# Usage:
# result = capture_probe_universe_results()
