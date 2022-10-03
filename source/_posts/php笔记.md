---
title: PHP笔记
date: 2021-03-10 21:44:42
tags:
---

# 函数

1. iconv('charset in','charset out',$str); mb_convert_encoding($str,'charsetout','charsetin');

2. get_class_methods() 获取类方法，需要传递一个类名字符串 例如 People::class / 'People' ，get_class_vars() 获取类属性同上 。以上两个方法只能获取类中的public属性和方法。get_object_vars()

3. set_exception_handler()

<!-- more -->

4. ord() 返回字符串首个字符的ACSCII

5. array_fill() 填充数组，range() 生成一个范围的数组

6. json_encode($arr,JSON_UNESCAPED_UNICODE) #256 将unicode转为汉字

7. zip_open()

8. strpos 这类函数需要注意判断时候使用===false ,并且搜索值都要为字符串，数字要用引号

9. array_map($call,$arr) $call 只接受一个参数即数组的值 array_walk($arr,$call) $call接受两个参数即数组的值和键,preg_replace_callback() 这三个函数容易和闭包用在一起

10. pack()  unpack()

11. call_user_func() call_user_fuc_array()  第一个参数可以是数组形式的一个类/实例的方法，例如['test','eat'] 表示test类的eat方法，或者[$a,'eat']表示$a实例的eat方法

12. compact()  extract()从数组中将变量导入到符号表

13. php7新特性 $a??$b等同于isset($a) ? $a:$b,$a?:$b 等同于!empty($a) ? $a:$b

14. array_shift() array_pop() array_unshift() array_push()

15. array_merge_recursive() 不会对键进行覆盖而是相同键名递归组成一个数组

16. substr_count统计“子字符串”在“原始字符串中出现的次数

17. CLASS获取当前类名，get_class(对象)获取类名，get_called_class() 多用在继承的子类中获取主调类

    ```php
    public static function getInstance() {
            $class_name = get_called_class();
            if (isset(self::$instance[$class_name])) {
                return self::$instance[$class_name];
            }
            self::$instance[$class_name] = new $class_name;
            return self::$instance[$class_name];
        }
    ```

18. constant() 返回一个常量的值

19. abs()取得绝对值

20. str_pad() 填补奇数位则右边优先，sprintf(”%05d”,1) 右边补零5个， sprintf(”%01.3f”,1);用一个小数点后最少三位不足三位补零，小数点前最少一位，不足一位补零的浮点数格式化后边的参数，sprintf(format,arg1,arg2,arg++) 

21. php可变参数个数，或者使用func_get_args() func_get_arg() func_num_args()

    ```php
    <?php
    
    function test(...$a){
        return $a;
    }
    print_r(test(10,1,3));
    ```

22. strlen()计算的是字符串的总字节数，mb_strlen()计算字符个数；gbk中文1.5个（单个时占2个）；utf中文占1个字符（开启mbstring扩展，二是要指定字符集）。

23. http_build_query()函数的作用是使用给出的关联（或下标）数组生成一个经过 URL-encode 的请求字符串。

24. PHP中的ignore_user_abort函数是当用户关掉终端后脚本不停止仍然在执行，可以用它来实现计划任务与持续进程

25. eval()

26. unset() 引用变量时候会检查变量是否还存在引用，存在的话之销毁该变量而不销毁变量的值

27. realpath('..') dirname()  getcwd()  

28. session_set_cookie_params();

29. 获取header ：get_headers() ,$http_response_header ,stream_get_meta_data() ,curl扩展

30. ob_start()

    ```
    <?php
    
    ob_start();
    echo 'one';
    $data[] = ob_get_contents();
    ob_flush();
    echo 'two';
    $data[] = ob_get_contents();
    print_r($data);
    ```
31. quotemeta() 函数在字符串中某些预定义的字符前添加反斜杠。

预定义的字符：

- 句号（.）
- 反斜杠（\）
- 加号（+）
- 星号（*）
- 问号（?）
- 方括号（[]）
- 脱字号（^）
- 美元符号（$）
- 圆括号（()）

**提示：**该函数可用于转义拥有特殊意义的字符，比如 SQL 中的 ( )、[ ] 以及 * 。

**注释：**该函数是二进制安全的。
# 术语

1. 缓存控制中间件

2. 算力（也称哈希率）是比特币网络处理能力的度量单位。即为计算机（[CPU](https://baike.baidu.com/item/CPU/120556)）计算哈希函数输出的速度。比特币网络必须为了安全目的而进行密集的数学和加密相关操作。 例如，当网络达到10Th/s的哈希率时，意味着它可以每秒进行10万亿次计算。

3. 迭代是重复反馈过程的活动，其目的通常是为了逼近所需目标或结果。每一次对过程的重复称为一次“迭代”，而每一次迭代得到的结果会作为下一次迭代的初始值。

   重复执行一系列运算步骤，从前面的量依次求出后面的量的过程。此过程的每一次结果，都是由对前一次所得结果施行相同的运算步骤得到的。例如利用迭代法*求某一数学问题的解。

   对计算机特定程序中需要反复执行的子程序*(一组指令)，进行一次重复，即重复执行程序中的循环，直到满足某条件为止，亦称为迭代。（php迭代器）生成器是一个简单的迭代器

4. URI（Uniform Resource Identifier统一资源标识符）标识抽象或者物理资源的紧凑字符串

   URL（Uniform Resource Locator统一资源定位器）定位资源主要访问机制的字符串

   URN（Uniform Resource Name[统一资源名称）通过特定命名空间中的唯一名称或ID来标识资源

   例如：身份证号是URN,家庭地址就是URL。

5. 权重：一指某一因素或指标相对于某一事物的重要程度，其不同于一般的比重，体现的不仅仅是某一因素或指标所占的百分比，强调的是因素或指标的相对重要程度，倾向于贡献度或重要性。通常，权重可通过划分多个层次指标进行判断和计算，常用的方法包括层次分析法、模糊法、模糊层次分析法和专家评价法等；二指贡献度；三指权利、大权。

6. 汉字的ASCII

   汉字的ASCII是负数是因为你错误使用有符号的整型观察它，它实质上不是负数。

   相关问题细节如下：

   1. 英文标准的ASCII码中只有128个符号，只需要7位，但是计算机分配存储的最基本单位是字节，至少是8位，因此最高位为0；

   2. 因此常见的西文符号的ASCII都是在0-127之间，无论是有符号还是无符号去观察它们，都是正的。

   3. 中文的符号远超过256个，因此用一个字节不能存储汉字，早期的GB2312采用了两个字节。

   4. 但是很麻烦的问题是一个汉字用两个字节存储在计算机中后，和两个西文字母的ASCII混淆，为了避免这个混淆，汉字两个字节的最高位都是1。

   5. 如果用有符号的数去读取一个汉字的内容，最高位的1正好和负号位置相同，因此此时就会发现汉字的内吗是负的。

      实质上汉字应该用字符型而不是整型去读取和显示它。## 术语

# 其他
HttpOnly可选,设置了HttpOnly属性的cookie不能使用,JavaScript 经由Document.cookie属性,XMLHttpRequest和Request APIs进行访问，以防范跨站脚本攻击(xSS)。

1.如何设计一个高并发的系统
①数据库的优化，包括合理的事务隔离级别、SQL语句优化、索引的优化使用缓存，尽量减少数据库IO

考虑到当前的局限性，在MySQL 5.7的生存期内将继续支持查询缓存。MySQL 8.0将不支持查询缓存，并且鼓励用户升级以使用服务器端查询重写或ProxySQL作为中间人缓存。
[MySQL 8.0：不再支持查询缓存](https://mysqlserverteam.com/mysql-8-0-retiring-support-for-the-query-cache/)

分布式数据库、分布式缓存服务器的负载均衡

1. php如何实现保存网络图片（代码）

   ```php
   function file_exists_S3($url)
    {    
   $state = @file_get_contents($url,0,null,0,1);//获取网络资源的字符内容
   
       if($state){        
   
       $filename = date("dMYHis").'.jpg';//文件名称生成
   
           ob_start();//打开输出
   
           readfile($url);//输出图片文件
   
           $img = ob_get_contents();//得到浏览器输出
   
           ob_end_clean();//清除输出并关闭
   
           $size = strlen($img);//得到图片大小
   
           $fp2 = @fopen($filename, "a");        
   
           fwrite($fp2, $img);//向当前目录写入图片文件，并重新命名
   
           fclose($fp2);        
   
           return 1;
   
       } else{        
   
              return 0;
   
              }
   
       }
   ```

2. ASCII : 0 -> 48 A -> 65 a -> 97

3. 是一条错误的笔记

4. 在utf8mb4编码下英文占用1字节，一般汉字占用3字节， emoji表情占用4字节。可以使用length(字段)或者char_length(字段)查询长度

5. 优先级 算比逻条赋[赋值大于and|or]逗 

6. GD库1.6.2版以前支持GIF格式，但因GIF格式使用LZW演算法牵涉专利权，因此在GD1.6.2版之后不支持GIF的格式。如果你是WINDOWS的环境，你只要进入PHP.INI文件找到extension=php_gd2.dll，将#去除，重启APACHE即可，如果你是Linux环境，又想支持GIF，PNG，JPEG，你需要去[下载libpng](http://www.libpng.org/pub/png/libpng.html)，[zlib](http://www.zlib.net/)，以及[freetype字体](http://www.freetype.org/)并安装。

7. 一般视为无差，utc是以原子时计时，更加精准，适应现代社会的精确计时。不过一般使用不需要精确到秒时，视为等同。gmt是前世界标准时，utc是现世界标准时。每年格林尼治天文台会发调时信息，基于utc。格林尼治bai标准时间（GMT，旧译“格林威治平du均时间”或“zhi格林威治标准时间”）是指位于伦敦郊区的dao皇家格林尼治天文台的标准时间，因为本初子午线被定义在通过那里的经线。UTC表示世界协调时 GMT表示东八区，中国时区，协调世界时(UTC)  英文：Coordinated Universal Time ，别称：世界统一时间，世界标准时间，国际协调时间， 协调世界时，又称世界统一时间，世界标准时间，国际协调时间，简称UTC。它从英文“Coordinated Universal Time”／法文“Temps Universel Cordonné”而来。GMT（Greenwish Mean Time 格林威治平时），这是UTC的民间名称。GMT=UTC。

8. 短语运算符 $a > 0 && echo '\$a > 0';

9. 用ini_set修改session.save_handler要把 “session.auto_start = 1 改成 session.auto_start = 0 

10. 常量和变量的性能上的区别：简单数据类型如整数等，常量编译采用立即数方式，要快一点，也节约空间；变量采用间接寻址，慢一两个周期，需要额外空间。如果是复杂数据类型，例如字符串就差不多了。

11. 使用系统类需要加到根空间即\线，才能调用根空间的类。或者引入use \PDO,下面就可以不写斜线。异常类也需要加斜线或者引入，出错终止需要封锁运行

12. `self`调用静态方法时(本类)，是在子类未实例化调用之前就已经绑定完毕，所以原先在父类中指向的就是父类中的方法。而`static`是在实例化的时候才进行绑定指向的是此时实例化的类，也就是子类。

13. 计算机字长指的是计算机一次能处理的二进制数的位数，例如16，32，64位，这样的一个数称为一个字，类似的还有双字，多字。

14. 正数的原码法码和补码相同，负数的反码为原码除了符号位之外的数字取反之后加1，补码是为了让计算机更好的计算减法，同时统一符号位和整数位。

15. 在不开启 持久链接 PDO::ATTR_PERSISTENT  情况下脚本结束的时候会自动关闭连接

16. Heredoc :PHP定界符的作用就是按照原样，包括换行格式什么的，输出在其内部的东西；2.在PHP定界符中的任何特殊字符都不需要转义；3.PHP定界符中的PHP变量会被正常的用其值来替换。这个可以用来保存大段的文本比较有用。

    ```php
    echo <<<EOT
    	//内容
    EOT; //前面不能有任何空格或缩进
    ```

17. 静态局部变量的初始化是在编译时进行的，因此在程序开始执行的时候就始终存在，也就是说它的生命期为整个源程序，但是其作用域仍与自动变量相同。在定义时用常量或者常量表达式进行赋值。未赋值编译时系统自动赋值为0。静态局部变量具有可继承性。 

18. TP数据库操作，Db类插入数据的insert里第二个参数，传入ture，怎么做到有数据就更新，没有数据就插入

    replace into 跟 insert 功能类似，不同点在于：replace into 首先尝试插入数据到表中，如果发现表中已经有此行数据（根据主键或者唯一索引判断）则先删除此行数据，然后插入新的数据。 否则，直接插入新数据。
    要注意的是：插入数据的表必须有主键或者是唯一索引！否则的话，replace into 会直接插入数据，这将导致表中出现重复的数据。
	
## PHP静态类型变量的销毁

```php
<?php
class Teacher
{
    private static $_instance;
    private $_props = [];
    private function __construct(){}
    public function __destruct()
    {
       echo '666';
    }
    public static function getInstance()
    {
        if (empty(self::$_instance)) {
            self::$_instance = new self();
        }
        return self::$_instance;
    }
    public function setProperty($key, $val)
    {
        $this->_props[$key] = $val;
    }
    public function getProperty($key)
    {
        return $this->_props[$key];
    }
}
$t1 = Teacher::getInstance();
$t1->setProperty('name', 'lily');
unset($t1);
//var_dump($t1);
$t2 = Teacher::getInstance();
echo $t2->getProperty('name');
```

上例代码中虽然unset了$t1但是$t2仍能取到name的值。但如果不是单例模式是动态的对象存储时则不行。

如果在函数中 **unset()** 一个静态变量，那么在函数内部此静态变量将被销毁。但是，当再次调用此函数时，此静态变量将被复原为上次被销毁之前的值。来源：http://php.net/manual/zh/function.unset.php

所以，我们要注销一个静态变量，需要重新静态定义该变量为null。

参考如下 ：

```php
<?php
function test() {
    static $test;
    $test++;
    echo($test . " "); //1
    unset($test);
    $test = 2;
    echo($test . " ");  //2
}
test();
test();
test();
```

输出 ：1 2 2 2 3 2

因为每次定义static $test时被销毁的值被重新拿了回来并继续向下+1；而下方的$test在函数结束一次调用后即被销毁。

##获取文件格式码

```php
 $file = fopen($filename, "rb");
 $bin = fread($file, 2); //只读2字节
 fclose($file);
 $strInfo = @unpack("C2chars", $bin);
 $typeCode = intval($strInfo['chars1'].$strInfo['chars2']);
```

## bindParam和bindValue的区别

1.  PDOStatement::bindParam不能绑定常量，而bindValue可以绑定常量 如 $stm->bindParam(":sex",$sex); //正确  $stm->bindParam(":sex","female"); //错误  $stm->bindValue(":sex",$sex); //正确  $stm->bindValue(":sex","female"); //正确

1.  bindParam 变量被以引用方式绑定到点位符上,而且仅仅当调用PDOStatement::execute()时才会去计算具体被绑定变量在PDOStatement::execute()被调用时的值. 例如，使用bindParam方式：

bindColumn bindValue bindParam

bindparam只能传递引用，而bindvalue可以传递值或者引用

## sprintf()

参数 *format* 是转换的格式，以百分比符号 ("%") 开始到转换字符结束。下面的可能的 *format*值：

- %% - 返回百分比符号
- %b - 二进制数
- %c - 依照 ASCII 值的字符
- %d - 带符号十进制数
- %e - 可续计数法（比如 1.5e+3）
- %u - 无符号十进制数
- %f - 浮点数(local settings aware)
- %F - 浮点数(not local settings aware)
- %o - 八进制数
- %s - 字符串
- %x - 十六进制数（小写字母）
- %X - 十六进制数（大写字母）

arg1, arg2, ++ 等参数将插入到主字符串中的百分号 (%) 符号处。该函数是逐步执行的。在第一个 % 符号中，插入 arg1，在第二个 % 符号处，插入 arg2，依此类推。



```php
<?php   
$number = 123;
$txt = sprintf("%f",$number); 
echo $txt;
?> 
```


\3. 格式数字 number_format()

保留两位小数并且四舍五入

```php
$num = 123213.8889
echo sprintf("%.2f", $num);
```

   保留两位小数并且不四舍五入

```php
$num = 123213.666666;   
echo sprintf("%.2f",substr(sprintf("%.3f", $num), 0, -2));  
```

php进一法取整

```php
echo ceil(4.3);    // 5   
echo ceil(9.999);  // 10  
```

php舍去法，取整数

```php
echo floor(4.3);   // 4 
echo floor(9.999); // 9  
```

预定义接口

`Traversable` 可遍历接口
`Countable` 可count接口

### XSS

XSS又叫CSS（cross-site script）,跨站脚本攻击。恶意攻击者往Web页面里插入恶意html代码，当用户浏览该页时，嵌入其中Web里面的html代码会被执行，从而达到恶意用户的特殊目的

##### 办法：`htmlspecialchars()`

`htmlspecialchars()`把一些预定义的字符转换为html实体。

### PHP包含

#### include和require

include与require语句用于在执行流中插入卸载其他文件中的有用的代码。
include和require除了处理错误的方式不同之外，在其他地方都是相同的

- require生成一个致命错误(E_COMPILE_ERROR),在错误发生后脚本会停止执行
- include生成一个警告(E_WARNING)，在错误发生后脚本会继续执行

##### `include_once`及`require_once`只引入一次，且使用后失效，多次引入也只能使用一次

### Cookie

cookie常用于识别用户。是一种服务器留在用户计算机上的小文件，当同一台计算机通过浏览器请求页面时，这台计算机将会发送cookie
创建Cookie:`setcookie(name,value,expire,path,domain)`
取回cookie的值：`$_COOKIE`
使用 `isset()`函数确认是否已经设置了cookie

### Session

session变量用于存储关于用户会话(session)的信息，或者更改用户会话的设置。
session变量存储单一用户的信息，并对于应用程序中所有页面都是可用的。
session通过在服务器生存储用户信息以便随后使用，会话信息是临时的，在用户离开网站后将被删除。
session工作机制：为每个访客创建一个唯一的id（UID），并基于这个UID来存储变量。UID存储在cookie中，或者通过URL进行传导
开启session:`session_start()`
存储和获得session变量：`$_SESSION`
销毁session：`unset()`或者`session_destroy()`（session_destroy彻底重置session，将失去所有的session数据）

### 错误处理

#### 基本的错误处理:使用die()函数

#### 创建自定义错误处理器

语法：
`error_function(error_level,error_message,error_file,error_line,error_context)`

| 参数          | 描述                                                     |
| :------------ | :------------------------------------------------------- |
| error_level   | 必需。为用户定义的错误规定错误报告级别                   |
| error_message | 必需。为用户定义的错误规定错误消息                       |
| error_file    | 可选。规定错误发声的文件名                               |
| error_line    | 可选。规定错误发生的行号                                 |
| error_context | 可选。规定一个数组，包含了当错误发生时在用的每个变量和值 |

#### 设置错误处理程序

PHP的默认错误处理程序是内建的错误处理程序。可以修改错误处理程序，使其仅应用到某些错误，这样脚本就能以不同的方式处理不同的错误。
`set_error_handler(eorr_name,error_level)`

#### 错误记录

默认情况下，根据在php.ini中的error_log配置，使用error_log()函数，可以向指定文件或远程目的地发送错误记录

### Exception

异常处理用于在指定的错误发生时改变脚本的正常流程。
当异常发生时，通常会：

- 当前代码状态被保存
- 代码执行被切换到预定义（自定义）的异常处理器函数
- 根据情况，处理其也会从保存的代码状态重新开始执行代码，种植脚本执行，或从代码中另外的位置继续执行脚本

**注意**：异常应该仅仅在错误情况下使用，而不应该用在一个指定的点跳转到代码的另一个位置

### 过滤器

过滤器用于验证和过滤来自非安全来源的数据
测试、验证和过滤用户输入或自定义数据是任何Web应用程序的重要组成部分

#### 为什么使用过滤器？

几乎所有的Web应用程序都以来外部的输入。这些数据通常来自用户或其他应用程序。通过使用过滤器，能够保证应用程序获取正确的输入类型。
什么是外部数据？

- 来自表单的输入数据
- Cookies
- Web services data
- 服务器变量
- 数据库查询结果

#### 函数和过滤器

过滤变量，函数：

- `filter_var()`通过一个指定的过滤器来过滤单一的变量
- `filter_var_array()`通过相同或不同的顾虑其来过滤多个变量
- `filter_input`获取一个输入变量，并对它进行过滤
- `filter_input_array`获取多个输入变量，并通过相同的或不同的过滤器对它们进行过滤

#### Validating 和 Sanitizing

Validating过滤器：

- 用于验证用户输入
- 严格的格式规则
- 成功则返回预期的类型，否则返回false

Sanlitizing过滤器：

- 用于允许或禁止字符串中指定的字符
- 无数据格式规则
- 始终返回字符串

http://blog.kaiot.xyz/read/52.html