from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["performance_test"]
collection = db["sales"]

collection.create_index([("category", 1)])  # Створення індексу на поле category
print("Index on 'category' field created successfully.")