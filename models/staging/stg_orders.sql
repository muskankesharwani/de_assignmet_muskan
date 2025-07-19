{{ config(
    materialized='view',
    schema='PLANETKART_STAGE',
    database='PLANETKART_DBT'
) }}

SELECT
  ORDER_ID AS order_id,
  CUSTOMER_ID AS customer_id,
  order_date_cast AS order_date,
  STATUS AS status
FROM {{ source('raw', 'vw_orders') }}
