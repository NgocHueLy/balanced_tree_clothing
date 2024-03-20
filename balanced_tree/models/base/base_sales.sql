{{
    config(
        materialized='view'
    )
}}


SELECT 
  * ,
  DATE(start_txn_time) AS transaction_date
FROM {{ source('base', 'sales') }}

{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}