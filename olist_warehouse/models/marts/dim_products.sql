SELECT
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_key,
    p.product_id,
    p.product_category_name,
    ct.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM {{ ref('stg_products') }} AS p
LEFT JOIN {{ source('public', 'staging_category_translation') }} AS ct
    ON p.product_category_name = ct.product_category_name