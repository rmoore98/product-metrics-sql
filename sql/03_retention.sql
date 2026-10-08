WITH signups AS (
	SELECT user_id, CAST(event_ts AS DATE) AS signup_date
	FROM events
	WHERE event_type = 'signup'
),
activity AS (
	SELECT DISTINCT user_id, CAST(event_ts AS DATE) AS active_date
	FROM events
	WHERE event_type = 'app_open'
)
SELECT
	CAST(DATE_TRUNC('week', s.signup_date) AS DATE) AS cohort_week,
	COUNT(DISTINCT s.user_id) AS cohort_size,
	ROUND(COUNT(DISTINCT CASE WHEN a.active_date = s.signup_date + 1 THEN s.user_id END) * 1.0
		  / COUNT(DISTINCT s.user_id), 3) AS d1_retention,
	ROUND(COUNT(DISTINCT CASE WHEN a.active_date = s.signup_date + 7 THEN s.user_id END) * 1.0
		  / COUNT(DISTINCT s.user_id), 3) AS d7_retention,
	ROUND(COUNT(DISTINCT CASE WHEN a.active_date = s.signup_date + 14 THEN s.user_id END) * 1.0
		  / COUNT(DISTINCT s.user_id), 3) AS d14_retention
FROM signups s
LEFT JOIN activity a ON a.user_id = s.user_id
GROUP BY 1
ORDER BY 1;
