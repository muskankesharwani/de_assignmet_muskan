{{ config(
    materialized = 'table',
    schema = 'PLANETKART_ANALYTICS',
    database = 'PLANETKART_DBT'
) }}

SELECT
    sp.product_id              AS product_key,
    INITCAP(sp.product_name)  AS product_name,
    INITCAP(sp.category)      AS category,
    sp.sku                    AS sku,
    sp.cost                   AS cost,
    CURRENT_TIMESTAMP         AS record_loaded_at
FROM {{ ref('stg_products') }} sp
