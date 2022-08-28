---
title: PHP的闭包
date: 2021-04-03 22:00:14
tags:
---

#减少foreach的循环的代码

```
&lt;?php

// 一个基本的购物车，包括一些已经添加的商品和每种商品的数量。
// 其中有一个方法用来计算购物车中所有商品的总价格。该方法使用了一个closure作为回调函数。
class Cart {
    const PRICE_BUTTER = 1.00;
    const PRICE_MILK   = 3.00;
    const PRICE_EGGS   = 6.95;

    protected $products = [];

    public function add($product, $quantity) {
        $this-&gt;products[$product] = $quantity;
    }

    public function getQuantity($product) {
        return isset($this-&gt;products[$product]) ? $this-&gt;products[$product] : FALSE;
    }

    public function getTotal($tax) {
        $total = 0.00;

        $callback =
        function ($quantity, $product) use ($tax, &amp;$total) {
            $pricePerItem = constant(__CLASS__ . &quot;::PRICE_&quot; .
                strtoupper($product));
            $total += ($pricePerItem * $quantity) * ($tax + 1.0);
        };

        array_walk($this-&gt;products, $callback);
        return round($total, 2);
    }
}

$my_cart = new Cart;

// 往购物车里添加条目
$my_cart-&gt;add('butter', 1);
$my_cart-&gt;add('milk', 3);
$my_cart-&gt;add('eggs', 6);

// 打出出总价格，其中有 5% 的销售税.
print $my_cart-&gt;getTotal(0.05) . &quot;\n&quot;;
// The result is 54.29
?&gt;
```

 这里如果我们改造getTotal函数必然要使用到foreach

# 减少函数的参数

```
&lt;?php
function html($code, $id = &quot;&quot;, $class = &quot;&quot;) {
    if ($id !== &quot;&quot;) {
        $id = &quot; id = \&quot;$id\&quot;&quot;;
    }
    $class = ($class !== &quot;&quot;) ? &quot; class =\&quot;$class\&quot;&quot; : &quot;&gt;&quot;;
    $open = &quot;&lt;$code$id$class&quot;;
    $close = &quot;&lt;/$code&gt;&quot;;
    return function ($inner = &quot;&quot;) use ($open, $close) {
        return &quot;$open$inner$close&quot;;};
}
?&gt;
```

  如果是使用平时的方法，我们会把inner放到html函数参数中，这样不管是代码阅读还是使用都不如使用闭包

# 解除递归函数

```
&lt;?php

$fib = function ($n) use (&amp;$fib) {
    if ($n == 0 || $n == 1) {
        return 1;
    }

    return $fib($n - 1) + $fib($n - 2);
};

echo $fib(2) . &quot;\n&quot;; // 2
$lie = $fib;
$fib = function () {die('error');}; //rewrite $fib variable
echo $lie(5); // error because $fib is referenced by closure

?&gt;
```

  注意上题中的use使用了&amp;，这里不使用&amp;会出现错误fib(fib(n-1)是找不到function的（前面没有定义fib的类型）

  所以想使用闭包解除循环函数的时候就需要使用

```
&lt;?php
$recursive = function () use (&amp;$recursive) {
// The function is now available as $recursive
}
?&gt;
```

# 关于延迟绑定

  如果你需要延迟绑定use里面的变量，你就需要使用引用(&amp;)，否则在定义的时候就会做一份拷贝放到use中 //理解use(&amp;$var)

```php
&lt;?php

$result = 0;
$one = function () {
    var_dump($result);
};
$two = function () use ($result) {
    var_dump($result);
};
$three = function () use (&amp;$result) {
    var_dump($result);
};
$result++;
$one(); // outputs NULL: $result is not in scope
$two(); // outputs int(0): $result was copied
$three(); // outputs int(1)
```

  使用引用和不使用引用就代表了是调用时赋值，还是申明时候赋值