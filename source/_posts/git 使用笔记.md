---
title: git 使用笔记
date: 2020-12-15 11:00:16
tags:
---

# 常用

## 命令

```
git init
git config -e # 编辑配置文件
git config user.name 'username'
git config user.email 'email'
git clone [-b] branch xxx.git 拉取
git status 
git log [-p]/[-n]  ---n代表数字
git log --stat ---简单信息
git log --name-status  ---可以显示新增、修改、删除的文件清单
git commit [-m '']
git push 远程 本地
git pull 远程 本地
git pull origin 1.x:dev 将远程origin的1.x分支拉取到本地dev分支
git push origin dev:1.x 将本地dev分支推送到远程1.x分支
git fetch origin test:example fetch远程test到本地example(原本不存在)
git tag test_tag c809ddbf83939a89659e51dc2a5fe183af384233　　　　//在某个commit 上打tag
git tag [tag] 新建或者list tag
git tag -d <tag> 删除本地tag
git push origin :refs/tags/test_tag　　　　//本地tag删除了，再执行该句，删除线上tag
git push origin :<tag>/<branch> 删除远程tag/分支
git remote add origin https://git.com
git remote set-url origin https://<token>@github.com/<username>/<repo>.git
git remote set-url --add origin https://<token>@github.com/<username>/<repo>.git # 添加多个
git remote get-url origin
git remote -v # 列出所有
git remote rename 原名 新名
git remote remove 名字
git add xx命令可以将xx文件添加到暂存区，如果有很多改动可以通过 git add -A .来一次添加所有改变的文件。注意 -A 选项后面还有一个句点。 git add -A表示添加所有内容， git add . 表示添加新文件和编辑过的文件不包括删除的文件; git add -u 表示添加编辑或者删除的文件，不包括新添加的文件
git commit -m "提交注释"
git branch 查看本地所有分支
git branch -r查看远程所有分支  一般当前本地分支前带有“*”号且为绿色，远程分支为红色
git branch -a
git branch -vv
git branch [-f] <branchname> 新建分支但是不切换
git branch -d[-D] <branchname>删除本地分支[强制(相当于 --delete --force)]
git branch -d -r <branchname>删除远程分支，其中<branchname>为本地分支名
git branch (-m | -M) <oldbranch> <newbranch> //修改branch名称
git checkout -b <branchname> 新建并切换至新分支
git push origin  分支名称，一般使用：git push origin master
git branch --set-upstream 本地关联远程分支
git push --set-upstream origin master
git remote rm
git config --global core.autocrlf false 禁用Git默认配置替换回车换行成统一的CRLF
git diff  分支1 分支2 --stat （加上 --stat 是显示文件列表, 否则是文件内容diff）
git cherry-pick <commitHash> 将commitHash的提交应用于当前分支 
git cherry-pick <branch> 会转移该分支的最新一次提交
git cherry-pick <hash1> <hash2> 转移这两次提交
git cherry-pick <hash1>..<hash10> 转移hash1到hash10的提交（hash1必须比hash10早，默认不包含1, 如果要包含，需要<hash1^>, 例如：git cherry-pick A^..B ）
```

> 更多cherry-pick用法可以参考：https://ruanyifeng.com/blog/2020/04/git-cherry-pick.html 或者官方文档
```
git cherry-pick --help
```

## 选项

```
-d  --delete：删除
-D  --delete --force的快捷键
-f  --force：强制
-m  --move：移动或重命名
-M  --move --force的快捷键
-r  --remote：远程
-a  --all：所有
```

# 常见问题

最近使用git pull的时候多次碰见下面的情况：

There is no tracking information for the current branch.
Please specify which branch you want to merge with.
See git-pull(1) for details.

git pull <remote> <branch>

If you wish to set tracking information for this branch you can do so with:

git branch --set-upstream-to=origin/<branch> release

其实，输出的提示信息说的还是比较明白的。
使用git在本地新建一个分支后，需要做远程分支关联。如果没有关联，git会在下面的操作中提示你显示的添加关联。
关联目的是在执行git pull, git push操作时就不需要指定对应的远程分支，你只要没有显示指定，git pull的时候，就会提示你。
解决方法就是按照提示添加一下呗：
git branch --set-upstream-to=origin/remote_branch  your_branch
其中，origin/remote_branch是你本地分支对应的远程分支；your_branch是你当前的本地分支。

## 恢复到之前的文件

对于恢复修改的文件，就是将文件从仓库中拉到本地工作区，即 仓库区 ----> 暂存区 ----> 工作区。

对于修改的文件有两种情况：

- 只是修改了文件，***没有任何 git 操作***
- 修改了文件，并提交到***暂存区***（即编辑之后，gitadd但没有gitadd但没有 git commit -m ....）
- 修改了文件，并提交到***仓库区***（即编辑之后，gitadd和gitadd和 git commit -m ....）

### 情况I：

只是修改了文件，***没有任何 git 操作***，直接一个命令就可回退：

```
$ git checkout -- aaa.txt # aaa.txt为文件名
```

### 情况II：

修改了文件，并提交到***暂存区***（即编辑之后，gitadd但没有 git commit -m ....）

```
$ git log --oneline    # 可以省略
$ git reset HEAD    # 回退到当前版本
$ git checkout -- aaa.txt    # aaa.txt为文件名
```

###  情况III：

修改了文件，并提交到***仓库区***（即编辑之后，gitadd和gitadd和 git commit -m ....）

```
$ git log --oneline    # 可以省略
$ git reset HEAD^    # 回退到上一个版本
$ git checkout -- aaa.txt    # aaa.txt为文件名
```

> 情况II 和 情况III 只有回退的版本不一样，

对于 情况II，并没有 $ git commit，仓库版本也就不会更新和记录，所以回退的是当前版本

对于情况III，一旦 $ git commit，仓库版本就会更新并记录，所以要回退的也就是上一个版本

> git reset 版本号  ---- 将暂缓区回退到指定版本

根据 $ git log --oneline 显示的版本号（下图黄色的字），可以回退到任何一个版本，也可通过 HEAD 来指定版本（下图红色的字）。

## 合并

一、开发分支（dev）上的代码达到上线的标准后，要合并到 master 分支

```
git checkout dev
git pull
git checkout master
git merge dev
git push -u origin master
```


二、当master代码改动了，需要更新开发分支（dev）上的代码

```
git checkout master 
git pull 
git checkout dev
git merge master 
git push -u origin dev
```

## 删除已经add的文件

`git rm --cached <文件路径>`，不删除物理文件，仅将该文件从缓存中删除；

`git rm --f <文件路径>`，不仅将该文件从缓存中删除，还会将物理文件删除（不会回收到垃圾桶）。

`git reset HEAD` 用版本库内容清空暂存区，（谨慎使用）

## 常见错误

## You can only push commits that were committed with one of your own verified emails.

### 报错

```
remote: GitLab: You cannot push commits for 'mailto:xxxx.sss@trip.com'. You can only push commits that were committed with one of your own verified emails.
To git.dev.sh.1kmb.com:amd.yes/hello-world.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'git@git.dev.sh.1kmb.com:amd.yes/hello-world.git'
```

### 原因

```
commit的时候邮箱不一致
```

### 解决

```
$ git log
$ git reset --hard 9e76350248a46a16b68fef25d27e25fcd4d65312  # 回滚到没错
$ git config --global user.email "你的邮箱地址"
改下邮箱，重新conmmit
```

# Github使用token

```php
git remote set-url origin https://<token>@github.com/<username>/<repo>.git
```

# 恢复版本

git 如何恢复到指定版本
查看git的提交版本和id 拿到需要恢复的版本号 
　　　命令：git log　 

　　  2. 恢复到指定版本 

　　　命令：git reset --hard 44f994dd8fc1e10c9ed557824cae50d1586d0cb3   //后面这一大串44f994dd8fc1e10c9ed557824cae50d1586d0cb3就是版本id

　　  3. 强制push

　　　命令：git push -f origin master

# 【Git】pull遇到错误：error: Your local changes to the following files would be overwritten by merge:

首先取决于你是否想要保存本地修改。（是 /否）

**是**
别急我们有如下三部曲

    git stash  
    git pull origin master  
    git stash pop  

git stash的时候会把你本地快照，然后git pull 就不会阻止你了，pull完之后这时你的代码并没有保留你的修改。惊了！ 别急，我们之前好像做了什么？

STASH
这时候执行git stash pop你去本地看会发现发生冲突的本地修改还在，这时候你该commit push啥的就悉听尊便了。

**否**
既然不想保留本地的修改，那好办。直接将本地的状态恢复到上一个commit id 。然后用远程的代码直接覆盖本地就好了。

```
git reset --hard 
git pull origin master
```
