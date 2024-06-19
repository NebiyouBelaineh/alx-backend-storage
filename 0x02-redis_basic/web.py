#!/usr/bin/env python3
"""Module containing method get_page which handles web requests"""
import requests
import redis
from typing import Callable
from functools import wraps


r = redis.Redis()


def data_cacher(method: Callable) -> Callable:
    '''Caches the output of fetched data.
    '''
    @wraps(method)
    def invoker(url) -> str:
        '''The wrapper function for caching the output.
        '''
        r.incr(f'count:{url}')
        result = r.get(f'result:{url}')
        if result:
            return result.decode('utf-8')
        result = method(url)
        r.set(f'count:{url}', 0)
        r.setex(f'result:{url}', 10, result)
        return result
    return invoker


@data_cacher
def get_page(url: str) -> str:
    """Method that handles web requests"""
    return requests.get(url).text
