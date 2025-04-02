-- ========================================================
-- User Retention Analysis SQL Script: A fictional Health app 
-- ========================================================

-- STEP 1: Table Schemas (users, events) -- you can find the csv files in /data folder
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    plan_type TEXT,
    channel TEXT
);

CREATE TABLE events (
    user_id INT,
    event_type TEXT,
    timestamp TIMESTAMP
);

-- STEP 2: Data Import (done manually in pgAdmin GUI)
--
-- users.csv  → users table
-- events.csv → events table
--
-- Import via: table → Import/Export
-- Format: CSV, Header: Yes, Delimiter: ',', Encoding: UTF-8

-- STEP 3: KPI Queries and Product Analytics

-- D30 Retention per user
SELECT
    u.user_id,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM events e
            WHERE e.user_id = u.user_id
              AND e.timestamp::date >= u.signup_date + INTERVAL '30 days'
        ) THEN 1
        ELSE 0
    END AS retained_d30
FROM users u;

-- D7 Retention per user
SELECT
    u.user_id,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM events e
            WHERE e.user_id = u.user_id
              AND e.timestamp::date >= u.signup_date + INTERVAL '7 days'
        ) THEN 1
        ELSE 0
    END AS retained_d7
FROM users u;

-- Activation Funnel: signed up → log_metric → set_goal
SELECT
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN e1.event_type = 'log_metric' THEN e1.user_id END) AS logged_metric,
    COUNT(DISTINCT CASE WHEN e2.event_type = 'set_goal' THEN e2.user_id END) AS set_goal
FROM users u
LEFT JOIN events e1 ON u.user_id = e1.user_id
LEFT JOIN events e2 ON u.user_id = e2.user_id;

-- Feature Adoption by Plan
SELECT
    u.plan_type,
    e.event_type,
    COUNT(*) AS event_count
FROM events e
JOIN users u ON u.user_id = e.user_id
GROUP BY u.plan_type, e.event_type
ORDER BY u.plan_type, e.event_type;

-- Retention Cohorts by Signup Month
SELECT
    DATE_TRUNC('month', u.signup_date) AS cohort_month,
    COUNT(*) AS total_users,
    SUM(CASE 
            WHEN EXISTS (
                SELECT 1 FROM events e
                WHERE e.user_id = u.user_id
                  AND e.timestamp::date >= u.signup_date + INTERVAL '30 days'
            ) THEN 1 ELSE 0
        END) AS retained_d30
FROM users u
GROUP BY cohort_month
ORDER BY cohort_month;

-- Events per User (Engagement Metric)
SELECT
    user_id,
    COUNT(*) AS total_events,
    COUNT(DISTINCT event_type) AS unique_event_types
FROM events
GROUP BY user_id
ORDER BY total_events DESC
LIMIT 10;