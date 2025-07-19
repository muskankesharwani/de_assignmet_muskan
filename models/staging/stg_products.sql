{{ config(
    materialized='view',
    schema='PLANETKART_STAGE',
    database='PLANETKART_DBT'
) }}

SELECT
  PRODUCT_ID AS product_id,
  PRODUCT_NAME AS product_name,
  SKU AS sku,
  CATEGORY AS category,
  COST AS cost
FROM {{ source('raw', 'products') }}
