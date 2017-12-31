---
layout:     post
title:      "Linux 多线程之线程属性解析" 
subtitle:   "linux多线程编程，除了使用默认的线程创建方式外，还可以对线程的属性进行调整，包括线程优先级，运行栈，线程分离状态等。"
date:       2015-11-25 15:30:00
author:     "jeanphorn"
header-img: "img/in-post/cat-linux.jpg"
categories:
    - linux
tags:
    - linux 
    - 多线程
---

## 1. 线程属性的结构

一般情况来说，当我们需要使用多线程时直接调用pthread_create()函数的默认参数即可满足我们的需求，但有些时候我们也需要调整线程的属性。线程的属性结构为pthread_attr_t，<pthreadtypes.h>中定义>，原型如下：

```
typedef struct __pthreat_attr_s
{
  int   __detchstate;                   //终止状态
  int   __schedpolicy;                  //调度优先级
  struct __schedparam   __schedparam;   //参数
  int   __inheritsched;                 //继承
  int   __scope;                        //范围
  size_t __guardsize;
  int   __stackaddr_set;                //运行栈
  void  *__stackaddr;                   //线程运行栈地址
  size_t __stacksize;
}pthread_attr_t;

```

线程的属性不能直接设置，而是要通过相关的函数操作类进行设置。线程属性的初始化工作由pthread_attr_init()函数完成，且必须在pthread_create()调用前被调用。线程的属性对象主要包括分离状态，优先级，运行的栈地址以及栈地址的大小。

## 2. 线程的优先级

线程的优先级属于常用设置，存放在sched_param结构体中。其操作方式有两个函数控制，pthread——attr_getschedparam()获得线程的优先级设置，然后对需要设置的参数修改优先级，再由pthread_attr_setschedparam()写回去。这是对复杂结构进行设置的通用方法，防止因设置不当造成不可预料的后果。结构体sched_param定义在头文件sched.h中。

```
#include <pthread.h>
#include <sched.h>

struct shedparam sch;
pthread_t pt;
pthread_attr_t attr;

pthread_attr_init(&attr);
pthread_attr_getschedparam(&attr, &sch);
sch.sched_priority = 256;       //重新设置优先级
pthread_attr_setschedparam(&attr,&sch);

```

## 3. 线程的分离状态

线程的分离状态决定线程的终止方法，有分离线程和非分离线程两种，默认为非分离线程。这种情况下，需要等待线程的结束，只有当pthread_join()函数返回时，线程才会终止并且释放线程创建的时候系统分配的资源。分离线程不用其他线程等待，当线程执行完毕就自行结束并释放掉资源。设置线程状态的函数为：

```
int pthread_attr_setdetachstate(pthread_attr_t *attr, int detachstate);

```

detachstate有两种：PTHREAD_CREATE_DETACHED设置分离线程，PTHREAD_CREATE_JOINABLE设置非分离线程。当一个线程为分离线程时，如果线程运行的非常快，可能在pthread_create()返回之前就终止。


## 4. 示例说明

先看如下一段代码：

```
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <sched.h>

pthread_t pt1, pt2;
pthread_attr_t attr;

void *thread_fun1(void *arg)
{
    int cnt = 5;
    while(cnt--)
    {
        printf("thread one counting: %d\n", cnt);
        sleep(2);
    }
}

void *thread_fun2(void *arg)
{
    int cnt = 5;
    while(cnt--)
    {
        printf("thread two counting: %d\n", cnt);
        sleep(1);
    }
    
}

int main()
{
    struct sched_param sch;
    pthread_attr_init(&attr);
    
    pthread_attr_getschedparam(&attr, &sch);
    sch.sched_priority = 256;
    pthread_attr_setschedparam(&attr, &sch);
    printf("priority: %d\n", sch.sched_priority);

    /*代码块一*/
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    pthread_create(&pt1, &attr, thread_fun1, NULL);
    sleep(3);
   
    /*代码块二*/
    // pthread_create(&pt2, NULL, thread_fun2, NULL);
    //pthread_join(pt2, NULL);

    return 0;
}

```

首先看代码块一，以分离的方式运行线程，则不等子线程运行完毕, 主线程执行结束并强制退出了子线程。如果是运行代码块二，则要等待子线程结束运行结束后才继续pthread_join()之后的代码_join()之后的代码。
