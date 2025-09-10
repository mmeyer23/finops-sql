-- 02_views.sql
CREATE OR REPLACE VIEW aws.cost_by_service AS
SELECT
    date_trunc('day', line_item_usage_start_date)::date AS usage_day,
    line_item_product_code AS service,
    sum(line_item_unblended_cost) AS total_cost,
    sum(line_item_usage_amount) AS total_usage
FROM aws.cur
GROUP BY 1,2
ORDER BY 1,2;

CREATE OR REPLACE VIEW aws.daily_trend AS
SELECT
    date_trunc('day', line_item_usage_start_date)::date AS usage_day,
    sum(line_item_unblended_cost) AS total_cost
FROM aws.cur
GROUP BY 1
ORDER BY 1;

-- Rolling 7-day mean/stddev anomaly detection (requires enough history; sample is illustrative)
CREATE OR REPLACE VIEW aws.anomalies AS
WITH daily AS (
    SELECT
        date_trunc('day', line_item_usage_start_date)::date AS usage_day,
        sum(line_item_unblended_cost) AS total_cost
    FROM aws.cur
    GROUP BY 1
),
stats AS (
    SELECT
        usage_day,
        total_cost,
        avg(total_cost) OVER (ORDER BY usage_day ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS mean_7d,
        stddev_pop(total_cost) OVER (ORDER BY usage_day ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS stddev_7d,
        count(*) OVER (ORDER BY usage_day ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS n_7d
    FROM daily
)
SELECT
    usage_day,
    total_cost,
    mean_7d,
    stddev_7d,
    CASE
        WHEN n_7d >= 3 AND stddev_7d IS NOT NULL AND total_cost > mean_7d + 3*stddev_7d THEN true
        ELSE false
    END AS is_anomaly,
    CASE
        WHEN n_7d >= 3 AND stddev_7d IS NOT NULL THEN (total_cost - mean_7d) / NULLIF(stddev_7d,0)
        ELSE NULL
    END AS z_score
FROM stats
ORDER BY usage_day;

CREATE OR REPLACE VIEW aws.top_accounts AS
SELECT
    bill_payer_account_id,
    sum(line_item_unblended_cost) AS total_cost
FROM aws.cur
GROUP BY 1
ORDER BY total_cost DESC;
