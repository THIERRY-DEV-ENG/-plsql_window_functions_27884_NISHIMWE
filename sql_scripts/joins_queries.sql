

  -- INNER JOIN --
SELECT 
    s.sale_id,
    c.name AS customer_name,
    c.region,
    p.name AS product_name,
    p.category,
    s.quantity,
    s.amount,
    s.sale_date
FROM Sales s
INNER JOIN Customers c ON s.customer_id = c.customer_id
INNER JOIN Products p ON s.product_id = p.product_id
ORDER BY s.sale_date DESC
LIMIT 8;


 -- Add inactive customer
INSERT INTO Customers (customer_id, name, email, region) 
VALUES (16, 'Inactive Customer', 'inactive@email.com', 'Kigali');

-- LEFT JOIN
SELECT 
    c.customer_id,
    c.name,
    c.region,
    c.email,
    s.sale_id
FROM Customers c
LEFT JOIN Sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.region, c.name;

 -- Add unsold product
INSERT INTO Products (product_id, name, category, price) 
VALUES (113, 'Unsold Product', 'Electronics', 100000.00);

-- RIGHT JOIN
SELECT 
    p.product_id,
    p.name,
    p.category,
    p.price,
    s.sale_id
FROM Sales s
RIGHT JOIN Products p ON s.product_id = p.product_id
WHERE s.sale_id IS NULL
ORDER BY p.category, p.name;

-- FULL OUTER JOIN
SELECT 
    c.name AS customer_name,
    c.region,
    p.name AS product_name,
    p.category,
    s.amount
FROM Customers c
FULL OUTER JOIN Sales s ON c.customer_id = s.customer_id
FULL OUTER JOIN Products p ON s.product_id = p.product_id
WHERE s.sale_id IS NULL
ORDER BY c.region, p.category;


-- SELF JOIN
SELECT 
    c1.name AS customer_1,
    c2.name AS customer_2,
    c1.region,
    c1.email AS email_1,
    c2.email AS email_2
FROM Customers c1
INNER JOIN Customers c2 ON c1.region = c2.region 
    AND c1.customer_id < c2.customer_id
ORDER BY c1.region, c1.name
LIMIT 12;