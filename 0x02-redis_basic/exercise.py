#!/usr/bin/env python3
"""Module containing class Cache"""
import redis
from uuid import uuid4
from typing import Union, Callable


class Cache:
    """Class Cache"""
    def __init__(self) -> None:
        self._redis = redis.Redis()
        self._redis.flushdb()

    def store(self, data: Union[str, bytes, int, float]) -> str:
        """Store data in redis using the a random key"""
        key = str(uuid4())
        self._redis.set(key, data)

        return key

    def get(self, key: str, fn: Callable = None) -> Union[str, bytes, int, float]:
        """Get data from redis"""
        if fn is None:
            return self._redis.get(key)
        return fn(self._redis.get(key))
    
    def get_str(self, key: str) -> str:
        """Get data from redis as a string"""
        return self.get(key, str)

    def get_int(self, key: str) -> int:
        """Get data from redis as an integer"""
        return self.get(key, int)
