---
title: Typescript学习笔记
date: 2022-09-18 13:06:34
cover: https://ts1.cn.mm.bing.net/th/id/R-C.11405798e565f05e91995c792278ff4d?rik=IODGhCnazbsF%2fg&riu=http%3a%2f%2fwww.jayleen.wang%2fuploads%2f727a65c7ad06d6cd6e90ae8775ec75b8.png&ehk=WbWyMqj9YFWuRdk0NnCOIged3lN%2b8u7LBjfBW7WGCq8%3d&risl=&pid=ImgRaw&r=0
tags:
---

# 类型

any / number / 元组 / 枚举 / never

## 元组

```typescript
let map : [string, number] = ["str", 123]
```

## 枚举

```typescript
enum Color {Red, Blue, Green}
let c Color = Color.Red
```

<!-- more -->

# 类型断言

```typescript
interface foo {
    bar number
}

const f1 = <foo>{}
f.bar = 1

const f2 = {} as foo
```

```typescript
var str = '1' 
var str2:number = <number> <any> str   //str、str2 是 string 类型
```

> 类型断言是编译时语法，类型转换通常意味着某种运行时支持， typescript支持类型推断，如果不能推断出类型，那么默认是动态any类型

# 变量作用域

- 全局作用域： 全局变量定义在程序结构的外部，它可以在你代码的任何位置使用
- 类作用域：也可成为字段，声明在类内方法外，可以在类对象访问，静态变量可以用类访问
- 局部作用域：只能在代码块中使用

# 循环

```typescript
for ( init; condition; increment ){
    statement(s);
}
```

```typescript
for (var val in list) { 
    //语句 
}
```

```typescript
let someArray = [1, "string", false];
 
for (let entry of someArray) {
    console.log(entry); // 1, "string", false
}
```

> for...of 语句创建一个循环来迭代可迭代的对象。在 ES6 中引入的 for...of 循环，以替代 for...in 和 forEach() ，并支持新的迭代协议。for...of 允许你遍历 Arrays（数组）, Strings（字符串）, Maps（映射）, Sets（集合）等可迭代的数据结构等。

```typescript
let list = [4, 5, 6];
list.forEach((val, idx, array) => {
    // val: 当前值
    // idx：当前index
    // array: Array
});
```

```typescript
let list = [4, 5, 6];
list.every((val, idx, array) => {
    // val: 当前值
    // idx：当前index
    // array: Array
    return true; // Continues
    // Return false will quit the iteration
});
```

> forEach、every 和 some 是 JavaScript 的循环语法，TypeScript 作为 JavaScript 的语法超集，当然默认也是支持的。因为 forEach 在 iteration 中是无法返回的，所以可以使用 every 和 some 来取代 forEach

```typescript
while(true) {  
    // do something
}

do {
    // do something
} while ();
```

# 函数参数

## 可选参数

```typescript
function func1 (name ?: string) {
    console.log(name)
}
```

## 默认参数

> 参数不能同时设置为默认和可选

```typescript
function func2 (name : string = "zhangsan") {
    console.log(name)   
}
```

## 剩余参数

```typescript
function done(...names: string[]) {
    console.log(names)
}
```

> 函数的最后一个命名参数 names 以 ... 为前缀，它将成为一个由剩余参数组成的数组，索引值从0（包括）到 names.length（不包括）

## 构造函数

TypeScript 也支持使用 JavaScript 内置的构造函数 Function() 来定义函数

```typescript
var res = new Function ([arg1[, arg2[, ...argN]],] functionBody)
```

- arg1, arg2, ... argN：参数列表。
- functionBody：一个含有包括函数定义的 JavaScript 语句的字符串

```typescript
var func = new Function("a", "b", "return a+b");
console.log(func("zhang", "san"));
```

## Lambda

```typescript
var foo = (x :number) => {
    console.log(x)
}

var bar = (y :number) => console.log(y)

// var bar = y => console.log(y)

console.log(foo(1))
```

## 函数重载

> 重载是方法名字相同，而参数不同，返回类型可以相同也可以不同。每个重载的方法（或者构造函数）都必须有一个独一无二的参数类型列表。如果参数类型不同，则参数类型应设置为 any。参数数量不同你可以将不同的参数设置为可选。

```typescript
function disp(s1:string):void; 
function disp(n1:number,s1:string):void; 
 
function disp(x:any,y?:any):void { 
    console.log(x); 
    console.log(y); 
} 
disp("abc") 
disp(1,"xyz");
```

> 定义函数重载需要定义重载签名和一个实现签名。重载签名定义函数的形参和返回类型，没有函数体。一个函数可以有多个重载签名(不可调用)

## prototype 实例

```typescript
function employ(name: string) {
    this.name = name
}

var n = new employ("zhangsan");

console.log(n)
```

# 类型

## String

```typescript
var b = new String("guanyu");
```

### prototype

```typescript
function user(name: string) {
    this.name = name
}
var u = new user("xiaohong");
user.prototype.age = 25;
console.log(u.age)
```

### 方法

```typescript
chatAt()
charCodeAt()
concat()
indexOf()
lastIndexOf()
localeCompare()
match()
replace()
search()
slice()
splice()
substr()
substring()
toLocaleLowerCase()
toLocaleUpperCase()
toLowerCase()
toUpperCase()
toString()
valueOf()
```

## number

```typescript
var a = new Number(10);
```

## 属性

```typescript
MAX_VALUE
MIN_VALUE
NaN
NEGATIVE_INFINITY
POSITIVE_INFINITY
prototype
constructor
```

## 方法

```typescript
toExponential()
toFixed()
toLocaleString()
toPrecision()
toString()
valueOf()
```

## Array

### 初始化

```typescript
var a1 = new Array(5); // 指定长度

var a2 = new Array("小荷才露尖尖角"); // 初始化数组元素

console.log(a1, a2)
```

### 数组解构

```typescript
var poetry = new Array("小荷才露尖尖角", "早有蜻蜓立上头");

var [first, last] = poetry

console.log(first, last)
```

### 多维数组

```typescript
var seat: number[][] = [[1, 2, 3], [4, 5, 6]]

console.log(seat)
```

### 方法

```typescript
concat()
every()
filter()
forEach()
indexOf()
join()
lastIndexOf()
map()
pop()
push()
reduce()
reduceRight()
reverse()
shift()
slice()
some()
sort()
splice()
toString()
unshift()
```

## Map对象

> 保存键值对，且可以记住键的原始插入顺序，是ES6引入的新数据结构

```typescript
let m = new Map()
```

```typescript
let a = new Map([
    ["key1", "value1"],
    ["key2", "value2"],
])
```

如果编译报错  error TS2583: Cannot find name 'Map'. Do you need to change your target library? Try changing the 'lib' compiler option to 'es2015' or later. 可以给编译参数加上--terget es6 选项，例如

```shell
tsc app.ts --target es6; node app.js
```

## 方法

```typescript
clear()
set()
get()
has()
delete()
size()
keys()
values()
```

## 使用for...of 迭代map

```typescript
var m = new Map()

m.set("jey", "ds")

for (let key of m.keys()) {
    console.log(key)
}

for (let value of m.values()) {
    console.log(value)
}

for (let entry of m.entries()) {
    console.log(entry)
}

for (let [k, v] of m) {
    console.log(k, v)
}
```

## 元组

```typescript
var a :[string, number] = ["杜甫", 80];
```

```typescript
var b = ["李白", 20];
b.push("陶渊明");
b.pop();
console.log(b[0])
```

## 联合类型

```typescript
var unionTypeVariable : string | number = 10
unionTypeVariable = "王维"

// 数组也可以作为联合类型
var unionTypeVariable2 : string[] | number[] = ["李清照"]
```

## 接口

> 接口是一系列抽象方法的声明，是一些方法特征的集合

```typescript
interface animal {
    type: string
    run(): void
    eat(): void
}

var panda: animal = {
    type: "panda",
    run(): void {
        console.log(this.type + " run")
    },
    eat(): void {
        console.log(this.type + " eat")
    }
}

panda.run()
panda.eat()
```

在接口中使用联合类型

```typescript
interface controller {
    action: string | string[] | (() => string)
}
```

### 接口继承

```typescript
interface person {
    name: string
}
interface man extends person {
    height: number
}
interface baby extends man {
    age: number
}

const ba: baby = <baby>{}

ba.age = 10
ba.height = 100
ba.name = "张择端"

console.log(ba)
```

> 多继承可以使用逗号分割

## 类

```typescript
interface AuthManager {
    name: string
}

class Auth implements AuthManager {
    name: string

    constructor(name: string) {
        this.name = name
    }

    protected login(): string {
        return this.name + " auth";
    }

    private logout() {
        // ...
    }
}

class JwtAuth extends Auth {
    static type: string = "jwt"
    // 重写login方法 ，并将访问权限更改为public
    public login(): string {
        return this.name + " jwt auth"
    }
}

var auth = new JwtAuth("刘备")
var data = auth.login()

console.log(auth, data, JwtAuth.type, auth instanceof Auth)
```

> 给构造函数参数加入public修饰，等同于创建了同名的成员变量

```typescript
class User {
    constructor(public name: string) {
        console.log(this.name)
    }
}

var user = new User("user")
```

## 对象

```typescript
var obj = {
    name: "user",
    say: function () {
        console.log(this.name)
    }
}

console.log(obj.say())
```

对象也可以作为参数传递

```typescript
function Test (func: () => string) {
    // 接收一个返回类型为string的闭包
}
```

## 命名空间

如果一个命名空间在一个单独的 TypeScript 文件中，则应使用三斜杠 /// 引用它，语法格式如下：

```
/// <reference path = "SomeFileName.ts" />
```

```typescript
namespace Max {
    // 嵌套命名空间
    export namespace Di {
        export class Container {

        }
    }
}

var container = new Max.Di.Container()
```

## 模块

### 报错 ReferenceError: define is not defined 

编译选项添加 --module commonjs

参考：https://segmentfault.com/a/1190000018249137