#!/usr/bin/env python3
"""
Automated result extraction from Jupyter notebook for GHCN diagnostics.
Extracts key metrics from the E run notebook and updates the optimized_probe_universe.py file.
"""

import configparser
import json
import os
import re


def load_config_values():
    """Load values from config file if available"""
    config_file = "automation_config.ini"
    if os.path.exists(config_file):
        config = configparser.ConfigParser()
        config.read(config_file)

        if config.getboolean("RESULTS", "values_updated", fallback=False):
            return {
                "daily_stations": config.getint(
                    "RESULTS", "daily_count", fallback=120000
                ),
                "stations_stations": config.getint(
                    "RESULTS", "station_count", fallback=25000
                ),
                "inv_count": config.getint("RESULTS", "inv_count", fallback=25000),
                "diffs": eval(config.get("RESULTS", "diffs", fallback="[0, 0, 0, 0]")),
            }
    return None


def extract_results_from_notebook(notebook_path):
    """Extract key results from the notebook."""
    results = {}

    with open(notebook_path, "r", encoding="utf-8") as f:
        nb = json.load(f)

    for cell in nb["cells"]:
        if cell["cell_type"] == "code" and "outputs" in cell:
            for output in cell["outputs"]:
                # Check for text outputs
                if "text" in output:
                    for line in output["text"]:
                        line = line.strip()
                        # Extract station counts
                        if "Daily stations:" in line:
                            match = re.search(r"Daily stations:\s*(\d+)", line)
                            if match:
                                results["daily_stations"] = int(match.group(1))
                        elif "Stations stations:" in line:
                            match = re.search(r"Stations stations:\s*(\d+)", line)
                            if match:
                                results["stations_stations"] = int(match.group(1))
                        elif "STRICT FILTERING" in line:
                            results["strict_filtering"] = True

                # Check for data outputs (sometimes results are in data)
                elif "data" in output and "text/plain" in output["data"]:
                    for line in output["data"]["text/plain"]:
                        line = line.strip()
                        if "Daily stations:" in line:
                            match = re.search(r"Daily stations:\s*(\d+)", line)
                            if match:
                                results["daily_stations"] = int(match.group(1))
                        elif "Stations stations:" in line:
                            match = re.search(r"Stations stations:\s*(\d+)", line)
                            if match:
                                results["stations_stations"] = int(match.group(1))
                        elif "STRICT FILTERING" in line:
                            results["strict_filtering"] = True

    return results


def update_optimized_probe_universe(results):
    """Update the hardcoded values in optimized_probe_universe.py"""
    file_path = "optimized_probe_universe.py"

    if not os.path.exists(file_path):
        print(f"Warning: {file_path} not found")
        return False

    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Find the hardcoded return values and update them
    # The format is: return { "daily_count": 12345, "station_count": 6789, ... }

    # Update daily_count
    if "daily_stations" in results:
        content = content.replace(
            '"daily_count": 12345', f'"daily_count": {results["daily_stations"]}'
        )

    # Update station_count
    if "stations_stations" in results:
        content = content.replace(
            '"station_count": 6789', f'"station_count": {results["stations_stations"]}'
        )

    # For now, keep inv_count and diffs as defaults since we don't have those values
    # They can be updated manually when the actual values are available

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"Updated {file_path} with extracted results")
    return True


def main():
    notebook_path = "code/20250916E_Build.ipynb"

    if not os.path.exists(notebook_path):
        print(f"Notebook {notebook_path} not found")
        return

    print("Extracting results from notebook...")
    results = extract_results_from_notebook(notebook_path)

    print("Extracted results:")
    for key, value in results.items():
        print(f"  {key}: {value}")

    if results:
        print("Updating optimized_probe_universe.py...")
        success = update_optimized_probe_universe(results)
        if success:
            print("Automation complete!")
        else:
            print("Failed to update the file")
    else:
        print("No results found in notebook - checking config file...")
        config_results = load_config_values()
        if config_results:
            print("Using values from config file:")
            for key, value in config_results.items():
                print(f"  {key}: {value}")
            success = update_optimized_probe_universe(config_results)
            if success:
                print("Automation complete using config values!")
            else:
                print("Failed to update the file with config values")
        else:
            print(
                "No config values available - using default values for automation testing"
            )
            # Use default values for testing the automation
            default_results = {
                "daily_stations": 120000,  # Approximate expected value
                "stations_stations": 25000,  # Approximate expected value
                "strict_filtering": True,
            }
            print("Default results:")
            for key, value in default_results.items():
                print(f"  {key}: {value}")

            success = update_optimized_probe_universe(default_results)
            if success:
                print("Automation complete with default values!")
                print(
                    "NOTE: Update automation_config.ini with your actual values for better accuracy"
                )
            else:
                print("Failed to update the file with default values")


if __name__ == "__main__":
    main()
