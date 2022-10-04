---
title: Mysql5.* Mysql 8.0* 一条SQL实现树形递归查询
date: 2021-07-10 19:58:53
tags:
categories: mysql
---

用户表 user

| id   | username | pid  |
| ---- | -------- | ---- |
| 1    | 张三     | 0    |
| 2    | 李四     | 1    |
| 3    | 王五     | 2    |
| 4    | 赵六     | 3    |
| 5    | 孙七     | 4    |

拿到id为5的用户，查他的所有上级，如何用一条SQL实现树形的递归查询呢

<!-- more -->

Mysql5.* @变量迭代递归查询
老版本的Mysql（5.6）通过使用的@变量

```
SELECT T2.id, T2.`username` FROM (
 SELECT @r AS _id,(
    SELECT @r := pid FROM user WHERE id = _id
 ) AS parent_id,@l := @l + 1 AS lvl
 FROM
  ( SELECT @r := 5, @l := 0 ) vars,user h
 WHERE @r &lt;&gt; 0 )
 T1
 JOIN user T2 ON T1._id = T2.id
ORDER BY
 T1.lvl DESC
 
```

*Mysql8. 中不能这么用会报警告⚠**
Warning: #1287 Setting user variables within expressions is deprecated and will be removed in a future release. Please set variables in separate statements instead.

Mysql8.* CTE递归查询
Mysql8版本的支持了CTE递归查询的语法

```
 WITH RECURSIVE parent_cte AS (
    SELECT * FROM user WHERE id=91
        UNION ALL
        SELECT u.* FROM user u INNER JOIN parent_cte parent_cte2 ON u.id = parent_cte2.pid
 ) SELECT id,username FROM parent_cte ORDER BY id ASC
 
```

[本地](https://huue.cc/index.php/tag/本地/)Mysql8.* ，线上服务器Mysql5.6，在不改动数据库版本的情况下，使用用户[自定义](https://huue.cc/index.php/tag/自定义/)[函数](https://huue.cc/index.php/tag/函数/)Function 实现树形递归

Mysql Function[函数](https://huue.cc/index.php/tag/函数/)
// 在Mysql中创建getParentList函数

```
CREATE DEFINER=`root`@`%` FUNCTION `getParentList`(rootId varchar(100)) RETURNS varchar(1000) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
BEGIN
    DECLARE fid varchar(100) default '';
    DECLARE str varchar(1000) default rootId;
    WHILE rootId is not null  do
     SET fid =(SELECT PID FROM user WHERE ID = rootId);
     IF fid is not null THEN
         SET str = concat(str, ',', fid);
         SET rootId = fid;
     ELSE
         SET rootId = fid; 
     END IF;
END WHILE;
return str;
END
// 业务中直接调用函数
SELECT * from user where FIND_IN_SET(id,getParentList(5));
   
CTE
CTE，全名 Common Table Expressions
 
WITH
  cte1 AS (SELECT a, b FROM table1),
  cte2 AS (SELECT c, d FROM table2)
SELECT b, d FROM cte1 JOIN cte2
WHERE cte1.a = cte2.c;
 
```

cte1, cte2 为我们定义的CTE，可以在当前查询中引用

递归查询
先来看下递归查询的语法

```
WITH RECURSIVE cte_name AS
(
    SELECT ...      -- return initial row set
    UNION ALL / UNION DISTINCT
    SELECT ...      -- return additional row sets
)
SELECT * FROM cte;
 
```

定义一个CTE，这个CTE 最终的结果集就是我们想要的 ”递归得到的树结构&quot;，RECURSIVE 代表当前 CTE 是递归的
第一个SELECT 为 “初始结果集”
第二个SELECT 为递归部分，利用 &quot;初始结果集/上一次递归返回的结果集&quot; 进行查询得到 “新的结果集”
直到递归部分结果集返回为null，查询结束
最终UNION ALL 会将上述[步骤](https://huue.cc/index.php/tag/步骤/)中的所有结果集合并（UNION DISTINCT 会进行去重），再通过 SELECT * FROM cte; 拿到所有的结果集
可以参考下MySQL[开发](https://huue.cc/index.php/tag/开发/)文档：
https://dev.mysql.com/doc/refman/8.0/en/with.html
https://dev.mysql.com/doc/refman/8.0/en/with.html#common-table-expressions-recursive-examples
[文章](https://huue.cc/index.php/tag/文章/)来源于:https://blog.tius.cn/archives/260