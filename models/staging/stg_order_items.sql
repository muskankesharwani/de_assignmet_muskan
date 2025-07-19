{{ config(
    materialized='view',
    schema='PLANETKART_STAGE',
    database='PLANETKART_DBT'
) }}

SELECT
  ORDER_ID AS order_id,
  PRODUCT_ID AS product_id,
  QUANTITY AS quantity,
  UNIT_PRICE AS unit_price
FROM {{ source('raw', 'order_items') }}
