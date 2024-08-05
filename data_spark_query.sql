use dataspark;

-- gender distribution
select gender,count(DISTINCT customerkey) as count 
from combined_sales
group by gender;

-- Age Distribution
select age,count(DISTINCT customerkey) as count
from combined_sales
group by age
order by age;

-- Customer Segmentation
select segment,count(DISTINCT customerkey) as count
from combined_sales
group by segment
order by count desc;

-- Lifetime Value
SELECT customerkey, 
       customer_name, 
       ROUND(SUM(unit_price_usd * exchange * quantity), 2) AS total_revenue
FROM combined_sales
GROUP BY customerkey, customer_name
ORDER BY total_revenue DESC;

-- Total Revenue
SELECT ROUND(SUM(unit_price_usd * exchange * quantity), 2) AS total_revenue
FROM combined_sales;

-- Monthly Sales
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, ROUND(SUM(unit_price_usd * exchange * quantity), 2) AS total_revenue
FROM combined_sales 
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Top Products
SELECT product_name, SUM(quantity) AS total_quantity, ROUND(SUM(unit_price_usd * exchange * quantity), 2) AS total_revenue
FROM combined_sales 
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Unit Cost vs. Unit Price
SELECT product_name, unit_cost_usd, unit_price_usd, (unit_price_usd - unit_cost_usd) AS profit_margin
FROM combined_sales;

-- total orders
SELECT COUNT(DISTINCT order_number) AS total_orders
FROM combined_sales;

-- Average Order Value
SELECT round(avg(total_revenue),2) AS average_order_value
FROM (
    SELECT order_number, ROUND(SUM(unit_price_usd * exchange * quantity), 2) AS total_revenue
    FROM combined_sales
    GROUP BY order_number
) sub;

-- Purchase Frequency
SELECT customerkey, customer_name, COUNT(DISTINCT order_number) AS purchase_frequency
FROM combined_sales
GROUP BY customerkey, customer_name
ORDER BY purchase_frequency DESC;

-- Churn Analysis
SELECT customerkey, customer_name, MAX(order_date) AS last_purchase_date
FROM combined_sales 
GROUP BY customerkey, customer_name
HAVING MAX(order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- Sales by Country
SELECT country, ROUND(SUM(unit_price_usd * exchange * quantity), 2) AS total_revenue
FROM combined_sales 
GROUP BY country
ORDER BY total_revenue DESC;

-- sales by store sq mtr
SELECT store_state, square_meters, ROUND(SUM(unit_price_usd * exchange * quantity), 2) AS total_revenue
FROM combined_sales 
GROUP BY store_state,square_meters
ORDER BY total_revenue DESC;
