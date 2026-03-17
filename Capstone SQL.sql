CREATE DATABASE bookstore;
USE bookstore;
SHOW TABLES;

# QUERIES DI CONTROLLO
DESCRIBE TABLE books;
SELECT * FROM books;

DESCRIBE TABLE customers;
SELECT * FROM customers;

DESCRIBE TABLE orders;
SELECT * FROM orders;

# controlli integrità referenziale
# primary keys uniche
SELECT Customer_ID, COUNT(*)
FROM customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT Order_ID, COUNT(*)
FROM orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT Book_ID, COUNT(*)
FROM books
GROUP BY Book_ID
HAVING COUNT(*) > 1;

# primary keys senza valori NULL
SELECT *
FROM customers
WHERE Customer_ID IS NULL;

SELECT *
FROM orders
WHERE Order_ID IS NULL;

SELECT *
FROM books
WHERE Book_ID IS NULL;

# valori distinti
SELECT DISTINCT Genre
FROM books;

SELECT DISTINCT Country
FROM customers;

# # TOP 20 LIBRI PIU' VENDUTI IN GENERALE
SELECT 
	b.Title, 
    SUM(o.Quantity) as Total_Sales
FROM books b
INNER JOIN orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Title
ORDER BY Total_Sales DESC
LIMIT 20; 

# TOP 20 dei libri che hanno fatturato di più
SELECT 
    b.Title,
    SUM(o.Quantity * b.Price) AS revenue
FROM books b
JOIN orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Title
ORDER BY revenue DESC
LIMIT 20;
 
# Quale genere è il più venduto?
SELECT
	b.Genre, 
    SUM(o.Quantity) as Total_Sales
FROM books b
INNER JOIN orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Total_Sales DESC;
# il genere più venduto è il mystery

# quale genere fattura di più?
SELECT
	b.Genre, 
    SUM(o.Quantity * b.Price) as Total_Revenue
FROM books b
INNER JOIN orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Total_Revenue DESC;  # il genere che fattura di più è il Romance

# top 10 libri ROMANCE che portano più fatturato
SELECT 
	b.Title,
    b.Author,
    SUM(o.Quantity * b.Price) as Books_Revenue
FROM   books b  
INNER JOIN orders o
ON b.Book_ID = o.Book_ID
WHERE b.Genre = 'Romance'
GROUP BY b.Title, b.Author
ORDER BY Books_Revenue DESC
LIMIT 10;

# top 10 AUTORI ROMANCE che portano più fatturato
SELECT 
    b.Author,
    SUM(o.Quantity * b.Price) as Books_Revenue
FROM   books b  
INNER JOIN orders o
ON b.Book_ID = o.Book_ID
WHERE b.Genre = 'Romance'
GROUP BY b.Author
ORDER BY Books_Revenue DESC
LIMIT 10;

# TOP 5 dei libri mystery
SELECT 
	b.Title,
    b.Author,
    SUM(o.Quantity) as Books_Sold
FROM   books b  
INNER JOIN orders o
ON b.Book_ID = o.Book_ID
WHERE b.Genre = 'Mystery'
GROUP BY b.Title, b.Author
ORDER BY Books_Sold DESC
LIMIT 5;

#TOP 5 AUTORI e vendite e genere di ciascuno
SELECT 
	b.Author,
    b.Genre,
    SUM(o.Quantity) as Total_Sales
FROM books b
JOIN orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Author, b.Genre
ORDER BY Total_Sales DESC
LIMIT 5;

#TOP 5 AUTORI che hanno portato più fatturato
SELECT 
	b.Author,
    b.Genre,
    SUM(o.Quantity * b.Price) as Total_Revenue
FROM books b
JOIN orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Author, b.Genre
ORDER BY Total_Revenue DESC
LIMIT 5; 

# QUERIES GEOGRAFICHE
SET SQL_SAFE_UPDATES = 1;
UPDATE customers
SET Country = 'USA'
WHERE Country IN (
'Alabama',
'Alaska',
'Arizona',
'Arkansas',
'California',
'Colorado',
'Connecticut',
'Delaware',
'Florida',
'Georgia',
'Hawaii',
'Idaho',
'Illinois',
'Indiana',
'Iowa',
'Kansas',
'Kentucky',
'Louisiana',
'Maine',
'Maryland',
'Massachusetts',
'Michigan',
'Minnesota',
'Mississippi',
'Missouri',
'Montana',
'Nebraska',
'Nevada',
'New Hampshire',
'Jersey',
'New Mexico',
'New York',
'North Carolina',
'North Dakota',
'Ohio',
'Oklahoma',
'Oregon',
'Pennsylvania',
'Rhode Island',
'South Carolina',
'South Dakota',
'Tennessee',
'Texas',
'Utah',
'Vermont',
'Virginia',
'Washington',
'West Virginia',
'Wisconsin',
'Wyoming', 
'United States Minor Outlying Islands');

# Quanti clienti singoli per nazione?
SELECT 
    Country,
    COUNT(Customer_ID) AS total_customers
FROM customers
GROUP BY Country
ORDER BY total_customers DESC;

# Quale nazione COMPRA di più?
SELECT 
	c.Country,
    SUM(o.Quantity) as Books_Sold
FROM customers c
JOIN orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Country
ORDER BY Books_Sold DESC; # Gli USA comprano di più

# Quale è FATTURATO delle nazioni?
SELECT 
	c.Country,
    SUM(o.Quantity * b.Price) as Revenue
FROM customers c
JOIN orders o
ON c.Customer_ID = o.Customer_ID
JOIN books b
ON o.Book_ID = b.Book_ID
GROUP BY c.Country
ORDER BY Revenue DESC;

# Spesa media per cliente per nazione
SELECT 
    c.Country,
    AVG(o.Quantity * b.Price) AS avg_spending
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY c.Country;

# Quali generi fatturano di più in ogni nazione?
SELECT 
	c.Country,
    b.Genre,
    SUM(o.Quantity * b.Price) as Books_Revenue
FROM customers c
JOIN orders o
ON c.Customer_ID = o.Customer_ID
JOIN books b
ON o.Book_ID = b.Book_ID
GROUP BY c.Country, b.Genre
ORDER BY Books_Revenue DESC;

# Autore più venduto per nazione
SELECT 
    c.Country,
    b.Author,
    SUM(o.Quantity) AS total_sold
FROM orders o
JOIN customers c
ON o.Customer_ID = c.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY c.Country, b.Author
ORDER BY total_sold DESC;

# QUERIES TEMPORALI
# numero ordini per anno
SELECT 
    YEAR(Order_Date) AS year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY year
ORDER BY year;

# fatturato per anno
SELECT
	YEAR(o.Order_Date) as Year,
    SUM(o.Quantity * b.Price) as revenue
FROM orders o    
JOIN books b
ON o.Book_ID = b.Book_ID
GROUP BY Year
ORDER BY Year;

# stagionalità
SELECT 
    MONTHNAME(Order_Date) AS MONTH,
    COUNT(*) AS orders
FROM orders
GROUP BY MONTH
ORDER BY orders DESC;

# fatturato per MESE 
SELECT
	YEAR(o.Order_Date) as Year,
    MONTH(o.Order_Date) as Month,
    SUM(o.Quantity * b.Price) as revenue
FROM orders o    
JOIN books b
ON o.Book_ID = b.Book_ID
GROUP BY Year, Month
ORDER BY Year, Month;

# giorni della settimana più attivi
SELECT 
    DAYNAME(Order_Date) AS weekday,
    COUNT(*) AS orders
FROM orders
GROUP BY weekday
ORDER BY orders DESC;

# Libro più venduto per anno
SELECT 
    YEAR(o.Order_Date) AS year,
    b.Title,
    SUM(o.Quantity) AS total_sold
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY year, b.Title
ORDER BY year, total_sold DESC;

# Evoluzione dei generi nel tempo
SELECT 
    YEAR(o.Order_Date) AS year,
    b.Genre,
    SUM(o.Quantity) AS total_sold
FROM orders o
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY year, b.Genre
ORDER BY year, total_sold DESC;

# Fatturato per paese nel tempo
SELECT 
    c.Country,
    YEAR(o.Order_Date) AS year,
    SUM(o.Quantity * b.Price) AS revenue
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
JOIN books b ON o.Book_ID = b.Book_ID
GROUP BY year, c.Country
ORDER BY year;
