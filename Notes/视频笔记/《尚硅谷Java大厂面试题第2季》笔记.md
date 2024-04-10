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

# P58 谈谈你对 GCRoots 的理解

题目1

1. JVM 垃圾回收的时候如何确定垃圾？是否知道什么是 GC Roots
   - 什么是垃圾
     - 简单的说就是内存中已经不再被使用到的空间就是垃圾
   - 要进行垃圾回收，如何判断一个对象是否可以被回收？
     - 引用计数法（3：18）
     - 枚举根节点做可达性分析（根搜索路径）（4：23）
       - case（8：04）
       - Java 中可以作为 GC Roots 的对象
         - 虚拟机栈（栈帧中的局部变量区）
         - 方法区中的类静态属性引用的对象
         - 方法区中常量引用的对象
         - 本地方法栈中 JNI（Native 方法）引用的对象。
2. 你说你做过 JVM 调优和参数设置，请问如何盘点查看 JVM 系统默认值
3. 你平时工作用过的 JVM 常用基本配置参数有哪些？
4. 强引用、软引用、弱引用、虚引用分别是什么？
5. 请谈谈你对 OOM 的认识
6. GC 垃圾回收算法和垃圾收集器的关系？分别是什么请你谈谈
7. 怎么查看服务器默认的垃圾收集器是那个？生产上如何配置垃圾收集器的？谈谈你对垃圾收集器的理解？
8. G1 垃圾收集器
9. 生产环境服务器变慢，诊断思路和性能评估谈谈？
10. 假如生产环境出现 CPU 占用过高，请谈谈你的分析思路和定位
11. 对于 JDK 自带的 JVM 监控和性能分析工具用过哪些？一般你是怎么用的？

# P59 JVM 的标配参数和 X 参数

2、你说你做过 JVM 调优和参数设置，请问如何盘点查看 JVM 系统默认值

- JVM 的参数类型
  - 标配参数（4：07）
    - -version
    - -help
    - java -showversion
  - X 参数（了解）（5：26）
    - -Xint
      - 解释执行
    - -Xcomp
      - 第一次使用就编译成本地代码
    - -Xmixed
      - 混合模式
  - XX 参数
- 盘点家底查看 JVM 默认值

# P60 JVM 的 XX 参数之布尔类型

XX 参数

- Boolean 类型
  - 公式
    - -XX:+ 或者 - 某个属性值
    - `+` 表示开启
    - `-` 表示关闭
  - Case
    - 是否打印 GC 收集细节
      - -XX:-PrintGCDetails（10：08）
      - -XX:+PrintGCDetails（10：16）
    - 是否使用串行垃圾回收器
      - -XX:-UseSerialGC
      - -XX:+UseSerialGC
- KV 设值类型
- jinfo 举例，如何查看当前运行程序的配置
- 题外话（坑题）

# P61 JVM 的 XX 参数之设值类型

KV 设值类型

- 公式
  - -XX:属性key=属性值value
- Case
  - -XX:MetaspaceSize=128m
  - -XX:MaxTenuringThreshold=15

# P62 JVM 的 XX 参数之 XmsXmx 坑题

jinfo 举例，如何查看当前运行程序的配置

- 公式
  - jinfo -flag 配置项 进程编号
- Case1（0：24）
- Case2（0：37）
- Case3（3：18）

题外话（坑题）

- 两个经典参数：-Xms 和 -Xmx
- 这个你如何解释
  - -Xms
    - 等价于 -XX:InitialHeapSize
  - -Xmx
    - 等价于 -XX:MaxHeapSize

# P63 JVM 盘点家底查看初始默认值

盘点家底查看 JVM 默认值

- -XX:+PrintFlagsInitial
  - 主要查看初始默认
  - 公式
    - java -XX:+PrintFlagsInitial -version
    - java -XX:+PrintFlagsInitial
  - Case（2：54）
- -XX:+PrintFlagsFinal
  - 主要查看修改更新
  - 公式
    - java -XX:+PrintFlagsFinal -version
    - java -XX:+PrintFlagsFinal -version
  - Case（6：50）
- PrintFlagsFinal 举例，运行 java 命令的同时打印出参数
- -XX:+PrintCommandLineFlags

# P64 JVM 盘点家底查看修改变更值

# P65 堆内存初始大小快速复习

3、你平时工作用过的 JVM 常用基本配置参数有哪些？

- 基础知识复习（1：28）
  - Case（2：05）
- 常用参数

# P66 常用基础参数栈内存 Xss 讲解

常用参数

- -Xms
  - 初始大小内存，默认为物理内存 1/64
  - 等价于 -XX:InitialHeapSize
- -Xmx
  - 最大分配内存，默认为物理内存 1/4
  - 等价于 -XX:MaxHeapSize
- -Xss
  - 设置单个线程栈的大小，一般默认为 512k ~ 1024k
  - 等价于 -XX:ThreadStackSize
- -Xmn
- -XX:MetaspaceSize
- 典型设置案例
- -XX:+PrintGCDetails
- -XX:SurvivorRatio
- -XX:NewRatio
- -XX:MaxTenuringThreshold

# P67 常用基础参数元空间 MetaspaceSize 讲解

-Xmn

- 设置年轻代大小

-XX:MetaspaceSize

- 设置元空间大小

  - 元空间的本质和永久代类似，都是对 JVM 规范中方法区的实现。不过元空间与永久代之间最大的区别在于：

    元空间并不在虚拟机中，而是使用本地内存。

    因此，默认情况下，元空间的大小仅受本地内存限制

- -Xms10m -Xmx10m -XX:MetaspaceSize=1024m -XX:+PrintFlagsFinal

典型设置案例

- （5：20）

  -Xms128m -Xmx4096m -Xss1024k -XX:MetaspaceSize=512m -XX:PrintCommandLineFlags -XX:+PrintGCDetails -XX:+UseSerialGC

# P68 常用基础参数 PrintGCDetails 回收前后对比讲解

-XX:+PrintGCDetails

- 输出详细 GC 收集日志信息
- GC
- FullGC

# P69 常用基础参数 SurvivorRatio 讲解

-XX:SurvivorRatio（3：14）

- 设置新生代中 eden 的 S0/S1 空间的比例

  默认

  -XX:SurvivorRatio=8, Eden:S0:S1 = 8:1:1

  假如

  -XX:SurvivorRatio=4, Eden:S0:S1 =  4:1:1

  SurvivorRatio 值就是设置 eden 区的比例占多少，S0/S1 相同

# P70 常用基础参数 NewRatio 讲解

-XX:NewRatio（4：31）

- 配置年轻代与老年代在堆结构的占比

  默认

  -XX:NewRatio=2 新生代占 1，老年代 2，年轻代占整个堆的 1/3

  假如

  -XX:NewRatio=4 新生代占 1，老年代 4，年轻代占整个堆的 1/5

  NewRatio 值就是设置老年代的占比，剩下的 1 给新生代

# P71 常用基础参数 MaxTenuringThreshold 讲解

-XX:MaxTenuringThreshold（0：31）

- 设置垃圾最大年龄

# P72 强引用 Reference

4、强引用、软引用、弱引用、虚引用分别是什么？

- 整体架构（2：04）
- 强引用（默认支持模式）（3：15）
  - case（5：02）
- 软引用
- 弱引用
- 虚引用

# P73 软引用 SoftReference

软引用（1：13）

# P74 弱引用 WeakReference

弱引用（1：31）

# P75 软引用和弱引用的适用场景

弱引用

- case
- 软引用和弱引用的适用场景（2：28）
- 你知道弱引用的话，能谈谈 WeakHashMap 吗？

# P76 WeakHashMap 案例演示和解析

# P77 虚引用简介

虚引用（0：29）

- 引出队列（4：42）
  - case
- case

# P78 ReferenceQueue 引用队列介绍

# P79 虚引用 PhantomReference

# P80 GCRoots 和四大引用小总结

GCRoots 和四大引用小总结（0：35）

# P81 SOFE 之 StackOverflowError

5、请谈谈你对 OOM 的认识

- java.lang.StackOverflowError
- java.lang.OutOfMemory: Java heap space
- java.lang.OutOfMemory: GC overhead limit exceeded
- java.lang.OutOfMemory: Direct buffer memory
- java.lang.OutOfMemory: unable to create new native thread
- java.lang.OutOfMemory: Metaspace

# P82 OOM 之 Java heap space

# P83 OOM 之 overhead limit exceeded

java.lang.OutOfMemory: GC overhead limit exceeded（1：01）

# P84 OOM 之 Direct buffer memory

java.lang.OutOfMemory: Direct buffer memory（1：42）

# P85 OOM 之 unable to create new native thread 故障演示

java.lang.OutOfMemory: unable to create new native thread（1：43）

# P86 OOM 之 unable to create new native thread 上限调整

java.lang.OutOfMemory: unable to create new native thread

- 非 root 用户登陆 Linux 系统测试
- 服务器级别调参调优（1：18）

# P87 OOM 之 Metaspace

java.lang.OutOfMemory: Metaspace

- 适用 java -XX:+PrintFlagsInitial 命令查看本机的初始化参数，-XX:Metaspacesize 为 218103768（大约 20.8M）（1：49）

# P88 垃圾收集器回收种类

6、GC 垃圾回收算法和垃圾收集器的关系？分别是什么请你谈谈

- GC 算法（引用计数/复制/标清/标整）是内存回收的方法论，垃圾收集器就是算法落地实现
- 因为目前为止还没有完美的收集器出现，更加没有万能的收集器，只是针对具体应用最合适的收集器，进行分代收集
- 4 种主要垃圾收集器（3：32）

# P89 串行并行并发 G1 四大垃圾回收方式

4 种主要垃圾收集器

- 串行垃圾收集器（Serial）

  - 它为单线程环境设计且只适用一个线程进行垃圾回收，会暂停所有的用户线程。所以不适合服务器环境

- 并行垃圾收集器（Parallel）

  - 多个垃圾收集线程并行工作，此时用户线程是暂停的，适用于科学计算/大数据处理首台处理等弱交互场景

- 并发垃圾回收器（CMS）

  - 用户线程和垃圾收集线程同时执行（不一定是并行，可能交替执行），不需要停顿用户线程

    互联网公司多用它，适用对响应时间有要求的场景

- 上述 3 个小总结，G1 特殊后面说（7：52）

- G1 垃圾回收器

  - G1 垃圾回收器适用于堆内存很大的情况，他将堆内存分割成不同的区域然后并发的对其进行垃圾回收

# P90 如何查看默认的垃圾收集器

7、怎么查看服务器默认的垃圾收集器是那个？生产上如何配置垃圾收集器的？谈谈你对垃圾收集器的理解？

- 怎么查看默认的垃圾收集器是哪个？（5：36）
- 默认的垃圾收集器有哪些？
- 垃圾收集器
- 如何选择垃圾收集器

# P91 JVM 默认的垃圾收集器有哪些

默认的垃圾收集器有哪些？

- （0：29）

  java 的 gc 回收的类型主要有几种：

  UseSerialGC, UseParallelGC, UseConcMarkSweepGC, UseParNewGC, UseParallelOldGC, UseG1GC

# P92 GC 之 7 大垃圾收集器概述

垃圾收集器（1：10）

# P93 GC 之约定参数说明

垃圾收集器

- 部分参数预先说明

  - DefNew
    - Default New Generation
  - Tenured
    - Old
  - ParNew
    - Parallel New Generation
  - PSYoungGen
    - Parallel Scavenge
  - ParOldGen
    - Parallel Old Generation

- Server/Client 模式分别是什么意思

  - （3：32）

    1. 适用范围：只需要掌握 Server 模式即可，Client 模式基本不会用

    2. 操作系统：

       2.1 32 位 Windows 操作系统，不论硬件如何都默认使用 Client 的 JVM 模式

       2.2 32 位其它操作系统，2G 内存同时有 2 个 cpu 以上用 Server 模式，低于该配置还是 Client 模式

       2.3 64 位 only server 模式

- 新生代

- 老年代

- 垃圾收集器配置代码总结

# P94 GC 之 Serial 收集器

新生代

- 串行 GC（Serial）/（Serial Copying）

  - （1：30）

    没有线程交互的开销可以获得最高的单线程垃圾收集效率，因此 Serial 垃圾收集器依然是 java 虚拟机运行在 Client 模式下默认的新生代垃圾收集器。

    对应 JVM 参数是：-XX:+UseSerialGC

    开启后会使用：Serial（Young 区用）+ Serial Old（Old 区用）的收集器组合

    表示：新生代、老年代都会使用串行回收收集器，新生代使用复制算法，老年代使用标记-整理算法

- 并行 GC（ParNew）

- 并行回收 GC（Parallel）/（Parallel Scavenge）

# P95 GC 之 ParNew 收集器

并行 GC（ParNew）

- （0：42）

  它是很多 java 虚拟机运行在 Server 模式下新生代的默认垃圾收集器

  常用对应 JVM 参数：-XX:+UseParNewGC 启用 ParNew 收集器，只影响新生代的收集，不影响老年代

  开启上述参数后，会使用：ParNew（Young 区用）+ Serial Old 的收集器组合，新生代使用复制算法，老年代采用标记-整理算法

# P96 GC 之 Parallel 收集器

并行回收 GC（Parallel）/（Parallel Scavenge）

- （2：27）

  可控制的吞吐量

  自适应调节策略

  常用 JVM 参数：-XX:+UseParallelGC 或 -XX:+UseParallelOldGC（可互相激活）使用 Parallel Scavenge 收集器

  开启该参数后：新生代使用复制算法，老年代使用标记-整理算法

# P97 GC 之 ParallelOld 收集器

老年代

- 串行 GC（Serial Old）/（Serial MSC）

- 并行 GC（Parallel Old）/（Parallel MSC）

  - （1：30）

    Parallel Old 收集器是 Parallel Scavenge 的老年代版本，使用多线程的标记-整理算法，Parallel Old 收集器在 JDK 1.6 才开始提供

    JVM 常用参数：

    -XX:+UseParallelOldGC 使用 Parallel Old 收集器，设置该参数后，新生代 Parallel + 老年代 Parallel Old

- 并发标记清除 GC（CMS）

# P98 GC 之 CMS 收集器

并发标记清除 GC（CMS）

- （1：36）

  CMS 收集器（Concurrent Mark Sweep：并发标记清除）是一种以获取最短回收停顿时间为目标的收集器。

  并发收集低停顿，并发指的是与用户线程一起执行

  开启该收集器的 JVM 参数：-XX:+UseConcMarkSweepGC 开启该参数后会自动将 -XX:+UseParNewGC 打开

  开启该参数后，使用 ParNew(Young 区用) + CMS(Old 区用) + Serial Old 的收集器组合，Serial Old 将作为 CMS 出错的后备收集器

- 4 步过程

  - 初始标记（CMS initial mark）
  - 并发标记（CMS concurrent mark）和用户线程一起（6：07）
  - 重新标记（CMS remark）（6：58）
  - 并发清除（CMS concurrent sweep）和用户线程一起（7：50）
  - 四步概述（8：50）

- 优缺点

  - 优
    - 并发收集低停顿
  - 缺
    - 并发执行，对 CPU 资源压力大（10：23）
    - 采用的标记清除算法会导致大量碎片（11：48）

# P99 GC 之 SerialOld 收集器

串行 GC（Serial Old）/（Serial MSC）

- （0：26）

  Serial Old 是 Serial 垃圾收集器老年代版本，它同样是个单线程的收集器，使用标记-整理算法，这个收集器也主要是运行在 Client 默认的 java 虚拟机的年老代垃圾收集器

  在 Server 模式下，主要有两个用途（了解，版本已经到 8 及以后）：

  1. 在 JDK 1.5 之前版本中与新生代的 Parallel Scavenge 收集器搭配使用。（Parallel Scavenge + Serial Old）
  2. 作为老年代版中使用 CMS 收集器的后备垃圾收集方案

垃圾收集器配置代码总结

- 底层代码（2：42）
- 实际代码（2：58）

# P100 GC 之如何选择垃圾收集器

如何选择垃圾收集器（2：07）

# P101 GC 之 G1 收集器

8、G1 垃圾收集器

- 以前收集器特点
  - 年轻代和老年代是各自独立且连续的内存块
  - 年轻代收集使用单 eden + S0 + S1 进行复制算法
  - 老年代收集必须扫描整个老年代区域
  - 都是以尽可能少而快速地执行 GC 为设计原则
- G1 是什么（5：54）
  - 特点（12：28）
- 底层原理
- case 案例
- 常用配置参数（了解）
- 和 CMS 相比的优势
- 小总结

# P102 GC 之 G1 底层原理

底层原理

- Region 区域化垃圾收集器（2：38）
  - 最大好处是化整为零，避免全内存扫描，只需要按照区域来进行扫描即可
- 回收步骤（7：11）
- 4 步过程（9：55）

# P103 GC 之 G1 参数配置及和 CMS 的比较

case 案例（0：09）

常用配置参数（了解）（3：50）

- -XX:+UseG1GC
- -XX:G1HeapRegionSize=n：设置的 G1 区域的大小。值是 2 的幂，范围是 1 MB 到 32 MB。目标是根据最小的 Java 堆大小划分出约 2048 个区域
- -XX:MaxGCPauseMillis=n：最大 GC 停顿时间，这是个软目标，JVM 将尽可能（但不保证）停顿小于这个时间
- -XX:InitiatingHeapOccupancyPercent=n：堆占用了多少的时候就触发 GC，默认为 45
- -XX:ConcGCThreads=n：并发 GC 使用的线程数
- -XX:G1ReservePercent=n：设置作为空闲空间的预留内存百分比，以降低目标空间溢出的风险，默认值是 10%

和 CMS 相比的优势（6：31）

# P104 JVMGC 结合 SpringBoot 微服务优化简介

# P105 Linux 命令之 top

9、生产环境服务器变慢，诊断思路和性能评估谈谈？

- 整机：top
  - uptime，系统性能命令的精简版
- CPU：vmstat
- 内存：free
- 硬盘：df
- 磁盘 IO：iostat
- 网络 IO：ifstat

# P106 Linux 之 cpu 查看 vmstat

CPU：vmstat

- 查看 CPU（包含不限于）（1：44）
- 查看额外

# P107 Linux 之 cpu 查看 pidstat

查看额外

- 查看所有 cpu 核信息
  - mpstat -P ALL 2
- 每个进程使用 cpu 的用量分解信息
  - pidstat -u 1 -p 进程编号

# P108 Linux 之内存查看 free 和 pidstat

内存：free

- 应用程序可用内存数（0：35）
- 查看额外
  - pidstat -p 进程号 -r 采样间隔秒数

# P109 Linux 之硬盘查看 df

硬盘：df

- 查看磁盘剩余空间数（0：14）

# P110 Linux 之磁盘 IO 查看 iostat 和 pidstat

磁盘 IO：iostat

- 磁盘 I/O 性能评估（0：41）
- 查看额外
  - pidstat -d 采样间隔秒数 -p 进程号

# P111 Linux 之网络 IO 查看 ifstat

网络 IO：ifstat

- 默认本地没有，下载 ifstat（0：36）
- 查看网络 IO（0：59）

# P112 CPU 占用过高的定位分析思路

10、假如生产环境出现 CPU 占用过高，请谈谈你的分析思路和定位

- 结合 Linux 和 JDK 命令一块分析
- 案例步骤
  1. 先用 top 命令找出 CPU 占比最高的（1：46）
  2. ps -ef 或者 jps 进一步定位，得知是一个怎么样的一个后台程序给我们惹事（2：33）
  3. 定位到具体线程或者代码
     - ps -mp 进程 -o THREAD,tid,time（4：41）
     - 参数解释
       - -m 显示所有的线程
       - -p pid 进程使用 cpu 的时间
       - -o 该参数后是用户自定义格式
  4. 将需要的线程 ID 转换为 16 进制格式（英文小写格式）
     - printf "%x\n" 有问题的线程 ID
  5. jstack 进程 ID | grep tid（16 进制线程 ID 小写英文） -A60
