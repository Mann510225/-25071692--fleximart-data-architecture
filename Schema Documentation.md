### Entity-Relationship Description



\### ENTITY: 



#### A) customers

Purpose: Stores customer master information used for order processing.



Attributes:

\- customer\_id: Unique identifier for each customer (Primary Key)

\- first\_name: Customer’s first name

\- last\_name: Customer’s last name

\- email: Customer’s email address

\- phone: Customer’s contact number

\- city: Customer’s city of residence

-registration date : 



Relationships:

\- One customer can place MANY orders (1:M relationship with orders table)



\### customers



| customer\_id | first\_name | last\_name | email                 |Phone           | city        |Registration date|

|------------|------------|-----------|------------------------|----------------|------------|------------------|



'C001'       | 'Rahul'     | 'Sharma'  | 'rahul.sharma@gmail.com'|9876543210   | 'Bangalore'| '2023-01-15'

'C002'       I 'Priya'     | 'Patel'   | 'priya.patel@yahoo.com' | 9988776564   |  'Mumbai'  | '2023-02-20'





#### B) Products

Purpose: Stores product master information used for order processing.



Attributes:

\- Product\_id: Unique identifier for each product (Primary Key)

-Product\_name : Name of the product (Brand \& sku)

-Category: generic explanation of product based on usage \& use

-unit\_price : Cost price of each product 

-stock\_quantity : quantity available for sale of the product





Relationships:

\- One product can appear in MANY order items. One order can have MANY products. M:M





Product\_id | Product\_name      | Category    | unit\_price | stock\_quantity  |

'P001'     | Samsung Galaxy S21|'Electronics'| '45999.00' | 150             |

'P002'     | 'Nike Running Shoes'| 'fashion'| '3499.00'   |  80             |





#### C) Orders



Purpose : Stores order master with list of orders along with customer \& product details 



Attributes : 



-order\_id : unique identifier for each order (primary key)

-customer\_id : unique identifier for each customer (foreign key in this case)

-order\_date : date of order execution

-total\_amount : total amount for each product sub total value

-status : whether the order is completed or pending 



Relationships:

\- One customer can place MANY orders . Each order belongs to ONE customer 1:M



order\_id | customer\_id | order\_date | total\_amount | status    |



1        |'C001'       | '2024-01-15'| '45999.00'   | 'Completed'|

2        | 'C002'      | '2024-01-16 | '5998.00'   | 'Completed' |









#### D) Order Items



Purpose : Order\_Items stores line-level product details for each order



Attributes :



-order\_item\_ id : unique identifier for each order items (primary key)

-order\_id : unique identifier for each order (foreign key)

-product\_id : Unique identifier for each product (foreign key)

-quantity: units sold/bought for each product

-unit\_price : cost price for each product

-sub\_total: Re value for any product sold 



Relationships:

\- One Order → MANY Order\_Items.One Product → MANY Order\_Items (M:M)



order\_item\_id | order\_id| product\_id | quantity | unit\_price | sub\_total|

101           |  1      | 'P001'     |   1      | 45999.00' | 45999.00'|

102           |  2      | 'P004'     |   2      | 2999.00'   | 5998.00'|



## 

## Normalization Explanation

## 

Explain why this design is in 3NF (200-250 words)

Identify functional dependencies

Explain how the design avoids update, insert, and delete anomalies





















