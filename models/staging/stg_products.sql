SELECT
    TRIM(PRODUCT_ID) AS product_id,
    TRIM(PRODUCT_NAME) AS product_name,
    TRIM(SKU) AS sku,
    LOWER(TRIM(CATEGORY)) AS category,
    TRY_CAST(COST AS FLOAT) AS cost,

    -- adding it for easy lookup/search
    CONCAT(TRIM(PRODUCT_NAME), ' (', TRIM(SKU), ')') AS product_name_sku

FROM {{ source('raw', 'products') }}
