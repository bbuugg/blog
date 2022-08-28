---
title: MongoDB学习笔记
date: 2021-11-28 20:07:11
tags:
---

# 优劣：

高性能、易部署、易使用，存储数据非常方便。

不支持连表查询，不支持sql语句，不支持事务存储过程等，所以不适合存储数据间关系比较复杂的数据，一般主要是当做一个**数据仓库**来使用。

**适用于**：日志系统，股票数据等。

**不适用于**：电子商务系统等需要连多表查询的功能。



# 概念

## 文档

**文档**是mongoDB中数据的**基本单元**，类似关系数据库的行， 多个键值对有序地放置在一起便是文档。 MongoDB 中以文档的方式存取记录，如一条记录格式如下：

```
{ “username”:”Tom”, “age”:10 ,email:’abc@qq.com’,’sex’:男，键,值}

{ "username":"Tom" , "age" : "10" } 

{“Username”:”Tom”,”age”:10} 

{“Username”:”Tom” } 
```

注意：

（1）以上是几个不同的文档，**MongoDB****区分大小写的数据类型**，第一个age字段是**数字**类型，第二个age是**字符串**类型。

（2）每一个文档尺寸不能超过**16M** 

## 集合

集合就是一组文档，**多个文档组成一个集合**，集合类似于 mysql里面的表 。

**无模式**是指，在**同一个集合**中可以包含**不同格式的文档**，如：

```
{  "Name" : "Mongodb" , "Type" : "Nosql" }

{  "UserName" : "Tom" , "age" : 20 , "Gender" : "male" }
```

以上两个文档可以放在同一个集合中。

在Mysql需要先建表再插入数据，

**模式自由**（schema-free）：**意思是集合里面没有行和列的概念**，

注意：MongoDB中的**集合不用创建**、**没有结构**，所以可以放不同格式的文档。

## 数据库

多个集合可以组成数据库。一个mongoDB实例可以承载多个数据库，他们之间完全独立。 

Mongodb中的数据库和Mysql中的数据库概念类似，只是**无需创建**。

一个数据库中可以有多个集合。一个集合中可以有多个文档。

## 其他

1. 单个文档最大16M, 32位系统上单个数据库最大2G

# 简单使用

## 连接

linux下启动mongo后使用mongo命令连接

```
mongodb://127.0.0.1:27017
```

可以使用mongo --help查看帮助

### 语法

```
use 数据库
```

如果不存在，则创建，否则切换。如果创建了没有做任何操作会自动删除。

```
show dbs
```

查看数据库列表

### 添加文档

```
db.集合名.insert({})
```

集合隐式创建，所以可以直接使用， db表示当前数据库，也就是前面use的数据库，可以使用db命令查看当前数据库，添加命令如下

```
db.test.insert({"name": "max"})
```

>  数据类型是BSON, 支持的值更丰富

在添加的数据中都有一个"_id"的键，值为对象类型

```
{ "_id" : ObjectId("61a365b5e2e6abe7dea43ac8"), "name" : "tet" }
```

ObjectId类型： 

每个文档都有一个_id字段，并且**同一集合**中的_id**值唯一**，该字段可以是**任意类型**的数据，默认是一个**ObjectId**对象。

**ObjectId**对象**对象数据组成：**时间戳|机器码|PID|计数器， _id的键值我们可以自己输入，但是不能重复，重复会报错

>  使用js批量插入

```js
for(var i = 0; i < 10; i++) {
	db.test.insert({"name": "maxphp", "age": i})
}
```

### 查看集合

```
show tables
```

### 查询

```
db.集合名.find()       // 查询所有
db.集合名.find(条件)    // 查询某条件下所有
db.集合名.findOne()    // 查询一个文档
db.集合名.findOne(条件) // 查询某条件下一个文档
db.集合名.find().pretty()
```

> 可以使用操作符 $lt , $lte , $gt , $gte  ( < , <= , > , >= ), $ne ( <> ) ,$in , $nin , $or , $not, $mod (取模), $exists, $where

例如

```
db.users.find({"age": {"$gt": 12}}, {"name": 1})  // 只显示年龄大于12的用户名字
db.users.find({"age": {"$gt": 12}}, {"name": 0})  // 年龄大于12的用户，除了名字其他都显示
db.users.find({}, {"$lt": 1})
```

**排序**

```
db.test.find().sort({"age": 1}) //根据年龄升序， -1为降序
```

**限制**

```
db.test.find().limit(3)  // 查询前3条
db.test.find().skip(3).limit(2)  // 查询偏移量为3的2个文档
```

**count**

```
db.test.count() // 查询集合文档总数
```

### 删除文档

```
db.集合名.remove({条件}) // 如果没有条件会删除所有
```

例如

```
db.users.remove({”age“: 5})  // 删除用户中年龄等于5的文档
```

```
db.users.remove({"age": {"$gt": 8}})
```

### 删除集合

```
db.集合名.drop()
```

### 删除数据库

```
use 数据库
db.dropDatabase()
```

### 更新文档

#### 直接修改

```
db.集合名.update(条件，新文档, 是否新增, 是否修改多条)
```

**是否新增**：如果值是1（true）则没有满足条件的则添加。

**是否修改多条**：若值是1（true），如果满足条件的有多个文档则都要修改

```
db.users.update({"age": 3}, {"age": 4}, true, true)
```

> 上面的修改会导致其他数据键值丢失，所以不推荐

#### 使用修改器

**$inc** : 加一个数字

**$set :** 修改某一个字段,如果该字段不存在就增这个字段

```
db.集合名.update({条件}, {修改器名称: {修改的键: 修改后的值}})
```

例如

```
db.test.update({"name": "maxphp"}, {"$set": {"age": 14}}, true, true)  // 将所有名字为maxphp的修改年龄为14
db.test.update({"age": 14}, {"$inc": {"age": 100}})  // 将年龄为14的一个年龄增加100
```

### 帮助

```
help            // 全局
db.help()       // 数据库相关帮助
db.集合名.help() // 集合相关帮助
```

# 用户管理（权限控制）

在mongodb里面的用户是属于数据库的,每个数据库有自己的管理员，管理员登录后，只能操作所属的数据库。

注意：一般在admin数据库中创建的用户授予超级管理员权限，登录后可以操作任何的数据库。

### 创建用户

注意：在开启权限管理控制时，一定先要创建一个超级管理员授予超级管理权限。

```
use admin
db.createUser({user: "root", pwd: "123456", roles: [{role: "root", db: "admin"}]})  // 创建超级管理员


use php
db.createUser({user: "phpadmin", pwd: "123456", roles: [{role: "dbOwner", db: "php"}]}) // 创建普通用户

```

用户相关

```
show users // 查看当前库的所有用户
db.dropUser("username") // 删除用户
db.updateUser("admin", {pwd: "password"}) // 修改admin密码
ab.auth("user", "pass") // 使用密码认证
```

登录

```
mongo 数据库 -u 用户名 -p 密码    // 本地
mongo IP地址:端口/数据库名称 -u 用户名 -p 密码  // 远程
```

### 角色

（1）数据库用户角色：read、readWrite; 

（2）数据库管理角色：dbAdmin、**dbOwner**、userAdmin； 

（3）集群管理角色：clusterAdmin、clusterManager、clusterMonitor、hostManager；

（4）备份恢复角色：backup、restore；

（5）所有数据库角色：readAnyDatabase、readWriteAnyDatabase、userAdminAnyDatabase、 dbAdminAnyDatabase 

（6）超级用户角色：**root**