

 
 -- WINDOW 1: Ranking Functions--
 SELECT 
    c.name,
    c.region,
    SUM(s.amount) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(s.amount) DESC) AS row_num,
    RANK() OVER (ORDER BY SUM(s.amount) DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY SUM(s.amount) DESC) AS dense_rank,
    ROUND(
        CAST(PERCENT_RANK() OVER (ORDER BY SUM(s.amount) DESC) * 100 AS NUMERIC), 
        2
    ) AS percent_rank
FROM Customers c
INNER JOIN Sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.name, c.region
ORDER BY total_revenue DESC
LIMIT 10;



  --WINDOW 2: Aggregate Functions --

   WITH MonthlyData AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') AS month,
        SUM(amount) AS monthly_sales
    FROM Sales
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    month,
    monthly_sales,
    SUM(monthly_sales) OVER (
        ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total,
    ROUND(
        CAST(AVG(monthly_sales) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS NUMERIC), 
        2
    ) AS three_month_moving_avg
FROM MonthlyData
ORDER BY month;

 

 -- WINDOW 3: Navigation Functions--
 WITH MonthlySales AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') AS month,
        SUM(amount) AS monthly_sales
    FROM Sales
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    month,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales,
    ROUND(
        CAST(
            (monthly_sales - LAG(monthly_sales) OVER (ORDER BY month)) 
            / NULLIF(LAG(monthly_sales) OVER (ORDER BY month), 0) 
            * 100 AS NUMERIC
        ), 
        2
    ) AS growth_pct
FROM MonthlySales
ORDER BY month;

   -- WINDOW 4: Distribution Functions--
  SELECT 
    c.name,
    c.region,
    SUM(s.amount) AS total_revenue,
    NTILE(4) OVER (ORDER BY SUM(s.amount) DESC) AS revenue_quartile,
    ROUND(
        CAST(CUME_DIST() OVER (ORDER BY SUM(s.amount) DESC) * 100 AS NUMERIC), 
        2
    ) AS cumulative_percent,
    CASE NTILE(4) OVER (ORDER BY SUM(s.amount) DESC)
        WHEN 1 THEN 'Platinum (Top 25%)'
        WHEN 2 THEN 'Gold (25-50%)'
        WHEN 3 THEN 'Silver (50-75%)'
        WHEN 4 THEN 'Bronze (75-100%)'
    END AS customer_tier
FROM Customers c
INNER JOIN Sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.name, c.region
ORDER BY total_revenue DESC;