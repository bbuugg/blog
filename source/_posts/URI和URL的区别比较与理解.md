---
title: URI和URL的区别比较与理解
date: 2021-04-03 21:49:25
tags:
---

#什么是URI

URI，通一资源标志符(Uniform Resource Identifier， URI)，表示的是web上每一种可用的资源，如 HTML文档、图像、视频片段、程序等都由一个URI进行标识的。

<!-- more -->

#URI的结构组成

URI通常由三部分组成：

①资源的命名机制；

②存放资源的主机名；

③资源自身的名称。

（注意：这只是一般URI资源的命名方式，只要是可以唯一标识资源的都被称为URI，上面三条合在一起是URI的充分不必要条件）

#URI举例

如：https://www.chengyao.xyz/notes/edit/152

我们可以这样解释它：

①这是一个可以通过https协议访问的资源，

②位于主机 www.chengyao.xyz上，

③通过“/notes/edit/152”可以对该资源进行唯一标识（注意，这个不一定是完整的路径）

注意：以上三点只不过是对实例的解释，以上三点并不是URI的必要条件，URI只是一种概念，怎样实现无所谓，只要它唯一标识一个资源就可以了。

# URL

URL是URI的一个子集。它是Uniform Resource Locator的缩写，译为“统一资源定位 符”。

通俗地说，URL是Internet上描述信息资源的字符串，主要用在各种WWW客户程序和服务器程序上。

采用URL可以用一种统一的格式来描述各种信息资源，包括文件、服务器的地址和目录等。URL是URI概念的一种实现方式。

URL的一般格式为(带方括号[]的为可选项)：

protocol :// hostname[:port] / path / [;parameters][?query]#fragment

URL的格式由三部分组成： 

①第一部分是协议(或称为服务方式)。

②第二部分是存有该资源的主机IP地址(有时也包括端口号)。

③第三部分是主机资源的具体地址，如目录和文件名等。

第一部分和第二部分用“://”符号隔开，

第二部分和第三部分用“/”符号隔开。

第一部分和第二部分是不可缺少的，第三部分有时可以省略。 

# URI和URL之间的区别

从上面的例子来看，你可能觉得URI和URL可能是相同的概念，其实并不是，URI和URL都定义了资源是什么，但URL还定义了该如何访问资源。URL是一种具体的URI，它是URI的一个子集，它不仅唯一标识资源，而且还提供了定位该资源的信息。URI 是一种语义上的抽象概念，可以是绝对的，也可以是相对的，而URL则必须提供足够的信息来定位，是绝对的。

更新:看了一下大家的疑问,其实大家对uri可以认为只是唯一识别的编号,类似于大家的身份证号,而url就是身份证住址+姓名,这样是不是就很明显了~~

更新2:针对大部分同学的疑问，其实纠结的就是URI到底是什么，怎么它就是URI不是URL了，其实文章中都已交代，只要能唯一标识资源的就是URI，在URI的基础上给出其资源的访问方式的就是URL，这是最简单的总结了，希望对大家有所帮助，祝好~~