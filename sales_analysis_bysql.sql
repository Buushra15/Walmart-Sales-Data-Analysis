Create database IF NOT EXISTS walmart_sales;
SHOW DATABASES;
USE walmart_sales
CREATE table IF NOT EXISTS sales_analysis(
invoice_id varchar(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city varchar(30) NOT NULL,
cuatomer_type varchar(30) not null,
gender varchar(30) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
qunatity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT  NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12,4) NOT NULL,
rating FLOAT(2,1)
);


-- Feature Engineering-----

-- tim_of_day


select
   time,
   (CASE 
         WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		 WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
         ELSE "Evening"
   END) AS time_of_date
FROM sales_analysis;

ALTER TABLE sales_analysis ADD COLUMN time_of_day varchar(20);

UPDATE sales_analysis  
SET time_of_day=(
CASE 
         WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		 WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
         ELSE "Evening"
END);

-- day_name
SELECT 
	date,
    dayname(date)
From sales_analysis;

ALTER TABLE sales_analysis ADD column day_name varchar(10);
UPDATE sales_analysis
SET day_name = dayname(date);

-- month_name
SELECT date,
monthname(date)
FROM sales_analysis;

Alter table sales_analysis ADD COLUMN month_name varchar(10);
UPDATE sales_analysis 
SET month_name = monthname(date)
-- ---- -------
-- ------------------------------Generic------------
-- how many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales_analysis;

SELECT 
	DISTINCT branch
FROM sales_analysis;

SELECT 
	DISTINCT city,branch
FROM sales_analysis;

-- --------------------------Product----------------
-- how many  unique product lines does the data have?
SELECT 
	count(DISTINCt product_line)
FROM sales_analysis;
-- what is most common payment method?
SELECT *
FROM sales_analysis;

SELECT payment_method,
count(payment_method) AS cnt
FROM sales_analysis
group by payment_method
order by cnt DESC;

-- most selling product _line
SELECT product_line,
count(product_line) AS cnt
FROM sales_analysis
group by product_line
order by cnt DESC
-- total revenue by month

SELECT
 month_name AS month,
SUM(total) AS total_revenue
FROM sales_analysis
group by month_name
order by 'total_revenue'  DESC;

-- what month has largest cogs?
SELECT
 month_name AS month,
SUM(cogs) AS cogs
FROM sales_analysis
group by month_name
order by 'cogs'  DESC;
-- what product_line has largest revenue?
SELECT
product_line,
SUM(total) AS total_revenue
FROM sales_analysis
group by product_line
order by 'total_revenue'  DESC;
-- what city has largest revenue?
SELECT
city,branch,
SUM(total) AS total_revenue
FROM sales_analysis
group by city,branch
order by 'total_revenue'  DESC;

-- what product line has largest VAT?
SELECT
product_line,
AVG(VAT) AS avg_tax
FROM sales_analysis
group by product_line
order by 'avg_tax'  DESC;
-- Fetch each product line and add a column to those product line showing "good", "bad"."Good" if its greater than avg sales.
-- which branch sold more products than avg?
SELECT
branch,
SUM(qunatity) AS qty
FROM sales_analysis
group by branch
-- HAVING SUM(qunatity) > (SELECT AVG(qunatity) from sales_analysis);

-- most common product line by gender?
SELECT
product_line,gender,
COUNT(gender) AS cnt
FROM sales_analysis
group by gender,product_line
order by cnt DESC
-- avg rating of each product line
SELECT ROUND(AVG(rating),2) as avg_rating,product_line
FROM sales_analysis
group by product_line