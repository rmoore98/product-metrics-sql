# Product Metrics with SQL

Analyzing user engagement for a simulated social app using SQL. A Python script generates a realistic event log (signups, app opens, and posts for 500 users over 60 days), which is loaded into DuckDB and analyzed with SQL to calculate the kinds of product metrics used by teams at companies like Meta.

**Tools:** Python, pandas, DuckDB, SQL

## How to run

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS/Linux
source .venv/bin/activate
pip install -r requirements.txt
python generate_data.py
python run_queries.py
```

## Metrics

| File | Metric | Question it answers |
|------|--------|---------------------|
| `01_dau.sql` | Daily active users | How many unique users open the app each day? |
| `02_stickiness.sql` | DAU / MAU | How often do monthly users come back? |
| `03_retention.sql` | Cohort retention | Of users who signed up in a given week, what share returned 1, 7, and 14 days later? |
| `04_funnel.sql` | Engagement funnel | How many users go from signup → first post → 3+ posts? |

## Key findings

- **Stickiness rose from 13.4% in August to 16.0% in September.** The average user was active in September than August.
- **Day-1 retention ranged from about 24% to 40%** across complete cohorts. Day-7 retention was mostly between 20% and 30%, so most new users did not use the app the day after signing up, and only about 1 in 4 returned a week later.
- **67.2% of users made at least one post, but only 42.9% of those made three or more.** Users were more likely to not return after their first than to never post at all. 

## Limitations

- **Recent cohorts look smaller than they actually are.** The data ends September 29, so users who signed up in late September didn't have 7 or 14 days to return yet. A production version would likely only include cohorts within the full measurement window.
- **The first cohort looks smaller than it actually is.** The data starts on Saturday, August 1, but the week started on Monday, so the first cohort only includes two days of signups.
- **Exact-day retention is noisy.** The retention query only counts a user if they opened the app on exactly day 1, 7, or 14. Counting users active any time in a range, like days 7–13, would give steadier numbers.
- The data is simulated, so the findings describe the synthetic behavior rather than real users.

## What I learned

The relationship between stickiness and retention is not one-to-one. While retention is an essential metric, stickiness provides additional context about how often users return rather than just whether users return. On the technical side, using CTEs allowed me to combine daily-user and monthly-user information into one query rather than nest several subqueries, making the query easier to read and debug.

Next time, I would implement the rolling-window approach described in the limitations section. This would provide a clearer view of weekly returns rather than activity on specific dates. The tradeoff is waiting longer for the full window to pass and losing some precision about the specific days users returned.
