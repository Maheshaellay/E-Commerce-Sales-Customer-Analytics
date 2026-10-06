use ecommerce;

select * from ecommerce_sales;

select customer_name,count(customer_name) as duplicate_count 
from ecommerce_sales group by customer_name having count(customer_name) >1; 

select customer_name,max(sales)as Highest_sales
from ecommerce_sales group by customer_name;

select * from ecommerce_sales limit 5;

select customer_name,count(order_id) as customer_count
from ecommerce_sales group by customer_name; 

select * from ecommerce_sales order by order_id desc limit 3;

with CTE AS (select*,row_number() over(order by order_id desc) as rownumber from ecommerce_sales) select * from CTE where rownumber <=3; 

select customer_name from ecommerce_sales where customer_name like 'A%';

select sales from ecommerce_sales order by sales desc limit 10;

select sales  from ecommerce_sales e1 where sales >= all (select sales from ecommerce_sales e2);


-- ==================================================
-- 1 DATA QUALITY CHECKS
-- ==================================================
SELECT COUNT(*) AS total_records
FROM ecommerce_sales;

-- Duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM ecommerce_sales
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- unique orders/customers/products
select count(distinct order_id) as unique_orders from ecommerce_sales;
select count(distinct customer_id) as unique_customers from ecommerce_sales;
select count(distinct product_id) as unique_products from ecommerce_sales;

-- nullcheck

select 
sum(order_id is null) as null_order_id,
sum(order_date is null) as null_order_date,
sum(ship_date is null) as null_ship_date,
SUM(customer_id is null) as null_customer_id,
SUM(product_id iS nULL) as null_product_id,
SUM(brand is null) as null_brand,
SUM(sales is null) as null_sales,
SUM(cost is null) as null_cost,
SUM(profit is null) as null_profit
FROM ecommerce_sales; 

-- Invalid Negative Checks 
select 
sum(quantity < 0) as negative_quantity,
sum(unit_price < 0) as negative_unit_price,
sum(sales < 0) as negative_sales,
sum(cost < 0) as negative_cost,
sum(profit < 0) as negative_profit
FROM ecommerce_sales;
-- ===========================================
-- 2 BASIC BUSINESS KPIs
-- ===========================================
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin_pct,
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value
FROM ecommerce_sales;
-- ============================================
-- 3. SALES ANALYSIS
-- =============================================
-- Sales by category
SELECT
    category,
    COUNT(DISTINCT order_id) AS orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100,2) AS profit_margin_pct
FROM ecommerce_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Sales by sub-category
SELECT
    sub_category,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY sub_category
ORDER BY total_sales DESC;

-- Sales by region
SELECT
    region,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100,2) AS profit_margin_pct
FROM ecommerce_sales
GROUP BY region
ORDER BY total_sales DESC;

-- Sales by country
SELECT
    country,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY country
ORDER BY total_sales DESC;

-- Sales by state
SELECT
    state,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY state
ORDER BY total_sales DESC;

-- Sales by city
SELECT
    city,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY city
ORDER BY total_sales DESC;

-- ============================================
-- 4. PRODUCT ANALYSIS
-- =============================================
-- Top 10 products by sales
SELECT
    product_id,
    product_name,
    category,
    brand,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY product_id, product_name, category, brand
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 products by profit
SELECT
    product_id,
    product_name,
    category,
    brand,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100,2) AS profit_margin_pct
FROM ecommerce_sales
GROUP BY product_id, product_name, category, brand
ORDER BY total_profit DESC
LIMIT 10;

-- Bottom 10 products by profit
SELECT
    product_id,
    product_name,
    category,
    brand,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY product_id, product_name, category, brand
ORDER BY total_profit ASC
LIMIT 10;

-- Brand performance
SELECT
    brand,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100,2) AS profit_margin_pct
FROM ecommerce_sales
GROUP BY brand
ORDER BY total_sales DESC;

-- Top product within every category
WITH product_rank AS (
    SELECT
        category,
        product_id,
        product_name,
        SUM(sales) AS total_sales,
        RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS rnk
    FROM ecommerce_sales
    GROUP BY category, product_id, product_name
)
SELECT
    category,
    product_id,
    product_name,
    ROUND(total_sales,2) AS total_sales
FROM product_rank
WHERE rnk = 1
ORDER BY category;

-- =======================================
-- 5. CUSTOMER ANALYSIS
-- =========================================
-- New vs Returning vs VIP
SELECT
    customer_type,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY customer_type
ORDER BY total_sales DESC;

-- Customer segment
SELECT
    segment,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY segment
ORDER BY total_sales DESC;

-- Top 20 customers by revenue
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(sales),2) AS customer_lifetime_value,
    ROUND(SUM(profit),2) AS customer_profit
FROM ecommerce_sales
GROUP BY customer_id, customer_name
ORDER BY customer_lifetime_value DESC
LIMIT 20;

-- Customer order frequency
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(SUM(sales),2) AS total_sales
FROM ecommerce_sales
GROUP BY customer_id, customer_name
ORDER BY order_count DESC, total_sales DESC
LIMIT 20;

-- Average customer value
SELECT
    ROUND(SUM(sales) / NULLIF(COUNT(DISTINCT customer_id),0),2)
        AS average_revenue_per_customer
FROM ecommerce_sales;

-- ===========================================
-- 6. CUSTOMER DEMOGRAPHICS
-- ==============================================
-- Gender analysis
SELECT
    gender,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(AVG(rating),2) AS average_rating
FROM ecommerce_sales
GROUP BY gender
ORDER BY total_sales DESC;

-- Age group analysis
SELECT
    CASE
        WHEN age < 25 THEN '18-24'
        WHEN age < 35 THEN '25-34'
        WHEN age < 45 THEN '35-44'
        WHEN age < 55 THEN '45-54'
        WHEN age < 65 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY age_group
ORDER BY total_sales DESC;

-- ============================================================
-- 7. ORDER STATUS ANALYSIS
-- ============================================================

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY order_status
ORDER BY orders DESC;

-- Status percentage
SELECT
    order_status,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(
        COUNT(DISTINCT order_id) * 100.0 /
        NULLIF((SELECT COUNT(DISTINCT order_id) FROM ecommerce_sales),0),
        2
    ) AS order_percentage
FROM ecommerce_sales
GROUP BY order_status
ORDER BY order_percentage DESC;

-- ============================================================
-- 8. DELIVERY / OPERATIONS ANALYSIS
-- ============================================================

-- Average delivery time
SELECT
    ROUND(AVG(delivery_days),2) AS average_delivery_days,
    MIN(delivery_days) AS fastest_delivery,
    MAX(delivery_days) AS slowest_delivery
FROM ecommerce_sales;

-- Delivery by shipping mode
SELECT
    ship_mode,
    COUNT(*) AS orders,
    ROUND(AVG(delivery_days),2) AS avg_delivery_days,
    ROUND(AVG(rating),2) AS avg_rating,
    ROUND(SUM(sales),2) AS total_sales
FROM ecommerce_sales
GROUP BY ship_mode
ORDER BY avg_delivery_days;

-- Delivery speed groups
SELECT
    CASE
        WHEN delivery_days <= 2 THEN 'Fast'
        WHEN delivery_days <= 5 THEN 'Medium'
        ELSE 'Slow'
    END AS delivery_category,
    COUNT(*) AS orders,
    ROUND(AVG(rating),2) AS average_rating,
    ROUND(AVG(sales),2) AS average_sales
FROM ecommerce_sales
GROUP BY delivery_category
ORDER BY average_rating DESC;

-- Check order-to-ship date difference
SELECT
    ROUND(AVG(DATEDIFF(ship_date, order_date)),2)
        AS average_ship_processing_days
FROM ecommerce_sales
WHERE order_date IS NOT NULL
  AND ship_date IS NOT NULL;

-- ============================================================
-- 9. CUSTOMER SATISFACTION / RATING
-- ============================================================

SELECT
    customer_satisfaction,
    COUNT(*) AS orders,
    ROUND(AVG(rating),2) AS average_rating,
    ROUND(AVG(delivery_days),2) AS avg_delivery_days,
    ROUND(SUM(sales),2) AS total_sales
FROM ecommerce_sales
GROUP BY customer_satisfaction
ORDER BY orders DESC;

-- Rating distribution
SELECT
    rating,
    COUNT(*) AS orders,
    ROUND(AVG(sales),2) AS average_sales,
    ROUND(AVG(delivery_days),2) AS average_delivery_days
FROM ecommerce_sales
GROUP BY rating
ORDER BY rating;

-- ============================================================
-- 10. PAYMENT METHOD ANALYSIS
-- ============================================================

SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(AVG(sales),2) AS average_order_value
FROM ecommerce_sales
GROUP BY payment_method
ORDER BY total_sales DESC;

-- ============================================================
-- 11. COUPON / DISCOUNT ANALYSIS
-- ============================================================

SELECT
    coupon_used,
    COUNT(*) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(AVG(rating),2) AS average_rating
FROM ecommerce_sales
GROUP BY coupon_used
ORDER BY total_sales DESC;

-- ============================================================
-- 12. MONTHLY / YEARLY ANALYSIS
-- ============================================================

SELECT
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS sales_month,
    MONTHNAME(order_date) AS month_name,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date), MONTHNAME(order_date)
ORDER BY sales_year, sales_month;

-- Quarterly sales
SELECT
    YEAR(order_date) AS sales_year,
    QUARTER(order_date) AS sales_quarter,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), QUARTER(order_date)
ORDER BY sales_year, sales_quarter;

-- ============================================================
-- 13. PROFITABILITY ANALYSIS
-- ============================================================

-- Overall profit margin
SELECT
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100,2)
        AS profit_margin_pct
FROM ecommerce_sales;

-- Profit margin by category
SELECT
    category,
    ROUND(SUM(sales),2) AS sales,
    ROUND(SUM(profit),2) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100,2)
        AS profit_margin_pct
FROM ecommerce_sales
GROUP BY category
ORDER BY profit_margin_pct DESC;

-- Loss-making products
SELECT
    product_id,
    product_name,
    ROUND(SUM(sales),2) AS sales,
    ROUND(SUM(cost),2) AS cost,
    ROUND(SUM(profit),2) AS profit
FROM ecommerce_sales
GROUP BY product_id, product_name
HAVING SUM(profit) < 0
ORDER BY profit ASC;

-- ============================================================
-- 14. BUSINESS INSIGHT QUERIES
-- ============================================================

-- Highest revenue category
SELECT
    category,
    ROUND(SUM(sales),2) AS total_sales
FROM ecommerce_sales
GROUP BY category
ORDER BY total_sales DESC
LIMIT 1;

-- Highest profit category
SELECT
    category,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY category
ORDER BY total_profit DESC
LIMIT 1;

-- Best region by profit
SELECT
    region,
    ROUND(SUM(profit),2) AS total_profit
FROM ecommerce_sales
GROUP BY region
ORDER BY total_profit DESC
LIMIT 1;

-- Best payment method by revenue
SELECT
    payment_method,
    ROUND(SUM(sales),2) AS total_sales
FROM ecommerce_sales
GROUP BY payment_method
ORDER BY total_sales DESC
LIMIT 1;

-- Best shipping mode by rating
SELECT
    ship_mode,
    ROUND(AVG(rating),2) AS average_rating
FROM ecommerce_sales
GROUP BY ship_mode
ORDER BY average_rating DESC
LIMIT 1;


-- ============================================================
-- 15. PORTFOLIO SUMMARY
-- ============================================================

SELECT
    'E-Commerce Sales & Customer Analytics' AS project_name,
    COUNT(*) AS records,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT product_id) AS products,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100,2)
        AS profit_margin_pct,
    ROUND(
        SUM(sales) / NULLIF(COUNT(DISTINCT order_id),0),
        2
    ) AS average_order_value,
    ROUND(AVG(delivery_days),2) AS average_delivery_days,
    ROUND(AVG(rating),2) AS average_rating
FROM ecommerce_sales;

-- ============================================================
-- END OF PROJECT
-- ============================================================














