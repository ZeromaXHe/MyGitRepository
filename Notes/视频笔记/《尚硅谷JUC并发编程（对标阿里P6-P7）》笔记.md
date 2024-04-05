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

# P40 多线程锁之 objectMonitor 和 synchronized 锁小总结

- 写锁（独占锁）/读锁（共享锁）
  - 源码深度分析见后续第 14 章
- 自旋锁 SpinLock
  - 源码深度分析见后续第 8 章
- 无锁 -> 独占锁 -> 读写锁 -> 邮戳锁
  - 有没有比读写锁更快的锁？
    - StampedLock
  - 源码深度分析见后续第 14 章
- 无锁 -> 偏向锁 -> 轻量锁 -> 重量锁
  - 源码深度分析见后续第 12 章
  - 本章锁内容，上半场小总结
    - 8 锁案例运行，锁的到底是什么
      - 对象锁
      - 类锁
    - 公平锁和非公平锁
    - 可重入（又名递归锁）
    - 死锁及排查
    - 为什么任何一个对象都可以成为一个锁
      - objectMonitor.hpp（4：24）
    - 小总结（重要）（4：49）

# P41 中断机制之中断协商机制简介

5、LockSupport 与线程中断

- 2内容简介

  - LockSupport（0：25）
  - 线程中断机制（1：30）

- 线程中断机制

  - 从阿里蚂蚁金服面试题讲起（2：27）

  - 什么是中断机制？

    - （3：50）

      首先，一个线程不应该由其他线程来强制中断或停止，而是应该由线程自己自行停止。所以 Thread.stop，Thread.suspend，Thread.resume 都已经被废弃了。

      其次，Java 提供了一种用于停止线程的协商机制——中断，也即中断标识协商机制。

      中断只是一种协作协商机制，Java 没有给中断增加任何语法，中断的过程完全需要程序员自己实现。若要中断一个线程，你需要手动调用该线程的 interrupt 方法。该方法也仅仅是将线程对象的中断标识设成 true；接着你需要自己写代码不断检测当前线程的标识位。

  - 中断的相关 API 方法之三大方法说明

  - 大厂面试题中断机制考点

  - 总结

- LockSupport 是什么

- 线程等待唤醒机制

# P42 中断机制之 3 大中断方法说明

中断的相关 API 方法之三大方法说明

- （0：36）

  void interrupt() 设置线程的中断状态为 true

  static boolean interrupted() 判断线程是否被中断并清除当前中断状态

  boolean isInterrupted() 判断当前线程是否被中断

# P43 中断机制之通过 volatile 实现线程中断停止

大厂面试题中断机制考点

- 如何停止中断运行中的线程？
  - 通过一个 volatile 变量实现
  - 通过 AtomicBoolean
  - 通过 Thread 类自带的中断 api 实例方法实现
- 当前线程的中断标识为 true，是不是线程就立刻停止？
- 静态方法 Thread.interrupted()，谈谈你的理解

# P44 中断机制之通过 AtomicBoolean 实现线程中断停止

# P45 中断机制之通过 interrupt 实现线程中断停止

通过 Thread 类自带的中断 api 实例方法实现

- 在需要中断的线程中不断监听中断状态，一旦发生中断，就执行相应的中断处理业务逻辑 stop 线程
- API（1：34）
  - code（5：46）
  - 实例方法 interrupt()，没有返回值
    - 源码分析
  - 实例方法 isInterrupted()，返回布尔值
    - 源码分析
  - 说明

# P46 中断机制之 interrupt 和 isInterrupted 源码分析

- 实例方法 interrupt()，没有返回值（0：32）

  - 源码分析（0：50）

- 实例方法 isInterrupted()，返回布尔值（0：37）

  - 源码分析（4：54）

- 说明

  - （5：02）

    具体来说，当对一个线程，调用 interrupt() 时：

    1. 如果线程处于正常活动状态，那么会将该线程的中断标志设置为 true，仅此而已
    2. 如果线程处于被阻塞状态（例如处于 sleep，wait，join 等状态），在别的线程中调用当前线程对象的 interrupt 方法，那么线程将立即退出被阻塞状态，并抛出一个 InterruptedException 异常

# P47 中断机制之中断协商案例深度解析-上集

当前线程的中断标识为 true，是不是线程就立刻停止？

- code02
- code02 后手案例（重要，面试就是它，操蛋）
- 小总结

# P48 中断机制之中断协商案例深度解析-下集

- code02 后手案例（重要，面试就是它，操蛋）（11：52）

  - 结论

    - （12：54）

      sleep 方法抛出 InterruptedException 后，中断标识也被清空置为 false，我们在 catch 没有通过 th.interrupt() 方法再次将中断标识置为 true，这就导致无限循环了

- 小总结

  - 中断只是一种协商机制，修改中断标识位仅此而已，不是立刻 stop 打断

# P49 中断机制之静态方法 interrupted

- 静态方法 Thread.interrupted()，谈谈你的理解

  - 静态方法 Thread.interrupted()

    - 说明（0：28）
    - code（4：45）

  - 都会返回中断状态，两者对比（4：53）

    - 结论

      - （7：30）

        方法的注释也清晰的表达了“中断状态将会根据传入的 ClearInterrupted 参数值确定是否重置”

        所以，静态方法 interrupted 将会清除中断状态（传入的参数 ClearInterrupted 为 true）。

        实例方法 isInterrupted 则不会（传入的参数 ClearInterrupted 为 false）

总结

- （8：22）

  interrupt() 方法是一个实例方法，它通知目标线程中断，也仅是设置目标线程的中断标志位为 true

  isInterrupted() 方法也是一个实例方法，它判断当前线程是否被中断（通过检查中断标志位）并获取中断标志

  Thread 类的静态方法 interrupted() 返回当前线程的中断状态真实值（boolean 类型）后会将当前线程的中断状态设为 false，此方法调用之后会清除当前线程的中断标记位的状态（将中断标志置为 false 了），返回当前值并清零置 false

# P50 LockSupport 之是什么及等待唤醒机制对比

LockSupport 是什么（1：03）

- 是什么（2：05）

线程等待唤醒机制

- 3 种让线程等待和唤醒的方法
  - 方式1：使用 Object 中的 wait() 方法让线程等待，使用 Object 中的 notify() 方法唤醒线程
  - 方式2：使用 JUC 包中 Condition 的 await() 方法让线程等待，使用 signal() 方法唤醒线程
  - 方式3：LockSupport 类可以阻塞当前线程以及唤醒指定被阻塞的线程
- Object 类中的 wait 和 notify 方法实现线程等待和唤醒
- Condition 接口中的 await 后 signal 方法实现线程的等待和唤醒
- 上述两个对象 Object 和 Condition 使用的限制条件
- LockSupport 类中的 park 等待和 unpark 唤醒

# P51 LockSupport 之 wait 和 notify 实现等待和唤醒

Object 类中的 wait 和 notify 方法实现线程等待和唤醒

- 代码
  - 正常（3：00）
  - 异常1
    - wait 方法和 notify 方法，两个都去掉同步代码块
    - 异常情况（4：40）
  - 异常2
    - 将 notify 放在 wait 方法前面
    - 程序无法执行，无法唤醒
- 小总结
  - wait 和 notify 方法必须要在同步块或者方法里面，且成对出现使用
  - 先 wait 后 notify 才 OK

# P52 LockSupport 之 await 和 signal 实现等待和唤醒

Condition 接口中的 await 后 signal 方法实现线程的等待和唤醒

- 代码
  - 正常
  - 异常1
    - 去掉 lock/unlock（3：18）
  - 异常2（4：38）
    - 先 signal 后 await
- 小总结
  - Condition 中的线程等待和唤醒方法，需要先获取锁
  - 一定要先 await 后 signal，不要反了

上述两个对象 Object 和 Condition 使用的限制条件

- 线程先要获得并持有锁，必须在锁块（synchronized 或 lock）中
- 必须要先等待后唤醒，线程才能够被唤醒

# P53 LockSupport 之 park 和 unpark 入门简介

LockSupport 类中的 park 等待和 unpark 唤醒

- 是什么
  - 通过 park() 和 unpark(thread) 方法来实现阻塞和唤醒线程的操作
  - 官网解释（0：29）
- 主要方法
  - API（2：17）
  - 阻塞
    - park()/park(Object blocker)（2：40）
    - 阻塞当前线程/阻塞传入的具体线程
  - 唤醒
    - unpark(Thread thread)（4：52）
    - 唤醒处于阻塞状态的指定线程
- 代码
- 重点说明（重要）
- 面试题

# P54 LockSupport 之 park 和 unpark 编码实战

代码

- 正常+无锁块要求
- 之前错误的先唤醒后等待，LockSupport 照样支持
  - 解释（4：31）
- 成双成对要牢记

# P55 LockSupport 之原理小总结

- 重点说明（重要）

  - （2：51）

    LockSupport 是用来创建锁和其他同步类的基本线程阻塞原语。

    LockSupport 是一个线程阻塞工具类，所有的方法都是静态方法，可以让线程在任意位置阻塞，阻塞之后也有对应的唤醒方法。归根结底，LockSupport 调用的 Unsafe 中的 native 代码。

    LockSupport 提供 park() 和 unpark() 方法实现阻塞线程和解除线程阻塞的过程

    LockSupport 和每个使用它的线程都有一个许可（permit）关联。每个线程都有一个相关的 permit，permit 最多只有一个，重复调用 unpark 也不会积累凭证。

- 面试题

  - （4：44）

    **为什么可以突破 wait/notify 的原有调用顺序？**

    因为 unpark 获得了一个凭证，之后再调用 park 方法，就可以名正言顺的凭证消费，故不会阻塞。先发放了凭证后续可以畅通无阻。

    **为什么唤醒两次后阻塞两次，但最终结果还会阻塞线程？**

    因为凭证的数量最多为 1，连续调用两次 unpark 和调用一次 unpark 效果一样，只会增加一个凭证

# P56 JMM 之入门简介

6、Java 内存模型之 JMM

- 先从大厂面试题开始

  - 你知道什么是 Java 内存模型 JMM 吗？
  - JMM 与 volatile 它们两个之间的关系？（下一章详细讲解）
  - JMM 有哪些特性 or 它的三大特性是什么？
  - 为什么要有 JMM，它为什么出现？作用和功能是什么？
  - happens-before 先行发生原则你有了解过吗？
  - ……

- 计算机硬件存储体系（2：25）

  - 推导出我们需要知道 JMM

    - （5：08）

      CPU 的运行并不是直接操作内存而是先把内存里面的数据读到缓存。而内存的读和写操作的时候就会造成不一致的问题

      JVM 规范中试图定义一种 Java 内存模型（Java Memory Model，简称 JMM）来屏蔽掉各种硬件和操作系统的内存访问差异。以实现让 Java 程序在各种平台下都能达到一致的内存访问效果。

- Java 内存模型 Java Memory Model

- JMM 规范下，三大特性

- JMM 规范下，多线程对变量的读写过程

- JMM 规范下，多线程先行发生原则之 happens-before

# P57 JMM 之学术定义和作用

Java 内存模型 Java Memory Model

- （0：46）

  JMM（Java 内存模型 Java Memory Model, 简称 JMM）本身是一种抽象的概念并不真实存在，它仅仅描述的是一组约定或规范，通过这组规范定义了程序中（尤其是多线程）各个变量的读写访问方式并决定一个线程对共享变量的写入何时以及如何变成对另一个线程可见，关键技术点都是围绕多线程的原子性、可见性和有序性展开的

  原则：

  JMM 的关键技术点都是围绕多线程的原子性、可见性和有序性展开的

  能干嘛？

  1. 通过 JMM 来实现线程和主内存之间的抽象关系
  2. 屏蔽各个硬件平台和操作系统的内存访问差异，以实现让 Java 程序在各种平台下都能达到一致的内存访问效果

# P58 JMM 之三大特性

JMM 规范下，三大特性

- 可见性

  - （2：32）

    可见性是指当一个线程修改了某一个共享变量的值，其他线程是否能够立即知道该变更，JMM 规定了所有的变量都存储在主内存中。

- 原子性

  - 指一个操作是不可打断的，即多线程环境下，操作不能被其他线程干扰

- 有序性

  - （13：27）

    对于一个线程的执行代码而言，我们总是习惯性认为代码的执行总是从上到下，有序执行。但为了提升性能，编译器和处理器通常会对指令序列进行重新排序。Java 规范规定 JVM 线程内部维持顺序化语义，即只要程序的最终结果与它顺序化执行的结果相等，那么指令的执行顺序可以与代码顺序不一致，此过程叫指令的重排序。

  - 简单案例先过个眼熟（12：09）

# P59 JMM 之多线程对变量的读写过程

JMM 规范下，多线程对变量的读写过程

- 读取过程（0：12）
- 小总结
  - 我们定义的所有共享变量都存储在物理主内存中
  - 每个线程都有自己独立的工作内存，里面保存该线程使用到的变量的副本（主内存中该变量的一份拷贝）
  - 线程对共享变量所有的操作都必须先在线程自己的工作内存中进行后写回主内存，不能直接从主内存中读写（不能越级）
  - 不同线程之间也无法直接访问其他线程的工作内容中的变量，线程间变量值的传递需要通过主内存来进行（同级不能相互访问）

# P60 JMM 之 happens-before - 上集

JMM 规范下，多线程先行发生原则之 happens-before

- 在 JMM 中，如果一个操作执行的结果需要对另一个操作可见性或者代码重排序，那么这两个操作之间必须存在 happens-before（先行发生）原则。逻辑上的先后关系
- x、y 案例说明（4：00）
- 先行发生原则说明（4：09）
- happens-before 总原则
  - 如果一个操作 happens-before 另一个操作，那么第一个操作的执行结果将对第二个操作可见，而且第一个操作的执行顺序排在第二个操作之前。
  - 两个操作之间存在 happens-before 关系，并不意味着一定要按照 happens-before 原则制定的顺序来执行。如果重排序之后的执行结果与按照 happens-before 关系来执行的结果一致，那么这种重排序并不非法。
    - 值日
      - 周一张三周二李四，假如有事情调换班可以的
    - 1+2+3=3+2+1
- happens-before 之 8 条
- happens-before - 小总结
- 案例说明

# P61 JMM 之 happens-before - 下集

happens-before 之 8 条

1. 次序原则
   - 一个线程内，按照代码顺序，写在前面的操作先行发生于写在后面的操作
   - 加深说明
     - 前一个操作的结果可以被后续的操作获取。讲白点就是前面一个操作把变量 X 赋值为 1，那后面一个操作肯定能知道 X 已经变成了 1
2. 锁定原则
   - 一个 unLock 操作先行发生于后面（这里的“后面”是指时间上的先后）对同一个锁的 lock 操作（2：54）
3. volatile 变量规则
   - 对一个 volatile 变量的写操作先行发生于后面对这个变量的读操作，前面的写对后面的读是可见的，这里的“后面”同样是指时间上的先后。
4. 传递规则
   - 如果操作 A 先行发生于操作 B，而操作 B 又先行发生于操作 C，则可以得出操作 A 先行发生于操作 C；
5. 线程启动规则（Thread Start Rule）
   - Thread 对象的 start() 方法先行于此线程的每一个动作
6. 线程中断规则（Thread Interruption Rule）
   - 对线程 interrupt() 方法的调用先行于被中断线程的代码检测到中断事件的发生
   - 可以通过 Thread.interrupted() 检测到是否发生中断
   - 也就是说你要先调用 interrupt() 方法设置过中断标志位，我才能检测到中断发送
7. 线程终止规则（Thread Termination Rule）
   - 线程中的所有操作都先行于对此线程的终止检测，我们可以通过 isAlive() 等手段检测线程是否已经终止执行
8. 对象终结规则（Finalizer Rule）
   - 一个对象的初始化完成（构造函数执行结束）先行发生于它的 finalize() 方法的开始
   - 说人话
     - 对象没有完成初始化之前，是不能调用 finalized() 方法的

# P62 JMM 之 happens-before 小总结和案例分析

happens-before - 小总结

- （0：12）

  在 Java 语言里面，Happens-before 的语义本质上是一种可见性

  A Happens-Before B 意味着 A 发生过的事情对 B 来说是可见的，无论 A 事件和 B 事件是否发生在同一个线程里

  JMM 的设计分为两部分：

  一部分是面向我们程序员提供的，也就是 happens-before 规则，它通俗易懂的向我们程序员阐述了一个强内存模型，我们只要理解 happens-before 规则，就可以编写并发安全的程序了。

  另一部分是针对 JVM 实现的，为了尽可能少的对编译器和处理器做约束从而提高性能，JMM 在不影响程序执行结果的前提下对其不做要求，即允许优化重排序。我们只需要关注前者就好了，也就是理解 happens-before 规则即可，其它繁杂的内容有 JMM 规范结合操作系统给我们搞定，我们只写好代码即可。

案例说明

- code（2：16）
- 解释（4：24）
  - 修复01
    - 把 getter/setter 方法都定义为 synchronized 方法（5：01）
  - 修复02
    - 把 value 定义为 volatile 变量，由于 setter 方法对 value 的修改不依赖 value 的原值，满足 volatile 关键字使用场景（6：10）

# P63 volatile 之两大特性

7、volatile 与 JMM

- 被 volatile 修饰的变量有 2 大特点
  - 特点
    - 可见性
    - 有序性
      - 排序要求
        - 有时需要禁重排
  - volatile 的内存语义
    - 当写一个 volatile 变量时，JMM 会把该线程对应的本地内存中的共享变量值立即刷新回主内存中。
    - 当读一个 volatile 变量时，JMM 会把该线程对应的本地内存设置为无效，重新回到主内存中读取最新共享变量
    - 所以 volatile 的写内存语义是直接刷新到主内存中，读的内存语义是直接从主内存中读取
  - volatile 凭什么可以保证可见性和有序性？？？
    - 内存屏障 Memory Barrier
- 内存屏障（面试重点必须拿下）
- volatile 特性
- 如何正确使用 volatile
- 本章最后的小总结

# P64 volatile 之四大屏障

内存屏障（面试重点必须拿下）

- 先说生活 case

  - 没有管控，顺序难保（1：44）
  - 设定规则，禁止乱序
    - 上海南京路武警“人墙”当红灯（2：29）
  - 再说 volatile 两大特性
    - 可见
      - 写完后立即刷新回主内存并及时发出通知，大家可以去主内存拿最新版，前面的修改对后面所有线程可见
    - 有序（禁重排）（4：00）

- 是什么

  - （5：30）

    内存屏障（也称内存栅栏，屏障指令等，是一类同步屏障指令，是 CPU 或编译器在对内存随机访问的操作中的一个同步点，使得此点之前的所有读写操作都执行后才可以开始执行此点之后的操作），避免代码重排序。内存屏障其实就是一种 JVM 指令，Java 内存模型的重排规则会要求 Java 编译器在生成 JVM 指令时插入特定的内存屏障指令，通过这些内存屏障指令，volatile 实现了 Java 内存模型中的可见性和有序性（禁重排），但 volatile 无法保证原子性。

- 内存屏障分类

  - 一句话

    - 上一章讲解过 happens-before 先行发生原则，类似接口规范，落地？
    - 落地靠什么？
      - 你凭什么可以保证？你管用吗？

  - 粗分 2 种

    - 读屏障（Load Barrier）
      - 在读指令之前插入读屏障，让工作内存或 CPU 高速缓存当中的缓存数据失效，重新回到主内存中获取最新数据
    - 写屏障（Store Barrier）
      - 在写指令之后插入写屏障，强制把写缓冲区的数据刷回到主内存中

  - 细分 4 种

    - C++ 源码分析

      - IDEA 工具里面找 Unsafe.class
        - Unsafe.java
          - Unsafe.cpp（13：43）
            - OrderAccess.hpp（14：29）
              - orderAccess_linux_x86.inline.hpp（14：54）

    - orderAccess_linux_x86.inline.hpp（15：26）

    - 四大屏障分别是什么意思

      - （13：35）

        | 屏障类型   | 指令示例                   | 说明                                                         |
        | ---------- | -------------------------- | ------------------------------------------------------------ |
        | LoadLoad   | Load1; LoadLoad; Load2     | 保证 load1 的读取操作在 load2 及后续读取操作之前执行         |
        | StoreStore | Store1; StoreStore; Store2 | 在 store2 及其后的写操作执行前，保证 store1 的写操作已刷新到主内存 |
        | LoadStore  | Load1; LoadStore; Store2   | 在 store2 及其后的写操作执行前，保证 load1 的读操作已读取结束 |
        | StoreLoad  | Store1; StoreLoad; Load2   | 保证 store1 的写操作已刷新到主内存之后，load2 及其后的读操作才能执行 |

- 如下内容困难，可能会导致学生懵逼，课堂要讲解细致。分 2 次讲解 + 复习

# P65 volatile 之读写屏障插入策略

如下内容困难，可能会导致学生懵逼，课堂要讲解细致。分 2 次讲解 + 复习

- 什么叫保证有序性？

  - 禁重排
    - 通过内存屏障禁重排
    - 上述说明（1：48）

- happens-before 之 volatile 变量规则

  - （2：55）

    | 第一个操作  | 第二个操作：普通读写 | 第二个操作：volatile 读 | 第二个操作：volatile 写 |
    | ----------- | -------------------- | ----------------------- | ----------------------- |
    | 普通读写    | 可以重排             | 可以重排                | 不可以重排              |
    | volatile 读 | 不可以重排           | 不可以重排              | 不可以重排              |
    | volatile 写 | 可以重排             | 不可以重排              | 不可以重排              |

    当第一个操作为 volatile 读时，不论第二个操作是什么，都不能重排序。这个操作保证了 volatile 读之后的操作不会被重排到 volatile 读之前。

    当第二个操作为 volatile 写时，不论第一个操作是什么，都不能重排序。这个操作保证了 volatile 写之前的操作不会被重排到 volatile 写之后

    当第一个操作为 volatile 写时，第二个操作为 volatile 读时，不能重排

- JMM 就将内存屏障插入策略分为 4 种规则

  - 读屏障
    - 在每个 volatile 读操作的后面插入一个 LoadLoad 屏障
    - 在每个 volatile 读操作的后面插入一个 LoadStore 屏障
  - 对比图
  - 写屏障
    - 在每个 volatile 写操作的前面插入一个 StoreStore 屏障
    - 在每个 volatile 写操作的后面插入一个 StoreLoad 屏障

# P66 volatile 之可见性案例详解

volatile 特性

- 保证可见性

  - 说明

    - 保证不同线程对某个变量完成操作后结果及时可见，即该共享变量一旦改变所有线程立即可见

  - Code

    - 不加 volatile，没有可见性，程序无法停止
    - 加了 volatile，保证可见性，程序可以停止

  - 上述代码原理解释（7：35）

  - volatile 变量的读写过程

    - （8：31）

      read(读取)->load(加载)->use(使用)->assign(赋值)->store(存储)->write(写入)->lock(锁定)->unlock(解锁) 

- 没有原子性

- 指令禁重排

# P67 volatile 之无原子性案例详解

没有原子性

- volatile 变量的复合操作不具有原子性，比如 number++
- Code
  - 读取赋值一个普通变量的情况（3：59）
  - 不保证原子性（5：05）
  - 从 i++ 的字节码角度说明（13：24）
- 结论
  - volatile 变量不适合参与到依赖当前值的运算（15：21）
- 面试回答
  - JVM 的字节码，i++ 分为三步，间隙期不同步非原子操作（i++）（16：30）

# P68 volatile 之禁重排案例详解

指令禁重排

- 说明与案例（0：41）
- volatile 的底层实现是通过内存屏障，2 次复习
  - volatile 有关的禁止指令重排的行为（5：51）
  - 四大屏障的插入情况
    - 在每个 volatile 写操作的前面插入一个 StoreStore 屏障
      - StoreStore 屏障可以保证在 volatile 写之前，其前面的所有普通写操作都已经刷新到主内存
    - 在每个 volatile 写操作的后面插入一个 StoreLoad 屏障
      - StoreLoad 屏障的作用是避免 volatile 写与后面可能有的 volatile 读/写操作重排序
    - 在每个 volatile 读操作的后面插入一个 LoadLoad 屏障
      - LoadLoad 屏障用来禁止处理器把上面的 volatile 读与下面的普通读重排序
    - 在每个 volatile 读操作的后面插入一个 LoadStore 屏障
      - LoadStore 屏障用来禁止处理器把上面的 volatile 读与下面的普通写重排序
- Code 说明（8：34）

# P69 volatile 之日常使用场景

如何正确使用 volatile

- 单一赋值可以，but 含复合运算赋值不可以（i++ 之类）
  - volatile int a = 10
  - volatile boolean flag = false
- 状态标志，判断业务是否结束（1：24）
- 开销较低的读，写锁策略（2：30）
- DCL 双端锁的发布
  - 问题（4：33）
    - 单线程看问题代码（6：16）
    - 由于存在指令重排序
    - 多线程看问题代码（7：26）
  - 解决（8：44）
    - 加 volatile 修饰

# P70 volatile 小总结

本章最后的小总结

- volatile 可见性（0：55）
- volatile 没有原子性
- volatile 禁重排
  - 写指令（2：56）
  - 读指令（3：33）
- 凭什么我们 java 写了一个 volatile 关键字，系统底层加入内存屏障？两者关系怎么勾搭上的？
  - 字节码层面（4：19）
- 内存屏障是什么（5：57）
- 内存屏障能干嘛
  - 阻止屏障两边的指令重排序
  - 写数据时加入屏障，强制将线程私有工作内存的数据刷回主物理内存
  - 读数据时加入屏障，线程私有工作内存的数据失效，重新到主物理内存中获取最新数据
- 内存屏障四大指令
  - 在每个 volatile 写操作的前面插入一个 StoreStore 屏障
  - 在每个 volatile 写操作的后面插入一个 StoreLoad 屏障
  - 在每个 volatile 读操作的后面插入一个 LoadLoad 屏障
  - 在每个 volatile 读操作的后面插入一个 LoadStore 屏障
- 3 句话总结
  - volatile 写之前的操作，都禁止重排序到 volatile 之后
  - volatile 读之后的操作，都禁止重排序到 volatile 之前
  - volatile 写之后 volatile 读，禁止重排序

# P71 CAS 之原理简介

8、CAS

- 原子类
  - java.util.concurrent.atomic
- 没有 CAS 之前
  - 多线程环境不使用原子类保证线程安全 i++（基本数据类型）（2：26）
- 使用 CAS 之后
  - 多线程环境使用原子类保证线程安全 i++（基本数据类型）
  - 类似我们的乐观锁
- 是什么
  - 说明（4：49）
    - 原理（5：58）
  - CASDemo 代码
  - 硬件级别保证
  - 源码分析 compareAndSet(int expect, int update)
- CAS 底层原理？如果知道，谈谈你对 UnSafe 的理解
- 原子引用
- CAS 与自旋锁，借鉴 CAS 思想
- CAS 缺点

# P72 CAS 之源码分析引出 Unsafe 类

- CASDemo 代码
- 硬件级别保证（2：49）
- 源码分析 compareAndSet(int expect, int update)（5：28）

# P73 CAS 之 Unsafe 类详解

CAS 底层原理？如果知道，谈谈你对 UnSafe 的理解

- UnSafe（1：41）
- 我们知道 i++ 线程不安全的，那 atomicInteger.getAndIncrement()（7：36）
- 源码分析
- 底层汇编

# P74 CAS 之 Unsafe 类底层汇编源码分析

- 源码分析
  - new AtomicInteger().getAndIncrement();（1：05）
- 底层汇编
  - native 修饰的方法代表是底层方法（5：54）
  - cmpxchg（8：04）
  - 在不同的操作系统下会调用不同的 cmpxchg 重载函数，阳哥本次用的是 win10 系统（8：45）
  - 总结（10：06）

# P75 CAS 之原子引用 AtomicReference

原子引用

- AtomicInteger 原子整型，可否有其它原子类型？
- AtomicReferenceDemo

# P76 CAS 之手写自旋锁

CAS 与自旋锁，借鉴 CAS 思想

- 是什么（0：46）
- 自己实现一个自旋锁 SpinLockDemo

# P77 CAS 的两大缺点

CAS 缺点

- 循环时间开销很大（0：45）
- 引出来 ABA 问题？？？
  - ABA 问题怎么产生的（1：45）
  - 版本号时间戳原子引用
  - 一句话：

# P78 CAS 之 AtomicStampedReference 入门

版本号时间戳原子引用

- AtomicStampedReference
  - 简单 case
- ABADemo
- 下一章介绍 AtomicMarkableReference

# P79 CAS 之 ABA 问题编码实战

一句话：

- 比较+版本号一块上

# P80 原子类入门介绍和分类说明

9、原子操作类之 18 罗汉增强

- 是什么（1：02）
  - atomic
    1. AtomicBoolean
    2. AtomicInteger
    3. AtomicIntegerArray
    4. AtomicIntegerFieldUpdater
    5. AtomicLong
    6. AtomicLongArray
    7. AtomicLongFieldUpdater
    8. AtomicMarkableReference
    9. AtomicReference
    10. AtomicReferenceArray
    11. AtomicReferenceFieldUpdater
    12. AtomicStampedReference
    13. DoubleAccumulator
    14. DoubleAdder
    15. LongAccumulator
    16. LongAdder
- 再分类
  - 基本类型原子类
  - 数组类型原子类
  - 引用类型原子类
  - 对象的属性修改原子类
  - 原子操作增强类原理深度解析

# P81 原子类之基本类型原子类

基本类型原子类

- AtomicInteger
- AtomicBoolean
- AtomicLong
- 常见 API 简介
  - public final int get() // 获取当前的值
  - public final int getAndSet(int newValue) // 获取当前的值，并设置新的值
  - public final int getAndIncrement() // 获取当前的值，并自增
  - public final int getAndDecrement() // 获取当前的值，并自减
  - public final int getAndAdd(int delta) // 获取当前的值，并加上预期的值
  - boolean compareAndSet(int expect, int update) // 如果输入的数值等于预期值，则以原子方式将该值设置为输入值（update）
- Case
  - tsleep -> countDownLatch

# P82 原子类之数组类型原子类

数组类型原子类

- AtomicIntegerArray
- AtomicLongArray
- AtomicReferenceArray
- Case
  - 要求学生自学
  - 基本使用

# P83 原子类之引用类型原子类

引用类型原子类

- AtomicReference
  - 自旋锁 SpinLockDemo（1：02）
- AtomicStampedReference
  - 携带版本号的引用类型原子类，可以解决 ABA 问题
  - 解决修改过几次
  - 状态戳原子引用
    - ABADemo
- AtomicMarkableReference
  - 原子更新带有标记位的引用类型对象
  - 解决是否修改过
    - 它的定义就是将状态戳简化为 true/false
    - 类似一次性筷子
  - 状态戳（true/false）原子引用

# P84 原子类之对象的属性修改原子类理论

对象的属性修改原子类

- AtomicIntegerFieldUpdater
  - 原子更新对象中 int 类型字段的值
- AtomicLongFieldUpdater
  - 原子更新对象中 Long 类型字段的值
- AtomicReferenceFieldUpdater
  - 原子更新引用类型字段的值
- 使用目的
  - 以一种线程安全的方式操作非线程安全对象内的某些字段
- 使用要求
  - 更新的对象属性必须使用 public volatile 修饰符
  - 因为对象的属性修改类型原子类都是抽象类，所以每次使用都必须使用静态方法 newUpdater() 创建一个更新器，并且需要设置想要更新的类和属性
- 面试官问你：你在哪里用了 volatile
  - AtomicReferenceFieldUpdater
- Case
  - AtomicIntegerFieldUpdaterDemo
  - AtomicReferenceFieldUpdater

# P85 原子类之对象的属性修改原子类案例 01



# P86 原子类之对象的属性修改原子类案例 02



# P87 原子类值原子操作增强类理论入门

原子操作增强类原理深度解析

- DoubleAccumulator
- DoubleAdder
- LongAccumulator
- LongAdder
- 阿里要命题目（1：58）
- 点赞计数器，看看性能
- 源码、原理分析
- 小总结

# P88 原子类 LongAdder 和 LongAccumulator 简介

点赞计数器，看看性能

- 常用 API

  - （2：18）

    | 方法名              | 说明                                                         |
    | ------------------- | ------------------------------------------------------------ |
    | void add(long x)    | 将当前 value 加 x                                            |
    | void increment()    | 将当前 value 加 1                                            |
    | void decrement()    | 将当前 value 减 1                                            |
    | long sum()          | 返回当前值。特别注意，在没有并发更新 value 的情况下，sum 会返回一个精确值，在存在并发的情况下，sum 不保证返回精确值 |
    | long reset()        | 将 value 重置为 0，可用于替代重新 new 一个 LongAdder，但此方法只可以在没有并发更新的情况下使用。 |
    | long sumThenReset() | 获取当前 value，并将 value 重置为 0                          |

- 入门讲解

  - LongAdder 只能用来计算加法，且从零开始计算
  - LongAccumulator 提供了自定义的函数操作
  - LongAdderAPIDemo

- LongAdder 高性能对比 Code 演示

# P89 原子类之高性能热点商品点赞计算案例

# P90 原子类之 LongAdder 源码分析前置知识

源码、原理分析

- 架构（1：31）

- 原理（LongAdder 为什么这么快）

  - 官网说明和阿里要求（3：00）

  - LongAdder 是 Striped64 的子类

  - Striped64

    - Striped64 有几个比较重要的成员函数（5：24）

      - 最重要 2 个

        - （5：41）

          transient volatile Cell[] cells;

          transient volatile long base;

    - Striped64 中一些变量或者方法的定义（7：02）

  - Cell

    - 是 java.util.concurrent.atomic 下 Striped64 的一个内部类（7：33）

  - LongAdder 为什么这么快

- 源码解读深度分析

- 使用总结

# P91 原子类之 LongAdder 高性能原理说明

LongAdder 为什么这么快

- 一句话

  - （8：08）

    LongAdder 的基本思路就是分散热点，将 value 值分散到一个 Cell 数组中，不同线程会命中到数组的不同槽中，各个线程只对自己槽中的那个值进行 CAS 操作，这样热点就被分散了，冲突的概率就小很多。如果要获取真正的 long 值，只要将各个槽中的变量值累加返回

- 数学表达

  - 内部有一个 base 变量，一个 Cell[] 数组。
    - base 变量：低并发，直接累加到该变量上
    - Cell[] 数组：高并发，累加进各个线程自己的槽 Cell[i] 中
  - Value = Base + ∑Cell[i]

# P92 原子类之 LongAdder 源码分析 01

源码解读深度分析

- 小总结

  - （3：31）

    LongAdder 在无竞争的情况，跟 AtomicLong 一样，对同一个 base 进行操作，当出现竞争关系时则是采用化整为零分散热点的做法，用空间换时间，用一个数组 cells，将一个 value 拆分进这个数组 cells，多个线程需要同时对 value 进行操作时候，可以对线程 id 进行 hash 得到 hash 值，再根据 hash 值映射到这个数组 cells 的某个下标，再对该下标所对应的值进行自增操作。当所有线程操作完毕，将数组 cells 的所有值和 base 都加起来作为最终结果

- longAdder.increment()

  - add(1L)（5：35）
  - longAccumulate
  - sum

# P93 原子类之 LongAdder 源码分析 02

add(1L)

- 条件递增，逐步解析

# P94 原子类之 LongAdder 源码分析 03

条件递增，逐步解析

- 1、最初无竞争时只更新 base；
- 2、如果更新 base 失败后，首次新建一个 Cell[] 数组
- 3、当多个线程竞争同一个 Cell 比较激烈时，可能就要对 Cell[] 扩容
- 上述小总结

# P95 原子类之 LongAdder 源码分析 04

上述小总结（0：51）

# P96 原子类之 LongAdder 源码分析 05

longAccumulate

- longAccumulate 入参说明（1：52）
- Striped64 中一些变量或者方法的定义（2：42）
- 步骤
  - 线程 hash 值：probe（3：54）
  - 总纲（6：23）
  - 计算
    - 刚刚要初始化 Cell[] 数组（首次新建）
      - 未初始化过 Cell[] 数组，尝试占有锁并首次初始化 cells 数组（9：13）
    - 兜底
      - 多个线程尝试 CAS 修改失败的线程会走到这个分支（14：20）
    - Cell 数组不再为空且可能存在 Cell 数组扩容

# P97 原子类之 LongAdder 源码分析 06

Cell 数组不再为空且可能存在 Cell 数组扩容

- 多个线程同时命中一个 cell 的竞争
- 总体代码（0：39）
- 1（8：24）
- 2（9：25）
- 3（10：28）
- 4（11：01）
- 5（11：26）
- 6（11：56）
- 上 6 步骤总结（12：59）

# P98 原子类之 LongAdder 源码分析 07

- sum（0：31）

  - 为啥在并发情况下 sum 的值不精确

    - （1：46）

      sum 执行时，并没有限制对 base 和 cells 的更新（一句要命的话），所以 LongAdder 不是强一致性的，它是最终一致性的。

使用总结

- AtomicLong
  - 线程安全，可允许一些性能损耗，要求高精度时可使用
  - 保证精度，性能代价
  - AtomicLong 是多个线程针对单个热点值 value 进行原子操作
- LongAdder
  - 当需要在高并发下有较好的性能表现，且对值得精确度要求不高时，可以使用
  - 保证性能，精度代价
  - LongAdder 是每个线程拥有自己的槽，各个线程一般只对自己槽中的那个值进行 CAS 操作

# P99 原子类之原子操作增强类小总结

小总结

- AtomicLong
  - 原理
    - CAS+自旋
    - incrementAndGet
  - 场景
    - 低并发下的全局计算
    - AtomicLong 能保证并发情况下计数的准确性，其内部通过 CAS 来解决并发安全性的问题。
  - 缺陷
    - 高并发后性能急剧下降
    - why?
      - AtomicLong 的自旋会成为瓶颈（1：26）
- LongAdder
  - 原理
    - CAS + Base + Cell 数组分散
    - 空间换时间并分散了热点数据
  - 场景
    - 高并发下的全局计算
  - 缺陷
    - sum 求和后还有计算线程修改结果的话，最后结果不够准确

# P100 ThreadLocal 之是什么能干嘛

10、聊聊 ThreadLocal

- ThreadLocal 简介
  - 恶心的大厂面试题
    - ThreadLocal 中 ThreadLocalMap 的数据结构和关系？
    - ThreadLocal 的 key 是弱引用，这是为什么？
    - ThreadLocal 内存泄漏问题你知道吗？
    - ThreadLocal 中最后为什么要加 remove 方法？
    - ……
  - 是什么（1：54）
  - 能干嘛（3：09）
    - 反恐射击游戏画面（8：49）
  - api 介绍（10：25）
  - 永远的 helloworld 讲起
  - 通过上面代码总结
- ThreadLocal 源码分析
- ThreadLocal 内存泄露问题
- 小总结

# P101 ThreadLocal 之案例编码实战

永远的 helloworld 讲起

- 5 个销售卖房子，集团高层只关心销售总量的准确统计数，按照总销售额统计，方便集团公司给部分发送奖金
  - 群雄逐鹿起纷争
    - 为了数据安全只能加锁
  - Code
- 上述需求变化了……
  - 希望各自分灶吃饭，各凭销售本事提成，按照出单数各自统计
    - 比如某房产中介销售都有自己的销售额指标，自己专属自己的，不和别人掺和
- 上述需求该如何处理？？？
  - 人手一份天下安
  - Code
  - 阿里手册对使用 ThreadLocal 的规范
  - Code2

# P102 ThreadLocal 之阿里规范对 ThreadLocal 要求

- 阿里手册对使用 ThreadLocal 的规范（6：08）

通过上面代码总结

- 因为每个 Thread 内有自己的实例副本且该副本只由当前线程自己使用
- 既然其它 Thread 不可访问，那就不存在多线程间共享的问题
- 统一设置初始值，但是每个线程对这个值的修改都是各自线程互相独立的
- 一句话
  - 如何才能不争抢
    1. 加入 synchronized 或者 Lock 控制资源的访问顺序
    2. 人手一份，大家各自安好，没必要抢夺

# P103 ThreadLocal 之底层源码分析

ThreadLocal 源码分析

- 源码解读

- Thread, ThreadLocal, ThreadLocalMap 关系

  - Thread 和 ThreadLocal（2：20）

    - 再次体会，各自线程，人手一份

  - ThreadLocal 和 ThreadLocalMap（2：45）

  - All 三者总概括

    - （3：36）

      threadLocalMap 实际上就是一个以 threadLocal 实例为 key，任意对象为 value 的 Entry 对象

      当我们为 threadLocal 变量赋值，实际上就是以当前 threadLocal 实例为 key，值为 value 的 Entry 往这个 threadLocalMap 中存放

- 小总结（12：59）
