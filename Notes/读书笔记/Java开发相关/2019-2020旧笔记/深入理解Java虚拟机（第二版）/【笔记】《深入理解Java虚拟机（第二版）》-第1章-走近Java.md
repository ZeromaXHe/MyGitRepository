# 第1章 走近Java

## 1.1 概述

“一次编写到处运行”	安全的内存管理和访问机制	热点代码检测和运行时编译及优化	应用程序接口

## 1.2 Java技术体系

广义上讲，Clojure、JRuby、Groovy等运行于Java虚拟机上的语言及其相关的程序都属于Java技术体系中的一员。传统意义上来看，Sun官方所定义的Java技术体系包括以下几个组成部分：

- Java程序设计语言
- 各种硬件平台上的Java虚拟机
- Class 文件格式
- Java API 类库
- 来自商业机构和开源社区的第三方Java类库

Java程序设计语言、Java虚拟机、Java API 类库这三部分统称为JDK（Java Development Kit），JDK是用于支持Java程序开发的最小环境。可以把Java API类库中的Java SE API子集和Java虚拟机这两部分统称为JRE（Java Runtime Environment）,JRE是支持Java程序运行的标准环境。

![1555978664462](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\1555978664462.png)

Java技术体系可以分为4个平台，分别为：

- Java Card：支持一些Java小程序（Applet）运行在小内存设备（如智能卡）上的平台。
- Java ME（Micro Edition）：支持Java程序运行在移动终端（手机、PDA）上的平台，对Java API 有所精简，并加入了针对移动终端的支持，这个版本以前称为J2ME。
- Java SE（Standard Edition）：支持面向桌面级应用（如Windows下的应用程序）的Java平台，提供了完整的Java核心API，这个版本以前称为J2ME。
- Java EE（Enterprise Edition）：支持使用多层架构的企业级应用（如ERP、CRM应用）的Java平台，除了提供Java SE API外，还对其做了大量的补充并提供了相关的部署支持，这个版本以前称为J2EE。

## 1.3 Java发展史

1991年4月	James Gosling博士	绿色计划（Green Project）

1995年5月23日	Oak语言改名为Java	正式发布Java 1.0 	“Write Once，Run Anywhere”

1996年1月23日	JDK 1.0发布	代表技术：Java虚拟机、Applet、AWT等

1996年5月底	首届JavaOne大会

1997年2月19日	JDK 1.1	代表技术：JAR文件格式、JDBC、JavaBeans、RMI、Java语法也有了一定的发展，如内部类（Inner Class）和反射（Reflection）都是这个时候出现的。

1998年12月4日	JDK 1.2	工程代号Playground（竞技场）	这个版本把Java技术体系拆分成J2SE、J2EE和J2ME	代表技术：EJB、Java Plug-in、Java IDL、Swing等，第一次内置了JIT（Just In Time）编译器（JDK 1.2中曾并存过3个虚拟机，Classic VM、HotSpot VM 和 Exact VM，其中Exact VM只在Solaris平台出现过；后面两个虚拟机都是内置JIT编辑器的）。在语言和API级别上，Java添加了strictfp关键字与现在Java编码之中极为常用的一系列Collection集合类。

1999年4月27日	HotSpot虚拟机发布

2000年5月8日	JDK 1.3	工程代号Kestrel（美洲红隼）	改进一些类库（如数学运算和新的Timer API等），JNDI服务从JDK 1.3开始被作为一项平台级服务提供（以前JNDI仅仅是一项扩展），使用COBRA IIOP来实现RMI的通信协议，等等。这个版本还对Java 2D做了很多改进，提供了大量新的Java 2D API，并且新添加了JavaSound类库。

2002年2月13日	JDK 1.4	工程代号为Merlin（灰背隼）	Java真正走向成熟的一个版本	技术特性：正则表达式、异常链、NIO、日志类、XML解析器和XSLT转换器等。

2002年前后，.NET Framework发布

2004年9月30日	JDK 1.5	工程代号Tiger（老虎）	在Java语法易用性上做出了非常大的改进。例如，自动装箱、泛型、动态注解、枚举、可变长参数、遍历循环（foreach循环）等语法特性都是在JDK 1.5中加入的。这个版本改进了Java的内存模型（Java Memory Model，JMM）、提供了java.util.concurrent并发包等。

2006年12月11日	JDK 1.6	工程代号Mustang（野马）	这个版本终结了JDK 1.2开始已有8年历史的J2EE、J2SE、J2ME的命名方式，启用Java SE 6、Java EE 6、Java ME 6的命名方式。	改进包括：动态语言支持（内置Mozilla JavaScript Rhino引擎实现）、提供编译API和微型HTTP服务器API等。同时这个版本对Java虚拟机内部做了大量改进，包括锁与同步、垃圾手机、类加载等方面算法都有相当多的改动。

2006年11月13日的JavaOne大会上	Sun公司宣布最终会将Java开源。

2009年2月19日	JDK 1.7	工程代号Dolphin（海豚）	本应该是一个包含许多重要改进的JDK版本，其中的Lambda项目（Lambda表达式、函数式编程）、Jigsaw项目（虚拟机模块化支持）、动态语言支持、GarbageFirst收集器和Coin项目（语言细节进化）等子项目对于Java产业都会产生深远的影响。	不能按时完成的Lambda项目、Jigsaw项目和Coin项目的部分改进延迟到JDK 1.8之中。	JDK1.7的主要改进：提供新的G1收集器、加强对非Java语言的调用支持、升级类加载架构等。

2009年4月20日	Oracle公司宣布正式以74亿美元的价格收购Sun公司，Java商标从此正式归Oracle所有。

## 1.4 Java虚拟机发展史

### 1.4.1 Sun Classic/Exact VM

Classic VM	世界第一款商用Java虚拟机	只能使用纯解释器方式类执行Java代码，如果要使用JIT编译器，就必须进行外挂。如果外挂了JIT编辑器，JIT编译器就完全接管了虚拟机的执行系统，解释器便不再工作了。

sunwjit就是Sun提供的外挂编译器，类似的有SymantecJIT和shuJIT。由于解释器和编译器不能配合工作，“Java很慢”的形象就是在这时候开始在用户心中树立起来的。

Exact VM	JDK1.2时发布	二级即时编译器、编译器和解释器混合工作模式	准确式内存管理（Exact Memory Management，也可以叫做Non-Conservative/Accurate Memory Management）: 虚拟机可以知道内存中某个位置的数据具体是什么类型

### 1.4.2 Sun HotSpot VM

“Longview Technologies”的小公司设计的：甚至这个虚拟机最初并非是为Java语言而开发的，它来源于Strongtalk VM，而这款虚拟机中相当多的技术又是来源于一款支持Self语言实现“达到C语言50%以上的执行效率”的目标而设计的虚拟机。1997年Sun收购了Longview Technologies公司，从而获得了HotSpot VM。

（HotSpot一开始就是准确式GC，而Exact VM之中也有与HotSpot几乎一样的热点探测。HotSpot打败Exact并不能算技术上的胜利。）HotSpot VM的热点代码探测能力可以通过执行计数器找出最具有编译价值的代码，然后通知JIT编译器以方法为单位进行编译。如果一个方法被频繁调用，或方法中有效循环次数很多，将会分别触发标准编译和OSR（栈上替换）编译动作。通过编译器与解释器恰当地协同工作，可以在最优化的程序响应时间与最佳执行性能中取得平衡。

2008年和2009年，Oracle公司分别收购了BEA公司和Sun公司，这样Oracle同时拥有了JRockit VM和HotSpot VM两款优秀的Java虚拟机。Oracle宣布在不久的将来（大约应在发布JDK 8的时候）会完成这两款虚拟机的整合工作，使之优势互补。大致是在HotSpot的基础上，移植JRockit的优秀特性，譬如使用JRockit的垃圾回收器与MissionControl服务，使用HotSpot的JIT编译器与混合的运行时系统。

### 1.4.3 Sun Mobile-Embedded VM / Meta-Circular VM

1) KVM

2) CDC/CLDC HotSpot Implementation

3) Squawk VM

4) JavaInJava

5) Maxine VM

### 1.4.4 BEA JRockit / IBM J9 VM

由于专注于服务器端应用，它可以不太关注程序启动速度，因此JRockit内部不包含解析器实现，全部代码都靠及时编译器编译后执行。

IBM J9 VM最初是由IBM Ottawa实验室一个名叫SmallTalk的虚拟机扩展而来的

### 1.4.5 Azul VM / BEA Liquid VM

### 1.4.6 ApacheHarmony / Google Android Dalvik VM

TCK(Technology Compatibility Kit)的兼容性测试

JCP（Java Community Process）组织

Dalvik VM	没有遵循Java虚拟机规范	不能直接执行Class文件，使用寄存器架构	它执行的dex（Dalvik Executable）文件可以通过Class文件转化而来，使用Java语法编写应用程序，可以直接使用大部分的Java API等。

### 1.4.7 Microsoft JVM及其他

## 1.5 展望Java技术的未来

### 1.5.1 模块化

### 1.5.2 混合语言

### 1.5.3 多核并行

### 1.5.4 进一步丰富语法

### 1.5.5 64位虚拟机

## 1.6 实战：自己编译JDK

### 1.6.1 获取JDK源码

### 1.6.2 系统需求

### 1.6.3 构建编译环境

### 1.6.4 进行编译

### 1.6.5 在IDE工具中进行源码调试

