USE sakila;
SELECT * FROM actor LIMIT 10;
SELECT * FROM film LIMIT 10;
USE sakila;

SELECT
    f.film_id,
    f.title,
    l.name AS language_name
FROM film f
INNER JOIN language l
    ON f.language_id = l.language_id
LIMIT 10;

SELECT
    r.rental_id,
    r.rental_date,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM rental r
INNER JOIN customer c
    ON r.customer_id = c.customer_id
LIMIT 10;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    r.rental_id,
    r.rental_date
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
ORDER BY c.customer_id
LIMIT 30;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    r.rental_id,
    r.rental_date
FROM customer c
RIGHT JOIN rental r
    ON c.customer_id = r.customer_id
ORDER BY r.rental_id
LIMIT 30;

-- Average payment amount (just to see it)
SELECT AVG(amount) AS avg_payment_amount
FROM payment;

-- Customers whose total paid > average single payment amount
SELECT
    p.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_paid
FROM payment p
INNER JOIN customer c
    ON p.customer_id = c.customer_id
GROUP BY p.customer_id, c.first_name, c.last_name
HAVING total_paid > (
    SELECT AVG(amount)
    FROM payment
)
ORDER BY total_paid DESC;

SELECT
    f.film_id,
    f.title
FROM film f
WHERE f.film_id NOT IN (
    SELECT DISTINCT i.film_id
    FROM inventory i
    INNER JOIN rental r
        ON i.inventory_id = r.inventory_id
);

-- Film count per actor
SELECT
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(*) AS film_count
FROM actor a
INNER JOIN film_actor fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, actor_name;

-- Now use that in a subquery to get the max
SELECT
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(*) AS film_count
FROM actor a
INNER JOIN film_actor fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, actor_name
HAVING film_count = (
    SELECT MAX(film_cnt)
    FROM (
        SELECT
            COUNT(*) AS film_cnt
        FROM film_actor
        GROUP BY actor_id
    ) AS t
);

SELECT
    SUM(amount) AS total_revenue
FROM payment;

SELECT
    AVG(amount) AS avg_payment_amount
FROM payment;

SELECT
    p.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_paid,
    COUNT(*) AS number_of_payments
FROM payment p
INNER JOIN customer c
    ON p.customer_id = c.customer_id
GROUP BY
    p.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_paid DESC
LIMIT 20;

SELECT
    SUM(amount) / COUNT(DISTINCT customer_id) AS avg_revenue_per_customer
FROM payment;


CREATE OR REPLACE VIEW vw_customer_payment_summary AS
SELECT
    p.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_paid,
    COUNT(*) AS payment_count,
    MIN(p.payment_date) AS first_payment_date,
    MAX(p.payment_date) AS last_payment_date
FROM payment p
INNER JOIN customer c
    ON p.customer_id = c.customer_id
GROUP BY
    p.customer_id,
    c.first_name,
    c.last_name;

SELECT *
FROM vw_customer_payment_summary
ORDER BY total_paid DESC
LIMIT 10;

CREATE OR REPLACE VIEW vw_film_rental_stats AS
SELECT
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS rental_count,
    SUM(p.amount) AS total_revenue
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
LEFT JOIN payment p
    ON r.rental_id = p.rental_id
GROUP BY
    f.film_id,
    f.title;

SELECT *
FROM vw_film_rental_stats
ORDER BY total_revenue DESC
LIMIT 10;

SHOW INDEX FROM payment;
SHOW INDEX FROM rental;
SHOW INDEX FROM customer;

CREATE INDEX idx_payment_payment_date
ON payment (payment_date);

CREATE INDEX idx_payment_customer_id
ON payment (customer_id);


