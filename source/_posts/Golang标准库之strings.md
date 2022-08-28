---
title: Golang标准库之strings
date: 2021-11-19 18:53:19
tags:
---

&gt; package strings

```go
import &quot;strings&quot;
```

strings包实现了用于操作字符的简单函数。

func [EqualFold](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#674)

```
func EqualFold(s, t string) bool
```

判断两个utf-8编码字符串（将unicode大写、小写、标题三种格式字符视为相同）是否相同。

Example

# func [HasPrefix](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#371)

```
func HasPrefix(s, prefix string) bool
```

判断s是否有前缀字符串prefix。

# func [HasSuffix](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#376)

```
func HasSuffix(s, suffix string) bool
```

判断s是否有后缀字符串suffix。

# func [Contains](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#112)

```
func Contains(s, substr string) bool
```

判断字符串s是否包含子串substr。

Example
## 
# func [ContainsRune](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#122)

```
func ContainsRune(s string, r rune) bool
```

判断字符串s是否包含utf-8码值r。

# func [ContainsAny](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#117)

```
func ContainsAny(s, chars string) bool
```

判断字符串s是否包含字符串chars中的任一字符。

Example

# func [Count](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#65)

```
func Count(s, sep string) int
```

返回字符串s中有几个不重复的sep子串。

Example

# func [Index](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#127)

```
func Index(s, sep string) int
```

子串sep在字符串s中第一次出现的位置，不存在则返回-1。

Example

# func [IndexByte](https://github.com/golang/go/blob/master/src/strings/strings_decl.go?name=release#8)

```
func IndexByte(s string, c byte) int
```

字符c在s中第一次出现的位置，不存在则返回-1。

# func [IndexRune](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#190)

```
func IndexRune(s string, r rune) int
```

unicode码值r在s中第一次出现的位置，不存在则返回-1。

Example

# func [IndexAny](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#211)

```
func IndexAny(s, chars string) int
```

字符串chars中的任一utf-8码值在s中第一次出现的位置，如果不存在或者chars为空字符串则返回-1。

Example

# func [IndexFunc](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#537)

```
func IndexFunc(s string, f func(rune) bool) int
```

s中第一个满足函数f的位置i（该处的utf-8码值r满足f(r)==true），不存在则返回-1。

Example

# func [LastIndex](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#164)

```
func LastIndex(s, sep string) int
```

子串sep在字符串s中最后一次出现的位置，不存在则返回-1。

Example

# func [LastIndexAny](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#227)

```
func LastIndexAny(s, chars string) int
```

字符串chars中的任一utf-8码值在s中最后一次出现的位置，如不存在或者chars为空字符串则返回-1。

# func [LastIndexFunc](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#543)

```
func LastIndexFunc(s string, f func(rune) bool) int
```

s中最后一个满足函数f的unicode码值的位置i，不存在则返回-1。

# func [Title](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#489)

```
func Title(s string) string
```

返回s中每个单词的首字母都改为标题格式的字符串拷贝。

BUG: Title用于划分单词的规则不能很好的处理Unicode标点符号。

Example

# func [ToLower](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#437)

```
func ToLower(s string) string
```

返回将所有字母都转为对应的小写版本的拷贝。

Example

# func [ToLowerSpecial](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#450)

```
func ToLowerSpecial(_case unicode.SpecialCase, s string) string
```

使用_case规定的字符映射，返回将所有字母都转为对应的小写版本的拷贝。

# func [ToUpper](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#434)

```
func ToUpper(s string) string
```

返回将所有字母都转为对应的大写版本的拷贝。

Example

# func [ToUpperSpecial](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#444)

```
func ToUpperSpecial(_case unicode.SpecialCase, s string) string
```

使用_case规定的字符映射，返回将所有字母都转为对应的大写版本的拷贝。

# func [ToTitle](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#440)

```
func ToTitle(s string) string
```

返回将所有字母都转为对应的标题版本的拷贝。

Example

# func [ToTitleSpecial](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#456)

```
func ToTitleSpecial(_case unicode.SpecialCase, s string) string
```

使用_case规定的字符映射，返回将所有字母都转为对应的标题版本的拷贝。

# func [Repeat](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#424)

```
func Repeat(s string, count int) string
```

返回count个s串联的字符串。

Example

# func [Replace](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#638)

```
func Replace(s, old, new string, n int) string
```

返回将s中前n个不重叠old子串都替换为new的新字符串，如果n&lt;0会替换所有old子串。

Example

# func [Map](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#383)

```
func Map(mapping func(rune) rune, s string) string
```

将s的每一个unicode码值r都替换为mapping(r)，返回这些新码值组成的字符串拷贝。如果mapping返回一个负值，将会丢弃该码值而不会被替换。（返回值中对应位置将没有码值）

Example

# func [Trim](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#586)

```
func Trim(s string, cutset string) string
```

返回将s前后端所有cutset包含的utf-8码值都去掉的字符串。

Example

# func [TrimSpace](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#613)

```
func TrimSpace(s string) string
```

返回将s前后端所有空白（unicode.IsSpace指定）都去掉的字符串。

Example

# func [TrimFunc](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#531)

```
func TrimFunc(s string, f func(rune) bool) string
```

返回将s前后端所有满足f的unicode码值都去掉的字符串。

# func [TrimLeft](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#595)

```
func TrimLeft(s string, cutset string) string
```

返回将s前端所有cutset包含的utf-8码值都去掉的字符串。

# func [TrimLeftFunc](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#508)

```
func TrimLeftFunc(s string, f func(rune) bool) string
```

返回将s前端所有满足f的unicode码值都去掉的字符串。

# func [TrimPrefix](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#619)

```
func TrimPrefix(s, prefix string) string
```

返回去除s可能的前缀prefix的字符串。

Example

# func [TrimRight](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#604)

```
func TrimRight(s string, cutset string) string
```

返回将s后端所有cutset包含的utf-8码值都去掉的字符串。

# func [TrimRightFunc](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#518)

```
func TrimRightFunc(s string, f func(rune) bool) string
```

返回将s后端所有满足f的unicode码值都去掉的字符串。

# func [TrimSuffix](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#628)

```
func TrimSuffix(s, suffix string) string
```

返回去除s可能的后缀suffix的字符串。

Example

# func [Fields](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#307)

```
func Fields(s string) []string
```

返回将字符串按照空白（unicode.IsSpace确定，可以是一到多个连续的空白字符）分割的多个字符串。如果字符串全部是空白或者是空字符串的话，会返回空切片。

Example

# func [FieldsFunc](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#314)

```
func FieldsFunc(s string, f func(rune) bool) []string
```

类似Fields，但使用函数f来确定分割符（满足f的unicode码值）。如果字符串全部是分隔符或者是空字符串的话，会返回空切片。

Example

# func [Split](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#294)

```
func Split(s, sep string) []string
```

用去掉s中出现的sep的方式进行分割，会分割到结尾，并返回生成的所有片段组成的切片（每一个sep都会进行一次切割，即使两个sep相邻，也会进行两次切割）。如果sep为空字符，Split会将s切分成每一个unicode码值一个字符串。

Example

# func [SplitN](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#277)

```
func SplitN(s, sep string, n int) []string
```

用去掉s中出现的sep的方式进行分割，会分割到结尾，并返回生成的所有片段组成的切片（每一个sep都会进行一次切割，即使两个sep相邻，也会进行两次切割）。如果sep为空字符，Split会将s切分成每一个unicode码值一个字符串。参数n决定返回的切片的数目：

```
n &gt; 0 : 返回的切片最多n个子字符串；最后一个子字符串包含未进行切割的部分。
n == 0: 返回nil
n &lt; 0 : 返回所有的子字符串组成的切片
```

Example

# func [SplitAfter](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#300)

```
func SplitAfter(s, sep string) []string
```

用从s中出现的sep后面切断的方式进行分割，会分割到结尾，并返回生成的所有片段组成的切片（每一个sep都会进行一次切割，即使两个sep相邻，也会进行两次切割）。如果sep为空字符，Split会将s切分成每一个unicode码值一个字符串。

Example

# func [SplitAfterN](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#286)

```
func SplitAfterN(s, sep string, n int) []string
```

用从s中出现的sep后面切断的方式进行分割，会分割到结尾，并返回生成的所有片段组成的切片（每一个sep都会进行一次切割，即使两个sep相邻，也会进行两次切割）。如果sep为空字符，Split会将s切分成每一个unicode码值一个字符串。参数n决定返回的切片的数目：

```
n &gt; 0 : 返回的切片最多n个子字符串；最后一个子字符串包含未进行切割的部分。
n == 0: 返回nil
n &lt; 0 : 返回所有的子字符串组成的切
```

Example

# func [Join](https://github.com/golang/go/blob/master/src/strings/strings.go?name=release#349)

```
func Join(a []string, sep string) string
```

将一系列字符串连接为一个字符串，之间用sep来分隔。

Example

# type [Reader](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#16)

```
type Reader struct {
    // 内含隐藏或非导出字段
}
```

Reader类型通过从一个字符串读取数据，实现了io.Reader、io.Seeker、io.ReaderAt、io.WriterTo、io.ByteScanner、io.RuneScanner接口。

## func [NewReader](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#144)

```
func NewReader(s string) *Reader
```

NewReader创建一个从s读取数据的Reader。本函数类似bytes.NewBufferString，但是更有效率，且为只读的。

## func (*Reader) [Len](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#24)

```
func (r *Reader) Len() int
```

Len返回r包含的字符串还没有被读取的部分。

## func (*Reader) [Read](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#31)

```
func (r *Reader) Read(b []byte) (n int, err error)
```

## func (*Reader) [ReadByte](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#59)

```
func (r *Reader) ReadByte() (b byte, err error)
```

## func (*Reader) [UnreadByte](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#69)

```
func (r *Reader) UnreadByte() error
```

## func (*Reader) [ReadRune](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#78)

```
func (r *Reader) ReadRune() (ch rune, size int, err error)
```

## func (*Reader) [UnreadRune](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#93)

```
func (r *Reader) UnreadRune() error
```

## func (*Reader) [Seek](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#103)

```
func (r *Reader) Seek(offset int64, whence int) (int64, error)
```

Seek实现了io.Seeker接口。

## func (*Reader) [ReadAt](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#44)

```
func (r *Reader) ReadAt(b []byte, off int64) (n int, err error)
```

## func (*Reader) [WriteTo](https://github.com/golang/go/blob/master/src/strings/reader.go?name=release#124)

```
func (r *Reader) WriteTo(w io.Writer) (n int64, err error)
```

WriteTo实现了io.WriterTo接口。

# type [Replacer](https://github.com/golang/go/blob/master/src/strings/replace.go?name=release#10)

```
type Replacer struct {
    // 内含隐藏或非导出字段
}
```

Replacer类型进行一系列字符串的替换。

## func [NewReplacer](https://github.com/golang/go/blob/master/src/strings/replace.go?name=release#31)

```
func NewReplacer(oldnew ...string) *Replacer
```

使用提供的多组old、new字符串对创建并返回一个*Replacer。替换是依次进行的，匹配时不会重叠。

Example

## func (*Replacer) [Replace](https://github.com/golang/go/blob/master/src/strings/replace.go?name=release#78)

```
func (r *Replacer) Replace(s string) string
```

Replace返回s的所有替换进行完后的拷贝。

## func (*Replacer) [WriteString](https://github.com/golang/go/blob/master/src/strings/replace.go?name=release#83)

```
func (r *Replacer) WriteString(w io.Writer, s string) (n int, err error)
```

WriteString向w中写入s的所有替换进行完后的拷贝。



来源： [Go语言标准库文档中文版 | Go语言中文网 | Golang中文社区 | Golang中国 (studygolang.com)](https://studygolang.com/pkgdoc)