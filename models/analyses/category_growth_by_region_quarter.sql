WITH category_quarter_sales AS (
    SELECT
        dr.planet,
        dr.zone,
        fo.order_year,
        fo.quarter,
        fo.main_category AS category,
        SUM(fo.total_revenue) AS total_revenue
    FROM {{ ref('fact_orders') }} fo
    JOIN {{ ref('dim_regions') }} dr ON fo.region_sk = dr.region_sk
    WHERE fo.main_category IS NOT NULL
    GROUP BY dr.planet, dr.zone, fo.order_year, fo.quarter, fo.main_category
)
SELECT
    *,
    total_revenue
      - LAG(total_revenue) OVER (
          PARTITION BY planet, zone, category
          ORDER BY order_year, quarter
        ) AS revenue_growth_vs_prev_quarter,
    CASE
      WHEN LAG(total_revenue) OVER (PARTITION BY planet, zone, category ORDER BY order_year, quarter) > 0
      THEN ROUND(
          100 * (
            total_revenue
            - LAG(total_revenue) OVER (PARTITION BY planet, zone, category ORDER BY order_year, quarter)
          ) / LAG(total_revenue) OVER (PARTITION BY planet, zone, category ORDER BY order_year, quarter)
      , 2)
      ELSE NULL
    END AS pct_growth_vs_prev_quarter
FROM category_quarter_sales
ORDER BY planet, zone, category, order_year, quarter

