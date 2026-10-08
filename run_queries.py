from pathlib import Path
import duckdb

con = duckdb.connect("metrics.duckdb")
con.execute("CREATE OR REPLACE TABLE users  AS SELECT * FROM read_csv_auto('data/users.csv')")
con.execute("CREATE OR REPLACE TABLE events AS SELECT * FROM read_csv_auto('data/events.csv')")

for path in sorted(Path("sql").glob("*.sql")):
    print(f"\n=== {path.name} ===")
    print(con.execute(path.read_text()).df().head(15).to_string(index=False))