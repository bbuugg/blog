---
title: mysql导出csv文件
date: 2022-06-18 16:04:16
cover: https://tse2-mm.cn.bing.net/th/id/OIP-C.gUNsLfFkEFpk_hNfvSe-ZQHaHa?pid=ImgDet&rs=1
tags:
categories: mysql
---

CSV格式，其要点包括：

- 字段之间以逗号分隔，数据行之间以\r\n分隔；
- 字符串以半角双引号包围，字符串本身的双引号用两个双引号表示。

<!-- more -->

# 准备

首先需要查看下一个变量

```
SHOW VARIABLES LIKE "secure_file_priv";
```

可以看到，本地value的值为NULL。解释如下

（1）NULL，表示禁止。

（2）如果value值有文件夹目录，则表示只允许该目录下文件（PS：测试子目录也不行）。

（3）如果为空，则表示不限制目录。

修改

1. 把导入文件放入secure-file-priv目前的value值对应路径
2. 把secure-file-priv的value值修改为准备导入文件的放置路径
3. 去掉导入的目录限制。可修改mysql配置文件（Windows下为my.ini, Linux下的my.cnf），在[mysqld]下面，查看是否有: `secure_file_priv = `这样一行内容，表示不限制目录，等号一定要有，否则mysql无法启动。

修改完配置文件后，重启mysql生效。

重启后：

```
service mysqld stop
service mysqld start
```

如果不修改可能会有如下报错

```
The MySQL server is running with the --secure-file-priv option so it cannot execute this statement.
```

# 开始

CSV代表逗号分隔值。 您经常使用CSV文件格式在*Microsoft Excel*，*Open Office*，*Google Docs*等应用程序之间交换数据。

以CSV文件格式从MySQL数据库中获取数据将非常有用，因为您可以按照所需的方式分析和格式化数据。

MySQL提供了一种将查询结果导出到位于数据库服务器中的CSV文件的简单方法。

在导出数据之前，必须确保：

- MySQL服务器的进程对包含目标CSV文件的目标文件夹具有写访问权限。
- 要导出的目标CSV文件不能存在。

以下查询从`orders`表中查询选择已取消的订单：

```sql
SELECT 
    orderNumber, status, orderDate, requiredDate, comments
FROM
    orders
WHERE
    status = 'Cancelled';
```

要将此结果集导出为CSV文件，请按如下方式向上述查询添加一些子句：

```sql
SELECT 
    orderNumber, status, orderDate, requiredDate, comments
FROM
    orders
WHERE
    status = 'Cancelled' 
INTO OUTFILE 'F:/worksp/mysql/cancelled_orders.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ';' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n';
```

该语句在`F:/worksp/mysql/`目录下创建一个包含结果集，名称为`cancelled_orders.csv`的CSV文件。

CSV文件包含结果集中的行集合。每行由一个回车序列和由`LINES TERMINATED BY '\r\n'`子句指定的换行字符终止。文件中的每行包含表的结果集的每一行记录。

每个值由`FIELDS ENCLOSED BY '"'`子句指示的双引号括起来。 这样可以防止可能包含逗号(`，`)的值被解释为字段分隔符。 当用双引号括住这些值时，该值中的逗号不会被识别为字段分隔符。

## 将数据导出到文件名包含时间戳的CSV文件

我们经常需要将数据导出到CSV文件中，该文件的名称包含创建文件的时间戳。 为此，您需要使用[MySQL准备语句](http://www.yiibai.com/mysql/prepared-statement.html)。

以下命令将整个`orders`表导出为将时间戳作为文件名的一部分的CSV文件。

```sql
SET @TS = DATE_FORMAT(NOW(),'_%Y%m%d_%H%i%s');

SET @FOLDER = 'F:/worksp/mysql/';
SET @PREFIX = 'orders';
SET @EXT    = '.csv';

SET @CMD = CONCAT("SELECT * FROM orders INTO OUTFILE '",@FOLDER,@PREFIX,@TS,@EXT,
    "' FIELDS ENCLOSED BY '\"' TERMINATED BY ';' ESCAPED BY '\"'",
    "  LINES TERMINATED BY '\r\n';");

PREPARE statement FROM @CMD;

EXECUTE statement;
```

下面，让我们来详细讲解上面的命令。

- **首先**，构造了一个具有当前时间戳的查询作为文件名的一部分。
- **其次**，使用`PREPARE`语句`FROM`命令准备执行语句。
- **第三**，使用`EXECUTE`命令执行语句。

可以通过[事件](http://www.yiibai.com/mysql/triggers/working-mysql-scheduled-event.html)包装命令，并根据需要定期安排事件的运行。

## 使用列标题导出数据

如果CSV文件包含第一行作为列标题，那么该文件更容易理解，这是非常方便的。

要添加列标题，需要使用[UNION](http://www.yiibai.com/sql-union-mysql.html)语句如下：

```sql
(SELECT 'Order Number','Order Date','Status')
UNION 
(SELECT orderNumber,orderDate, status
FROM orders
INTO OUTFILE 'F:/worksp/mysql/orders_union_title.csv'
FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"'
LINES TERMINATED BY '\r\n');
```

如查询所示，需要包括每列的列标题。

## 处理NULL值

如果结果集中的值包含[NULL](http://www.yiibai.com/mysql/null.html)值，则目标文件将使用“`N/A`”来代替数据中的`NULL`值。要解决此问题，您需要将`NULL`值替换为另一个值，例如不适用(`N/A`)，方法是使用[IFNULL函数](http://www.yiibai.com/mysql/ifnull.html)，如下：

```sql
SELECT 
    orderNumber, orderDate, IFNULL(shippedDate, 'N/A')
FROM
    orders INTO OUTFILE 'F:/worksp/mysql/orders_null2na.csv' 
    FIELDS ENCLOSED BY '"' 
    TERMINATED BY ';' 
    ESCAPED BY '"' LINES 
    TERMINATED BY '\r\n';
```

我们用`N/A`字符串替换了`shippingDate`列中的`NULL`值。 CSV文件将显示`N/A`而不是`NULL`值。

给导出文件添加列名

```
select * into outfile '/tmp/test1.csv' fields terminated by ',' escaped by '' optionally enclosed  by '' lisnes terminated by '\n' from (select 'col1','col2','col3','col4','col5' union select id,user,url,name,age  from test) b;
```

使用MySQL命令结合sed的方法

- 使用-e参数执行命令，-s是去掉输出结果的各种划线
- 利用sed将字段之间的tab换成，并且将NULL替换成空字符
- 如果不想要标题行，可以使用-N参数

```sql
mysql -uroot  -p密码  test -e "select * from test where id > 1" -s |sed -e  "s/\t/,/g" -e "s/NULL/  /g" -e "s/\n/\r\n/g"  > /tmp/test2.csv
```

使用mysqldump导出

```sql
mysqldump -uroot  -p密码  -t -T/tmp/ test  test --fields-terminated-by=',' --fields-escaped-by='' --fields-optionally-enclosed-by='' 
```

```
test（第一个test） ：导出的数据库；
test（第二个test）：导出的数据表；
-t ：不导出create 语句，只要数据；
-T 指定到处的位置，注意目录权限，注意这里只到目录，默认名字是table_name.txt；
–fields-terminated-by=’,’：字段分割符；
–fields-enclosed-by=’’ ：字段引号；

```

//更多请阅读：https://www.yiibai.com/mysql/export-table-to-csv.html 