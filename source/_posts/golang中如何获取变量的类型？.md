---
title: golang中如何获取变量的类型？
date: 2021-05-29 15:39:42
tags:
---

在golang中并没有提供内置函数来获取变量的类型，但是通过一定的方式也可以获取，下面提供两种思路

<!-- more -->

# 通过格式化

使用格式化字符%T(注意为大写的T)便可以获取到对应的类型

```go
package main

import (
	&quot;fmt&quot;
)

func main(){
	var v int = 64
	fmt.Printf(&quot;v的值为: %v, v的类型为: %T\n&quot;, v, v)
	// 如果想要保存类型到字符串中，可以使用
	typ := fmt.Sprintf(&quot;%T&quot;, v)
}

```

# 通过反射机制

reflect包中提供了相应的手段

```go
package main

import (
	&quot;fmt&quot;
	&quot;reflect&quot;
)

func main(){
	var v int = 64
	fmt.Println(reflect.TypeOf(v))
}
```