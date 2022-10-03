---
title: order by 语句对null字段的默认排序
date: 2021-01-19 15:44:51
tags:
---

1.oracle 结论 (null 最大)

- order by colum asc 时，null默认被放在最后
- order by colum desc 时，null默认被放在最前
- nulls first 时，强制null放在最前，不为null的按声明顺序[asc|desc]进行排序
- nulls last 时，强制null放在最后，不为null的按声明顺序[asc|desc]进行排序 

<!-- more -->

2.mysql,sql server 结论 (null 最小)
order by colum asc 时，null默认被放在最前
order by colum desc 时，null默认被放在最后
ORDER BY IF(ISNULL(update_date),0,1) null被强制放在最前，不为null的按声明顺序[asc|desc]进行排序
ORDER BY IF(ISNULL(update_date),1,0) null被强制放在最后，不为null的按声明顺序[asc|desc]进行排序

    SELECT * FROM t1 where 1=1 ORDER BY IF(ISNULL(order_index),1,0),order_index asc,create_time desc


mysql nulls first nulls last解决方案
nulls first:

order by IF(ISNULL(my_field),0,1),my_field;  
nulls last:

order by IF(ISNULL(my_field),1,0),my_field; 
ISNULL函数当my_field字段为空是，返回1，当不为空时返回0

IF函数，如果第一个表达式为真，则返回第二个参数的值，否则，返回第三个参数的值。

EXTRACT(unit FROM date) 


pgsql null排在有值的行前面还是后面通过语法来指定 

```
--null值在前
select * from tablename order by id nulls first;
--null值在后
select * from tablename order by id nulls last;
--null在前配合desc使用
select * from tablename order by id desc nulls first;
--null在后配合desc使用
select * from tablename order by id desc nulls last;
举例:
null值在后,先按照count1降序排列,count1相同再按照count2降序排列
order by count1 desc nulls last, count2  desc nulls last;
```

mysql的null值排序和pgsql相反
https://www.w3school.com.cn/sql/func_extract.asp