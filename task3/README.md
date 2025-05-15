# 📊 Task 3: SQL for Data Analysis – Data Analyst Internship

## 📌 Objective
Use SQL to extract, analyze, and manipulate data from an ecommerce database. This task demonstrates core SQL skills including filtering, aggregation, joins, subqueries, views, and indexing.

---

## 🛠 Tools Used
- **SQLite (sqlite3 CLI)**
- **Dataset**: `ecommerce.csv`
- **Command Prompt** for executing queries
- **DB Browser for SQLite** (optional for GUI work)

---

## 📁 Dataset Structure

The dataset `ecommerce.csv` contains historical ecommerce transactions with the following fields:

| Column Name   | Description                              |
|---------------|------------------------------------------|
| InvoiceNo     | Invoice ID for the transaction           |
| StockCode     | Unique code for the product              |
| Description   | Product description                      |
| Quantity      | Number of items sold                     |
| InvoiceDate   | Date and time of the transaction         |
| UnitPrice     | Price per item                           |
| CustomerID    | Unique ID for the customer               |
| Country       | Country of the customer                  |

---

## 🧪 SQL Query Breakdown

### ✅ 1. SELECT, WHERE, ORDER BY
**Top 10 high-value line items**
```sql
SELECT InvoiceNo, StockCode, Quantity, UnitPrice,
       Quantity * UnitPrice AS line_revenue
FROM orders
WHERE CustomerID IS NOT NULL
ORDER BY line_revenue DESC
LIMIT 10;
✅ 2. GROUP BY
Monthly revenue totals

SELECT substr(InvoiceDate, 1, 7) AS month,
       SUM(Quantity * UnitPrice) AS total_revenue
FROM orders
GROUP BY month
ORDER BY month;

✅ 3. JOINS (INNER, LEFT, RIGHT)
Helper tables created:

CREATE TABLE products AS
SELECT DISTINCT StockCode, Description FROM orders;

CREATE TABLE customers AS
SELECT DISTINCT CustomerID, Country FROM orders;

INNER JOIN

SELECT o.InvoiceNo, c.Country,
       SUM(o.Quantity * o.UnitPrice) AS revenue
FROM orders o
INNER JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY o.InvoiceNo, c.Country
ORDER BY revenue DESC
LIMIT 5;

LEFT JOIN

SELECT o.InvoiceNo, IFNULL(c.Country, 'Unknown') AS Country,
       o.Quantity * o.UnitPrice AS revenue
FROM orders o
LEFT JOIN customers c ON o.CustomerID = c.CustomerID
LIMIT 10;

RIGHT JOIN (Simulated)

SELECT c.CustomerID, IFNULL(o.InvoiceNo, 'No Order') AS InvoiceNo,
       IFNULL(o.Quantity * o.UnitPrice, 0) AS revenue
FROM customers c
LEFT JOIN orders o ON o.CustomerID = c.CustomerID
LIMIT 10;

✅ 4. Subqueries
High-value customers (spending > ₹5000)

SELECT CustomerID, total_spent
FROM (
  SELECT CustomerID, SUM(Quantity * UnitPrice) AS total_spent
  FROM orders
  GROUP BY CustomerID
) AS t
WHERE total_spent > 5000;

✅ 5. Aggregate Functions
Average line value

SELECT AVG(Quantity * UnitPrice) AS avg_line_value
FROM orders;
Average spend per customer

SELECT CustomerID,
       AVG(Quantity * UnitPrice) AS avg_spend
FROM orders
GROUP BY CustomerID
ORDER BY avg_spend DESC
LIMIT 10;

✅ 6. Views
Monthly revenue view

CREATE VIEW monthly_revenue AS
SELECT substr(InvoiceDate, 1, 7) AS month,
       SUM(Quantity * UnitPrice) AS revenue
FROM orders
GROUP BY month;

✅ 7. Indexes
Indexing for optimization

CREATE INDEX idx_customer_id ON orders(CustomerID);
CREATE INDEX idx_invoice_date ON orders(InvoiceDate);
