-- what is the average spend between men and women
Select gender, round(avg(price)) AS average_spend
from shopping.customer_shopping
group by gender

-- what is the average money spent between the differennt age ranges
select gender, 
round(avg(case when age <=19 then price end)) AS '0-19',
round(avg(case when age >= 20 and age <= 29 then price end)) AS '20-29',
round(avg(case when age >= 30 and age <=39 then price end)) AS '30-39',
round(avg(case when age >= 40 and age <=49 then price end)) AS '40-49',
round(avg(case when age >= 50 and age <=59 then price end)) AS '50-59',
round(avg(case when age >= 60 and age <=69 then price end)) AS '60-69',
round(avg(case when age >= 70 then price end)) AS '70+'
from shopping.customer_shopping
group by gender 

-- what category of shopping makes the most money and the total quantity sold
Select category, round(sum(price)) AS total_sales
from shopping.customer_shopping
group by Category
order by total_sales desc

-- average price of different product types
select distinct category,round(avg(price) over(partition by category)) AS Avg_price
from shopping.customer_shopping
order by Avg_price desc

-- top 5 shopping malls which making the most amount of money 
With shops AS (Select shopping_mall, round(sum(price)) AS Total_sale
from shopping.customer_shopping
group by shopping_mall
order by Total_sale desc), 
CTE AS ( select *, dense_rank() over(order by Total_sale) AS RNK
from shops) 
Select distinct shopping_mall, Total_sale
from CTE 
where RNK > 5 
order by Total_sale desc

-- which method of payment is used the most by the customers 
With Pay AS(Select payment_method, count(1) AS Total_count
from shopping.customer_shopping
group by payment_method)
select p.*, round(p.Total_count*100/t.C) AS percentage
from pay p cross join (select sum(Total_count) AS C from pay) T
order by percentage desc

-- What is the average price spent by each gender for all the months
select gender,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 1 then price end),2) AS January,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 2 then price end),2) AS February,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 3 then price end),2) AS March,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 4 then price end),2) AS April,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 5 then price end),2) AS May,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 6 then price end),2) AS June,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 7 then price end),2) AS July,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 8 then price end),2) AS August,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 9 then price end),2) AS September,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 10 then price end),2) AS October,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 11 then price end),2) AS November,
round(avg(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 12 then price end),2) AS December
from shopping.customer_shopping
group by gender

-- how much money did each shopping mall make in November and December 
select shopping_mall, 
round(sum(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 11 then price end),2) AS November,
round(sum(case when month(date_format(str_to_date(invoice_date,'%d/%m/%y'),'%d/%m/%y')) = 12 then price end),2) AS December
from shopping.customer_shopping
group by shopping_mall

-- most sold quantity per category based on age range
select category, 
count(case when age <=19 then quantity end) AS '0-19',
count(case when age >= 20 and age <= 29 then quantity end) AS '20-29',
count(case when age >= 30 and age <=39 then quantity end) AS '30-39',
count(case when age >= 40 and age <=49 then quantity end) AS '40-49',
count(case when age >= 50 and age <=59 then quantity end) AS '50-59',
count(case when age >= 60 and age <=69 then quantity end) AS '60-69',
count(case when age >= 70 then price end) AS '70+'
from shopping.customer_shopping
group by category
 
-- what is the most popular category types between men and women
select gender,
sum(case when Category = 'Clothing' then quantity end) AS Clothing,
sum(case when Category = 'Shoes' then quantity end) AS Shoes,
sum(case when Category = 'books' then quantity end) AS Books,
sum(case when Category = 'Cosmetics' then quantity end) AS Cosmetics,
sum(case when Category = 'Food & Beverage' then quantity end) AS 'Food & Beverage',
sum(case when Category = 'Toys' then quantity end) AS Toys,
sum(case when Category = 'Technology' then quantity end) AS Technology,
sum(case when Category = 'Souvenir' then quantity end) AS Souvenir
from shopping.customer_shopping
group by gender
