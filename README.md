# Retail Sales Analysis SQL Project

![Retail sales analysis_page-0001](https://github.com/user-attachments/assets/da6ac430-fd4a-4326-9b07-ec37c5c6ef1e)


## Project Overview

**Project Title**: Retail Sales Analysis

**Description**: The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries

## Objectives

1.  **Database setup**: Create and populate a retail sales database with the provided sales data.
2.	**Data Cleaning**: Identify and remove any records with missing or null values.
3.	**Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4.	**Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1.Database Setup
**a.	Database Creation**: The project starts by creating a database named retail_sales_database

**b.	Table Creation**: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_sales_database;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

```

## 2. Data Cleaning and Exploration
**a. Record Count**: Determine the total number of records in the dataset.
```sql
SELECT COUNT(*) FROM retail_sales;
```
**b. Customer Count**: Find out how many unique customers are in the dataset.
```sql
SELECT COUNT(DISTINCT customer_id) FROM retail sales;
```
**c. Category Count**: Identify all unique product categories in the dataset.
```sql
SELECT DISTINCT category FROM retail_sales;
```
**d. Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```sql
SELECT * FROM retail_sales
WHERE
sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR age IS NULL OR category IS NULL OR 
    	quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE
sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR age IS NULL OR category IS NULL OR 
    	quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```
**e. Duplicate Value Check**: Check for any duplicate values in the dataset and delete these data.
```sql
WITH cte_duplicate AS 
(
SELECT *,
ROW_NUMBER () OVER(PARTITION BY transactions_id) AS row_num
FROM retail_sales
)
SELECT *
FROM cte_duplicate
WHERE row_num > 1;
```

## 3.	Data Analysis and Findings

The following SQL queries were developed to answer specific business questions:

**a. Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = ‘2022-11-05’;
```
**b. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is equal to or more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales
WHERE 
    category = ‘Clothing’ AND 
    quantity >=4 AND
    DATEFORMAT(sale_date, ‘&Y-%m) = ‘2022-11’;
```
**c. Write a SQL query to calculate the total sales (total_sale) and total number of orders for each category**:
```sql
SELECT
    category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;
```
**d. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**:
```sql
SELECT ROUND(AVG(age),2) AS avg_age_customers
FROM retail_sales
WHERE category = ‘Beauty’;
```
**e. Write a SQL query to find all transactions where the total_sale is greater than 1000**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```
**f. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category**:
```sql
SELECT
    category,	
    gender,
    COUNT(transaction_id) AS total_transaction
FROM retail_sales
GROUP BY 1,2
ORDER BY 1; 
```
**g. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT
    year,
    month,
    avg_sale
FROM
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        ROUND(AVG(total_sale),2) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
FROM retail_sales
GROUP BY 1,2) AS table1
WHERE ranking =1;
```
**h. Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
**i. Write a SQL query to find the number of unique customers who purchased items from each category**:
```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1;
```
**j. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sales AS
(
SELECT *,
	CASE
        WHEN EXTRACT(HOUR from sale_time) < 12 THEN ‘Morning’
        WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17 THEN ‘Afternoon
        ELSE ‘Evening’
        END AS shift
FROM retail_sales
)

SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY 1;
```
**k. Write a query to find the sales breakdown by category and age group.**:
```sql
SELECT
    category,
    CASE
        WHEN age >=18 AND age <=24 THEN '18-24'
        WHEN age >=18 AND age <=24 THEN '18-24'
        WHEN age >=25 AND age <=34 THEN '25-34'
        WHEN age >=35 AND age <=44 THEN '35-44'
        WHEN age >=45 AND age <=54 THEN '45-54'
        WHEN age >=55 AND age <=64 THEN '55-64'
        ELSE '65+'
        END AS age_group,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,2;
```
**l. Write a query to find the monthly and yearly sales**:
```sql
SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    ROUND(AVG(total_sale),2) AS avg_sale
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,2;
```

## 4. Summary of Findings

**a. Category Performance**: The sales among Electronics and Clothing outperforms the sales of the Beauty Category.

**b. Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons. Strong performance is noticeable in July 2022 and February 2023.

**c. Age Group Dynamics**: The sales by age group reveals that 18-24 age group are spending more on the Beauty category while those who are 25 years old and above spends more on Electronics and Clothing.

## 5. Strategic Recommendations:

**a. Category growth**: 
1. Boost Beauty sales through bundled offers with Clothing products.
2. dentify trends driving Clothing & Electronics success and apply them across categories.

**b. Seasonal Strategy**:
1. Introduce new campaigns to mitigate low-sales periods.
2. Maximize high-performing months with aggressive promotions.
   
**c. Demographic Focus**:
1. Engage Gen Z with fresh, digital-first campaigns.
2. Retain older customers with loyalty programs and personalized offers.

