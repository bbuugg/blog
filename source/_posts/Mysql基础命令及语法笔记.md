---
title: Mysql基础命令及语法笔记
date: 2021-07-05 22:49:20
tags:
---

# show 命令

> help show 查看允许的show语句

```sql
show databases
show tables
show [full] columns from <table>
show create database <name>
show status
show grants
show errors
show warnings
```

# set names 

设置编码
```
set names 'utf8';
```

# select

```sql
select distinct <column> from <table>
```

> 对于order by , `A` 和 `a` 不一定相同（在mysql中默认相同【字典排序】），取决于数据库怎么设计，通常可以改变这种行为。


> 对于没有排序的语句，返回的结果集的顺序没有特殊意义，又可能按照插入表的顺序，也有可能不是，只要返回总数正确，就是正常的。

## 正则

```sql
SELECT * FROM users WHERE name REGEXP BINARY '^cheng.*g$' --使用BINARY来区分大小写
```

```sql
SELECT * FROM information WHERE salary REGEXP '1000|2000' --OR匹配
```

```sql
SELECT * FROM users WHERE name REGEXT '[cz]ong' -- 单一字符，会匹配cong / zong； 可以使用否定 例如：[^cz]
```

>其他支持的正则 [0-9], \\\\-（特殊字符）-, 也可以用来引用元字符，例如\\\\f (换页)， \\\\n （换行），\\\\r （换行）, \\\\t （制表）, \\\\v （纵向制表），\\\ （反斜线），多数正则表达式使用单个反斜线转义特殊字符，mysql要求使用两个，一个由mysql解析，另外一个由正则表达式库解析。

like 也支持binary来区分大小写 `like binary`, 大小写主要取决于表的校对规则collect

### 字符类（character class）

| 类         | 说明                                               |
| ---------- | -------------------------------------------------- |
| [:alnum:]  | 任意字母和数字.(同[ a-zA-Z0-9])                    |
| [:alpha:]  | 任意字符（同[ a-zA-Z])                             |
| [:blank:]  | 空格和制表（同[ \lt])                              |
| [:cntrl:]  | ASCII控制字符（ASCII 0到31和127)                   |
| [:digit:]  | 任意数字（同[0-9])                                 |
| [:graph:]  | 与[ :print : ]相同，但不包括空格                   |
| [:lower:]  | 任意小写字母(同[ a-z])                             |
| [:print:]  | 任意可打印字符                                     |
| [:punct:]  | 既不在[ :alnum: ]又不在[ :cntrl: ]中的任意字符     |
| [:space:]  | 包括空格在内的任意空白字符（同[ \lf\ln \lrlltllv]) |
| [:upper:]  | 任意大写字母(同[A-Z])                              |
| [:xdigit:] | 任意十六进制数字（同[ a-fA-FO-9])                  |

```sql
select * from contracts where amount regexp '[[:digit:]]{2,4}'
-- 匹配2到四位数字
```

### 匹配多个实例

支持`*`,`+`, `?`, `{n}`, `{n,}`, `{n,m}` 其中m不能大于255 （mysql8测试可以输入大于255的数字，但是有没有效果没有测试）

### 元字符

| 元字符  | 说明       |
| ------- | ---------- |
| ^       | 文本的开始 |
| $       | 文本的结尾 |
| [[:<:]] | 词的开始   |
| [[:>:]] | 词的结尾   |

> 匹配词的边界，兼容perl的正则表达式通常使用\b单词边界 或者\B 非单词边界


使REGEXP起类似LIKE的作用， LIKE和REGEXP的不同在于、LIKE匹配整个串而REGEXP匹配子串。利用定位符,通过用^开始每个表达式，用$结束每个表达式可以使REGEXP的作用与LIKE一样。

> 简单的正则表达式测试可以在不使用数据库表的情况下用SELECT来测试正则表达式。 REGEXP检查总是返回0(没有匹配）或1(匹配）。可以用带文字串的REGEXP来测试表达式，并试验它们。相应的语法如下:

```sql
SELECT 'hello' REGEXP '[0-9]';
```

## 计算字段

### 拼接（concatenate）字段或者字符串

> 多数数据库采用`||`或者`+` 来拼接，而Mysql使用concat() 函数拼接。

### 删除多余空格

`rtrim()` `ltrim()` `trim()`

`AS` 别名，可以用来创建一个计算字段，当列名不符合规定的字符例如包含空格的时候可以使用别名代替，在原名易混淆时候扩充它。别名也称作`导出列（derivid column）`

## 函数

### 文本处理函数

| 函数                    | 说明                                  |
| ----------------------- | ------------------------------------- |
| LEFT(Str,length)        | 返回串左边的字符                      |
| Length()                | 返回串的长度                          |
| Locate()                | 找出一个串的子串                      |
| Lower()                 | 将串转为小写                          |
| Ltrim()                 | 去掉左边的空格                        |
| Right()                 | 返回串右边的字符                      |
| Rtrim()                 | 去掉右边空格                          |
| Soundex()               | 发音接近                              |
| SubString()             | 返回子串的字符                        |
| Upper()                 | 将串转为大写                          |
| LOCATE(substr,str)      | 寻找子串位置，返回数字，0表示没有找到 |
| LOCATE(substr,str,pos)  |                                       |
| POSITION(substr IN str) |                                       |
| INSTR(str,substr)       |                                       |
| REVERSE(Str)            | 翻转                                  |

```sql
SELECT * 
FROM party_course_study
WHERE LOCATE(findCode, '00001') >0
 
// 注：Mybatis使用场景，需要加 <![CDATA[ ]]>
SELECT * 
FROM party_course_study
WHERE <![CDATA[ LOCATE(findCode, '00001') > 0 ]]>
```


> 表中的SOUNDEX需要做进一步的解释。SOUNDEX是一个将任何文本串转换为描述其语音表示的字母数字模式的算法。SOUNDEX考虑了类似的发音字符和音节，使得能对串进行发音比较而不是字母比较。虽然SOUNDEX不是SQL概念，但MySQL（就像多数DBMS一样）都提供对SOUNDEX的支持。

### 日期和时间处理函数

| 函数                          | 说明                            |
| ----------------------------- | ------------------------------- |
| AddDate()                     | 增加一个日期（天、周等）        |
| AddTime()                     | 增加一个时间（时、分等）        |
| CurDate()                     | 返回当前日期                    |
| CurTime ()                    | 返回当前时间                    |
| Date()                        | 返回日期时间的日期部分          |
| DateDiff ()                   | 计算两个日期之差                |
| Date_Add()                    | 高度灵活的日期运算函数          |
| Date Format ()                | 返回一个格式化的日期或时间串    |
| Day()                         | 返回一个日期的天数部分          |
| DayOfWeek()                   | 对千一个日期， 返回对应的星期几 |
| Hour()                        | 返回一个时间的小时部分          |
| minute()                      | 返回一个时间的分钟部分          |
| Month ()                      | 返回一个日期的月份部分          |
| Now()                         | 返回当前日期和时间              |
| Second()                      | 返回一个时间的秒部分            |
| Time ()                       | 返回一个日期时间的时间部分      |
| Year()                        | 返回一个日期的年份部分          |
| DATE_FORMAT(CURDATE(),'%Y%m') | 结果为当前年和月                |
| CURRENT_TIMESTAM              | 当前时间戳                      |
| CURRENT_TIME                  | 当前时间                        |
| CURRENT_DATE                  | 当前日期                        |


mysql查询今天、昨天、本周、本月、上一月 、今年数据

```
--今天

select * from 表名 where to_days(时间字段名) = to_days(now());

--昨天

SELECT * FROM 表名 WHERE TO_DAYS( NOW( ) ) - TO_DAYS( 时间字段名) &lt;= 1

--本周

SELECT * FROM  表名 WHERE YEARWEEK( date_format(  时间字段名,'%Y-%m-%d' ) ) = YEARWEEK( now() ) ;

--本月

SELECT * FROM  表名 WHERE DATE_FORMAT( 时间字段名, '%Y%m' ) = DATE_FORMAT( CURDATE( ) ,'%Y%m' ) 

--上一个月

SELECT * FROM  表名 WHERE PERIOD_DIFF(date_format(now(),'%Y%m'),date_format(时间字段名,'%Y%m') =1

--本年

SELECT * FROM 表名 WHERE YEAR(  时间字段名 ) = YEAR( NOW( ) ) 


--上一月

SELECT * FROM 表名 WHERE PERIOD_DIFF( date_format( now( ) , '%Y%m' ) , date_format( 时间字段名, '%Y%m' ) ) =1



--查询本季度数据
select * from `ht_invoice_information` where QUARTER(create_date)=QUARTER(now());
--查询上季度数据
select * from `ht_invoice_information` where QUARTER(create_date)=QUARTER(DATE_SUB(now(),interval 1 QUARTER));
--查询本年数据
select * from `ht_invoice_information` where YEAR(create_date)=YEAR(NOW());
--查询上年数据
select * from `ht_invoice_information` where year(create_date)=year(date_sub(now(),interval 1 year));




--查询当前这周的数据 
SELECT name,submittime FROM enterprise WHERE YEARWEEK(date_format(submittime,'%Y-%m-%d')) = YEARWEEK(now());

--查询上周的数据
SELECT name,submittime FROM enterprise WHERE YEARWEEK(date_format(submittime,'%Y-%m-%d')) = YEARWEEK(now())-1;

--查询当前月份的数据
select name,submittime from enterprise   where date_format(submittime,'%Y-%m')=date_format(now(),'%Y-%m')

--查询距离当前现在6个月的数据
select name,submittime from enterprise where submittime between date_sub(now(),interval 6 month) and now();

--查询上个月的数据
select name,submittime from enterprise   where date_format(submittime,'%Y-%m')=date_format(DATE_SUB(curdate(), INTERVAL 1 MONTH),'%Y-%m')

select * from ` user ` where DATE_FORMAT(pudate, ' %Y%m ' ) = DATE_FORMAT(CURDATE(), ' %Y%m ' ) ;

select * from user where WEEKOFYEAR(FROM_UNIXTIME(pudate,'%y-%m-%d')) = WEEKOFYEAR(now())

select * 
from user 
where MONTH (FROM_UNIXTIME(pudate, ' %y-%m-%d ' )) = MONTH (now())

select * 
from [ user ] 
where YEAR (FROM_UNIXTIME(pudate, ' %y-%m-%d ' )) = YEAR (now())
and MONTH (FROM_UNIXTIME(pudate, ' %y-%m-%d ' )) = MONTH (now())

select * 
from [ user ] 
where pudate between 上月最后一天
and 下月第一天

where   date(regdate)   =   curdate();

select   *   from   test   where   year(regdate)=year(now())   and   month(regdate)=month(now())   and   day(regdate)=day(now())

SELECT date( c_instime ) ,curdate( )
FROM `t_score`
WHERE 1
LIMIT 0 , 30
```

### 数值处理函数

| 函数    | 说明               |
| ------- | ------------------ |
| Abs ()  | 返回一个数的绝对值 |
| Cos ()  | 返回一个角度的余弦 |
| Exp ()  | 返回一个数的指数值 |
| Mod ()  | 返回除操作的余数   |
| Pi（）  | 返回圆周率         |
| Rand () | 返回一个随机数     |
| Sin ()  | 返回一个角度的正弦 |
| Sqrt()  | 返回一个数的平方根 |
| Tan ()  | 返回一个角度的正切 |

## 聚集函数

|         |                  |
| ------- | ---------------- |
| AVG()   | 返回某列的平均值 |
| COUNT() | 返回某列的行数   |
| MAX()   | 返回某列的最大值 |
| MIN()   | 返回某列的最小值 |
| SUM()   | 返回某列值之和   |

> 不可以使用distinct *, count(*) 包含null，count(字段) 不包含null，；利用标准运算符，所有的聚集函数都可以执行多个列的运算

```sql
select count(distinct cid) from notes;
```

聚合函数可以聚合多个列的计算值，例如

```sql
select sum(price * stock) from products;
```

## concat系列函数

### concat

**mysql**

```
select concat(id, name) as id_and_name from users;
```

返回两个字段拼接的值，如果有一个字段的值为null，则返回null

**oracle, psql**

可以使用`||`来分割，例如

```
select id || name as id_and_name from users;
```

好像是上面这么写的，好久没用了。

### concat_ws

> concat with separator, 使用分隔符分割

```
select concat_ws(',', id, name) as id_and_name from users;
```

返回结果例如，分隔符如果为null则返回null

```
id = 1, name = 2
id_and_name 1,2
```

### group_concat

-  功能：将`group by`产生的同一个分组中的值连接起来，返回一个字符串结果。
- 语法：`group_concat( [distinct] 要连接的字段 [order by 排序字段 asc/desc ] [separator '分隔符'])`

> 在有group by的查询语句中，select指定的字段要么就包含在group by语句的后面，作为分组的依据，要么就包含在聚合函数中

例如，查询相同姓名中年龄最小的用户

```
select name, min(age) from users group by name;
```

如果要查出所有

```
select name, age from users order by age;
```

则name可能重复，可以使用group_concat

```
select name, group_concat(age) from users group by name; 
```

## 分组

`group by` 必须出现在`where`之后`order by`之前

使用`with rollup` 可以获取分组汇总级别

```sql
select count(id), id from users group by id with rollup;
```

我们经常发现用GROUP BY分组的数据确实是以分组顺序输出的。但情况并不总是这样，它并不是SQL规范所要求的。此外，用户也可能会要求以不同于分组的顺序排序。仅因为你以某种方式分组数据（获得特定的分组聚集值)，并不表示你需要以相同的方式排序输出。应该提供明确的ORDER BY子句，即使其效果等同于GROUP BY子句也是如此。

> 不要忘记ORDER BY一般在使用GROUP BY子句时，应该也给出ORDER BY子句。这是保证数据正确排序的唯一方法。千万不要仅依赖GROUP BY排序数据。

# 排序

## 随机排序

```
order by rand()
```

## 取消排序

```
order by null 
```

## 自定义排序

```
order by field(id, 1,3,4)
```

根据id自定义排序，如果id是null或者不存在于后面的列表中则排序为0，否则按照后面给定的排序进行排序


# SQL子句顺序

| 子句     | 说明               | 是否必须使用           |
| -------- | ------------------ | ---------------------- |
| SELECT   | 要返回的列或表达式 | 是                     |
| FROM     | 从中检索数据的表   | 仅在从表选择数据时使用 |
| WHERE    | 行级过滤           | 否                     |
| GROUP BY | 分组说明           | 仅在按组计算聚集时使用 |
| HAVING   | 组级过滤           | 否                     |
| ORDER BY | 输出排序顺序       | 否                     |
| LIMIT    | 要检索的行数       | 否                     |


# 子查询

```sql
select * from maker where country_id in (select country_id from country);
```

# 联表

自联结
内联
外联【左，右】
full join

# 组合查询

union 会去除重复行
union all 不会去除重复行

# 索引

禁用、启用索引

```sql
alter table users disable keys; --禁用
alter table users enable keys; --启用
```

> 在批量插入数据之前禁用索引，插入完成后启用索引

## 创建索引

### 添加PRIMARY KEY（主键索引）

```
ALTER TABLE `table_name` ADD PRIMARY KEY ( `column` ) 
```

### 添加UNIQUE(唯一索引)

```
ALTER TABLE `table_name` ADD UNIQUE ( `column` ) 
```

### 添加INDEX(普通索引)

```
ALTER TABLE `table_name` ADD INDEX index_name ( `column` ) 
```

### 添加FULLTEXT(全文索引)

#### 建表时建立

```sql
CREATE TABLE article ( 
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    title VARCHAR(200), 
    body TEXT, 
    FULLTEXT(title, body) 
) TYPE=MYISAM; 
```

#### 修改

```sql
ALTER TABLE `table_name` ADD FULLTEXT INDEX index_name( `column`, `column2`); 
```

#### 直接添加

```sql
CREATE FULLTEXT INDEX index_name(`column`) on `table_name`;
```

### 添加多列索引

```sql
ALTER TABLE `table_name` ADD INDEX index_name ( `column1`, `column2`, `column3` )
```

## 修改索引

mysql中没有真正意义上的修改索引，只有先删除之后在创建新的索引才可以达到修改的目的，原因是mysql在创建索引时会对字段建立关系长度等，只有删除之后创建新的索引才能创建新的关系保证索引的正确性；

如：将login_name_index索引修改为单唯一索引；

```
DROP INDEX login_name_index ON `user`; 
ALTER TABLE `user` ADD UNIQUE login_name_index ( `login_name` );
```

## 删除索引

格式：`DROP INDEX` 索引名称 `ON` 表名;

```sql
DROP INDEX login_name_index ON 'user';

ALTER TABLE `table_name` DROP INDEX 'index_name';
```

## 查询索引

格式：SHOW INDEX FROM 表名;

```
SHOW INDEX FROM `user`;
```


## 全文索引

全文本搜索时，MySQL不需要分别查看每个行，不需要分别分析和处理每个词。MySQL创建指定列中各词的-一个索引，搜索可以针对这些词进行。这样，MySQL可以快速有效地决定哪些词匹配(哪些行包含它们)，哪些词不匹配，它们匹配的频率，等等。

> Mysql5.7之后innodb引擎也支持全文索引

通常在建表的时候添加fulltext索引，例如

```sql
create table notes (
	title text,
	fulltext(title)
)engine=myisam;
```

也可以使用`create index` 或者`alter table`来添加索引

> match() against() 还可以作为一个列，

```
select match(title) against('rabbit') as sc from notes;
```

sc 表示全文检索的计算出的等级值

## 使用

参考：[MySQL使用全文索引(fulltext index)_椰汁菠萝-CSDN博客_fulltext index](https://blog.csdn.net/suo082407128/article/details/82663113)

> 使用全文索引需要注意的是：(基本单位是词)， MySQL默认的分词是所有非字母和数字的特殊符号都是分词符

使用Match() 和 Against() 来使用全文索引进行检索

```sql
select note_text from notes where match(note_text) against('book');
```

> match() 可以包含多个列，例如match(title,content) , 应该和建立索引时候的顺序一致
>
>  当查询多列数据时，建议在此多列数据上创建一个联合的全文索引，否则使用不了索引的

检索的文本越靠前，等级值越大。如果包含多个搜索项，则包含多个匹配词的行的等级值更高

## 查询扩展

扫描步骤如下：

1. 全文检索，筛选结果行
2. 检查匹配行，选择有用词
3. 再次全文检索，包含上个步骤选择词

```sql
select note_text from notes where match(note_text) against('book' with query expansion);
```

> 记录越多，文本越多，使用查询扩展返回的结果越好

## 布尔全文检索

> 即使没有fulltext索引也可以使用，但是比较慢且性能差

关键点：

- 要匹配的词
- 要排除的词（即使有匹配到的词也会排除掉）
- 排列提示（指定一些更重要的词，越重要的词等级越高）
- 表达式分组
- 其他

```sql
--匹配heavy 排除rope*（rope开头的词）
SELECT note_ text FROM productnotes WHERE Match(note_ text) Agai nst( 'heavy -rope*' IN BOOLEAN MODE);
```

| 布尔操作符 | 说明                                                         |
| ---------- | ------------------------------------------------------------ |
| +          | 包含，词必须存在                                             |
| -          | 排除，词必须不出现                                           |
| >          | 包含且增加等级值                                             |
| <          | 包含且减少等级值                                             |
| （）       | 把词组成子表达式，允许这些组表达式作为一个组被包含，排除，排列等 |
| ~          | 取消一个词的排序值                                           |
| *          | 词尾的通配符                                                 |
| ""         | 定义一个短语，它匹配整个短语                                 |

```sql
SELECT note_text FROM productnotes WHERE Match(note_text) Against('+rabbit +bait'IN BOOLEAN MODE);
--这个搜索匹配包含词rabbit和bait的行。
SELECT note_text FROM productnotes WHERE Match(note_text) Against('rabbit bait'IN BOOLEAN MODE); 
--没有指定操作符，这个搜索匹配包含rabbit和bait中的至少一个词的行。
SELECT note_text FROM productnotes WHERE Match(note_text) Against('"rabbit bait"'IN BOOLEAN MODE); 
--这个搜索匹配短语rabbitbait而不是匹配两个词rabbit和bait。
SELECT note_text FROM productnotes WHERE Match(note_text) Against('>rabbit <carrot'IN BOOLEAN MODE); 
--匹配rabbit和carrot,增加前者的等级，降低后者的等级。
SELECT note_text FROM productnotes WHERE Match (note_text) Against('+safe +(<Combination)'IN BOOLEAN MODE); 
--这个搜索匹配词safe和combination,降低后者的等级。
```

> 扩展

- 在索引全文本数据时，短词被忽略且从索引中排除。短词定义为那些具有3个或3个以下字符的词(如果需要,这个数目可以更改)。
- MySQL带有一个内建的非用词(stopword) 列表，这些词在索引全文本数据时总是被忽略。如果需要，可以覆盖这个列表(请参阅MySQL文档以了解如何完成此工作)。
- 许多词出现的频率很高，搜索它们没有用处(返回太多的结果)。因此，MySQL规定了一条50%规则，如果-一个词出现在50%以上的行中，则将它作为一个非用词忽略。50%规则不用于IN BOOLEAN MODE。
- 如果表中的行数少于3行，则全文本搜索不返回结果(因为每个词或者不出现，或者至少出现在50%的行中)。
- 忽略词中的单引号。例如，don't索 引为dont。
- 不具有词分隔符(包括日语和汉语)的语言不能恰当地返回全文本搜索结果。

**邻近操作符**

# 视图

## 使用视图的优势：

2. 重用SQL语句
3. 简化复杂的SQL
4. 使用表的组成部分而不是整个表，因此可以作保保护数据即授予表特定部分的访问权限，而不是整个表
5. 更改数据格式，视图可以返回与底层表示和格式不同的数据

视图本身不包含数据，使用视图实际上是使用视图的查询规则检索数据。如果修改源表的数据，视图中查询到的数据也会被修改。

> 可以通过视图修改数据

## 视图创建的规则和限制

1. 视图名不可与其他视图或表名重复
2. 创建视图数量没有限制
3. 创建视图必须有相应访问权限
4. 视图可以嵌套（使用视图再创建视图）
5. ORDER BY可以在视图中使用，但是如果检索的SQL中有ORDER BY则视图中的被覆盖
6. 视图不能索引，也不能有关联的触发器或者默认值
7. 视图可以和表一起使用

## 使用视图

### 创建视图

```sql
create view <view_name> as <dql>
```

### 查看创建视图语句

```sql
show create view <view_name>
```

### 删除视图

```sql
drop view <view_name>
```

### 修改视图

可以先删除视图在创建，也可以

```sql
create or repace view <view_name>
```

> 视图可以更新，但是如果Mysql认为基数据不能被正确更新，则不会更新，在以下情况下不会更新

- 分组 group by 和having
- 联结
- 子查询
- 并
- 聚集函数
- Distinct
- 导出（计算）列

> 上面的情况可能随着版本不同而有差异，一般情况下视图用来检索

# 存储过程

## 使用存储过程

```sql
call procedure_name(@in, @out)
```

## 创建存储过程

```
create procedure procedure_name() comment 'procedure comment'
begin
select * from notes;
end;
```

> 注意要先使用\d $ 或者delimiter $将分隔符;临时更改为$或者其他字符

其中`()`中可接受参数，begin, end 包含的为存储过程体

可以使用参数

```
create procedure get_username(in id int, out name varchar(10))
begin
select `username` into name from users where `id` = id;
end;
--没有测试，正确性未知
```

> 所有变量都必须以@开始

调用

```
call get_username(1, @ret);
```

查询执行返回值

```
select @ret;
```

### 定义变量

```sql
declare total decimal(8,2) default 0;
```

### 判断

```sql
if <variable> then
select * from users;
end if;
```

查看存储过程

```sql
show procedure status [like 'keywords'];
show create procedure <procudure_name>;
```

# 游标

> MySQL游标不同于其他多数DBMS， 只能用于存储过程和函数 【早期资料】

## 使用游标

- 使用游标前应该先声明（定义），这个过程实际没有检索数据，只是定义要使用的SELECT 语句
- 一旦声明后，应该打开游标来使用，这个过程用前面定义的SELECT 语句把数据检索出来
- 对于填有数据的游标，根据需要取出（检索）各行
- 结束后必须关闭游标

声明游标后，可以频繁地打开或者关闭游标，游标打开后，可以频繁地执行取操作

### 创建游标

**使用declare 定义游标**

```
declare products_f cursor for select * from products order by id;
```

**定义游标之后可以打开游标**

```
open products_f;
```

> open 语句执行查询，存储检索到地数据以提供浏览和滚动。

**游标处理完成，应该关闭游标**

```
close products_f;
```

> 关闭游标会释放游标所使用地内存等资源，所以当游标不再需要使用地时候就应该关闭游标，如果你不明确关闭游标，MySQL会在end语句时关闭游标。

**使用游标数据**

游标被打开后，可以使用fetch语句访问它的每一行。fetch指定检索所需的列，数据存放位置，还会向前移动游标内部指针，使下一条fetch语句检索下一行。

```
fetch products_f into o;
```

> 检索游标中结果的第一行并将数据存放到局部变量o中，再次执行fetch将检索下一行，除了使用repeat ,还可以使用其他循环语句来重复执行，直到使用leave手动退出，通常repeat的语法更适合对游标进行循环。



**例子**

```sql
create procedure products_p()
begin
	declare done boolean default 0;
	declare o int;
	declare products_f cursor 
	for 
	select id from users;
	-- continue handler 条件出现时被执行的代码 即 SQLSTATE '02000'出现时执行set done = 1
	-- SQLSTATE '02000'是一个未找到条件，即没有更多行时候不再循环 ，更多错误代码列可以查看MySQL手册https://dev.mysql.com/doc/refman/8.0/en/error-handling.html
	declare continue handler for SQLSTATE '02000' set done = 1;
	open products_f;
	-- 反复执行知道done为真
	repeat
		fetch products_f into o;
	until done end repeat;
	close products_f;
end
```

>  DECLARE语句的次序： DECLARE语句的发布存在特定的次序。用DECLARE语句定义的局部变量必须在定义任意游标或句柄之前定义，而句柄必须在游标之后定义，不遵守此顺序将产生错误消息。

# 触发器

MySQL响应delete, insert, update语句而执行触发的一条SQL或位于begin, end 之间的一组SQL。其他MySQL语句不支持触发器。

## 创建触发器

创建触发器需要提供以下信息

- 唯一的触发器名
- 触发器关联的表
- 触发器应该响应的活动（delete, insert, update）
- 触发器何时执行（前或者后）

> 触发器名必须在每个表中唯一，而在每个数据库中不一定唯一。这在其它DBMS中是不允许的。最好是在同一个数据库中保持触发器名唯一

使用`create trigger` 创建触发器

```sql
create trigger get_id after insert on users for each row select 'insert';
```

其中for each row 表示代码对每个插入执行

> 只有表支持触发器，视图不支持，每个表每个事件只允许一个触发器，因此每个表支支持6个触发器（insert, update, delete 前后 ）。 如果before触发器执行失败，则MySQL不执行请求的操作，如果触发器或语句本身失败，如果有after触发器，则不执行。

## 删除触发器

```sql
drop trigger get_id;
```

> 触发器不能更新或者覆盖，因此必须先删除再创建

## 使用

**insert 触发器**

- 在insert 触发器代码内，可引用一个NEW的虚拟表，访问被插入的行
- 在before insert 触发器内，NEW中的值也可以被更新（允许更改被插入的值）
- 对于auto_increment 列，NEW 在insert 之前包含0，在insert 执行之后包含新的自动生成的值

**delete 触发器**

在delete 触发器代码内，你可以引用一个名为OLD的虚拟表，访问被删除的行。

OLD中的值全部是只读的，不能更新

下面例子，使用OLD保存将要被删除的行到一个存档表中：

```
create trigger 触发器名 before delete on 表1 for each row 
begin 
	insert into 表2(列,列,列)values(old.表1列名,old.表1列名,old.表1列名);
end
```

删除表1的数据前会把数据存到结构相同的表2中
使用begin end 块的好处是触发器能容纳多条sql语句

**UPDATE 触发器 **

在update触发器代码中，可以引用一个名为old虚拟表访问以前的值，引用new虚拟表访问新更新的值

new中的值可能被更新，old中的值全部是只读的

```
create trigger 触发器名 before update on 表1 for each row set new.id = upper(new.id);
```


显然，每次更新一个行时，new.id 中的值（将用来更新表行的值）都用upper(new.id)替换。 也就是，如果new.id = 110，那用update更新表1的id时，将用110这个值更新。

**触发器的进一步介绍**

触发器可以用来创建审计跟踪，使用触发器，把更改记录到另一个表非常容易

mysql触发器不支持call语句，这表示不能从触发器内调用存储过程，只能把存储过程代码复制到触发器内

# 事务

## 术语

**事务（transaction）**指一组SQL语句

**回滚（rollback）**撤销指定SQL执行过程

**提交（commit）**将为存储的SQL语句结果写入数据表

**保留点（savepoint）**事务处理中设置的临时占位符（place holder） ,可以发布或者回退（与回退整个事务不同）

> 事务用来管理insert, update, delete 语句，不能回退drop，select， create 操作，即使使用了也不会撤销。

隐含事务提交：commit 或者rollback 后事务会自动关闭。

## 保留点

简单的commit或者rollback会撤销整个事务，但是实际上可能需要回滚或者提交一部分事务，就需要在事务处理块中放置合适的保留点，回滚时回滚到某个保留点，可以使用savepoint创建保留点。

```
savepoint delete1;
```

当需要回滚时，可以指定保留点

```
rollback to delete1
```

> 可以尽可能多地创建保留点，因为这样就可以更灵活地控制事务。当执行commit 或者rollback 后自动释放保留点，也可以使用release savepoint 释放保留点。

## 更改默认提交行为

关闭自动提交

```
set autocommit = 0
```

> 该标志是针对当前连接而不是服务器


# 字符集和编码

**字符集** 字母和符号的集合

**编码** 某个字符集内成员的内部表示

**校对** 规定字符集如何比较的指令

查看可用的校对和字符集

```
show collation;
show variables like '%character%';
show variables like '%collation%';
```

> 可以给单个表，单个列设置字符集和校对

select 语句中可以指定使用不同的校对，例如可以使用区分大小写的校对

```
select * from users order by username collate latin1_general_cs;
```

使用cast() 或者convert() 可以在字符集之间转换

# 数据备份

## 数据备份

mysqldump

mysqlhotcopy 从一个数据库复制全部数据

back up table / select into outfile    ->  restore table 

> 为保证所有数据都被写到磁盘（包括索引数据），可能需要在备份前使用flush tables 语句

命令行下具体用法如下： 

```shell
mysqldump -u用戶名 -p密码 -d 数据库名 表名 > 脚本名;
```

导出整个数据库结构和数据

```shell
mysqldump -h localhost -uroot -p123456 database > dump.sql
```

导出整个数据库结构和数据[包含建库语句]

```shell
mysqldump -h localhost -uroot -p123456 -B database > dump.sql
```

导出单个数据表结构和数据

```shell
mysqldump -h localhost -uroot -p123456  database table > dump.sql
```

导出整个数据库结构（不包含数据）

```shell
mysqldump -h localhost -uroot -p123456  -d database > dump.sql
```

导出单个数据表结构（不包含数据）

```shell
mysqldump -h localhost -uroot -p123456  -d database table > dump.sql
```

## 恢复

未登录

```sql
mysql -uroot -proot -h127.0.0.1 -P3306 test<s1.sql
```

登录

```sql
source ./a.sql
```

## 数据维护

- analyze table 检查表键是否正确
- check table 针对许多问题进行检查，在myisam引擎上还针对索引进行检查 , 如果在Myisam引擎上产生的结果不正确，可能需要使用repare table 修复响应的表。
- changed 检查自最后一次检查以来改动过的表
- extended 执行最彻底的检查
- fast 检查未正常关闭的表
- medium 检查所有被删除的链接并进行键检验
- quick 只进行快速扫描
- optimize table  优化表，如果有大量删除操作，应该使用

## 诊断启动问题

- --safe-mode 装载减去某些最佳配置的服务器
- --verbose 显示全文本消息，常与--help 联合使用

## 查看日志文件

- 错误日志，包含启停或任意关键位置的错误细节，日志名通常为hostname.err 位于data 目录， 可用--log-error 命令更改
- 查询日志，记录MySQL活动，在诊断问题时非常有用，日志可能会很快变得很大，所以不应该长期使用，位于data 目录，可用--log更改
- 二进制日志(bin-log)，记录更新或者可能更新过数据的所有语句，日志名通常为hostname-bin，位于data 目录，可用--log-bin 更改
- 慢查询日志， 可用--log-slow-queries 更改

# 性能优化

MySQL 使用一系列默认配置预先配置的，但随着需求增加，往往需要重新调整分配内存，缓冲区等等。可以使用下面的命令查看变量以及状态

```
show [global] variables;
show status;
```

当你遇到MySQL性能显著不良的时候，可以使用

```
show [full] processlist
```

查看活动以及他们的线程id和执行时间，可以使用kill 来终止

使用explain [analyze] 来解释如何执行一条SQL

一般来说，存储过程比一条一条执行SQL性能好

insert  支持一个可选的 delayed 关键字，如果使用，将把控制立即返回给调用程序，并且一旦有可能就实际执行该操作

在导入数据时，应该关闭自动提交，临时禁用索引，索引在导入完成后再开启

```
alter table notes disable/enable keys;
```

如果SQL存在大量OR，可以尝试使用union关键字连接结果

索引可能会加快查询，也可能会降低插入，更新速度

一般来说，尽量使用fulltext 而不是用like

# 其他语法

## alter

```
alter table <table_name>
(
	add column <column_name>    datatype [null|not null] [constraint],
	change column <column_name> datatype [null|not null] [constraint], 
	drop column <column_name>
	add index <column_name> 
)

ALTER table Teacher change Tid Tnum int; //修改列名
```

## create index

```
create index <index_name> on <table_name> (column [desc|asc], ...);
```

## create user

```
create user <username>[@host] identified [with mysql_native_password] by <password>; 
```

## drop

```
drop database|index|procedure|table|trigger|user|view|itemname;
```

## insert select

```
insert into users select * from users_bak;
```

## select

```sql
select 
	column 
from 
	table_name
where
union
group by 
having
order by
```

## 事务

```
start transaction;
```

## 排序

字符串以字典顺序排序，从左向右一次比较每一个字符，这将导致‘10‘位于’2‘之前，数值才能正确排序。

# 删除

```
drop procedure <procedure_name> [if exists]
```


# 插入

```sql
insert 语句耗时，可能因为等待而降低select性能，所以使用下面的语句降低有限级
INSERT LOW_PRIORITY INTO
--降低insert的有限级，同样适用于update,delete。
```

## 更新

更新可以使用子查询，即将查到的值更新到列。
update ignore 可以忽略错误

更新表不能包含该表的子查询例如

```
update user set sex = 1 where id in (select id from user where age > 8)
```

上面的SQL会报错，应该更改为

```
update user left inner join (select id from user where age > 8) set sex = 1;
```

> 上面的SQL只是示例

## 删除

```
truncate [table] users;
delete from 
```


# 其他

外键不能跨引擎，例如myisam不能添加innodb表的主键为外键

```sql
rename table notes to note;
alter table notes rename to note;
```

# Mysql添加自增列

两句查完：

```sql
set @rownum=0;

select (@rownum:=@rownum+1),colname from [tablename or (subquery) a];
```

一句查完：

```
select @rownum:=@rownum+1,colnum from (select @rownum:=0) a,[tablename or (subquery) b];
```


> 多条SQL要用`;`分割，单条SQL末尾的分号非必须，推荐加上分号，如果使用命令行，则必须要有结尾符。

> SQL 语句不区分大小写。最佳的方式是按照大小写惯例，且使用时保持一致。

> SQL可以分成多行，用更直观的格式表达

```sql
desc / describe <table>;
```

# 函数

## COALLESCE

```
COALESCE(expression, value1, value2, valuen)
```

返回按顺序取第一个不为NULL的值，都为NULL则返回NULL, 因为不判断空字符串，所以如果有空字符串则需要先处理，例如：

```
COALESCE(NULLIF(text1, ''), NULLIF(text2, ''))
```
其他替代
```
--MYSQL: 
  IFNULL(expression,value) 
--MSSQLServer: 
  ISNULL(expression,value) 
--Oracle: 
  NVL(expression,value)
```

## 格式化时间日期

https://www.cnblogs.com/shuilangyizu/p/8036620.html

## IF

Mysql的if既可以作为表达式用，也可在存储过程中作为流程控制语句使用
IF表达式

```
IF(expr1,expr2,expr3)
```



如果 expr1 是TRUE (expr1 <> 0 and expr1 <> NULL)，则 IF()的返回值为expr2; 否则返回值则为 expr3。IF() 的返回值为数字值或字符串值，具体情况视其所在语境而定。

```
select *,if(sva=1,"男","女") as ssva from taname where sva != ""
```



作为表达式的if也可以用CASE when来实现：

```
select CASE sva WHEN 1 THEN '男' ELSE '女' END as ssva from taname where sva != ''
```



在第一个方案的返回结果中， value=compare-value。而第二个方案的返回结果是第一种情况的真实结果。如果没有匹配的结果值，则返回结果为ELSE后的结果，如果没有ELSE 部分，则返回值为 NULL。

例如：

```
SELECT CASE 1 WHEN 1 THEN 'one'
              WHEN 2 THEN 'two'
              ELSE 'more' END
              as testCol
```

将输出one

```
IFNULL(expr1,expr2)
```


假如expr1 不为 NULL，则 IFNULL() 的返回值为 expr1; 否则其返回值为 expr2。IFNULL()的返回值是数字或是字符串，具体情况取决于其所使用的语境。

```
mysql> SELECT IFNULL(1,0);
        -> 1

mysql> SELECT IFNULL(NULL,10);
        -> 10

mysql> SELECT IFNULL(1/0,10);
        -> 10

mysql> SELECT IFNULL(1/0,'yes');
        -> 'yes'
```


IFNULL(expr1,expr2) 的默认结果值为两个表达式中更加“通用”的一个，顺序为STRING、 REAL或 INTEGER。

IF ELSE 做为流程控制语句使用
if实现条件判断，满足不同条件执行不同的操作，这个我们只要学编程的都知道if的作用了，下面我们来看看mysql 存储过程中的if是如何使用的吧。

```sql
IF search_condition THEN
    statement_list
[ELSEIF search_condition THEN]
    statement_list ...
[ELSE
    statement_list]
END IF
```

当IF中条件search_condition成立时，执行THEN后的statement_list语句，否则判断ELSEIF中的条件，成立则执行其后的statement_list语句，否则继续判断其他分支。当所有分支的条件均不成立时，执行ELSE分支。search_condition是一个条件表达式，可以由“=、<、<=、>、>=、!=”等条件运算符组成，并且可以使用AND、OR、NOT对多个表达式进行组合。

例如，建立一个存储过程，该存储过程通过学生学号（student_no）和课程编号（course_no）查询其成绩（grade），返回成绩和成绩的等级，成绩大于90分的为A级，小于90分大于等于80分的为B级，小于80分大于等于70分的为C级，依次到E级。那么，创建存储过程的代码如下：

```sql
create procedure dbname.proc_getGrade
(stu_no varchar(20),cour_no varchar(10))
BEGIN
declare stu_grade float;
select grade into stu_grade from grade where student_no=stu_no and course_no=cour_no;
if stu_grade>=90 then
    select stu_grade,'A';
elseif stu_grade<90 and stu_grade>=80 then
    select stu_grade,'B';
elseif stu_grade<80 and stu_grade>=70 then
    select stu_grade,'C';
elseif stu_grade70 and stu_grade>=60 then
    select stu_grade,'D';
else
    select stu_grade,'E';
end if;
END
```


注意：IF作为一条语句，在END IF后需要加上分号“;”以表示语句结束，其他语句如CASE、LOOP等也是相同的。

> help show 查看允许的show语句

# 其他

```shell
tee /home/cheng/log.sql
```

将下面的操作都写入改日志


```sql
grant all privileges on testdb.* to ‘test_user’@’localhost’ identified by “jack” with grant option;
```

WITH GRANT OPTION 这个选项表示该用户可以将自己拥有的权限授权给别人。注意：经常有人在创建操作用户的时候不指定WITH GRANT OPTION选项导致后来该用户不能使用GRANT命令创建用户或者给其它用户授权。
如果不想这个用户有这个grant的权限，可以不加这句

## mysql的SQL长度限制

```shell
max_allowed_packet = 6M
```

把上面这个配置改大就行了

## 监听SQL
登录mysql
```
set global general_log_file='/tmp/general.log';
set global general_log='on';
```
之后执行命令都会记录进LOG

## 排序
MySQL中的排序ORDER BY 除了可以用ASC和DESC，还可以自定义字符串/数字来实现排序。

格式如下：

```
SELECT * FROM table ORDER BY FIELD(status,1,2,0);
```

这样子写的话，返回的结果集是按照字段status的1、2、0进行排序的，当然，也可以对字符串进行排序。

原理如下：

FIELD()函数是将参数1的字段对后续参数进行比较，并返回1、2、3等等，如果遇到null或者没有在结果集上存在的数据，则返回0，然后根据升序进行排序。

# json字段

自*MySQL5.7.8*版本以来，MySQL支持原生JSON数据类型。允许使用原生JSON数据类型比以前MySQL版本中所使用JSON文本格式更能有效地存储JSON文档。

MySQL以内部格式存储JSON文档，允许对文档元素的快速读取访问。JSON二进制格式的结构是允许服务器通过键或数组索引直接搜索JSON文档中的值，这非常快。

JSON文档的存储大约与存储`LONGBLOB`或`LONGTEXT`数据量相同。

要定义数据类型为JSON的列，请使用以下语法：

```sql
CREATE TABLE `json_test` (
  `id` int(11) unsigned NOT NULL,
  `j` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

> json列不能有默认值，而且不能直接编入索引，可以在包含从json列中提取的生成列上创建索引，当从JSON列查询数据时，MySQL优化器将在匹配JSON表达式的虚拟列上查找兼容的索引。

如下json数据，存储为两条记录

```sql
insert into json_test values(2, '{"name":"test","age": 14}');
insert into json_test values(2, '{"name":"test1","age": 12}');
```

查询，使用列路径运算符(`->`)

```sql
select id, j->'$.name' as name from json_test;
```

查询结果如下

```
+----+------------+
| id | name       |
+----+------------+
|  1 | "chengyao" |
|  2 | "test"     |
+----+------------+
```

name列值中有引号，怎么去掉，可以使用内联路径运算符( `->>`)

```sql
select id, j->>'$.name' as name from json_test;
```

查询结果

```
+----+----------+
| id | name     |
+----+----------+
|  1 | chengyao |
|  2 | test     |
+----+----------+
```

json函数： [(53条消息) MySQL常用Json函数_dragonpeng2008的博客-CSDN博客](https://blog.csdn.net/dragonpeng2008/article/details/89479698)

#  生成列

*MySQL 5.7*引入了一个名为*生成列*的新功能。它之所以叫作*生成列*，因为此列中的数据是基于预定义的表达式或从其他列计算的。

例如，假设有以下结构的一个`contacts`表：

```sql
CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL
);
```

要获取联系人的全名，请使用`CONCAT()`函数，如下所示：

```sql
SELECT 
    id, CONCAT(first_name, ' ', last_name), email
FROM
    contacts;
```

这不是最优的查询。

通过使用MySQL生成的列，可以重新创建`contacts`表，如下所示：

```sql
DROP TABLE IF EXISTS contacts;

CREATE TABLE contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    fullname varchar(101) GENERATED ALWAYS AS (CONCAT(first_name,' ',last_name)),
    email VARCHAR(100) NOT NULL
);
```

`GENERATED ALWAYS as(expression)`是创建生成列的语法。要测试“全名”列，请在`contacts`表中插入一行。

```sql
INSERT INTO contacts(first_name,last_name, email)
VALUES('john','doe','john.doe@yiibai.com');
```

现在，可以从`contacts`表中查询数据。

当从`contacts`表中查询数据时，`fullname`列中的值将立即计算。

MySQL提供了两种类型的生成列：存储和虚拟。每次读取数据时，虚拟列都将在运行中计算，而存储的列在数据更新时被物理计算和存储。

基于此定义，上述示例中的`fullname`列是虚拟列。

## MySQL生成列的语法

定义生成列的语法如下：

```sql
column_name data_type [GENERATED ALWAYS] AS (expression)
   [VIRTUAL | STORED] [UNIQUE [KEY]]
```

首先，指定列名及其数据类型。

接下来，添加`GENERATED ALWAYS`子句以指示列是生成的列。

然后，通过使用相应的选项来指示生成列的类型：`VIRTUAL`或`STORED`。 默认情况下，如果未明确指定生成列的类型，MySQL将使用`VIRTUAL`。

之后，在`AS`关键字后面的大括号内指定表达式。 该表达式可以包含文字，内置函数，无参数，操作符或对同一表中任何列的引用。 如果你使用一个函数，它必须是标量和确定性的。

最后，如果生成的列被存储，可以为它定义一个唯一约束。

## MySQL存储列示例

我们来看一下`products`表。

```sql
mysql> desc products;
+--------------------+---------------+------+-----+---------+-------+
| Field              | Type          | Null | Key | Default | Extra |
+--------------------+---------------+------+-----+---------+-------+
| productCode        | varchar(15)   | NO   | PRI |         |       |
| productName        | varchar(70)   | NO   |     | NULL    |       |
| productLine        | varchar(50)   | NO   | MUL | NULL    |       |
| productScale       | varchar(10)   | NO   |     | NULL    |       |
| productVendor      | varchar(50)   | NO   |     | NULL    |       |
| productDescription | text          | NO   |     | NULL    |       |
| quantityInStock    | smallint(6)   | NO   |     | NULL    |       |
| buyPrice           | decimal(10,2) | NO   |     | NULL    |       |
| MSRP               | decimal(10,2) | NO   |     | NULL    |       |
+--------------------+---------------+------+-----+---------+-------+
9 rows in set
```

使用`quantityInStock`和`buyPrice`列的数据，通过以下表达式计算每个`SKU`的股票值：

```sql
quantityInStock * buyPrice
```

但是，可以使用以下[ALTER TABLE … ADD COLUMN](http://www.yiibai.com/mysql/add-column.html "ALTER TABLE ... ADD COLUMN")语句将名为`stock_value`的存储的生成列添加到`products`表：

```sql
ALTER TABLE products
ADD COLUMN stockValue DOUBLE 
GENERATED ALWAYS AS (buyprice*quantityinstock) STORED;
```

通常，`ALTER TABLE`语句需要完整的表重建，因此，如果更改大表是耗时的。 但是，虚拟列并非如此。

现在，我们可以直接从`products`表中查询库存值。

```sql
SELECT 
    productName, ROUND(stockValue, 2) AS stock_value
FROM
    products;
```

执行上面查询语句，得到以下结果 -

```shell
+---------------------------------------------+-------------+
| productName                                 | stock_value |
+---------------------------------------------+-------------+
| 1969 Harley Davidson Ultimate Chopper       |   387209.73 |
| 1952 Alpine Renault 1300                    |   720126.90 |
| 1996 Moto Guzzi 1100i                       |   457058.75 |
| 2003 Harley-Davidson Eagle Drag Bike        |   508073.64 |
| 1972 Alfa Romeo GTA                         |   278631.36 |
| 1962 LanciaA Delta 16V                      |   702325.22 |
| 1968 Ford Mustang                           |     6483.12 |
|************** 省略了一大波数据 ****************************|
| The Queen Mary                              |   272869.44 |
| American Airlines: MD-11S                   |   319901.40 |
| Boeing X-32A JSF                            |   159163.89 |
| Pont Yacht                                  |    13786.20 |
+---------------------------------------------+-------------+
110 rows in set
```

参考： [MySQL生成列 - MySQL教程 (yiibai.com)](https://www.yiibai.com/mysql/generated-columns.html)

# 常见错误处理

## Operation CREATE USER failed for XXX

原因：可能是执行了如下操作

```sql
delete  from  mysql.user  where user ='user_1';
```

需要再执行下面命令

```sql
drop user user1;
```

## ERROR 1269 (HY000): Can't revoke all privileges for one or more of the requested users

需要加上host，例如

```sql
REVOKE ALL PRIVILEGES ON *.* FROM 'testuser'@'localhost';
```

## 字符校对规则问题
查询视图时报错：java.sql.SQLException: Illegal mix of collations (utf8mb4_general_ci,IMPLICIT) and (utf8mb4_0900_ai_ci,IMPLICIT) for operation '='；

本地环境:`mysql8.0.13`

异常提示排序规则编码混乱，mysql8.0.1之后的默认COLLATE为utf8mb4_0900_ai_ci；

检查视图中所包含的表发现其中一个建表时 没有设置编码，并且其他的表设置的是 CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci；因此导致混乱；

查看当前数据库的默认编码：

```shell
mysql> show variables where Variable_name like 'collation%';
```


查看各表编码：
```shell
mysql> show create table ‘table_name’;
```
 

解决方案给没有设置编码的表重新设置一下：
```shell
mysql> alter table table_name default character set utf8mb4 collate=utf8mb4_general_ci;
```


这样设置只针对表的，但是表中字段未修改：
```shell
mysql> ALTER TABLE table_name convert to CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

修改完成以后，重新创建视图！！！！

## 排序内存溢出问题
报错：
`SQLSTATE[HY001]: Memory allocation error: 1038 Out of sort memory, consider increasing sort buffer size`

找到mysql配置文件（我的是`/etc/mysql/mysql.conf.d/mysqld.cnf`）, 添加一行
```
sort_buffer_size        = 16M
```
重启数据库，报错继续加大

## 数据类型相关
记录datetime到毫秒
5.6 之后可以将字段类型设置为datetime(3), 其中的数字表示精度，三位精确到毫秒

## Incorrect key file for notes
解决方案（目前使用myisam引擎）
```sql
optimize table notes;
```
如果不行就google一下

## 不用密码登录

```shell
vim /etc/my.cnf
```

在[mysqld]段后加一行

```
skip-grant-tables
```

或者用这条命令运行

```
/usr/bin/mysqld --skip-grant-tables
```

重启mysql

```
/etc/init.d/mysql restart
service mysql restart
```

## 修改validate_password_policy参数的值

```
set global validate_password_policy=0;
#validate_password_length(密码长度)参数默认为8，修改为需要长度
set global validate_password_length=1;
```

## mysqld命令

https://www.cnblogs.com/shymen/p/8850655.html