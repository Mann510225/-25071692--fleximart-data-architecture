# QUERY 1: CUSTOMER PURCHASE SUMMARYHISTORY   
# Business Question: "Generate a detailed report showing each customer's name, email, total number of orders placed, and total amount spent. 
Include only customers who have placed at least 2 orders and spent more than ₹5,000. Order by total amount spent in descending order."
USE fleximart;

SELECT
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
c.email,
SUM(o.total_amount) AS total_amount,
COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 
c.first_name,
c.last_name,
c.email
HAVING
COUNT(DISTINCT o.order_id)>= 2 AND
SUM(o.total_amount) > 5000
ORDER BY 
total_amount desc
-- OUTPUT --
customer_name	   email	          total_amount	total_orders
Lakshmi Krishnan	C012@noemail.com	85998.00	   2
Arjun Rao	       arjun.rao@gmail.com	82998.00	   2
Karthik Nair	karthik.nair@yahoo.com	57598.00	2
Amit Kumar	    C003@noemail.com	   57496.00	      2
Priya Patel	priya.patel@yahoo.com	51997.00	2
Swati Desai	swati.desai@gmail.com	51498.00	2
Rajesh Kumar	rajesh.kumar@gmail.com	36595.00	2
Anjali Mehta	anjali.mehta@gmail.com	17598.00	2
Ravi Verma	C007@noemail.com	10996.00	2
Kavya Reddy	C018@noemail.com	5697.00	2
Neha Shah	neha.shah@gmail.com	5596.00	2
Suresh Patel	suresh.patel@outlook.com	5348.00	2



# QUERY 2: PRODUCT SALES ANALYSIS

# Business Question: "For each product category, show the category name, number of different products sold, total quantity sold, 
and total revenue generated. 
Only include categories that have generated more than ₹10,000 in revenue. Order by total revenue descending."

USE fleximart;
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS num_products,
    (SUM(oi.quantity + 0)) AS total_qty_sold,
    (SUM(oi.subtotal + 0)) AS total_revenue
FROM products AS p
JOIN order_items AS oi
    ON oi.product_id = p.product_id
GROUP BY p.category
HAVING (SUM(oi.subtotal + 0)) > 10000
ORDER BY total_revenue DESC;

-- OUTPUT --
category	num_products	total_qty_sold	total_revenue
Electronics	9	23	547477.00
fashion	7	17	45883.00
Groceries	4	42	18601.00


# QUERY 3: MONTHLY SALES TRENDS
# Business Question: "Show monthly sales trends for the year 2024. For each month, display the month name, total number of orders, total revenue, 
and the running total of revenue (cumulative revenue from January to that month)."
USE fleximart;
SELECT
    MONTHNAME(order_month) AS month_name,
    total_orders,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS monthly_revenue
    FROM orders
    WHERE YEAR(order_date) = 2024
    GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
) t
ORDER BY order_month;

-- OUTPUT --
month_name	total_orders	monthly_revenue	cumulative_revenue
January	10	180335.00	180335.00
February	7	162991.00	343326.00
March	9	188887.00	532213.00
April	2	2859.00	535072.00
May	3	59845.00	594917.00
August	2	3349.00	598266.00
October	2	7597.00	605863.00
December	2	9396.00	615259.00