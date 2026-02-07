# 📊 Rwanda E-Commerce Sales Analytics – SQL Project

## 📌 Overview  
This project is a comprehensive SQL-based business intelligence solution for an e-commerce platform operating in Rwanda. It leverages **advanced SQL JOINs** and **Window Functions** to analyze sales data, uncover regional trends, segment customers, and provide actionable insights for inventory optimization, targeted marketing, and growth strategy.

---

## 🎯 Business Problem  
The company struggles with fragmented customer and sales data, leading to inefficient stock distribution, missed marketing opportunities, and hampered revenue growth. There is a clear need to join customer profiles with transaction data to uncover regional purchasing behaviors and improve decision-making.

### ✅ **Success Criteria – 5 Measurable Goals**

| # | Goal | Window Function Used | Business Value |
|---|------|----------------------|----------------|
| 1 | Top 5 products per region by revenue | `RANK() OVER(PARTITION BY region ORDER BY revenue DESC)` | Optimize inventory allocation per province |
| 2 | Running monthly sales totals | `SUM(amount) OVER(ORDER BY month ROWS UNBOUNDED PRECEDING)` | Track YTD performance against targets |
| 3 | Month-over-month growth percentage | `LAG(sales) OVER(ORDER BY month)` | Identify seasonal trends and campaign timing |
| 4 | Customer quartile segmentation by lifetime revenue | `NTILE(4) OVER(ORDER BY total_revenue DESC)` | Enable tiered marketing and loyalty programs |
| 5 | 3-month moving average of sales | `AVG(sales) OVER(ORDER BY month RANGE 2 PRECEDING)` | Smooth volatility for accurate forecasting |

---

## 🗄️ Database Schema

### Tables

**1. Customers**
| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| customer_id | INTEGER | PRIMARY KEY | Unique customer identifier |
| name | VARCHAR(100) | NOT NULL | Customer full name |
| email | VARCHAR(100) | UNIQUE | Contact email |
| region | VARCHAR(50) | NOT NULL | Rwanda province (Kigali, Northern, Southern, Eastern, Western) |

**2. Products**
| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| product_id | INTEGER | PRIMARY KEY | Unique product identifier |
| name | VARCHAR(200) | NOT NULL | Product name |
| category | VARCHAR(50) | NOT NULL | Category (Electronics, Appliances, Books) |
| price | DECIMAL(10,2) | NOT NULL | Unit price in RWF |

**3. Sales**
| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| sale_id | INTEGER | PRIMARY KEY | Unique transaction ID |
| customer_id | INTEGER | FOREIGN KEY | References Customers.customer_id |
| product_id | INTEGER | FOREIGN KEY | References Products.product_id |
| quantity | INTEGER | NOT NULL | Units purchased |
| amount | DECIMAL(10,2) | NOT NULL | Total sale amount (RWF) |
| sale_date | DATE | NOT NULL | Transaction date |

### 🔗 Entity Relationship Diagram (ERD)

- **Primary Keys**: `customer_id`, `product_id`, `sale_id`
- **Foreign Keys**: `Sales.customer_id` → `Customers.customer_id`, `Sales.product_id` → `Products.product_id`

*(ER diagram image would be inserted here in practice)*

---

## 🔗 SQL JOINs Implementation

### 1. INNER JOIN – Valid Sales Transactions
**Purpose**: Retrieve only transactions with valid customer and product records.  
**SQL**:
```sql
SELECT s.sale_id, c.name AS customer_name, c.region, 
       p.name AS product_name, p.category, s.quantity, s.amount, s.sale_date
FROM Sales s
INNER JOIN Customers c ON s.customer_id = c.customer_id
INNER JOIN Products p ON s.product_id = p.product_id
ORDER BY s.sale_date DESC
LIMIT 8;
