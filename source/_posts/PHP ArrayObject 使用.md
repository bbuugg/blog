---
title: PHP ArrayObject 使用
date: 2022-03-06 15:17:00
tags:
---

# ArrayObject的使用说明

> ArrayObject是将数组转换为数组对象。

## 代码示例

```php
<?php  //打印全部数组元素
$array =array('1'=>'one', '2'=>'two', '3'=>'three');

$arrayobject = new ArrayObject($array);//构造一个ArrayObject对象
for($iterator= $arrayobject->getIterator();//构造一个迭代器    
$iterator->valid();//检查是否还含有元素    
$iterator->next()){ //指向下个元素    
echo $iterator->key() . ' => ' . $iterator->current() . "\n";//打印数组元素
}
?>

<?php   //重置数组指针
$arrayobject =new ArrayObject();
$arrayobject[] = 'zero';
$arrayobject[] = 'one';
$arrayobject[] = 'two';
$iterator= $arrayobject->getIterator();
$iterator->next();
echo $iterator->key(); // 1
$iterator->rewind(); //重置指针到头部
echo $iterator->key(); // 0
?>
```

## ArrayObject的常用函数

```cpp
ArrayIterator::current( void ) //返回当前数组元素

ArrayIterator::key(void) //返回当前数组key

ArrayIterator::next (void)//指向下个数组元素

ArrayIterator::rewind(void )//重置数组指针到头

ArrayIterator::seek()//查找数组中某一位置

ArrayIterator::valid()//检查数组是否还包含其他元素

ArrayObject::append()//添加新元素

ArrayObject::__construct()//构造一个新的数组对象

ArrayObject::count()//返回迭代器中元素个数

ArrayObject::getIterator()//从一个数组对象构造一个新迭代器

ArrayObject::offsetExists(mixed index )//判断提交的值是否存在

ArrayObject::offsetGet()//指定 name 获取值

ArrayObject::offsetSet()//修改指定 name 的值

ArrayObject::offsetUnset()//删除数据
```

参考文档：[www.php.net](https://www.php.net/manual/zh/arrayobject.construct)