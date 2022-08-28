---
title: PHP算法
date: 2022-06-11 18:50:26
tags:
---

# 排序

## 快速排序
```
function quickSort($arr)
{
  if (count($arr) <= 1) {
    return $arr;
  } else {
    $key = $arr[0];
    $left = [];
    $right = [];
    for ($i = 1; $i < count($arr); $i++) {
      if ($arr[$i] < $key) {
        $left[] = $arr[$i];
      } else {
        $right[] = $arr[$i];
      }
    }
    $left = quickSort($left);
    $right = quickSort($right);
    return array_merge($left, [$key], $right);
  }    
}
```

# 无限级分类

例如数据格式如下：

```
$categories = [
  [
    'id' => 1,
    'parent_id' => 0,
  ],
  [
    'id' => 2,
    'parent_id' => 1,
  ],
  [
    'id' => 3,
    'parent_id' => 2,
  ]
];
```

示例方法

```php
function get_tree($data) {
    $items = [];
    foreach ($data as $v){
        $items[$v['id']] = $v;
    }
    $tree = array();//格式化好的树
    foreach ($items as $item)
       if (isset($items[$item['parent_id']]))
             $items[$item['parent_id']]['children'][] = &$items[$item['id']];
       else   $tree[] = &$items[$item['id']];
    return $tree;
};
```

```php
function get_tree($categories, $parent_id = 0)
{
  $arr = [];
  foreach ($categories as $v) {
    if ($v['parent_id'] == $parent_id) {
      $v['children'] = get_tree($categories, $v['id']);
      $arr[] = $v;
    }
  }
  return $arr;
}
```

最终数据

```
array(1) {
  [0]=>
  array(3) {
    ["id"]=>
    int(1)
    ["parent_id"]=>
    int(0)
    ["children"]=>
    array(1) {
      [0]=>
      array(3) {
        ["id"]=>
        int(2)
        ["parent_id"]=>
        int(1)
        ["children"]=>
        array(1) {
          [0]=>
          array(3) {
            ["id"]=>
            int(3)
            ["parent_id"]=>
            int(2)
            ["children"]=>
            array(0) {
            }
          }
        }
      }
    }
  }
}
```

# 拼手气分红包分配

```php
/**
 * 拼手气红包分配算法
 *
 * @param $money  金额
 * @param $count 数量
 */
function redAlgorithm($money, $count)
{
    // 参数校验
    if ($count * 0.01 > $money) {
        throw new \Exception("单个红包不能低于0.01元");
    }
    // 存放随机红包
    $redpack = [];
    // 未分配的金额
    $surplus = $money;
    for ($i = 1; $i <= $count; $i++) {
        // 安全金额
        $safeMoney = $surplus - ($count - $i) * 0.01;
        // 平均金额
        $avg = $i == $count ? $safeMoney : bcdiv($safeMoney, ($count - $i), 2);
        // 随机红包
        $rand = $avg > 0.01 ? mt_rand(1, $avg * 100) / 100 : 0.01;
        // 剩余红包
        $surplus = bcsub($surplus, $rand, 2);
        $redpack[] = $rand;
    }
    // 平分剩余红包
    $avg = bcdiv($surplus, $count, 2);
    for ($n = 0; $n < count($redpack); $n++) {
        $redpack[$n] = bcadd($redpack[$n], $avg, 2);
        $surplus = bcsub($surplus, $avg, 2);
    }
    // 如果还有红包没有分配完时继续分配
    if ($surplus > 0) {
        // 随机抽取分配好的红包，将剩余金额分配进去
        $keys = array_rand($redpack, $surplus * 100);
        // array_rand 第二个参数为 1 时返回的是下标而不是数组
        $keys = is_array($keys) ? $keys : [$keys];
        foreach ($keys as $key) {
            $redpack[$key] = bcadd($redpack[$key], 0.01, 2);
            $surplus = bcsub($surplus, 0.01, 2);
        }
    }
    // 红包分配结果
    return $redpack;
}
```

原文地址:https://www.itqaq.com/index/art/352.html

# ID

## 雪花算法

```
<?php
class Idcreate {
    const EPOCH = 0;
    //开始时间,固定一个小于当前时间的毫秒数
    const max12bit = 1024;
    const max41bit = 1099511627888;
    static $machineId = null;
    public static function machineId($mId = 0) {
        self::$machineId = $mId;
    }
    public static function createOnlyId() {
        // 时间戳 42字节
        $time = floor(microtime(true) * 1000);
        // 当前时间 与 开始时间 差值
        $time -= self::EPOCH;
        // 二进制的 毫秒级时间戳
        $base = decbin(self::max41bit + $time);
        // 机器id  10 字节
        if(!self ::$machineId) {
            $machineid = self ::$machineId;
        } else {
            $machineid = str_pad(decbin(self ::$machineId),10,"0",STR_PAD_LEFT);
        }
        $random = str_pad(decbin(mt_rand(0,self::max12bit)),12,"0",STR_PAD_LEFT);
        // 拼接
        $base = $base . $machineid . $random;
        // 转化为 十进制 返回
        return bindec($base);
    }
}
$obj = new Idcreate;
for ($i=0; $i <100 ; $i++) {
    echo $obj->createOnlyId()."<br>";
}
```

## PHP+Redis生成唯一序列

```
$prefix = ‘DS’; //标题前缀

$currentCycle = date(‘ymd‘); // 日期拼接成中间
$key = "codegen:{$currentCycle}:{$prefix}"; // 生成redis健  健名前缀按照天来更新
$Redis = $this->Redis->getRedis(); // 连接redis
$codeNum = $Redis->incr($key);  // 这里用incr 方法来获取当前自增数量 incr是原子性的 能处理并发
// 为1说明是当天的第一条，设置有效期，删除过期key
if ($codeNum == 1) {

　　// 设置有效期1天
　　　　$expireAt = strtotime(date('Y-m-d 00:00:00', strtotime("+1 day")));
　　　　$Redis->expireAt($key, $expireAt);
　　// 删除过期key，加锁，一周期只删一次 setnx锁设置键不存在则设置并返回1，否则返回0
　　if ($Redis->setnx("codegen:{$currentCycle}:rmLock", 1)) {
　　　　$lastCycle = date($dateFormat, strtotime("-1 day"));
　　　　$keys = $Redis->keys("codegen:{$lastCycle}:*");
　　　　foreach ($keys as $k) {
　　　　$Redis->del($k);
　　}

}

$codeNum = str_pad($codeNum, 4, '0', STR_PAD_LEFT);  // 拼成固定长度  比如  1  100  返回 0001  0100

return $prefix . $codeNum;
```

