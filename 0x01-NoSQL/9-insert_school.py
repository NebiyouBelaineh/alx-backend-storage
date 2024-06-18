#!/usr/bin/env python3
"""Module containing method insert_school"""

def insert_school(mongo_collection, **kwargs):
    """Inserts a new document and returns the _id"""
    results = mongo_collection.insert_one(kwargs)
    return results.inserted_id 
