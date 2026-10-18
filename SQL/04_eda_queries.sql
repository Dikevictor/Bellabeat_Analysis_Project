-- Query #1 AND #2: Relationship between user sedentary Persona and Sleep Efficiency

/*
Here we want to see what the activity level looks like 
for a user in day across the sedentary_minutes, 
lightly_active_minutes, fairly_active_minutes, very_active_minutes.

Output: 
1. We will get the percentage that a user spends sedentary 
2. Categorizing the users in two persona based on sedentary level

Business Impact: Know the demographic of user with sedentary
lifestyle that marketing with target

Action: 
1. Customized in-app notification or gentile vibration from 
the leaf or the Time device to encourage activity
*/ 

-- CTE 1: Sedentary Percentage
WITH user_activity_summary AS ( 
    
    SELECT 
    user_id,
    ROUND(AVG(sedentary_minutes)::NUMERIC, 1) AS avg_sedentary_mins,
    ROUND(AVG(lightly_active_minutes)::NUMERIC, 1) AS avg_lightly_active_mins,
    ROUND(AVG(fairly_active_minutes)::NUMERIC, 1) AS avg_fairly_active_mins,
    ROUND(AVG(very_active_minutes)::NUMERIC, 1) AS avg_very_active_mins,

    ROUND(
            (AVG(sedentary_minutes)::NUMERIC / 
             NULLIF(AVG(lightly_active_minutes) + AVG(fairly_active_minutes) 
             + AVG(very_active_minutes) + AVG(sedentary_minutes),0
                    )
            ) * 100,
        2
        ) AS sedentary_pct

FROM cleaned_daily_activity 

GROUP BY 
    user_id

),

-- CTE 2: Activity_Persona
persona_pct AS (
    SELECT
        user_id,
        sedentary_pct,

        CASE 
            WHEN sedentary_pct > 80 THEN 'HIGHLY SEDENTARY'
            WHEN sedentary_pct < 70 THEN 'ACTIVE'
            ELSE 'MODERATELY SEDENTARY'
        END AS activity_persona 

    FROM user_activity_summary

),

-- CTE 3: Counting Persona
count_of_persona AS (
    SELECT 
        activity_persona,
        COUNT(user_id) AS Persona_count
        

    FROM persona_pct

    GROUP BY
        activity_persona
    ORDER BY 
        persona_count DESC

),


-- CTE 4: Sleep Efficiency
efficient_sleep AS (
    SELECT
        user_id,
        ROUND(AVG(total_minutes_asleep)::NUMERIC, 1) AS avg_tot_min_asleep,
        ROUND(AVG(total_time_in_bed)::NUMERIC, 1) AS avg_tot_time_in_bed,

        ROUND(
            AVG(total_minutes_asleep)::NUMERIC / AVG(total_time_in_bed)
            , 2) * 100 
        AS user_sleep_efficiency
    FROM cleaned_daily_sleep

    GROUP BY
        user_id
),

-- CTE 5: Sedentary_pct Vs Sleep efficiency 

sedentary_sleep AS (
    SELECT 
    pp.user_id,
    sedentary_pct,
    user_sleep_efficiency,
    activity_persona

FROM persona_pct pp
    LEFT JOIN efficient_sleep es 
    ON pp.user_id = es.user_id

WHERE user_sleep_efficiency IS NOT NULL

ORDER BY 
    sedentary_pct DESC

)

SELECT 
    activity_persona,
    ROUND(AVG(sedentary_pct), 2) AS persona_sedentary_percentage,
    ROUND(AVG(user_sleep_efficiency), 2) AS persona_sleep_efficiency,
    COUNT(user_id) AS Persona_size

FROM Sedentary_sleep

GROUP BY
    activity_persona
ORDER BY 
    persona_sleep_efficiency DESC;



