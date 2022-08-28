---
title: PHP中的反射
date: 2021-04-03 22:04:35
tags:
---

# PHP反射机制简单理解                     

什么是反射呢？

在PHP的面向对象编程中的对象，它被系统赋予自省的能力，而这个自省的过程，我们把它叫做反射。

我们对反射的直观理解可以是，根据达到地，找到出发地和来源这么一个过程，通俗来讲就是，我给你一个光秃秃的对象，完事你可以根据这个对象，知道它所属的类，拥有哪些方法。

在PHP中，反射是指在PHP运行状态中，扩展分析PHP程序，导出或者提取出关于类、属性、方法、参数等的详细信息，包括注释。这种动态获取信息以及动态调用对象方法的功能，被称为反射API。

我们接下来通过一段代码来感受下：

```
class person{
    public $name;
    public $age;
    public function say()
    {
    	echo $this-&gt;name.&quot;&lt;br&gt;&quot;.$this-&gt;age;
    }
    public function set($name,$value)
    {
        echo 'set name to value';
        $this-&gt;$name = $value;
    }
    public function get($name)
    {
        if(!isset($this-&gt;$name)){
            echo 'unset name';
            $this-&gt;$name = 'seting~~~';
        }
        return $this-&gt;$name;
    }
}

$stu = new person();
$stu-&gt;name = 'luyaran';
$stu-&gt;age = 26;
$stu-&gt;sex = 'girl';
```

上述代码是一个简单的类，我们通过实例化它，以及赋值，让它含有意义。

完事，我们就来通过反射API获取这个stu对象的方法和属性的一个列表：

```
//获取对象的属性列表
$reflect = new ReflectionObject($stu);
$props = $reflect-&gt;getProperties();
foreach ($props as $key_p =&gt; $value_p) {
    var_dump($value_p-&gt;getName());
}
//获取对象的方法列表
$method = $reflect-&gt;getMethods();
foreach ($method as $key_m =&gt; $value_m) {
    var_dump($value_m-&gt;getName());
}
```

除了反射API之外，我们还可以使用class函数来获取对象的各种属性以及方法的数据，如下：

```
// 获取对象的属性的关联数组
var_dump(get_object_vars($stu));
//获取类属性
var_dump(get_class_vars(get_class($stu)));
//获取类的方法名称组成的数组
var_dump(get_class_methods(get_class($stu)));
```

值得一说的是，这个get_class这个函数，还可以获取从其他页面传递过来的对象的属性列表以及所属的类。

不过，class函数和反射API相比较起来，个人感觉还是后者更胜一筹啊。

反射API甚至可以还原这个类的原型，包括方法的访问权限，来看代码感受下：

```
//实例化反射API获取类名
$obj = new ReflectionObject($stu);
$class_name = $obj-&gt;getName();
$method_arr = $props_arr = array();
//获取对象的属性列表
$props = $obj-&gt;getProperties();
foreach ($props as $key_p =&gt; $value_p) {
    $props_arr[$value_p-&gt;getName()] = $value_p;
}
//获取对象的方法列表
$method = $obj-&gt;getMethods();
foreach ($method as $key_m =&gt; $value_m) {
    $method_arr[$value_m-&gt;getName()] = $value_m;
} 
//格式化输出类的属性以及方法
echo &quot;class $class_name { \n&quot;;
is_array($props_arr) &amp;&amp; ksort($props_arr);
foreach ($props_arr as $key_o =&gt; $value_o) {
    echo &quot;\t&quot;;
    echo $value_o-&gt;isPublic() ? 'public' : ' ' ,$value_o-&gt;isPrivate() ? 'private' : ' ' ,$value_o-&gt;isProtected() ? 'protected' : ' ' ,$value_o-&gt;isStatic() ? 'static' : ' ';
    echo &quot;\t$value_o\n&quot;;
}
echo &quot;\n&quot;;
is_array($method_arr) &amp;&amp; ksort($method_arr);
foreach ($method_arr as $key_e =&gt; $value_e) {
    echo &quot;\t&quot;;
    echo $value_e-&gt;isPublic() ? 'public' : ' ' ,$value_e-&gt;isPrivate() ? 'private' : ' ' ,$value_e-&gt;isProtected() ? 'protected' : ' ';
    echo &quot;\tfunction $value_e () {} \n&quot;;
}
echo '}';
```

根据上述代码，输出结果如下： 

![](/upload/e651fd07c29c304a643dfd2c2e478a96.jpg)

我们可以看到，上图很详细的输出了这个类的构造。

不仅如此哦，PHP手册中关于反射API的数量，多达几十个，可以这么说，反射完整的描述了一个类或者对象的原型。

同时呢，反射不仅可以用作类和对象，还可以用于函数，扩展模块，异常等。

咱们呢，在这里就不赘述了，最后一点篇幅，就来聊聊反射的一些作用。

首先，它可以用作文档生成，所以，我们可以用它对文档中的类进行扫描，逐个生成扫描文档。

反射可以探知类的内部结构，也可以用作hook来实现插件功能，还有就是可以做动态代理。

咱们来看段MySQL的动态代理的代码感受下：

```
class mysql{
    public function connect($db_name)
    {
        echo &quot;we will connect database $db_name \r\n&quot;;
    }
}
class sql_proxy{
    private $target;
    public function __construct($tar)
	{
        $this-&gt;target = new $tar();
	}
    public function __call($name,$args)
    {
        $reflect = new ReflectionClass($this-&gt;target);
        $method = $reflect-&gt;getMethods();
        if ($method) {
            foreach ($method as $key_method =&gt; $value_method) {
                if($value_method-&gt;isPublic() &amp;&amp; !$value_method-&gt;isAbstract()){
                    echo &quot;方法前拦截记录LOG\r\n&quot;;
                    $value_method-&gt;invoke();
                    echo &quot;方法后拦截记录LOG\r\n&quot;;
                }
            }
        }
    }
}

$obj = new sql_proxy('mysql');
$obj-&gt;coonect('luyaran');
```

上述代码真正的操作类是mysql，下面的sql_proxy只是根据动态传入的参数，来代替了实际运行的类，并且可以在方法运行的前后进行拦截，还可以动态地改变类中的方法和属性，这个可以叫做简单的动态代理类。

在我们平常的开发中，用到反射的地方不多，一般是用来对对象进行调试，还有就是获取类的信息，但是在MVC和插件中，比较常见，并且反射的消耗也是不小的，我们在有另外一种方案的时候，尽量不要选择反射。

我们还可以通过PHP中的token函数来实现简单的反射功能，不过，从简单灵活的角度来看，还是使用已有的反射API比较好。

很多时候，善用某个东西，会使得我们的代码，简洁又优雅，但是不能贪多，比如这个反射API，用的多了，会破坏我们类的封装性，使得本不应该暴露的方法暴露了出来，这是优点也是缺点，我们要搞搞清楚。

好啦，本次记录就到这里了。

如果感觉不错的话，请多多点赞支持哦。。。





#PHP 反射的简单使用                     

##反射机制简介

1. 之前已经介绍过Java反射机制的简单使用，所有的反射机制的思想作用等都是类似的，下面就一起来了解一下PHP反射机制。
2. 个人理解：反射机制就是可以利用类名或者一个类的对象来获取关于这个类的一系列信息（类的变量，方法），然后又就可以利用得到的类的信息实例化一些类的对象
3. 官方给的简介：反射 API，有 对类、接口、函数、方法和扩展进行反向工程的能力。 此外，反射 API 提供了方法来取出函数、类和方法中的文档注释。
4. 一般在框架中使用到反射机制比较多（控制反转），正常情况下一般使用不到反射的

# 反射机制的使用

1. 常用的类

   1. ReflectionClass		通过类名获取类的信息
   2. ReflectionObject		通过类的对象获取类的信息

2. 代码，还以之前介绍Java反射的Worker类为例

   worker.php：

   ```
   &lt;?php
   
    class Worker{
       //工人的一些属性
       private $name_;
   	 private $age_;
       private $salary_;
   
       //构造方法
       public function __construct($name,$age,$salary){
           $this-&gt;name_ = $name;
           $this-&gt;age_ = $age;
           $this-&gt;salary_ = $salary;
       }
       //输出工人信息的方法
       public function show(){
           echo &quot;年龄&quot;.$this-&gt;salary_;
           echo &quot;姓名&quot;.$this-&gt;name_;
           echo &quot;工资&quot;.$this-&gt;salary_;
       }
   
       //__toString方法
       public function __toString(){
           return &quot;年龄：&quot;.$this-&gt;age.&quot;，姓名：&quot;.$this-&gt;name.&quot;工资：&quot;.$this-&gt;salary;
       }
   
   }		
   ```

   下面可以通过反射机制获取类的信息
    注 getObjectOfRuntimeClass.php 该文件和worker.php 在一个文件夹下

   ```
   &lt;?php
   	include 'worker.php';
   	//通过类名获取
   	$workClass_by_classname = new ReflectionClass('Worker');
   	
   	//通过类的实例对象获取
   	$w = new Worker(&quot;小明&quot;,20,20);
   	$workerClass_by_classinstance = new ReflectionObject($w);
   	
   	//因为ReflectionObject是ReflectionClass的子类，所以workClass_by_classname的方法，workerClass_by_classinstance同样适用
   	//下面利用workClass_by_classname对象获取类的一些属性
   	//获取类名
   	echo $workClass_by_classname-&gt;getName();
   	//获取类的方法列表
   	var_dump($workClass_by_classname-&gt;getMethods());
   	//获取类的属性
   	var_dump($workClass_by_classname-&gt;getProperties());
   	
   	//利用反射得到方法，并执行该方法
   	$worker = $workClass_by_classname-&gt;newInstance(&quot;小明&quot;,20,20);
   	$show_method = new ReflectionMethod('Worker','show');
   	$show_method-&gt;invoke($worker);
   	
   	//利用反射机制得到属性，并设置值
   	$property = $workClass_by_classname-&gt;getProperty('name_');
   	$property-&gt;setAccessible(true);
   	var_dump($property-&gt;getValue($worker));
   
   	$property-&gt;setValue($worker ,'小红');
   	var_dump($property-&gt;getValue($worker));
   		
   ```

   除了这些外，PHP反射还有其他的功能，具体可参考[PHP手册的反射部分](http://php.net/manual/zh/book.reflection.php)

#### PHP利用反射实现对象调用方法

```php
&lt;?php 
class Test {
    function phone() {
    	return '13888888888';
    }
    function user($name,$sex) {
    	return '我是'.$name.',性别'.$sex;
    }
}
//调用phone方法
$obj = new Test;
$med = new ReflectionMethod($obj,'phone');
echo $med-&gt;invoke($obj);
echo '&lt;hr/&gt;';
//调用user方法
$obj2 = new Test;
$med2 = new ReflectionMethod($obj2,'user');
echo $med2-&gt;invokeArgs($obj2,array('lws','男')); 
```