SELECT
    TRIM(CUSTOMER_ID) AS customer_id,
    TRIM(FIRST_NAME) AS first_name,
    TRIM(LAST_NAME) AS last_name,
    LOWER(TRIM(EMAIL)) AS email,
    TRIM(REGION_ID) AS region_id,
    TRY_CAST(SIGNUP_DATE AS DATE) AS signup_date,

    -- signup month and days since signup, helps understanding the trends later, 
    --email check to make sure we don't have wrong email, under assumption email is a text field
    DATE_TRUNC('month', TRY_CAST(SIGNUP_DATE AS DATE)) AS signup_month,
    DATEDIFF('day', TRY_CAST(SIGNUP_DATE AS DATE), CURRENT_DATE) AS days_since_signup,
    CASE 
        WHEN EMAIL LIKE '%@%.%' THEN TRUE ELSE FALSE
    END AS is_valid_email

FROM {{ source('raw', 'customers') }}
