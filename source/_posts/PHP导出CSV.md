---
title: PHP导出CSV
date: 2022-04-21 23:32:59
cover: https://tse2-mm.cn.bing.net/th/id/OIP-C.gUNsLfFkEFpk_hNfvSe-ZQHaHa?pid=ImgDet&rs=1
tags:
---

文档待整理，暂时写这么点

# 涉及函数

```
fopen
fputs
fputcsv
```

<!-- more -->

# 示例代码

```
$header = ['第一列', '第二列', '第三列'];
$row = ['one', 'two', 'three'];
$fp = fopen('./example.csv', 'w+');
fputs(chr(239) . chr(187) . chr(191)); // 添加utf-8 bom头
fputcsv($fp, $row);
```

如果不想使用`fputcsv`函数，可以直接使用`,`分割拼接数组，但是要注意每一列的逗号应该被处理，否则可能会不能对齐

# 浏览器下载

响应如下头部

```php
header('Content-Type: application/vnd.ms-excel'); // 文件格式
header('Content-Type: charset=utf-8'); // 文件编码
header('Content-Disposition: attachment; filenaeme='. $filename); // 文件名
header('Content-Type: application/octet-stream'); // 二进制流
// header("Accept-Ranges:bytes");// 表明范围单位为字节，可不写
header("Pragma: no-cache"); // 禁止缓存
header("Expires: 0");// 有效期时间
```

实例

```php
$fp = fopen('./example.csv', 'w+');
$count = 0;
$max = 100;
while($row = $query->fetch()) {
	if($count > $max) {
		ob_flush();
		flush();
		$count = 0;
	}
	$count++;
	fputcsv($fp, $row);
	unset($row);
}
fclose($fp);
```



## 细节

如果没有写入bom头，则使用Microsoft Excel打开有可能乱码，如果你使用windows,可以将csv以记事本方式打开保存时选择编码为utf-8 bom，你也可以进行转码

```
$str = "\t".iconv('utf-8', 'gb2312//ignore', $v);  // gbk 也可以（建议）
```

前面加了\t，这样对于长数字，不会被显示为科学计数法，也可以对应一些特殊字符问题，如果是时间格式，不要在末尾加\t，否则不可筛选

**转码函数还有例如**：

```
mb_convert_encoding
mb_convert_variables
```

# BOM

BOM（Byte Order Mark），字节顺序标记，出现在文本文件头部，Unicode编码标准中用于标识文件是采用哪种格式的编码。

```
0xEF 0xBB 0xBF
```

移除BOM

```
$BOM = chr(239).chr(187).chr(191);
return str_replace($BOM,”,$contents);
```

检查是否有BOM

```
return substr($string,0,3) == pack("CCC",0xef,0xbb,0xbf);
```

## 参考

PHP文件头BOM头问题  https://www.cnblogs.com/wt645631686/p/6868826.html
在 PHP 中使用 BOM 将字符串编码为 UTF-8 https://www.itbaoku.cn/post/1743835/do