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
    SELECT customer_sk, customer_id FROM {{ ref('dim_customers') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['o.order_id']) }} AS order_fact_sk,
    o.order_id,
    dc.customer_sk,
    o.order_date,
    COUNT(DISTINCT oi.product_id) AS total_products,
    SUM(CAST(oi.quantity AS INTEGER)) AS total_quantity,
    SUM(CAST(oi.quantity AS INTEGER) * CAST(oi.unit_price AS FLOAT)) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN dim_customers dc ON o.customer_id = dc.customer_id
GROUP BY 1, 2, 3, 4
