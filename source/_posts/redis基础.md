---
title: redis基础
date: 2020-08-15 07:20:37
tags:
---

# Redis的优势和特点
## Redis的特点：

- 内存数据库，速度快，也支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。
- Redis不仅仅支持简单的key-value类型的数据，同时还提供list，set，zset，hash等数据结构的存储。
- Redis支持数据的备份，即master-slave模式的数据备份。
- 支持事务

<!-- more -->

## Redis的优势：

- 性能极高 – Redis能读的速度是110000次/s,写的速度是81000次/s 。
- 丰富的数据类型 – Redis支持二进制案例的 Strings, Lists, Hashes, Sets 及 Ordered Sets 数据类型操作。
- 原子 – Redis的所有操作都是原子性的，同时Redis还支持对几个操作合并后的原子性执行。（事务）
- 丰富的特性 – Redis还支持 publish/subscribe, 通知, key 过期等等特性。

## Redis与其他key-value存储有什么不同？

- Redis有着更为复杂的数据结构并且提供对他们的原子性操作，这是一个不同于其他数据库的进化路径。Redis的数据类型都是基于基本数据结构的同时对程序员透明，无需进行额外的抽象。
- Redis运行在内存中但是可以持久化到磁盘，所以在对不同数据集进行高速读写时需要权衡内存，因为数据量不能大于硬件内存。在内存数据库方面的另一个优点是，相比在磁盘上相同的复杂的数据结构，在内存中操作起来非常简单，这样Redis可以做很多内部复杂性很强的事情。同时，在磁盘格式方面他们是紧凑的以追加的方式产生的，因为他们并不需要进行随机访问。

# Redis的过期策略和内存淘汰机制

## Redis 的 key 有两种过期淘汰的方式：被动方式、主动方式。

被动过期：用户访问某个 key 的时候，key 被发现过期。

当然，被动方式过期对于那些永远也不会再次被访问的 key 并没有效果。不管怎么，这些 key 都应被过期淘汰，所以 Redis 周期性主动随机检查一部分被设置生存时间的 key，那些已经过期的 key 会被从 key 空间中删除。

Redis每秒执行10次下面的操作：

从带有生存时间的 key 的集合中随机选 20 进行检查。
删除所有过期的key。
如20里面有超过25%的key过期，立刻继续执行步骤1。
这是一个狭义概率算法，我们假设我们选出来的样本 key 代表整个 key 空间，我们继续过期检查直到过期 key 的比例降到 25% 以下。

这意味着在任意时刻已经过期但还占用内存的 key 的数量，最多等于每秒最多写操作的四分之一。

## 过期策略

我们set key的时候，都可以给一个expire time，就是过期时间，指定这个key比如说只能存活1个小时，我们自己可以指定缓存到期就失效。

如果假设你设置一个一批key只能存活1个小时，那么接下来1小时后，redis是怎么对这批key进行删除的？

答案是：定期删除+惰性删除



所谓定期删除，指的是redis默认是每隔100ms就随机抽取一些设置了过期时间的key，检查其是否过期，如果过期就删除。

注意，这里可不是每隔100ms就遍历所有的设置过期时间的key，那样就是一场性能上的灾难。

实际上redis是每隔100ms随机抽取一些key来检查和删除的。



但是，定期删除可能会导致很多过期key到了时间并没有被删除掉，所以就得靠惰性删除了。

这就是说，在你获取某个key的时候，redis会检查一下 ，这个key如果设置了过期时间那么是否过期了？如果过期了此时就会删除，不会给你返回任何东西。

并不是key到时间就被删除掉，而是你查询这个key的时候，redis再懒惰的检查一下

通过上述两种手段结合起来，保证过期的key一定会被干掉。



但是实际上这还是有问题的，如果定期删除漏掉了很多过期key，然后你也没及时去查，也就没走惰性删除，此时会怎么样？

如果大量过期key堆积在内存里，导致redis内存块耗尽了，怎么办？

答案是：走内存淘汰机制。

## 内存淘汰机制

如果redis的内存占用过多的时候，此时会进行内存淘汰，有如下一些策略：

noeviction：当内存不足以容纳新写入数据时，新写入操作会报错，这个一般没人用吧

allkeys-lru：当内存不足以容纳新写入数据时，在键空间中，移除最近最少使用的key（这个是最常用的）

allkeys-random：当内存不足以容纳新写入数据时，在键空间中，随机移除某个key，这个一般没人用吧

volatile-lru：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，移除最近最少使用的key（这个一般不太合适）

volatile-random：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，随机移除某个key

volatile-ttl：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，有更早过期时间的key优先移除

# Redis配置文件全解

==基本配置
daemonize no 是否以后台进程启动
databases 16 创建database的数量(默认选中的是database 0)


save 900 1    #刷新快照到硬盘中，必须满足两者要求才会触发，即900秒之后至少1个关键字发生变化。
save 300 10  #必须是300秒之后至少10个关键字发生变化。
save 60 10000 #必须是60秒之后至少10000个关键字发生变化。
stop-writes-on-bgsave-error yes    #后台存储错误停止写。
rdbcompression yes    #使用LZF压缩rdb文件。
rdbchecksum yes    #存储和加载rdb文件时校验。
dbfilename dump.rdb    #设置rdb文件名。
dir ./    #设置工作目录，rdb文件会写入该目录。


==主从配置
slaveof <masterip> <masterport> 设为某台机器的从服务器
masterauth <master-password>   连接主服务器的密码
slave-serve-stale-data yes  # 当主从断开或正在复制中,从服务器是否应答
slave-read-only yes #从服务器只读
repl-ping-slave-period 10 #从ping主的时间间隔,秒为单位
repl-timeout 60 #主从超时时间(超时认为断线了),要比period大
slave-priority 100    #如果master不能再正常工作，那么会在多个slave中，选择优先值最小的一个slave提升为master，优先值为0表示不能提升为master。

repl-disable-tcp-nodelay no #主端是否合并数据,大块发送给slave
slave-priority 100 从服务器的优先级,当主服挂了,会自动挑slave priority最小的为主服


===安全
requirepass foobared # 需要密码
rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c52 #如果公共环境,可以重命名部分敏感命令 如config



===限制
maxclients 10000 #最大连接数
maxmemory <bytes> #最大使用内存

maxmemory-policy volatile-lru #内存到极限后的处理
volatile-lru -> LRU算法删除过期key
allkeys-lru -> LRU算法删除key(不区分过不过期)
volatile-random -> 随机删除过期key
allkeys-random -> 随机删除key(不区分过不过期)
volatile-ttl -> 删除快过期的key
noeviction -> 不删除,返回错误信息

#解释 LRU ttl都是近似算法,可以选N个,再比较最适宜T踢出的数据
maxmemory-samples 3

====日志模式
appendonly no #是否仅要日志
appendfsync no # 系统缓冲,统一写,速度快
appendfsync always # 系统不缓冲,直接写,慢,丢失数据少
appendfsync everysec #折衷,每秒写1次

no-appendfsync-on-rewrite no #为yes,则其他线程的数据放内存里,合并写入(速度快,容易丢失的多)
auto-AOF-rewrite-percentage 100 当前aof文件是上次重写是大N%时重写
auto-AOF-rewrite-min-size 64mb aof重写至少要达到的大小

====慢查询
slowlog-log-slower-than 10000 #记录响应时间大于10000微秒的慢查询
slowlog-max-len 128   # 最多记录128条


====服务端命令
time  返回时间戳+微秒
dbsize 返回key的数量
bgrewriteaof 重写aof
bgsave 后台开启子进程dump数据
save 阻塞进程dump数据
lastsave 

slaveof host port 做host port的从服务器(数据清空,复制新主内容)
slaveof no one 变成主服务器(原数据不丢失,一般用于主服失败后)

flushdb  清空当前数据库的所有数据
flushall 清空所有数据库的所有数据(误用了怎么办?)

shutdown [save/nosave] 关闭服务器,保存数据,修改AOF(如果设置)

slowlog get 获取慢查询日志
slowlog len 获取慢查询日志条数
slowlog reset 清空慢查询


info []

config get 选项(支持*通配)
config set 选项 值
config rewrite 把值写到配置文件
config restart 更新info命令的信息

debug object key #调试选项,看一个key的情况
debug segfault #模拟段错误,让服务器崩溃
object key (refcount|encoding|idletime)
monitor #打开控制台,观察命令(调试用)
client list #列出所有连接
client kill #杀死某个连接  CLIENT KILL 127.0.0.1:43501
client getname #获取连接的名称 默认nil
client setname "名称" #设置连接名称,便于调试



====连接命令===
auth 密码 #密码登陆(如果有密码)
ping #测试服务器是否可用
echo "some content" #测试服务器是否正常交互
select 0/1/2... #选择数据库
quit #退出连接

# 启动redis
启动redis时直接 redis-server就可以启动服务端了，也可以指定加载的配置文件

```php
redis-server ./***/redis.conf
```

默认情况下 redis-server会以非守护进程（简单理解就是后台运行）的形式启动，指定配置文件后就可以实现以守护进程运行。

# redis数据类型

```
type key
```

使用`object encoding key`可以判断数据类型，字符串长度大于39,底层数据结构蜕变为`raw`
redis是一种高级的key:redis存储系统，redis的value共支持五种数据类型

字符串(strings)，列表(lists)，哈希散列(hashes)，集合(sets)，有序集合(sorted sets)

## strings
字符串累行是二进制安全（可以存储用二进制表示的文件）。

再遇到数值操作时，redis会将字符串类型转换成数值。

由于INCR等指令本省就具有原子操作的特性，所以我们可以利用redis的INCR、INCRBY、DECR、DECRBY等指令来实现原子计数的效果。

## lists
redis的lists在底层实现上并不是数组，而是链表，也就是说，lists具有链表所具有的优势，也具有链表所具有的劣势。

lists的常用操作包括 LPUSH、RPUSH、LRANGE等。
```
lrange key start end 
lrem key count element
lpush key element [element...]
lpop key [count]
```

## sets
集合，是一种无序集合，元素没有先后顺序，但元素唯一

集合操作，诸如添加新元素、删除已有元素、交集、并集、差集等

## sorted sets
有序集合每个元素都关联一个序号（score）,是排序的依据

有时，也将redis的有序集合成为 zsets，因为在redis中，有序集合的操作都是z开头的，如 zrange、zadd、zrevrange、zrangebyscore等

## hashes
hashes存储的是字符串和字符串值之间的映射。比如存储一个用户的姓名、年龄、联系方式等。

# redis持久化
redis长时间挂载在内存上，但有时我们需要其将内容及时拷贝，这时，我们就需要redis的持久化功能

redis提供两种持久化方式，分别是RDB(redis database)和AOF(append only file)

## RDB
就是在不同的时间点，将redis存储的数据生成快照并存储到磁盘等介质上

这是一种类似快照的持久化方法
redis在进行数据持久化的过程中，会将数据先写入到一个临时文件中，等到持久化过程都结束了，才会用该临时文件替换上次持久化的文件。

对于RDB方式，redis会单独创建（fork）一个子进程来进行持久化任务，而此时主进程是不会进行任何IO操作的，保证服务的正常高性能进行

如果需要进行大规模数据的恢复，切对于数据恢复的完整性不是非常敏感，那RDB方式比AOF方式更加高效

当数据完整性要求较好高时，redis发生故障，会有一段时间的数据没来得及进行快照，进而导致丢失

## AOF
将redis执行过的所有指令记录下来，在下次启动时，只要将指令读入再执行一遍，数据就恢复了

默认的AOF持久化策略是没秒 fsync（fsync指把缓存中的写指令记录到磁盘中）,因为在这种情况下，redis仍可以保持很好的性能，即使redis故障，也只丢失了最近1秒的数据

AOF方式的一个好处就是可以进行“情景再现”,若我们不小心清空了redis，当AOF文件还没被重写时，我们就可以修改AOF文件，重启redis在恢复数据

在同样数据规模的情况下，AOF文件比RDB文件大得多，且AOF恢复速度要慢于RDB方式

### AOF重写
在重写即将开始前，redis会创建（fork）一个重写子进程，该子进程会先读取现有的AOF文件，并将其包含的指令进行分析压缩并写入到一个临时文件中。

与此同时，主进程会将新接收到的写指令一边积累到内存缓冲区中，一边继续写入到原有的AOF文件中。这样做保证原有的AOF文件的可用性，避免在重写过程中出现意外。

当重写子进程完成重写任务后，他会给主进程发一个信号，主进程收到信号后就会将内存中缓存的写指令追加到新AOF文件中。

当追加结束后，redis就会用心AOF文件来代替旧AOF文件，之后再有新的写指令，就会都追加到新的AOF文件中。

# 主从用法
像mysql一样，redis是支持主从同步的，也支持一主多从及多从结构

主从结构，一是为了纯粹的冗余备份，二是为了提升读性能，如很消耗性能的操作可由从服务器承担

redis的主从同步是异步进行的，意味着主从同步不会影响主逻辑，也不会降低redis的处理性能

主从架构中，可以考虑关闭主服务器的数据持久化功能，只让从服务器进行持久化，可以进一步提高主服务器的处理性能

主从架构中，从服务器通常被设置为只读模式，可以避免从服务器的数据被误改。但从服务器还是可以接受到config等指令，所以还是应该避免将从服务器直接暴露到不安全的网络环境中。

## 主从同步原理
从服务器会向主服务器发出sync（异步）指令，当主服务器接收到此指令后，就会调用BGSAVE指令来创建一个子进程专门进行数据持久化工作，也就是将主服务器的数据写入RDB文件中。在数据持久化期间，主服务器将执行的写指令都缓存在内存中

在BGSAVE指令执行完成后，主服务器会将持久化好的RDB文件发送给从服务器，从服务器接收到此文件后会将其存储到磁盘上，然后再将棋读取到内存中。这个动作完成后，主服务器会将这段时间缓存的写指令再以redis协议的格式发送给从服务器

即使有多个从服务器同时发来sync指令，主服务器也只会执行一次BGSAVE，然后把持久化好的RDB文件发给多个下游。

主服务器会在内存中维护一个缓冲区，缓冲区中存储着将要发给从服务器的内容。从服务器在与主服务器出线网络瞬断之后，从服务器会尝试再次与主服务器连接，一点连接成功，从服务器就会把“希望同步的主服务器ID”和“希望请求的数据偏移位置”发送出去。主服务器接收到这样的同步请求后，首先会验证主服务器ID是否和自己的ID匹配，其次会检查“请求的偏移位置”是否存在于自己的缓冲区中，如果两者都满足的haul，主服务器就会向从服务器发送增量内容

# redis的事务处理
事务是指“一个完整的动作，要么全部执行，要么全部不执行”
redis事务处理：

MULTI 用来组装一个事务
EXEC 用来执行一个事务
DISCARD 用来取消一个事务
WATCH 用来监视一些key，一旦这些key在事务执行之前被改变，则取消事务的执行
在用 MULTI 组装驶入时，每一个命令都会进入到内存队列中缓存起来，如果出现 QUEUED 则表示我们这个命令成功插入到缓存队列，在将来执行 EXEC 时，这些被 QUEUED 的命令会被组装成一个事务来执行

有关事务，常见的两类错误：

调用EXEC之前错误
调用EXEC之后错误
“调用EXEC之前错误”，有可能是由于语法有错误导致，也可能由于内存不足导致。只要出现某个命令无法成功写入缓冲队列的情况，redis都会进行记录，在客户端调用EXEC时，redis会拒绝执行这一事务。

“调用EXEC之后错误”，redsi采取了不同的策略，即redis不会理睬这些错误，而是继续向下执行事务中的其他命令。因为，对于应用层的错误，并不是redis自身需要考虑处理的问题，故，一个事务中某一条命令执行失败，并不影响接下来的其他命令的执行。

## watch
作用是“监视key是否被改动过”，且支持同时监视多个key，只要还没真正触发事务，WATCH 都会尽职尽责的监视，一旦发现某个key被修改了，在执行EXEC时就会返回 nil ，表示事务无法触发。

## redis配置文件
redis配置文件分为几大区域：

- 通用（general）
- 快照（snapshotting）
- 复制（replication）
- 安全（security）
- 限制（limit）
- 追加模式（append only mode）
- LUA脚本（lua scripting）
- 慢日志（slow log）
- 事件通知（event notification）

## PHP秒杀示例

```php
$redis->watch('lucky');        // 监听lucky，lucky的值可以是0
$value = $redis->get('lucky'); // 获取lucky的值 
$redis->multi();               // 开启事务
if ($value < 20) {             // 如果库存足够，则幸运数量加一
    $redis->incr('lucky');
}
if ($redis->exec()) {          // 如果有其它线程改变了lucky的值，则秒杀失败，否则提交事务，秒杀成功，幸运数量加一
    dump('秒杀成功');
} else {
    dump('秒杀失败');
}
```

## 实时监控

redis-cli monitor