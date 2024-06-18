#!/usr/bin/env python3
"""Module containing schools_by_topic method"""

def schools_by_topic(mongo_collection, topic):
    """returns the list of school having a specific topic"""
    filter = {
            "topics": {
                "$elemMatch": {
                    "$eq": topic,
                    },
                },
            }
    result = mongo_collection.find(filter)
    return list(result)
