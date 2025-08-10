-- Customers table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT
);

-- Categories table
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Products table
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    category_id INT REFERENCES Categories(category_id)
);
-- Orders table (renamed to CustomerOrders)
CREATE TABLE CustomerOrders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    order_date DATE NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL
);

-- OrderDetails table
CREATE TABLE OrderDetails (
    orderdetail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES CustomerOrders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL
);


-- Insert customers
INSERT INTO Customers (name, email, phone, address) VALUES
('Amit Sharma', 'amit@example.com', '9876543210', 'Delhi, India'),
('Priya Mehta', 'priya@example.com', '9876501234', 'Mumbai, India'),
('Rahul Verma', 'rahul@example.com', '9123456780', 'Bangalore, India');

-- Insert categories
INSERT INTO Categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books');

-- Insert products
INSERT INTO Products (product_name, price, category_id) VALUES
('Laptop', 55000.00, 1),
('Smartphone', 20000.00, 1),
('T-shirt', 799.00, 2),
('Novel', 499.00, 3);

-- Insert orders
INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2025-08-01', 55000.00),
(2, '2025-08-02', 20800.00),
(3, '2025-08-03', 1298.00);

-- Insert order details
INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES
(1, 1, 1),  -- Amit bought 1 Laptop
(2, 2, 1),  -- Priya bought 1 Smartphone
(3, 3, 1),  -- Rahul bought 1 T-shirt
(3, 4, 1);  -- Rahul bought 1 Novel
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT 
    o.order_id,
    c.name AS customer_name,
    p.product_name,
    od.quantity,
    o.order_date,
    o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id;
SELECT 
    c.name AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;
SELECT 
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;
SELECT 
    cat.category_name,
    p.product_name,
    p.price
FROM Products p
JOIN Categories cat ON p.category_id = cat.category_id
ORDER BY cat.category_name, p.product_name;
SELECT 
    cat.category_name,
    p.product_name,
    p.price
FROM Products p
JOIN Categories cat ON p.category_id = cat.category_id
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM Products p2
    WHERE p2.category_id = p.category_id
);
SELECT 
    p.product_name,
    SUM(od.quantity) AS total_sold
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;
SELECT 
    c.name AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;