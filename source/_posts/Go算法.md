---
title: Go算法
date: 2022-06-11 18:51:22
tags:
---

## 排序

### 冒泡
```
package main

import "fmt"

func BubbleSort(list []int) []int {
	for i := 0; i < len(list); i++ {
		for j := i + 1; j < len(list); j++ {
			if list[j] > list[i] {
				list[i], list[j] = list[j], list[i]
			}
		}
	}
	return list
}

func main() {
	list := []int{2, 4, 2, 6, 1, 3, 9}
	fmt.Println(BubbleSort(list))
}
```