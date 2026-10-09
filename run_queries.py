"""Load the generated CSVs into DuckDB and run every query in the sql folder.

How to run from the project folder:
    python generate_data.py
    python run_queries.py
"""
import duckdb

SQL_FILES = [
    "sql/01_dau.sql",
    "sql/02_stickiness.sql",
    "sql/03_retention.sql",
    "sql/04_funnel.sql",
]

# Create (or open) a local DuckDB database file
con = duckdb.connect("metrics.duckdb")

# Load the CSVs as tables, replacing them if they already exist
con.execute("CREATE OR REPLACE TABLE users AS SELECT * FROM read_csv_auto('data/users.csv')")
con.execute("CREATE OR REPLACE TABLE events AS SELECT * FROM read_csv_auto('data/events.csv')")

# Run each query and print the results
for path in SQL_FILES:
    with open(path) as f:
        query = f.read()
    results = con.execute(query).df()
    print(f"\n=== {path} ===")
    print(results.to_string(index=False))

con.close()