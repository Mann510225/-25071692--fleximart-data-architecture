## SECTION A : LIMITATION OF RDBMS

RDBMS manage structured by rigid data sets, enforcing ACID properties – Atomicity of data , Consistency of data, Isolation of transactions and Durability of content.
Fixed & rigid schema & Normalization, however, become a limitation to manage heterogenous data efficiently, like;
1.	flexible data or semi-structured data 
2.	diversified product attributes
3.	large volume / scale of data
for example, in dept store, product like jean, jacket , shirts come with different attributes of color , design , and within them are further diversification of sizes, making it difficult to store all product data in single row or table.

# In current scenario, relational database with struggle with :
1.	Products with different attributes (laptops with RAM , shoes with size & color) as list of product are a mix of structured data & semi-structured flexible data. These diversified information ( especially shoes ,color with different design & size & vice Versa) becomes difficult to manage by a rigid structed relationship.
2.	Frequent schema changes when adding new products types, will have its own limitation as ALTER or INSERT command which can be costly, risk data consistency & difficult in large data sets.
3.	Storing customer reviews as nested data will become difficult due to high volume & variability of content.



## SECTION B : NoSQL BENEFITS
NoSQL database are designed to store unstructured & semi structured data with high efficiency and flexible schemas and, unlike RDBMS ACID properties,  follow BASE like properties.
1.	Basically Available
2.	Soft state (flexible)
3.	Eventually Consistent for result point of view

# Based on these properties, NoSQL offers benefits like:
a.	Creation of flexible/dynamic scheme. Ability to store different records for different attributes (eg. Laptops with RAMS & Shoes with size & color)
b.	Can handle unstructured & semi structured data like JSON & document files, Key-Value (Redis) files, Graphs & wide column data models. Ideal of variable data like product specification & nested data like customer reviews.
c.	High scalability for rapidly growing data (horizontal scalability), unlike RDBMS which has vertical scalability.
d.	Better operational performance in large volumes  & real time data eg. Netflix streaming 
e.	High availability, making data available even if some nodes fail.
 
# Explain how MongoDB solves these problems using:
MongoDB is schema-less, meaning documents in the same collection can have different fields. 
This offers flexible, schema-less document storage with built-in unique IDs and a rich query interface.
MongoDB offers implementation of :
1.	Flexible schema (document structure)
MongoDB’s database contains collections instead of tables; collections contain documents as records.
This makes it easier to store product attribute variables across different product specification. 
Moreover, any new product or product variable entry becomes easy, fast & less costly.

2.	Embedded documents (reviews within products)
Mongo BD support embedding of documents , data & arrays, especially in maintaining hierarchical nested system of customer reviews. 
Same can be stored in documents which enhances readability & reduces need for joins.
Thus, It allows embedding documents within other documents to avoid complex joins, trading off some redundancy.

3.	Horizontal Scalability
Mongo DB assists horizontal scalability through Sharding, where data is divided horizontally into multiple servers. With increase in volume and user traffic , additional nodes can be expanded, ensuring better performance, without risk.
In short, MongoDB suitable for large-scale and high-traffic applications through horizontal scalability.



## SECTION C : TRADE OFFS
What are two disadvantages of using MongoDB instead of MySQL for this product catalog?
MongoDB offers flexibility and scalability but trades off strong relational consistency and ease of complex reporting compared to MySQL. Two disadvantages can be :
1.	Comparatively lower data consistency
MongoDB often favours performance and availability over strong consistency, which can increase the risk of temporary data inconsistencies. ( considering CAP theorem of NoSQL, where out of Consistency, Availability &  Performance , only 2 property will be confirmed)
2.	Complex Analysis
MongoDB is less suitable for complex analytical queries that involve multiple joins, aggregations, and relational reporting. It’s aggregation framework can handle analytics but is generally more complex to write and maintain.
