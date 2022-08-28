---
title: npm & yarn 更换源等常用命令或操作
date: 2021-01-09 19:36:56
tags:
---

# npm

> 由于node下载第三方依赖包是从国外服务器下载，虽然没有被墙，但是下载的速度是非常的缓慢且有可能会出现异常。
> 所以为了提高效率，我们还是把npm的镜像源替换成淘宝的镜像源。有几种方式供我们选择

## 使用cnpm

使用阿里定制的cnpm命令行工具代替默认的npm，输入以下代码

```shell
npm install -g cnpm --registry=https://registry.npm.taobao.org 
cnpm -v      #检测是否安装成功
```

安装成功之后，以后安装依赖包的方式和npm的是一样的，只是npm的命令换成是cnpm就可以了

假如你已经习惯了使用npm的安装方式的，不想去下载阿里的cnpm命令工具的话，很简单，我们直接将node的仓库地址换成淘宝仓库地址即可

## 单次使用

```shell
npm install --registry=https://registry.npm.taobao.org
```

## 永久使用

在开发react-native的时候，不要使用cnpm！cnpm安装的模块路径比较奇怪，packager不能正常识别。所以，为了方便开发，我们最好是直接永久使用淘宝的镜像源

直接命令行的设置

```shell
npm config set registry https://registry.npm.taobao.org
```

手动修改设置

1.打开`.npmrc`文件（`C:\Program Files\nodejs\node_modules\npm\npmrc`，没有的话可以使用git命令行建一个(`touch .npmrc`)，用`cmd`命令建会报错）
2.增加 

```
registry =https://registry.npm.taobao.org
```

即可。

检测是否修改成功

```php
// 配置后可通过下面方式来验证是否成功
npm config list
npm config get registry
npm info express
```

注：如果想还原npm仓库地址的话，只需要在把地址配置成npm镜像就可以了

```shell
npm config set registry https://registry.npmjs.org/
```
# yarn

## yarn add

```shell
yarn add [package]@[version]
```

 这将安装您的`dependencies`中的一个或多个包。
 用 `--dev` 或 `-D` 会在 `devDependencies` 里安装一个或多个包。

```
yarn global add <package...> //全局安装依赖
```

 对于绝大部分包来说，这是个坏习惯，因为它们是隐藏的。 最好本地安装你的依赖，这样它们都是明确的，每用你项目的人都能得到同样的依赖。
 注意：`yarn add global <package...>`会变成本地安装，注意顺序。

##  yarn cache

```
 yarn cache dir
```

 运行 `yarn cache dir` 会打印出当前的 `yarn`全局缓存在哪里。

```
yarn cache list --pattern <pattern> //列出匹配指定模式的已缓存的包
```

 示例：yarn cache list --pattern "gulp-(match|newer)"

yarn cache clean
 运行此命令将清除全局缓存。 将在下次运行 yarn 或 yarn install 时重新填充。

## yarn list

```
yarn list [--depth] [--pattern]
```

 默认情况下，所有包和它们的依赖会被显示。 要限制依赖的深度，你可以给 list 命令添加一个标志 --depth 所需的深度。
 示例

```
yarn list --depth=0
```

## yarn remove

```
yarn remove <package...>
```

 运行 `yarn remove foo` 会从你的直接依赖里移除名为 `foo` 的包，在此期间会更新你的 `package.json` 和 `yarn.lock` 文件。

## yarn run

```
yarn run [script] [<args>]
```

 如果你已经在你的包里定义了 `scripts`，这个命令会运行指定的 `[script]`。例如：
 运行这个命令会执行你的 `package.json` 里名为 `"test"` 的脚本。

## yarn upgrade

```
 yarn upgrade [package | package@tag | package@version | @scope/]... [--ignore-engines] [--pattern]
```

 可以选择指定一个或多个包名称。指定包名称时，将只升级这些包。未指定包名称时，将升级所有依赖项。

查看npm上已经全局安装的命令

```
npm list -g --depth=0
```

查看yarn 全局安装的根目录

```
 yarn global bin
```


 查看npm 全局安装的根目录

```
npm bin
```

yarn windows 安装

```
choco install yarn
```

 或者 

```
scoop install yarn
```

 或者下载安装包

## yarn指定淘宝源 

```
yarn config set registry http://registry.npm.taobao.org
```


原文链接：https://www.jianshu.com/p/f5d85e541a99
