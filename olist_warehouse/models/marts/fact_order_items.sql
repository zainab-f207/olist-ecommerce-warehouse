SELECT
    ROW_NUMBER() OVER (ORDER BY oi.order_id, oi.order_item_id) AS order_item_key,
    oi.order_id,
    oi.order_item_id,
    dp.product_key,
    ds.seller_key,
    dc.customer_key,
    dd.date_key AS purchase_date_key,
    oi.price,
    oi.freight_value
FROM {{ ref('stg_order_items') }} AS oi
LEFT JOIN {{ ref('stg_orders') }} AS o
    ON oi.order_id = o.order_id
LEFT JOIN {{ ref('dim_products') }} AS dp
    ON oi.product_id = dp.product_id
LEFT JOIN {{ ref('dim_sellers') }} AS ds
    ON oi.seller_id = ds.seller_id
LEFT JOIN {{ ref('dim_customers') }} AS dc
    ON o.customer_id = dc.customer_id
LEFT JOIN {{ ref('dim_date') }} AS dd
    ON o.order_purchase_date = dd.full_date