WITH customer_orders AS (
    SELECT
        dc.customer_sk,
        dc.customer_id,
        {{ format_full_name('dc.first_name', 'dc.last_name') }} AS full_name,
        dc.planet,
        dc.zone,
        COUNT(DISTINCT fo.order_id) AS order_count,
        SUM(fo.total_revenue) AS total_spend
    FROM {{ ref('fact_orders') }} fo
    JOIN {{ ref('dim_customers') }} dc ON fo.customer_sk = dc.customer_sk
    GROUP BY dc.customer_sk, dc.customer_id, dc.first_name, dc.last_name, dc.planet, dc.zone
),
customer_categories AS (
    SELECT
        fo.customer_sk,
        ARRAY_AGG(DISTINCT fo.main_category) AS categories_bought
    FROM {{ ref('fact_orders') }} fo
    GROUP BY fo.customer_sk
)
SELECT
    co.customer_id,
    co.full_name,
    co.planet,
    co.zone,
    co.order_count,
    co.total_spend,
    cc.categories_bought
FROM customer_orders co
LEFT JOIN customer_categories cc
    ON co.customer_sk = cc.customer_sk
ORDER BY co.total_spend DESC
LIMIT 5
