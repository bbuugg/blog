---
title: a标签的download属性
date: 2022-06-14 22:47:53
tags:
---

a标签加上downlaod属性后，就可完成对href属性链接文件的下载，但仅仅是限于同源文件，如果是非同源，download属性会失效。没有download属性的时候，a标签的默认行为是链接跳转进行预览，而针对浏览无法预览的文件，也可达到下载的效果。怎么解决下载非同源文件的问题？？ 例如image图片

方法： 通过canvas绘制，生成临时路径 (

data协议路径  // data:image/jpeg;base64,/9j/4AAQSkZJRgABAQ...9oADAMBAAIRAxEAPwD/AD/6AP/Z")，这个路径就是一个同源路径，然后传入下载函数进行下载。 

 
```
let img = new Image();
img.setAttribute('crossOrigin', 'anonymous')
img.src = data.entry;
img.onload = function(data) {
    let canvas = document.createElement('canvas');
    canvas.width = img.width;
    canvas.height = img.height;
    let context = canvas.getContext('2d');
    context.drawImage(img, 0, 0, canvas.width, canvas.height);
    let url = canvas.toDataURL('image/png');
    downLoadByLink(url,"小程序码");
}
```

```
const downLoadByLink = (url, filename) =>{
    //如果提供filename，则filename需要包含扩展名
    var link,
        evt;
    
    link = document.createElement('a');
    link.href = url;
    filename && link.setAttribute('download', filename);
    if(document.fireEvent) {
        window.open(link.href);
    }else {
        evt = document.createEvent('MouseEvents');
        evt.initEvent('click', true, true);
        link.dispatchEvent(evt);
    }
};
```