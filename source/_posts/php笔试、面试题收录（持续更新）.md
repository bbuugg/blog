---
title: php笔试、面试题收录（持续更新）
date: 2020-08-15 07:19:23
tags:
---

1. php中isset,empty,is_null,?:,??
is_null
bool is_null ( mixed $var )

<!-- more -->

当参数满足下面三种情况时，is_null()将返回TRUE，其它的情况就是FALSE
1、它被赋值为NULL
2、它还没有赋值
3、它未定义，相当于unset()处理过的变量
isset
bool isset ( mixed $var [, mixed $... ] )，参数是一个变量

检测参数已设定，并且不是NULL。如果没有设置变量，变量未赋值，或变量被设为NULL，isset()函数就返回NULL。
正好和is_null()函数相反，is_null()为TRUE的情况在isset()中就为FALSE。
如果传递多个参数，将取交集。即所有参数全部符合 isset() 时才返回 TRUE。
empty
bool empty ( mixed $var )

判读变量是否为空。
empty()为TRUE的情况，若变量不存在，或者变量存在且其值为&quot;&quot;、0、&quot;0&quot;、NULL、FALSE、array()、var $var; 以及没有任何属性的对象，则返回 TURE。
?:
$b = $a?:1等于 $b = !empty($a)?$a:1 ,若$a为空，则赋值为1，否则取$a的值

??
$b = $a??$c等于$b = isset($a)?$a:$c,若$a未设定，返回$c,否则返回$a

2. date类问题
strtotime()函数的作用是将日期时间描述解析为 Unix 时间戳

int strtotime ( string time [, int now] )

示例：

echo &quot;今天:&quot;.date(&quot;Y-m-d&quot;);
echo &quot;昨天:&quot;.date(&quot;Y-m-d&quot;,strtotime(&quot;-1 day&quot;));
echo &quot;明天:&quot;.date(&quot;Y-m-d&quot;,strtotime(&quot;+1 day&quot;));
echo &quot;一周后:&quot;.date(&quot;Y-m-d&quot;,strtotime(&quot;+1 week&quot;));
echo &quot;一周零两天四小时两秒后:&quot;.date(&quot;Y-m-d G:H:s&quot;,strtotime(&quot;+1 week 2 days 4 hours 2 seconds&quot;));
echo &quot;下个星期四:&quot;.date(&quot;Y-m-d&quot;,strtotime(&quot;next Thursday&quot;));
echo &quot;上个周一:&quot;.date(&quot;Y-m-d&quot;,strtotime(&quot;last Monday&quot;));
echo &quot;一个月前:&quot;.date(&quot;Y-m-d&quot;,strtotime(&quot;last month&quot;));
echo &quot;一个月后:&quot;.date(&quot;Y-m-d&quot;,strtotime(&quot;+1 month&quot;));
echo &quot;十年后:&quot;.date(&quot;Y-m-d&quot;,strtotime(&quot;+10 year&quot;));
主要考虑date()函数和strtotime()函数

3. require 和 include
 require是无条件包含也就是如果一个流程里加入require,无论条件成立与否都会先执行require
 include有返回值，而require没有(可能因为如此require的速度比include快)
 包含文件不存在或者语法错误的时候require是致命的错误终止执行,include不是
原文地址：https://learnku.com/articles/28758

4. 数据库主从复制、读写分离
什么是主从复制
主从复制，是用来建立一个和主数据库完全一样的数据库环境，称为从数据库；
主从复制的原理：
1.数据库有个bin-log二进制文件，记录了所有的sql语句。
2.只需要把主数据库的bin-log文件中的sql语句复制。
3.让其从数据的relay-log重做日志文件中在执行一次这些sql语句即可。
主从复制的作用
1.做数据的热备份，作为后备数据库，主数据库服务器故障后，可切换到从数据库继续工作，避免数据丢失。
2.架构的扩展。业务量越来越大，I/O访问频率过高，单机无法满足，此时做多库的存储，降低磁盘I/O访问频率，提高单机的I/O性能
3.主从复制是读写分离的基础，使数据库能制成更大 的并发。例如子报表中，由于部署报表的sql语句十分慢，导致锁表，影响前台的服务。如果前台服务使用master，报表使用slave，那么报表sql将不会造成前台所，保证了前台的访问速度。
主从复制的几种方式：
1.同步复制：所谓的同步复制，意思是master的变化，必须等待slave-1,slave-2,...,slave-n完成后才能返回。
2.异步复制：如同AJAX请求一样。master只需要完成自己的数据库操作即可。至于slaves是否收到二进制日志，是否完成操作，不用关心。MYSQL的默认设置。
3.半同步复制：master只保证slaves中的一个操作成功，就返回，其他slave不管。
这个功能，是由google为MYSQL引入的。
关于读写分离
在完成主从复制时，由于slave是需要同步master的。所以对于insert/delete/update这些更新数据库的操作，应该在master中完成。而select的查询操作，则落下到slave中。
原文地址：https://learnku.com/articles/28758

5. 数据库索引
**什么是索引**
索引是对数据库表中一列或多列的值进行排序的一种结构，使用索引可快速访问数据库表中的特定信息。（摘自百度百科）
**索引类型**
1.FULLTEXT 全文索引
    全文索引，仅MyISAM引擎支持。其可以在CREATE TABLE ，ALTER TABLE ，CREATE INDEX 使用，不过目前只有 CHAR、VARCHAR ，TEXT 列上可以创建全文索引。
2.HASH 哈希索引
    HASH索引的唯一性及类似键值对的形式十分适合作为索引，HASH索引可以一次定位，不需要像树形索引那样逐层参照，因此具有极高的效率。但是这种高效是有条件的。即只在“=”和“in”条件下高效，对于范围查询，排序及组合索引仍然效率不高。
3.BTREE 树形索引
    BTREE所以是一种将索引按一定算法，存入一个树形的数据结构中（二叉树），每次查询都是从树的入口root开始，一次遍历node，获取leaf。这是MySQL中默认也是最常用的索引类型。
4.RTREE
    RTREE在MySQL中很少使用，仅支持geometry数据类型，支持该存储引擎只有MyISAM、BDb、InnoDb、NDb、Archive几种。相对于BTREE，RTREE的优势在于范围查找。
**索引种类**
普通索引：仅加速查询
唯一索引：加速查询+列值唯一（可以有null）
主键索引：加速查询+列值唯一（不可以有null）+表中只有一个
组合索引：多列值组成一个索引，专门用于组合搜索，其效率大于索引合并
全文索引：对文本内容进行分词，进行搜索
外键索引：与主键索引形成联系，保证数据的完整性。
**索引使用的注意事项**
1.符合索引遵循前缀原则
2.like查询%不能再前，否则索引失效。如有需要，使用全文索引
3.column is null可以使用索引
4.如果MySQL估计使用索引比全表扫描慢，则放弃使用索引
5.如果or前的条件中列有索引，后面的没有，索引不会生效。
6.列类型是字符串，查询时，一定要给值加引号，否则索引失效。
7.确定order by 和 group by 中只有一个表的列，这样才能使用索引
原文地址：https://learnku.com/articles/28758

6. 高并发的解决方案
web服务器优化 ：负载均衡 
流量优化：防盗链处理 将恶意请求屏蔽，
前端优化：减少http请求、添加异步请求、启用浏览器缓存和文件压缩、cdn加速、建立独立的图片服务器、
服务端优化：  页面静态化、并发处理、队列处理、
数据库优化： 数据库缓存、分库分表、分区操作 、读写分离、负载均衡
原文地址：https://learnku.com/articles/28758

7. 接口与抽象类的区别
1. 接口
（1）对接口的使用是通过关键字implements
（2）接口不能定义成员变量（包括类静态变量），能定义常量
（3）子类必须实现接口定义的所有方法
（4）接口只能定义不能实现该方法
（5）接口没有构造函数
（6）接口中的方法和实现它的类默认都是public类型的
2. 抽象类
（1）对抽象类的使用是通过关键字extends
（2）不能被实例化，可以定义子类必须实现的方法
（3）子类必须定义父类中的所有抽象方法，这些方法的访问控制必须和父类中一样（或者更为宽松）
（4）如一个类中有一个抽象方法，则该类必须定义为抽象类
（5）抽象类可以有构造函数
（6）抽象类中的方法可以使用private,protected,public来修饰。
（7）一个类可以同时实现多个接口，但一个类只能继承于一个抽象类。
3. Final类/方法
（1）final类不能被继承
（2）final方法不能被重写
4. Static类/方法
(1)可以不实例化类而直接访问
(2)静态属性不可以由对象通过-&gt;操作符来访问,用::方式调用
原文地址：https://learnku.com/articles/28758

8. php获取上级文件目录
echo __FILE__ ; // 获取当前所在文件的绝对路径及地址，结果：D:\aaa\my.php 
echo dirname(__FILE__); // 取得当前文件所在的绝对目录，结果：D:\aaa\ 
echo dirname(dirname(__FILE__)); //取得当前文件的上一层目录名，结果：D:\ 
原文：https://blog.csdn.net/viqecel/article/details/80765275
9. HTTP状态码
1**
信息，服务器收到请求，需要请求者继续执行操作
2**
成功，操作被成功接收并处理
3**
重定向，需要进一步的操作以完成请求
4**
客户端错误，请求包含语法错误或无法完成请求
5**
服务器错误，服务器在处理请求的过程中发生了错误
详细参照：https://www.runoob.com/http/http-status-codes.html
10. 设计模式
简单工厂模式：根据产品接口，创建多个产品类，由一个工厂类返回多种产品对象
工厂模式：根据产品接口，创建多个产品类，并创建多个工厂类，由一个工厂使用类调用多个工厂对象来制造多种产品对象
单例模式：保证一个类有且只有一个实例，且提供一个访问它的全局控制点
策略模式：一个策略接口，多个具体策略类，一个策略使用类
11. 三大范式
第一范式：确保每列保持原子性
第二范式：确保表中每列都和主键相关
第三范式：确保每列都和主键列直接相关，而不是间接相关
12. 面向对象
面向过程是具体化的，流程化的，解决一个问题，你需要一步一步的分析，一步一步的实现。
面向对象是模型化的，你只需抽象出一个类，这是一个封闭的盒子，在这里你拥有数据也拥有解决问题的方法。
需要什么功能直接使用就可以了，不必去一步一步的实现，至于这个功能是如何实现的，管我们什么事？我们会用就可以了。
面向对象的底层其实还是面向过程，把面向过程抽象成类，然后封装，方便我们使用的就是面向对象了。
面向对象的三大特征和五大基本原则
面向对象的三大特征：封装、继承、多态
五大基本原则：
单一职责原则：类的功能要单一
开放封闭原则：模块对于拓展是开放的，修改是封闭的
里式替换原则：子类可以代替父类出现在父类可以出现的任何地方
依赖倒置原则：高层次的模块不应该依赖于低层次模块，他们都应该依赖于抽象。抽象不应该依赖于具体实现，具体实现应该依赖于抽象。就如同在国外，‘我是中国人’，而不是‘我是**村的人’
接口分离原则：接口的功能也具有单一性，需要尽可能的拆分

转载 http://blog.kaiot.xyz/read/55.html