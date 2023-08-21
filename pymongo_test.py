# import pymongo
# from django.conf import settings

# cluster = MongoClient("mongodb+srv://musaw650:8Wt2VOjnQfoutmbl@cluster0.aegfgxg.mongodb.net/?retryWrites=true&w=majority")
# db = cluster["test"]
# collection = db["test"] 

# # adding a document (entry) to db:
# document = {"_id": 0, "name": "Mishary", "country": "Kuwait"}
# collection.insert_one(document)

# #result = cluster.admin.command("ismaster")
import pymongo
from pymongo import MongoClient

#connect_string = 'mongodb+srv://<username>:<password>@<atlas cluster>/<myFirstDatabase>?retryWrites=true&w=majority' 

from django.conf import settings

#cluster = MongoClient("mongodb+srv://musaw650:8Wt2VOjnQfoutmbl@cluster0.aegfgxg.mongodb.net/?retryWrites=true&w=majority")

my_client = MongoClient("mongodb+srv://musaw650:8Wt2VOjnQfoutmbl@cluster0.aegfgxg.mongodb.net/?retryWrites=true&w=majority")

# First define the database name
dbname = my_client['reciters']

# Now get/create collection name (remember that you will see the database in your mongodb cluster only after you create a collection
collection_name = dbname["reciter_names"]

#let's create two documents
reciter_1 = {

    "name" : "Mishary",
    "country" : "Kuwait",
}
reciter_2 = {
    "_id": 2,
    "name" : "Hussary",
    "country" : "Egypt",
}
# Insert the documents
collection_name.insert_many([reciter_1,reciter_2])
collection_name.delete_one(reciter_1)






# Check the count
count = collection_name.count()
print(count)

# Read the documents
reciters = collection_name.find({})
# Print on the terminal
for r in reciters:
    print(r["name"])
# Update one document

# Delete one document
delete_data = collection_name.delete_one({'_id':'1'})

