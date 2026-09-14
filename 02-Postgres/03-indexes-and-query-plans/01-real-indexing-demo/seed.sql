-- seed.sql
-- Creates the orders table and populates it with skewed data.

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id serial PRIMARY KEY,
    customer_email text,
    status text,
    country text,
    amount numeric,
    created_at timestamp
);

-- Generates 20 million rows.
-- customer_email: high cardinality, effectively unique per row.
-- status: low cardinality, four fixed values.
-- country: skewed, approximately 80% US with a long tail.

INSERT INTO orders (customer_email, status, country, amount, created_at)
SELECT
    'user' || i || '@example.com' AS customer_email,
    (ARRAY['pending', 'shipped', 'delivered', 'cancelled'])
        [1 + floor(random() * 4)::int] AS status,
    CASE
        WHEN random() < 0.80 THEN 'US'
        WHEN random() < 0.90 THEN 'CA'
        WHEN random() < 0.95 THEN 'UK'
        WHEN random() < 0.98 THEN 'DE'
        ELSE 'FR'
    END AS country,
    round((random() * 500 + 5)::numeric, 2) AS amount,
    now() - (random() * interval '365 days') AS created_at
FROM generate_series(1, 20000000) AS i;

ANALYZE orders;
