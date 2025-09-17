# Notebook Versioning System

## 🎯 **Date + Letter Versioning System**

### **Naming Convention:**
```
YYYYMMDDA_Build.ipynb
││││││││││││││││││
│││││││││││││││││└─ Type (Build, Processing, etc.)
││││││││││││││││└─ Letter (A, B, C... for daily modifications)
│││││││││││││││└─ Day (01-31)
││││││││││││││└─ Month (01-12)
│││││││││││││└─ Year (2025)
```

### **Examples:**
- `20250918A_Build.ipynb` - First version on Sept 18, 2025
- `20250918B_Build.ipynb` - Second milestone on Sept 18, 2025
- `20250919A_Build.ipynb` - First version on Sept 19, 2025

## 🚀 **Quick Commands:**

### **Create New Version:**
```batch
.\notebook_versioner.bat
```

### **Version Management Dashboard:**
```batch
.\version_dashboard.bat
```

### **Switch Automation to Version:**
```batch
# From dashboard or manually:
powershell -Command "(Get-Content q2_automation_config.ini) -replace 'notebook_path = .*', 'notebook_path = code/20250918A_Build.ipynb' | Set-Content q2_automation_config.ini"
```

### **View Version History:**
```batch
start VERSION_HISTORY.md
```

## 📁 **File Structure:**
```
code/
├── 20250916A_Build.ipynb    # Original A
├── 20250916B_Build.ipynb    # Original B
├── 20250916C_Pandas_Processing.ipynb
├── 20250916D_Build.ipynb    # Current working
├── 20250918A_Build.ipynb    # Today's first version
└── 20250918B_Build.ipynb    # Today's second milestone

archive/                     # Old versions moved here
VERSION_HISTORY.md          # Automatic version tracking
```

## ⚙️ **Automation Integration:**

- ✅ **New versions automatically update** `q2_automation_config.ini`
- ✅ **Version history automatically maintained**
- ✅ **Git-aware analysis works with any version**
- ✅ **All scripts work with current configured version**

## 🎯 **Workflow:**

1. **Work on current notebook** (e.g., `20250916D_Build.ipynb`)
2. **Reach milestone** → Run `.\notebook_versioner.bat`
3. **Creates** `20250918A_Build.ipynb` (or next available letter)
4. **Automation switches** to new version automatically
5. **Continue working** on new version
6. **Repeat** for each milestone

## 📊 **Benefits:**

- ✅ **Clear version history** with dates and letters
- ✅ **Milestone tracking** throughout the day
- ✅ **Automatic organization** by date
- ✅ **Seamless automation integration**
- ✅ **Easy rollback** to any previous version

**Your versioning system is now fully automated and integrated with your Q2 analysis workflow!** 🎉