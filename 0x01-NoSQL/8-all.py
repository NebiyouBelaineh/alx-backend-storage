#!/usr/bin/env python3
"""Script that lists all documents in a collection"""

def list_all(mongo_collection):
    """Lists all documents in a collection"""
    results = mongo_collection.find()
    if results:
        return results
    return []

