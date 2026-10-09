-- Engagement funnel:
-- How many users made at least one post? How many made at least 3?

-- Number of posts per user
WITH post_counts AS (
  SELECT
    u.user_id,
    COUNT(e.user_id) AS posts  -- counts only matched post rows, so non-posters get 0
  FROM users AS u
  LEFT JOIN events AS e
    ON e.user_id = u.user_id
    AND e.event_type = 'post'
  GROUP BY u.user_id
),

-- How many users made one post and how many made 3 or more
funnel AS (
  SELECT
    COUNT(*) AS signed_up,
    SUM(CASE WHEN posts >= 1 THEN 1 ELSE 0 END) AS made_first_post,
    SUM(CASE WHEN posts >= 3 THEN 1 ELSE 0 END) AS made_3_posts
  FROM post_counts
)

SELECT
  signed_up,
  made_first_post,
  made_3_posts,
  ROUND(made_first_post / signed_up, 3) AS signup_to_post_rate,
  ROUND(made_3_posts / made_first_post, 3) AS post_to_3_posts_rate
FROM funnel;