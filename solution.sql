-- 1. total orders per customer
SELECT c.customer_id, c.name, COUNT(o.order_id) AS orders_count
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- 2. customers above average orders
SELECT customer_id, name, orders_count
FROM (
    SELECT c.customer_id, c.name, COUNT(o.order_id) AS orders_count
    FROM Customers c
    LEFT JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.name
) t
WHERE orders_count > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(order_id) AS cnt
        FROM Orders
        GROUP BY customer_id
    ) avg_t
);

-- 3. index on customer_id
CREATE INDEX idx_cust_id ON Orders(customer_id);

-- 4. transaction for new order and items
BEGIN TRANSACTION;

INSERT INTO Orders (order_id, customer_id, order_date, total_amount)
VALUES (10, 2, '2026-04-10', 120.00);

INSERT INTO Order_Items (item_id, order_id, product_name, quantity, price)
VALUES
(1, 10, 'USB Cable', 2, 15.00),
(2, 10, 'Headset', 1, 90.00);

COMMIT;
-- if any error happens, run: ROLLBACK;

-- 5. cumulative qty by day
SELECT day, qty, SUM(qty) OVER (ORDER BY day) AS cumQty
FROM demand;
