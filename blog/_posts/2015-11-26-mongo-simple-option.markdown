---
layout:     post
title:      "MongoDB简单基本操作 创建、删除、插入文档" 
permalink:   mongodb-simple-option
subtitle:   "本文主要介绍MongoDB的一些简单基本的操作，数据库的创建、删除和文档的插入。后续会有其他操作的介绍"
date:       2015-11-26 17:10:00
author:     "jeanphorn"
header-img: "img/in-post/post-mongo.png"
categories:
    - DataBase
tags:
    - Linux 
    - MongoDB
---

# 1. MongoDB 创建数据库

1). **语法**

MongoDB创建数据的格式如下：

> use DataBase_Name

如果数据库不存在则创建，否则切换到该数据库。

2). **实例**

使用"show dbs"命令查看当前MongoDB中的所有数据库。

>
> \>
> \>show dbs
> local  0.078GB
> \>
> 

使用use命令，创建数据库，并查看数据库列表。

> 
> \> use test
> switched to db test
> \>
> \>
> \> show dbs
> local  0.078GB
> \>
> 

刚创建的数据库并没有显示出来，没关系，我们插入一条数据就好了。

> 
> \>
> \>db.col.insert({"test":"test create db"})
> WriteResult({ "nInserted" : 1 })
> \>
> \>
> \>show dbs
> local  0.078GB
> test   0.078GB
> \>
> 

# 2. 删除数据库

1). **语法**

删除数据库的格式如下：

> db.dropDatabase()

命令时删除当前使用的数据库，使用"db"命令可查看当前使用的数据名称。

2). **实例**

首先我们创建一个数据库"dbToDelete"，并插入一条简单的数据。

> 
> \>use dbToDelete
> switched to db dbToDelete
> \>
> \>
> \> db.test.insert({"testdb":"to delete"})
> WriteResult({ "nInserted" : 1 })
> \>
> \> 
> \>show dbs
> dbToDelete  0.078GB
> local       0.078GB
> test        0.078GB
> \>
> 

执行删除命令，查看结果：

> 
> \>
> \>db.dropDatabase()
> { "dropped" : "dbToDelete", "ok" : 1 }
> \>
> \> show dbs
> local       0.078GB
> test        0.078GB
> \>
>

# 3. 插入文档

MongoDB的文档数据结构和json的格式类似，所有存储在集合中的数据都是BSON(Binary json)格式，它是一种二进制存储格式。

1). **语法**

使用insert()或者save()方法像集合中插入文档。语法格式如下：

> db.COLLECTION_NAME.insert(document)

2). **实例**

我们建一个个人信息的文档，然后将其插入person的集合中。

>
> \> 
> \>db.person.insert({
>    ... "nick name":"jeanphorn"
>    ... ,
>    ... "age":"26",
>    ... "university":"CUC",
>    ... "company":"qihoo360",
>    ... "url":"jeanphorn.github.io",
>    ... "description":"linux programmer, Software Development Engineer"
>    ... })
> WriteResult({ "nInserted" : 1 })
> \>
>

上面这个例子，如果person集合存在就直接写入其中，否则先创建然后再将文档写入person集合中。查看插入集合的数据：

>
> \>
> \>db.person.find()
> { "_id" : ObjectId("5656c351392ce9180d6e94c6"), "nick name" : "jeanphorn", "age" : "26", "university" : "CUC", "company" : "qihoo360", "url" : "jeanphorn.github.io", "description" : "linux programmer, Software Development Engineer" }
> \>
>

文档的内容可以定义为一个变量然后通过变量插入。

>
> 
> \>document=({
>    ... "nick name":"zhangsan"
>    ... ,
>    ... "age":"24",
>    ... "city":"Beijing",
>    ... "job":"builder",
>    ... "description":"lalala, kick ass"
>    ... })
> {
>    "nick name" : "zhangsan",
>    "age" : "24",
>    "city" : "Beijing",
>    "job" : "builder",
>    "description" : "lalala, kick ass"
> } 
> \> 
> \> db.person.insert(document)
> WriteResult({ "nInserted" : 1 })
> \>
>

插入文档也可以使用 db.col.save(document) 命令。如果不指定 _id 字段 save() 方法类似于 insert() 方法。如果指定 _id 字段，则会更新该 _id 的数据。
 
