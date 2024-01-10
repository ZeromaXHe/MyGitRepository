# 参考教程

尚硅谷SpringBoot3响应式编程教程，2024最新springboot入门到实战 

https://www.bilibili.com/video/BV1sC4y1K7ET

# 章节笔记

## P8 为什么有 Reactive Stream 规范

Java 9 中的 Flow 类定义了响应式编程的 API。实际上就是拷贝了 Reactive Stream 的四个接口定义，然后放在 java.util.concurrent.Flow 类中。Java 9 提供了 SubmissionPublisher 和 ConsumerSubscriber 两个默认实现。

### Reactive Manifesto

https://www.reactivemanifesto.org/zh-CN

反应式系统的特质：

- **即时响应性**：只要有可能，系统就会即时地做出响应。
- **回弹性**：系统在出现失败时依然保持即时响应性。
- **弹性**：系统在不断变化的工作负载之下依然保持即时响应性。
- **消息驱动**：反应式系统依赖异步的消息传递，从而确保了松耦合、隔离、位置透明的组件之间有着明确边界。这一边界还提供了将失败做完消息委托出去的手段。

价值：即时响应性
形式：弹性、回弹性
手段：消息驱动

### Reactive Streams

Reactive Streams 是 JVM 面向流的库的标准和规范

1. 处理可能无限数量的元素
2. 有序
3. 在组件之间异步传递元素
4. 强制性非阻塞背压模式（迭代的问题：1.迭代速度取决于数据量 2.数据还得有容器缓存；正压：正向压力，数据的生产者给消费者压力）

思路：让少量的线程一直忙，而不是让大量的线程一直切换等待

只要占了一个 CPU 核心的线程一直不闲，不等任何数据返回。数据到达后自动放到缓存区，worker 闲了去缓存区拿数据继续处理

## P9 消息传递是响应式核心

基于异步、消息驱动的全事件回调系统：响应式系统

## P10 Reactive-Stream 规范核心接口

API Components:

1. Publisher：发布者，产生数据流
2. Subscriber：订阅者，消费数据流
3. Subscription：订阅关系（订阅关系是发布者和订阅者之间的关键接口。订阅者通过订阅来表示对发布者产生的数据的兴趣。订阅者可以请求一定数量的元素，也可以取消订阅。）
4. Processor：处理器（处理器是同时实现了发布者和订阅者接口的组件。它可以接收来自一个发布者的数据，进行处理，并将结果发布给下一个订阅者。处理器在 Reactor 中充当中间环节，代表一个处理阶段，允许你在数据流中进行转换、过滤和其他操作。）

这种模型遵循 Reactive Streams 规范，确保了异步流的一致性和可靠性。

数据是自流动的，而不是靠迭代被动流动；

推拉模型：

推：流模式；上游有数据，自动推送给下游

拉：迭代器；自己遍历，自己拉取

Publisher(dataBuffer) -> 多个 Processor（Subscriber -> Publisher，既是订阅者又是发布者） -> Subscriber

## P11 Reactive-Stream 发布数据

见 FlowDemo

## P12 Reactive-Stream 发布订阅写法

见 FlowDemo

## P13 Reactive-Stream 四大核心组件

见 FlowDemo

响应式编程：

1. 底层：基于数据缓冲队列 + 消息驱动模型 + 异步回调机制
2. 编码：流式编程 + 链式调用 + 声明式 API
3. 效果：优雅全异步 + 消息实时处理 + 高吞吐量 + 占用少量资源

## P14 第二次课-小结

痛点：以前要做一个高并发系统：缓存、异步、队排好；手动控制整个逻辑
现在：全自动控制整个逻辑。只需要组装好数据处理流水线即可。

## P15 前情提要

Reactor 是基于 Reactive Streams 的第四代响应式库规范，用于在 JVM 上构建非阻塞应用程序；https://projectreactor.io

1. 一个完全非阻塞的，并提供高效的需求管理。它直接与 Java 的功能 API、CompletableFuture、Stream 和 Duration 交互。
2. Reactor 提供了两个响应式和可组合的 API，Flux[N] 和 Mono[0|1];
3. 适合微服务，提供基于 Netty 背压机制的网络引擎（HTTP、TCP、UDP）

高并发：“缓存、异步、队排好”
高可用：“分片、复制、选领导”

非阻塞的原理：缓冲 + 回调

1. 开线程不是解决问题的重点
2. 不要浪费时间去等待

## P16 响应式编程模型

1. 数据流：数据源头
2. 变化传播：数据操作（中间操作）
3. 异步编程模式：底层控制异步

这就是响应式编程

