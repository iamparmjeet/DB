\set id random(1, 100000000)

INSERT INTO orders (customer_email, status, country, amount, created_at)
VALUES ('newest' || :id || '@example.com', 'pending', 'US', 99.99, now());
