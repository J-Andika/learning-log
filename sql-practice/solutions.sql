-- KUNCI JAWABAN. Jangan diedit. Bandingkan hasilmu dengan: python3 check.py
-- Konvensi: hasil dibandingkan sebagai himpunan baris (urutan bebas), float dibulatkan 2 desimal.
-- "revenue" = qty * unit_price * (1 - discount), hanya orders.status = 'completed' kecuali disebut lain.

-- Q1
SELECT count(*) FROM customers;

-- Q2
SELECT city, count(*) AS n FROM customers GROUP BY city ORDER BY n DESC, city LIMIT 5;

-- Q3
SELECT round(sum(oi.qty * oi.unit_price * (1 - oi.discount)), 2) AS revenue
FROM orders o JOIN order_items oi ON oi.order_id = o.id
WHERE o.status = 'completed';

-- Q4
SELECT p.name, round(sum(oi.qty * oi.unit_price * (1 - oi.discount)), 2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
WHERE o.status = 'completed'
GROUP BY p.id, p.name
ORDER BY revenue DESC, p.name
LIMIT 10;

-- Q5
SELECT count(*) AS customers_without_orders
FROM customers c LEFT JOIN orders o ON o.customer_id = c.id
WHERE o.id IS NULL;

-- Q6
SELECT strftime('%Y-%m', o.order_date) AS ym,
       round(sum(oi.qty * oi.unit_price * (1 - oi.discount)), 2) AS revenue
FROM orders o JOIN order_items oi ON oi.order_id = o.id
WHERE o.status = 'completed' AND o.order_date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY ym ORDER BY ym;

-- Q7
WITH per_order AS (
  SELECT o.id, o.customer_id, sum(oi.qty * oi.unit_price * (1 - oi.discount)) AS rev
  FROM orders o JOIN order_items oi ON oi.order_id = o.id
  WHERE o.status = 'completed' GROUP BY o.id, o.customer_id
)
SELECT c.segment, round(avg(po.rev), 2) AS aov
FROM per_order po JOIN customers c ON c.id = po.customer_id
GROUP BY c.segment ORDER BY c.segment;

-- Q8
WITH cat AS (
  SELECT p.category, sum(oi.qty * oi.unit_price * (1 - oi.discount)) AS rev
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.id
  JOIN products p ON p.id = oi.product_id
  WHERE o.status = 'completed'
  GROUP BY p.category
)
SELECT category, round(rev, 2) AS revenue,
       round(100.0 * rev / sum(rev) OVER (), 2) AS pct
FROM cat ORDER BY revenue DESC;

-- Q9
SELECT c.id, c.name, count(DISTINCT o.id) AS n_orders
FROM customers c JOIN orders o ON o.customer_id = c.id
WHERE o.status = 'completed'
GROUP BY c.id, c.name
HAVING count(DISTINCT o.id) >= 3
ORDER BY n_orders DESC, c.id
LIMIT 10;

-- Q10
WITH m AS (
  SELECT strftime('%Y-%m', o.order_date) AS ym, sum(oi.qty * oi.unit_price * (1 - oi.discount)) AS rev
  FROM orders o JOIN order_items oi ON oi.order_id = o.id
  WHERE o.status = 'completed' AND o.order_date BETWEEN '2025-01-01' AND '2025-12-31'
  GROUP BY ym
)
SELECT ym, round(rev, 2) AS revenue, round(sum(rev) OVER (ORDER BY ym), 2) AS running_total
FROM m ORDER BY ym;

-- Q11
WITH q AS (
  SELECT p.category, p.name, sum(oi.qty) AS units
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.id
  JOIN products p ON p.id = oi.product_id
  WHERE o.status = 'completed'
  GROUP BY p.category, p.name
), r AS (
  SELECT category, name, units,
         row_number() OVER (PARTITION BY category ORDER BY units DESC, name) AS rn
  FROM q
)
SELECT category, name, units FROM r WHERE rn = 1 ORDER BY category;

-- Q12
WITH per_cust AS (
  SELECT o.customer_id, count(*) AS n
  FROM orders o WHERE o.status = 'completed'
  GROUP BY o.customer_id
)
SELECT round(100.0 * sum(CASE WHEN n > 1 THEN 1 ELSE 0 END) / count(*), 2) AS repeat_rate_pct
FROM per_cust;

-- Q13
WITH per_cust AS (
  SELECT o.customer_id, sum(oi.qty * oi.unit_price * (1 - oi.discount)) AS rev
  FROM orders o JOIN order_items oi ON oi.order_id = o.id
  WHERE o.status = 'completed' GROUP BY o.customer_id
)
SELECT count(*) AS customers_above_avg
FROM per_cust WHERE rev > (SELECT avg(rev) FROM per_cust);

-- Q14
WITH m AS (
  SELECT strftime('%Y-%m', o.order_date) AS ym, sum(oi.qty * oi.unit_price * (1 - oi.discount)) AS rev
  FROM orders o JOIN order_items oi ON oi.order_id = o.id
  WHERE o.status = 'completed' AND o.order_date BETWEEN '2025-01-01' AND '2025-12-31'
  GROUP BY ym
)
SELECT ym, round(rev, 2) AS revenue,
       round(100.0 * (rev - lag(rev) OVER (ORDER BY ym)) / lag(rev) OVER (ORDER BY ym), 2) AS mom_pct
FROM m ORDER BY ym;

-- Q15
WITH cohort AS (
  SELECT id FROM customers WHERE strftime('%Y-%m', signup_date) = '2025-01'
), months(m) AS (VALUES ('2025-01'), ('2025-02'), ('2025-03'))
SELECT months.m AS month, count(DISTINCT o.customer_id) AS active_customers
FROM months
LEFT JOIN orders o
  ON strftime('%Y-%m', o.order_date) = months.m
 AND o.status = 'completed'
 AND o.customer_id IN (SELECT id FROM cohort)
GROUP BY months.m ORDER BY months.m;

-- Q16
WITH first_order AS (
  SELECT customer_id, min(order_date) AS fo
  FROM orders WHERE status = 'completed' GROUP BY customer_id
)
SELECT strftime('%Y-%m', fo) AS first_month, count(*) AS customers
FROM first_order GROUP BY first_month ORDER BY first_month;

-- Q17
SELECT count(*) AS never_sold
FROM products p
WHERE NOT EXISTS (
  SELECT 1 FROM order_items oi JOIN orders o ON o.id = oi.order_id
  WHERE oi.product_id = p.id AND o.status = 'completed'
);

-- Q18
SELECT p.category,
       round(sum(oi.qty * oi.unit_price * (1 - oi.discount)), 2) AS revenue,
       round(avg(oi.discount) * 100, 2) AS avg_discount_pct
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
WHERE o.status = 'completed'
GROUP BY p.category ORDER BY revenue DESC;

-- Q19
WITH first_order AS (
  SELECT customer_id, min(order_date) AS fo
  FROM orders WHERE status = 'completed' GROUP BY customer_id
)
SELECT c.segment,
       round(avg(julianday(f.fo) - julianday(c.signup_date)), 2) AS avg_days_to_first_order
FROM first_order f JOIN customers c ON c.id = f.customer_id
GROUP BY c.segment ORDER BY c.segment;

-- Q20
WITH per_cust AS (
  SELECT o.customer_id, sum(oi.qty * oi.unit_price * (1 - oi.discount)) AS rev
  FROM orders o JOIN order_items oi ON oi.order_id = o.id
  WHERE o.status = 'completed' GROUP BY o.customer_id
), ranked AS (
  SELECT c.city, c.id, c.name, per_cust.rev,
         row_number() OVER (PARTITION BY c.city ORDER BY per_cust.rev DESC, c.id) AS rn
  FROM per_cust JOIN customers c ON c.id = per_cust.customer_id
)
SELECT city, id, name, round(rev, 2) AS revenue FROM ranked WHERE rn = 1 ORDER BY city;
