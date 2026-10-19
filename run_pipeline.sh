#!/bin/bash
set -e

# Get the directory where this script is located
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo "Starting Bellabeat Data Pipeline..."
echo "========================================"

# 1. Create Staging Tables
echo "[1/6] Creating staging schemas..."
"/Applications/Postgres.app/Contents/Versions/18/bin/psql" -d bellabeat_analysis -f "$DIR/SQL/01_schema_staging.sql"

# 2. Load Raw CSV Data
echo "[2/6] Loading raw CSV data..."
"/Applications/Postgres.app/Contents/Versions/18/bin/psql" -d bellabeat_analysis -f "$DIR/SQL/02_data_loading.sql"

# 3. Clean and Transform Data
echo "[3/6] Running data cleaning and transformation..."
"/Applications/Postgres.app/Contents/Versions/18/bin/psql" -d bellabeat_analysis -f "$DIR/SQL/03_data_cleaning.sql"

# 4. Run Exploratory Data Analysis
echo "[4/6] Running EDA queries..."
"/Applications/Postgres.app/Contents/Versions/18/bin/psql" -d bellabeat_analysis -f "$DIR/SQL/04_sedentary_vs_sleep_impact.sql"

# 5. Sleep Hygiene Analysis
echo "[5/6] Running sleep hygiene analysis..."
"/Applications/Postgres.app/Contents/Versions/18/bin/psql" -d bellabeat_analysis -f "$DIR/SQL/05_sleep_hygiene.sql"

# 6. Activity & Adherence Analysis
echo "[6/6] Running activity and adherence analysis..."
"/Applications/Postgres.app/Contents/Versions/18/bin/psql" -d bellabeat_analysis -f "$DIR/SQL/06_activity_adherence.sql"

echo "========================================"
echo "Pipeline execution complete successfully!"
echo "========================================"