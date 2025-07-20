SELECT
    dr.planet,
    dr.zone,
    fo.order_year,
    fo.quarter,
    fo.main_category AS category,
    SUM(fo.total_revenue) AS total_revenue,
    SUM(fo.total_quantity) AS total_quantity,
    COUNT(DISTINCT fo.order_id) AS order_count
FROM {{ ref('fact_orders') }} fo
JOIN {{ ref('dim_regions') }} dr ON fo.region_sk = dr.region_sk
WHERE fo.main_category IS NOT NULL
GROUP BY dr.planet, dr.zone, fo.order_year, fo.quarter, fo.main_category
ORDER BY dr.planet, dr.zone, fo.order_year, fo.quarter, total_revenue DESC

