SELECT
    op.order_id,
    op.payment_sequential,
    op.payment_type,
    op.payment_installments,
    op.payment_value
FROM {{ ref('stg_order_payments') }} AS op
LEFT JOIN {{ ref('fact_orders') }} AS fo
    ON op.order_id = fo.order_id