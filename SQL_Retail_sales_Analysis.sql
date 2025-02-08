CREATE DATABASE SQL_RETAIL_SALES_PROJECT;

DROP TABLE IF EXISTS RETAIL_SALES;
CREATE TABLE RETAIL_SALES
			(
				transactions_id	INT PRIMARY KEY,
                sale_date DATE,
                sale_time TIME,
                customer_id	INT,
                gender VARCHAR(250),
                age	INT,
                category VARCHAR(250),
                quantiy	INT,
                price_per_unit	FLOAT,
                cogs FLOAT,
                total_sale FLOAT
                );

select * from retail_sales;

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE?
SELECT COUNT(*) AS TOTAL_SALE FROM retail_sales;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- HOW MANY UNIQUE CATEGORIES WE HAVE?
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Problema and Answers
-- Q.1 Write a SQL query to retrive all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
select * from retail_sales
where category = 'clothing'
	and
    quantiy >= 4
	and
    extract(year from sale_date) = 2022
    and
    extract(month from sale_date) = 11;
    
    -- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
    
    SELECT category, SUM(total_sale), COUNT(*) AS TOTAL_ORDERS
    FROM retail_sales
    group by category;
    
-- Q.4 Write a SQL query to calculate average age of customers who purchased items from the 'Beauty' category.
     select category, round(avg(age), 2)
     from retail_sales
     where category = 'beauty';
     
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale > '1000';

-- Q.6 Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each gategory.

select category, gender, count(transactions_id) as total_transactions 
from retail_sales
group by category, gender
order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

select
	year,
    month,
    avg_sale
from
    (
	select extract(year from sale_date) as Year,
		extract(month from sale_date) as Month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as 'Rank'
	from retail_sales
	group by year, month
    ) as table_2
Where rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

select 
	customer_id,
	sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category

select
	category,
    count(distinct customer_id) as 'number of customers'
    from retail_sales
    group by category;
    
-- Q.10 Write a SQL query to create each shift and number of orders.

WITH SHIFT_WISE_SALE
AS
(
SELECT *,
	case
		when EXTRACT(HOUR FROM sale_time) < 12 then 'MORNING'
		when EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 then 'AFTERNOON' 
		else 'EVENING'
	end AS 'SHIFT'
FROM retail_sales
)
SELECT SHIFT,
	COUNT(*) AS TOTAL_ORDERS
	FROM SHIFT_WISE_SALE
GROUP BY SHIFT;

-- END OF PROJECT --