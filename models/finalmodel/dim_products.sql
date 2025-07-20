{{ config(
    materialized = 'table',
    schema = 'PLANETKART_ANALYTICS',
    database = 'PLANETKART_DBT'
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['sp.product_id']) }} AS product_sk,
    sp.product_id,
    INITCAP(sp.product_name) AS product_name,
    INITCAP(sp.category) AS category,
    sp.sku AS sku,
    sp.cost AS cost,
    sp.product_name_sku,
    CURRENT_TIMESTAMP AS record_loaded_at
FROM {{ ref('stg_products') }} sp
