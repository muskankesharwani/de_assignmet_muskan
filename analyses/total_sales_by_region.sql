
SELECT
    dr.region_name,
    SUM(fo.revenue) AS total_revenue
FROM {{ ref('fact_orders') }} fo
JOIN {{ ref('dim_regions') }} dr
    ON fo.region_id = dr.region_id
GROUP BY dr.region_name
ORDER BY total_revenue DESC
