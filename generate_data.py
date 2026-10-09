"""Generate a fake event log for a social app: 500 users over 60 days.

How to run from the project folder:
    python generate_data.py
"""
import random
from datetime import datetime, timedelta

import pandas as pd

random.seed(42)  # Using the same seed reproduces the same results later

NUM_USERS = 500
START = datetime(2026, 8, 1)
END = START + timedelta(days=60)  # ends at midnight on Sept 30, so Sept 29 is the last full day
COUNTRIES = ["US", "IN", "BR", "GB", "DE"]

users = []
events = []

for user_id in range(1, NUM_USERS + 1):
    signup = START + timedelta(days=random.randint(0, 59),
                               minutes=random.randint(0, 1439))
    users.append({"user_id": user_id,
                  "country": random.choice(COUNTRIES),
                  "signup_ts": signup})
    events.append({"user_id": user_id, "event_type": "signup", "event_ts": signup})

    # Each user opens the app between 5% and 60% on a given day
    p_active = random.uniform(0.05, 0.6)

    # Each day after signup has a random chance of the user opening the app
    day = signup + timedelta(days=1)
    while day < END:
        if random.random() < p_active:
            ts = day.replace(hour=random.randint(0, 23), minute=random.randint(0, 59))
            events.append({"user_id": user_id, "event_type": "app_open", "event_ts": ts})

            # 30% of users will create a post 5 minutes after opening (=5 for simplification)
            if random.random() < 0.3:
                events.append({"user_id": user_id, "event_type": "post",
                               "event_ts": ts + timedelta(minutes=5)})

        # Users' chance of opening the app drops 3% each day (lose interest)
        p_active *= 0.97
        day += timedelta(days=1)

pd.DataFrame(users).to_csv("data/users.csv", index=False)
pd.DataFrame(events).to_csv("data/events.csv", index=False)
print(f"Generated {len(users)} users and {len(events)} events")