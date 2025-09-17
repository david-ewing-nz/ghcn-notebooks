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