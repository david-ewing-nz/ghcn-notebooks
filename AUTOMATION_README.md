# Automated Cross-Environment Diagnostics System

This system provides fully automated cross-environment diagnostics for the GHCN data processing workflow, eliminating the need for manual intervention.

## Overview

The automation system coordinates between:
- **PySpark Environment**: Runs full diagnostics and pushes results (E/F/G versions)
- **VS Code/pandas Environment**: Automatically detects, pulls, and analyzes results
- **Automated Workflow**: Handles the entire process without user intervention

## Quick Start

1. **Initialize the System**:
   ```batch
   start_automation.bat
   ```

2. **PySpark Environment**: Run your diagnostics and push results as usual

3. **Monitor Progress**: Check the `results/` directory for analysis outputs

## System Components

### Core Scripts
- `start_automation.bat` - Main startup script
- `auto_orchestrator.bat` - Master workflow coordinator
- `auto_git_monitor_enhanced.bat` - Git change detector
- `auto_analyze_[e|f|g].bat` - Version-specific analyzers
- `auto_extract_diagnostics.py` - Diagnostic output extractor
- `auto_push_results.bat` - Automated results push back to repository
- `generate_final_report.bat` - Final report compiler

### Configuration
- `.vscode/settings.json` - VS Code automation settings
- `requirements.txt` - Python dependencies

## Workflow

```
PySpark Environment    VS Code Environment
     |                        |
     |  Push E/F/G versions   |
     |----------------------->|
     |                        |  Auto-detect changes
     |                        |  Auto-pull updates
     |                        |  Auto-execute notebooks
     |                        |  Auto-extract diagnostics
     |                        |  Auto-push results back
     |                        |  Auto-generate reports
```

## Output Files

Results are saved to the `results/` directory:

- `E_analysis_summary.txt` - Tier 1 (Sample) results
- `F_analysis_summary.txt` - Tier 2 (Filtered) results
- `G_analysis_summary.txt` - Tier 3 (Full) results
- `final_report.txt` - Complete analysis summary

## Key Features

### Fully Automated
- No manual Git commands required
- Automatic notebook execution
- Self-contained diagnostic extraction
- Comprehensive reporting

### Robust Monitoring
- Continuous Git change detection
- Background process management
- Error handling and recovery
- Status logging with timestamps

### Cross-Environment Validation
- Validates PySpark vs pandas results
- Extracts key diagnostic metrics
- Compares station counts and filtering
- Identifies discrepancies automatically

## Usage Examples

### Starting the System
```batch
# Initialize everything
start_automation.bat
```

### Manual Analysis (if needed)
```batch
# Analyze specific version
auto_analyze_e.bat
auto_analyze_f.bat
auto_analyze_g.bat
```

### Checking Status
```batch
# View current results
type results\final_report.txt
```

## Diagnostic Output

The system extracts these key metrics:

- **Daily stations count**
- **Stations stations count**
- **Strict filtering results**
- **Filtered stations count**
- **Total records processed**
- **Sample size validation**
- **Set differences between environments**
- **38/39 validation markers**

## Troubleshooting

### System Not Starting
1. Ensure Python virtual environment is set up
2. Check that required packages are installed
3. Verify Git credentials are configured

### No Results Generated
1. Confirm PySpark environment is pushing changes
2. Check Git connectivity
3. Verify notebook files are present in `code/` directory

### Analysis Errors
1. Check `results/` directory for error logs
2. Ensure Jupyter is properly configured
3. Verify notebook cell execution permissions

## System Requirements

- Windows 10/11
- Python 3.8+
- Git
- VS Code with Python and Jupyter extensions
- PySpark environment (remote)

## Dependencies

- jupyter
- nbconvert
- pandas
- numpy
- matplotlib

## Configuration

The system is configured via:
- `.vscode/settings.json` - VS Code automation settings
- `auto_git_monitor_enhanced.bat` - Git monitoring parameters
- `auto_orchestrator.bat` - Workflow timing and logic

## Logs and Monitoring

- All operations are logged with timestamps
- Background processes run continuously
- Status updates every 30-60 seconds
- Results saved to `results/` directory

## Stopping the System

To stop the automation:
1. Close the orchestrator terminal window
2. Kill any running background processes
3. The system will automatically clean up on next restart

---

**Note**: This system is designed for the specific GHCN data processing workflow and may require adaptation for other use cases.