---
title: Golang fmt.Scan获取命令行输入（八）｜Go主题月
date: 2022-06-14 09:58:22
tags:
---

Golang 本身十分轻量级，运行效率极高，同时对并发编程有着原生的支持，从而能更好的利用多核处理器。 这使得Golang对微服务开发具有先天的优势

常见的程序触发形式有`api 调用`，`命令行执行`。而在命令行执行中，用户输入执行参数的获取至关重要。 下面就来详细讲一讲

Golang 语言`fmt`包下有`fmt.Scan`、`fmt.Scanf`、`fmt.Scanln`三个函数，可以在程序运行过程中从标准输入获取用户的输入。

## fmt.Scan

函数调用语法：

> func Scan(a ...interface{}) (n int, err error)

- `Scan` 从命令行输入扫描文本，读取由`空白符分隔`的值 传递到本`函数参数`中，换行符视为空白符。
- 函数返回`成功扫描数据个数`和`执行遇到的任何错误`。如果读取的数据个数比参数少，会抛出错误。

具体代码示例如下：

```go
func main() {
    var (
        name    string
        age     int
        is_marry bool
    )
    
    fmt.Scan(&name, &age, &is_marry)
    fmt.Printf("获取结果 name:%s age:%d is_marry:%t \n", name, age, is_marry)
}
复制代码
```

将上面的代码编译后在终端执行，在终端依次输入`韩韩、18、false`使用空格分隔。

```md
$ ./scan_demo 
韩韩 18 false
获取结果 name:韩韩 age:18 is_marry:false
复制代码
```

fmt.Scan从命令行输入中扫描用户输入的数据，将以空白符分隔的数据分别存入指定的参数。

## fmt.Scanf

函数调用语法：

> func Scanf(format string, a ...interface{}) (n int, err error)

- `Scanf` 从命令行输入扫描文本，根据 `format参数` 指定格式去读取由 `空白符分隔的值` 保存到传递给本函数参数中。
- 函数返回`成功扫描数据个数`和`执行遇到的任何错误`。

代码示例如下：

```go
func main() {
    var (
        name    string
        age     int
        is_marry bool
    )
    
    fmt.Scanf("1:%s 2:%d 3:%t", &name, &age, &is_marry)
    fmt.Printf("扫描结果 name:%s age:%d is_marry:%t \n", name, age, is_marry)
}
复制代码
```

将上面代码编译执行后，在终端按照指定的格式依次输入 韩韩、18、false。

```md
$ ./scan_demo 
1:韩韩 2:18 3:false
获取结果 name:韩韩 age:18 is_marry:false
复制代码
```

fmt.Scanf不同于fmt.Scan简单的以空格作为输入数据的分隔符，fmt.Scanf为输入数据指定了具体的输入内容格式，只有按照格式输入数据才会被扫描并存入对应变量。

## fmt.Scanln

函数调用语法：

> func Scanln(a ...interface{}) (n int, err error)

- Scanln类似Scan，它在遇到换行时才停止扫描。最后一个数据后面必须有换行或者到达结束位置。
- 函数返回`成功扫描数据个数`和`执行遇到的任何错误`。

具体代码示例如下：

```go
    func main() {
        var (
            name    string
            age     int
            is_marry bool
        )
        fmt.Scanln(&name, &age, &is_marry)
        fmt.Printf("获取结果 name:%s age:%d is_marry:%t \n", name, age, is_marry)
    }
复制代码
```

将上面代码编译执行后，在终端依次输入韩韩、18、false使用空格分隔。

```md
$ ./scan_demo 
韩韩 18 false
获取结果 name:韩韩 age:18 is_marry:false
复制代码
```

fmt.Scanln遇到回车就结束扫描了，这个比较常用。

## Fscan系列

函数功能分别对应上述 `fmt.Scan、fmt.Scanf、fmt.Scanln` 函数， 只不过它们`并不从命令行`输入中读取数据而是从`io.Reader`中读取数据。

```go
func Fscan(r io.Reader, a ...interface{}) (n int, err error)
func Fscanln(r io.Reader, a ...interface{}) (n int, err error)
func Fscanf(r io.Reader, format string, a ...interface{}) (n int, err error)
复制代码
```

## Sscan系列

函数功能分别对应上述 `fmt.Scan、fmt.Scanf、fmt.Scanln` 函数， 只不过它们`并不从命令行`输入中读取数据而是从 `指定字符串` 中读取数据。

```go
func Sscan(str string, a ...interface{}) (n int, err error)
func Sscanln(str string, a ...interface{}) (n int, err error)
func Sscanf(str string, format string, a ...interface{}) (n int, err error)
```


作者：锐玩道
链接：https://juejin.cn/post/6945631500335480839
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。