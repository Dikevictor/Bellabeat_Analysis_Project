-- Query 4: User Activity Adherence and Consistency

/*

The query of two types
1. We want to calculate bench mark hit rate i.e 
the percentage days when users hit the 8k daily step bench out of total logged days
2. the weekly active days per user to know when user

GOAL
1. Bench mark hit rate will tell me at which point user stop logging steps giving 
us insights into when to engage them to prevent drop off or add automated logging to our products
2. The weekly active days will tell us how often user use the tracking devices. 

ACTION
Both metrics show us at what point users drop off in using the devices,
so we can optimize push notifications to before that time to encourage 
use devices to continue to track progress toward health goal. 

*/

-- CTE 1: Total Logged Days
WITH logged_days AS (
    SELECT DISTINCT
        user_id,
        activity_date,
        total_steps

    FROM cleaned_daily_activity

    GROUP BY 
        user_id,
        activity_date,
        total_steps
),

-- CTE 2: Calculating Bench
benchmark_cal AS (
SELECT 
    user_id,
    COUNT(activity_date) AS total_logged_days,
    COUNT(CASE WHEN total_steps >= 8000 THEN 1 END) AS total_days_above_8k,
    ROUND (
        (COUNT(CASE WHEN total_steps >= 8000 THEN 1 END)::NUMERIC/COUNT(activity_date)) * 100
        , 2
        ) AS benchmark_count

FROM logged_days

GROUP BY 
    user_id

),

-- CTE 3: Weekly_consistency
Weekly_consistency AS (
SELECT 
    user_id, 
    DATE_TRUNC('week', activity_date) AS activity_week,
    COUNT(DISTINCT activity_date) AS active_days_per_week

FROM logged_days

GROUP BY
    user_id,
    activity_week

),

-- CTE 4: Combining benchmark metrics and weekly averages
combination AS (
SELECT
    bc.user_id,
    bc.total_logged_days,
    bc.total_days_above_8k,
    bc.benchmark_count,
    ROUND(
        AVG(wc.active_days_per_week), 1
    ) AS avg_weekly_active_days

FROM benchmark_cal bc
JOIN Weekly_consistency wc
ON  bc.user_id = wc.user_id

GROUP BY 
    bc.user_id,
    bc.total_logged_days,
    bc.total_days_above_8k,
    bc.benchmark_count

ORDER BY 
    bc.benchmark_count DESC,
    avg_weekly_active_days DESC

)

SELECT
    COUNT(bc.user_id) AS User_Count,
    ROUND(AVG(bc.total_logged_days), 1) AS avg_total_logged_days,
    ROUND(AVG(bc.total_days_above_8k), 1) AS avg_total_days_above_8k,
        CASE 
            WHEN bc.benchmark_count >= 75 THEN 'HIGH ACHIEVERS'
            WHEN bc.benchmark_count < 40 THEN 'LOW_ADHERENCE'
            ELSE 'CONSISTENT MOVERS'
        END AS benchmark_cohort

FROM benchmark_cal bc
JOIN Weekly_consistency wc
ON  bc.user_id = wc.user_id

GROUP BY
    benchmark_cohort

ORDER BY 
    benchmark_cohort


/* 

RESULT SET

[
  {
    "user_count": "56",
    "avg_total_logged_days": "29.2",
    "avg_total_days_above_8k": "15.3",
    "benchmark_cohort": "CONSISTENT MOVERS"
  },
  {
    "user_count": "39",
    "avg_total_logged_days": "30.4",
    "avg_total_days_above_8k": "26.7",
    "benchmark_cohort": "HIGH ACHIEVERS"
  },
  {
    "user_count": "58",
    "avg_total_logged_days": "29.3",
    "avg_total_days_above_8k": "3.4",
    "benchmark_cohort": "LOW_ADHERENCE"
  }
]

Ask for the visualization with Bubble chat. 

*/
