---
title: Elasticsearch Api
toc: true
date: 2022-10-04 19:32:16
tags:
---

## GET /_cat/health?v 

集群健康状况，status有以下三种

- green 每个索引的primary shard和replica shard都是active状态的
- yellow 每个索引的primary shard都是activi状态，部分replica shard不是active状态，处于不可用状态
- red 部分索引数据可能丢失了

primary shard 和 replica shard 不能在同一个节点。启动第二个进程，就会在es集群中有2node，replica就会被分配，status就是green

<!-- more -->

## GET /_ca/indices?v 

查看集群中有哪些索引

## PUT /index/type/id

创建，更新的话会覆盖

## POST /index/type/id/_update
```json
{
    "doc": {
        "name": "lisi"
    }
}
```

更新某个字段
  
## 搜索

### query string search

例如：/index/type/_search?q=name:zhangsan&sort=age:desc

### DSL (Domain specific language)

> GET /index/type/_search

```json
{
    "query": {
        "match_all": {}
    }
}
```

添加排序和分页

```json
{
    "query": {
        "match": {
            "name": "yahu"
        }
    },
    "sort": {
        "age": "desc"
    },
    "from": 0,
    "size": 10
}
```

指定查询的字段

```json
{
    "query": {
        "match_all": {}
    },
    "_source": ["name", "age"]
}
```

添加query filter

```json
{
    "query": {
        "bool": {
            "must": {
                "match": {
                    "name": "yoga"
                }
            },
            "filter": {
                "range": {
                    "prize": {
                        "gt": 25
                    }
                }
            }
        }
    }
}
```

full text search (全文检索)

```json
{
    "query": {
        "match": {
            "name": "yoga xiaoxin"
        }
    }
}
```

> 匹配yoga, xiaoxin, yoga xiaoxin。相关度打分不同，yoga xiaoxin 相关度分数最高

短语搜索

```json
{
    "query": {
        "match_phrase": {
            "product": "yoga"
        }
    }
}
```

> 和全文检索相反，要求输入字符串要在指定字段中包含完全相同的。

highlight search

```json
{
    "query": {
        "match": {
            "product": "yoga"
        }
    },
    "highlight": {
        "fields": {
            "product": {}
        }
    }
}
```