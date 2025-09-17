# Capture E notebook results for comparison
# Run this in your PySpark environment after executing the E notebook

import json
from pathlib import Path


def capture_e_notebook_results():
    """Capture the results from the E notebook's probe_universe call"""

    # Execute the same probe_universe call as in the E notebook
    # Note: This assumes daily, stations, inv_agg are already loaded
    result = probe_universe(daily, stations, inv_agg, tag="E-notebook-capture")

    # Save to a JSON file that both environments can access
    results_file = "/path/to/shared/results/e_notebook_results.json"

    # Create directory if it doesn't exist
    Path(results_file).parent.mkdir(parents=True, exist_ok=True)

    with open(results_file, "w") as f:
        json.dump(result, f, indent=2)

    print(f"E notebook results saved to: {results_file}")
    print("Results:", result)

    return result


# Usage:
# result = capture_e_notebook_results()
