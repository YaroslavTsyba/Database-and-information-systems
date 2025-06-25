import matplotlib.pyplot as plt
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["performance_test"]
collection = db["sales"]

pipeline = [
  { "$group": { "_id": "$category", "count": { "$sum": 1 } } }
]

results = list(collection.aggregate(pipeline))

categories = [doc["_id"] for doc in results]
sales = [doc["count"] for doc in results]

plt.bar(categories, sales)
plt.xlabel("Category")
plt.ylabel("Total Sales")
plt.title("Sales per Category")
plt.show()
