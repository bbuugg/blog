---
title: PHP 7.4的新增特性（功能，弃用，速度）
date: 2020-09-12 21:23:17
tags:
---

&gt; 原文链接：[https://www.ffeeii.com/1075.html](https://link.zhihu.com/?target=https%3A//www.ffeeii.com/1075.html)

下一个PHP 7里程版本PHP 7.4预计将于2019年11月28日正式发布。因此，现在该让我们深入研究一些最令人兴奋的新增功能和新功能，这些功能将使PHP更快，更可靠。 。

实际上，即使PHP 7.4显着提高了性能并提高了代码的可读性，PHP 8仍将是PHP性能的真正里程碑，因为JIT包含的建议已得到批准。

无论如何，今天我们正在经历一些我们期望的PHP 7.4最有趣的功能和更改。 因此，在阅读这篇文章之前，请确保保存以下日期：

&gt; 6月6日：PHP 7.4 Alpha 1
&gt; 7月18日：PHP 7.4 Beta 1 –功能冻结
&gt; 11月28日：PHP 7.4 GA发布

您可以在[RFC官方页面](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc%23php_74)上查看功能和添加项的完整列表。


**PHP 7.4发布日期：**
PHP 7.4计划于2019年11月28日发布。它是下一个PHP 7次要版本，应再次提高性能并提高代码的可读性/可维护性。

# PHP 7.4中的PHP有何新功能？

在本文中，我们讨论了PHP 7.4最终版本中应在语言中添加的一些更改和功能：

- 支持数组内解包 – 数组扩展Spread运算符
- 箭头函数 2.0 (更加简短的闭包)
- NULL 合并运算符
- 弱引用
- 协变返回和逆变参数
- 预加载
- 新的自定义对象序列化机制

## 数组表达式中引入 Spread 运算符…

自 PHP 5.6 起可用，[参数解包](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/argument_unpacking)是将数组和 [Traversable](https://link.zhihu.com/?target=https%3A//www.php.net/manual/en/class.traversable.php) 解包为参数列表的语法。要解压一个数组或 Traversable，必须以 …（3 点）为前缀，如下例所示：

```text
function test(...$args) { var_dump($args); }
test(1, 2, 3);
```

然而 [PHP 7.4 RFC](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/spread_operator_for_array) 建议将此功能扩展到数组中去定义：

```text
$arr = [...$args];
```

**Spread 运算符**的第一个好处就是性能，[RPC 文档指出](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/spread_operator_for_array):

&gt; Spread 运算符应该比 `array_merge` 拥有更好的性能。这不仅仅是 Spread 运算符是一个语法结构，而 `array_merge` 是一个方法。还是在编译时，优化了高效率的常量数组

Spread 运算符的一个显着优点是它支持任何可遍历的对象，而该 `array_merge` 函数仅支持数组。以下是数组中参数带有 Spread 运算符的示例：

```text
$parts = ['apple', 'pear'];
$fruits = ['banana', 'orange', ...$parts, 'watermelon'];
var_dump($fruits);
```

如果在 PHP 7.3 或更早版本中运行此代码，PHP 会抛出一个 Parse 错误：

```text
Parse error: syntax error, unexpected '...' (T_ELLIPSIS), expecting ']' in /app/spread-operator.php on line 3
```

相反，PHP 7.4 将返回一个数组

```text
array(5) {
    [0]=&gt;
    string(6) &quot;banana&quot;
    [1]=&gt;
    string(6) &quot;orange&quot;
    [2]=&gt;
    string(5) &quot;apple&quot;
    [3]=&gt;
    string(4) &quot;pear&quot;
    [4]=&gt;
    string(10) &quot;watermelon&quot;
  }
```

RFC 声明我们可以多次扩展同一个数组。此外，我们可以在数组中的任何位置使用 Spread Operator 语法，因为可以在 spread 运算符之前或之后添加常规元素。因此，以下代码将按预期工作：

```text
$arr1 = [1, 2, 3];
$arr2 = [4, 5, 6];
$arr3 = [...$arr1, ...$arr2];
$arr4 = [...$arr1, ...$arr3, 7, 8, 9];
```

也可以将函数返回的数组作为参数，放到新数组中：

```text
function buildArray(){
    return ['red', 'green', 'blue'];
}
$arr1 = [...buildArray(), 'pink', 'violet', 'yellow'];
```

PHP 7.4 输出以下数组：

```text
array(6) {
    [0]=&gt;
    string(3) &quot;red&quot;
    [1]=&gt;
    string(5) &quot;green&quot;
    [2]=&gt;
    string(4) &quot;blue&quot;
    [3]=&gt;
    string(4) &quot;pink&quot;
    [4]=&gt;
    string(6) &quot;violet&quot;
    [5]=&gt;
    string(6) &quot;yellow&quot;
}
```

我们也可以使用[生成器](https://link.zhihu.com/?target=https%3A//www.php.net/manual/en/language.generators.syntax.php)：

```text
function generator() {
    for ($i = 3; $i &lt;= 5; $i++) {
        yield $i;
    }
  }
  $arr1 = [0, 1, 2, ...generator()];
```

但不允许通过引用传递的方式。请考虑以下示例：

```text
$arr1 = ['red', 'green', 'blue'];
$arr2 = [...&amp;$arr1];
```

如果我们尝试通过传递引用的方式，PHP 会抛出以下 Parse 错误：

```text
Parse error: syntax error, unexpected '&amp;' in /app/spread-operator.php on line 3
```

如果第一个数组的元素是通过引用存储的，那么它们也通过引用存储在第二个数组中。这是一个例子：

```text
$arr0 = 'red';
  $arr1 = [&amp;$arr0, 'green', 'blue'];
  $arr2 = ['white', ...$arr1, 'black'];
```

这是我们用 PHP 7.4 获得的：

```text
array(5) {
    [0]=&gt;
    string(5) &quot;white&quot;
    [1]=&gt;
    &amp;string(3) &quot;red&quot;
    [2]=&gt;
    string(5) &quot;green&quot;
    [3]=&gt;
    string(4) &quot;blue&quot;
    [4]=&gt;
    string(5) &quot;black&quot;
  }
```

## **箭头函数 2.0 (简短闭包)**

在 PHP 中，匿名函数被认为是非常冗长且难以实现和难以维护的，[RFC](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/arrow_functions_v2) 建议引入更简单，更清晰的箭头函数（或简短闭包）语法，这样我们就可以简洁地编写代码。在 PHP 7.4 以前：

```text
function cube($n){
    return ($n * $n * $n);
  }
  $a = [1, 2, 3, 4, 5];
  $b = array_map('cube', $a);
  print_r($b);
```

PHP 7.4 允许使用更简洁的语法，上面的函数可以重写如下：

```text
$a = [1, 2, 3, 4, 5];
  $b = array_map(fn($n) =&gt; $n * $n * $n, $a);
  print_r($b);
```

目前，由于语言结构，[匿名函数](https://link.zhihu.com/?target=https%3A//www.php.net/manual/en/functions.anonymous.php)（闭包）可以使用 `use` 继承父作用域中定义的变量，如下所示：

```text
$factor = 10;
  $calc = function($num) use($factor){
    return $num * $factor;
  };
```

但是在 PHP 7.4 中，父级作用域的值是通过隐式捕获的（隐式按值的作用域进行绑定）。所以我们可以用一行来完成一下这个函数

```text
$factor = 10;
  $calc = fn($num) =&gt; $num * $factor;
```

父级作用域定义的变量可以用于箭头函数，它跟我们使用 `use` 是等价的，并且不可能被父级所修改。新语法是对语言的一个很大改进，因为它允许我们构建更易读和可维护的代码。

## NULL 合并运算符

&gt; 由于日常使用中存在大量同时使用三元表达式和 isset () 的情况， 我们添加了 null 合并运算符 (??) 这个语法糖。如果变量存在且值不为 NULL， 它就会返回自身的值，否则返回它的第二个操作数。

```text
$username = $_GET['user'] ?? ‘nobody';
```

这段代码的作用非常简单：**它获取请求参数并设置默认值（如果它不存在）**。但是在 RFC 这个例子中，如果我们有更长的变量名称呢？

```text
$this-&gt;request-&gt;data['comments']['user_id'] = $this-&gt;request-&gt;data['comments']['user_id'] ?? 'value';
```

长远来看，这段代码可能难以维护。因此，旨在帮助开发人员编写更直观的代码，[这个 RFC](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/null_coalesce_equal_operator) 建议引入 null 合并等于运算符 (null_coalesce_equal_operator)`??=`，所以我们可以敲下面这段代码来替代上面的这段代码：

```text
$this-&gt;request-&gt;data['comments']['user_id'] ??= ‘value’;
```

如果左侧参数的值为 `null`，则使用右侧参数的值。

注意，虽然 coalesce 运算符 `??` 是一个比较运算符，但 `??=` 它是赋值运算符。

## 类型属性 2.0

类型的声明，类型提示，以及指定确定类型的变量传递给函数或类的方法。其中类型提示是在 [PHP5](https://link.zhihu.com/?target=https%3A//www.php.net/manual/en/functions.returning-values.php%23functions.returning-values.type-declaration) 的时候有的一个功能，PHP 7.2 的时候添加了 `object` 的数据类型。而 PHP7.4 更是增加了[主类属性声明](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/typed_properties_v2)，看下面的例子：

```text
class User {
    public int $id;
    public string $name;
  }
```

除了 `void` 和 `callable` 外，所有的类型都支持

```text
public int $scalarType;
  protected ClassName $classType;
  private ?ClassName $nullableClassType;
```

为什么不支持 `void` 和 `callable`？下面是 RFC 的解释

&gt; The `void` type is not supported, because it is not useful and has unclear semantics.
&gt; 不支持 `void` 类型，是因为它没用，并且语义不清晰。
&gt; The `callable` type is not supported, because its behavior is context dependent.
&gt; 不支持 `callable` 类型，因为其行为取决于上下文。

因此，我们可以放心使用 `bool`，`int`，`float`，`string`，`array`，`object`，`iterable`，`self`，`parent`，当然还有我们很少使用的 `&quot;https://wiki.php.net/rfc/nullable_types&quot;&gt;nullable 空允许 (?type)`

所以你可以在 PHP7.4 中这样敲代码：

```text
// 静态属性的类型
  public static iterable $staticProp;

  // var 中声明属性
  var bool $flagl

  // 设置默认的值
  // 注意，只有 nullable 的类型，才能设置默认值为 null
  public string $str = &quot;foo&quot;;
  public ?string $nullableStr = null;

  // 多个同类型变量的声明
  public float $x, $y;
```

如果我们传递不符合给定类型的变量，会发生什么？

```text
class User {
    public int $id;
    public string $name;
  }

  $user = new User;
  $user-&gt;id = 10;
  $user-&gt;name = [];

  // 这个会产生一个致命的错误
  Fatal error: Uncaught TypeError: Typed property User::$name must be string, array used in /app/types.php:9
```

## 弱引用

在这个 [RFC](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/weakrefs) 中，提议引入 `WeakReference` 这个类，弱引用允许编码时保留对对象的引用，该引用不会阻止对象被破坏；这对于实现类似于缓存的结构非常有用。

该提案的作者 [Nikita Popov](https://link.zhihu.com/?target=http%3A//slideshare.net/nikita_ppv/typed-properties-and-more-whats-coming-in-php-74) 给出的一个例子：

```text
$object = new stdClass;
  $weakRef = WeakReference::create($object);

  var_dump($weakRef-&gt;get());
  unset($object);
  var_dump($weakRef-&gt;get());

  // 第一次 var_dump
  object(stdClass)#1 (0) {}

  // 第二次 var_dump，当 object 被销毁的时候，并不会抛出致命错误
  NULL
```

## 协变返回和逆变参数

[协变和逆变](https://link.zhihu.com/?target=https%3A//zh.wikipedia.org/wiki/%E5%8D%8F%E5%8F%98%E4%B8%8E%E9%80%86%E5%8F%98)
[百度百科的解释](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/%E5%8D%8F%E5%8F%98)

- Invariant (不变): 包好了所有需求类型
- Covariant (协变)：类型从通用到具体
- Contravariant (逆变): 类型从具体到通用目前，PHP 主要具有 `Invariant` 的参数类型，并且大多数是 `Invariant` 的返回类型，这就意味着当我是 T 参数类型或者返回类型时，子类也必须是 T 的参数类型或者返回类型。但是往往会需要处理一些特殊情况，比如具体的返回类型，或者通用的输入类型。而 [RFC](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/covariant-returns-and-contravariant-parameters) 的这个提案就提议，PHP7.4 添加协变返回和逆变参数，以下是提案给出来的例子：协变返回：

```text
interface Factory {
  function make(): object;
}

class UserFactory implements Factory {
  // 将比较泛的 object 类型，具体到 User 类型
 function make(): User;
}
```

逆变参数：

```text
interface Concatable {
  function concat(Iterator $input); 
}

class Collection implements Concatable {
  // 将比较具体的 `Iterator`参数类型，逆变成接受所有的 `iterable`类型
  function concat(iterable $input) {/* . . . */}
}
```

## 预加载

这个 [RFC](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/preload) 是由 Dmitry Stogov 提出的，预加载是在模块初始化的时候，将库和框架加载到 OPCache 中的过程，如下图所示

![img](https://pic2.zhimg.com/80/v2-6ef99c040791298da64203434edf6aaa_720w.jpg)

引用他的原话：

&gt; On server startup – before any application code is run – we may load a certain set of PHP files into memory – and make their contents “permanently available” to all subsequent requests that will be served by that server. All the functions and classes defined in these files will be available to requests out of the box, exactly like internal entities.
&gt; 服务器启动时 – 在运行任何应用程序代码之前 – 我们可以将一组 PHP 文件加载到内存中 – 并使得这些预加载的内容，在后续的所有请求中 “永久可用”。这些文件中定义的所有函数和类在请求时，就可以开箱即用，与内置函数相同。

预加载由 `php.ini` 的 `opcache.preload` 进行控制。这个参数指定在服务器启动时编译和执行的 PHP 脚本。此文件可用于预加载其他文件，或通过 `opcache_compile_file() 函数`

这在性能上有很大的提升，但是也有一个很明显的缺点，RFC 提出来了

&gt; preloaded files remain cached in opcache memory forever. Modification of their corresponding source files won’t have any effect without another server restart.
&gt; 预加载的文件会被永久缓存在 opcache 内存中。在修改相应的源文件时，如果没有重启服务，修改就不会生效。

## 新的自定义对象序列化机制

这是尼基塔·波波夫（Nikita Popov）的[另一项建议](https://link.zhihu.com/?target=https%3A//nikic.github.io/aboutMe.html) ，得到了绝大多数票的批准。

当前，我们有两种不同的机制可以在PHP中对对象进行自定义序列化：

- `__sleep()`和`__wakeup()`魔术方法
- 可`Serializable`接口

根据Nikita的说法，这两个选项都存在导致复杂且不可靠的代码的问题。 您可以在[RFC](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/custom_object_serialization)[中](https://link.zhihu.com/?target=https%3A//translate.googleusercontent.com/translate_c%3Fdepth%3D1%26rurl%3Dtranslate.google.com.hk%26sl%3Dauto%26sp%3Dnmt4%26tl%3Dzh-CN%26u%3Dhttps%3A//wiki.php.net/rfc/custom_object_serialization%26xid%3D17259%2C15700021%2C15700043%2C15700186%2C15700191%2C15700256%2C15700259%2C15700262%2C15700265%2C15700271%26usg%3DALkJrhhkhsvjxsW3I8740AMUhHLsZa83MQ)深入研究此主题。 在这里，我只提到新的序列化机制应该通过提供两个结合了两个现有机制的新魔术方法`__serialize()`和`__unserialize()`来防止这些问题。

该提案以20票对7票获得通过。

# PHP7.4 又将废弃什么功能呢？

## 更改连接运算符的优先级

目前，在 PHP 中 `+` , `-` 算术运算符和 `.` 字符串运算符是左关联的， 而且它们具有相同的优先级。例如：

```text
echo &quot;sum: &quot; . $a + $b;
```

在 PHP 7.3 中，此代码生成以下警告：

```text
Warning: A non-numeric value encountered in /app/types.php on line 4
```

这是因为这段代码是从左往右开始的，所以等同于：

```text
echo (&quot;$sum: &quot; . $a) + $b;
```

针对这个问题，[这个 RFC](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/concatenation_precedence) 建议更改运算符的优先级，使 `.` 的优先级低于 `+` ，`-` 这两个运算符，以便在字符串拼接之前始终执行加减法。所以这行代码应该等同于以下内容：

```text
  echo &quot;$sum: &quot; . ($a + $b);
```

这个提案分为两步走：

- 从 PHP7.4 开始，当遇见 `+``-` 和 `.` 在没有指明执行优先级时，会发出一个弃用通知。
- 而真正调整优先级的这个功能，会在 PHP8 中执行弃用左关联三元运算符在 PHP 中，三元运算符与许多其他语言不同，它是左关联的。而根据 Nikita Popof 的所说：对于在不同语言之间切换的编程人员来说，会令他们感到困扰。比如以下的例子，在 PHP 中是正确的：`$b = $a == 1 ? 'one' : $a == 2 ? 'two' : $a == 3 ? 'three' : 'other';`它会被解释为：`$b = (($a == 1 ? 'one' : $a == 2) ? 'two' : $a == 3) ? 'three' : 'other';`对于这种复杂的三元表现形式，它很有可能不是我们希望的方式去工作，容易造成错误。因此，[这个 RFC](https://link.zhihu.com/?target=https%3A//wiki.php.net/rfc/ternary_associativity) 提议删除并弃用三元运算符的左关联使用，强制编程人员使用括号。这个提议分为两步执行：
- 从 PHP7.4 开始，没有明确使用括号的嵌套三元组将抛出弃用警告。
- 从 PHP 8.0 开始，将出现编译运行时错误。

# php7.4性能

出于对PHP 7.4的Alpha预览版性能状态的好奇，我今天针对使用Git构建的PHP 7.3.6、7.2.18、7.1.29和7.0.32运行了一些快速基准测试，并且每个发行版均以相同的方式构建。

![img](https://pic1.zhimg.com/80/v2-4162b3878e8891154c4b1aad2f17c6f0_720w.jpg)

在此阶段，PHPBench的7.4性能与PHP 7.3稳定版相当，已经比PHP 7.0快了约30％…当然，与PHP 5.5的旧时代相比，收益甚至更大。

![img](https://picb.zhimg.com/80/v2-92c0f270e71fe21ce55828a0b95f095a_720w.jpg)

在微基准测试中，PHP 7.4的运行速度仅比PHP 7.3快一点，而PHP-8.0的性能却差不多，至少要等到JIT代码稳定下来并默认打开为止。

![img](https://picb.zhimg.com/80/v2-e80458d4005811eae62dc39a14c0910e_720w.jpg)

在Phoronix测试套件的内部PHP自基准测试中，PHP 7.4的确确实处于PHP 7.3性能水平之上-至少在此Alpha前状态下。 自PHP 7.0起，取得了一些显着的进步，而自PHP5发行缓慢以来，也取得了许多进步。