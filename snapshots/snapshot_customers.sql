{% snapshot snapshot_customers %}

{{
    config(
        target_schema='PLANETKART_ANALYTICS',
        unique_key='customer_id',
        strategy='check',
        check_cols=['first_name', 'last_name', 'email', 'region_id']
    )
}}

SELECT * FROM {{ source('raw', 'customers') }}

{% endsnapshot %}
