---
title: Golang Mutex互斥锁
date: 2022-04-24 18:58:24
cover: https://img-blog.csdnimg.cn/20210408215347576.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0szNDZLMzQ2,size_16,color_FFFFFF,t_70
tags:
---

### 互斥锁

其中Mutex为互斥锁，Lock()加锁，Unlock()解锁，使用Lock()加锁后，便不能再次对其进行加锁，直到利用Unlock()解锁对其解锁后，才能再次加锁．适用于读写不确定场景，即读写次数没有明显的区别，并且只允许只有一个读或者写的场景，所以该锁叶叫做全局锁．

<!-- more -->

```
package main

import (
	"fmt"
	"sync"
	"errors"
)

type MyMap struct {
	mp map[string]int
	mutex *sync.Mutex
}

func (this *MyMap) Get(key string) (int, error) {
	this.mutex.Lock()
	i, ok := this.mp[key]
	this.mutex.Unlock()
	if !ok {
		return i, errors.New("不存在")
	}
	return i, nil
}

func (this *MyMap) Set(key string, v int) {
	this.mutex.Lock()
	defer this.mutex.Unlock()
	this.mp[key] = v
}

func (this *MyMap) Display() {
	this.mutex.Lock()
	defer this.mutex.Unlock()
	for k, v := range this.mp {
		fmt.Println(k, "=", v)
	}
}

func SetValue(m *MyMap) {
	var a rune
	a = 'a'
	for i := 0; i < 10; i++ {
		m.Set(string(a+rune(i)), i)
	}
}

func main() {
	m := &MyMap{mp: make(map[string]int), mutex: new(sync.Mutex)}
	go SetValue(m) /*启动一个线程向 map 写入值*/
	go m.Display() /*启动一个线程读取 map 的值*/
	var str string /*这里主要是等待线程结束*/
	fmt.Scan(&str)
}

```

### 读写锁

读写锁即是针对于读写操作的互斥锁。它与普通的互斥锁最大的不同就是，它可以分别针对读操作和写操作进行锁定和解锁操作。读写锁遵循的访问控制规则与互斥锁有所不同。

在读写锁管辖的范围内，它允许任意个读操作的同时进行。但是，在同一时刻，它只允许有一个写操作在进行。并且，在某一个写操作被进行的过程中，读操作的进行也是不被允许的。

也就是说，读写锁控制下的多个写操作之间都是互斥的，并且写操作与读操作之间也都是互斥的。但是，多个读操作之间却不存在互斥关系。

```
package main

import (
	"fmt"
	"sync"
	"errors"
	"time"
)

type MyMap struct {
	mp    map[string]int
	mutex *sync.RWMutex
}

func (this *MyMap) Get(key string) (int, error) {
	this.mutex.RLock()
	i, ok := this.mp[key]
	this.mutex.RUnlock()
	if !ok {

		return i, errors.New("不存在")

	}
	return i, nil
}

func (this *MyMap) Set(key string, v int) {
	this.mutex.RLock()
	defer this.mutex.RUnlock()
	this.mp[key] = v
}

func (this *MyMap) Display() {
	this.mutex.RLock()
	defer this.mutex.RUnlock()
	for k, v := range this.mp {
		fmt.Println(k, "=", v)
	}
}

func SetValue(m *MyMap) {
	var a rune
	a = 'a'
	for i := 0; i < 10; i++ {
		m.Set(string(a+rune(i)), i)
	}
}

func main() {
	m := &MyMap{mp: make(map[string]int), mutex: new(sync.RWMutex)}
	go SetValue(m) /*启动一个线程向 map 写入值*/
	go m.Display() /*启动一个线程读取 map 的值*/
	var str string /*这里主要是等待线程结束*/
	fmt.Scan(&str)
}
```

读写锁小例子

```
package main

import (
	"fmt"
	"sync"
	"time"
)

func main() {
	var lock sync.RWMutex
	go read(&lock)
	go read(&lock)
	go write(&lock)
	time.Sleep(25000000)
	fmt.Println("end")
}

func read(lock *sync.RWMutex) {
	lock.RLock()
	fmt.Println("reading")
	time.Sleep(5000)
	fmt.Println("read end")
	lock.RUnlock()
}

func write(lock *sync.RWMutex) {
	time.Sleep(1000) //保证先让读拿到锁, 如果没有就会随机，不过应该先过read一般会先read.
	lock.Lock()
	fmt.Println("writing")
	time.Sleep(5000)
	fmt.Println("write end")
	lock.Unlock()
}

```

//结果

reading

reading

read end

read end

writing

write end

end

# map并发读写报错

相似的报错：fatal error: concurrent map writes

原因1：加解锁异常
代码写的不严谨，加锁后未解锁，未形成单次闭环
解决：形成闭环，有加得必须有解

原因2：加解锁代码看起来貌似正常
实际上是加锁内部的代码加了个寂寞，map操作不在锁的范围内，和外部的代码在使用的
(共同读写的)还是相同的map（同地址），锁未起实际作用

解决：对map数据进行转移不使用旧map，在加锁与解锁之间生成新的map，
将数据转移至新map(或其它数据结构)再返回新map

或

调整代码位置即可

原因3：锁未加完全

只给写map的goroutine实施了加解锁，而读goroutine方面没有；
或
只给读map的goroutine实施了加解锁，而写goroutine方面没有；
或
未加锁

原因4：对该map加的不是同一把锁

举例：对于某map，读map有2个goroutine，写map有2个goroutine，这四个依次编号为1,2,3,4，前3个使用mu1，最后一个使用mu2，就会造成该报错。


温馨提示：
同一把锁可以作用多个map，但同一个map不能有两把锁操作。


