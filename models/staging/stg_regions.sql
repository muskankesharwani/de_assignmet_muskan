

SELECT
    TRIM(REGION_ID) AS region_id,
    UPPER(TRIM(PLANET)) AS planet,
    TRIM(ZONE) AS zone
FROM {{ source('raw', 'regions') }}
