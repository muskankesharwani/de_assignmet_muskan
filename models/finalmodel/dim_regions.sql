{{ config(
    materialized='table',
    schema='PLANETKART_ANALYTICS',
    database='PLANETKART_DBT'
) }}

SELECT
    sr.region_id AS region_key,
    sr.zone AS zone,
    sr.planet AS planet,
    CURRENT_TIMESTAMP AS record_loaded_at
FROM {{ ref('stg_regions') }} sr
