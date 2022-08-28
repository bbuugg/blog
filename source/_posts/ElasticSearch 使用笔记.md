---
title: ElasticSearch 使用笔记
date: 2022-07-31 22:09:17
tags:
---

# Docker 启动
拉取镜像

```shell
docker pull elasticsearch
```
启动容器
```shell
docker run -d --name elasticsearch --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:tag
```

# Elasticsearch 8.0报错：received plaintext http traffic on an https channel, closing connection

**原因**：是因为ES8默认开启了 ssl 认证。

修改elasticsearch.yml配置文件，改为flase

```shell
xpack.security.enabled: false
```