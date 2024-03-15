# 导航表

| key          | value                            |
| ------------ | -------------------------------- |
| **题目**     | 什么是 happens-before？          |
| **同义题目** | （暂无）                         |
| **主题**     | 多线程                           |
| **上推问题** | （什么是 Java 内存模型，待完成） |
| **平行问题** | （暂无）                         |
| **下切问题** | （暂无）                         |

# 1. Happens-Before 的定义

Happens-Before 的概念最初由 Leslie Lamport 在其一篇影响深远的论文（《Time, Clocks and the Ordering of Events in a Distributed System》）中提出。Leslie Lamport 使用 Happens-Before 来定义分布式系统中事件之间的偏序关系（partial ordering）。Leslie Lamport 在这篇论文中给出了一个分布式算法，该算法可以将该偏序关系扩展为某种全序关系。

JSR-133 使用 Happens-Before 的概念来指定两个操作之间的执行顺序。由于这两个操作可以在一个线程之内，也可以是在不同线程之间。因此，JMM 可以通过 Happens-Before 关系向程序员提供跨线程的内存可见性保证（如果 A 线程的写操作 a 与 B 线程的读操作 b 之间存在 Happens-Before 关系，尽管 a 操作和 b 操作在不同的线程中执行，但 JMM 向程序员保证 a 操作将对 b 操作可见）。

《JSR-133: Java Memory Model and Thread Specification》对 Happens-Before 关系的定义如下：

1. 如果一个操作 Happens-Before 另一个操作，那么第一个操作的执行结果将对第二个操作可见，而且第一个操作的执行顺序排在第二个操作之前。 
2. 两个操作之间存在 Happens-Before 关系，并不意味着 Java 平台的具体实现必须要按照 Happens-Before 关系指定的顺序来执行。如果重排序之后的执行结果，与按 Happens-Before 关系来执行的结果一致，那么这种重排序并不非法（也就是说，JMM允许这种重排序）。 

**上面的 1）是 JMM 对程序员的承诺**。从程序员的角度来说，可以这样理解 Happens-Before 关系：如果 A happens-before B，那么 Java 内存模型将向程序员保证——A 操作的结果将对 B 可见， 且 A 的执行顺序排在 B 之前。注意，这只是 Java 内存模型向程序员做出的保证！ 

**上面的 2）是 JMM 对编译器和处理器重排序的约束原则**。正如前面所言，JMM 其实是在遵循一个基本原则：只要不改变程序的执行结果（指的是单线程程序和正确同步的多线程程序），编译器和处理器怎么优化都行。JMM 这么做的原因是：程序员对于这两个操作是否真的被重排序并不关心，程序员关心的是程序执行时的语义不能被改变（即执行结果不能被改变）。因此，Happens-Before 关系本质上和 as-if-serial 语义是一回事。 

- as-if-serial 语义保证单线程内程序的执行结果不被改变，Happens-Before 关系保证正确同步的多线程程序的执行结果不被改变。 
- as-if-serial 语义给编写单线程程序的程序员创造了一个幻境：单线程程序是按程序的顺序来执行的。Happens-Before 关系给编写正确同步的多线程程序的程序员创造了一个幻境：正确同步的多线程程序是按 Happens-Before 指定的顺序来执行的。 

as-if-serial 语义和 Happens-Before 这么做的目的，都是为了在不改变程序执行结果的前提下，尽可能地提高程序执行的并行度。

# 2. Happens-Before 规则

Java 内存模型是通过各种操作来定义的，包括对变量的读 / 写操作，监视器的加锁和释放操作，以及线程的启动和合并操作。JMM 为程序中所有的操作定义了一个偏序关系，称之为 **Happens-Before**。

> **偏序关系** π 是集合上的一种关系，具有反对称、自反和传递属性，但对于任意两个元素 x，y 来说，并不需要一定满足 x π y 或 y π x 的关系。我们每天都在使用偏序关系来表达喜好，例如我们可以更喜欢寿司而不是干酪三明治，可以更喜欢莫扎特而不是马勒，但我们不必在干酪三明治和莫扎特之间作出明确的喜好选择。

要想保证执行操作 B 的线程看到操作 A 的结果（无论 A 和 B 是否在同一个线程中执行），那么在 A 和 B 之间必须满足 Happens-Before 关系。如果两个操作之间缺乏 Happens-Before 关系，那么 JVM 可以对它们任意地重排序。

当一个变量被多个线程读取并且至少被一个线程写入时，如果在读操作和写操作之间没有依照 Happens-Before 来排序，那么就会产生数据竞争问题。在正确同步的程序中不存在数据竞争，并会表现出串行一致性，这意味着程序中的所有操作都会按照一种固定的和全局的顺序执行。

Happen(s)-Before 规则说明了哪些指令不能重排。虽然 Java 虚拟机和执行系统会对指令进行一定的重排，但是指令重排是有原则的，并非所有的指令都可以随便改变执行位置，以下罗列了一些基本原则，这些原则是指令重排不可违背的：

- **程序顺序原则**：一个线程内保证语义的串行性。如果程序中操作 A 在操作 B 之前，那么在线程中 A 操作将在 B 操作之前执行。
- **volatile 变量规则**：volatile 变量的写先于读发生，这保证了 volatile 变量的可见性。
- **监视器锁规则**：在监视器锁上的解锁（unlock）操作必然发生在同一个监视器锁上的随后的加锁（lock）操作前。（显式锁和内置锁在加锁和解锁等操作上有着相同的内存语义）
- **传递性**：A 先于 B，B 先于 C，那么 A 必然先于 C。
- **线程启动规则**：线程的 start() 方法先于它的每一个动作。
- **线程结束规则**：线程的所有操作先于线程的终结（如 `Thread.join()`）。线程中的任何操作都必须在其他线程检测到该线程已经结束之前执行，或者从 `Thread.join` 中成功返回，或者在调用 `Thread.isAlive` 时返回 false。
- **中断规则**：线程的中断（`interrupt()`）先于被中断线程的代码。当一个线程在另一个线程上调用 interrupt 时，必须在被中断线程检测到 interrupt 调用之前执行（通过抛出 InterruptedException，或者调用 isInterrupted 和 interrupted）。
- **终结器规则**：对象的构造函数的执行、结束先于 `finalize()` 方法。

虽然这些操作只满足偏序关系，但同步操作，如锁的获取与释放等操作，以及 volatile 变量的读取与写入操作，都满足全序关系。因此，在描述 Happens-Before 关系时，就可以使用“后续的锁获取操作”和“后续的 volatile 变量读取操作”等表达术语。



Java 标准库类也定义了一些 happens-before 规则（关系），这些规则建立在 Java 内存模型所定义的基本 happens-before 规则之上。

例如，对于任意的 CountDownLatch 实例 countDownLatch，一个线程在 `countDownLatch.countDown()` 调用前所执行的所有动作与另外一个线程在 `countDownLatch.await()` 调用成功返回之后所执行的所有动作之间存在 happen-before 关系；对于任意的 BlockingQueue 实例 blockingQueue，一个线程在 `blockingQueue.put(E)` 调用所执行的所有动作与另外一个线程在 `blockingQueue.take()` 调用返回之后所执行的所有动作之间存在 happen-before 关系。

# 参考文档

- 《实战 Java 高并发程序设计》（第 2 版）1.5.4 哪些指令不能重排：Happen-Before 规则
- 《Java 并发编程实战》16.1.3 Java 内存模型简介
- 《Java 并发编程的艺术》 3.7.2 happens-before 的定义、3.7.3 happens-before 规则
- 《Java 多线程编程实战指南：核心篇》11.6.2 happen(s)-before 关系