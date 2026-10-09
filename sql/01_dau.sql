-- Daily active users:
-- How many unique users open the app each day?

SELECT
  CAST(event_ts AS DATE) AS activity_date,
  COUNT(DISTINCT user_id) AS dau
FROM events
WHERE event_type = 'app_open'
GROUP BY activity_date
ORDER BY activity_date;