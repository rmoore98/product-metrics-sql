-- Cohort retention:
-- For each signup week, what percent of users opened the app 1 day, 7 days, and 14 days after signing up?

-- Each user's signup date
WITH signups AS (
  SELECT
    user_id,
    CAST(event_ts AS DATE) AS signup_date
  FROM events
  WHERE event_type = 'signup'
),

-- Each day a user opened the app 
activity AS (
  SELECT DISTINCT
    user_id,
    CAST(event_ts AS DATE) AS active_date
  FROM events
  WHERE event_type = 'app_open'
),

-- Did users come back on day 1, 7, and 14? (1 = yes, 0 = no)
user_returns AS (
  SELECT
    s.user_id,
    s.signup_date,
    MAX(CASE WHEN a.active_date = s.signup_date + 1 THEN 1 ELSE 0 END) AS returned_d1,
    MAX(CASE WHEN a.active_date = s.signup_date + 7 THEN 1 ELSE 0 END) AS returned_d7,
    MAX(CASE WHEN a.active_date = s.signup_date + 14 THEN 1 ELSE 0 END) AS returned_d14
  FROM signups AS s
  LEFT JOIN activity AS a
    ON a.user_id = s.user_id
  GROUP BY s.user_id, s.signup_date
)

-- Percent of users from each signup week that came back on day 1, 7, and 14
SELECT
  CAST(DATE_TRUNC('week', signup_date) AS DATE) AS cohort_week,
  COUNT(*) AS cohort_size,
  ROUND(AVG(returned_d1), 3) AS d1_retention,
  ROUND(AVG(returned_d7), 3) AS d7_retention,
  ROUND(AVG(returned_d14), 3) AS d14_retention
FROM user_returns
GROUP BY cohort_week
ORDER BY cohort_week;