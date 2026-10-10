-- Here I am writing the statements to ingest the raw data into staging tables.

-- 1. Ingest Daily Activity Raw CSV 
SELECT '=== Loading daily_activity Table ===' AS info;
COPY daily_activity (
    id, Activity_Date, Total_Steps, Total_Distance, Tracker_Distance, Logged_Activities_Distance,
     Very_Active_Distance, Moderately_Active_Distance, Light_Active_Distance, 
     Sedentary_Active_Distance, Very_Active_Minutes, Fairly_Active_Minutes, 
     Lightly_Active_Minutes, Sedentary_Minutes, Calories
)
FROM '/Users/nwabuokeidikevictor/Development Folder/Bellabeat_Analysis_Project/Data/raw/dailyActivity_merged.csv'
DELIMITER ','
CSV HEADER;

-- 2. Ingest Daily Sleep Raw CSV
SELECT '=== Loading daily_sleep Table ===' AS info;
COPY daily_sleep (
    id, Sleep_Day, Total_Sleep_Records, Total_Minutes_Asleep, Total_Time_in_Bed
)
FROM '/Users/nwabuokeidikevictor/Development Folder/Bellabeat_Analysis_Project/Data/raw/sleepDay_merged.csv'
DELIMITER ','
CSV HEADER;

-- Data Validation 
SELECT 'daily_activity' AS table_name, COUNT(*) AS record_count FROM daily_activity
UNION ALL
SELECT 'daily_sleep', COUNT(*) FROM daily_sleep;

-- SELECT '=== Daily Activity Sample ===' AS info;
SELECT * FROM daily_activity LIMIT 5; 
-- SELECT '=== Daily Sleep Sample ===' AS info;
SELECT * FROM daily_sleep LIMIT 5;