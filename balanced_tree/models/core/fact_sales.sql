{{
    config(
        materialized='table'
    )
}}

WITH sales AS (
    SELECT *
    FROM {{ ref("stg_sales") }}
),
product_detail AS (
    SELECT *
    FROM {{ ref("stg_product_details") }}
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
    sales.member AS member,
    sales.txn_id AS transaction_id,
    sales.start_txn_time AS transaction_timestamp
FROM sales
INNER JOIN product_detail
ON sales.prod_id = product_detail.product_id