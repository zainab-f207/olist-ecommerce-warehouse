SELECT
    TO_CHAR(full_date, 'YYYYMMDD')::INTEGER AS date_key,
    full_date,
    EXTRACT(DAY FROM full_date)::INTEGER AS day,
    EXTRACT(MONTH FROM full_date)::INTEGER AS month,
    EXTRACT(YEAR FROM full_date)::INTEGER AS year,
    EXTRACT(DOW FROM full_date)::INTEGER AS day_of_week
FROM (
    SELECT
        generate_series(
            '2016-01-01'::date,
            '2018-12-31'::date,
            '1 day'::interval
        )::date AS full_date
) AS dates