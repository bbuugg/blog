---
title: Go语言学习笔记
date: 2021-11-28 12:28:58
tags:
---

# 内置

Go 语言拥有一些不需要进行导入操作就可以使用的内置函数。它们有时可以针对不同的类型进行操作，例如：len、cap 和 append，或必须用于系统级的操作，例如：panic。因此，它们需要直接获得编译器的支持。

```
  append          -- 用来追加元素到数组、slice中,返回修改后的数组、slice
  close           -- 主要用来关闭channel
  delete            -- 从map中删除key对应的value
  panic            -- 停止常规的goroutine  （panic和recover：用来做错误处理）
  recover         -- 允许程序定义goroutine的panic动作
  real            -- 返回complex的实部   （complex、real imag：用于创建和操作复数）
  imag            -- 返回complex的虚部
  make            -- 用来分配内存，返回Type本身(只能应用于slice, map, channel)
  new                -- 用来分配内存，主要用来分配值类型，比如int、struct。返回指向Type的指针
  cap                -- capacity是容量的意思，用于返回某个类型的最大容量（只能用于切片和 map）
  copy            -- 用于复制和连接slice，返回复制的数目
  len                -- 来求长度，比如string、array、slice、map、channel ，返回长度
  print、println     -- 底层打印函数，在部署环境中建议使用 fmt 包
```

# go mod


- go mod help 查看帮助
- go mod init<项目模块名称>初始化模块，会在项目根目录下生成 go.mod 文件。
- go mod tidy 根据 go.mod 文件来处理依赖关系。
- go mod vendor 将依赖包复制到项目下的 vendor 目录。建议一些使用了被墙包的话可以这么处理，方便用户快速使用命令 go build -mod=vendor 编译
- go list -m all 显示依赖关系。go list -m -json all 显示详细依赖关系。
- go mod download 下载依赖。参数是非必写的，path 是包的路径，version 是包的版本。

# 数组切片

初始化数组的初始化有多种形式,

```go
[5] int {1,2,3,4,5}    //长度为5的数组，其元素值依次为：1，2，3，4，5
[5] int {1,2}          //长度为5的数组，其元素值依次为：1，2，0，0，0 。在初始化时没有指定初值的元素将会赋值为其元素类型int的默认值0,string的默认值是"" 
[...] int {1,2,3,4,5}  //长度为5的数组，其长度是根据初始化时指定的元素个数决定的 
[5] int { 2:1,3:2,4:3} //长度为5的数组，key:value,其元素值依次为：0，0，1，2，3。在初始化时指定了2，3，4索引中对应的值：1，2，3 
[...] int {2:1,4:3}    //长度为5的数组，起元素值依次为：0，0，1，0，3。由于指定了最大索引4对应的值3，根据初始化的元素个数确定其长度为5赋值与使用
```

数组的长度不可改变，在特定场景中这样的集合就不太适用，Go中提供了一种灵活，功能强悍的内置类型Slices切片(“动态数组"),与数组相比切片的长度是不固定的，可以追加元素，在追加时可能使切片的容量增大。切片中有两个概念：一是len长度，二是cap容量，长度是指已经被赋过值的最大下标+1，可通过内置函数len()获得。容量是指切片目前可容纳的最多元素个数，可通过内置函数cap()获得。切片是引用类型，因此在当传递切片时将引用同一指针，修改值将会影响其他的对象。

切片可以通过数组来初始化，也可以通过内置函数make()初始化 .初始化时len=cap,在追加元素时如果容量cap不足时将按len的2倍扩容

```go
s :=[] int {1,2,3 }           //直接初始化切片，[]表示是切片类型，{1,2,3}初始化值依次是1,2,3.其cap=len=3
s := arr[:]                   //初始化切片s,是数组arr的引用
s := arr[startIndex:endIndex] //将arr中从下标startIndex到endIndex-1 下的元素创建为一个新的切片
s := arr[startIndex:]         //缺省endIndex时将表示一直到arr的最后一个元素
s := arr[:endIndex]           //缺省startIndex时将表示从arr的第一个元素开始
s1 := s[startIndex:endIndex]  //通过切片s初始化切片s1
s :=make([]int,len,cap)       //通过内置函数make()初始化切片s,[]int 标识为其元素类型为int的切片
```

`slice`可以从一个数组或一个已经存在的`slice`中再次声明。`slice`通过`array[i:j]`来获取，其中`i`是数组的开始位置，`j`是结束位置，但不包含`array[j]`，它的长度是`j-i`。

注意`slice`和数组在声明时的区别：声明数组时，方括号内写明了数组的长度或使用`...`自动计算长度，而声明`slice`时，方括号内没有任何字符

切片是引用类型，在使用时需要注意其操作：

- 切片可以通过内置函数append(slice []Type,elems ...Type)追加元素，elems可以是一排type类型的数据，也可以是slice,因为追加的一个一个的元素，因此如果将一个slice追加到另一个slice中需要带上"..."，这样才能表示是将slice中的元素依次追加到另一个slice中。另外在通过下标访问元素时下标不能超过len大小，如同数组的下标不能超出len范围一样。

  ```
  s :=append(s,1,2,3,4)
  s :=append(s,s1...)
  ```

- `slice`的默认开始位置是0，`ar[:n]`等价于`ar[0:n]`

- `slice`的第二个序列默认是数组的长度，`ar[n:]`等价于`ar[n:len(ar)]`

- 如果从一个数组里面直接获取`slice`，可以这样`ar[:]`，因为默认第一个序列是0，第二个是数组的长度，即等价于`ar[0:len(ar)]`

`slice`是引用类型，所以当引用改变其中元素的值时，其它的所有引用都会改变该值，例如上面的`aSlice`和`bSlice`，如果修改了`aSlice`中元素的值，那么`bSlice`相对应的值也会改变。

### go get 和 go get -u 的区别

如题，区别如下：
加上它可以利用网络来更新已有的代码包及其依赖包。如果已经下载过一个代码包，但是这个代码包又有更新了，那么这时候可以直接用 -u 标记来更新本地的对应的代码包。如果不加这个 -u 标记，执行 go get 一个已有的代码包，会发现命令什么都不执行。只有加了 -u 标记，命令会去执行 git pull 命令拉取最新的代码包的最新版本，下载并安装。


### 其他

```
func main() {
 x := 0x12345678
 p := unsafe.Pointer(&x) // *int -> Pointer
 n := (*[4]byte)(p) // Pointer -> *[4]byte
 for i := 0; i < len(n); i++ {
 fmt.Printf("%X ", n[i])
 }
}
```

输出
```
78 56 34 12
```

IEEE754 NAN  f!=f

单引号字符常量表⽰ Unicode Code Point，⽀持 \uFFFF、\U7FFFFFFF、\xFF 格式。
对应 rune 类型，用for遍历是逐字节的for range遍历是字符

返回局部变量指针是安全的，编译器会根据需要将其分配在 GC Heap 上。
```
func test() *int {
 x := 100
 return &x // 在堆上分配 x 内存。但在内联时，也可能直接分配在⺫标栈。
}
```


将 Pointer 转换成 uintptr，可变相实现指针运算。
```
func main() {
 d := struct {
 s string
 x int
 }{"abc", 100}
p := uintptr(unsafe.Pointer(&d)) // *struct -> Pointer -> uintptr
 p += unsafe.Offsetof(d.x) // uintptr + offset
  p2 := unsafe.Pointer(p) // uintptr -> Pointer
 px := (*int)(p2) // Pointer -> *int
 *px = 200 // d.x = 200
 fmt.Printf("%#v\n", d)
}
```

输出：

```php
struct { s string; x int }{s:"abc", x:200}
```

注意：GC 把 uintptr 当成普通整数对象，它⽆法阻⽌ "关联" 对象被回收。

自定义类型

命名类型：bool、int、string
未命名类型： array、slice、map
目标类型是未命名类型会发生隐式转换否则必须显式转换，例如

```
type bigInt int64
var a bigInt = 12
var b int64 = a //报错 var b int64 = int64(a) 

type FooSlice []uint
var a FooSlice = FooSlice{1, 2, 3}
var b []uint = a  // 正常运行
```

运算符  ^取反

### 转换

```
func main() {
   var v int64 = 12              //默认10进制
   s2 := strconv.FormatInt(v, 2) //10 转2进制
   fmt.Printf("%v\n", s2)
 
   s8 := strconv.FormatInt(v, 8)
   fmt.Printf("%v\n", s8)
 
   s10 := strconv.FormatInt(v, 10)
   fmt.Printf("%v\n", s10)
 
   s16 := strconv.FormatInt(v, 16) //10 yo 16
   fmt.Printf("%v\n", s16)
 
   var sv = "11"
   fmt.Println(strconv.ParseInt(sv, 16, 32)) // 16 to 10
   fmt.Println(strconv.ParseInt(sv, 10, 32)) // 10 to 10
   fmt.Println(strconv.ParseInt(sv, 8, 32))  // 8 to 10
   fmt.Println(strconv.ParseInt(sv, 2, 32))  // 2 to 10
 
}
```

# 编码url

## 为什么需要编码和解码

1.是因为当字符串数据以url的形式传递给web服务器时,字符串中是不允许出现空格和特殊字符的；
2.因为 url 对字符有限制，比如把一个邮箱放入 url，就需要使用 urlencode 函数，因为 url 中不能包含 @ 字符；
3.url转义其实也只是为了符合url的规范而已。因为在标准的url规范中中文和很多的字符是不允许出现在url中的。

## 哪些字符是需要转化的呢？

### 1. ASCII 的控制字符

这些字符都是不可打印的，自然需要进行转化。

### 2. 一些非ASCII字符

这些字符自然是非法的字符范围。转化也是理所当然的了。

### 3. 一些保留字符

很明显最常见的就是“&”了，这个如果出现在url中了，那你认为是url中的一个字符呢，还是特殊的参数分割用的呢？

### 4. 就是一些不安全的字符了。

例如：空格。为了防止引起歧义，需要被转化为“+”。
明白了这些，也就知道了为什么需要转化了，而转化的规则也是很简单的。

按照每个字符对应的字符编码，不是符合我们范围的，统统的转化为%的形式也就是了。自然也是16进制的形式。

### 5.和字符编码无关

通过urlencode的转化规则和目的，我们也很容易的看出，urleocode是基于字符编码的。同样的一个汉字，不同的编码类型，肯定对应不同的urleocode的串。gbk编码的有gbk的encode结果。
apache等服务器，接受到字符串后，可以进行decode，但是还是无法解决编码的问题。编码问题，还是需要靠约定或者字符编码的判断解决。
因此，urleocode只是为了url中一些非ascii字符，可以正确无误的被传输，至于使用哪种编码，就不是encode所关心和解决的问题了。
编码问题，不是urlencode所要解决的。

## golang之UrlEncode编码/UrlDecode解码

```golang
package main

import(
    "fmt"
    "net/url"
)

func main()  {
    var urlStr string = "傻了吧:%:%@163& .html.html"
    escapeUrl := url.QueryEscape(urlStr)
    fmt.Println("编码:",escapeUrl)

    enEscapeUrl, _ := url.QueryUnescape(escapeUrl)
    fmt.Println("解码:",enEscapeUrl)
}

```

### 输出

编码: %E5%82%BB%E4%BA%86%E5%90%A7%3A%25%3A%25%40163%26+.html.html
解码: 傻了吧:%:%@163& .html.html

原文地址： [golang之UrlEncode编码/UrlDecode解码](https://www.cnblogs.com/haima/p/13442194.html)

# defer

Golang中的defer语句用于延迟函数的调用，每次 defer 都会把一个函数压入栈中，函数返回前再把延迟的函数取出并执行。Golang 中的 defer 可以帮助我们处理容易忽略的问题，如资源释放、连接关闭等。

关键字 return 不是一个原子操作，实际上 return 只代理汇编指令 ret，即将跳转程序执行。比如语句 return i，实际上分两步进行，即将 i 值存入栈中作为返回值，然后执行跳转，而 defer 的执行时机正是跳转前，所以说 defer 执行时还是有机会操作返回值的。



defer函数在return前执行

匿名返回值，返回字面量，不会被影响

```
func foo() int {
	i := 0
	defer func() {
		i++
	}()
	return i  // 0 匿名返回值
}
func gee() int {
	i := 0
	defer func() {
		i++
	}
	return 0 // 0 字面量
}
```

具名返回值，会被影响

```
func bar() (result int) {
	defer func() {
		result++
	}()
	return result // 1 这里return 0或者result都会返回1
}
```

## 判断文件是否存在

```
func FileExist(path string) bool {
  _, err := os.Lstat(path)  // Stat
  return !os.IsNotExist(err)
}
```

## 正则

- (re)           numbered capturing group
- (?P<name>re)   named & numbered capturing group
- (?:re)         non-capturing group
- (?flags)       set flags within current group; non-capturing
- (?flags:re)    set flags during re; non-capturing

> Flag syntax is xyz (set) or -xyz (clear) or xy-z (set xy, clear z). The flags are:

- i              case-insensitive (default false)
- m              multi-line mode: ^ and $ match begin/end line in addition to begin/end text (default false)
- s              let . match \
-  (default false)
- U              ungreedy: swap meaning of x* and x*?, x+ and x+?, etc (default false)

例如不区分大小写
```
r := regexp.MustCompile(`(?i)CaSe`)
```

# 交换顺序

```
a := 1
b := 2
a ^= b
b ^= a
a ^= b
```

```
a := 1
b := 2
a, b = b, a
```

# 获取正在运行的函数名

```
func getFuncName() string {
	pc, _, _, _ := runtime.Caller(1)
	return runtime.FuncForPC(pc).Name()
}
```

```
func getFuncName()string{
    pc := make([]uintptr,1)
    runtime.Callers(2,pc)
    f := runtime.FuncForPC(pc[0])
    return f.Name()
}
```

# 泛型
> go >= 1.18

```
type Number interface {
	uint | uint8 | uint16 | uint32 | uint64  # 联合类型
}

func sum[K comparable, V Number](s map[K]V) (sum uint64) {
	for _, value := range s {
		sum += uint64(value)
	}
	return
}

fmt.Println(sum[int, uint64](map[int]uint64{1: 1, 2: 3}))
```

> 为 K 类型参数指定类型约束 comparable。专门针对此类情况，comparable 在 Go 中预先声明了约束。它允许任何类型的值可以用作比较运算符 == 和的操作数 !=。Go 要求 map keys 具有可比性。所以声明 K as comparable 是必要的，这样你就可以 K 在 map 变量中用作键。它还确保调用代码对 map keys 使用允许的类型。