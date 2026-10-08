WITH post_counts AS (
    SELECT u.user_id, COUNT(e.user_id) AS posts
    FROM users u
    LEFT JOIN events e
        ON e.user_id = u.user_id AND e.event_type = 'post'
    GROUP BY u.user_id
)
SELECT
    COUNT(*) AS signed_up,
    COUNT(*) FILTER (WHERE posts >= 1) AS made_first_post,
    COUNT(*) FILTER (WHERE posts >= 3) AS made_3_posts,
    ROUND(COUNT(*) FILTER (WHERE posts >= 1) * 1.0 / COUNT(*), 3) AS signup_to_post_rate,
    ROUND(COUNT(*) FILTER (WHERE posts >= 3) * 1.0
          / COUNT(*) FILTER (WHERE posts >= 1), 3) AS post_to_3_posts_rate
FROM post_counts;