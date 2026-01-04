# FlexiMart Data Architecture Project

**Student Name:** [MANISH SHAH]
**Student ID:** [25071692]
**Email:** [mann510225@gmail.com]
**Date:** [25.12.2025]

## Project Overview

ETL Pipeline: Ingest raw CSV data into a relational database
Database Documentation: Document the database schema and relationships
Business Queries: Answer specific business questions using SQL
NoSQL Analysis: Analyze product data requirements and implement MongoDB queries
Data Warehouse: Build a star schema and generate analytical reports

## Repository Structure
├── part1-database-etl/
│   ├── etl_pipeline.py
│   ├── schema_documentation.md
│   ├── business_queries.sql
│   └── data_quality_report.txt
├── part2-nosql/
│   ├── nosql_analysis.md
│   ├── mongodb_operations.js
│   └── products_catalog.json
├── part3-datawarehouse/
│   ├── star_schema_design.md
│   ├── warehouse_schema.sql
│   ├── warehouse_data.sql
│   └── analytics_queries.sql
└── README.md

## Technologies Used

- Python 3.x, pandas, mysql-connector-python
- MySQL 8.0 / PostgreSQL 14
- MongoDB 6.0

## Setup Instructions

### Database Setup

```bash
# Create databases
mysql -u root -p -e "CREATE DATABASE fleximart;"
mysql -u root -p -e "CREATE DATABASE fleximart_dw;"

# Run Part 1 - ETL Pipeline
python part1-database-etl/etl_pipeline.py

# Run Part 1 - Business Queries
mysql -u root -p fleximart < part1-database-etl/business_queries.sql

# Run Part 3 - Data Warehouse
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_schema.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_data.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/analytics_queries.sql


### MongoDB Setup

mongosh < part2-nosql/mongodb_operations.js

## Key Learnings

1. How a real data ETL pipeline works 
   - Extract (convert csv to dataframes in jupt nb & py files)
   - Transform ( Clean data of missing, null values, format date & time)
   - Load (load data in mysql - match schema / insert eact table row by row command)
2. How to document the database schema and relationships
3. Importance to defining a schema , preparing structure on mysql before loading data (mismatch with schema will not allow loading)
4. How to answer specific business questions using SQL - importance of join across different tables / facts & dimensions)
5. Strict nature of primary key & unique constraint
6. data cleaning mandatory before sql insertion as mysql tends to reject uncleaned data
7. Concept & usefulness of github, noSQl usage in mongobd, data warehouse usage in mysql
8. flowchart for submission 


## Challenges Faced

1. Challenge - remembering all python commands and sequence of py operations 
             - Uploading of data to mysql - lot of reworking done to change schema corrections & correct mismatch
    Solution - took help by revisiting Bitsom classes 
              - copilot inline was helpful in understanding syntax & py commands
               - cross checked errors and clarified confusions with help of chatgpt


