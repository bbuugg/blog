---
title: PHP数组相加和array_merge
date: 2021-10-04 13:58:17
tags:
---

**array_merge**

如果输入的数组中有相同的字符串键名，则该键名后面的值将覆盖前一个值。然而，如果数组包含数字键名，后面的值将 不会 覆盖原来的值，而是附加到后面。

**联合（数组相加）**

\+ 运算符把右边的数组元素附加到左边的数组后面，两个数组中都有的键名，则只用左边数组中的，右边的被忽略。

```php
<?php
$a = array("a" => "apple", "b" => "banana");
$b = array("a" => "pear", "b" => "strawberry", "c" => "cherry");

$c = $a + $b; // $a 和 $b 的并集
echo "Union of \$a and \$b: \n";
var_dump($c);

$c = $b + $a; // $b 和 $a 的并集
echo "Union of \$b and \$a: \n";
var_dump($c);

$a += $b; //  $a += $b 的并集是 $a 和 $b
echo "Union of \$a += \$b: \n";
var_dump($a);
?>

```

**array_replace**