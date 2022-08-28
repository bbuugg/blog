---
title: js获取当前位置的地理坐标（经纬度）
date: 2021-04-16 09:57:41
tags:
---

```
if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
        function (position) {  
            console.log( position.coords.longitude );
            console.log( position.coords.latitude );
        },
        function (e) {
           throw(e.message);
        }
    ) 
}
```