import random
from datetime import datetime, timedelta
import pandas as pd

random.seed(42)

NUM_USERS = 500
START = datetime(2026, 8, 1)
END = START + timedelta(days=60)
COUNTRIES = ["US", "IN", "BR", "GB", "DE"]

users, events = [], []

for user_id in range(1, NUM_USERS + 1):
    signup = START + timedelta(days=random.randint(0, 59),
                               minutes=random.randint(0, 1439))
    users.append({"user_id": user_id,
                  "country": random.choice(COUNTRIES),
                  "signup_ts": signup})
    events.append({"user_id": user_id, "event_type": "signup", "event_ts": signup})

    p_active = random.uniform(0.05, 0.6)
    day = signup + timedelta(days=1)
    while day < END:
        if random.random() < p_active:
            ts = day.replace(hour=random.randint(0, 23), minute=random.randint(0, 59))
            events.append({"user_id": user_id, "event_type": "app_open", "event_ts": ts})
            if random.random() < 0.3:
                events.append({"user_id": user_id, "event_type": "post",
                               "event_ts": ts + timedelta(minutes=5)})
        p_active *= 0.97
        day += timedelta(days=1)

pd.DataFrame(users).to_csv("data/users.csv", index=False)
pd.DataFrame(events).to_csv("data/events.csv", index=False)
print(f"Generated {len(users)} users and {len(events):,} events")