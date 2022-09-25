---
title: ElasticSearch 使用笔记
date: 2022-07-31 22:09:17
tags:
---

# Docker 启动

## 拉取镜像

```shell
docker pull elasticsearch
```

## 启动容器

```shell
docker run -d --name elasticsearch --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:tag
```

# Elasticsearch 8.0报错：received plaintext http traffic on an https channel, closing connection

**原因**：是因为ES8默认开启了 ssl 认证。

修改elasticsearch.yml配置文件，改为flase

```shell
xpack.security.enabled: false
```

## index和type区别以及如何选择

对于 ES 的新用户来说，有一个常见的问题：要存储一批新数据时，应该在已有 index 里新建一个 type，还是给它新建一个 index？要想回答这个问题，我们必须先理解这两者是怎么实现的。

在过去，我们试图通过与关系数据库建立类比来使弹性搜索更容易理解：索引`index`就像数据库一样，类型`type`似于数据库中的表。这是一个错误：数据的存储方式是如此不同，以至于任何比较几乎都没有意义，这最终会导致在有害的情况下过度使用类型。

## index 是什么

索引`index`存储在一系列分片中，它们本身就是Lucene index。所以使用新索引应该注意：Lucene索引在磁盘空间，内存使用和使用的文件描述符方面有一个小而固定的开销。因此，单个大index比几个小index效率更高，Lucene index的固定开销更好地摊销在多个文档中。

另一个重要因素是如何搜索数据,虽然每个分片都是独立搜索的，但`Elasticsearch`最终需要合并所有搜索分片的结果。例如，搜索10个`index`,每个`index`有5个分片，则协调搜索请求执行的节点将需要合并5x10 = 50个分片结果。在这里需要注意：如果有太多的分片结果要合并，或者运行了一个产生大量分片响应的大量请求，合并这些分片结果的任务会非常消耗CPU和内存资源。这也是提倡少用`index`的原因。

## type是什么

使用`type`允许我们在一个`index`里存储多种类型的数据，这样就可以减少`index`的数量了。在使用时，向每个文档加入`_type` 字段，在指定type搜索时就会被用于过滤。使用type的一个好处是，搜索一个index下的多个type，和只搜索一个type相比没有额外的开销 —— 需要合并结果的分片数量是一样的。

但是，这也是有限制的：

- 不同type里的字段需要保持一致。例如，一个`index`下的不同`type`里有两个名字相同的字段，他们的类型（string, date 等等）和配置也必须相同。
- 只在某个`type`里存在的字段，在其他没有该字段的 type 中也会消耗资源。这是`Lucene Index`带来的常见问题：它不喜欢稀疏。由于连续文档之间的差异太大，稀疏的 posting list 的压缩效率不高。这个问题在 doc value 上更为严重：为了提高速度，doc value 通常会为每个文档预留一个固定大小的空间，以便文档可以被高速检索。这意味着，如果 Lucene 确定它需要一个字节来存储某个数字类型的字段，它同样会给没有这个字段的文档预留一个字节。未来版本的 ES 会在这方面做一些改进，但是我仍然建议你在建模的时候尽量避免稀疏。[1]
- 得分是由`index`内的统计数据来决定的。也就是说，一个 type 中的文档会影响另一个 type 中的文档的得分。

这意味着，只有同一个`index`的中的 type 都有类似的映射 (mapping) 时，才应该使用 `type`。否则，使用多个`type`可能比使用多个`index`消耗的资源更多。

## 如何选择

这是个困难的问题，它的答案取决于你用的硬件、数据和用例。首先你要明白 type 是有用的，因为它能减少 ES 需要管理的`Lucene Index`的数量。但是也有另外一种方式可以减少这个数量：创建 index 的时候让它的分片少一些。例如，与其在一个 index 里塞上 5 个 type，不如创建 5 个只有一个分片的 index。

在你做决定的时候可以问自己下面几个问题：

- 你需要使用父子文档吗？如果需要，只能在一个 index 里建立多个 type。
- 你的文档的映射是否相似？如果不相似，使用多个 index。
- 如果你的每个 type 都有足够多的文档，Lucene Index 的开销可以被分摊掉，你就可以安全的使用多个 index 了。如果有必要的话，可以把分片数量设小一点。
- 如果文档不够多，你可以考虑把文档放进一个 index 里的多个 type 里，甚至放进一个 type 里。

总之，你可能有点惊讶，因为 type 的使用场景没有你想象的多，这是正确的。由于我们上面提到原因，在一个 index 中使用多个 type 的情景其实很少。如果你的数据有不同的映射，那就给他们分配不同的 index。但是请记住，如果不需要很高的写入吞吐量，或者存储的文档数量不多，你可以通过减少 index 的分片来使集群中的分片数量保持合理。

[1] posting list 和 doc value 都是 Lucene 的压缩技术，原理是保存后一个文档和前一个文档的差异，而不是完整的文档。

# RestApi

> 请求须指定文档的索引名称，唯一的文档 ID，以及请求体中一个或多个键值对

## 查看映射

> GET /user/_mapping

```json
{
    "user": {
        "mappings": {
            "properties": {
                "name": {
                    "type": "text",
                    "fields": {
                        "keyword": {
                            "type": "keyword",
                            "ignore_above": 256
                        }
                    }
                },
                "age": {
                    "type": "long"
                }
            }
        }
    }
}
```

### 查看单个字段

> GET /user/_mapping/field/address

```json
{
    "user": {
        "mappings": {
            "address": {
                "full_name": "address",
                "mapping": {
                    "address": {
                        "type": "text",
                        "fields": {
                            "keyword": {
                                "type": "keyword",
                                "ignore_above": 25
                            }
                        }
                    }
                }
            }
        }
    }
}
```

## 新建映射

> PUT /user/_mapping

```json
{
    "properties": {
        "address": {
            "type": "text",
            "fields": {
                "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                }
            }
        }
    }
}

```

## 修改映射

text类型不能转为long类型

## 新增文档

> PUT /index/_doc/1

如果ID相同则更新

请求
```json
{
    "name": "john"
}
```
响应
```json
{
    "_index": "index",
    "_type": "_doc",
    "_id": "1",
    "_version": 3,
    "result": "deleted",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 2,
    "_primary_term": 1
}
```

> 索引index不存在则自动创建

## 查询文档

> GET /index/_doc/1

响应
```json
{
    "_index": "index",
    "_type": "_doc",
    "_id": "2",
    "_version": 1,
    "_seq_no": 4,
    "_primary_term": 1,
    "found": true,
    "_source": {
        "name": 123
    }
}
```

## 删除

> DELETE /index/_doc/2

响应

```json
{
    "_index": "index",
    "_type": "_doc",
    "_id": "2",
    "_version": 2,
    "result": "deleted",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 5,
    "_primary_term": 1
}
```

## 搜索

> 默认情况返回前10个符合查询的文档

> GET /user/_search

### 简单查询

> 按照age正序，查询前10个

```json
{
  "query": { "match_all": {} },
  "sort": [
    { "age": "asc" }
  ],
  "from": 0,
  "size": 10,
}
```

> 查询name包含包含zhang或者zhao的文档

```json
{
    "query": {
        "match": {
            "name": "zhang zhao"
        }
    }
}
```

如果需要完全匹配，查询name同时包含zhang和zhao的文档，可以使用match_phrase

### 复杂查询

> 使用布尔查询组合多个查询条件，must match、should match、must not match

```json
{
    "query" {
        "bool": {
            "must": {
                "match": {
                    "name": "zhang"
                }
            },
            "must_not": {
                "match": {
                    "scool": "shifan"
                }
            },
            "filter": {
                "range": {
                    "age": {
                        "lte": 10,
                        "gte": 5
                    }
                }
            }
        }
    }
}
```

布尔查询中每个 must，should,must_not 都被称为查询子句。每个
must 或者 should 查询子句中的条件都会影响文档的相关得分。得分越高，文档跟搜索条件匹配得越好。默认情况下，Elasticsearch 返回的文档会根据相关性算分倒序排列，must_not 子句中认为是过滤条件。它会过滤返回结果，但不会影响文档的相关性算分

> 你还可以明确指定任意过滤条件去筛选结构化数据文档，如上查询中的filter

## 删除索引

```
//删除指定索引
DELETE /index
DELETE /index1,index2
DELETE /index_*
// 删除全部
DELETE /_all 
DELETE /*
```

删除全部索引操作非常危险，禁止措施，elasticsearch.yml 做如下配置：
```shell
action.destructive_requires_name: true
```
这个设置使删除只限于特定名称指向的数据, 而不允许通过指定 _all 或通配符来删除指定索引库

## 聚合查询

> GET /user/_search

```json
{
  "size": 0,
  "aggs": {
    "group_by_country": {
      "terms": {
        "field": "country.keyword",
        "order": {
            "average_age": "desc"
        }
      },
      "aggs": {
        "average_age": {
            "avg": {
                "field": "age"
            }
        }
      }
    }
  }
}
```
其中size为0，所以只返回聚合数据，请求使用 terms 聚合 索引中对所有国家进行分组，使用组合聚合，查询分组内所有age字段平均数，还可以使用聚合字段进行排序


# 常见报错

- Text fields are not optimised for operations that require per-document field data like aggregations and sorting, so these operations are disabled by default. Please use a keyword field instead. Alternatively, set fielddata=true on [interests] in order to load field data by uninverting the inverted index. Note that this can use significant memory.

        因为interests的类型type是text，text或annotated_text字段doc_values默认为false，也就是说，text字段作为整体，默认没有索引
