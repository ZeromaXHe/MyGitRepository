# 简答

应用程序有的需要“**至少一次**”（at-least-once）语义（意味着没有数据丢失），有的还需要“**仅一次**”（exactly-once）语义。即需要保证数据不丢失（消息可靠性传输）和消息不被重复消费（消息消费的幂等性）。

对于**保证无消息丢失**，我们可以对 Kafka 进行如下配置：

- block.on.buffer.full = true
- acks = all or -1
- retries = Integer.MAX_VALUE
- max.in.flight.requests.per.connection = 1
- 使用带回调机制的 send 发送消息，即 `KafkaProducer.send(record, callback)`
- Callback 逻辑中显式地立即关闭 producer，使用 `close(0)`
- unclean.leader.election.enable = false
- replication.factor = 3
- min.insync.replicas = 2
- replication.factor > min.insync.replicas
- enable.auto.commit = false

而**保证消息消费的幂等性**则可以：

实现仅一次处理最简单且最常用的办法是把结果写到一个支持唯一键的系统里，比如键值存储引擎、关系型数据库、ElasticSearch 或其他数据存储引擎。在这种情况下，要么消息本身包含一个唯一键（通常都是这样），要么使用主题、分区和偏移量的组合来创建唯一键——它们的组合可以唯一标识一个 Kafka 记录。如果你把消息和一个唯一键写入系统，然后碰巧又读到一个相同的消息，只要把原先的键值覆盖掉即可。数据存储引擎会覆盖已经存在的键值对，就像没有出现过重复数据一样。这个模式被叫做**幂等性写入**，它是一种很常见也很有用的模式。

如果写入消息的系统支持事务，那么就可以使用另一种方法。最简单的是使用关系型数据库，不过 HDFS 里有一些被重新定义过的原子操作也经常用来达到相同的目的。我们把消息和偏移量放在同一个事务里，这样它们就能保持同步。在消费者启动时，它会获取最近处理过的消息偏移量，然后调用 seek() 方法从该偏移量位置继续读取数据。

# 详解

# 1 无消息丢失配置

Java 版本 producer 用户采用异步发送机制。`KafkaProducer.send` 方法仅仅把消息放入缓冲区中，由一个专属 I/O 线程负责从缓冲区中提取消息并封装进消息 batch 中，然后发送出去。显然，这个过程中存在着数据丢失的窗口：若 I/O 线程发送之前 producer 崩溃，则存储缓冲区中消息全部丢失了。这是 producer 需要处理的很重要的问题。

producer 的另一个问题就是消息的乱序。假设客户端依次执行下面的语句发送两条消息到相同的分区：

```java
producer.send(record1);
producer.send(record2);
```

若此时由于某些原因（比如瞬时的网络抖动）导致 record1 未发送成功，同时 Kafka 又配置了重试机制以及 max.in.flight.requests.per.connection 大于 1（默认值是 5），那么 producer 重试 record1 成功后，record1 在日志中的位置反而位于 record2 之后，这样造成了消息的乱序。要知道很多实际使用场景中都有事件强顺序保证的要求。

鉴于 producer 的这两个问题，应该如何规避呢？首先对于消息丢失的问题，很容易想到的一个方案就是：既然异步发送可能丢失数据，改成同步发送似乎是一个不错的主意。比如这样：

```java
producer.send(record).get();
```

采用同步发送当然是可以的，但是性能会很差，并不推荐在实际场景中使用。因此最好能有一份配置，既使用异步方式还能有效地避免数据丢失，即使出现 producer 崩溃的情况也不会有问题。

本节首先给出 producer 端“无消息丢失配置”，然后再分别解释每个参数配置的含义。具体配置参数列表如下：

- block.on.buffer.full = true
- acks = all or -1
- retries = Integer.MAX_VALUE
- max.in.flight.requests.per.connection = 1
- 使用带回调机制的 send 发送消息，即 `KafkaProducer.send(record, callback)`
- Callback 逻辑中显式地立即关闭 producer，使用 `close(0)`
- unclean.leader.election.enable = false
- replication.factor = 3
- min.insync.replicas = 2
- replication.factor > min.insync.replicas
- enable.auto.commit = false

下面分别从 producer 端和 broker 端分别讨论一下上述参数这样设置的含义。

## 1.1 producer 端配置

**block.on.buffer.full = true**

实际上这个参数在 Kafka 0.9.0.0 版本已经被标记为“deprecated”，并使用 max.block.ms 参数替代，但这里还是推荐用户显式地设置它为 true，使得内存缓冲区被填满时 producer 处于阻塞状态并停止接收新的消息而不是抛出异常；否则 producer 生产速度过快会耗尽缓冲区。新版本 Kafka（0.10.0.0 之后）可以不用理会这个参数，转而设置 max.block.ms 即可。

**acks = all**

设置 acks 为 all 很容易理解，即必须要等到所有 follower 都响应了发送消息才能认为提交成功，这是 producer 端最强程度的持久化保证。

**retries = Integer.MAX_VALUE**

设置成 MAX_VALUE 纵然有些极端，但其实想表达的是 producer 要开启无限重试。用户不必担心 producer 会重试那些肯定无法恢复的错误，当前 producer 只会重试那些可恢复的异常情况，所以放心地设置一个比较大的值通常能很好地保证消息不丢失。

**max.in.flight.requests.per.connection = 1**

设置该参数为 1 主要是为了防止 topic 同分区下的消息乱序问题。这个参数的实际效果其实限制了 producer 在单个 broker 连接上能够发送的未响应请求的数量。因此，如果设置成 1，则 producer 在某个 broker 发送响应之前将无法再给该 broker 发送 PRODUCE 请求。

**使用带有回调机制的 send**

不要使用 KafkaProducer 中单参数的 send 方法，因为该 send 调用仅仅是把消息发出而不会理会消息发送的结果。如果消息发送失败，该方法不会得到任何通知，故可能造成数据的丢失。实际环境中一定要使用带回调机制的 send 版本，即 `KafkaProducer.send(record, callback)`。

**Callback 逻辑中显式立即关闭 producer**

在 Callback 的失败处理逻辑中显式调用 `KafkaProducer.close(0)`。这样做的目的是为了处理消息的乱序问题。若不使用 close(0)，默认情况下 producer 会被允许将未完成的消息发送出去，这样就有可能造成消息乱序。

## 1.2 broker 端配置

**unclean.leader.election.enable = false**

关闭 unclean leader 选举，即不允许非 ISR 中的副本被选举为 leader，从而避免 broker 端因日志水位截断而造成的消息丢失。

**replication.factor >= 3**

设置成 3 主要是参考了 Hadoop 及业界通用的三备份原则，其实这里想强调的是一定要使用多个副本来保存分区的消息。

**min.insync.replicas > 1**

用于控制某条消息至少被写入到 ISR 中的多少副本才算成功，设置成大于 1 是为了提升 producer 端发送语义的持久性。记住只有在 producer 端 acks 被设置成 all 或 -1 时，这个参数才有意义。在实际使用时，不要使用默认值。

**确保 replication.factor > min.insync.replicas**

若两者相等，那么只要有一个副本挂掉，分区就无法正常工作，虽然有很高的持久性但可用性被极大地降低了。推荐配置成 relication.factor = min.insync.replicas + 1。

# 2 保证消息消费的幂等性

有些应用程序不仅仅需要“**至少一次**”（at-least-once）语义（意味着没有数据丢失），还需要“**仅一次**”（exactly-once）语义。尽管 Kakfa 现在还不能完全支持仅一次语义，消费者还是有一些办法可以保证 Kafka 里的每个信息只被写到外部系统一次（但不会处理向 Kafka 写入数据时可能出现的重复数据）。

实现仅一次处理最简单且最常用的办法是把结果写到一个支持唯一键的系统里，比如键值存储引擎、关系型数据库、ElasticSearch 或其他数据存储引擎。在这种情况下，要么消息本身包含一个唯一键（通常都是这样），要么使用主题、分区和偏移量的组合来创建唯一键——它们的组合可以唯一标识一个 Kafka 记录。如果你把消息和一个唯一键写入系统，然后碰巧又读到一个相同的消息，只要把原先的键值覆盖掉即可。数据存储引擎会覆盖已经存在的键值对，就像没有出现过重复数据一样。这个模式被叫做**幂等性写入**，它是一种很常见也很有用的模式。

如果写入消息的系统支持事务，那么就可以使用另一种方法。最简单的是使用关系型数据库，不过 HDFS 里有一些被重新定义过的原子操作也经常用来达到相同的目的。我们把消息和偏移量放在同一个事务里，这样它们就能保持同步。在消费者启动时，它会获取最近处理过的消息偏移量，然后调用 seek() 方法从该偏移量位置继续读取数据。

# 参考文档

- 《Apache Kafka 实战》4.6 无消息丢失配置
- 《Kafka 权威指南》6.5.2 显式提交偏移量