{{ config(
    materialized='view',
    schema='PLANETKART_STAGE',
    database='PLANETKART_DBT'
) }}

SELECT
  CUSTOMER_ID AS customer_id,
  FIRST_NAME AS first_name,
  LAST_NAME AS last_name,
  EMAIL AS email,
  REGION_ID AS region_id,
  SIGNUP_DATE AS signup_date
FROM {{ source('raw', 'customers') }}
