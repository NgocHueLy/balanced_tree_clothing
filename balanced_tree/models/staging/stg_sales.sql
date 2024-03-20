{{
    config(
        materialized='view'
    )
}}

WITH sales AS (
    SELECT *
    FROM {{ ref("base_sales") }}
),
product_detail AS (
    SELECT *
    FROM {{ ref("base_product_details") }}
),
date AS (
    SELECT *
    FROM {{ ref("dim_dates") }}
)

SELECT
    sales.prod_id AS product_id,
    product_detail.product_name AS product_name,
    product_detail.style_name AS style_name,
    product_detail.segment_name AS segment_name,
    product_detail.category_name AS category_name,
    sales.qty AS quantity,
    sales.price AS price,
    sales.discount AS discount_percentage,
    sales.qty * sales.price AS revenue,
    sales.member AS member,
    sales.txn_id AS transaction_id,
    sales.start_txn_time AS transaction_datetime,
    date.month,
    date.month_name,
    date.weekday_name,
    date.calendar_week
FROM sales
INNER JOIN product_detail
ON sales.prod_id = product_detail.product_id
INNER JOIN date
ON sales.transaction_date = date.date
