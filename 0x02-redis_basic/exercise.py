#!/usr/bin/env python3
"""Module containing class Cache"""
import redis
from uuid import uuid4
from typing import Union


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
