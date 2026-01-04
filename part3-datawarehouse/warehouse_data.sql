INSERT DATA INTO THE TABLES


### INSERT dim_date 

INSERT INTO dim_date
(date_key, full_date, day_of_week, day_of_month, month, month_name, quarter, year, is_weekend)
SELECT
    DATE_FORMAT(d, '%Y%m%d'),
    d,
    DAYNAME(d),
    DAY(d),
    MONTH(d),
    MONTHNAME(d),
    QUARTER(d),
    YEAR(d),
    CASE WHEN DAYOFWEEK(d) IN (1,7) THEN TRUE ELSE FALSE END
FROM (
    SELECT DATE_ADD('2022-01-01', INTERVAL seq DAY) AS d
    FROM (
        SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 AS seq
        FROM (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
              UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
             (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
              UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
             (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
              UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c,
             (SELECT 0 N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
              UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
    ) seqs
    WHERE DATE_ADD('2022-01-01', INTERVAL seq DAY) <= '2024-12-31'
) dates;

INSERT INTO fleximart_dw.dim_customer
(customer_id, first_name, last_name, email, phone, city, registration_date)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.city,
    c.registration_date
FROM fleximart.customers c;

INSERT INTO fleximart_dw.dim_product
(product_id, product_name, category)
SELECT
    p.product_id,
    p.product_name,
    p.category  
FROM fleximart.products p;

INSERT INTO fact_sales
(date_key, product_key, customer_key, quantity_sold, unit_price, total_amount)
SELECT
    dd.date_key,
    dp.product_key,
    dc.customer_key,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS total_amount
FROM fleximart.order_items oi
JOIN fleximart.orders o
    ON oi.order_id = o.order_id
JOIN dim_date dd
    ON o.order_date = dd.full_date
JOIN dim_product dp
    ON oi.product_id = dp.product_id
JOIN dim_customer dc
    ON o.customer_id = dc.customer_id;




## Minimum Data Requirements:

dim_date: 30 dates (January-February 2024)
dim_product: 15 products across 3 categories
dim_customer: 12 customers across 4 cities
fact_sales: 40 sales transactions

SELECT * from dim_date
WHERE month_name = 'January' AND year = 2024
LIMIT 10

date key,date_full,day_name,day_of_month,month_of_year,month_name,month_number,year,is_weekend
20240101,'2024-01-01','Monday',1,1,'January','1',2024,0
20240102,'2024-01-02','Tuesday',2,1,'January','1',2024,0
20240103,'2024-01-03','Wednesday',3,1,'January','1',2024,0
20240104,'2024-01-04','Thursday',4,1,'January','1',2024,0
20240105,'2024-01-05','Friday',5,1,'January','1',2024,0
20240106,'2024-01-06','Saturday',6,1,'January','1',2024,1
20240107,'2024-01-07','Sunday',7,1,'January','1',2024,1
20240108,'2024-01-08','Monday',8,1,'January','1',2024,0
20240109,'2024-01-09','Tuesday',9,1,'January','1',2024,0
20240110,'2024-01-10','Wednesday',10,1,'January','1',2024,0

SELECT * from dim_date
WHERE month_name = 'February' AND year = 2024
LIMIT 10
date key,date_full,day_name,day_of_month,month_of_year,month_name,month_number,year,is_weekend
20240201,'2024-02-01','Thursday',1,2,'February','2',2024,0
20240202,'2024-02-02','Friday',2,2,'February','2',2024,0
20240203,'2024-02-03','Saturday',3,2,'February','2',2024,1
20240204,'2024-02-04','Sunday',4,2,'February','2',2024,1
20240205,'2024-02-05','Monday',5,2,'February','2',2024,0
20240206,'2024-02-06','Tuesday',6,2,'February','2',2024,0
20240207,'2024-02-07','Wednesday',7,2,'February','2',2024,0
20240208,'2024-02-08','Thursday',8,2,'February','2',2024,0
20240209,'2024-02-09','Friday',9,2,'February','2',2024,0
20240210,'2024-02-10','Saturday',10,2,'February','2',2024,1

SELECT * from dim_product
Limit 15
product_key,product_id,product_name,category
'P001','P001','Samsung Galaxy S21','Electronics'
'P002','P002','Nike Running Shoes','fashion'
'P003','P003','Apple MacBook Pro','ELECTRONICS'
'P004','P004','Levi's Jeans','Fashion'
'P005','P005','Sony Headphones','electronics'
'P006','P006','Organic Almonds','Groceries'
'P007','P007','HP Laptop','Electronics'
'P008','P008','Adidas T-Shirt','FASHION'
'P009','P009','Basmati Rice 5kg','groceries'
'P010','P010','OnePlus Nord','Electronics'
'P011','P011','Puma Sneakers','Fashion'
'P012','P012','Dell Monitor 24inch','Electronics'
'P013','P013','Woodland Shoes','fashion'
'P014','P014','iPhone 13','Electronics'
'P015','P015','Organic Honey 500g','Groceries'

SELECT * from dim_customer
Limit 12
customer_key,customer_id,first_name,last_name,email,city
'C001','C001','Rahul','Sharma','rahul.sharma@gmail.com','9876543210.0','Bangalore','2023-01-15 00:00:00'
'C002','C002','Priya','Patel','priya.patel@yahoo.com','-9988776564.0','Mumbai','2023-02-20 00:00:00'
'C003','C003','Amit','Kumar','C003@noemail.com','9765432109.0','Delhi','2023-10-03 00:00:00'
'C004','C004','Sneha','Reddy','sneha.reddy@gmail.com','9123456789.0','Hyderabad','2023-04-15 00:00:00'
'C005','C005','Vikram','Singh','vikram.singh@outlook.com','9988112233.0','Chennai','2023-05-22 00:00:00'
'C006','C006','Anjali','Mehta','anjali.mehta@gmail.com','9876543210.0','Bangalore','2023-06-18 00:00:00'
'C007','C007','Ravi','Verma','C007@noemail.com','919877000000.0','Pune','2023-07-25 00:00:00'
'C008','C008','Pooja','Iyer','pooja.iyer@gmail.com','9123456780.0','Bangalore','2023-08-15 00:00:00'
'C009','C009','Karthik','Nair','karthik.nair@yahoo.com','9988776644.0','Kochi','2023-09-30 00:00:00'
'C010','C010','Deepa','Gupta','deepa.gupta@gmail.com','9871234567.0','Delhi','2023-12-10 00:00:00'
'C011','C011','Arjun','Rao','arjun.rao@gmail.com','9876509876.0','Hyderabad','2023-05-11 00:00:00'
'C012','C012','Lakshmi','Krishnan','C012@noemail.com','9988001122.0','Chennai','2023-01-12 00:00:00'

SELECT * from fact_sales
Limit 40
sales_key,date_key,product_key,customer_key,quantity_sold,unit_price,total_amount
1,20240102,'P006','C010',5,'899.00','4495.00'
2,20240103,'P001','C002',1,'45999.00','45999.00'
3,20240115,'P007','C003',1,'52999.00','52999.00'
4,20240115,'P001','C001',1,'45999.00','45999.00'
5,20240116,'P004','C002',2,'2999.00','5998.00'
6,20240120,'P009','C005',3,'650.00','1950.00'
7,20240122,'P012','C006',1,'12999.00','12999.00'
8,20240123,'P005','C007',2,'1999.00','3998.00'
9,20240128,'P011','C009',1,'4599.00','4599.00'
10,20240202,'P014','C011',1,'69999.00','69999.00'
11,20240210,'P019','C014',2,'1499.00','2998.00'
12,20240218,'P016','C017',1,'32999.00','32999.00'
13,20240220,'P020','C018',2,'1899.00','3798.00'
14,20240222,'P018','C019',10,'120.00','1200.00'
15,20240225,'P010','C020',1,'45999.00','45999.00'
16,20240228,'P017','C021',2,'2999.00','5998.00'
17,20240302,'P019','C003',3,'1499.00','4497.00'
18,20240304,'P014','C016',1,'69999.00','69999.00'
19,20240312,'P002','C007',2,'3499.00','6998.00'
20,20240315,'P015','C008',4,'450.00','1800.00'
21,20240318,'P007','C009',1,'52999.00','52999.00'
22,20240322,'P012','C011',1,'12999.00','12999.00'
23,20240325,'P016','C012',1,'32999.00','32999.00'
24,20240328,'P005','C013',2,'1999.00','3998.00'
25,20240330,'P008','C014',2,'1299.00','2598.00'
26,20240401,'P018','C015',8,'120.00','960.00'
27,20240408,'P020','C018',1,'1899.00','1899.00'
28,20240502,'P003','C012',1,'52999.00','52999.00'
29,20240503,'P009','C004',5,'650.00','3250.00'
30,20240504,'P006','C017',4,'899.00','3596.00'
31,20240802,'P015','C013',3,'450.00','1350.00'
32,20241003,'P011','C006',1,'4599.00','4599.00'
33,20241004,'P019','C019',2,'1499.00','2998.00'
34,20241202,'P008','C015',3,'1299.00','3897.00'
35,20241204,'P013','C020',1,'5499.00','5499.00'
