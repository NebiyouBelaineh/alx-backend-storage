#!/usr/bin/env python3
"""Modue containing method update_topics()"""

def update_topics(mongo_collection, name, topics):
    """Updates the topics of all school documents"""
    mongo_collection.update_many({"name": name}, { "$set": {"topics": topics}})
