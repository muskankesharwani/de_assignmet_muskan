SELECT
    dr.planet,
    dr.zone,
    fo.main_category AS category,
    COUNT(DISTINCT fo.order_id) AS total_orders,
    SUM(fo.total_revenue) AS total_revenue,
    CASE WHEN COUNT(DISTINCT fo.order_id) > 0
         THEN SUM(fo.total_revenue) / COUNT(DISTINCT fo.order_id)
         ELSE 0 END AS avg_order_value
FROM {{ ref('fact_orders') }} fo
JOIN {{ ref('dim_regions') }} dr ON fo.region_sk = dr.region_sk
WHERE fo.main_category IS NOT NULL
GROUP BY dr.planet, dr.zone, fo.main_category
ORDER BY dr.planet, dr.zone, avg_order_value DESC

