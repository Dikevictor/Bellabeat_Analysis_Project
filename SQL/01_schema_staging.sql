-- Creating tables for raw CSV injection 
-- Here I created the daily_activity and daily sleep tables 

DROP TABLE IF EXISTS daily_activity;
DROP TABLE IF EXISTS daily_sleep;

-- 1. Table for Daily Activity

CREATE TABLE daily_activity (
    id                              BIGINT,
    Activity_Date                   VARCHAR(50),
    Total_Steps                     INT,
    Total_Distance                  NUMERIC(10,2),
    Tracker_Distance                NUMERIC(10,2),
    Logged_Activities_Distance      NUMERIC(10,2),
    Very_Active_Distance            NUMERIC(10,2),
    Moderately_Active_Distance      NUMERIC(10,2),
    Light_Active_Distance           NUMERIC(10,2),
    Sedentary_Active_Distance       NUMERIC(10,2),
    Very_Active_Minutes             INT,
    Fairly_Active_Minutes           INT,
    Lightly_Active_Minutes          INT,
    Sedentary_Minutes               INT,
    Calories                        INT
);

-- 2. Table for Daily Sleep 

CREATE TABLE daily_sleep (
    id                             BIGINT,
    Sleep_Day                      VARCHAR(50),
    Total_Sleep_Records            INT,
    Total_Minutes_Asleep           INT,
    Total_Time_in_Bed              INT
);

