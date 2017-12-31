---
layout:     post
title:      "Linux 查看串口情况" 
subtitle:   "查看Linux串口是否可以使用" 
date:       2015-05-08 15:28:00
author:     "jeanphorn"
header-img: "img/in-post/cat-linux.jpg"
categories:
    - linux
tags:
    - Linux 
    - 查看串口
---


## 1、描述
　　查看串口是否可用，可以对串口发送数据比如对com1口，echo lyjie126 > /dev/ttyS0
查看串口名称使用 ls -l /dev/ttyS* 一般情况下串口的名称全部在dev下面，如果你没有外插串口卡的话默认是dev下的ttyS* ,一般ttyS0对应com1，ttyS1对应com2，当然也不一定是必然的；
## 2. 查看方法

 - 查看串口驱动：cat /proc/tty/drivers/serial 
 - 查看串口设备：dmesg | grep ttyS*
