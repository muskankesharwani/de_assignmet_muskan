WITH region_orders AS (
    SELECT
        dr.planet,
        dr.zone,
        fo.order_year,
        fo.quarter,
        SUM(fo.total_revenue) AS total_revenue,
        COUNT(DISTINCT fo.order_id) AS total_orders
    FROM {{ ref('fact_orders') }} fo
    JOIN {{ ref('dim_regions') }} dr ON fo.region_sk = dr.region_sk
    GROUP BY dr.planet, dr.zone, fo.order_year, fo.quarter
)
SELECT
    *,
    total_revenue
      - LAG(total_revenue) OVER (
          PARTITION BY planet, zone ORDER BY order_year, quarter
        ) AS revenue_growth_vs_prev_quarter
FROM region_orders
ORDER BY planet, zone, order_year, quarter
