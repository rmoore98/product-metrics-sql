WITH daily AS (
	SELECT CAST(event_ts AS DATE) AS d,
		   COUNT(DISTINCT user_id) AS dau
	FROM events
	WHERE event_type = 'app_open'
	GROUP BY 1
),
monthly AS (
	SELECT CAST(DATE_TRUNC('month', event_ts) AS DATE) AS month,
		   COUNT(DISTINCT user_id) AS mau
	FROM events
	WHERE event_type = 'app_open'
	GROUP BY 1
)
SELECT m.month,
	   m.mau,
	   ROUND(AVG(d.dau), 1) AS avg_dau,
	   ROUND(AVG(d.dau) / m.mau, 3) AS stickiness
FROM monthly m
JOIN daily d ON CAST(DATE_TRUNC('month', d.d) AS DATE) = m.month
GROUP BY m.month, m.mau
ORDER BY m.month;
