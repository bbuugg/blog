---
title: Golang判断字符串是否是纯数字
date: 2022-06-11 18:35:51
tags:
---

提供了两个方法，一个逐字符判断，一个使用正则

```
func IsNumeric(str string) bool {
	for _, v := range str {
		if !unicode.IsNumber(v) {    // IsNumber判断是否为一个数字字符 (类别 N)
		// if !unicode.IsDigit(v) { // IsDigit 判断 r 是否为一个十进制的数字字符
			return false
		}
	}
	return true
}

# https://www.coder.work/article/193576

func IsNumericP(str string) bool {
	// 使用正则判断是不是数字字符串
	return regexp.MustCompile(`^[0-9]+$`).MatchString(str)
}

```

示例

```
func main() {
	str := "12345"
	str1 := "123rr"
	// fmt.Println(IsNumeric(str), IsNumeric(str1)) // true, false
	fmt.Println(IsNumericP(str), IsNumericP(str)) // true, false
}
```