#!/usr/bin/env python3
"""Module containing class Cache"""
import redis
from uuid import uuid4
from typing import Union, Callable
from functools import wraps


def count_calls(method: Callable) -> Callable:
    """Decorator that counts calls of Cache.store"""
    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """wrapper function"""
        self._redis.incr(method.__qualname__)
        return method(self, *args, **kwargs)
    return wrapper


def call_history(method: Callable) -> Callable:
    """Decorator that stores history of inputs and outputs"""
    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """wrapper function"""
        inputs = args
        outputs = method(self, *args, **kwargs)
        self._redis.rpush(method.__qualname__ + ":inputs",
                          str(inputs))
        self._redis.rpush(method.__qualname__ + ":outputs",
                          str(outputs))
        return outputs
    return wrapper


class Cache:
    """Class Cache"""
    def __init__(self) -> None:
        self._redis = redis.Redis()
        self._redis.flushdb()

    @count_calls
    @call_history
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """Store data in redis using the a random key"""
        key = str(uuid4())
        self._redis.set(key, data)

        return key

    def get(self, key: str, fn: Callable = None) -> Union[str,
                                                          bytes,
                                                          int,
                                                          float]:
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
