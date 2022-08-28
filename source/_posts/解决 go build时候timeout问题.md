---
title: 解决 go build时候timeout问题
date: 2021-08-29 12:43:21
tags:
---

默认安装的go 在 build的时候会出现长时间无响应，有类似如下报如下错误：

```
go: github.com/hyperledger/fabric-contract-api-go@v1.0.0: Get https://proxy.golang.org/github.com/hyperledger/fabric-contract-api-go/@v/v1.0.0.mod: dial tcp 172.217.27.145:443: i/o timeout
```

因为默认的go地址被墙了，所以我们要更换地址，更换为七牛云的镜像，直接运行下面两条命令即可：

```
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
```

原文地址：http://www.iamlintao.com/7194.html