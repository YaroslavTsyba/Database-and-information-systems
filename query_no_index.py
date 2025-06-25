from pymongo import MongoClient
import time

client = MongoClient("mongodb://localhost:27017/")
db = client["performance_test"]
collection = db["sales"]

time_start = time.time()

electronics_sales = collection.find({"category": "Electronics"}).to_list()

time_end = time.time()
time_diff = time_end - time_start
print(f"Time taken to query sales in Electronics category: {time_diff:.2f} seconds")