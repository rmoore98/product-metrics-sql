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

 - **Stickiness rose from 13.4% in August to 16.0% in September**, meaning the average user was active on more days of the month.
 - **Day-1 retention ranged from about 24% to 40%** across complete cohorts, with day-7 retention mostly between 20% and 30%.
 - **67.2% of users made at least one post**, and **42.9% of those went on to make three or more**, showing the biggest drop-off is between signing up and posting for the first time.

 ## Limitations

 - **Recent cohorts look artificially low.** The data ends September 30, so users who signed up in late September haven't had 7 or 14 days to return yet. A production version would exclude cohorts that haven't reached the full measurement window.
 - **The first cohort is partial.** Weeks start on Monday, but the data starts on Saturday, August 1, so the first cohort only includes two days of signups.
 - **Exact-day retention is noisy.** Retention checks activity on exactly day 1, 7, or 14, which can produce odd results in small cohorts (for example, day-14 retention higher than day-7). A rolling window, such as “active any time in days 7–13,” would be more stable.
 - The data is simulated, so the findings describe the generator's behavior rather than real users.

 ## What I learned

 The relationship between stickiness and retention is not one-to-one. While retention is an essential metric, stickiness provides additional context about how often users return rather than just whether users return. On the technical side, using CTEs allowed me to combine daily-user and monthly-user information into one query rather than nest several subqueries, making the query easier to read and debug.

 Next time, I would implement the rolling-window approach described in the limitations section. This would provide a clearer view of weekly returns rather than activity on specific dates. The tradeoff is waiting longer for the full window to pass and losing some precision about the specific days users returned.
