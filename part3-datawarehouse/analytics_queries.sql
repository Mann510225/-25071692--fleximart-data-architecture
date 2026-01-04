
-- Query 1: Monthly Sales Drill-Down
-- Business Scenario:
   -- "The CEO wants to see sales performance broken down by time periods. Start with yearly total, then quarterly, then monthly sales for 2024."
-- Demonstrates: Drill-down from Year to Quarter to Month

select d.year, d.quarter, d.month_name, sum(f.quantity_sold) as total_quantity, sum(f. total_amount) as total_sales 
from fact_sales f
join dim_date d 
on d.date_key = f.date_key
group by d.year, d.quarter, d.month_name ;

# year	quarter	month_name	total_quantity	total_sales
	2024	1	January	      17	        179036.00
	2024	1	February	    19	        162991.00
	2024	1	March	       17	         188887.00
	2024	2	April	        9	         2859.00
	2024	2	May	           10	         59845.00
	2024	3	August	        3	          1350.00
	2024	4	October	        3            7597.00
	2024	4	December	    4	          9396.0

-- Query 2: Top 10 Products by Revenue
-- Business Scenario: 
 "The product manager needs to identify top-performing products. 
  Show the top 10 products by revenue, along with their category, total units sold, and revenue contribution percentage."
-- Includes: Revenue percentage calculation

SELECT 
    p.product_name,
    p.category,
    SUM(f.quantity_sold) AS units_sold,
    SUM(f.total_amount) AS total_revenue,
	round (SUM(f.total_amount)/ SUM(SUM(f.total_amount)) over () * 100, 2) as revenue_percentage
FROM dim_product p
JOIN fact_sales f 
    ON f.product_key = p.product_id
GROUP BY 
    p.product_name,
    p.category
ORDER BY 
    total_revenue desc
    limit 10


# product_name	        category	  units_sold	total_revenue	revenue_percentage  
iPhone 13	            Electronics	            2	139998.00	    22.88
HP Laptop	            Electronics	            2	105998.00	    17.32
Samsung Galaxy S21	    Electronics	            2	91998.00	    15.03
Samsung TV 43inch	    ELECTRONICS	            2	65998.00	    10.78
Apple MacBook Pro	    ELECTRONICS	            1	52999.00	    8.66
OnePlus Nord	        Electronics	            1	45999.00	    7.52
Dell Monitor 24inch	    Electronics	            2	25998.00	    4.25
Boat Earbuds	        Electronics	            7	10493.00	    1.71
Puma Sneakers	        Fashion	                2	9198.00	        1.50
Organic Almonds	        Groceries	            9	8091.00	        1.32


-- Query 3: Customer Segmentation
-- Business Scenario: 
"Marketing wants to target high-value customers. Segment customers into 'High Value' (>₹50,000 spent), 
'Medium Value' (₹20,000-₹50,000), and 'Low Value' (<₹20,000). Show count of customers and total revenue in each segment."
-- Segments: High/Medium/Low value customers

select 
case when f.total_amount > 50000 then 'high_value'
	 when f.total_amount > 20000 then 'medium_value'
     else 'low_value' end as 'customer_segment',
          count(distinct c. customer_id) as customer_count,
          sum(f.total_amount) as total_revenue,
     avg(f.total_amount) as average_revenue
from dim_customer c
join fact_sales f
on f.customer_key = c.customer_key
group by customer_segment ;

# customer_segment	customer_count	total_revenue	average_revenue
high_value	                    5	298995.00	59799.000000
low_value	                    18	108971.00	4358.840000
medium_value	                5	203995.00	40799.000000    