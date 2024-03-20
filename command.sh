# build models command
dbt build --select base_sales base_product_details --vars '{'is_test_run': 'false'}'
dbt build --select dim_dates stg_sales



# generate model yaml command
dbt run-operation generate_model_yaml --args '{"model_names": ["stg_sales"]}'

dbt run-operation generate_model_yaml --args '{"model_names": ["dim_dates","stg_sales"]}'