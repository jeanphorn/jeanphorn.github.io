---
layout:     post
title:      "Linux下Mysql安装与操作及字符集设置 C语言版" 
subtitle:   "linux mywql数据库的安装以及字符集设置，c语言操作实例" 
date:       2015-04-16 08:49:00
author:     "jeanphorn"
header-img: "img/in-post/cat-linux.jpg"
categories:
    - linux
tags:
    - Linux 
    - mysql
---

## 一、C语言 Mysql操作

1. 首先安转libmysql库。

```# sudo apt-get install libmysql++-dev```
2.  把MySQL的库拷贝到公共库中。
``` # sudo cp -ri /usr/lib/mysql/* /usr/lib/```
3. 配置MySQL库。
```# mysql_config --cflags --libs```
## 二、创建数据库和表
1. 启动终端，输入以下命令，进入mysql。
``` # mysql -u username -p ```

2. 创建一个数据库。
``` mysql > create database TemWet;```
![db](http://img.blog.csdn.net/20150416082419066)

3. 创建数据表monitor,sensers，并插入测试数据。
```
mysql> use TemWet
Database changed
mysql> create table monitor
    -> (
    -> Id int not null,
    -> monitor_name varchar(50),
    -> monitor_com varchar(50),
    -> primary key(Id)
    -> );
Query OK, 0 rows affected (0.10 sec)
```
## 三、编写c程序测试
c连接操作数据库代码示例：
	

```

#include <mysql/mysql.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static char* server_groups[]={"embedded","server","this_program_server",(char*)NULL};

int main(){

	MYSQL mysql;
	MYSQL_RES *res;
	MYSQL_ROW row;
	char sqlcmd[200];
	int t,r;
	mysql_init(&mysql);//初始化MYSQL标识符，用于连接
	if(!mysql_real_connect(&mysql,"localhost","root","root","sensers",0,NULL,0)){
	  fprintf(stderr,"无法连接到数据库，错误原因是:%s/n",mysql_error(&mysql));

	}
	else {
		 puts("数据库连接成功");
		//首先向数据库中插入一条记录
		//sprintf(sqlcmd,"%s","insert into friends (name,telephone) Values ('xx','xx')");
		 //mysql_query(&mysql,sqlcmd);
		 sprintf(sqlcmd,"%s","set names utf8;");
		 t=mysql_real_query(&mysql,sqlcmd,(unsigned int)strlen(sqlcmd));
		 sprintf(sqlcmd,"%s","select * from senser;");
		 t=mysql_real_query(&mysql,sqlcmd,(unsigned int)strlen(sqlcmd));
	
		 if(t){
			 printf("查询数据库失败%s/n",mysql_error(&mysql));
		}
		else {
			res=mysql_store_result(&mysql);//返回查询的全部结果集
			while(row=mysql_fetch_row(res)){//mysql_fetch_row取结果集的下一行
			 for(t=0;t<mysql_num_fields(res);t++){//结果集的列的数量
			  printf("%s\t",row[t]);
			 }
		 printf("\n");
		 int wet = atoi(row[2]);
		 printf("%d\n",wet);
		}
		
		mysql_free_result(res);//操作完毕，查询结果集
		}
		mysql_close(&mysql);//关闭数据库连接

	}

mysql_library_end();//关闭MySQL库

return EXIT_SUCCESS;
}

```

编译c文件：

```# gcc sqltest.c -o sqltest -lmysqlclient```

编译成功，执行成功.
![suc](http://img.blog.csdn.net/20150416083819327)

## 四、字符集设置

插入一条带中文的数据，但是却出现了中文乱码的问题。这应该是数据库的字符编码问题了。
![lm](http://img.blog.csdn.net/20150416084413123)

解决方案：
修改MySQL的配置文件/etc/mysql/my.cnf
![fa](http://img.blog.csdn.net/20150416084332654)

保存，并重新启动mysql服务。
查看数据库的字符集：```mysql> show variables like 'character_set_%';```
![cs](http://img.blog.csdn.net/20150416084607768)

删除之前的数据库数据表，重新建立，并插入数据，完美支持中文。
![zw](http://img.blog.csdn.net/20150416084543491)

