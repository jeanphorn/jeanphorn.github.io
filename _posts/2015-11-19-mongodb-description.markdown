---
layout:     post
title:      "MongoDB基本概念解析" 
subtitle:   "MongoDB的基本元素主要有数据库、文档、集合、元数据等，文章主要介绍他们的含义以及简单的使用方式"
date:       2015-11-19 19:20:00
author:     "jeanphorn"
header-img: "img/in-post/post-mongo.png"
categories:
    - DataBase
tags:
    - Linux 
    - MongoDB
---

## 1. mongodb 基本概念

mongo基本的概念包括数据库、文档、集合。以下分别予以介绍。

### 1.1 数据库

一个mongodb可以建立多个数据库，每一个都有自己独立的目录和权限，不同的数据库放在不同的文件中。使用"show dbs"可以显示所有的数据库列表。

> 
> \>mongo
> MongoDB shell version: 3.0.7
> connecting to: test
> \> 
> \> show dbs
local  0.078GB
test   0.078GB
> \>
> 

执行"db"可以显示当前正在使用的数据库。

> 
> \> db
> test
> \>
> 

"use"可以连接到指定数据库。

> 
> \>use local
> switched to db local
> \>
> \>
> 

-------
**注意**
数据库命名要符合以下条件：

- 不能是空串
- 不能含有' ', ., \$, \/等特殊字符串
- 全部小写
- 最多64字节

-------

### 1.2 文档

文档是mongodb中的最核心的概念，我们可以把它当做关系型数据库的一行的概念。多个键和它关联的值合在一起就是文档。MongoDB使用BSON结构来储存和交换数据（BSON可以理解为在JSON基础上添加了以下json不支持的数据类型），通常object就是指的文档，下面是一个文档的例子：

> {site:"jeanphorn.github.io"}

需要留意的地方：

- 文档的键/值是有序的
- 文档的值除了字符串，还可以是其他类型的数据结构（set，嵌套）
- MongoDB区分类型和大小写
- MongoDB不允许有重复的键


### 1.3 集合

集合是一组文档的组合，如果把文档比作mysql中的行，那么集合就是mysql中的表。在MongoDB中集合是无模式的，存入集合的文档可以是不同的结构，例如下面的两个文档是可以存入同一个集合的。

> 
> {name: "jeanphorn"}
> {name: "jeanphorn", university: "cuc"}
> 

当第一个文档插入时，集合就被创建了。

> 
> \> 
> \>db.jeanphorn.insert({name: "jeanphorn"})
> WriteResult({ "nInserted" : 1 })
> \>db.jeanphorn.insert({name: "jeanphorn", university: "cuc"})
> WriteResult({ "nInserted" : 1 })
> \>
> \>db.jeanphorn.find()
> { "_id" : ObjectId("564da531f114824ae7b8138a"), "name" : "jeanphorn" }
> { "_id" : ObjectId("564da54df114824ae7b8138b"), "name" : "jeanphorn", "university" : "cuc" }
> \>
> 

### 1.4 元数据

数据库的信息存储在集合中，使用系统的命名空间"dbname.sytem.*"。

|集合命名空间|描述|
|:--------------|:----------|
|dbname.system.namespaces|列出所有命名空间|
|dbname.system.index|索引|
|dbname.system.profile|数据库概要信息|
|dbname.system.users|列出可访问数据库的用户|
|dbname.system.sources|包含slave服务器信息状态|

### 1.5 数据类型

下表是对MongoDB数据类型的相关描述。


|集合命名空间|描述|
|:--------------|:----------|
|String|在 MongoDB 中，UTF-8 编码的字符串才是合法的。|
|Integer|整型数值。根据服务器，可分为 32 位或 64 位。|
|Boolean|布尔值|
|Double|双精度值|
|Min/Max keys|将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。|
|Arrays|用于将数组或列表或多个值存储为一个键。|
|Timestamp|时间戳。记录文档修改或添加的具体时间。|
|Object|用于内嵌文档。|
|Null|用于创建空值|
|Symbol|符号。该数据类型基本上等同于字符串类型|
|Date|日期时间。用 UNIX 时间格式来存储当前日期或时间。|
|Object ID|对象 ID。用于创建文档的 ID|
|Binary Data|二进制数据。|
|Code|代码类型。用于在文档中存储 JavaScript 代码。|
|Regular expression|正则表达式类型。用于存储正则表达式。|


## 2. 例子

这里引用runoob网上的一个例子可以更形象的理解MongoDB。

![showMongo](http://img.blog.csdn.net/20151119190520805)
