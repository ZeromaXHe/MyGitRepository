# 第4章 虚拟机性能监控与故障处理工具

## 4.1 概述

给一个系统定位问题的时候，知识、经验是关键基础，数据是依据，工具是运用知识处理数据的手段。这里说的数据包括：运行日志、异常堆栈、GC日志、线程快照（threaddump/javacore文件）、堆转储快照（heapdump/hprof文件）等。

## 4.2 JDK的命令行工具

这些命令行工具大多数是jdk/lib/tools.jar类库的一层薄包装而已，它们主要的功能代码是在tools类库中实现的。

Linux版本JDK，这些工具中很多甚至就是由Shell脚本直接写成的，可以用vim直接打开它们。

JDK开发团队选择采用java代码来实现这些监控工具是有特别用意的，当应用程序部署到生产环境后，无论是直接解除物理服务器还是远程Telnet到服务器上都可能会收到限制。借助tools.jar类库里面的接口，我们可以直接在应用程序中实现功能强大的监控分析功能。（tools.jar中的类库不属于Java的标准API，如果引入这个类库，意味着用户的程序只能运行于Sun HotSpot上面，或者在部署程序时需要一起部署tools.jar）

*注意：运行于JDK1.5的虚拟机之上的程序，在程序启动时请添加参数"-Dcom.sun.management.jmxremote"开启JMX管理功能。如果运行于JDK1.6的虚拟机之上，那JMX管理默认是开启的。*

Sun JDK监控和故障处理工具

| 名称   | 主要作用                                                     |
| ------ | ------------------------------------------------------------ |
| jps    | JVM Process Status Tool，显示指定系统内所有的HotSpot虚拟机进程 |
| jstat  | JVM Statistics Monitoring Tool，用于收集HotSpot虚拟机各方面运行数据 |
| jinfo  | Configuration Info for Java，显示虚拟机配置信息。            |
| jmap   | Memory Map for Java，生成虚拟机的内存转储快照（heapdump文件） |
| jhat   | JVM Heap Dump Brower，用于分析heapdump文件，它会建立一个HTTP/HTML服务器，让用户可以在浏览器上查看分析结果 |
| jstack | Stack Trace for Java，显示虚拟机的线程快照                   |

### 4.2.1 jps：虚拟机进程状况工具

JDK很多小工具的名字都参考了UNIX命令的命名方式，jps是其中的典型。除了名字像UNIX的ps命令外，它的功能也和ps命令类似：可以列出正在运行的虚拟机进程，并显示虚拟机执行主类（Main Class，main()函数所在的类）名称以及这些进程的本地虚拟机唯一ID（Local Virtual Machine Identifier，LVMID）。

jps [options] [hostid]

jps可以通过RMI协议查询开启了RMI服务的远程虚拟机进程状态，hostid为RMI注册表中注册的主机名。

jps工具主要选项

| 选项 | 作用                                               |
| ---- | -------------------------------------------------- |
| -q   | 只输出LVMID，省略主类的名称                        |
| -m   | 输出虚拟机进程启动时传递给主类main()函数的参数     |
| -l   | 输出主类的全名，如果进程执行的是Jar包，输出Jar路径 |
| -v   | 输出虚拟机进程启动时JVM参数                        |

### 4.2.2 jstat：虚拟机统计信息监视工具

jstat（JVM Statistics Monitoring Tool）是用于监视虚拟机各种运行状态信息的命令行工具。它可以显示本地或远程（RMI支持）虚拟机进程的类装载、内存、垃圾收集、JIT编译等运行数据。

`jstat [option vmid [interval [m|ms] [count]] ]`

对于命令中的VMID与LVMID需要特别说明一下：如果是本地虚拟机进程，VMID与LVMID是一致的，如果是远程虚拟机进程，那VMID的格式应当是：

`[protocol:][//]lvmid[@hostname[:port]/servername]`

参数interval和count代表查询间隔和次数，如果省略这两个参数，说明只查询一次。假设没250毫秒查询一次进程2764垃圾收集状况，一共查询20次，那命令应当是：

`jstat -gc 2764 250 20`

jstat工具主要选项

| 选项              |                                                              |
| ----------------- | ------------------------------------------------------------ |
| -class            | 监视类装载、卸载数量、总空间以及类装载所耗费的时间           |
| -gc               | 监视Java堆状况，包括Eden区、两个Survivor区、老年代、永久代等的容量、已用空间、GC时间合计等信息 |
| -gccapacity       | 监视内容与-gc基本相同，但输出主要关注Java堆各个区域使用到的最大、最小空间 |
| -gcutil           | 监视内容与-gc基本相同，但输出主要关注已使用空间占总空间的百分比 |
| -gccause          | 与-gcutil功能一样，但是会额外输出导致上一次GC产生的原因      |
| -gcnew            | 监视新生代GC状况                                             |
| -gcnewcapacity    | 监视内容与-gcnew基本相同，输出主要关注使用到的最大、最小空间 |
| -gcold            | 监视老年代GC状况                                             |
| -gcoldcapacity    | 监视内容与-gcold基本相同，输出主要关注使用到的最大、最小空间 |
| -gcpermcapacity   | 输出永久代使用到的最大、最小空间                             |
| -compiler         | 输出JIT编译器编译过的方法、耗时等信息                        |
| -printcompilation | 输出已经被JIT编译的方法                                      |

### 4.2.3 jinfo：Java配置信息工具

jinfo（Configuration Info for Java）的作用是实时地查看和调整虚拟机各项参数。	-v参数可以查看虚拟机启动时显式指定的参数列表	-flag查询未被显式指定的参数的系统默认值（JDK1.6或以上版本，可使用"java -XX:+PrintFlagsFinal"查看参数默认值）	-sysprops选项把虚拟机进程的System.getProperties()的内容打印出来	可以使用-flag [+|-] name或者-flag name=value修改一部分运行期可写的虚拟机参数值。

`jinfo [option] pid`

### 4.2.4 jmap：Java内存映像工具

