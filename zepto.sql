create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

--Count rows
select count(*) from zepto;

--Sample data
select * from zepto
limit 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--Product categories
select distinct(category) 
from zepto
order by category;

--Products in vs out of stock
select outofstock , count(*)
from zepto
group by outofstock;

--Products names present more than once 
select name ,count(*) as number_of_sku from zepto
group by name
having count(*)>1
order by number_of_sku desc;

--date cleaning

--products with price =0
select * from zepto
where mrp=0;

delete from zepto
where mrp=0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

--Data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
select name , discountpercent
from zepto
order by discountpercent desc
limit 10;

-- Q2. What are the products with high MRP but out of stock?
select distinct(name) ,mrp from zepto
where outofstock is true and mrp>300
order by mrp;

-- Q3. Calculate estimated revenue for each category.
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct(name), mrp , discountpercent
from zepto
where mrp>500 and discountpercent<10
ORDER BY mrp DESC, discountPercent DESC;
 
-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category, round(avg(discountpercent),2) as avg_discount
from zepto
group by category 
order by avg(discountpercent) desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7. Group the products into categories like Low, Medium, and Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

-- Q8. What is the total inventory weight per category?
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
