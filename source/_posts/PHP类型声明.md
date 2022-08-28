---
title: PHP类型声明
date: 2021-11-28 11:14:49
tags:
---

# 类型声明

类型声明可以用于函数的参数、返回值，PHP 7.4.0 起还可以用于类的属性，来显性的指定需要的类型，如果预期类型在调用时不匹配，则会抛出一个 [TypeError](https://www.php.net/manual/zh/class.typeerror.php) 异常。

**注意**:

当子类覆盖父方法时，子类的方法必须匹配父类的类型声明。如果父类没有定义返回类型，那么子方法可以指定自己的返回类型。



## 单一类型[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.base)

| 类型                                                         | 说明                                                         | 版本      |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :-------- |
| 类/接口 名称                                                 | 值必须为指定类和接口的实例化对象 [`instanceof`](https://www.php.net/manual/zh/language.operators.type.php) |           |
| self                                                         | 值必须是用于类型声明相同类的 [`instanceof`](https://www.php.net/manual/zh/language.operators.type.php) 。 仅可在类中使用。 |           |
| parent                                                       | 值必须是用于类型声明父级类的 [`instanceof`](https://www.php.net/manual/zh/language.operators.type.php) ， 仅可在类中使用。 |           |
| array                                                        | 值必须为 array。                                             |           |
| [callable](https://www.php.net/manual/zh/language.types.callable.php) | 值必定是一个有效的 [callable](https://www.php.net/manual/zh/language.types.callable.php)。 不能用于类属性的类型声明。 |           |
| bool                                                         | 值必须为一个布尔值。                                         |           |
| float                                                        | 值必须为一个浮点数字。                                       |           |
| int                                                          | 值必须为一个整型数字。                                       |           |
| string                                                       | 值必须为一个 string。                                        |           |
| [iterable](https://www.php.net/manual/zh/language.types.iterable.php) | 值必须为 array 或 [`instanceof`](https://www.php.net/manual/zh/language.operators.type.php) **Traversable**。 | PHP 7.1.0 |
| object                                                       | 值必须为object。                                             | PHP 7.2.0 |
| [mixed](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.mixed) | 值可以为任何类型。                                           | PHP 8.0.0 |

### mixed[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.mixed)

[mixed](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.mixed) 等同于 [联合类型](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.union) object|resource|array|string|int|float|bool|null。PHP 8.0.0 起可用。

## 允许为空的（Nullable）类型[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.nullable)

自 PHP 7.1.0 起，类型声明允许前置一个问号 (`?`) 用来声明这个值允许为指定类型，或者为 **`null`**。



**示例 #5 定义可空（Nullable）的参数类型**

```
<?php
class C {

}

function f(?C $c) {
	var_dump($c);
}

f(new C);

f(null);
?>
```

以上例程会输出：

```
object(C)#1 (0) {
}
NULL
```

**示例 #6 定义可空（Nullable）的返回类型**

```
<?php

function get_item(): ?string {  
	if (isset($_GET['item'])) {   
		return $_GET['item'];  
	} else {    
		return null;  
	}
}

?>
```

> **注意**:
>
> 可以通过设置参数的默认值为 `null` 来实现允许为空的参数。不建议这样做，因为影响到类的继承调用。
>
> **示例 #7 旧版本中实现允许为空参数的示例**

```php
<?php

class C
{

}

function f(C $c = null)
{
    var_dump($c);
}

f(new C);
f(null);
?>
```

> 以上例程会输出：

```
object(C)#1 (0) {
}
NULL
```

## 联合类型[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.union)

联合类型接受多个不同的类型做为参数。声明联合类型的语法为 `T1|T2|...`。联合类型自 PHP 8.0.0 起可用。

### 允许为空的联合类型[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.union.nullable)

`null` 类型允许在联合类型中使用，例如 `T1|T2|null` 代表接受一个空值为参数。已经存在的 `?T` 语法可以视为以下联合类型的一个简写 `T|null`。

**警告**

`null` 不能作为一个独立的类型使用。

### false 伪类型[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.union.false)

通过联合类型支持字面类型（Literal Type）`false`， 出于历史原因，很多内部函数在失败时返回了 `false` 而不是 `null`。 这类函数的典型例子是 [strpos()](https://www.php.net/manual/zh/function.strpos.php)。

**警告**

`false` 不能单独作为类型使用（包括可空 nullable 类型）。 因此，`false`、`false|null`、 `?false` 都是不可以用的。

**警告**

`true` 字面类型*不存在*。

### 重复冗余的类型[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.union.redundant)

为了能在联合类型声明中暴露简单的 bug，不需要加载 class 就可以在编译时让重复冗余的类型产生错误。 包含：

- 解析出来的类型只能出现一次。例如这样的类型 `int|string|INT` 会导致错误。
- 使用了 bool 时就不能再附带使用 false。
- 使用了 object 时就不能再附带使用 class 类型。
- 使用了 [iterable](https://www.php.net/manual/zh/language.types.iterable.php) 时，array、 **Traversable** 都不能再附带使用。

> **注意**: 不过它不能确保类型最小化，因为要达到这样的效果，还要加载使用类型的 class。

例如，假设 `A` 和 `B` 都是一个类的别名， 而 `A|B` 仍然是有效的，哪怕它可以被简化为 `A` 或 `B`。 同样的，如果 `B extends A {}`，那 `A|B` 仍然是有效的联合类型，尽管它可以被简化为 `A`。

```
<?php
function foo(): int|INT {} // 不允许
function foo(): bool|false {} // 不允许

use A as B;
function foo(): A|B {} // 不允许 ("use" 是名称解析的一部分)

class_alias('X', 'Y');
function foo(): X|Y {} // 允许 (运行时才能知道重复性)
?>
```

## 仅仅返回类型[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.return-only)

### void[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.void)

`void` 是一个返回类型，用于标识函数没有返回值。 它不能是联合类型的一部分。 PHP 7.1.0 起可用。

> **注意**:
>
> 从 PHP 8.1.0 起弃用引用返回 void 的函数， 因为这样的函数是矛盾的。 之前，它在调用时已经发出如下 **`E_NOTICE`**： `Only variable references should be returned by reference`。

```
<?php
function &test(): void {}
?>
```

### never[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.never)

`never` 是一种表示没有返回的返回类型。这意味着它可能是调用 [exit()](https://www.php.net/manual/zh/function.exit.php)， 抛出异常或者是一个无限循环。所以，它不能作为联合类型的一部分。PHP 8.1.0 起可用。

在类型理论用于中，never 是底层类型。 意味着它是其它所有类型的子类型，并且可以在继承期间替换任何其他返回类型。

### static[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.static)

它的值必须是一个 class 的 [`instanceof`](https://www.php.net/manual/zh/language.operators.type.php)，该 class 是调用方法所在的同一个类。 PHP 8.0.0 起有效。

## 严格类型[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.strict)

默认如果可能，PHP 会强制转化不合适的类型为想要的标量类型。 比如，参数想要 string，传入的是 int， 则会获取 string 类型的变量。

可以按文件开启严格模式。 在严格模式下，只能接受完全匹配的类型，否则会抛出 [TypeError](https://www.php.net/manual/zh/class.typeerror.php)。 唯一的例外是 int 值也可以传入声明为 float 的类型。

**警告**

通过内部函数调用函数时，不会受 `strict_types` 声明影响。

要开启严格模式，使用 [`declare`](https://www.php.net/manual/zh/control-structures.declare.php) 开启 `strict_types`：

> **注意**:
>
> 文件开启严格类型后的*内部*调用函数将应用严格类型， 而不是在声明函数的文件内开启。 如果文件没有声明开启严格类型，而被调用的函数所在文件有严格类型声明， 那将遵循调用者的设置（开启类型强制转化）， 值也会强制转化。

> **注意**:
>
> 只有为标量类型的声明开启严格类型。

**示例 #8 参数值的严格类型**

```
<?php
declare(strict_types=1);

function sum(int $a, int $b) {
    return $a + $b;
}

var_dump(sum(1, 2));
var_dump(sum(1.5, 2.5));
?>
```

以上例程在 PHP 8 中的输出：

```
int(3)

Fatal error: Uncaught TypeError: sum(): Argument #1 ($a) must be of type int, float given, called in - on line 9 and defined in -:4
Stack trace:
#0 -(9): sum(1.5, 2.5)
#1 {main}
  thrown in - on line 4
```

**示例 #9 参数值的类型强制转化**

```
int(3)

Fatal error: Uncaught TypeError: sum(): Argument #1 ($a) must be of type int, float given, called in - on line 9 and defined in -:4
Stack trace:
#0 -(9): sum(1.5, 2.5)
#1 {main}
  thrown in - on line 4
```

以上例程会输出：

```
int(3)
int(3)
```

**示例 #10 返回值的严格类型**

```
<?php
declare(strict_types=1);

function sum($a, $b): int {
    return $a + $b;
}

var_dump(sum(1, 2));
var_dump(sum(1, 2.5));
?>
```

以上例程会输出：

```
int(3)

Fatal error: Uncaught TypeError: sum(): Return value must be of type int, float returned in -:5
Stack trace:
#0 -(9): sum(1, 2.5)
#1 {main}
  thrown in - on line 5
```

## 联合类型的内部隐式强制转化[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.union.coercive)

没有开启 `strict_types` 时，标量类型可能会限制内部隐式类型转化。 如果值的类型不是联合类型中的一部分，则目标类型会按以下顺序：

1. int
2. float
3. string
4. bool

如果类型出现在组合中，值可以按 PHP 现有的类型语义检测进行内部隐式强制转化，则会选择该类型。 否则会尝试下一个类型。

**警告**

有一个例外：当值是字符串，而 int 与 float 同时在组合中，将按现有的“数字字符串”检测语义，识别首选的类型。 例如，`"42"` 会选择 int 类型， 而 `"42.0"` 会选择 float 类型。

> **注意**:
>
> 没有出现在上面列表中的类型则不是有效的内部隐式转化目标。 尤其是不会出现内部隐式转化 `null` 和 `false` 类型。

**示例 #11 类型强制转换为联合类型的例子**

```
<?php
// int|string
42    --> 42          // 类型完全匹配
"42"  --> "42"        // 类型完全匹配
new ObjectWithToString --> "__toString() 的结果"
                      // object 不兼容 int，降级到 string
42.0  --> 42          // float 与 int 兼容
42.1  --> 42          // float 与 int 兼容
1e100 --> "1.0E+100"  // float 比 int 大太多了，降级到 string
INF   --> "INF"       // float 比 int 大太多了，降级到 string
true  --> 1           // bool 与 int 兼容
[]    --> TypeError   // array 不兼容 int 或 string

// int|float|bool
"45"    --> 45        // int 的数字字符串
"45.0"  --> 45.0      // float 的数字字符串

"45X"   --> true      // 不是数字字符串，降级到 bool
""      --> false     // 不是数字字符串，降级到 bool
"X"     --> true      // 不是数字字符串，降级到 bool
[]      --> TypeError // array 不兼容 int、float、bool
?>
```

## 其他[ ¶](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.misc)

**示例 #12 传引用参数的类型**

仅仅会在函数入口检查传引用的参数类型，而不是在函数返回时检查。 所以函数返回时，参数类型可能会发生变化。

```
<?php
function array_baz(array &$param)
{
    $param = 1;
}
$var = [];
array_baz($var);
var_dump($var);
array_baz($var);
?>
```

以上例程在 PHP 8 中的输出：

```
int(1)

Fatal error: Uncaught TypeError: array_baz(): Argument #1 ($param) must be of type array, int given, called in - on line 9 and defined in -:2
Stack trace:
#0 -(9): array_baz(1)
#1 {main}
  thrown in - on line 2
```

**示例 #13 捕获 [TypeError](https://www.php.net/manual/zh/class.typeerror.php)**

```
<?php
declare(strict_types=1);

function sum(int $a, int $b) {
    return $a + $b;
}

try {
    var_dump(sum(1, 2));
    var_dump(sum(1.5, 2.5));
} catch (TypeError $e) {
    echo 'Error: ', $e->getMessage();
}
?>
```

以上例程在 PHP 8 中的输出：

```
int(3)
Error: sum(): Argument #1 ($a) must be of type int, float given, called in - on line 10
```

原文地址：https://www.php.net/manual/zh/language.types.declarations.php