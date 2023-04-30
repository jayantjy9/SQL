#########################################################################
-- creating a database name 'project_sales_data' for this project.
-- importing the sales data using table data import wizard
#########################################################################

create database project_sales_data;

use project_sales_data;

select * from sales_data;

describe sales_data;

select count(1) from sales_data;    -- Count of records in the data

####################################################
#######################################


-- 1.Which month had the highest sales?

select month_id, sales from sales_data
group by month_id
order by sales desc
limit 1;

-- 2.Which city sold the most products?

select city, quantityordered from sales_data
group by city
order by quantityordered desc
limit 1;

-- 3.What products are most often sold together?

select productcode, count(productcode) from sales_data
group by productcode, customername
order by count(productcode) desc;

-- 4.What is the most popular shipping method?

select productline, count(productline) from sales_data
group by productline
order by productline desc;

-- 5.What is the average order value?

select round(avg(quantityordered*priceeach),2) as avg_order_value from sales_data;

-- 6. Minimum and Maximum Sale for each Month

select month_id, min(sales), max(sales)
from sales_data
group by month_id
order by month_id;

-- 7.What are the top 5 best-selling products?

select productcode, sales from sales_data
order by sales desc
limit 5;

-- 8.What time should we display advertisements to maximize customer engagement?

select month_id, round(sum(sales),2) as sales,
round(((sum(sales)/(select sum(sales) from sales_data))*100),2) as Percentage_of_sales
from sales_data
group by month_id
order by sales;

-- 9. Sales based on Deal size

select dealsize, round(sum(sales)) as Total_Sales, 
round(((sum(sales)/(select sum(sales) from sales_data))*100),2) as Percentage_of_sales
from sales_data
group by dealsize;

-- 10. find Sales by Year which involves per year increment or decrement percentage

select year_id,  round(sum(sales)) as Total_Sales, 
case when year_id=2003 then ' '
when year_id=2004 then round(((select sum(sales) from sales_data where year_id=2004)-
(select sum(sales) from sales_data where year_id=2003))*100/(select sum(sales) from sales_data where year_id=2003),2)
when year_id=2005 then round(((select sum(sales) from sales_data where year_id=2005)-
(select sum(sales) from sales_data where year_id=2004))*100/(select sum(sales) from sales_data where year_id=2004),2)
end as Percentage_of_inc_or_dec
from sales_data
group by year_id;

-- 11. find top 3 cities in each Country With highest sales

select * from
(select country,city,sales, rank() over(partition by country order by sales desc) as ranking from sales_data) a
where a.ranking in (1,2,3) 
order by a.country;
