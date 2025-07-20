{{ config(
    materialized='table',
    schema='PLANETKART_ANALYTICS',
    database='PLANETKART_DBT'
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['sr.region_id']) }} AS region_sk,
    sr.region_id,
    sr.zone,
    sr.planet,
    CURRENT_TIMESTAMP AS record_loaded_at
FROM {{ ref('stg_regions') }} sr
