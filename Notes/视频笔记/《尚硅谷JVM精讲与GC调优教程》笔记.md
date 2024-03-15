尚硅谷JVM精讲与GC调优教程（宋红康主讲，含jvm面试真题）2023-11-07

https://www.bilibili.com/video/BV1Dz4y1A7FB

实际录制时间 Java 17 还没出

# P1 教程介绍

# P2 JVM 与 GC 调优内容介绍

# P3 JVM 概述内容

## Java 存不存在内存溢出？内存泄漏？

垃圾收集机制为我们打理了很多繁琐的工作，大大提高了开发效率，但是，垃圾收集也不是万能的，懂得 JVM 内部的内存结构、工作机制，是设计高扩展性应用和诊断运行时间问题的基础，也是 Java 工程师进阶的必备能力。

## Java 发展的几个重大事件？

2000 年，JDK 1.3 发布，Java Hotspot Virtual Machine 正式发布，成为 Java 默认虚拟机。

2002 年，JDK 1.4 发布，古老的 Classic 虚拟机退出历史舞台。

2003 年年底，Java 平台的 Scala 正式发布，同年 Groovy 也加入了 Java 阵营。

2006 年，JDK 6 发布。同年，Java 开源并建立了 OpenJDK。顺理成章，HotSpot 虚拟机也成为了 OpenJDK 中的默认虚拟机。

2007 年，Java 平台迎来了新伙伴 Clojure。

2008 年，Oracle 收购了 BEA，得到了 JRockit 虚拟机。

2009 年，Twitter 宣布把后台大部分程序从 Ruby 迁移到 Scala，这是 Java 平台的又一次大规模应用。

2010 年，Oracle 收购了 Sun，获得了 Java 商标和最具价值的 HotSpot 虚拟机，此时，Oracle 拥有市场占用率最高的两次虚拟机 HotSpot 和 JRockit，并计划在未来对它们进行整合：HotRockit。JCP 组织管理：Java 语言。

2011 年，JDK 7 发布。在 JDK 1.7u4 中，正式启用了新的垃圾回收器 G1。

2017 年，JDK 9 发布。将 G1 设置为默认 GC，替代 CMS（被标记为 Deprecated）

同年，IBM 的 J9 开源，形成了现在的 Open J9 社区。

2018 年，Android 的 Java 侵权案判决，Google 赔偿 Oracle 计 88 亿美元

同年，JDK 11 发布，LTS 版本的 JDK，发布革命性的 ZGC，调整 JDK 授权许可

2019 年，JDK 12 发布，加入 RedHat 领导开发的 Shenandoah GC。

## JVM 的生命周期

**虚拟机的启动**

Java 虚拟机的启动是通过引导类加载器（bootstrap class loader）创建一个初始类（initial class）来完成的，这个类是由虚拟机的具体实现指定的。

**虚拟机的退出有如下的几种情况：**

- 某线程调用 Runtime 类或 System 类的 exit 方法，或 Runtime 类的 halt 方法，并且 Java 安全管理器也允许这次 exit 或 halt 操作。
- 程序正常执行结束
- 程序在执行过程中遇到了异常或错误而异常终止
- 由于操作系统出现错误而导致 Java 虚拟机进程终止

## 能否画出 JVM 架构图？

Class Files → 类加载器子系统（Class Loader Subsystem）

​							↕

运行时数据区（Runtime Data Area）

{ 线程共享的：方法区（Method Area）、堆（Heap）

线程私有的：程序计数器（Program Counter Register）、本地方法栈（Native Method Stack）、虚拟机栈（Java Virtual Machine Stack）}

↕							↕

执行引擎 ↔ 本地方法接口 ← 本地方法库

**面试题**

JVM 的组成？说说 Java 虚拟机的体系结构？

# P4 字节码文件的概述

# P5 字节码相关的面试题（上）

# P6 字节码相关的面试题（下）