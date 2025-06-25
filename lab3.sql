-- Лабораторна робота №3
-- З дисципліни: Бази даних та інформаційні системи
-- Студента групи МІТ-31 Циби Ярослава

-- 1. Вміст таблиці Products
SELECT * FROM products;

-- 2. Вміст Products відсортований за ціною
SELECT * FROM products
ORDER BY price;

-- 3. 10 товарів з найвищими цінами
SELECT * FROM products
ORDER BY price DESC
LIMIT 10;

-- 4. Підрахунок кількості товарів
SELECT COUNT(id) as product_count
FROM products;

-- 5. Кількість всього куплених товарів
SELECT SUM(amount) as bought_products_amount
FROM orders;

-- 6. Середня кількість куплених товарів на покупця
SELECT AVG(amount) as avg_products_per_order
FROM orders;

-- 7. Хто зробив найбільше замовлень?
WITH orders_per_person as 
(SELECT COUNT(o.id) as order_amount, CONCAT(c.name, ' ',c.last_name) customer
FROM orders o
LEFT JOIN customers c ON c.id = o.customer_id
GROUP BY c.id) 
	
SELECT order_amount max_order_amount, customer
FROM orders_per_person
WHERE order_amount = (
	SELECT MAX(order_amount) 
	FROM orders_per_person
);

-- 8. Хто не зробив жодного замовлення?
SELECT * FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE c.id = o.customer_id);

-- 9. Кількість витрачених коштів кожного клієнта
SELECT customer, SUM(order_price) money_spent
FROM(
	SELECT o.id, amount*price order_price, CONCAT(c.name, ' ' ,last_name) customer
	FROM orders o
	INNER JOIN products p on p.id = o.product_id
	RIGHT JOIN customers c on c.id = o.customer_id
)
GROUP BY customer;

-- 10. Клієнти, що робили хоча б одне замовлення на більше ніж 5 товарів
SELECT * FROM customers
WHERE id IN (SELECT customer_id FROM orders WHERE amount > 5);

-- 11. Замовлення з найменшою вартістю
SELECT o.id, price*amount order_price, p.name product, o.amount, CONCAT(c.name, ' ' ,last_name) customer
FROM products p
RIGHT JOIN orders o on o.product_id = p.id
INNER JOIN customers c on c.id = o.customer_id
ORDER BY order_price
LIMIT 1;

-- 12. Найдорожче замовлення
SELECT o.id, price*amount order_price, p.name product, o.amount, CONCAT(c.name, ' ' ,last_name) customer
FROM products p
RIGHT JOIN orders o on o.product_id = p.id
INNER JOIN customers c on c.id = o.customer_id
ORDER BY order_price DESC
LIMIT 1;

-- 13. Замовлення клієнтів з рангами (1 місце - найдорожче)
SELECT CONCAT(c.name, ' ',c.last_name) customer, o.id order_id, p.price*o.amount order_price,
RANK() OVER (PARTITION BY c.id ORDER BY p.price*o.amount DESC) as orders_ranked
FROM orders as o
LEFT JOIN customers c ON c.id = o.customer_id 
LEFT JOIN products p ON p.id = o.product_id;

-- 14. Кількість товарів замовлених клієнтами
SELECT CONCAT(c.name, ' ',c.last_name) customer, orders.id order_id, amount,
SUM(amount) OVER (PARTITION BY customer_id) AS total_amount
FROM orders
JOIN customers c on c.id = orders.customer_id;

-- 15. Звернення до служби підтримки з високим приорітетом (high, urgent)
SELECT *
FROM support_tickets
WHERE priority IN ('high','urgent');

-- 16. Найнижча швидкість відповіді для звернень з високим приорітетом (high, urgent)
SELECT MIN(resolved_date - submit_date) minimal_time
FROM support_tickets
WHERE priority IN ('high','urgent');

-- 17. Клієнти з невирішеними задачами з високим приорітетом (high, urgent)
SELECT *
FROM customers
WHERE id IN(
	SELECT customer_id
	FROM support_tickets
	WHERE priority IN ('high','urgent')
);

-- 18. Клієнти, у яких є замовлення
SELECT *
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE c.id = o.customer_id);

-- 19. Клієнти, що робили як замовлення так і звернення у службу підтримки
SELECT * 
FROM customers
WHERE id IN(
	SELECT customer_id
	FROM orders
	INTERSECT
	SELECT customer_id
	FROM support_tickets
);

-- 20. Список усіх пошт та номерів телефонів
SELECT phone emails_and_phones
FROM customers
UNION
SELECT email emails_and_phones
FROM customers;

-- 21. Клієнти, що робили замовлення, але не робили запитів до служби підтримки
SELECT * FROM
customers
WHERE id in(
	SELECT customer_id
	FROM orders
	EXCEPT
	SELECT customer_id
	FROM support_tickets
);

-- 22. Клієнти, у яких пошти закінчуються на "wsj.com"
SELECT * FROM
customers
WHERE email LIKE '%wsj.com';

-- 23. Кількість замовлень кожного товару кожним клієнтом
SELECT CONCAT(c.name, ' ',c.last_name) customer, p.name product, product_amount
FROM customers c
CROSS JOIN products p
LEFT JOIN (
	SELECT SUM(amount) product_amount, customer_id, product_id
	FROM orders o
	GROUP BY customer_id, product_id
)
ON c.id = customer_id AND p.id = product_id;

-- 24. Клієнт та замовлення зроблені ним
SELECT CONCAT(c.name, ' ',c.last_name) customer, orders.id order_id
FROM customers c
FULL JOIN orders ON c.id = orders.customer_id
ORDER BY customer;

-- 25. Співставлення замовлень з однаковим товаром
SELECT o.id order_id_1, a.id order_id_2, p.name product
FROM orders o
LEFT JOIN products p ON p.id = product_id
INNER JOIN orders a ON o.product_id = a.product_id AND o.id <> a.id;

-- 26. 10 найпопулярніших товарів
SELECT p.name product, COUNT(o.id) orders
FROM orders o
JOIN products p ON p.id = o.product_id
GROUP BY p.name
ORDER BY orders desc
LIMIT 10;

-- 27. Який загальний дохід, отриманий від всіх замовлень?
SELECT SUM(amount*price) total_income
FROM orders o
JOIN products p on o.product_id = p.id;

-- 28. Скільки замовлень було зроблено для кожного продукту?
SELECT p.name product, COUNT(o.id) orders
FROM orders o
RIGHT JOIN products p ON p.id = o.product_id
GROUP BY p.name
ORDER BY orders DESC;

-- 29. Яка загальна кількість звернень до підтримки, поданих кожним клієнтом?
SELECT CONCAT(c.name, ' ',c.last_name) customer, COUNT(s.id)
FROM customers c
FULL JOIN support_tickets s ON c.id = s.customer_id
GROUP BY c.id;

-- 30. Які товари не було замовлено?
SELECT p.name product
FROM products p
WHERE id NOT IN (SELECT product_id
				FROM orders);
				
-- 31. Які товари було замовлено?
SELECT p.name product
FROM products p
WHERE id IN (SELECT product_id
				FROM orders);

-- 32. Яке найсвіжіше замовлення, зроблене клієнтами?
SELECT customer, order_id, amount, product, time
FROM(
	SELECT CONCAT(c.name, ' ',c.last_name) customer, o.id order_id, o.amount, p.name product, o.time,
	DENSE_RANK() OVER (PARTITION BY c.id ORDER BY o.time DESC) AS time_rank
	FROM customers c
	FULL JOIN orders o ON o.customer_id = c.id
	LEFT JOIN products p ON o.product_id = p.id
)
WHERE time_rank = 1;

-- 33. Яка загальна кількість звернень до підтримки?
SELECT COUNT(id) ticket_amount
FROM support_tickets;

-- 34. Яка середня ціна всіх продуктів?
SELECT AVG(price) average_price
FROM products;

-- 35. Яка середня вартість замовлення?
SELECT AVG(price*amount)
FROM orders o
LEFT JOIN products p ON p.id = o.product_id;

-- 36. Які деталі всіх звернень до підтримки, поданих конкретним клієнтом (Francklyn Keady)?
SELECT * 
FROM support_tickets
WHERE customer_id = (SELECT id
		   FROM customers
		   WHERE (CONCAT(name,' ',last_name)) = 'Francklyn Keady');
		   
-- 37. Скільки квитків підтримки наразі не вирішено?
SELECT COUNT(id) open_ticket_amount
FROM support_tickets
WHERE status != 'resolved';

-- 38. Скільки та яких товарів було замовлено за осінь 2024?
SELECT p.name product, SUM(amount) amount
FROM orders o
JOIN products p ON p.id = product_id
WHERE EXTRACT(MONTH FROM time) IN (9,10,11)
AND EXTRACT(YEAR FROM time) = 2024
GROUP BY p.name
ORDER BY amount DESC;

-- 39. Хто не робив замовлення, але звертався до підтримки?
SELECT * 
FROM customers
WHERE id IN (
	SELECT customer_id
	FROM support_tickets
	WHERE customer_id NOT IN (SELECT customer_id FROM orders)
	);
	
-- 40. Які клієнти мають незакриті звернення?
SELECT * 
FROM customers
WHERE id IN(
	SELECT customer_id
	FROM support_tickets
	WHERE status != 'resolved'
);

