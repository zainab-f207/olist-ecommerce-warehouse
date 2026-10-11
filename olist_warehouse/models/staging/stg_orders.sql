SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::date AS order_purchase_date,
    order_estimated_delivery_date,
    order_delivered_customer_date
FROM {{ source('public', 'staging_orders') }}