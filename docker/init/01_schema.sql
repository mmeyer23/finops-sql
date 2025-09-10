-- 01_schema.sql
CREATE SCHEMA IF NOT EXISTS aws;

DROP TABLE IF EXISTS aws.cur CASCADE;

CREATE TABLE aws.cur (
    bill_payer_account_id      text,
    product_region             text,
    line_item_product_code     text,
    line_item_usage_type       text,
    line_item_operation        text,
    line_item_resource_id      text,
    line_item_usage_start_date date,
    line_item_usage_end_date   date,
    line_item_usage_amount     numeric,
    pricing_unit               text,
    line_item_unblended_cost   numeric
);

-- Load sample CSV (available inside container via docker-entrypoint-initdb.d)
COPY aws.cur (
    bill_payer_account_id,
    product_region,
    line_item_product_code,
    line_item_usage_type,
    line_item_operation,
    line_item_resource_id,
    line_item_usage_start_date,
    line_item_usage_end_date,
    line_item_usage_amount,
    pricing_unit,
    line_item_unblended_cost
)
FROM '/docker-entrypoint-initdb.d/datasets/aws_cur_sample.csv'
WITH (FORMAT csv, HEADER true);
