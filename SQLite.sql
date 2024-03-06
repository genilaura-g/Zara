select * from zara2

-- What are the top-selling products in the Zara dataset?
select sales_volume, terms
from zara2
group by terms
order by sales_volume DESC
limit 10;  

-- Season trends 
select sales_volume, terms, 
partition over seasonal 
from zara2
group by terms
order by sales_volume DESC
limit 10;



-- Are there any visual correlations between promotional activities (e.g., discounts, promotions) and sales performance?
select sales_volume, price, (sales_volume * price) as revenue, terms, name 
from zara2
group by name
order by sales_volume DESC

select sales_volume, price, (sales_volume * price) as revenue, terms,
rank() over (partition by terms order by sales_volume * price) As ranking  
from zara2
group by terms 
order by revenue DESC


-- What is the average price of item

select avg(price), *
from zara2
group by terms
order by sales_volume DESC

-- How do sales vary across different product categories (e.g., clothing, accessories)?
SELECT 
    terms,
    sum(sales_volume) OVER (PARTITION BY terms ORDER BY sales_volume DESC) AS sales_rank
FROM 
    zara2
GROUP BY
    terms; -- Grouping by section and sales_volume


-- What is the overall revenue trend over the specified time period?

select round(sum(price * sales_volume), 2) as revenue 
from zara2;


select terms, sum(price * sales_volume) over (partition by terms order by sales_volume) as revenue 
from zara2
group by terms
order by sales_volume DESC;

-- How effective are different marketing channels (e.g., online, in-store promotions) in driving sales? /*
select terms, product_position, 
sum(sales_volume) over (partition by terms order by sales_volume) as sales_volume_gender 
from zara2
group by product_position,terms;

select terms, promotion, 
sum(sales_volume) over (partition by promotion order by sales_volume) as sales_volume_gender 
from zara2
group by promotion,terms;

select terms, section, 
sum(sales_volume) over (partition by section order by sales_volume) as sales_volume_gender 
from zara2
group by section,terms
order by sales_volume_gender DESC;

-- reducing scraped_at colum to 10 characters,
Select MAX(dates), terms,
from (select SUBSTRING(scraped_at,1, 10) as Dates, product_id,product_id, terms, promotion
from zara2)
group by terms
Order by dates 

-- reducing scraped_at colum to 10 characters, subqueery to find max price by date 
Select MAX(z.price), z.terms, z2.dates
from 
	(select SUBSTRING(scraped_at,1, 10) as Dates, product_id,from zara2) as z2 
    join zara2 as z 
    on z2.product_id=z.product_id
group by z.terms,z2.Dates
Order by z.price;

SELECT 
    MAX(z.price) AS max_price,
    z.terms,
    z2.Dates
FROM 
    (SELECT 
         SUBSTRING(scraped_at, 1, 10) AS Dates,
         product_id
     FROM 
         zara2) AS z2
JOIN 
    zara2 AS z ON z2.product_id = z.product_id
GROUP BY 
    z.terms, z2.Dates
ORDER BY 
    max_price;




