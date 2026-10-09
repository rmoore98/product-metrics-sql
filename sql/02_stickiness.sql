-- Stickiness (DAU / MAU):
-- For each month, on average, what percent of the month's users opened the app each day?

-- Daily active users, with the month each day belongs to
WITH daily AS (
  SELECT
    CAST(event_ts AS DATE) AS activity_date,
    CAST(DATE_TRUNC('month', event_ts) AS DATE) AS activity_month,
    COUNT(DISTINCT user_id) AS dau
  FROM events
  WHERE event_type = 'app_open'
  GROUP BY activity_date, activity_month
),

-- Average daily active users for each month
avg_daily AS (
  SELECT
    activity_month,
    AVG(dau) AS avg_dau
  FROM daily
  GROUP BY activity_month
),

-- Monthly active users
monthly AS (
  SELECT
    CAST(DATE_TRUNC('month', event_ts) AS DATE) AS activity_month,
    COUNT(DISTINCT user_id) AS mau
  FROM events
  WHERE event_type = 'app_open'
  GROUP BY activity_month
)

SELECT
  m.activity_month,
  m.mau,
  ROUND(a.avg_dau, 1) AS avg_dau,
  ROUND(a.avg_dau / m.mau, 3) AS stickiness
FROM monthly AS m
JOIN avg_daily AS a
  ON a.activity_month = m.activity_month
ORDER BY m.activity_month;
