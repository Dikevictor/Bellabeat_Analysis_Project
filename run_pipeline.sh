# This is a root automation script to build the entire pipeline
#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================="
echo "Starting Bellabeat Data Pipeline..."
echo "=========================================="

# 1. Create Staging Tables
echo "[1/2] Creating staging schemas..."
psql -d bellabeat_analysis -f sql/01_schema_staging.sql

# 2. Load Raw CSV Data using client-side \copy stream
echo "[2/2] Loading raw CSV data..."
psql -d bellabeat_analysis -c "\copy daily_activity FROM 'Data/dailyActivity_merged.csv' WITH (FORMAT csv, HEADER true);"
psql -d bellabeat_analysis -c "\copy daily_sleep FROM 'Data/sleepDay_merged.csv' WITH (FORMAT csv, HEADER true);"

echo "=========================================="
echo "Pipeline execution complete successfully!"
echo "=========================================="