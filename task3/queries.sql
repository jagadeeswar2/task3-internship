Microsoft Windows [Version 10.0.26100.3775]
(c) Microsoft Corporation. All rights reserved.

C:\Users\chara>cd /d D:\task3

D:\task3>sqlite3 ecommerce.db
SQLite version 3.44.3 2024-03-24 21:15:01 (UTF-16 console I/O)
Enter ".help" for usage hints.
sqlite> .mode csv
sqlite> .import ecommerce.csv orders
sqlite> .headers on
sqlite> .mode column
sqlite> SELECT * FROM orders LIMIT 5;
InvoiceNo  StockCode  Description                          Quantity  InvoiceDate       UnitPrice  CustomerID  Country   
---------  ---------  -----------------------------------  --------  ----------------  ---------  ----------  --------------
536365     85123A     WHITE HANGING HEART T-LIGHT HOLDER   6         12-01-2010 08:26  2.55       17850       United Kingdom
536365     71053      WHITE METAL LANTERN                  6         12-01-2010 08:26  3.39       17850       United Kingdom
536365     84406B     CREAM CUPID HEARTS COAT HANGER       8         12-01-2010 08:26  2.75       17850       United Kingdom
536365     84029G     KNITTED UNION FLAG HOT WATER BOTTLE  6         12-01-2010 08:26  3.39       17850       United Kingdom
536365     84029E     RED WOOLLY HOTTIE WHITE HEART.       6         12-01-2010 08:26  3.39       17850       United Kingdom
sqlite> SELECT
   ...>   InvoiceNo,
   ...>   StockCode,
   ...>   Quantity,
   ...>   UnitPrice,
   ...>   Quantity * UnitPrice AS line_revenue
   ...> FROM orders
   ...> WHERE CustomerID IS NOT NULL
   ...> ORDER BY line_revenue DESC
   ...> LIMIT 10;
InvoiceNo  StockCode  Quantity  UnitPrice  line_revenue
---------  ---------  --------  ---------  ------------
536370     22728      24        3.75       90.0
536370     22727      24        3.75       90.0
536367     84879      32        1.69       54.08
536370     22726      12        3.75       45.0
536367     21777      4         7.95       31.8
536367     48187      4         7.95       31.8
536367     22749      8         3.75       30.0
536365     21730      6         4.25       25.5
536367     84969      6         4.25       25.5
536368     22960      6         4.25       25.5
sqlite> SELECT
   ...>   substr(InvoiceDate, 1, 7) AS month,
   ...>   SUM(Quantity * UnitPrice) AS total_revenue
   ...> FROM orders
   ...> GROUP BY month
   ...> ORDER BY month;
month    total_revenue
-------  -------------
12-01-2  752.95
sqlite> CREATE TABLE IF NOT EXISTS products AS
   ...> SELECT DISTINCT StockCode, Description
   ...> FROM orders
   ...> WHERE StockCode IS NOT NULL;
sqlite>
sqlite> CREATE TABLE IF NOT EXISTS customers AS
   ...> SELECT DISTINCT CustomerID, Country
   ...> FROM orders
   ...> WHERE CustomerID IS NOT NULL;
sqlite> SELECT
   ...>   o.InvoiceNo,
   ...>   c.Country,
   ...>   SUM(o.Quantity * o.UnitPrice) AS revenue
   ...> FROM orders o
   ...> INNER JOIN customers c
   ...>   ON o.CustomerID = c.CustomerID
   ...> GROUP BY o.InvoiceNo, c.Country
   ...> ORDER BY revenue DESC
   ...> LIMIT 5;
InvoiceNo  Country         revenue
---------  --------------  -------
536367     United Kingdom  278.73
536370     France          225.0
536365     United Kingdom  139.12
536368     United Kingdom  70.05
536366     United Kingdom  22.2
sqlite> SELECT
   ...>   o.InvoiceNo,
   ...>   IFNULL(c.Country, 'Unknown') AS Country,
   ...>   o.Quantity * o.UnitPrice AS revenue
   ...> FROM orders o
   ...> LEFT JOIN customers c
   ...>   ON o.CustomerID = c.CustomerID
   ...> LIMIT 10;
InvoiceNo  Country         revenue
---------  --------------  -------
536365     United Kingdom  15.3
536365     United Kingdom  20.34
536365     United Kingdom  22.0
536365     United Kingdom  20.34
536365     United Kingdom  20.34
536365     United Kingdom  15.3
536365     United Kingdom  25.5
536366     United Kingdom  11.1
536366     United Kingdom  11.1
536367     United Kingdom  54.08
sqlite> SELECT
   ...>   c.CustomerID,
   ...>   IFNULL(o.InvoiceNo, 'No Order') AS InvoiceNo,
   ...>   IFNULL(o.Quantity * o.UnitPrice, 0) AS revenue
   ...> FROM customers c
   ...> LEFT JOIN orders o
   ...>   ON o.CustomerID = c.CustomerID
   ...> LIMIT 10;
CustomerID  InvoiceNo  revenue
----------  ---------  -------
17850       536365     15.3
17850       536365     15.3
17850       536365     20.34
17850       536365     20.34
17850       536365     20.34
17850       536365     25.5
17850       536365     22.0
17850       536366     11.1
17850       536366     11.1
13047       536367     19.9
sqlite> SELECT CustomerID, total_spent
   ...> FROM (
(x1...>   SELECT CustomerID, SUM(Quantity * UnitPrice) AS total_spent
(x1...>   FROM orders
(x1...>   GROUP BY CustomerID
(x1...> ) AS t
   ...> WHERE total_spent > 5000;
sqlite> SELECT AVG(Quantity * UnitPrice) AS avg_line_value
   ...> FROM orders;
avg_line_value
----------------
25.9637931034483
sqlite> SELECT CustomerID,
   ...>        AVG(Quantity * UnitPrice) AS avg_spend
   ...> FROM orders
   ...> GROUP BY CustomerID
   ...> ORDER BY avg_spend DESC
   ...> LIMIT 10;
CustomerID  avg_spend
----------  ----------------
12583       75.0
13047       21.5664705882353
17850       17.9244444444444
sqlite> CREATE VIEW IF NOT EXISTS monthly_revenue AS
   ...> SELECT
   ...>   substr(InvoiceDate, 1, 7) AS month,
   ...>   SUM(Quantity * UnitPrice) AS revenue
   ...> FROM orders
   ...> GROUP BY month;
sqlite> SELECT * FROM monthly_revenue;
month    revenue
-------  -------
12-01-2  752.95
sqlite> CREATE INDEX IF NOT EXISTS idx_customer_id ON orders(CustomerID);
sqlite> CREATE INDEX IF NOT EXISTS idx_invoice_date ON orders(InvoiceDate);
sqlite>