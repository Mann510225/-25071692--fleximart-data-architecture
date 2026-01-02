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





## Normalization Explanation

# Explain why this design is in 3 Normalization form (200-250 words)

THis design conforms to 3 Normalization form due to following reasons :
1. low redundancy due to removal of duplicates
2. Integrity of data and relationships
3. Efficient design with minimal dependencies - non key to non key relationship
4. Efficient storage and retrieval - separate distinct tables of customers, products, orders and order items

it satisfies 3NF requirements of being :
1 Normalization form (each tables contains atomic value , no multivariable or reporting groups)
2 Normalization form  (all tables have single attribute primary key and all non key in table are dependent on this primary key)
3 Normalization form  (no transitive dependency. Non-key attributes do not depend on other non-key attributes. 
    For example, customer city information is stored only in the Customers table and not repeated in Orders, and product details are stored only in the Products table.)
This design reduces data redundancy by storing customer, product, and order information in separate tables. 
It also prevents update anomalies by ensuring that changes are made in only one place, avoids insert anomalies by allowing independent insertion of records, and avoids delete anomalies by preserving important master data

# Identify functional dependencies
Functional Dependencies

Customers

customer_id → first_name, last_name, email, phone, city, registration_date

All non-key attributes depend only on customer_id.

Products

product_id → product_name, category, unit_price, stock_quantity

Product details depend solely on the product identifier.

Orders

order_id → customer_id, order_date, total_amount, status

Order information depends only on order_id.

Order_Items

order_item_id → order_id, product_id, quantity, unit_price, sub_total

Line-item details depend on the order item identifier.

sub_total is derived from quantity × unit_price.


# Explain how the design avoids update, insert, and delete anomalies
Update Anomalies
Customer, product, and order data are stored only once. For example, updating a customer’s email requires changing data in only the customers table, preventing inconsistent updates across multiple records.

Insert Anomalies
New customers or products can be added independently without requiring an order. Similarly, orders can be created without duplicating customer or product details.

Delete Anomalies
Deleting an order does not remove customer or product information, ensuring that important master data is preserved even if transactional data is removed.




















