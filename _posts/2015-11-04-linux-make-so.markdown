---
layout:     post
title:      "Linux 静态和动态链接库的使用 dlopen()加载动态库文件"
subtitle:   "生成和使用.a  .so文件，动态加载so文件"
date:       2015-11-04
author:     "jeanphorn"
header-img: "img/post-bg-dlopen.jpg"
tags:
    - Linux
    - dlopen
    - dlsys
    - 静态链接库
    - 动态链接库
---

##1.  静态链接库	
　　静态库是obj文件的集合，一般以“.a”为后缀。静态库的有点事可以不用重新编译源程序，直接进行程序的重新链接，节省编译时间。开发者可以提供库文件而不用开放源代码。
　　命令：
　　``` $ar -rcs obj文件1 obj文件2```
　　例如我们编写一个string.cc的文件，里面定义了一个求字符串长度的函数。
　　

```c++
#define END '\0'

int my_strlen(char *str)
{
    int len = 0;
    while( *str++ != END)
    {   
        len ++; 
    }   
    return len;
}
```
　　用如下命令生产静态库文件：
　　``` 
　　$ c++ -c string.cc
　　$ ar -rcs libstr.a string.o ```

　　编写一个测试文件test.cc，内容如下：
　　

```
#include <stdio.h>

extern int my_strlen(char *str);

int main()
{
    char str[] = "hello, jeanphorn!";
    printf("%d\n", my_strlen(str));
    return 0;
}
```

　　编译命令： ```c++ -o test test.cc libstr.a```或者```c++ -o test test.cc -L./ -lstr```

##2. 生成和使用动态链接库
　　动态链接库是程序运行时加载。生成动态链接库使用"-fpic"选项，例如：```c++ -shared -fpic -o libstr.so string.cc```。动态库不能随意使用，需要在程序运行时制定系统的动态库搜素路径，让系统找到所需要的动态库。系统的配置文件"/etc/ld.so.conf"是动态库的搜索路径配置文件。
　　动态库管理命令ldconfig。
　　ldconfig的作用是在系统默认搜索路径和动态链接库配置文件和中所列出的目录里搜索动态库，创建动态链接装入程序需要的链接和缓存文件。搜索完毕后将结果写入到缓存文件/etc/ld.so.cache中。

　　使用动态链接库。
　　编译程序时使用动态库和使用静态库是一致的，使用"-l库名"的方式。
　　```c++ -o test test.cc -L./ -lstr```
　　但是要想正确运行test程序，还需要一步：将动态库文件放到程序搜素路径中。可以将libstr.so文件拷贝到/usr/lib等系统库路径中或者使用类似于下面这条命令：
	　```export LD_LIBRARY_PATH=/home/***/test/linux_network_program/lib_test```


##3. 加载动态库
　　动态加载库主要的函数有dlopen(), dlerror(), dlsym()和dlclose()。
　　dlopen()，按照用户指定的方式打开动态库。原型：```void * dlopen(const char * filename, int flag)```。 filename为动态库的名，flag打开方式，一般为“RTLD_LASY”。函数返回值为库的指针。
　　dlsym()获取函数指针。
　　例子：
　　

```
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

typedef int (*My_strlen)(char *str);

int main()
{
    char str[] = "hello, jeanphorn!";
    void *phandle = NULL;


    phandle = dlopen("./libstr.so", RTLD_LAZY);
    if(!phandle) 
        printf("Load library failed.\n");
    
    char *perr = dlerror();
    if(perr != NULL)
    {   
        printf("%s\n",perr);
        return 0;
    }   

    My_strlen my_strlen = (My_strlen)dlsym(phandle, "my_strlen");
    
    perr = dlerror();
    if(perr != NULL)
    {   
        printf("%s\n",perr);
        return 0;
    }   
    printf("%d\n", my_strlen(str));

    dlclose(phandle);
    return 0;
}
```

　　编译: ```c++ -o loadso loadso.cc libstr.so -ldl```
　　编译后直接运行是不行的，因为dlsym()函数是c语言函数形式。在底层编译器gcc和c++编译情况是不同的。在string.cc文件上做如下改动：
　　

```
#define END '\0'

#ifdef __cplusplus
extern "C"{
#endif

int my_strlen(char *str)
{
    int len = 0;
    while( *str++ != END)
    {   
        len ++; 
    }   
    return len;
}

#ifdef __cplusplus
}
#endif
```
　　重新编译生产so库就好了。
