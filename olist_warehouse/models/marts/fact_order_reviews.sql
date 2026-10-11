SELECT
    ROW_NUMBER() OVER (
        ORDER BY r.review_id, r.order_id, r.review_creation_date
    ) AS review_key,
    r.review_id,
    r.order_id,
    r.review_score,
    dd.date_key AS review_creation_date_key
FROM {{ ref('stg_order_reviews') }} AS r
LEFT JOIN {{ ref('fact_orders') }} AS fo
    ON r.order_id = fo.order_id
LEFT JOIN {{ ref('dim_date') }} AS dd
    ON r.review_creation_date::date = dd.full_date