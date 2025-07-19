{{ config(
    materialized = 'table',
    schema = 'PLANETKART_ANALYTICS',
    database = 'PLANETKART_DBT'
) }}

WITH params AS (
    SELECT 
        TO_DATE('2010-01-01') AS start_date,
        TO_DATE('2030-12-31') AS end_date
),

dates AS (
    SELECT
        DATEADD(DAY, ROW_NUMBER() OVER () - 1, (SELECT start_date FROM params)) AS date_day
    FROM TABLE(GENERATOR(ROWCOUNT => 1 + DATEDIFF(DAY, (SELECT start_date FROM params), (SELECT end_date FROM params))))
),

holidays AS (
    SELECT TO_DATE(column1) AS holiday_date, column2 AS holiday_name
    FROM VALUES
        -- Add or update your holiday list below:
        ('2010-01-01', 'New Year''s Day'),
        ('2010-01-26', 'Republic Day'),
        ('2010-08-15', 'Independence Day'),
        ('2010-10-02', 'Gandhi Jayanti'),
        ('2010-12-25', 'Christmas Day'),
        ('2024-03-25', 'Holi'),
        ('2024-04-11', 'Eid-ul-Fitr'),
        ('2024-10-31', 'Diwali')
)

SELECT
    d.date_day,
    EXTRACT(year FROM d.date_day)            AS year,
    EXTRACT(month FROM d.date_day)           AS month,
    TO_CHAR(d.date_day, 'Month')             AS month_name,
    EXTRACT(day FROM d.date_day)             AS day,
    EXTRACT(quarter FROM d.date_day)         AS quarter,
    TO_CHAR(d.date_day, 'Day')               AS day_name,
    EXTRACT(dayofweek FROM d.date_day)       AS day_of_week,
    CASE WHEN EXTRACT(dayofweek FROM d.date_day) IN (0,6) THEN 1 ELSE 0 END AS is_weekend,
    WEEK(d.date_day)                         AS week_of_year,
    DATE_TRUNC('month', d.date_day)          AS first_day_of_month,
    DATE_TRUNC('week', d.date_day)           AS week_start_date,
    DATE_TRUNC('quarter', d.date_day)        AS first_day_of_quarter,
    CASE WHEN d.date_day = CURRENT_DATE() THEN 'Y' ELSE 'N' END AS is_today,
    h.holiday_name,
    CASE WHEN h.holiday_date IS NOT NULL THEN 1 ELSE 0 END AS is_holiday
FROM dates d
LEFT JOIN holidays h ON d.date_day = h.holiday_date
ORDER BY d.date_day
