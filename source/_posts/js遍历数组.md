---
title: js遍历数组
date: 2022-07-23 13:51:29
tags:
---

JS中遍历数组经常用到，这里总结了6种遍历方法，以及各种方法的优劣。

## 1. for 遍历数组

### **1.1 for 的普通遍历**

```js
var name = ['Peter','Stark','Jack'];
// for 循环
for(var i = 0; i < name.length; i++) {
  console.log(name[i]);
}
```

<!-- more -->

### **1.2 for 优化版遍历**

```js
var name = ['Peter','Stark','Jack'];
// 先缓存 name.length
for(var i = 0, len = name.length; i < len; i++) {
  console.log(name[i]);
}
```

## 2、while 遍历数组

```js
// while 循环
var i = 0;
while (i < name.length) {
  console.log(name[i]);
  i++;
}
//while 逆向遍历
var i = name.length;
while (i--) {
  console.log(name[i]);
}
```

## 3. for...in 方法

数组既可遍历对象，也可遍历数组。遍历数组时也会遍历非数字键名,所以不推荐 for..in 遍历数组

### 3.1 遍历数组

```js
var a = [1, 2, 3];
for (var key in a) {
  console.log(a[key]);
}
/* 1
   2
   3 */
```

### 3.2 遍历对象

```js
const object = {
  name: 'Peter',
  age: 12,
  isHuman: true
};
for (let key in object) {
  console.log(key + '---' + object[key]);
}
```

## 4. for...of 方法 (ES6)

```js
var arr = ['a','b','c'];
for(let item of arr) {
  console.log(item);
}
```

## 5. forEach() 方法

用来遍历数组中的每一项，不影响原数组，性能差

缺陷 你不能使用break语句中断循环，也不能使用return语句返回到外层函数。

### 5.1 遍历普通数组

```js
var arr = [1,2,3,4];
arr.forEach = (function(item) {
  console.log(item);
})
```

### 5.2 forEach() 遍历对象类型数组

```js
const info = [
  {id: 1000, name: 'zhangsan'},
  {id: 1001, name: 'lisi'},
  {id: 1002, name: 'wangwu'}
]
arr.forEach( function(item) {
  console.log(item.id + '---' + item.name);
})
/* 1---zhangsan
   2---lisi
   3---wangwu */
```

## 6. map() 方法

支持return，相当与原数组克隆了一份，把克隆的每项改变了，不影响原数组

```js
var arr = [1,2,3,4];
arr.map( function(item) {
  return item;
})
```

当然有了 `箭头函数 =>` 后更方便

```js
var arr = ['a','b','c'];
var newArray = arr.map(x => x);
alert(newArray); // ['a','b''c']
```

`map()` 方法创建一个新数组，其结果是该数组中的每个元素都调用一个提供的函数后返回的结果

```js
var newArray = arr.map(function (item) {
  return [expression];
})
```

例如

```js
var arr = [1,2,3,4];
var newArray = arr.map(
  x => x * x
)
alert(newArray); // [1,4,9,16]
```

