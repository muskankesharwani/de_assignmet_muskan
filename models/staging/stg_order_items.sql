SELECT
    TRIM(ORDER_ID) AS order_id,
    TRIM(PRODUCT_ID) AS product_id,
    TRY_CAST(QUANTITY AS INT) AS quantity,
    TRY_CAST(UNIT_PRICE AS FLOAT) AS unit_price,

    -- Total price for this order line, can be used later to help understand customers who are paying us more
    (TRY_CAST(QUANTITY AS INT) * TRY_CAST(UNIT_PRICE AS FLOAT)) AS total_line_amount,

    -- Is quantity and unit_price valid provided in sheet is valid : indirecltky i am making sure we have right data
    CASE
      WHEN TRY_CAST(QUANTITY AS INT) > 0 AND TRY_CAST(UNIT_PRICE AS FLOAT) >= 0 THEN TRUE
      ELSE FALSE
    END AS is_valid_line

FROM {{ source('raw', 'order_items') }}
