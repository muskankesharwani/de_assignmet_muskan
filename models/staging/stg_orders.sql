
SELECT
    TRIM(ORDER_ID) AS order_id,
    TRIM(CUSTOMER_ID) AS customer_id,
     order_date,
    LOWER(TRIM(STATUS)) AS status,

    -- fetching year and month for analysis
    EXTRACT(year FROM order_date) AS order_year,
    EXTRACT(month FROM order_date ) AS order_month,
    
    -- adding quality condition to make sure status is correct
    CASE 
      WHEN LOWER(TRIM(STATUS)) IN ('completed', 'pending', 'shipped', 'cancelled') THEN TRUE
      ELSE FALSE
    END AS is_valid_status

FROM {{ source('raw', 'orders') }}
