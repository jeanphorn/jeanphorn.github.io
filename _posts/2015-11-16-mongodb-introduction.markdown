---
layout:     post
title:      "MongoDB介绍以及在linux平台的安装使用" 
subtitle:   "MongoDB为面向文档存储的一种分布式的NoSQLog数据库，本文主要介绍他的特点，Linux平台的安装，及使用"
date:       2015-11-06 20:30:00
author:     "jeanphorn"
header-img: "img/in-post/post-mongo.png"
categories:
    - DataBase
tags:
    - Linux 
    - MongoDB
---


## 1. MongoDB简介

MongoDB 是由C++语言编写的，是一个基于分布式文件存储的开源数据库系统。在高负载的情况下，添加更多的节点，可以保证服务器性能。MongoDB 旨在为WEB应用提供可扩展的高性能数据存储解决方案。MongoDB 将数据存储为一个文档，数据结构由键值(key=>value)对组成。MongoDB 文档类似于 JSON 对象。字段值可以包含其他文档，数组及文档数组。

MongoDB主要特点：

- 提供面向文档存储，操作简单。
- 可以在MongoDB记录中设置任何属性的索引 (如：FirstName="Sameer",Address="8 Gandhi Road")来实现更快的排序。
- 分布式存储。 如果负载的增加（需要更多的存储空间和更强的处理能力） ，它可以分布在计算机网络中的其他节点上这就是所谓的分片。
- Mongo支持丰富的查询表达式。查询指令使用JSON形式的标记，可轻易查询文档中内嵌的对象及数组。
- 提供Map/Reduce操作。Map和Reduce。Map函数调用emit(key,value)遍历集合中所有的记录，将key与value传给Reduce函数进行处理。
- MongoDB支持各种编程语言:RUBY，PYTHON，JAVA，C++，PHP，C#等多种语言。

## 2. 下载安装MongoDB

根据自己的系统版本，去[MongoDB官网]( http://www.mongodb.org/downloads)下载对应版本源码包，我的是centos 32位版本，因此下载的版本如下图：
![download_mongo](http://img.blog.csdn.net/20151116190618963?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

Linux可以用一些命令直接下载：

```
{% highlight bash lineno %}
wget https://fastdl.mongodb.org/linux/mongodb-linux-i686-3.0.7.tgz
```

解压安装包，并放在合适的目录中。

--------

**注：** 由于我的系统空间有限，MongoDB程序以及之后创建的数据库，我都放到挂载的磁盘sdb上去了。磁盘挂载目录：/home/jeanphorn/workspace.

-------

```
{% highlight bash lineno %}
$ tar -zxvf  mongodb-linux-i686-3.0.7.tgz -C ./	
$ mv  mongodb-linux-i686-3.0.7 ~/workspace/software/mongodb

```

可以通过"~/workspace/mongodb/bin/mongo"运行bin目录下的mongo程序，但每次都这样这样太麻烦了，将bin目录添加到系统的PATH变量中。这里我在家目录下建立一个软连接链接到mongo的bin目录（直接添加PATH路径没有成功，推测是挂载磁盘的原因）。

```
{% highlight bash lineno %}
$ ln -sf /home/jeanphorn/workspace/software/mongodb/bin /home/jeanphorn/bin
$ export PATH=$PATH:/home/jeanphorn/bin

```

## 3. 启动和测试MongoDB

### 3.1 创建数据库目录

MongoDB的数据存储在data目录的db目录下，但是这个目录在安装过程不会自动创建，所以你需要手动创建data目录，并在data目录中创建db目录。这里我在MongoDB程序包的同目录下创建数据库目录：

```$ mkdir -p ~/workspace/software/mongodb/data/db ```

-----

注意：/data/db 是 MongoDB 默认的启动的数据库路径，如果需要指定别的路径，则使用"--dbpath"选项。

-----

### 3.2 启动MongoDB服务

用"--dbpath"选项，执行以下命令：

```

mongod --dbpath=/home/jeanphorn/workspace/software/mongodb/data/db

```

![server](http://img.blog.csdn.net/20151116201013689)

### 3.3 测试MongoDB

MongoDB Shell是MongoDB自带的交互式Javascript shell,用来对MongoDB进行操作和管理的交互式环境。当你进入mongoDB后台后，它默认会链接到 test 文档（数据库）：

启动mongodb shell：

![test-start](http://img.blog.csdn.net/20151116201706079)

插入一些简单的数据，并对插入的数据进行检索：

![test](http://img.blog.csdn.net/20151116201827224)
