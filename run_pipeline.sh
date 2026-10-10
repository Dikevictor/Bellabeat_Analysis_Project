#!/bin/bash
set -e

# Get the directory where this script is located
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "Starting Bellabeat Data Pipeline..."
echo "=========================================="

# 1. Create Staging Tables
echo "[1/2] Creating staging schemas..."
"/Applications/Postgres.app/Contents/Versions/18/bin/psql" -d bellabeat_analysis -f "$DIR/SQL/01_schema_staging.sql"

# 2. Load Raw CSV Data using client-side \copy stream with updated raw path
echo "[2/2] Loading raw CSV data..."
"/Applications/Postgres.app/Contents/Versions/18/bin/psql" -d bellabeat_analysis -c "\copy daily_activity FROM '$DIR/Data/raw/dailyActivity_merged.csv' WITH (FORMAT csv, HEADER true);"
"/Applications/Postgres.app/Contents/Versions/18/bin/psql" -d bellabeat_analysis -c "\copy daily_sleep FROM '$DIR/Data/raw/sleepDay_merged.csv' WITH (FORMAT csv, HEADER true);"

echo "=========================================="
echo "Pipeline execution complete successfully!"
echo "=========================================="