---
title: Memcached List all keys
date: 2021-08-31 20:49:33
tags:
---

In the general case, there is [no way to list all the keys](https://code.google.com/p/memcached/wiki/NewProgrammingFAQ#How_can_you_list_all_keys?) that a [memcached](http://www.danga.com/memcached/) instance is storing. You can, however, list something like the first 1Meg of keys, which is usually enough during development. Here’s how:

Telnet to your server:

```
telnet 127.0.0.1 11211
```

List the items, to get the slab ids:

```
stats items
STAT items:3:number 1
STAT items:3:age 498
STAT items:22:number 1
STAT items:22:age 498
END
```

The first number after ‘items’ is the slab id. Request a cache dump for each slab id, with a limit for the max number of keys to dump:

```
stats cachedump 3 100
ITEM views.decorators.cache.cache_header..cc7d9 [6 b; 1256056128 s]
END

stats cachedump 22 100
ITEM views.decorators.cache.cache_page..8427e [7736 b; 1256056128 s]
END
```

