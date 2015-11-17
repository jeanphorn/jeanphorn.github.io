---
layout:     post
title:      "ubutu系统日志配置 /var/log/messages" 
subtitle:   "ubutu下配置系统日志/var/log/messages, 配置/etc/syslog.conf" 
date:       2015-004-21 10:46:00
author:     "jeanphorn"
header-img: "img/in-post/cat-linux.jpg"
categories:
    - linux
tags:
    - Linux 
    - 系统日志配置
---

## 1. 问题描述
　　今天需要查看系统的日志文件，但却没有找到```/var/log/messages```这个文件。网上搜素资料，说是要配置```/etc/syslog.conf```。syslog采用可配置的、统一的系统登记程序，随时从系统各处接受log请求，然后根据/etc/syslog.conf中的预先设定把log信息写入相应文件中、邮寄给特 定用户或者直接以消息的方式发往控制台。
　　好吧，问题又来了。系统中依然没有```/etc/syslog.conf```，经过一番搜素，最后得到的结论是：在Ubuntu下对应的应该是/etc/rsyslog.conf和rsyslogd。
## 2. 解决方案
　　关于syslog.conf文件和syslog.d下文件功能解释可以参考下面这篇文章：
　　http://blog.csdn.net/jeanphorn/article/details/45166633
　　通过查看rsyslog.conf文件，发现所有的配置文件都在```/etc/rsyslog.d/```文件夹下。
　　

> \#  /etc/rsyslog.conf    Configuration file for rsyslog.
>\#
> \#                       For more information see
>\#                       /usr/share/doc/rsyslog-doc/html/rsyslog_conf.html
>\#
>\#  Default logging rules can be found in /etc/rsyslog.d/50-default.conf
> ... ...
> \#
> \# Include all config files in /etc/rsyslog.d/
> \#
>     $IncludeConfig /etc/rsyslog.d/*.conf
　　

　　用vim打开```/etc/rsyslog.d/50-default.conf```文件增加一行内容如下：
　　```*.info;mail.none;authpriv.none;cron.none        /var/log/messages```
　　![conf](http://img.blog.csdn.net/20150421104033262?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvSmVhbnBob3Ju/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
　　重启系统，再来查看系统日志，发现已经okay了！！！ ^_^
　　![msg](http://img.blog.csdn.net/20150421104346842?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvSmVhbnBob3Ju/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
　　
