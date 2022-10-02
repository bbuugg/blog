---
title: Springboot实践
date: 2022-07-10 08:47:55
tags:
---

## 创建一个springboot项目

[(50条消息) 创建一个Spring Boot项目_慕北丶的博客-CSDN博客_创建springboot项目](https://blog.csdn.net/qq_42539533/article/details/90607415)

<!-- more -->

## Maven更换仓库

从官方仓库[http://repo.maven.apache.org/maven2/](https://link.jianshu.com/?t=http://repo.maven.apache.org/maven2/) 下载较慢，可以设置[maven](https://so.csdn.net/so/search?q=maven&spm=1001.2101.3001.7020)仓库源为国内镜像，加快依赖的下载。

修改Maven默认的下载仓库

### 可以在pom.[xml](https://so.csdn.net/so/search?q=xml&spm=1001.2101.3001.7020)中设置如下代码：

```
<repositories>
    <repository>
        <id>nexus-aliyun</id>
        <name>nexus-aliyun</name>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </repository>
</repositories>
```

### 也可以在本地maven子目录/conf/settings.xml中settings.xml中配置：

想要修改Maven默认的下载仓库，其实我们只需要找到Maven的settings.xml文件。如果使用的是IDEA默认的Maven，那么settings.xml默认存放地址为IDEA安装路劲下的：\JetBrains\IntelliJ IDEA xxx.xxx\plugins\maven\lib\maven3\conf

复制一份settings.xml 到：C:\Users\You user.m2(默认本地存放下载的jar包位置为当前用户文件下下的.m2文件中)下也就是你的本地maven仓库下。

```
<mirror>
    <!--This sends everything else to /public -->
    <id>nexus-aliyun</id>
    <mirrorOf>*</mirrorOf>
    <name>Nexus aliyun</name>
    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
</mirror>
```

## maven缺少依赖包，强制更新依赖命令

```
mvn clean install -e -U -Dmaven.test.skip=true
```

- -e详细异常，-U强制更新
- -DskipTests，不执行测试用例，但编译测试用例类生成相应的class文件至target/test-classes下。
- -Dmaven.test.skip=true，不执行测试用例，也不编译测试用例类。

使用maven.test.skip，不但跳过单元测试的运行，也跳过测试代码的编译。

```
mvn package -Dmaven.test.skip=true
```

## Error:java: 错误: 不支持发行版本 5 解决方法

[(50条消息) Error:java: 错误: 不支持发行版本 5 解决方法（详细）_哇咔咔i的博客-CSDN博客_java错误不支持发行版本5](https://blog.csdn.net/DD04567/article/details/107205871)