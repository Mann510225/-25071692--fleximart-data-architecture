## Create star_schema_design.md with these sections:
# Section 1: Schema Overview 

# FACT TABLE: fact_sales
Grain: One row per product per order line item
Business Process: Sales transactions
Measures (Numeric Facts):
- quantity_sold: Number of units sold
- unit_price: Price per unit at time of sale
- discount_amount: Discount applied
- total_amount: Final amount (quantity × unit_price - discount)
Foreign Keys:
- date_key → dim_date
- product_key → dim_product
- customer_key → dim_customer

# DIMENSION TABLE: dim_date
Purpose: Date dimension for time-based analysis
Type: Conformed dimension
Attributes:
- date_key (PK): Surrogate key (integer, format: YYYYMMDD)
- full_date: Actual date
- day_of_week: Monday, Tuesday, etc.
- month: 1-12
- month_name: January, February, etc.
- quarter: Q1, Q2, Q3, Q4
- year: 2023, 2024, etc.
- is_weekend: Boolean

 
# DIMENSION TABLE: dim_customer
Purpose
Captures customer-related descriptive attributes for customer segmentation and behavior analysis.
Type
Slowly Changing Dimension (Type 2 recommended for tracking changes in customer attributes).
Attributes
-	customer_key (PK): Surrogate key
-	customer_id: Business customer identifier
-	first_name: Customer First name
-	last_name : Customer Surname
-	email: Email address
-	phone: Contact number
-	city : name of the city
-	registration_date: Date customer joined
This dimension supports insights such as customer lifetime value, geographic sales distribution, and segment-wise performance.


# DIMENSION TABLE: dim_product
Purpose
Stores descriptive information about products sold.
Type
Slowly Changing Dimension (Type 2 can be applied if historical tracking is required).
Attributes
-	product_key (PK): Surrogate key
-	product_id: Business product identifier
-	product_name: Name of the product
-	category: Product category (e.g., Electronics, Apparel)

This dimension allows analysis such as sales by category, product performance, and product-level profitability 

## Section 2: Design Decisions (3 marks - 150 words)
# Explain:
# Why you chose this granularity (transaction line-item level)
Granularity (Grain) is the level of detail at which data is stored in the fact table of datawarehouse dw. 
it is the lowest level of data capture. eg sales per product per day per store , yield per man per mth.
Though the choice of granularity affects the size of fact table and performnce of dw; 
it ensures better analysis of details through efficient drill down process.

# Why surrogate keys instead of natural keys
Surrogate keys are system generated UNIQUE NUMERIC identifiers, used as orimary keys in dimesnions.
they differe from normal business Natural keys (primary keys) which are alphanumeric or composite in nature.
Advantage :
1. these simple integers (surrogate keys) improve query join performance compared to aphanumeric keys
2. Ensure consistency even if source key is duplicate or changed.

# How this design supports drill-down and roll-up operations
Separation of facts & dimensions and demnormalization of dimensions reduce join functions and improve performance.
This support smooth aggregation function (roll_up operations) and drill down (going into granular details) operations.
Roll up : aggregation of dim_date - date to mth to quarter to year
Drill down : Granularization of category to product to order item


## Section 3: Sample Data Flow (3 marks)
# Show an example of how one transaction flows from source to data warehouse:

In the FlexiMart OLTP system, 
Order 101 is placed by customer John Doe for product Laptop with quantity 2 at a unit price of ₹50,000 on 15-01-2024.

During the ETL process, descriptive data is stored in dimension tables and numeric measures are stored in the fact table. 
The date is mapped to dim_date (date_key = 20240115), 
The product to dim_product (product_key = 5), and 
The customer to dim_customer (customer_key = 12).
The final record is loaded into fact_sales with 
quantity_sold = 2, u
nit_price = 50000, 
total_amount = 100000, linked to dimension tables using surrogate keys.

Schema diagram is seen as given :

               dim_date
                   |
dim_customer — fact_sales — dim_product

