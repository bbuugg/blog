---
title: Vue操作select
date: 2022-05-22 16:59:48
cover: https://tse2-mm.cn.bing.net/th/id/OIP-C.HVhbb7dbGzpPL2gtNXKVCgHaE7?pid=ImgDet&rs=1
tags:
categories: vue
---

Vue操作select

<!-- more -->

html如下
```html

<div id="app">
  <select v-model="category" v-on:change="switchCategory($event, 1)">
    <option v-for="(category, index) in categories" :key="index" v-bind:value="category.id">
		{{category.name}}
	</option>
  </select>
</div>

```

js如下

```

  Vue.createApp({
    data() {
      return {
        category: 0,
        categories: [
          {
            id: 1,
            name: "PHP",
          },
          {
            id: 2,
            name: "Go",
          },
          {
            id: 3,
            name: "Java",
          },
        ],
      };
    },
    methods: {
      switchCategory($event, p) {
        console.log($event.target.value, p, this.category);
      },
    },
  }).mount("#app");
```