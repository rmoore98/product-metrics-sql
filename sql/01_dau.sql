SELECT CAST(event_ts AS DATE) AS activity_date,
	   COUNT(DISTINCT user_id) AS dau
FROM events
WHERE event_type = 'app_open'
GROUP BY 1
ORDER BY 1;
