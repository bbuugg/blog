---
title: Zabbix安装
toc: true
date: 2022-11-11 13:26:49
tags:
---

# 安装

官方安装文档：https://www.zabbix.com/documentation/5.4/zh/manual/installation/install

常见错误：

- configure: error: Invalid Net-SNMP directory - unable to find net-snmp-config

        Ubuntu:  apt-get install -y libsnmp-dev
        Centos:  yum install -y net-snmp-devel

- configure: error: Not found MySQL library

        Ubuntu： apt install -y libmysqlclient-dev
        Centos： yum install -y mariadb-devel

- configure: error: Unable to use libevent (libevent check failed)

        Ubuntu: apt install libevent-dev -y
        Centos: yum install libevent-devel  -y
- 配置前台报错 the table "dbversion" was not found.

        参考： https://www.zabbix.com/forum/zabbix-troubleshooting-and-problems/430162-the-table-dbversion-was-not-found

        找到源码的database里的schema.sql导入，cat schema.sql | psql -Upostgres -W -d zabbix
