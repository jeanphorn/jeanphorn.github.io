---
layout:     post
title:      "Linux 多线程编程" 
subtitle:   "linux多线程编程，使用phread_create()函数创建新的线程，各参数的含义，以及pthread_join()等待线程结束。"
date:       2015-11-24 19:20:00
author:     "jeanphorn"
header-img: "img/in-post/cat-linux.jpg"
categories:
    - linux
tags:
    - linux 
    - 多线程
---

## 1. Linux 多线程介绍

线程的概念早在上世纪60年代就被提出，知道上世纪80中期才被真正使用起来。Solaris是线程使用的先驱，在传统的UNIX系统中,一个线程就对应一个进程，多线程类似于多进程，线程的左右没有得到很好地发挥。现在多线程技术已经得到广泛的使用，与多进程相比，它具有的有点主要有：

- 系统资源消耗低
- 执行速度快
- 线程间的数据共享相比进程更加容易

Linux 系统下的多线程遵循POSIX标准，叫做pthread（可以用"man pthread"命令查看更详细的信息），编写Linux下的多线程程序需要包含"pthread.h"头文件，在编译的时候还需要加上"-lpthread"的链接选项。

## 2. 线程创建函数 pthread_create()

该函数负责创建出一个新的线程，当pthread_create()函数调用时，传入的参数有线程属性、线程函数、线程函数变量，用于生成一个某种特性的线程来执行线程函数。其函数原型为：

```
int pthread_create(pthread_t *thread,                   //线程标识符
                   pthread_attr_t *attr,                //线程属性，一般情况下置NULL
                   void *(*start_routine)(void *),      //函数指针
                   void *arg);                          //线程间传递参数

```

- **thread**: 用于标识一个线程，是一个pthread_t类型的变量，定义原型为"typedef unsigned long int phread_t"
- **attr**: 用于设置线程属性，可设置为NULL，使用默认属性
- **start_routine**: 线程资源分配成功后，线程中所运行的我单元，一般是自定义的线程函数。
- **arg**: 线程运行时传入的参数

当线程创建成功后，函数返回0，否则说明线程创建失败。之后，新创建的线程按照参数start_routine和arg确定一个运行函数，原来的线程继续执行下一行代码。

## 3. 线程结束函数 pthread_join()和phread_exit()

pthread_join()函数用来等待一个线程的结束，这个函数是阻塞函数，一直到被等待的线程结束为止，函数才返回并且收回被等待线程的资源。函数原型：

```
extern int pthread_join __p((pthread_t __th, void ** __thread_return));

```

- **__th**: 线程标识符，就是pthread_create()创建成功后的返回值。
- **__thread_return**: 线程返回值，是一个指针，用来存储被等待线程的返回值。

线程函数的结束方式有两种。

1. 线程函数运行完毕，自行结束，不返回结果。
2. 通过pthread_exit()函数退出，传出返回结果。

## 4. 示例

```

#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

static int run = 1;
static int retVal;

void *thread_func(void* arg)
{
    int *running = (int *)arg;

    while(*running)
    {
        printf("Sub thread is running...\n");
        usleep(1);
    }

    printf("Exit sub thread.\n");

    retVal = 8;
    pthread_exit( (void *) &retVal);   //exit the sub thread & capture the return val
}

int main()
{
    pthread_t pt;
    int ret = -1,times = 5;
    
    ret = pthread_create(&pt, NULL, thread_func, &run);  //create sub thread
    if(ret != 0)
    {
        printf("Start main thread failed.!");
        return 1;
    }

    for(int i = 0; i < times; i++)
    {
        printf("Main thread is running...\n");
        usleep(1);
    }

    run = 0; // to stop sub thread
    
    int *ret_join;
    pthread_join(pt, (void**)&ret_join);
    printf("Sub thread return value is: %d\n", *ret_join);

    return 0;
}

```

编译："g++ thread_test.cc -o thread_test -lpthread"
