-- BOOKS TABLE 
DROP TABLE IF EXISTS books;
CREATE TABLE books(
book_id SERIAL PRIMARY KEY,      
title VARCHAR(100),
author VARCHAR(100),
genre VARCHAR(50),
published_year INT ,
price NUMERIC(10,2),
stock INT
);

-- CUSTOMERS TABLE
DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
customer_id SERIAL PRIMARY KEY,
name VARCHAR(100),
email VARCHAR(100),
phone INT ,
city VARCHAR(50),
country VARCHAR(70)
);

-- ORDERS TABLE
DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
order_id SERIAL PRIMARY KEY,
customer_id  INT REFERENCES customers(customer_id),
book_id INT REFERENCES books(book_id),
order_date DATE,
quantity INT,
total_amount NUMERIC(10,2)
);

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

COPY books(book_id, title, author, genre, published_year, price, stock)
FROM 'E:\Data Analysis\SQL\Online Books Store Project\Books.csv'
CSV HEADER;

COPY customers(customer_id, name, email, phone, city, country)
FROM 'E:\Data Analysis\SQL\Online Books Store Project\Customers.csv'
CSV HEADER;

COPY orders(order_id, customer_id, book_id, order_date, quantity, total_amount)
FROM 'E:\Data Analysis\SQL\Online Books Store Project/orders.csv'
CSV HEADER;


-- 1. Retrieve all books in the "Fiction" genre
SELECT book_id, title,published_year
FROM books
WHERE genre='Fiction';

-- 2. Find books published after the year 1950
SELECT book_id, title,genre
FROM books
WHERE published_year >1950;

-- 3. List all customers from Canada
SELECT Name,city, country
FROM customers
WHERE country='Canada';

-- 4. Show orders placed in November 2023
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5. Retrieve the total stock of books available
SELECT SUM(stock) AS total_stock
FROM books;

-- 6. Find the details of the most expensive book
SELECT * 
FROM books 
ORDER BY price DESC 
LIMIT 1;

-- 7. Show all customers who ordered more than 1 quantity of a book
SELECT customer_id,book_id,quantity
FROM orders
WHERE quantity>1
ORDER BY quantity ASC ;

-- 8. Retrieve all orders where the total amount exceeds $20
SELECT * FROM orders
WHERE total_amount>20
ORDER BY total_amount ASC ;
-- 9. List all genres available in the Books table
SELECT DISTINCT genre 
FROM books;
-- 10. Find the book with the lowest stock
SELECT book_id,title,stock
FROM books
-- WHERE STOCK>0
ORDER BY stock ASC LIMIT 1;

-- 11. Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue
FROM orders;

							-- Advance Queries
							
-- 1. Retrieve the total number of books sold for each genre
SELECT b.Genre, SUM(o.quantity) AS total_quantity
FROM  orders o 
JOIN books b ON o.book_id=b.book_id
GROUP BY genre
ORDER BY total_quantity DESC ;

-- 2. Find the average price of books in the "Fantasy" genre
SELECT ROUND(AVG(price),2) AS "Average price"
FROM books
WHERE genre='Fantasy';

-- 3. List customers who have placed at least 2 orders
SELECT c.customer_id, c.name, COUNT(o.order_id) AS "Total Orders"
FROM orders o
JOIN customers c ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.name
HAVING COUNT(order_id)>=2
ORDER BY "Total Orders" ASC;

-- 4. Find the most frequently ordered book
SELECT b.title, o.book_id, COUNT(o.order_id) as total_ordered
FROM ORDERS o 
JOIN books b ON b.book_id=o.book_id
GROUP BY o.book_id, b.title
ORDER BY COUNT(order_id) DESC 
LIMIT 1;

-- 5. Show the top 3 most expensive books of 'Fantasy' genre
SELECT title,genre,price
FROM books
WHERE genre='Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 6. Retrieve the total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) AS "Total Quantity Sold"
FROM orders o
JOIN books b ON b.book_id=o.book_id
GROUP BY b.author 
ORDER BY SUM(o.quantity) DESC;

-- 7. List the cities where customers who spent over $300 are located
SELECT DISTINCT c.city
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount>300;

-- 8. Find the customer who spent the most on orders
SELECT c.customer_id,c.name ,SUM(o.total_amount) AS total_spend
FROM customers c 
JOIN orders o ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY total_spend DESC
LIMIT 1;

-- 9. Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(quantity),0) AS order_quantity, (b.stock-COALESCE(SUM(quantity),0) ) AS remaining_stock
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id;
