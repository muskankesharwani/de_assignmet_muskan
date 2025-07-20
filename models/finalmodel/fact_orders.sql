{{ config(
    materialized='table',
    schema='PLANETKART_ANALYTICS',
    database='PLANETKART_DBT'
) }}

WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),
dim_customers AS (
    SELECT customer_sk, customer_id, region_id FROM {{ ref('dim_customers') }}
),
dim_regions AS (
    SELECT region_sk, region_id FROM {{ ref('dim_regions') }}
),
dim_products AS (
    SELECT product_sk, product_id, category FROM {{ ref('dim_products') }}
),
order_item_ranked AS (
    SELECT
        oi.order_id,
        dp.category,
        oi.quantity,
        ROW_NUMBER() OVER (
            PARTITION BY oi.order_id
            ORDER BY oi.quantity DESC, oi.product_id
        ) AS category_rank
    FROM {{ ref('stg_order_items') }} oi
    JOIN {{ ref('dim_products') }} dp ON oi.product_id = dp.product_id
),
order_main_category AS (
    SELECT
        order_id,
        category AS main_category
    FROM order_item_ranked
    WHERE category_rank = 1
)
,
dim_dates AS (
    SELECT * FROM {{ ref('dim_date_analysis') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['o.order_id']) }} AS order_fact_sk,
    o.order_id,
    dc.customer_sk,
    o.order_date,
    o.status,
    o.order_year,
    o.order_month,
    dr.region_sk,
    COUNT(DISTINCT oi.product_id) AS total_products,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,

    -- Advanced date analytics from date dimension
    dd.is_weekend,
    dd.day_name,
    dd.is_holiday,
    dd.holiday_name,
    dd.month_name,
    dd.quarter,
    dd.quarter_name,
    dd.quarter_label,
    dd.week_of_year,

    -- Category analysis
    order_main_category.main_category,

    CURRENT_TIMESTAMP AS record_loaded_at

FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN dim_customers dc ON o.customer_id = dc.customer_id
LEFT JOIN dim_regions dr ON dc.region_id = dr.region_id
LEFT JOIN order_main_category ON o.order_id = order_main_category.order_id
LEFT JOIN dim_dates dd ON o.order_date = dd.date_day
GROUP BY
    o.order_id, dc.customer_sk, o.order_date, o.status, o.order_year, o.order_month,
    dr.region_sk, dd.is_weekend, dd.day_name, dd.is_holiday, dd.holiday_name, dd.month_name,
    dd.quarter, dd.quarter_name, dd.quarter_label, dd.week_of_year, order_main_category.main_category
