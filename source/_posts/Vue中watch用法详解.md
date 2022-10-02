---
title: Vue中watch用法详解
date: 2022-05-21 22:42:47
cover: https://swansoftwaresolutions.com/wp-content/uploads/2020/01/Benefits-of-Using-VUE.JS.jpeg
tags:
---

### 基本用法：

 当firstName值变化时，watch监听到并且执行

<!-- more -->

```jsx
<div>
      <p>FullName: {{fullName}}</p>
      <p>FirstName: <input type="text" v-model="firstName"></p>
</div>
 
new Vue({
  el: '#root',
  data: {
    firstName: 'Dawei',
    lastName: 'Lou',
    fullName: ''
  },
  watch: {
    firstName(newName, oldName) {
      this.fullName = newName + ' ' + this.lastName;
    }
  } 
})
```

### handler方法和immediate属性：

 上面的例子是值变化时候，watch才执行，我们想让值最初时候watch就执行就用到了`handler`和`immediate`属性



```kotlin
watch: {
  firstName: {
    handler(newName, oldName) {
      this.fullName = newName + ' ' + this.lastName;
    },
    // 代表在wacth里声明了firstName这个方法之后立即先去执行handler方法，如果设置了false，那么效果和上边例子一样
    immediate: true
  }
}
```

### deep属性（深度监听，常用语对象下面属性的改变）：



```jsx
<div>
      <p>obj.a: {{obj.a}}</p>
      <p>obj.a: <input type="text" v-model="obj.a"></p>
</div>
 
new Vue({
  el: '#root',
  data: {
    obj: {
      a: 123
    }
  },
  watch: {
    obj: {
      handler(newName, oldName) {
         console.log('obj.a changed');
      },
      immediate: true
    }
  } 
})
```

 我们在在输入框中输入数据视图改变obj.a的值时，我们发现是无效的。受现代 JavaScript 的限制 (以及废弃 Object.observe)，Vue 不能检测到对象属性的添加或删除。由于 Vue 会在初始化实例时对属性执行 getter/setter 转化过程，所以属性必须在 data 对象上存在才能让 Vue 转换它，这样才能让它是响应的。

 默认情况下 handler 只监听obj这个属性它的引用的变化，我们只有给obj赋值的时候它才会监听到，比如我们在 mounted事件钩子函数中对obj进行重新赋值：



```kotlin
mounted: {
  this.obj = {
    a: '456'
  }
}
```

 那么我们需要监听obj里的属性a的值呢？这时候deep属性就派上用场了:



```css
watch: {
  obj: {
    handler(newName, oldName) {
      console.log('obj.a changed');
    },
    immediate: true,
    deep: true
  }
}
```

 这样的方法对性能影响很大，修改obj里面任何一个属性都会触发这个监听器里的 handler。我们可以做如下处理：



```jsx
watch: {
  'obj.a': {
    handler(newName, oldName) {
      console.log('obj.a changed');
    },
    immediate: true,
    // deep: true
  }
}
```

 watch的注销这里就不在多说了，实际开发中，watch会随着组件一并销毁。

链接：https://www.jianshu.com/p/b70f1668d08f

