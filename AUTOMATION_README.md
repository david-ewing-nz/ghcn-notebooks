# Fully Automated Cross-Environment Diagnostics System

This system provides **completely automated** detection and notification of diagnostic results in Build files, running continuously without any user intervention.

## 🚀 Quick Start - Full Automation

1. **Start the complete automated system:**
   ```batch
   start_full_automation.bat
   ```

2. **The system runs indefinitely and automatically:**
   - Monitors Git for new commits with test results
   - Checks Build files for specific diagnostic patterns
   - Extracts and analyzes results when found
   - Sends notifications via Windows toast and logs
   - Continues monitoring 24/7

## 🎯 What Gets Automatically Detected

The system monitors for these exact diagnostic patterns from your GOOD notebook:

- `[COUNT] daily IDs : 129619`
- `[COUNT] station IDs (cat) : 129657`
- `[COUNT] inventory IDs : 129618`
- `[DIFF ] daily – station : 0`
- `[DIFF ] station – daily : 38`
- `[DIFF ] station – inv : 39`
- `[DIFF ] inv – daily : 0`
- `[DIFF ] inv – station : 0`
- `[time] cell_time (sec): 1757389100.25`
- `[time] cell_time (min): 29289818.34`

## 📁 Files Created Automatically

When results are detected:

- `results/{VERSION}_analysis_summary.txt` - Complete diagnostic extraction
- `diagnostic_alert.log` - Timestamped detection alerts
- `notification_log.txt` - Detailed notification history
- Windows toast notifications - Immediate alerts

## 🔔 Notification System

**Zero manual intervention required:**

1. **Windows Toast Notifications** - Instant popup when results found
2. **Persistent Logs** - All detections recorded automatically
3. **Real-time Console** - Live status in monitoring windows

## 🛑 Stopping the Automation

To stop the fully automated system:

1. Find console windows: "Git Monitor" and "Diagnostic Monitor"
2. Press `Ctrl+C` in each window
3. System stops completely

## 🧪 Manual Testing

Test the diagnostic extraction manually:

```batch
python auto_extract_diagnostics.py "code\20250916E_Build.ipynb" "E"
```

## ⚙️ Customization Options

- **Email alerts:** Configure in `send_notification.py`
- **Monitor frequency:** Edit `timeout` values in batch files
- **New patterns:** Add to `auto_extract_diagnostics.py`

## 📊 System Status

The master script shows:
- Status updates every 5 minutes
- Recent alerts from log files
- Active monitoring confirmation
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

## 🧹 Automated Notebook Cleanup

In addition to the diagnostic monitoring system, this repository includes automated tools to clean up Jupyter notebooks by removing duplicate cells and test/debugging content.

### Files

- `automate_notebook_cleanup.py` - Python script that automatically cleans notebooks
- `automate_cleanup.bat` - Windows batch file for easy execution

### Usage

#### Option 1: Run the Python script directly
```bash
python automate_notebook_cleanup.py
```

#### Option 2: Use the batch file (Windows)
Double-click `automate_cleanup.bat` or run it from command prompt:
```cmd
automate_cleanup.bat
```

### What the cleanup script does

The automated cleanup script:

1. **Removes duplicate Q4(b)58 cells** - Keeps only the first instance of the probe_universe diagnostic cell
2. **Removes test/debugging cells** - Identifies and removes cells containing:
   - Tier 1/2/3 sample data tests
   - Diagnostic testing strategy content
   - Wildcard daily data loading sections
   - Other test/debugging code

3. **Preserves essential analysis cells** - Keeps all legitimate analysis and processing cells

### Cleanup Results

After running the cleanup on `20250916D_Build.ipynb`:
- **Original cells**: 120
- **Cells kept**: 35
- **Cells removed**: 85
- **Q4(b)58 cells remaining**: 1

### Safety

The script works directly on the notebook file. Make sure to commit your changes before running the cleanup, or create a manual backup if needed.

---

## 🔧 Automated Cell Addition System

This system automatically adds the three core cells (imports, helper functions, variables) to Jupyter notebooks, ensuring consistency across all versions.

### Quick Start

**For current notebook (18A):** ✅ Already has all cells - no action needed

**For new notebooks:**
```bash
# Single notebook
python automate_cell_addition.py code\20250916D_Build.ipynb code\20250918A_Build.ipynb

# Or use batch file
auto_add_cells.bat code\20250916D_Build.ipynb code\20250918A_Build.ipynb
```

### Zero-Intervention Automation

Set up once to run automatically:

```bash
# Setup scheduled task (requires admin)
setup_auto_cell_addition.bat

# Or run full automation manually
full_auto_cell_addition.bat
```

### Advanced Management

```bash
# Validate notebook structure
python notebook_cell_manager.py validate code\20250918A_Build.ipynb

# Batch process multiple notebooks
python notebook_cell_manager.py batch-add --reference code\20250916D_Build.ipynb --pattern "code\202509*Build.ipynb"
```

### What Gets Automated

- ✅ Detects missing core cells (imports, helper functions, variables)
- ✅ Extracts cells from reference notebook (D version)
- ✅ Adds cells in correct order and position
- ✅ Creates automatic backups before changes
- ✅ Validates notebook structure after changes
- ✅ Logs all operations with timestamps

### Your Involvement Options

1. **Zero involvement:** Set up scheduled task - runs daily automatically
2. **Minimal involvement:** Run batch script when creating new notebooks
3. **Full control:** Use individual commands for specific operations

### Files Created

- `automate_cell_addition.py` - Core automation engine
- `auto_add_cells.bat` - Simple Windows interface
- `notebook_cell_manager.py` - Advanced management with validation
- `full_auto_cell_addition.bat` - Zero-intervention batch processing
- `setup_auto_cell_addition.bat` - Scheduled task setup (admin required)

### Integration

This system integrates seamlessly with your existing:
- Git automation (`auto_git_monitor_enhanced.bat`)
- Versioning system (`notebook_versioner.bat`)
- Cleanup system (`automate_notebook_cleanup.py`)
- Archiving system (`archive_versions.bat`)

**Result:** Complete automation chain from notebook creation to maintenance, requiring zero ongoing user intervention.