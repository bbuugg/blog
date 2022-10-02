---
title: composer使用笔记
date: 2021-02-13 18:40:20
cover: https://www.bleepstatic.com/content/posts/2018/08/29/Packagist.png
tags:
---

# 安装
```shell
wget https://mirrors.cloud.tencent.com/composer/composer.phar
mv composer.phar  /usr/local/bin/composer
```

#更换源
>首先要分清楚是局部换源还是全局换源

## 1、局部换源(仅对当前项目有效)

在当前项目下的composer.json中添加

```json
{
"repositories": [
        {
            "type": "composer",
            "url": "http://packages.example.com" //第一个源
        },
        {
            "type": "composer",
            "url": "http://packages.example.com" //第二个源
        },
		{
			"type": "git",
			"url": "https://git.url"
		},
		{
			"type": "path",
			"url": "D:/php/pacakge"
		}
}
```

寻找包的过程是先从第一个源中寻找，如果找不到就从第二个源中寻找，这里可以配置多个composer资源库

<!-- more -->

## 2、全局换源

打开命令行
### 首先把默认的源给禁用掉
```shell
composer config -g secure-http false
```
### 修改镜像源
```shell
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/    # 阿里
composer config -g repos.packagist composer https://mirrors.cloud.tencent.com/composer/ # 腾讯
```

### 更换为原来的源

```shell
composer config -g repo.packagist composer https://repo.packagist.org
```

### 修改成功后可以先查看一下配置
```shell
composer config -g -l
```
### 第二行`repositories.packagist.org.url` 如果是阿里的就代表成功

## 注意:

如果修改了全局的话 就不用再去项目下修改composer.json配置文件了

如果当前项目的composer.json已经配置过，那会是当前项目下指定的源

文章来源：[composer更换源](https://www.cnblogs.com/death-satan/p/12153960.html "composer更换源")


# 常用命令

composer outdated 

> 更新命令

```shell
composer self-update --preview
```

```shell
composer update -vvv
```

> 清除缓存命令

```shell
composer clearcache
```

> 更新到composer2 

```shell
composer self-update --2 
```
如果使用`apt`或者`yum`等方式安装可能需要其他方法具体见官方文档。

> 搜索扩展包

```shell
composer search max/max
```
#自动加载
>我们在开发项目中会经常用到第三方的类库插件，但是如果每次需要使用的时候都会在代码的某一处去引入，然后在实例化，这样做感觉很不方便，那么怎么实现自动加载呢，下面简单介绍使用composer实现自动加载：

## 安装

安装地址（中国镜像）: https://pkg.phpcomposer.com/#how-to-install-composer
根据它的说明一步一步进行安装

## 新建目录

新建一个目录，这个目录的名称是有要求的，当你看到有提示就说名你的命名不符合要求，该目录就是后面的项目目录！

## 初始化

打开命令行控制台cmd,进入工作目录,运行`composer`命令：`composer init`
之后会提示你输入一些包名，作者等信息，运行后会生成一个composer.json文件

## Install

执行composer install 安装会给你安装依赖，当然你的项目刚建立是没有依赖的，所以他会给你安装composer包，composer包的结构如下：

   - vendor
     - composer
     - autoload_classmap.php
     - autoload_namespaces.php
     - autoload_psr4.php
     - autoload_real.php
     - autoload_static.php
       ClassLoader.php
       installed.json
       LICENSE
          - autoload.php
         - composer.json

在你的项目中引入autoload.php就可以进行自动加载了。

你可能需要手动修改/添加一些东西

## 自动加载

### 配置

打开`composer.json`文件:
共有四种方式：

1. PSR-0（不推荐使用);
2. PSR-4;
3. Class-map;
4. Files;

下面演示PSR-4实现自动加载：

```json
  "autoload": {
    "psr-4": {
      "app\\": "../application"
    }
```

其中app\\表示../application 目录下的类的命名空间是app

### 命名空间

新建src目录，在目录下创建IndexController.php,php文件内容如下:

    //设置命名空间
    namespace src;
    class IndexController
    {
        public function index()
        {
            echo 'indexController';
        }
    }

## 创建类

在work根目录创建index.php：

    //引入vendor下的autoloas.php
    require 'vendor/autoload.php';
    //实例化对象
    $index = new src\\IndexController();
    //调用类中的方法
    $index->index();

运行后会出现报错:

> class IndexController not fund

打开控制台,进入到work文件目录,运行composer命令:

> composer dump-autoload

在运行`work`下的`index.php`，不报错误信息说明已经成功实现自动加载了。

## 使用

在`work`下的`index.php`文件中我们实例化IndexController类的时,格式为```new src\IndexController();```;
如果命名空间较长的情况下，看起来不太方便，那我们可以用```use```来引入关键字，修改index.php代码如下：

    use src\IndexController;
    //引入vendor下的autoloas.php
    require 'vendor/autoload.php';
    //修改后的实例化
    $index = new IndexController();
    //调用类中的方法
    $index->index();

在运行index.php结果和上面一样。
**注意：**在配置完`composer.json`以后一定要运行```composer dump-autoload [-o] ```不然会出现`class not fund;`
#踩坑

已经安装composer，写好composer.bat，并且设置好了path，在cmd下可以正常使用，但是在git-bash里面不行，显示如下提示：

`bash: composer: command not found`

原因很可能是composer文件没有可执行权限，git-bash是以linux shell方式运行的，linux和windows文件权限管理方式不太一样。切换到composer文件所在目录，执行如下命令修复权限：
```shell
chmod 755 composer.bat
```
可是我发现上面的命令没有效果，这就尴尬了

其实真正的原因是，git-bash 不识别 composer.bat 文件，需要新建一个 composer 文件，输入如下内容：
```shell
#!/usr/bin/env sh
# php /path/to/composer.phar $*
php `dirname $0`/composer.phar $*
```
`#!/usr/bin/env sh` 有个这一行，git-bash 会自动识别为可执行文件，不需要也不能使用 chmod 命令修改权限。

# 忽略平台要求
```
composer install --ignore-platform-reqs
```

指定php版本运行composer
```
php /usr/bin/composer create-project max/max .
```

这里composer需要是完整路径。

# 文档

https://docs.phpcomposer.com/

# 版本约束

## 通配符
可以使用通配符来设置版本。1.0.*相当于>=1.0 <1.1。
例子：1.0.*

## 波浪号
我们先通过后面这个例子去解释~操作符的用法：~1.2相当于>=1.2 <2.0.0，而~1.2.3相当于>=1.2.3 <1.3.0。对于使用Semantic Versioning作为版本号标准的项目来说，这种版本约束方式很实用。例如~1.2定义了最小的小版本号，然后你可以升级2.0以下的任何版本而不会出问题，因为按照Semantic Versioning的版本定义，小版本的升级不应该有兼容性的问题。简单来说，~定义了最小的版本，并且允许版本的最后一位版本号进行升级（没懂得话，请再看一边前面的例子）。
例子：~1.2

> 需要注意的是，如果~作用在主版本号上，例如~1，按照上面的说法，Composer可以安装版本1以后的主版本，但是事实上是~1会被当作~1.0对待，只能增加小版本，不能增加主版本。

## 折音号 ^
^操作符的行为跟Semantic Versioning有比较大的关联，它允许升级版本到安全的版本。例如，^1.2.3相当于>=1.2.3 <2.0.0，因为在2.0版本前的版本应该都没有兼容性的问题。而对于1.0之前的版本，这种约束方式也考虑到了安全问题，例如^0.3会被当作>=0.3.0 <0.4.0对待。
例子：^1.2.3

## 版本稳定性
如果你没有显式的指定版本的稳定性，Composer会根据使用的操作符，默认在内部指定为-dev或者-stable。例如：

## 参考

| 名称  | 实例  | 说明  |
| --- | --- | --- |
| 不指定版本 |     | 根据当前Path环境变量中的php版本下载最合适的最新版 |
| 确切的版本 | 6.0.1 | 指定下载的具体版本号 |
| 范围 <br> > <br> < <br>!= | > 6.0，< 6.0 | 指定版本范围，自动下载该范围中的最新版 |
| 通配符 * | 5.*，6.0.* | 5.* 代表版本范围 [5, 6.0) <br> 6.0.* 代表版本范围 [6.0, 6.1) |
| 赋值运算符（最低版本） ~ | 1.2，6.1.0 | ~1.2 代表版本范围 [1.2, 2.0) <br> ~6.1.0 代表版本范围 [6.1.0, 6.2) |
| 脱字号版本（最低版本） ^ | ^1.2.3 | ^1.2.3 代表版本范围 [1.2.3, 2.0.0) |

## 约束	内部约束
```
1.2.3	=1.2.3.0-stable
>1.2	>1.2.0.0-stable
>=1.2	>=1.2.0.0-dev
>=1.2-stable	>=1.2.0.0-stable
<1.3	<1.3.0.0-dev
<=1.3	<=1.3.0.0-stable
1 - 2	>=1.0.0.0-dev <3.0.0.0-dev
~1.3	>=1.3.0.0-dev <2.0.0.0-dev
1.4.*	>=1.4.0.0-dev <1.5.0.0-dev
```
例子：1.0 - 2.0
如果你想指定版本只要稳定版本，你可以在版本后面添加后缀-stable。
minimum-stability 配置项定义了包在选择版本时对稳定性的选择的默认行为。默认是stable。它的值如下（按照稳定性排序）：dev，alpha，beta，RC和stable。除了修改这个配置去修改这个默认行为，我们还可以通过稳定性标识（例如@stable和@dev）来安装一个相比于默认配置不同稳定性的版本。例如：
```
{
    "require": {
        "monolog/monolog": "1.0.*@beta",
        "acme/foo": "@dev"
    }
}
```

> 版本测试: https://semver.madewithlove.com/ ,地址可能会变更,可以参考composer官方文档