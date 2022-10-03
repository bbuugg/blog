---
title: PHP判断文件是不是图片
date: 2021-03-07 22:52:13
tags:
---

> php判断文件是不是图片的方法：1、利用getimagesize函数获取图片信息，然后进行判断；2、读取图片的前2个字节，然后进行判断；3、利用exif_imagetype函数实现判断。

<!-- more -->

# 方法一

利用 `getimagesize` 函数获取图片信息，然后进行判断：

```php
<?php

/* Author @ Huoty
* Date @ 2015-11-24 16:59:26
* Brief @
*/

function isImage($filename)
{
    $types = '.gif|.jpeg|.png|.bmp'; //定义检查的图片类型
    if (file_exists($filename)) {
        if ($info = @getimagesize($filename)) {
            return 0;
        }
        $ext = image_type_to_extension($info['2']);
        return stripos($types, $ext);
    } else {
        return false;
    }
}

if (isImage('isimg.txt') !== false) {
    echo isImage('1.jpg');
    echo '是图片';
} else {
    echo '不是图片';
}
?>
```

# 方法二

读取图片的前 2 个字节，然后判断是不是图片：

```php
<?php

/* Author @ Huoty
* Date @ 2015-11-25 16:42:38
* Brief @
*/

//判断上传的是不是图片
function isImg($fileName)
{
    $file = fopen($fileName, "rb");
    $bin = fread($file, 2); // 只读2字节
    fclose($file);
    $strInfo = @unpack("C2chars", $bin);
    $typeCode = intval($strInfo['chars1'] . $strInfo['chars2']);
    $fileType = '';
    if ($typeCode == 255216 /*jpg*/ || $typeCode == 7173 /*gif*/ || $typeCode == 13780 /*png*/) {
        return $typeCode;
    } else {
// echo '"仅允许上传jpg/jpeg/gif/png格式的图片！';
        return false;
    }
}

if (isImg("1.jpg")) {
    echo "是图片";
} else {
    echo "不是图片";
}

?>
```

# 方法三

最后一种方法是利用 exif_imagetype 函数，该函数用于判断一个图像的类型，采用这种方法更加简单。读取一个图像的第一个字节并检查其签名。 如果发现了恰当的签名则返回一个对应的常量，否则返回 FALSE。返回值和 getimagesize() 返回的数组中的索引 2 的值是一样的，但该函数要快得多。

该函数的返回值常量定义如下：

1. IMAGETYPE_GIF
2. IMAGETYPE_JPEG
3. IMAGETYPE_PNG
4. IMAGETYPE_SWF
5. IMAGETYPE_PSD
6. IMAGETYPE_BMP
7. IMAGETYPE_TIFF_II（Intel 字节顺序）
8. IMAGETYPE_TIFF_MM（Motorola 字节顺序）
9. IMAGETYPE_JPC
10. IMAGETYPE_JP2
11. IMAGETYPE_JPX
12. IMAGETYPE_JB2
13. IMAGETYPE_SWC
14. IMAGETYPE_IFF
15. IMAGETYPE_WBMP
16. IMAGETYPE_XBM

示例：

```php
<?php

/* Author @ Huoty
* Date @ 2015-11-25 16:53:04
* Brief @
*/

$mimetype = exif_imagetype("1.jpg");
if ($mimetype == IMAGETYPE_GIF || $mimetype == IMAGETYPE_JPEG || $mimetype == IMAGETYPE_PNG || $mimetype == IMAGETYPE_BMP) {
    echo "是图片";
}

?>
```

[原文地址](https://www.php.cn/php-ask-460801.html "原文地址")