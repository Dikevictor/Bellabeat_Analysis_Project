-- Query 3: Sleep Hygiene and Restlessness

/*
In this query we will calculate average sleep efficiency for each user AND 
the average time in bed

GOAL: Identify the user will low sleep efficiency and restlessness marketing targeting 

ACTION: Introduce evening wind-down programs and stretches 
and smart sleep alarm to help reduce nighttime restlessness

*/

-- CTE 1: Sleep Efficiency 
WITH sleep_efy_restlness AS (
    SELECT 
        user_id,
            ROUND(AVG(total_minutes_asleep)::NUMERIC, 1) AS avg_tot_min_asleep,
            ROUND(AVG(total_time_in_bed)::NUMERIC, 1) AS avg_tot_time_in_bed,
            ROUND(AVG(total_time_in_bed)::NUMERIC, 1) - ROUND(AVG(total_minutes_asleep)::NUMERIC, 1) AS avg_restlessness,

            ROUND(
                AVG(total_minutes_asleep)::NUMERIC / AVG(total_time_in_bed)
                , 2) * 100 
            AS user_sleep_efficiency
    
    FROM cleaned_daily_sleep

    GROUP BY
        user_id

),

-- CTE 2: Sleep Persona
sleep_personas AS (
    SELECT 
        user_id,
        avg_restlessness,
        user_sleep_efficiency,

    -- Sleep persona
        CASE 
            WHEN user_sleep_efficiency > 90 THEN 'OPTIMUM SLEEP'
            WHEN user_sleep_efficiency < 75 THEN 'HIGHLY RESTLESS'
            ELSE 'MODERATE RESTLESSNESS'
        END AS sleep_persona

    FROM sleep_efy_restlness

    ORDER BY user_sleep_efficiency
)

SELECT 
    sleep_persona,
    ROUND(AVG(avg_restlessness)::NUMERIC, 1) AS persona_avg_restlessness,
    ROUND(AVG(user_sleep_efficiency)::NUMERIC, 1) AS persona_avg_efficiency,
    COUNT(user_id)
    
FROM sleep_personas

GROUP BY 
    sleep_persona

ORDER BY 
    persona_avg_restlessness DESC;

/*
-- RESULT SET

[
  {
    "sleep_persona": "HIGHLY RESTLESS",
    "persona_avg_restlessness": "238.3",
    "persona_avg_efficiency": "66.0",
    "count": "2"
  },
  {
    "sleep_persona": "MODERATE RESTLESSNESS",
    "persona_avg_restlessness": "30.0",
    "persona_avg_efficiency": "86.5",
    "count": "2"
  },
  {
    "sleep_persona": "OPTIMUM SLEEP",
    "persona_avg_restlessness": "24.1",
    "persona_avg_efficiency": "94.2",
    "count": "20"
  }
]

Copy and paste this result set into Gemini and ask for a Scatter Plot with Size Encoding (Bubble Chart). 
This work because it clearly shows the inverse relationships
*/
