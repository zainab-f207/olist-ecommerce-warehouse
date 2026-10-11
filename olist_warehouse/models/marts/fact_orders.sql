SELECT
    o.order_id,
    dc.customer_key,
    dd_purchase.date_key AS purchase_date_key,
    dd_estimated.date_key AS estimated_delivery_date_key,
    dd_delivered.date_key AS delivered_customer_date_key,
    o.order_status,
    o.order_delivered_customer_date::date - o.order_estimated_delivery_date::date AS delivery_delay_days
FROM {{ ref('stg_orders') }} AS o
LEFT JOIN {{ ref('dim_customers') }} AS dc
    ON o.customer_id = dc.customer_id
LEFT JOIN {{ ref('dim_date') }} AS dd_purchase
    ON o.order_purchase_date::date = dd_purchase.full_date
LEFT JOIN {{ ref('dim_date') }} AS dd_estimated
    ON o.order_estimated_delivery_date::date = dd_estimated.full_date
LEFT JOIN {{ ref('dim_date') }} AS dd_delivered
    ON o.order_delivered_customer_date::date = dd_delivered.full_date
