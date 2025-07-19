{{ config(
    materialized='table',
    schema='PLANETKART_ANALYTICS',
    database='PLANETKART_DBT'
) }}

WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),
regions AS (
    SELECT * FROM {{ ref('stg_regions') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['customers.customer_id']) }} AS customer_sk,
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customers.email,
    customers.signup_date,
    customers.region_id,
    regions.planet,
    regions.zone
FROM customers
LEFT JOIN regions ON customers.region_id = regions.region_id
