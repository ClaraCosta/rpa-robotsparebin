from pymongo import MongoClient

class DatabaseConnector:
    def __init__(self, uri="mongodb://mongo:SGBPBkrSpqUHFUlfIDoVLauleMeOTafj@mongodb.railway.internal:27017", database="collection_robot_sparebin"):
        self.client = MongoClient(uri)
        self.db = self.client[database]