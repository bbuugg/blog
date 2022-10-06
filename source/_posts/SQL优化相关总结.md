---
title: SQL优化相关总结
date: 2021-07-06 23:16:37
tags:
---

# SQL执行顺序
原文链接：https://blog.csdn.net/u011277123/article/details/54691260

#Pgsql 执行计划
http://mysql.taobao.org/monthly/2018/11/06/

<!-- more -->

# 其他
在数据库应用中，程序员们通过不断的实践总结了很多经验，这些经验是一些普遍适用的规则。每一个程序员都应该了解并记住它们，在构造SQL语句时，养成良好的习惯。以下10条比较重要的原则供大家参考。

原则1：尽量避免在列上做运算，这样会导致索引失败。例如原句为：

```
SELECT * FROM t WHERE YEAR(d) >= 2011;
```

优化为：

```
SELECT * FROM t WHERE ｄ　>= ‘2011-01-01’;
```

原则2：使用join时，应该用小结果集驱动大结果集。同时把复杂的join查询拆分成多个query。因为join多个表时，可能导致更多的锁定和堵塞。例如：

```sql
SELECT * FROM a JOIN b ON a.id = b.id

LEFT JOIN c ON c.time = a.date

LEFT JOIN d ON c.pid = b.aid

LEFT JOIN e ON e.cid = a.did
```

原则3：注意like模糊查询的使用，避免%%。例如原句为：

```
SELECT * FROM t WHERE name LIKE ‘%de%’
```

优化为：

```
SELECT * FROM t WHERE name >= ‘de’AND name <= ‘df’
```

原则4：仅列出需要查询的字段，这对速度不会有明显的影响，主要考虑节省内存。例如原句为：

```
SELECT * FROM Member；
```

优化为：

```
SELECT id,name,pwd FROM Member;
```

原则5：使用批量插入语句节省交互。例如原句为：

```
INSERT INTO t(id,name)VALUES(1,’a’);

INSERT INTO t(id,name)VALUES(2,’b’);

INSERT INTO t(id,name)VALUES(3,’c’);
```

优化为：

```
INSERT INTO t(id,name)VALUES(1,’a’),(2,’b’),(3,’c’);
```

原则6：limit的基数比较大的时候使用between。例如原句为：

```
SELECT * FROM article AS article RODER BY id LIMIT 1000000,10;
```

优化为：

```
SELECT * FROM article AS article WHERE id BETWEEN 1000000 AND 1000010 RODER BY id;
```

Between限定比limit快，所以海量数据访问时，建议between或是where替换掉limit。但是between也有缺陷，如果id中间有断行或是中间部分id不读取的情况，总读取的数量会少于预计数量！

在取比较后面的数据时，通过desc方式把数据反向查找，以减少对前段数据的扫描，让limit的基数越小越好！

原则7：不要使用rand()函数获取多条随机记录。例如：

```
select * from table order by rand() limit 20;
```

使用下面的语句代替：

```sql
Select * from ‘table’as t1 join(select rand(rand() * ((select max(id) from ‘table’)-(select min(id) from ‘table’))+(select min(id) from ‘table’))as id) as t2 where t1.id >= t2.id order by t1.id limit 1;
```

这是获取一条随机记录，这样即使执行20次，也比原来的语句高效。或者先用php产生随机数，把这个字符串传给MySQL，MySQL里用in查询。

原则8：避免使用null。

原则9：不要使用count(*)，而应该是count(1)。

原则10：不要做无谓的排序操作，而尽可能在索引中完成排序。