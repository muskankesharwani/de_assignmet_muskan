{{ config(
    materialized='table',
    schema='PLANETKART_ANALYTICS',
    database='PLANETKART_DBT'
) }}

WITH source AS (
    SELECT
        customer_id,
        first_name,
        last_name
    FROM {{ ref('stg_customers') }}
)
SELECT
    customer_id,
    {{ format_full_name('first_name', 'last_name') }} AS full_name
FROM source

