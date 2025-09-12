REM --- THIS FILE WAS CREATED WITH THE HELP OF CHATGPT ---
cd /d M:\ghcn-spark-analysis

REM --- Top-level files ---
IF NOT EXIST ".gitignore" type nul > .gitignore
IF NOT EXIST "README.md" type nul > README.md
IF NOT EXIST "environment.yml" type nul > environment.yml

REM --- Directories and subfolders ---
IF NOT EXIST "notebooks" mkdir notebooks
IF NOT EXIST "scripts" mkdir scripts
IF NOT EXIST "data" mkdir data
IF NOT EXIST "data\raw" mkdir data\raw
IF NOT EXIST "data\processed" mkdir data\processed
IF NOT EXIST "data\sample" mkdir data\sample
IF NOT EXIST "output" mkdir output
IF NOT EXIST "output\figures" mkdir output\figures
IF NOT EXIST "output\tables" mkdir output\tables
IF NOT EXIST "output\results" mkdir output\results
IF NOT EXIST "report" mkdir report

REM --- Placeholder report files ---
IF NOT EXIST "report\DATA420_Report.pdf" type nul > report\DATA420_Report.pdf
IF NOT EXIST "report\supplementary_material.zip" type nul > report\supplementary_material.zip

REM --- Starter notebooks ---
IF NOT EXIST "notebooks\01_data_exploration.ipynb" type nul > notebooks\01_data_exploration.ipynb
IF NOT EXIST "notebooks\02_schema_and_loading.ipynb" type nul > notebooks\02_schema_and_loading.ipynb
IF NOT EXIST "notebooks\03_enrich_stations.ipynb" type nul > notebooks\03_enrich_stations.ipynb
IF NOT EXIST "notebooks\04_station_checks.ipynb" type nul > notebooks\04_station_checks.ipynb
IF NOT EXIST "notebooks\05_station_analysis.ipynb" type nul > notebooks\05_station_analysis.ipynb
IF NOT EXIST "notebooks\06_geospatial_distance.ipynb" type nul > notebooks\06_geospatial_distance.ipynb
IF NOT EXIST "notebooks\07_daily_summary.ipynb" type nul > notebooks\07_daily_summary.ipynb
IF NOT EXIST "notebooks\08_visualisations.ipynb" type nul > notebooks\08_visualisations.ipynb

REM --- Starter scripts ---
IF NOT EXIST "scripts\load_schemas.py" type nul > scripts\load_schemas.py
IF NOT EXIST "scripts\enrich_stations.py" type nul > scripts\enrich_stations.py
IF NOT EXIST "scripts\visualisation_helpers.py" type nul > scripts\visualisation_helpers.py

echo Project structure and starter files created.
pause
