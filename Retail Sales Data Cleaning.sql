-- 1. DATABASE SETUP
-- Create Database and Table
CREATE DATABASE p1_retail_db;
USE p1_retail_db;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
        sale_date DATE,	
        sale_time TIME,
        customer_id	INT,
        gender VARCHAR (15),
        age	INT,
        category VARCHAR (35),	
        quantiy	INT,
        price_per_unit FLOAT,	
        cogs FLOAT,
        total_sale FLOAT
	);

ALTER TABLE retail_sales
CHANGE COLUMN quantiy quantity INT;

SELECT * FROM retail_sales;
    
-- 2. DATA CLEANING
-- Checking for duplicates

WITH cte_duplicate AS (
SELECT *,
ROW_NUMBER () OVER(PARTITION BY transactions_id) AS row_num
FROM retail_sales
)
SELECT *
FROM cte_duplicate
WHERE row_num > 1;

-- Checking for Null values
SELECT *
FROM retail_sales
WHERE 
	sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR quantity IS NULL OR 
    price_per_unit IS NULL OR cogs IS NULL;

DELETE
FROM retail_sales
WHERE 
	sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR quantity IS NULL OR 
    price_per_unit IS NULL OR cogs IS NULL;
    
-- 3. DATA EXPLORATION
-- Record Count
SELECT COUNT(*) FROM retail_sales;

-- Customer Count
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- 4. Data Analysis
-- Quesstion 1: Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Question 2: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing' AND quantity >= 4 AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

-- Question 3: Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, SUM(total_sale) AS total_sale, COUNT(*) AS total_order
FROM retail_sales
GROUP BY category;

-- Question 4: Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Question 5: Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Question 6: Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT gender, category, COUNT(*) as total_transaction
FROM retail_sales
GROUP BY 1,2
ORDER BY 2;

-- Question 7: Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT
	year,
    month,
    avg_sale
FROM (
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		ROUND(AVG(total_sale),2) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
	FROM retail_sales
	GROUP BY 1,2) AS table1
WHERE ranking = 1;

-- Question 8: Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Question 9: Write a SQL query to find the number of unique customers who purchased items from each category

SELECT category, COUNT(DISTINCT customer_id) as num_unique_customers
FROM retail_sales
GROUP BY 1;

-- Question 10: Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale AS (
	SELECT *,
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
	FROM retail_sales)
    
    SELECT shift, category, COUNT(*) as total_orders
    FROM hourly_sale
    GROUP BY 1,2
    ORDER BY 1 ;
    
-- Question 11: Write a query to find the sales breakdown by category and age group.

SELECT category, 
CASE
	WHEN age >=18 AND age <=24 THEN '18-24'
    WHEN age >=25 AND age <=34 THEN '25-34'
    WHEN age >=35 AND age <=44 THEN '35-44'
    WHEN age >=45 AND age <=54 THEN '45-54'
    WHEN age >=55 AND age <=64 THEN '55-64'
    ELSE '65+'
END AS age_group, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY age_group, category
ORDER BY age_group, category;

-- Question 12: Monthly and Yearly sales

	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		ROUND(AVG(total_sale),2) as avg_sale
	FROM retail_sales
	GROUP BY 1,2
    ORDER BY 1;
    

-- KPIs:

SELECT COUNT(transactions_id) as Total_num_transactions
FROM retail_sales;

SELECT SUM(total_sale) as total_sales
FROM retail_sales;
