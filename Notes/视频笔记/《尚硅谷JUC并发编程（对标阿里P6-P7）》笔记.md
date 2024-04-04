尚硅谷JUC并发编程（对标阿里P6-P7）

https://www.bilibili.com/video/BV1ar4y1x727

2022-05-31 14:55:00

# P1 JUC 教程简介

JUC 并发编程与源码分析

1. 本课程前置知识及要求说明
   - JUC 是什么
     - java.util.concurrent 在并发编程中使用的工具包（1：45）
       - 对 JUC 知识的高阶内容讲解和实战增强
   - 本课程学生对象（非零基础）
     - 了解 Java 技术栈，实际一线编码工作过 1 ~ 5 年的 Java 开发工程师
     - 热爱高并发技术的小伙伴也同样欢迎
   - 本课程的难度对标
     - 阿里 P6、P7 对高级 Java 开发工程师的要求明细
       - 阿里手册规范
   - 前置知识
     - IDEA 开发工具和常用快捷键自定义配置
     - IDEA 之 lombok 插件
     - Java 8 新特性
       - Java 8 语法本身 + 函数式编程 + 方法引用 + lambda 表达式
       - 登陆 B 站-宋红康 Java 8 新特性（5：44）
       - 视频地址
     - JUC 初级篇
       - JUC 要求的知识内容
         - ReentrantLock
           - ReentrantReadWriteLock
           - Condition
         - 工具类
           - CountDownLatch
           - CyclicBarrier
           - Semaphore
         - 线程池与阻塞队列
         - ForkJoinPool 与 ForkJoinTask
         - 原子操作类 Atomic
         - volatile
         - Callable 和 FutureTask
         - ……
       - 登陆 B 站-JUC 并发编程（6：40）
       - 视频地址（7：16）
     - JVM
       - JVM 体系结构（6：57）
       - 参考资料
   - 本次讲解采用的 Java 版本
     - 1.8.0_111
2. 线程基础知识复习
3. CompletableFuture
4. 说说 Java “锁”事
5. LockSupport 与线程中断
6. Java 内存模型之 JMM
7. volatile 与 JMM
8. CAS
9. 原子操作类之 18 罗汉增强
10. 聊聊 ThreadLocal
11. Java 对象内存布局和对象头
12. Synchronized 与锁升级
13. AbstractQueuedSynchronizer 之 AQS
14. ReentrantLock、ReentrantReadWriteLock、StampedLock 讲解
15. 课程总结与回顾

# P2 为什么学好用好多线程如此重要

2、线程基础知识复习

- 先拜拜大神
  - Doug Lea（道格·利）（0：49）
  - java.util.concurrent 在并发编程中使用的工具包（0：42）
- 为什么学习并用好多线程及其重要！！！
  - 硬件方面
    - 摩尔定律失效（2：11）
  - 软件方面
    - 面试 B 格可以高一点点
    - 充分利用多核处理器
    - 提高程序性能，高并发系统
    - 提高程序吞吐量，异步+回调等生产需求
  - 弊端及问题
    - 线程安全性问题
      - i++
      - 集合类安全否
    - 线程锁问题
    - 线程性能问题
- 从 start 一个线程说起
- Java 多线程相关概念
- 用户线程和守护线程

# P3 start 线程开启 C 源码分析

从 start 一个线程说起

- Java 线程理解以及 openjdk 中的实现
  - private native void start0();
  - Java 语言本身底层就是 C++ 语言
  - OpenJDK 源码网址
    - 建议下载源码到本地观看
- 更加底层的 C++ 源码解读
  1. openjdk8\jdk\src\share\native\java\lang
     - thread.c（7：04）
  2. openjdk8\hotspot\src\share\vm\prims
     - jvm.cpp（8：22）
  3. openjdk8\hotspot\src\share\vm\runtime
     - thread.cpp（9：16）

# P4 基础概念复习

Java 多线程相关概念

- 1把锁
  - synchronized
- 2个并
  - 并发（concurrent）
    - 是在同一实体上的多个事件
    - 是在一台处理器上“同时”处理多个任务
    - 同一时刻，其实是只有一个事件在发生
  - 并行（parallel）
    - 是在不同实体上的多个事件
    - 是在多台处理器上同时处理多个任务
    - 同一时刻，大家真的都在做事情，你做你的，我做我的，但是我们都在做
  - 并发 vs 并行（4：31）
- 3个程
  - 进程
    - 简单的说，在系统中运行的一个应用程序就是一个进程，每一个进程都有它自己的内存空间和系统资源
  - 线程
    - 也被称为轻量级进程，在同一个进程内会有1个或多个线程，是大多数操作系统进行时序调度的基本单元
  - 管程
    - Monitor（监视器），也就是我们平时所说的锁（7：51）
    - JVM 第 3 版（9：08）

# P5 用户守护线程理论

用户线程和守护线程

- Java 线程分为用户线程和守护线程
  - 一般情况下不做特别说明配置，默认都是用户线程
  - 用户线程（User Thread）
    - 是系统的工作线程，它会完成这个程序需要完成的业务操作。
  - 守护线程（Daemon Thread）
    - 是一种特殊的线程为其它线程服务的，在后台默默地完成一些系统性的服务，比如垃圾回收线程就是最典型的例子
    - 守护线程作为一个服务线程，没有服务对象就没有必要继续运行了，如果用户线程全部结束了，意味着程序需要完成的业务操作已经结束了，系统可以退出了。所以假如当系统只剩下守护线程的时候，java 虚拟机会自动退出。
- 线程的 deamon 属性
  - 源码解读（4：00）
  - true 表示是守护线程
  - false 表示是用户线程
- code 演示
- 小总结

# P6 用户守护线程代码演示和总结

小总结

- 如果用户线程全部结束意味着程序需要完成的业务操作已经结束了，守护线程随着 JVM 一同结束工作
- setDaemon(true) 方法必须在 start() 之前设置，否则报 IllegalThreadStateException 异常
  - why（5：50）

# P7 CompletableFuture 之 Future 为什么出现

3、CompletableFuture

- Future 接口理论知识复习（1：27）
  - 一句话：Future 接口可以为主线程开一个分支任务，专门为主线程处理耗时和费力的复杂业务
- Future 接口常用实现类 FutureTask 异步任务
- CompletableFuture 对 Future 的改进
- 案例精讲-从电商网站的比价需求说开去
- CompletableFuture 常用方法

# P8 CompletableFuture 之引出 FutureTask - 上集

Future 接口常用实现类 FutureTask 异步任务

- Future 接口能干什么

  - （0：45）

    Future 是 Java 5 新加的一个接口，它提供了一种异步并行计算的功能

    目的：异步多线程任务执行且返回有结果，三个特点：多线程/有返回/异步任务

- 本源的 Future 接口相关架构

- Future 编码实战和优缺点分析

- 想完成一些复杂的任务

# P9 CompletableFuture 之引出 FutureTask - 中集

本源的 Future 接口相关架构

- （4：47）

  ```mermaid
  classDiagram
  	 RunnableFuture <|.. FutureTask
  	 Runnable <|-- RunnableFuture
  	 Future <|-- RunnableFuture
  	 FunctionalInterface .. Runnable
  ```

  

# P10 CompletableFuture 之引出 FutureTask - 下集

# P11 CompletableFuture 之 FutureTask 结合线程池提升性能

Future 编码实战和优缺点分析

- 优点
  - future + 线程池异步多线程任务配合，能显著提高程序的执行效率
  - 上述案例 case
- 缺点

# P12 CompletableFuture 之 get 获取容易阻塞

缺点

- Code1
  - get() 阻塞
    - 一旦调用 get() 方法求结果，如果计算没有完成容易导致程序阻塞
- Code2
- 结论

# P13 CompletableFuture 之轮询耗费 CPU

Code2

- isDone() 轮询
  - 轮询的方式会耗费无谓的 CPU 资源，而且也不见得能及时地得到计算结果
  - 如果想要异步获取结果，通常都会以轮询的方式去获取结果，尽量不要阻塞

结论

- Future 对于结果的获取不是很友好，只能通过阻塞或轮询的方式得到任务的结果

# P14 CompletableFuture 之 Future 异步优化思路

想完成一些复杂的任务

- 对于简单的业务场景使用 Future 完全 OK
- 回调通知
  - 应对 Future 的完成时间，完成了可以告诉我，也就是我们的回调通知
  - 通过轮询的方式去判断任务是否完成这样非常占 CPU 并且代码也不优雅
- 创建异步任务
  - Future + 线程池配合
- 多个任务前后依赖可以组合处理（水煮鱼）
  - 想将多个异步任务的计算结果组合起来，后一个异步任务的计算结果需要前一个异步任务的值
  - 将两个或多个异步计算合成一个异步计算，这几个异步计算互相独立，同时后面这个又依赖前一个处理的结果
- 对计算速度选最快
  - 当 Future 集合中某个任务最快结束时，返回结果，返回第一名处理结果。
- ……
  - 使用 Future 之前提供的那点 API 就囊中羞涩，处理起来不够优雅，这时候还是让 CompletableFuture  以声明式的方式优雅的处理这些需求
  - 从 i 到 i++
  - Future 能干的，CompletableFuture 都能干

# P15 CompletableFuture 之 CompletionStage 源码分析

CompletableFuture 对 Future 的改进

- CompletableFuture 为什么出现（0：13）
- CompletableFuture 和 CompletableStage 源码分别介绍
  - 类架构说明（2：50）
  - 接口 CompletionStage
    - 是什么（4：17）
  - 类 CompletableFuture
    - 是什么（5：50）
- 核心的四个静态方法，来创建一个异步任务

# P16 CompletableFuture 之四大静态方法初讲

核心的四个静态方法，来创建一个异步任务

- runAsync 无返回值
  - `public static CompletableFuture<Void> runAsync(Runnable runnable)`
  - `public static CompletableFuture<Void> runAsync(Runnable runnable, Executor executor)`
- supplyAsync 有返回值
  - `public static CompletableFuture<U> supplyAsync(Supplier<U> supplier)`
  - `public static CompletableFuture<U> supplyAsync(Supplier<U> supplier, Executor executor)`
- 上述 Executor executor 参数说明
  - 没有指定 Executor 的方法，直接使用默认的 ForkJoinPool.commonPool() 作为它的线程池执行异步代码。
  - 如果指定线程池，则使用我们自定义的或者特别指定的线程池执行异步代码
- Code
  - 无返回值（6：42）
  - 有返回值
- Code 之通用演示，减少阻塞和轮询
- CompletableFuture 的优点

# P17 CompletableFuture 之通用异步编程-上集

Code 之通用演示，减少阻塞和轮询

- 从 Java 8 开始引入了 CompletableFuture，它是 Future 的功能增强版，减少阻塞和轮询。可以传入回调对象，当异步任务完成或者发生异常时，自动调用回调对象的回调方法
- code（9：10）
  - whenComplete()
  - exceptionally()
  - 解释下为什么默认线程池关闭，自定义线程池记得关闭

# P18 CompletableFuture 之通用异步编程-下集

CompletableFuture 的优点

- 异步任务结束时，会自动回调某个对象的方法
- 主线程设置好回调后，不再关心异步任务的执行，异步任务之间可以顺序执行
- 异步任务出错时，会自动回调某个对象的方法

# P19 CompletableFuture 之链式语法和 join 方法介绍

案例精讲-从电商网站的比价需求说开去

- 函数式编程已经主流
  - 大厂面试题看看（1：05）
  - Lambda 表达式 + Stream 流式调用 + Chain 链式调用 + Java 8 函数式编程
    - Runnable（2：06）
    - Function（2：28）
    - Consumer（2：39）
      - BiConsumer（3：13）
    - Supplier（4：09）
    - 小总结（4：25）
- 先说说 join 和 get 对比
  - join() 编译期间不会抛出异常
- 说说你过去工作中的项目亮点
- 大厂业务需求说明
- 一波流 Java 8 函数式编程带走-比价案例实战 Case

# P20 CompletableFuture 之电商比价大厂案例需求分析

大厂业务需求说明

- 切记，功能 -> 性能
- 电商网站比价需求分析（2：07）

# P21 CompletableFuture 之电商比价大厂案例编码实战-上集

# P22 CompletableFuture 之电商比价大厂案例编码实战-下集

# P23 CompletableFuture 之获得结果和触发计算

CompletableFuture 常用方法

1. 获得结果和触发计算
   - 获取结果
     - public T get()
       - 不见不散
     - public T get(long timeout, TimeUnit unit)
       - 过时不候
     - public T join()
     - public T getNow(T valueIfAbsent)
       - 没有计算完成的情况下，给我一个替代结果
       - 立即获取结果不阻塞
         - 计算完，返回计算完成后的结果
         - 没算完，返回设定的 valueIfAbsent 值
       - Code
   - 主动触发计算
     - public boolean complete(T value)
       - 是否打断 get 方法立即返回括号值
     - code
2. 对计算结果进行处理
3. 对计算结果进行消费
4. 对计算速度进行选用
5. 对计算结果进行合并

# P24 CompletableFuture 之对计算结果进行处理

2、对计算结果进行处理

- thenApply
  - 计算结果存在依赖关系，这两个线程串行化
  - code
  - 异常相关
    - 由于存在依赖关系（当前步错，不走下一步），当前步骤有异常的话就叫停
- handle
  - 计算结果存在依赖关系，这两个线程串行化
  - code
  - 异常相关
    - 有异常也可以往下一步走，根据带的异常参数可以进一步处理
- 总结（7：56）

# P25 CompletableFuture 之对计算结果进行消费

3、对计算结果进行消费

- 接收任务的处理结果，并消费处理，无返回结果
- thenAccept
- 对比补充
  - Code 之任务之间的顺序执行
    - thenRun
      - thenRun(Runnable runnable)
      - 任务 A 执行完执行 B，并且 B 不需要 A 的结果
    - thenAccept
      - thenAccept(Consumer action)
      - 任务 A 执行完执行 B，B 需要 A 的结果，但是任务 B 无返回值
    - thenApply
      - thenApply(Function fn)
      - 任务 A 执行完执行 B，B 需要 A 的结果，同时任务 B 有返回值
    - code
- CompletableFuture 和线程池说明

# P26 CompletableFuture 之线程池运行选择

CompletableFuture 和线程池说明

- 以 thenRun 和 thenRunAsync 为例，有什么区别？

- code

- 小总结

  - （5：46）

    1. 没有传入自定义线程池，都用默认线程池 ForkJoinPool

    2. 传入了一个自定义线程池，如果你执行第一个任务的时候，传入了一个自定义线程池：

       调用 thenRun 方法执行第二个任务时，则第二个任务和第一个任务是共用同一个线程池。

       调用 thenRunAsync 执行第二个任务时，则第一个任务使用的是你自己传入的线程池，第二个任务使用的是 ForkJoin 线程池

    3. 备注：有可能处理太快，系统优化切换原则，直接使用 main 线程处理

    其它如：thenAccept 和 thenAcceptAsync，thenApply 和 thenApplyAsync 等，它们之间的区别也是同理

- 源码分析（10：42）

# P27 CompletableFuture 之对计算速度选用

4、对计算速度进行选用

- 谁快用谁
- applyToEither
- code

# P28 CompletableFuture 之对计算结果进行合并

5、对计算结果进行合并

- 两个 CompletionStage 任务都完成后，最终能把两个任务的结果一起交给 thenCombine 来处理
- 先完成的先等着，等待其它分支任务
- thenCombine
  - code 标准版，好理解先拆分
  - code 表达式（家庭作业）（4：05）

# P29 多线程锁之线程锁知识概述

4、说说 Java “锁”事

- 大厂面试题复盘（2：25）
- 从轻松的乐观锁和悲观锁开讲
- 通过 8 种情况演示锁运行案例，看看我们到底锁的是什么
- 公平锁和非公平锁
- 可重入锁（又名递归锁）
- 死锁及排查
- 写锁（独占锁）/读锁（共享锁）
- 自旋锁 SpinLock
- 无锁 -> 独占锁 -> 读写锁 -> 邮戳锁
- 无锁 -> 偏向锁 -> 轻量锁 -> 重量锁

# P30 多线程锁之悲观锁和乐观锁介绍

从轻松的乐观锁和悲观锁开讲

- 悲观锁（0：41）
  - 适合写操作多的场景，先加锁可以保证写操作时数据正确。
  - 显式的锁定之后再操作同步资源
  - 一句话：
    - 狼性锁
- 乐观锁（2：14）
  - 适合读操作多的场景，不加锁的特点能够使其读操作的性能大幅提升
  - 乐观锁则直接去操作同步资源，是一种无锁算法，得之我幸不得我命，再努力就是
  - 一句话：
    - 佛系锁
  - 乐观锁一般有两种实现方式：
    - 采用 Version 版本号机制
    - CAS（Compare-and-Swap，即比较并替换）算法实现
- 伪代码说明（5：32）

# P31 多线程锁之 8 锁案例编码演示

通过 8 种情况演示锁运行案例，看看我们到底锁的是什么

- 锁相关的 8 种案例演示 code
  - 参考阿里巴巴 Java 开发手册
  - Code 实操
    1. 标准访问有 ab 两个线程，请问先打印邮件还是短信
    2. sendEmail 方法中加入暂停 3 秒钟，请问先打印邮件还是短信
    3. 添加一个普通的 hello 方法，请问先打印邮件还是 hello
    4. 有两部手机，请问先打印邮件还是短信
    5. 有两个静态同步方法，有 1 部手机，请问先打印邮件还是短信
    6. 有两个静态同步方法，有 2 部手机，请问先打印邮件还是短信
    7. 有 1 个静态同步方法，有 1 个普通同步方法，有 1 部手机，请问先打印邮件还是短信
    8. 有 1 个静态同步方法，有 1 个普通同步方法，有 2 部手机，请问先打印邮件还是短信
  - 解释说明-小总结
- synchronized 有三种应用方式
- 从字节码角度分析 synchronized 实现
- 反编译 synchronized 锁的是什么
- 对于 synchronized 关键字，我们在《Synchronized 与锁升级》章节还会再深度讲解

# P32 多线程锁之 8 锁案例原理解释

解释说明-小总结（17：27）

# P33 多线程锁之 synchronized 字节码分析

synchronized 有三种应用方式

- JDK 源码（notify 方法）说明举例（00：56）
- 8 种锁的案例实际体现在 3 个地方
  - 作用于实例方法，当前实例加锁，进入同步代码前要获得当前实例的锁
  - 作用于代码块，对括号里配置的对象加锁
  - 作用于静态方法，当前类加锁，进去同步代码前要获得当前类对象的锁

从字节码角度分析 synchronized 实现

- javap -c ***.class 文件反编译
  - -c
    - 对代码进行反汇编
  - 假如你需要更多信息
    - javap -v ***.class 文件反编译
    - -v -verbose 输出附加信息（包括行号、本地变量表，反汇编等详细信息）
- synchronized 同步代码块
  - javap -c ***.class 文件反编译
  - 反编译（7：24）
  - synchronized 同步代码块
    - 实现使用的是 monitorenter 和 monitorexit 指令
  - 一定是一个 enter 两个 exit 吗？
    - 一般情况就是 1 个 enter 对应 2 个 exit
    - 极端
      - m1 方法里面自己添加一个异常试试（9：43）
- synchronized 普通同步方法块
  - javap -v ***.class 文件反编译
  - 反编译（11：41）
  - synchronized 普通同步方法
    - 调用指令将会检查方法的 ACC_SYNCHRONIZED 访问标志是否被设置。如果设置了，执行线程会将先持有 monitor 锁，然后再执行方法，最后在方法完成（无论是正常完成还是非正常完成）时释放 monitor
- synchronized 静态同步方法块
  - ACC_STATIC, ACC_SYNCHRONIZED 访问标志区分该方法是否静态同步方法

# P34 多线程锁之 synchronized 底层原语分析

反编译 synchronized 锁的是什么

- 面试题：为什么任何一个对象都可以成为一个锁
- 什么是管程 monitor
  - 大厂面试题讲解（2：23）
  - 管程（2：40）
  - 通过 C 底层原语了解
  - 在 HotSpot 虚拟机中，monitor 采用 ObjectMonitor 实现
  - 上述 C++ 源码解读
    - ObjectMonitor.java -> ObjectMonitor.cpp -> objectMonitor.hpp
    - objectMonitor.hpp（7：23）
    - 每个对象天生都带着一个对象监视器
    - 每一个被锁住的对象都会和 Monitor 关联起来

对于 synchronized 关键字，我们在《Synchronized 与锁升级》章节还会再深度讲解

- 提前剧透，混个眼熟（9：10）

# P35 多线程锁之公平锁和非公平锁

公平锁和非公平锁

- 从 ReentrantLock 卖票 demo 演示公平和非公平现象

- 何为公平锁/非公平锁？

  - （4：21）

    公平锁：多个线程按照申请锁的顺序来获取锁

    非公平锁：多个线程获取锁的顺序并不是按照申请锁的顺序，有可能后申请的线程比先申请的线程优先获取锁。在高并发环境下，有可能造成优先级翻转或者饥饿的状态（某个线程一直得不到锁）。ReentrantLock 默认非公平锁

  - 面试题

    - 为什么会有公平锁/非公平锁的设计？为什么默认非公平？

      - （6：29）
        1. 恢复挂起的线程到真正锁的获取还是有时间差的，所以非公平锁能更充分的利用 CPU 的时间片，尽量减少 CPU 空闲状态时间。
        2. 采用非公平锁时，当一个线程请求锁获取同步状态，然后释放同步状态，所以刚释放锁的线程在此刻再次获取同步状态的概率就变得非常大，所以就减少了线程的开销

    - 什么时候用公平？什么时候用非公平？

      - （8：38）

        如果为了更高的吞吐量，显然非公平锁是比较合适的；否则那就用公平锁，大家公平使用。

- 预埋伏 AQS（9：27）

  - 更进一步的源码深度分析见后续第 13 章

# P36 多线程锁之可重入锁理论知识

可重入锁（又名递归锁）

- 说明

  - （0：26）

    是指在同一个线程在外层方法获取锁的时候，再进入该线程的内存方法会自动获取锁（前提，锁对象得是同一个对象），不会因为之前已经获取过还没释放而阻塞。

    Java 中 ReentrantLock 和 synchronized 都是可重入锁

- “可重入锁”这四个字分开来解释：

  - 可：可以
  - 重：再次
  - 入：进入
  - 锁：同步锁
  - 进入什么
    - 进入同步域（即同步代码块/方法或显式锁锁定的代码）
  - 一句话
    - 一个线程中的多个流程可以获取同一把锁，持有这把同步锁可以再次进入。
    - 自己可以获取自己的内部锁

- 可重入锁种类

# P37 多线程锁之可重入锁 synchronized 代码验证

可重入锁种类

- 隐式锁（即 synchronized 关键字使用的锁）默认是可重入锁（0：42）
  - 同步块
  - 同步方法
- synchronized 的重入的实现机理
- 显式锁（即 Lock）也有 ReentrantLock 这样的可重入锁

# P38 多线程锁之可重入锁原理分析和 lock 代码验证

synchronized 的重入的实现机理

- （1：18）

  每个锁对象拥有一个锁计数器和一个指向持有该锁的线程的指针

- 为什么任何一个对象都可以成为一个锁

- objectMonitor.hpp（0：36）

显式锁（即 Lock）也有 ReentrantLock 这样的可重入锁（7：56）

# P39 多线程锁之死锁案例和排查命令

死锁及排查

- 是什么（1：03）
  - 产生死锁的主要原因
    - 系统资源不足
    - 进程进行推进的顺序不合适
    - 资源分配不当
  - 死锁的四个必要条件
    - 互斥条件
    - 不可剥夺条件
    - 请求和保持条件
    - 循环等待条件
- 请写一个死锁代码 case
- 如何排查死锁
  - 纯命令
    - jps -l
    - jstack 进程编号
  - 图形化
    - jconsole
