#!/usr/bin/env python3
"""
Automated Diagnostic Output Extractor
Extracts key diagnostic results from executed Jupyter notebooks
"""

import json
import os
import sys
from datetime import datetime


def extract_diagnostic_output(notebook_path, version):
    """Extract diagnostic output from executed notebook"""
    print(f"[{datetime.now()}] Extracting diagnostics from {notebook_path}")

    # Create results directory
    os.makedirs("results", exist_ok=True)

    try:
        with open(notebook_path, "r", encoding="utf-8") as f:
            notebook = json.load(f)
    except Exception as e:
        print(f"Error loading notebook: {e}")
        return

    results = {
        "version": version,
        "timestamp": datetime.now().isoformat(),
        "diagnostics": {},
    }

    # Extract outputs from code cells
    for i, cell in enumerate(notebook["cells"]):
        if cell["cell_type"] == "code" and "outputs" in cell:
            for output in cell["outputs"]:
                if "text" in output:
                    text_content = "".join(output["text"])
                    lines = text_content.split("\n")

                    # Look for specific diagnostic patterns
                    for line in lines:
                        line = line.strip()
                        if "Daily stations:" in line:
                            results["diagnostics"]["daily_stations"] = line
                        elif "Stations stations:" in line:
                            results["diagnostics"]["stations_stations"] = line
                        elif "STRICT FILTERING" in line:
                            results["diagnostics"]["strict_filtering"] = line
                        elif "Filtered stations:" in line:
                            results["diagnostics"]["filtered_stations"] = line
                        elif "Total records:" in line:
                            results["diagnostics"]["total_records"] = line
                        elif "Sample size:" in line:
                            results["diagnostics"]["sample_size"] = line
                        elif "Set difference" in line.lower():
                            results["diagnostics"]["set_difference"] = line
                        elif "38/39" in line:
                            results["diagnostics"]["validation_38_39"] = line

    # Save results to file
    output_file = f"results/{version}_analysis_summary.txt"
    with open(output_file, "w") as f:
        f.write(f"=== {version.upper()} VERSION DIAGNOSTIC RESULTS ===\n")
        f.write(f"Analysis Timestamp: {results['timestamp']}\n\n")

        f.write("KEY DIAGNOSTICS:\n")
        for key, value in results["diagnostics"].items():
            f.write(f"- {key}: {value}\n")

        f.write("\n=== RAW JSON RESULTS ===\n")
        f.write(json.dumps(results, indent=2))

    print(f"[{datetime.now()}] Results saved to {output_file}")

    print(f"\n=== {version.upper()} ANALYSIS SUMMARY ===")
    for key, value in results["diagnostics"].items():
        print(f"{key}: {value}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python auto_extract_diagnostics.py", "<notebook_path> <version>")
        sys.exit(1)

    notebook_path = sys.argv[1]
    version = sys.argv[2]

    extract_diagnostic_output(notebook_path, version)
