\set id random(1, 20000000)

SELECT *
FROM orders
WHERE customer_email = 'user' || :id || '@example.com';
