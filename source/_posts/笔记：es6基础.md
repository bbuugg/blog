---
title: 笔记：es6基础
date: 2020-08-15 07:21:59
tags:
---

# ECMAScript 与 javascript 

&gt;ECMAScript 可以说是 javascript 的国际标准。

## let
let 用来声明变量，用法类似 var 但由 let 声明的变量，只能在 let 命令所在的代码块内有效。

var 声明的变量在全局范围内都有效

var 命令会发生“变量提升”现象，即变量会在声明前可使用，而 let 做了语法处理，限制了这种情况

暂时性死区
若区块中存在let 和 const 命令，这个区块对这些命令声明的变量从一开始就有了封闭作用域。凡是声明前使用这些变量，就会报错。在语法上，称为“暂时性死区”。

不允许重复声明
let 不允许在同作用域内，重复声明同一个变量。

const命令
const 声明一个只读常亮，一旦声明，不可再修改，即为声明变量需要立即初始化

作用域与 let 相同

# ES6声明变量
共六种：var function let const import class

变量的解构赋值
数组解构
类似 let [a,b,c,] = [1,2,3];

若解构失败，变量的值就等于 undefined

解构赋值允许指定默认值

对象解构赋值
元素按次序排列，变量的取值由位置决定，而对象的属性无次序，变量必须与属性同名，才能取得正确的值

函数扩充
ES6中函数参数可带有默认值

参数变量是默认声明的，所以不能用 let 或 const 再次声明

使用参数默认值时，函数不能有同名参数

定义了默认值的参数，应该是函数的尾参数

rest参数
ES6引入 rest 参数（形式为 . . .变量名 ），用于获取函数的多余参数。

rest 参数搭配的变量是一个数组，该变量将多余的参数放入数组中。

rest 参数后不能再有参数

函数的 length 参数，不包括 rest 参数

name属性
返回函数的函数名

若将匿名函数赋值给一个变量，将返回变量名

Function 构造函数返回的函数实例，name 属性的值为 anonymous

bind返回的函数，name 属性值会加上 bound 前缀

箭头函数
ES6允许使用“箭头” (=&gt;)定义函数

var f = v =&gt; v;
等同于
var f = function (v) {
    return v;
}
如果箭头函数不需要参数或者需要多个参数，可以使用一个圆括号代表参数

var f = () =&gt; 5;
等同于 
var f = function ( ) { return 5; }
var sum = ( num1, num2) =&gt; num1 + num2;
等同于
var sum = function ( num1, num2) {
    return num1 + num2;
}
如果箭头函数代码块部分多余一条语句，就要使用大括号将他们括起来，并使用 return 语句返回。

var sum = ( num1, num2) =&gt; { return num1 + num2; }
由于大括号被解释为代码块，所以如果箭头函数直接返回一个对象，必须在对象外面加上大括号。

let getTempItem = id =&gt; ( { id : id ,name : &quot; Temp&quot;} ) ;
箭头函数使得表达式更为简洁

const isEven = n =&gt; n % 2 == 0 ;
const square = n =&gt; n * n ;
箭头函数可以简化回调函数

[ 1, 2, 3] .map( function (x) ){
    return x * x ;
}
箭头函数
[1, 2, 3].map( x =&gt; x * x ) ;
箭头函数与 rest 参数结合

const numbres = ( ...nums) =&gt; nums ;
numbers (1, 2, 3, 4, 5)
// [ 1, 2, 3, 4, 5]
const headAndTail = ( head , ...tail ) =&gt; [head, tail] ;
handAndTail (1, 2, 3, 4, 5)
// [1, [2, 3, 4, 5] ]
箭头函数使用注意
函数内的 this 对象，就是定义时所在的对象，而不是使用时所在的对象

不可以当作构造函数，也就是说，不可使用 new 命令

不可使用 arguments 对象，该对象在函数体内不存在。若要用，可使用 rest 参数代替

不可以使用 yield 命令

嵌套的箭头函数
箭头函数的内部，还可以使用箭头函数

 const plus1 = a =&gt; a+1;
 const mult2 = a =&gt; a * 2;
 mult2 ( plus1(5) )
双冒号运算符
函数绑定运算符，取代 call，apply，bind；

双冒号左边是一个对象，右边是一个函数。自动将左边的对象，作为上下文环境（即this对象）绑定到右边函数上。

foo :: bar
等同于
bar.bind( foo ) ;
foo :: bar( ..arguments ) ;
等同于
bar.apply( foo, arguments ) ;
如果双冒号左边为空，右边是一个对象的方法，等于将该方法绑定在该对象上

var method = obj :: obj.foo ;
var method = :: obj.foo ;
let log = :: console.log ;
var log = console.log.bind(console) ;
如果双冒号运算符的晕眩结果，还是一个对象，可以使用链式写法

import { map , takeWhile, foreach } from &quot;iterlib&quot; ;
getPlayers()
:: map( x =&gt; x.character ( ) )
:: takeWhile ( x =&gt; x.strength &gt; 100)
:: foreach ( x =&gt; console.log( x ) );
尾调用优化
尾调用（tail call）是函数式编程的一个概念，指某个函数的最后一步是调用另一个函数

function f ( x ) {
    return g ( x ) ;
}
尾调用之所以与其他调用不同，就在于它的特殊的调用位置。我们知道，函数调用会在内存形成一个“调用记录”，又称“调用帧”（call frame），保存调用位置和内部变量等信息。如果在函数A的内部调用函数B，那么在A的调用帧上方，还会形成一个B的调用帧。等到B运行结束，将结果返回到A，B的调用帧才会消失。如果函数B内部还调用函数C，那就还有一个C的调用帧，以此类推。所有的调用帧，就形成一个“调用栈”（call stack）。

尾调用由于是函数的最后一步操作，所以不需要保留外层函数的调用帧，因为调用位置、内部变量等信息都不会再用到了，只要直接用内层函数的调用帧，取代外层函数的调用帧就可以了。

```javascript
function f ( ) {
    let m = 1;
    let n =2;
    return g( m + n ) ;
}
f( );
```
等同于
```javascript
function f( ) {
    return g( 3 ); 
}
f( );
```
等同于
```javascript
g( 3 );
```
尾调用优化就是只保留内层函数的调用帧。

递归非常耗费内存，很容易发生“栈溢出”。对于尾递归来说，只存在一个调用帧，所以不会发生“栈溢出”

递归函数的改写
函数式编程有个概念，叫柯里化，意思是将多参数转换成但参数形式

```javascript
//采用es6
function  factorial( n, total = 1 ) {
    if( n == 1 ) return total;
    return factorial( n-1, n * total ) ;
}
factorial( 5 ); //120
```

原文地址 : [es6基础](http://yuque.com/oswind/es6 &quot;跳转&quot;)