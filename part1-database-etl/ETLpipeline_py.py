# %% [markdown]
# # Assignment: AI Data Architecture Design and Implementation

# %%
import pandas as pd
import numpy as np
import mysql.connector
from dateutil import parser
import re
from datetime import datetime

# %% [markdown]
# # upload files from csv data base

# %%
files = [
    r'D:\Manish\LEARNINGS\BITSOM\Assigments\Graded Assigment 3\customer_raw_data.csv',
    r'D:\Manish\LEARNINGS\BITSOM\Assigments\Graded Assigment 3\product_raw_data.csv',
    r'D:\Manish\LEARNINGS\BITSOM\Assigments\Graded Assigment 3\order_data.csv',
    r'D:\Manish\LEARNINGS\BITSOM\Assigments\Graded Assigment 3\order_item_data1.csv'
]


# %% [markdown]
# # Read files on pd system

# %%
df=pd.read_csv(files[0])
print(df.head())
df=pd.read_csv(files[1])
print(df.head())
df=pd.read_csv(files[2])
print(df.head())
df=pd.read_csv(files[3])
print(df.head())


# %% [markdown]
# # File Cleaning Process 
# # Customer data File 0 / Product data File 1 / Order data File 2 / Order Item File 3

# %%
# CLEANING PROCESS File 0 - Customer data
df=pd.read_csv(files[0])

print("Initial record count:", len(df))

df.replace({r'^\s*$': np.nan}, regex=True, inplace=True) 

df['email'] = df['email'].apply(lambda x: x.strip().lower() if isinstance(x, str) else x)
df['email'] = df['email'].fillna(
    df['customer_id'].astype(str) + '@noemail.com'
)

df['phone'] = (
    df['phone']
    .astype(str)
    .str.replace(r'\D', '', regex=True)
    .where(lambda x: x.str.len() >= 10)
)


df['registration_date'] = df['registration_date'].apply(lambda x: parser.parse(x).date() if pd.notnull(x) else x)

duplicate_count = df.duplicated().sum()
print(f'Duplicate records removed: {duplicate_count}')
df.drop_duplicates(inplace=True)

missing_values = df.isnull().sum().sum()
print(f'Total missing values after cleaning: {missing_values}')

print("After cleaning:")
print("Final record count:", len(df))
print(df.isnull().sum())
df = df.replace({np.nan: None})
print(df.head())




# %%
# CLEANING PROCESS  FILE 1
df=pd.read_csv(files[1])

# 1. intitial records
print("Initial record count:", len(df))

# 2. Replace empty strings with NaN
df.replace({r'^\s*$': np.nan}, regex=True, inplace=True) 
df = df.replace({np.nan: None}) 
# df['email'] = df['email'].apply(lambda x: x.strip().lower() if isinstance(x, str) else x)
# df['phone'] = df['phone'].apply(lambda x: re.sub(r'\D', '', x) if isinstance(x, str) else x)
# df['registration_date'] = df['registration_date'].apply(lambda x: parser.parse(x).date() if pd.notnull(x) else x)
duplicate_count = df.duplicated().sum()
print(f'Duplicate records removed: {duplicate_count}')
df.drop_duplicates(inplace=True)
missing_values = df.isnull().sum().sum()
print(f'Total missing values after cleaning: {missing_values}')

print("After cleaning:")
print("Final record count:", len(df))
print(df.isnull().sum())
df = df.replace({np.nan: None})

# %%
# CLEANING PROCESS FILE 2
df=pd.read_csv(files[2])
print("Initial record count:", len(df))
df.replace({r'^\s*$': np.nan}, regex=True, inplace=True)
# df['email'] = df['email'].apply(lambda x: x.strip().lower() if isinstance(x, str) else x)
# df['phone'] = df['phone'].apply(lambda x: re.sub(r'\D', '', x) if isinstance(x, str) else x)
df['order_date'] = df['order_date'].apply(lambda x: parser.parse(x).date() if pd.notnull(x) else x)
duplicate_count = df.duplicated().sum()
print(f'Duplicate records removed: {duplicate_count}')
df.drop_duplicates(inplace=True)
missing_values = df.isnull().sum().sum()
print(f'Total missing values after cleaning: {missing_values}')

print("After cleaning:")
print("Final record count:", len(df))
print(df.isnull().sum())
df = df.replace({np.nan: None})

# %% [markdown]
# # Creation of total amount column in order table

# %%
df['subtotal'] = df['quantity'] * df['unit_price']

orders_df = (
    df
    .groupby(['order_id', 'customer_id', 'order_date', 'status'], as_index=False)
    .agg(total_amount=('subtotal', 'sum'))
)

orders_df['order_date'] = pd.to_datetime(
    orders_df['order_date'],
    errors='coerce',
    dayfirst=True
).dt.date

# Remove bad rows
orders_df = orders_df.dropna(subset=['customer_id', 'order_date', 'total_amount'])

print(orders_df.head())

# %%
# CLEANING PROCESS File 3
df=pd.read_csv(files[3])

print("Initial record count:", len(df))

df.replace({r'^\s*$': np.nan}, regex=True, inplace=True) 

# df['email'] = df['email'].apply(lambda x: x.strip().lower() if isinstance(x, str) else x)

# df['phone'] = df['phone'].apply(lambda x: re.sub(r'\D', '', x) if isinstance(x, str) else x)

# df['registration_date'] = df['registration_date'].apply(lambda x: parser.parse(x).date() if pd.notnull(x) else x)

duplicate_count = df.duplicated().sum()
print(f'Duplicate records removed: {duplicate_count}')
df.drop_duplicates(inplace=True)

missing_values = df.isnull().sum().sum()
print(f'Total missing values after cleaning: {missing_values}')

print("After cleaning:")
print("Final record count:", len(df))
print(df.isnull().sum())
df = df.replace({np.nan: None})
print(df.head())

# %% [markdown]
# # UPLOAD into MYSQL system
# # Customer data File 0 / Product data File 1 / Order data File 2 / Order Item File 3

# %%
import mysql.connector 

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Mannu@510",
    database="fleximart"
)  

cursor = conn.cursor() # 

insert_query = """
INSERT IGNORE INTO customers
(customer_id,first_name, last_name, email, phone, city, registration_date)
VALUES (%s,%s, %s, %s, %s, %s, %s)
"""

### IGNORE is added as already product id is fed into mysql product table. 
# so to avoid double reading put IGNORE. otherwsie not required
inserted = 0
for _, row in df.iterrows():
    cursor.execute(insert_query, 
    (   row['customer_id'],
        row['first_name'],
        row['last_name'],
        row['email'],
        row['phone'],
        row['city'],
        row['registration_date']
    ))
    inserted += 1

conn.commit()
cursor.close()
conn.close()
print("✅ Data inserted successfully:", inserted)



# %%
import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Mannu@510",
    database="fleximart"
)

cursor = conn.cursor()

insert_query = """ 
INSERT IGNORE INTO Products  
(product_id, product_name, category, price, stock_quantity)
VALUES (%s, %s, %s, %s, %s)
"""

for _, row in df.iterrows():
    cursor.execute(insert_query, (
        row['product_id'],
        row['product_name'],
        row['category'],
        row['price'],
        row['stock_quantity']
    ))

conn.commit()

print("✅ Data inserted successfully:", inserted)

# %%
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Mannu@510",
    database="fleximart",
    autocommit=True
)

cursor = conn.cursor()

insert_query = """
INSERT IGNORE INTO orders (order_id, customer_id, order_date, total_amount, status)
VALUES (%s, %s, %s, %s, %s)
"""

inserted = 0
for _, row in orders_df.iterrows():
    cursor.execute(insert_query, (
        row['order_id'],
        row['customer_id'],
        row['order_date'],
        float(row['total_amount']),
        str(row['status'])
    ))
    inserted += 1

print("✅ Orders inserted:", inserted)

cursor.close()
conn.close()


# %%
import mysql.connector 

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Mannu@510",
    database="fleximart"
)  

cursor = conn.cursor() # 

insert_query = """
INSERT IGNORE INTO order_items
(order_item_id, order_id, product_id, quantity, unit_price,
       subtotal)
VALUES (%s,%s, %s, %s, %s, %s)
"""


for _, row in df.iterrows():
    cursor.execute(insert_query, 
    (   row['order_item_id'],
        row['order_id'],
        row['product_id'],
        row['quantity'],
        row['unit_price'],
        row['subtotal']
    ))

conn.commit()

print("✅ Data inserted successfully:", inserted)


# %% [markdown]
# data_quality_report.txt- Generated report showing:
# 
# Customer Data
# Number of records processed per file - 26
# Number of duplicates removed - 1
# Number of missing values handled - 0
# Number of records loaded successfully - 25
# 
# Product Data
# Number of records processed per file- 20
# Number of duplicates removed - 0
# Number of missing values handled - 4
# Number of records loaded successfully - 25
# 
# Order Data
# Number of records processed per file - 41
# Number of duplicates removed - 1
# Number of missing values handled - 3
# Number of records loaded successfully - 37
# 
# Order Item  Data
# Number of records processed per file - 41
# Number of duplicates removed - 1
# Number of missing values handled - 2
# Number of records loaded successfully - 37


