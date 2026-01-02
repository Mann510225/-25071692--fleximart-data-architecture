
1 Operation 1: Load Data(1 mark)
# Import the provided JSON file into collection 'products'

for doc in product_catalog:
    doc.pop("_id", None)

collection.delete_many({})  # Clear existing data})
rec = collection.insert_many(product_catalog)
print(len(rec.inserted_ids))
print("Data inserted successfully.")



2 Operation 2: Basic Query(2 marks)
# Find all products in "Electronics" category with price less than 50000. Return only: name, price, stock

q1 = collection.find({ "category": "Electronics", "price": { "$lt": 50000 } })

pd.DataFrame(list(q1))



3 Operation 3: Review Analysis(2 marks)
# Find all products that have average rating >= 4.0
# Use aggregation to calculate average from reviews array

pipeline1 = [   # Pipeline1 command taken from mongodb compass run pipeline and modified for jupyter notebook
    {
        '$unwind': '$reviews'
    }, {
        '$group': {
            '_id': '$_id',
            'averageRating': {
                '$avg': '$reviews.rating'
            }
        }
    }, {
        '$match': {
            'averageRating': {
                '$gte': 4.0
            }
        }
    }, {
        '$lookup': {
            'from': 'product_catalog',
            'localField': '_id',
            'foreignField': '_id',
            'as': 'productDetails'
        }
    }, {
        '$unwind': '$productDetails'
    }, {
        '$addFields': {
            'newRoot': '$productDetails'
        }
    }
]
pd.DataFrame(list(collection.aggregate(pipeline1)))



4 Operation 4: Update Operation(2 marks)
# Add a new review to product "ELEC001"
# Review: { user: "U999", rating: 4, comment: "Good value", date: ISODate() }

[
    {
        '$set': {
            'reviews': {
                '$concatArrays': [
                    '$reviews', [
                        {
                            'user_id': 'U999',
                            'username': 'U999',
                            'rating': 4,
                            'comment': 'Good value',
                            'date': datetime(2025, 12, 27, 8, 52, 29, tzinfo = timezone.utc)
                        }
                    ]
                ]
            }
        }
    }
]


5 Operation 5: Complex Aggregation(3 marks)
# Calculate average price by category. Return: category, avg_price, product_count.Sort by avg_price descending

operation_5 = [
    {
        '$group': {
            '_id': '$category',
            'avg_price': {
                '$avg': '$price'
            },
            'product_count': {
                '$sum': 1
            }
        }
    }, {
        '$sort': {
            'avg_price': -1
        }
    }, {
        '$project': {
            'category': '$_id',
            'avg_price': 1,
            'product_count': 1,
            '_id': 0
        }
    }
]
pd.DataFrame(list(collection.aggregate(operation_5)))