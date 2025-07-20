{{ config(
    materialized='table',
    schema='PLANETKART_ANALYTICS',
    database='PLANETKART_DBT'
) }}

WITH orders AS (
    SELECT
        order_id,
        customer_sk,
        total_revenue
    FROM {{ ref('fact_orders') }}
),
customers AS (
    SELECT
        customer_sk,
        region_id,
        planet,
        zone
    FROM {{ ref('dim_customers') }}
)

SELECT
    c.planet,
    c.zone,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_revenue) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_sk = c.customer_sk
GROUP BY c.planet, c.zone
