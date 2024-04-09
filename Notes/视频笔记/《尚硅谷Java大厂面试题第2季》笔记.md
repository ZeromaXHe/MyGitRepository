尚硅谷Java大厂面试题第2季，面试必刷，跳槽大厂神器

https://www.bilibili.com/video/BV18b411M7xz

2019-04-11 13:21:31

# P1 本课程前提要求和说明

互联网面试题

讲师：尚硅谷周阳

2019.3V1.4

1. 前提知识 + 要求
2. Java 基础
3. JUC 多线程及高并发
4. JVM + GC 解析
   - 前提复习
   - 节外生枝补充知识
   - 题目
     1. JVM 垃圾回收的时候如何确定垃圾？
     2. 你说说你做过 JVM 调优和参数配置，请问如何查看 JVM 系统默认值
     3. 你平时工作用过的 JVM 常用基本配置参数有哪些？
     4. 请谈谈你对 OOM 的认识
        - java.lang.StackOverflowError
        - java.lang.OutOfMemory: Java heap space
        - java.lang.OutOfMemory: GC overhead limit exceeded
        - java.lang.OutOfMemory: Direct buffer memory
        - java.lang.OutOfMemory: Metaspace
        - java.lang.OutOfMemory: unable to create new native thread
        - java.lang.OutOfMemory: Requested array size exceeds VM limit
     5. GC 回收算法和垃圾收集器的关系？另外，串行收集/并行收集/并发收集/STW 是什么？
     6. 怎么查看服务器默认的垃圾收集器是哪个？生产上你是如何配置垃圾收集器的？谈谈你的理解？
     7. G1 垃圾收集器
     8. 强引用、软引用、弱引用、虚引用分别是什么？
     9. 生产环境服务器变慢，诊断思路和性能评估谈谈？
     10. 假如生产环境出现 CPU 占用过高，请谈谈你的分析思路和定位
     11. 对于 JDK 自带的 JVM 监控和性能分析工具用过哪些？一般你是怎么用的？
         - 概览
         - 性能监控工具
           - jps
             - 官网
             - 解释
             - Case
           - jinfo
           - jmap
           - jstat
           - jstack
     12. JVM 的字节码指令接触过吗？
5. 消息中间件 MQ
   1. 消息队列的主要作用是什么？
   2. 你项目好好的情况下，为什么要引入消息队列？引入的理由是什么？
   3. 项目里你们是怎么用消息队列的？
   4. 你在项目中是如何保证消息队列的高可用
   5. kafka、activemq、rabbitmq、rocketmq 都有什么区别
   6. MQ 在高并发情况下假设队列满了如何防止消息丢失
   7. 消费者消费信息，如何保证 MQ 幂等性
   8. 谈谈你对死信队列的理解
   9. 如果百万级别的消息积压了，你们如何处理？
   10. 你们为什么不用其他的 MQ，最终选择了 RocketMQ？
6. NoSQL 数据库 Redis
   1. 在你的项目中，哪些数据是数据库和 Redis 缓存双写一份的？如何保证双写一致性？
   2. 系统上线，redis 缓存系统是如何部署的
   3. 系统上线，redis 缓存给了多大的总内存？命中率有多高？扛住了多少 QPS？数据流回源会有多少 QPS？
   4. 热 Key 大 Value 问题，某个 key 出现了热点缓存导致缓存集群中的某个机器负载过高？如何发现并解决
   5. 超大 Value 打满网卡的问题如何规避这样的问题
   6. 你过往的工作经历中，是否出现过缓存集群事故？说说细节并说说高可用保障的方案
   7. 平时如何监控缓存集群的 QPS 和容量
   8. 缓存集群如何扩容？？
   9. 说下 redis 的集群原理和选举机制
   10. Key 寻址算法有哪些？
   11. Redis 线程模型现场画个图说说
   12. Redis 内存模型现场画个图说说
   13. Redis 的底层数据结构了解多少？
   14. Redis 的单线程特性有什么优缺点？
   15. 你们怎么解决缓存击穿问题的？
7. Spring 原理
8. Netty + RPC
9. 网络通信与协议
10. 数据库
11. SpringBoot + SpringCloud + Dubbo
12. 项目

# P2 volatile 是什么

3、JUC 多线程及高并发

1. 请谈谈你对 volatile 的理解
   1. volatile 是 Java 虚拟机提供的轻量级的同步机制
      - 1.1 保证可见性
      - 1.2 不保证原子性
      - 1.3 禁止指令重排
   2. JMM 你谈谈
   3. 你在哪些地方用到过 volatile
2. CAS 你知道吗？
3. 原子类 AtomicInteger 的 ABA 问题谈谈？原子更新引用知道吗？
4. 我们知道 ArrayList 是线程不安全，请编码写一个不安全的案例并给出解决方案。
5. 公平锁/非公平锁/可重入锁/递归锁/自旋锁谈谈你的理解？请手写一个自旋锁
6. CountDownLatch/CyclicBarrier/Semaphore 使用过吗？
7. 阻塞队列知道吗？
8. 线程池用过吗？ThreadPoolExecutor 谈谈你的理解？
9. 线程池用过吗？生产上你如何设置合理参数
10. 死锁编码及定位分析

# P3 JMM 内存模型之可见性

2、JMM 你谈谈（2：07）

# P4 可见性的代码验证说明

2、JMM 你谈谈

- 2.1 可见性
- 2.2 原子性
- 2.3 VolatileDemo 代码演示可见性 + 原子性代码
- 2.4 有序性

# P5 volatile 不保证原子性

2.1 可见性（00：17）

# P6 volatile 不保证原子性理论解释

2.2 原子性

- number++ 在多线程下是非线程安全的，如果不加 synchronized 解决？（8：12）

# P7 volatile 不保证原子性问题解决

# P8 volatile 指令重排案例1

2.4 有序性（2：01）

- 重排1（10：21）
- 重排2（13：52）
  - 案例
- 禁止指令重排小总结

# P9 volatile 指令重排案例 2

- 案例（4：50）

禁止指令重排小总结（8：25）

2.1、2.2、2.3、2.4 }-> 线程安全性获得保证（12：35）

# P10 单例模式在多线程环境中可能存在安全问题

3、你在哪些地方用到过 volatile？

- 3.1 单例模式 DCL 代码
- 3.2 单例模式 volatile 分析

# P11 单例模式 volatile 分析

3.2 单例模式 volatile 分析

- （12：12）

  DCL（双端检锁）机制不一定线程安全，原因是有指令重排序的存在，加入 volatile 可以禁止指令重排

  原因在于某一个线程执行到第一次检测，读取到的 instance 不为 null 时，instance 的引用对象可能没有完成初始化。instance = new SingletonDemo(); 可以分为以下 3 步完成（伪代码）

  memory = allocate(); // 1. 分配对象内存空间

  instance(memory); // 2. 初始化对象

  instance = memory; // 3. 设置 instance 指向刚分配的内存地址，此时 instance != null

  步骤 2 和步骤 3 不存在数据依赖关系，而且无论重排前还是重排后程序的执行结构在单线程中并没有改变，因此这种重排优化是允许的。

# P12 CAS 是什么

2、CAS 你知道吗？

1. 比较并交换
   - CASDemo 代码
2. CAS 底层原理？如果知道，谈谈你对 UnSafe 的理解
3. CAS 缺点

# P13 CAS 底层原理-上

2、CAS 底层原理？如果知道，谈谈你对 UnSafe 的理解

- atomicInteger.getAndIncrement();
- UnSafe（10：05）
- CAS 是什么（14：10）
  - unsafe.getAndAddInt
  - 底层汇编
  - 简单版小总结

3、CAS 缺点

- 循环时间长开销很大
- 只能保证一个共享变量的原子操作
- 引出来 ABA 问题？？？

# P14 CAS 底层原理-下

CAS 是什么

- unsafe.getAndAddInt（0：21）

- 底层汇编

  - （10：36）

    cmpxchg

- 简单版小总结（12：00）

# P15 CAS 缺点

3、CAS 缺点

- 循环时间长开销很大（1：17）
- 只能保证一个共享变量的原子操作（3：48）
- 引出来 ABA 问题？？？

# P16 ABA 问题

3、原子类 AtomicInteger 的 ABA 问题谈谈？原子更新引用知道吗？

- ABA 问题怎么产生的（10:21）
- 原子引用
- 时间戳原子引用

# P17 AtomicReference 原子引用

# P18 AtomicStampedReference 版本号原子引用

# P19 ABA 问题的解决

# P20 集合类不安全之并发修改异常

4、我们知道 ArrayList 是线程不安全，请编码写一个不安全的案例并给出解决方案

# P21 集合类不安全之写时复制

4、我们知道 ArrayList 是线程不安全，请编码写一个不安全的案例并给出解决方案

- 解决方案1
  - ContainerNotSafeDemo
- 限制不可以用 Vector 和 Collections 工具类解决方案2

# P22 集合类不安全之 Set

# P23 集合类不安全之 Map

# P24 TransferValue 醒脑小练习

# P25 java 锁之公平和非公平锁

5、公平锁/非公平锁/可重入锁/递归锁/自旋锁谈谈你的理解？请手写一个自旋锁

- 公平和非公平锁
  - 是什么（6：29）
  - 两者区别（8：35）
  - 题外话（11：06）
- 可重入锁（又名递归锁）
- 自旋锁
  - SpinLockDemo
- 独占锁（写锁）/共享锁（读锁）/互斥锁

# P26 java 锁之可重入锁和递归锁理论知识

可重入锁（又名递归锁）

- 是什么（1：42）
- ReentrantLock/Synchronized 就是一个典型的可重入锁
- 可重入锁最大的作用是避免死锁
- ReentrantLockDemo
  - 参考1
  - 参考2

# P27 java 锁之可重入锁和递归锁代码验证

# P28 java 锁之自旋锁理论知识

自旋锁（6：34）

- SpinLockDemo

# P29 java 锁之自旋锁代码验证

# P30 java 锁之读写锁理论知识

独占锁（写锁）/共享锁（读锁）/互斥锁（1：19）

- ReadWriteLockDemo

# P31 java 锁之读写锁代码验证

# P32 CountDownLatch

6、CountDownLatch/CyclicBarrier/Semaphore 使用过吗？

# P33 CyclicBarrierDemo

6、CountDownLatch/CyclicBarrier/Semaphore 使用过吗？

- CountDownLatch
  - 让一些线程阻塞直到另一些线程完成一系列操作后才被唤醒
  - CountDownLatch 主要有两个方法，当一个或多个线程调用 await 方法时，调用线程会被阻塞。其他线程调用 countDown 方法会将计数器减 1（调用 countDown 方法的线程不会阻塞），当计数器的值变为零时，因调用 await 方法被阻塞的线程会被唤醒，继续执行。
  - CountDownLatchDemo
- CyclicBarrier
  - CyclicBarrier 的字面意思是可循环（Cyclic）使用的屏障（Barrier）。它要做的事情是，让一组线程到达一个屏障（也可以叫同步点）时被阻塞，直到最后一个线程到达屏障时，屏障才会开门，所有被屏障拦截的线程才会继续干活，线程进入屏障通过 CyclicBarrier 的 await() 方法。
  - CyclicBarrierDemo
    - 集齐 7 颗龙珠就能召唤神龙
    - 代码
- Semaphore

# P34 SemaphoreDemo

Semaphore

- 信号量最主要用于两个目的，一个是用于多个共享资源的互斥使用，另一个用于并发线程数的控制
- SemaphoreDemo
  - 争车位
  - 代码

# P35 阻塞队列理论

# P36 阻塞队列接口结构和实现类

7、阻塞队列知道吗？

- 队列 + 阻塞队列

  - （1：57）

    当阻塞队列是空时，从队列中获取元素的操作将会被阻塞

    当阻塞队列是满时，往队列中添加元素的操作将会被阻塞

- 为什么用？有什么好处？（5：39）

- BlockingQueue 的核心方法

  - （19：40）

    | 方法类型 | 抛出异常  | 特殊值   | 阻塞   | 超时                 |
    | -------- | --------- | -------- | ------ | -------------------- |
    | 插入     | add(e)    | offer(e) | put(e) | offer(e, time, unit) |
    | 移除     | remove()  | poll()   | take() | poll(time, unit)     |
    | 检查     | element() | peek()   | 不可用 | 不可用               |

    抛出异常：

    - 当阻塞队列满时，再往队列里 add 插入元素会抛 IllegalStateException：Queue full
    - 当阻塞队列空时，再往队列里 remove 移除元素会抛 NoSuchElementException

    特殊值：

    - 插入方法，成功 true 失败 false
    - 移除方法，成功返回出队列的元素，队列里面没有就返回 null

    一直阻塞：

    - 当阻塞队列满时，生产者线程继续往队列里 put 元素，队列会一直阻塞生产线程直到 put 数据 or 响应中断退出。
    - 当阻塞队列空时，消费者线程试图从队列里 take 元素，队列会一直阻塞消费者线程直到队列可用。

    超时退出：

    - 当阻塞队列满时，队列会阻塞生产者线程一定时间，超过限时后生产者线程会退出

- 架构梳理 + 种类分析

  - 架构介绍（11:15）
  - 种类分析
    - ArrayBlockingQueue：由数组结构组成的有界阻塞队列
    - LinkedBlockingQueue：由链表结构组成的有界（但大小默认值为 Integer.MAX_VALUE）阻塞队列
    - PriorityBlockingQueue：支持优先级排序的无界阻塞队列
    - DelayQueue：使用优先级队列实现的延迟无界阻塞队列
    - SynchronousQueue：不存储元素的阻塞队列，也即单个元素的队列
      - 理论
      - SynchronousQueueDemo
    - LinkedTransferQueue：由链表结构组成的无界阻塞队列
    - LinkedBlockingDeque：由链表结构组成的双向阻塞队列

- 用在哪里

# P37 阻塞队列 api 之抛出异常组

# P38 阻塞队列 api 之返回布尔值组

# P39 阻塞队列 api 之阻塞和超时控制

# P40 阻塞队列之同步 SynchronousQueue 队列

# p41 线程通信之生产者消费者传统版

用在哪里

- 生产者消费者模式
  - 传统版
    - ProdConsumer_TraditionDemo
  - 阻塞队列版
    - ProdConsumer_BlockQueueDemo
- 线程池
- 消息中间件

# P42 Synchronized 和 Lock 有什么区别

# P43 锁绑定多个条件 Condition

# P44 线程通信之生产者消费者阻塞队列版

# P45 Callable 接口

# P46 线程池使用及优势

8、线程池用过吗？ThreadPoolExecutor 谈谈你的理解？

- 为什么用线程池，优势

  - （9：51）

    线程池做的工作主要是控制运行的线程的数量，处理过程中将任务放入队列，然后在线程创建后启动这些任务，如果线程数量超过了最大数量超出数量的线程排队等候，等其它线程执行完毕，再从队列中取出任务来执行。

    他的主要特点为：线程复用；控制最大并发数；管理线程。

    第一：降低资源消耗

    第二：提高响应速度

    第三：提高线程的可管理性

- 线程池如何使用？

  - 架构说明
  - 编码实现
  - ThreadPoolExecutor

- 线程池的几个重要参数介绍？

- 说说线程池的底层工作原理？

# P47 线程池 3 个常用方式

编码实现

- 了解
  - Executors.newScheduledThreadPool()
  - java8 新出
    - Executors.newWorkStealingPool(int)
      - java8 新增，使用目前机器上可用的处理器作为它的并行级别
- 重点
  - Executors.newFixedThreadPool(int)（19：58）
    - 执行长期的任务，性能好很多
  - Executors.newSingleThreadExecutor()（20：39）
    - 一个任务一个任务执行的场景
  - Executors.newCachedThreadPool()（21：21）
    - 适用：执行很多短期异步的小程序或者负载较轻的服务器

# P48 线程池 7 大参数入门简介

- ThreadPoolExecutor（1：54）

线程池的几个重要参数介绍？

- 7 大参数（6：08）

# P49 线程池 7 大参数深入介绍

- 7 大参数
  1. corePoolSize：线程池中的常驻核心线程数
  2. maximumPoolSize：线程池能够容纳同时执行的最大线程数，此值必须大于等于 1
  3. keepAliveTime：多余的空闲线程的存活时间。当前线程池数量超过 corePoolSize 时，当空闲时间达到 keepAliveTime 值时，多余空闲线程会被销毁直到只剩下 corePoolSize 个线程为止
  4. unit：keepAliveTime 的单位。
  5. workQueue：任务队列，被提交但尚未被执行的任务。
  6. threadFactory：表示生成线程池中工作线程的线程工厂，用于创建线程一般用默认的即可。
  7. handler：拒绝策略，表示当队列满了并且工作线程大于等于线程池的最大线程数（maximumPoolSize）时如何来拒绝

说说线程池的底层工作原理？（17：21）

# P50 线程池底层工作原理

# P51 线程池的 4 种拒绝策略理论简介

9、线程池用过吗？生产上你如何设置合理参数

- 线程池的拒绝策略你谈谈
  - 是什么（1：01）
  - JDK 内置的拒绝策略
    - AbortPolicy（默认）：直接抛出 RejectedExecutionException 异常阻止系统正常运行。
    - CallerRunsPolicy：“调用者运行”一种调节机制，该策略既不会抛弃任务，也不会抛出异常，而是将某些任务回退到调用者，从而降低新任务的流量。
    - DiscardOldestPolicy：抛弃队列中等待最久的任务，然后把当前任务加入队列中尝试再次提交当前 任务。
    - DiscardPolicy：直接丢弃任务，不予任何处理也不抛出异常。如果允许任务丢失，这是最好的一种方案。
  - 以上内置拒绝策略均实现了 RejectedExecutionHandler 接口
- 你在工作中单一的/固定数的/可变的三种创建线程池的方法，你用哪个多？超级大坑
- 你在工作中是如何使用线程池的，是否自定义过线程池使用
  - Case
- 合理配置线程池你是如何考虑的？

# P52 线程池实际中使用哪一个

你在工作中单一的/固定数的/可变的三种创建线程池的方法，你用哪个多？超级大坑

- 答案是一个都不用，我们生产上只能使用自定义的

- Executors 中 JDK 已经给你提供了，为什么不用？

  - （5：10）

    阿里巴巴 Java 开发手册

    4、【强制】线程池不允许使用 Executors 去创建，而是通过 ThreadPoolExecutor 的方式

    说明：Executors 返回的线程池对象的弊端如下：

    1）FixedThreadPool 和 SingleThreadPool：

    允许的请求队列长度为 Integer.MAX_VALUE，可能会堆积大量的请求，从而导致 OOM。

    2）CachedTheadPool 和 ScheduledThreadPool：

    允许的创建线程数量为 Integer.MAX_VALUE，可能会创建大量的线程，从而导致 OOM。

# P53 线程池的手写改造和拒绝策略

# P54 线程池配置合理线程数

合理配置线程池你是如何考虑的？

- CPU 密集型

  - （3：32）

    一般公式：CPU 核数 + 1 个线程的线程池

- IO 密集型

  - 1

    - （4：49）

      由于 IO 密集型任务线程并不是一直在执行任务，则应配置尽可能多的线程，如 CPU 核数 * 2

  - 2

    - （5：36）

      IO 密集型时，大部分线程都阻塞，故需要多配置线程数：

      参考公式：CPU 核数 / （1 - 阻塞系数），阻塞系数在 0.8 ~ 0.9 之间

# P55 死锁编码及定位分析

10、死锁编码及定位分析

- 是什么（1：34）
  - 产生死锁的主要原因
    - 系统资源不足
    - 进程进行推进的顺序不合适
    - 资源分配不当
- 代码
- 解决
  - jps 命令定位进程号
  - jstack 找到死锁查看

# P56 JVM GC 下半场技术加强说明和前提知识要求

4、JVM + GC 解析

- 前提复习
- 题目1
- 题目2
- 其它

# P57 JVM GC 快速回顾复习串讲

前提复习

- JVM 内存结构

  - JVM 体系概述（0：50）
  - Java 8 以后的 JVM（2：39）

- GC 的作用域

  - （3：36）

    方法区、堆

- 常见的垃圾回收算法

  - 引用计数（4：01）
  - 复制（5：36）
  - 标记清除（6：54）
  - 标记整理（7：44）
