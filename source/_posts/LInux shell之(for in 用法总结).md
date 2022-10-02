---
title: LInux shell之(for in 用法总结)
date: 2022-04-24 22:45:50
tags:
---

一、语法

```
for 变量名  in  列表
  do
     程序段(command)
  done
```

<!-- more -->

注意1：是变量名而不是$变量！

注意2：列表可以做文章！

二、应用

第一类：数字性循环-->seq在in后面的应用

```
#!/bin/bash  
#也是产生等差数列-->默认是1
for i in $(seq 1 10)  #产生的是一个字符串，默认IFS是以空格隔开！
  do   
    echo $(expr $i \* 3 + 1);  #主要是复习:expr乘法的特殊用法！-->空格隔开
  done   
```

补充：产生[1,10]的自然数-->{}在in后面的应用

```
total=0 #全局变量
for i in {1..100} #".."表示连续，默认也是IFS为空格隔开
  do
    ((total+=i))
  done
echo -e "total is:${total}"

#多行注释
<<COMMENR
for i in mysql_{0,1,4,12}sql #多个文件
  do 
    echo $i
    samtools view -c $i 
  done
COMMENT
```

第二类：字符性循环

最原始的

```
#!/bin/bash
#使用列表for循环显示周一到周日对应的英文-->学习日期的英文
for day in Monday Tuesday Wednesday Thursday Friday Saturday Sunday 
  do
      echo "$day"
  done
```


变量的类型

```
#!/bin/bash  
list="Linux Java C++ Python"  
for i in $list  
  do  
    echo -e "Language is ${i}"   
  done  
```

cat在in后面的应用-->逐行读取文件的内容(默认是IFS)，所以不是逐行打印！

```
#!/bin/bash
for i in $(cat 日志颜色.sh) #注意:pwd当前目录下的文件
 do 
   echo $i
 done
```


思考：如果想逐行原样输出！

```
#!/bin/bash

# reading content from a file

file="日志文件.sh"
#将这个语句加入到脚本中，告诉bash shell在数据值中忽略空格和制表,使其只能识别换行符!
IFS=$'\n'
for std in $(cat $file)
  do
     echo "$std"
  done
```

说明：IFS的一些说明！

```
bash shell会将下列字符当作字段分隔符：空格、制表符、换行符

说明：如果在shell在数据中看到这些字符中的任意一个，它就会假定这表明了列表中一个新数据字段的开始！
参考的最佳安全实践：在改变IFS之前保存原来的IFS值，之后再恢复它。
```

https://zhuanlan.zhihu.com/p/36513249

保证了：在脚本的后续操作中使用的是IFS的默认值

实现：

```
IFS.OLD=$IFS          #默认的IFS的数值-->也是环境变量！
IFS=$'\n'             #自定义的IFS数值
<在代码中使用新的IFS值> #待使用自定义IFS的部分！
IFS=$IFS.OLD          #恢复默认的IFS
```


第三类：路径查找

ls在in后面的命令是-->读取当前pwd下的文件(广义上)！

```
#!/bin/bash  
for i in `ls`;  #ls可以结合统配符应用！
  do   
    echo $i is file name\! ;  #注意:\的应用！
  done   
```

 用通配符读取目录(无命令)

```
for file in ~/*;  #一级目录下的内容-->并不递归显示！ 
  do  
     echo $file is file path \! ;  #${file}代表的是文件的全路径
  done 
```


通过脚本传参

```
#!/bin/bash
#回忆1：统计脚本参数的个数
echo "argument number are $#"！
#回忆2：参数的内容-->此处可以换成$@来测试！
echo "the input is $*"
#循环执行
for argument in "$*";
  do
      echo "$argument "
  done
```


IFS：内部字段分隔符

需求如下：

```
#遍历一个文件中用冒号分隔的值：-->特殊文件-->/etc/passwd文件等！
IFS=：
#如果要指定多个IFS字符，只要将它们在赋值行串起来就行。
IFS=$'\n':;"
```


总结：

```
#（1）从变量读取列表

# 将一系列的值都集中存储在一个变量中，然后需要遍历变量中的整个列表

#（2）从命令读取值
#有两种方式可以将命令输出赋值给变量：

# （1）反引号字符（`）

# （2）$()格式 
```

补充：在列表构成上分多种情景，如数字列表、字符串列表、命令列表、脚本传参列表等！



数组遍历

遍历数组时，使用哪种方式取决于数组中元素的分布情况。

定义如下两个数组：

```
#下标连续
arr1=(a b c d e)
#下标不连续
arr2=([2]="a b" [5]="c" [8]=4 [10]="csdn")
1.for，适用于数组下标连续的情况，如果数组下标不连续会得不到完整的结果。

for ((i=0;i<${#arr1[@]};i++))
do
    echo ${arr1[$i]}
done
```

2.for...in，无论下标是否连续都可以，有两种方式，一种是直接遍历数组中的元素，一种是通过遍历数组下标获取数组元素。

#直接遍历数组

```
for value in "${arr1[@]}"
do
    echo $value
done
#通过遍历下标获取数组元素
for i in ${!arr1[@]}
do
    echo ${arr1[$i]}
done
```



3. while，适用于数组下标连续的情况，如果数组下标不连续会得不到完整的结果。

```
i=0
while [ $i -lt ${#arr1[@]} ]
do
    echo ${arr1[$i]}
    let i++
done
```


除了下标问题外，关于@与*在使用时也要注意，并不是完全等价，并且在被双引号包围时的解析有时也略有不同。

对于第一种遍历方式，${#arr1[@]}中@可以与*互换，并且被双引号包围时也是等效的，"${#arr1[@]}"。

对于第二种遍历方式，当直接遍历数组元素时，${arr1[@]}没有被双引号包围时@与*等效，但是解析数组元素时会把元素中的内容也按空格分隔，会导致解析错误。当${arr1[*]}被双引号包围时，会将数组中所有的元素按空格分隔后当作一个元素，解析也是错误的。只有当${arr1[@]}被双引号包围时，才能正确解析数组元素，所以直接遍历数组元素时，必须使用“"${arr1[@]}"”的方式。当通过遍历下标遍历数组元素时，${!arr1[*]}被双引号包围时，所有的元素下标会被逗号分隔后组成一个字符串，所以不能用此方式获取下标集合，其他三种情况可以正确获取下标。

对于第三种遍历方式，不受@、*与双引号影响。


————————————————
版权声明：本文为CSDN博主「wzj_110」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/wzj_110/article/details/86669426