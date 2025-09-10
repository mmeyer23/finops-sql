# cloud-cost-sql (MVP: AWS)

SQL-first cloud cost analytics you can run locally in minutes.

**Why?** Native tools are UI-heavy and hard to customize. This repo gives you **drop-in SQL views** over AWS Cost & Usage Report (CUR)-style data so engineers and analysts can query costs directly.

## Quickstart

Requirements: Docker

```bash
git clone <your-fork-url>
cd cloud-cost-sql
docker-compose up -d
# wait ~10s for init, then connect to Postgres
psql -h localhost -U cloud -d cloudcost
# password: cloudpw
```

Now try some queries:

```sql
-- Daily total cost
SELECT * FROM aws.daily_trend;

-- Cost by service per day
SELECT * FROM aws.cost_by_service WHERE usage_day >= CURRENT_DATE - 30;

-- Top accounts by spend
SELECT * FROM aws.top_accounts;

-- Potential anomalies (spikes based on 7-day rolling z-score)
SELECT * FROM aws.anomalies ORDER BY usage_day DESC;
```

## What’s Included

- **Sample dataset** (synthetic, small) that mimics AWS CUR columns
- **Postgres schema** (`aws.cur`) auto-loaded via Docker init
- **Reusable views**:
  - `aws.cost_by_service`
  - `aws.daily_trend`
  - `aws.anomalies` (rolling 7-day z-score)
  - `aws.top_accounts`

## Roadmap

- GCP (BigQuery export) + Azure (Cost Management exports)
- dbt packages for warehouse-native installs
- Prebuilt Power BI / Superset / Metabase dashboards
- FinOps-friendly dimensions (tags, savings plans, RI coverage)

## Troubleshooting

**I don’t see the views (`aws.daily_trend`, etc.)**  
Postgres runs files in `docker-entrypoint-initdb.d` **only on first init** of the data volume. If your container initialized before the views file existed, do one of the following:

- **Apply views without data loss:**
  ```bash
  ./scripts/apply_views.sh
  # or: make apply-views


## Contributing

Issues and PRs welcome! Please open an issue to discuss changes before large PRs.

## License

MIT
