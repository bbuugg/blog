---
title: Golang 通道(channel)
date: 2022-06-26 10:24:51
tags:
---

单纯地将函数并发执行是没有意义的。函数与函数间需要交换数据才能体现并发执行函数的意义。

虽然可以使用共享内存进行数据交换，但是共享内存在不同的goroutine中容易发生竞态问题。为了保证数据交换的正确性，必须使用互斥量对内存进行加锁，这种做法势必造成性能问题。

Go语言的并发模型是CSP（Communicating Sequential Processes），提倡通过通信共享内存而不是通过共享内存而实现通信。

如果说goroutine是Go程序并发的执行体，channel就是它们之间的连接。channel是可以让一个goroutine发送特定值到另一个goroutine的通信机制。

Go 语言中的通道（channel）是一种特殊的类型。通道像一个传送带或者队列，总是遵循先入先出（First In First Out）的规则，保证收发数据的顺序。每一个通道都是一个具体类型的导管，也就是声明channel的时候需要为其指定元素类型。



# 操作通道

## 创建channel

```
var ch chan int
make(chan 元素类型, [缓冲大小])
```

例如

```
ch := make(chan uint8, 1)
```

我们在将一个 channel 变量传递到一个函数时，可以通过将其指定为单向 channel 变量，从而限制该函数中可以对此 channel 的操作，比如只能往这个 channel 中写入数据，或者只能从这个 channel 读取数据。

> 可以使用len,cap获取通道内元素数量和容量

## 无缓冲通道

```
ch := make(chan bool) 
```

无缓冲通道也叫阻塞通道，同步通道，无缓冲的通道只有在有接收值的时候才能发送值，无缓冲通道上的发送操作会阻塞，直到另一个goroutine在该通道上执行接收操作，这时值才能发送成功，两个goroutine将继续执行。相反，如果接收操作先执行，接收方的goroutine将阻塞，直到另一个goroutine在该通道上发送一个值。使用无缓冲通道进行通信将导致发送和接收的goroutine同步化

## 单向通道

单向 channel 变量的声明非常简单，只能写入数据的通道类型为`chan<-`，只能读取数据的通道类型为`<-chan`，格式如下：

```
var 通道实例 chan<- 元素类型   // 只能写入数据的通道
var 通道实例 <-chan 元素类型   // 只能读取数据的通道
```

- 元素类型：通道包含的元素类型。
- 通道实例：声明的通道变量。

### time包中的单向通道

time 包中的计时器会返回一个 timer 实例，代码如下：

```
timer := time.NewTimer(time.Second)
```

timer的Timer类型定义如下：

```
type Timer struct { 
	C <-chan Time   
    r runtimeTimer
}
```

第 2 行中 C 通道的类型就是一种只能读取的单向通道。如果此处不进行通道方向约束，一旦外部向通道写入数据，将会造成其他使用到计时器的地方逻辑产生混乱。

因此，单向通道有利于代码接口的严谨性。

## 发送接收

通道有发送（send）、接收(receive）和关闭（close）三种操作。发送和接收都使用<-符号。

```
<- ch
ch <- 1
```

### 接收

```
channel := make(chan bool, 1)

for v, ok := range channel {
	if ok {
		// 通道未关闭
	}
}

for {
	select {
		case v := <-channel: 
		 	// 接收到值
		default: 
			// 其他
	}
}
```

## 关闭

```
close(ch)
```

close 函数官方定义如下：
close函数是一个内建函数， 用来关闭channel，这个channel要么是双向的， 要么是只写的（chan<- Type）。

关于关闭通道需要注意的事情是，只有在通知接收方goroutine所有的数据都发送完毕的时候才需要关闭通道。通道是可以被垃圾回收机制回收的，它和关闭文件是不一样的，在结束操作之后关闭文件是必须要做的，但关闭通道不是必须的。

关闭后的通道有以下特点：

​    1.对一个关闭的通道再发送值就会导致panic。
​    2.对一个关闭的通道进行接收会一直获取值直到通道为空。
​    3.对一个关闭的并且没有值的通道执行接收操作会得到对应类型的零值。

```
`v, ok := <-c`，中`ok`为false 标识通道已经被成功关闭
```

​    4.关闭一个已经关闭的通道会导致panic。

## 总结

![](https://topgoer.com/static/8.1/1.png)

参考文章：

[channel](https://topgoer.com/%E5%B9%B6%E5%8F%91%E7%BC%96%E7%A8%8B/channel.html)