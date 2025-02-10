# Retail Sales Analysis SQL Project

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




