SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date
FROM {{ source('public', 'staging_order_reviews') }}