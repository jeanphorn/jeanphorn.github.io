---
layout:     post
title:      "谷歌第二代深度学习系统\"TensorFlow\"首解密"
subtitle:   "Large-Scale Deep Learning for Building Intelligent Computer Systems"
date:       2015-11-06 18:30:00
author:     "jeanphorn"
header-img: "img/in-post/post-tensorflow.jpg"
tags:
    - deep learning 
    - 深度学习
    - TensorFlow
---

# 1. 背景
Google资深系统专家Jeff Dean在最近的湾区机器学习大会做了 Large-Scale Deep Learning for Inelligent Computer Systems 的演讲。

"Over the past few years, we have built large-scale computer systems for training neural networks and then applied these systems to a wide variety of problems that have traditionally been very difficult for computers. We have made significant improvements in the state-of-the-art in many of these areas and our software systems and algorithms have been used by dozens of different groups at Google to train state-of-the-art models for speech recognition, image recognition, various visual detection tasks, language modeling, language translation, and many other tasks. In this talk, Google Senior Fellow Jeff Dean highlights some of the distributed systems and algorithms that Google uses in order to train large models quickly. He also discusses ways Google has applied this work to a variety of problems in its products, usually in close collaboration with other teams.

Jeff Dean, senior fellow, Google Knowledge Group

02/26/2015"

【Jeff Dean】在过去的几年间，我们已经建立了两代用于训练和部署神经网络的计算机系统，并且将这些系统应用于解决很多在传统上来说对计算机而言很难的问题。我们对许多这些领域的最新技术做了很大的改进，我们的软件系统和算法已经被Google的很多小组采用，运用在语音识别、图像识别、视觉检测任务、语言建模、语言翻译和许多其它任务的模型训练上。**在这次讲演中，我会介绍我们从第一代分布式训练系统中得到的经验教训，并讨论在设计第二代系统时的一些选择。**然后我会讨论一下我们将通过哪些方式把它运用到Google的大量产品上，在这方面通常我们会与其他小组有密切的合作。

[Google 资深专家Jeff Dean 关于深度学习 TensorFlow演讲视频："Large-Scale Deep Learning for Building Intelligent Computer Systems.mp4"下载](http://vdisk.weibo.com/s/zTp6HtYlPosqi)

# 2. 概述
第一代系统DistBeliet在可扩缩性上表现很好，但在用于研究时灵活性达不到预期。对问题空间的更深理解让我们可以做出一些大幅度的简化。

这也是第二代系统的研发动机，用 TensorFlow 表达高层次的机器学习计算。它是C++语言编写的核心，冗余少。而不同的前端，现有Python和C++前端，添加其他语言的前端也不是难题。

在2015年10月5日，谷歌为TensorFlow提交了注册商标申请（登记编号86778464），这样描述它：

1.用以编写程序的计算机软件；

2.计算机软件开发工具；

3.可应用于人工智能、深度学习、高性能计算、分布式计算、虚拟化和机器学习这些领域；

4.软件库可应用于通用目的的计算、数据收集的操作、数据变换、输入输出、通信、图像显示、人工智能等领域的建模和测试；

5.软件可用作应用于人工智能等领域的应用程序接口（API）。

