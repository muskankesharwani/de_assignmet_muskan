{{ config(
    materialized='view',
    schema='PLANETKART_STAGE',
    database='PLANETKART_DBT'
) }}

SELECT
  REGION_ID AS region_id,
  PLANET AS planet,
  ZONE AS zone
FROM {{ source('raw', 'regions') }}
