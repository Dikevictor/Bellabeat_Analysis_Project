-- We want to perform data cleaning on the raw data

/*
-- First i created a table to put the new cleaned data. 
-- To clean this data, I first passed all the rows through two record filters: First, filtering out missing identifier and second, removing duplicate rows. 
1. For the first, I checked if there was any orphan rows using the code: SELECT COUNT (id) FROM daily_activity WHERE id IS NULL;
2. For the second, I used the SELECT DISTINCT function to filter out any duplicate row. 
Now, using all valid row, I then performs targeted cleaning on specific column that we will use for analysis.
This is shown in the code below: 

*/
-- Column Cleaning for daily_activity table 

DROP TABLE IF EXISTS cleaned_daily_activity;
DROP TABLE IF EXISTS cleaned_daily_sleep;

CREATE TABLE cleaned_daily_activity AS 
SELECT DISTINCT
    id::BIGINT AS user_id,
    TO_DATE(activity_date, 'MM/DD/YYYY') AS activity_date,
    Total_Steps::INT AS total_steps,
    Total_Distance::NUMERIC(10,2) AS total_distance,
    Tracker_Distance::NUMERIC(10,2) AS tracker_distance,
    Logged_Activities_Distance::NUMERIC(10,2) AS logged_activities_distance,
    Very_Active_Distance::NUMERIC(10,2) AS very_active_distance,
    Moderately_Active_Distance::NUMERIC(10,2) AS moderately_active_distance,
    Light_Active_Distance::NUMERIC(10,2) AS light_active_distance,
    Sedentary_Active_Distance::NUMERIC(10,2) AS sedentary_active_distance,
    Very_Active_Minutes::INT AS very_active_minutes,
    Fairly_Active_Minutes::INT AS fairly_active_minutes,
    Lightly_Active_Minutes::INT AS lightly_active_minutes,
    Sedentary_Minutes::INT AS sedentary_minutes,
    Calories::INT AS calories
    
FROM daily_activity

WHERE
    id IS NOT NULL;

-- Column Cleaning for daily_sleep table 

CREATE TABLE cleaned_daily_sleep AS 
SELECT DISTINCT
    id::BIGINT AS user_id,
    TO_DATE(SPLIT_PART(Sleep_Day,' ',1), 'MM/DD/YYYY') AS sleep_date,
    Total_Sleep_Records::INT AS total_sleep_records,
    Total_Minutes_Asleep::INT AS total_minutes_asleep,
    Total_Time_in_Bed::INT AS total_time_in_bed,
    -- Row-level Derived Metrics 1: Time awake in bed (Restlessness)
    (Total_Time_in_Bed::INT - Total_Minutes_Asleep::INT) AS time_awake_in_bed,

    -- Row-level Derived Metrics 2: Sleep Efficiency Percentage
    -- We use NULLIF to prevent division by zero errors on invalid rows
    ROUND(
        (total_minutes_asleep::NUMERIC / NULLIF(total_time_in_bed, 0)) * 100,
        2
    ) AS sleep_efficiency_pct

FROM daily_sleep

WHERE
    id IS NOT NULL; 



-- Data Validation 
SELECT 'cleaned_daily_activity' AS table_name, COUNT(*) AS record_count FROM daily_activity
UNION ALL
SELECT 'cleaned_daily_sleep', COUNT(*) FROM daily_sleep;

SELECT * FROM cleaned_daily_activity LIMIT 5; 
SELECT * FROM cleaned_daily_sleep LIMIT 5;

