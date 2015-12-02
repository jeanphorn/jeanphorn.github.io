---
layout:     post
title:      "MongoDB更新文档，修改字段和变量使用" 
subtitle:   "本文主要介绍MongoDB文档更新，文档中记录字段名称和和值得修改，增加字段。update()的使用方式，以及变量的访问方式介绍"
date:       2015-12-02 18:15:00
author:     "jeanphorn"
header-img: "img/in-post/post-mongo.png"
categories:
    - DataBase
tags:
    - Linux 
    - MongoDB
---

## 1. MongoDB更新文档

MongoDB更新文档的方法主要有两个，update()和save()。

## 2. update()方法

### 2.1 格式说明
update()方法适合更新MongoDB中已存在的集合，格式如下：

```
db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)

```

参数描述：

- **query**: 更新查询的条件，类似sql中update中的where语句。
- **update**: 更新的对象和操作。
- **upsert**: 可选，更新对象如果不存在是否插入，true表示插入，默认false，不插入。
- **multi**： 可选，是否更新所有的查找到的对象，默认false。
- **writeConcern**: 可选，抛出异常的级别。

### 2.2 修改字段值

继续上一篇的例子，先查看一下当前"test"数据库中"person"集合的数据。

> \> 
> \>db.person.find()
> { "_id" : ObjectId("5656c351392ce9180d6e94c6"), "nick name" : "jeanphorn", "age" : "26", "university" : "CUC", "company" : "qihoo360", "url" : "jeanphorn.github.io", "description" : "linux programmer, Software Development Engineer" }
> { "_id" : ObjectId("5656c5e6392ce9180d6e94c7"), "nick name" : "zhangsan", "age" : "24", "city" : "Beijing", "job" : "builder", "description" : "lalala, kick ass" }
> \>
>

下面对person对象的description字段进行更新.

>
> \>db.person.update({"nick name":"zhangsan"}, {$set:{"description": "I love Lisi"}}
> ... )
> WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> \>
> \>db.person.find().pretty()
>{
>    "_id" : ObjectId("5656c351392ce9180d6e94c6"),
>    "nick name" : "jeanphorn",
>    "age" : "26",
>    "university" : "CUC",
>    "company" : "qihoo360",
>    "url" : "jeanphorn.github.io",
>    "description" : "linux programmer, Software Development Engineer"
>}
>{
>    "_id" : ObjectId("5656c5e6392ce9180d6e94c7"),
>    "nick name" : "zhangsan",
>    "age" : "24",
>    "city" : "Beijing",
>    "job" : "builder",
>    "description" : "I love Lisi"
>}
> \>
>

以上语句只能更新查询到的第一条记录，如果要更新全部符合条件的记录则要设置"multi"为true。

```
db.person.update({"nick name":"zhangsan"}, {$set:{"descpription": "I love Lisi"}}, {multi:true})


```

### 2.3 修改字段名称

有时候对于集合中命名不太规范或者纯粹想改一下集合中字段的名称，也可以使用update()进行修改。例如上例中person集合中的"nick name".

>
> \> var document=db.person.find({"nick name": "zhangsan"})
> \>
> \>document[0]
> {
>    "_id" : ObjectId("5656c5e6392ce9180d6e94c7"),
>    "nick name" : "zhangsan",
>    "age" : "24",
>    "city" : "Beijing",
>    "job" : "builder",
>    "description" : "I love Lisi"
> }
> \>
> \> document[0]._id
> ObjectId("5656c5e6392ce9180d6e94c7")
> \>document[0].age
> 24
> \>
> \> document[0].nick name
> 2015-12-02T17:14:25.847+0800 E QUERY    SyntaxError: Unexpected identifier
> \>
>

"nick name"这个字段在此处就不大好了(当然了，也可以使用document[0]["nick name"]的方式访问！这里只为说明如何修个一个字段的名称)，使用如下命令为其重命名：

>
> \> db.person.update({}, {$rename:{"nick name":"nick_name"}}, false, true)
> WriteResult({ "nMatched" : 2, "nUpserted" : 0, "nModified" : 2 })
> \>
> \>
> \>db.person.find()
> { "_id" : ObjectId("5656c351392ce9180d6e94c6"), "age" : "26", "university" : "CUC", "company" : "qihoo360", "url" : "jeanphorn.github.io", "description" : "linux programmer, Software Development Engineer", "nick_name" : "jeanphorn" }
> \>
> 

### 2.4 给一条记录增加字段

查找到相应的记录，然后使用set操作直接添加即可。

```
db.person.update({"nick_name":"zhangsan"},{$set:{"hoby":"jumping"}},false,true)

```
false：表示没有查到结果的不插入。
true：如果查到多条结果全部更新。

## 3. save()方法

save()的方法是以新的文档来代替旧的文档。语法格式如下：

```
db.collection.save(
   <document>,   //文档数据
   {
     writeConcern: <document>  //可选，抛出异常的级别。
   }
)

```

使用以下语句查找昵称为"zhangsan"的人，并把结果保存到document变量中。

> 
> \> var document = db.person.find({"nick_name":"zhangsan"})
> \>
> \>document[0]
> {
>    "_id" : ObjectId("5656c5e6392ce9180d6e94c7"),
>    "age" : "24",
>    "city" : "Beijing",
>    "job" : "builder",
>    "nick_name" : "zhangsan",
>    "description" : "I love Lisi"
> }
> \>
>

把age变为28。

> \> 
> \>document[0]["age"] = 28
> 28
>  

将document保存到集合中，并查看结果。

> \> document[0]
> {
>     "_id" : ObjectId("5656c5e6392ce9180d6e94c7"),
>     "age" : 28,
>     "city" : "Beijing",
>     "job" : "builder",
>     "nick_name" : "zhangsan",
>     "description" : "I love Lisi"
> }
> \> 
> \> 
> \> db.person.save(document[0])
> WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> \> 
> \> 
> \> db.person.find()
> { "_id" : ObjectId("5656c351392ce9180d6e94c6"), "age" : "26", "university" : "CUC", "company" : "qihoo360", "url" : "jeanphorn.github.io", "nick_name" : "jeanphorn", "description" : "linux programmer, Software Development Engineer" }
> { "_id" : ObjectId("5656c5e6392ce9180d6e94c7"), "age" : 28, "city" : "Beijing", "job" : "builder", "nick_name" : "zhangsan", "description" : "I love Lisi" }
> \>
>
 
