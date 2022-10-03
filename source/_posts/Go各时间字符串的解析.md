---
title: Go各时间字符串的解析
date: 2022-09-04 21:30:39
cover: https://pic3.zhimg.com/v2-d2518077a020100f7188b5c457eabf36_180x120.jpg
tags:
---

### `Go` 中时间格式化的模板

```js
const (
    ANSIC       = "Mon Jan _2 15:04:05 2006"
    UnixDate    = "Mon Jan _2 15:04:05 MST 2006"
    RubyDate    = "Mon Jan 02 15:04:05 -0700 2006"
    RFC822      = "02 Jan 06 15:04 MST"
    RFC822Z     = "02 Jan 06 15:04 -0700" // RFC822 with numeric zone
    RFC850      = "Monday, 02-Jan-06 15:04:05 MST"
    RFC1123     = "Mon, 02 Jan 2006 15:04:05 MST"
    RFC1123Z    = "Mon, 02 Jan 2006 15:04:05 -0700" // RFC1123 with numeric zone
    RFC3339     = "2006-01-02T15:04:05Z07:00"
    RFC3339Nano = "2006-01-02T15:04:05.999999999Z07:00"
    Kitchen     = "3:04PM"
    // Handy time stamps.
    Stamp      = "Jan _2 15:04:05"
    StampMilli = "Jan _2 15:04:05.000"
    StampMicro = "Jan _2 15:04:05.000000"
    StampNano  = "Jan _2 15:04:05.000000000"
)
```

<!-- more -->

上面这些是官方定义的`layout`常量，我们自己也可以定义，如：

```js
"2006-01-02 15:04:05" 
"2006-01-02"
"2006-01-02 15:04"
"2006-01-02T15:04" //js和html中多用这种形式
"2006-01-02 15:03:04 -0700 MST"
```

### `Format` 格式化为字符串

`format` 的使用对象是一个 `time.Time` 对象，可以使用官方或者自己定义的布局进行格式化的输出，如：

```js
now := time.Now()
now.Format("2006-01-02 15:04:05") //输出 2020-07-21 10:12:13
```

### `Parse` 字符串解析为时间戳或`int64`

#### `Parse` 方法

需要两个参数，第一个是布局，第二个是字符串

```js
//Parse解析格式化的字符串并返回它表示的时间值。
//布局通过显示参考时间（定义为2006年1月2日星期一1:04:05 -0700
//如果它是值，则将被解释；它作为一个例子
//输入格式。然后将对输入字符串。预定义的布局ANSIC，UnixDate，RFC3339等描述了参考时间的标准和便捷表示形式。有关格式和参考时间的定义的更多信息，请参见ANSIC文档以及此程序包定义的其他常量。
//解析时间偏移为-0700的时间时，如果偏移量对应于当前位置（本地）使用的时区，则Parse在返回的时间中使用该位置和时区。否则，它将时间记录为处于伪造位置，时间固定在给定的区域偏移量。
//
//另外，Time.Format的可执行示例详细说明了布局字符串的工作原理，是一个很好的参考。
//
//值中省略的元素假定为零，或者
//零不可能为1，因此解析“ 3:04 pm”将返回时间
//对应于1月1日，0，15:04:00 UTC（请注意，因为年份是
//0，此时间早于零时间）。
//年份必须在0000..9999的范围内。将检查星期几的语法，否则将忽略该语法。
//
//解析带有MST等区域缩写的时间时，如果该区域缩写在当前位置具有已定义的偏移量，则使用该偏移量。
//区域缩写“ UTC”被识别为UTC，与位置无关。
//如果未知区域缩写，则Parse将时间记录为位于指定位置的伪造位置，并具有零偏移量。
//此选择意味着可以使用相同的布局无损地解析和重新格式化这样的时间，但是表示中使用的确切瞬间将因实际区域偏移而有所不同。为避免此类问题，请首选使用数字区域偏移量的时间布局或使用ParseInLocation。

func Parse(layout, value string) (Time, error) {
    return parse(layout, value, UTC, Local)
}
```

使用例子：

```js
eg, err := time.Parse("2006-01-02 15:04:05 -0700 MST", "2019-08-29 16:48:21 +0800 CST")
//输出结果为time.Time格式 使用 format格式化后为 2019-08-29 16:48:21
```

#### `ParseInLocation`

```js
//ParseInLocation类似于Parse，但在两个重要方面有所不同。
//首先，在没有时区信息的情况下，Parse将时间解释为UTC；
//ParseInLocation将时间解释为给定位置。
//第二，当给定区域偏移量或缩写时，Parse尝试将其与本地位置进行匹配； ParseInLocation使用给定的位置

func ParseInLocation(layout, value string, loc *Location) (Time, error) {
    return parse(layout, value, loc, loc)
}
```

参数： 1. 布局 2. 字符串 3. 时区

获取本地时区可以使用 `time.Local`

使用例子：

```js
onlineAt, err := time.ParseInLocation("2006-01-02T15:04", "2020-01-02T15:04"), time.Local)
```

#### 解析为`int64`

对于 `time.Time` 对象，可以使用`.Unix()` 方法转为 `int64`，如：

```js
eg.Unix() //默认使用 UTC时区 
eg.Local().Unix() //返回本地时区的时间戳 int64
```

参考文章： [golang的时区和神奇的time.Parse](https://www.jianshu.com/p/f809b06144f7)