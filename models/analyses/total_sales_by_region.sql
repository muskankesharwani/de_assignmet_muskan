
SELECT
    dr.planet,
    dr.zone,
    SUM(fo.total_revenue) AS total_revenue
FROM {{ ref('fact_orders') }} fo
JOIN {{ ref('dim_regions') }} dr
    ON fo.region_sk = dr.region_sk
GROUP BY dr.planet, dr.zone
ORDER BY total_revenue DESC

