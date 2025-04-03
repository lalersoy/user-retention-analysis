# SQL: Product Analytics KPIs for a Health SaaS

This folder contains SQL scripts for generating key product analytics insights from a fictional healthcare SaaS app. The data simulates user events such as logging metrics, reading content, and scheduling consults.

All queries assume the presence of two tables:
- `users` – user-level data (user_id, signup_date, plan_type, channel)
- `events` – timestamped event logs (user_id, timestamp, event_type)

---

## What You'll Find in `retention_kpis.sql`

| Query | Purpose |
|-------|---------|
| **Table creation** | Creates schema for `users` and `events` tables |
| **Manual Import Notes** | Documents CSV import process via pgAdmin GUI |
| **D30 retention** | Flags if user performed any event 30+ days post-signup |
| **D7 retention** | Same logic for a 7-day window |
| **Activation funnel** | Shows how many users: signed up → logged metric → set goal |
| **Feature adoption by plan** | Compares premium vs free usage across features |
| **Cohort analysis** | Tracks retention by signup month |
| **User engagement** | Lists most active users by total and diverse actions |

---

## Notes

- Designed to be compatible with PostgreSQL (tested in pgAdmin 4)
- Simulated event logs generated in the main notebook (`/code/`)
- Can be adapted to BigQuery or Snowflake with minor syntax tweaks

---

For full context, see the Jupyter notebook and dashboards in the root project.

**Contact:** [ersoydenizlal@gmail.com](mailto:ersoydenizlal@gmail.com) 
