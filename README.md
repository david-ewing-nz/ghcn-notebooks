# 🌍 GHCN Spark Analysis (DATA420 Assignment 1)
 
This is my submission for **DATA420 Assignment 1** . 
The project involves distributed data processing and analysis of the **Global Historical Climatology Network (GHCN)** dataset using **Apache Spark**.

---

## 🧠 Project Overview

The full workflow is run in a distributed environment using a cloud-based Spark notebook environment provided by James William, with outputs exported for local analysis and visualisation.

## 📋 Current Working Milestones

### **🎯 Primary Recommended Notebook**
**`20251003_AG_Enhanced.ipynb`** - Complete version combining:
- ✅ **Full Q2(b), Q2(c), Q3, Q4 functionality** from 1001A
- ✅ **Fixed cell dependencies** using C2_GOOD approach  
- ✅ **Dependency fix cells** to prevent `daily_for_overlap` NameError
- ✅ **Ready for Spark environment execution**

### **🔧 Alternative Versions**
- **`20251003_AG_Processing.ipynb`** - Basic stable version (C2_GOOD based)
- **`20251001A_Processing.ipynb`** - Full functionality but requires manual cell order fix

---

## 📁 Repository Structure (readme.md created with ChatGPT)

```bash
ghcn-spark-analysis/
│
├── .gitignore
├── README.md
├── environment.yml            # Optional: conda environment
│
├── notebooks/                 # Primary notebooks for each phase
│   ├── 01_data_exploration.ipynb
│   ├── 02_schema_and_loading.ipynb
│   ├── 03_enrich_stations.ipynb
│   ├── 04_station_checks.ipynb
│   ├── 05_station_analysis.ipynb
│   ├── 06_geospatial_distance.ipynb
│   ├── 07_daily_summary.ipynb
│   └── 08_visualisations.ipynb
│
├── scripts/                   # Helper scripts for schema, joins, visualisations
│   ├── load_schemas.py
│   ├── enrich_stations.py
│   └── visualisation_helpers.py
│
├── data/
│   ├── raw/                   # (Optional) local copy of samples
│   ├── processed/             # Spark output for visualisation
│   └── sample/                # Small mock files for testing locally
│
├── output/
│   ├── figures/               # Charts and plots for report
│   ├── tables/                # CSV summaries or aggregations
│   └── results/               # Misc. output files
│
├── report/
│   ├── DATA420_Report.pdf
│   └── supplementary_material.zip
│
└── doc/