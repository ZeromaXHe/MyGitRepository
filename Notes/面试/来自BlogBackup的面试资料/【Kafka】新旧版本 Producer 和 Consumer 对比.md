# 简答

比起旧版本的 **producer**，新版本在设计理念上有以下几个特点（或者说是优势）。

- 发送过程被划分到两个不同的线程：用户主线程和 Sender I/O 线程，逻辑更容易把控。
- 完全是异步发送信息，并提供回调机制（callback）用于判断发送成功与否。
- 分批机制（batching），每个批次中包括多个发送请求，提升整体吞吐量。
- 更加合理的分区策略：对于没有指定 key 的信息而言，旧版本 producer 分区策略是默认在一段时间内将消息发送到固定分区，这容易造成数据倾斜（skewed）；新版本采用轮询方式，消息发送将更加均匀化。
- 底层统一使用基于 Java Selector 的网络客户端，结合 Java 的 Future 实现更加健壮和优雅的生命周期管理。

鉴于新版本在设计和实际使用上的诸多优势，社区已于 0.9.0.0 版本正式废弃了旧版本的 producer，并且推荐所有依然使用旧版本的 producer 的用户尽早升级到新版本。



比起旧版本 **consumer**，新版本在设计上的突出优势如下。

- 单线程设计 —— 单个 consumer 线程可以管理多个分区的消费 Socket 连接，极大地简化了实现。虽然 0.10.1.0 版本额外引入了一个后台心跳线程（background heartbeat thread），不过双线程的设计依然比旧版本 consumer 鱼龙混杂的多线程设计要简单得多。
- 位移提交与保存交由 Kafka 来处理——位移不再保存在 ZooKeeper 中，而是单独保存在 Kafka 的一个内部 topic 中，这种设计既避免了 ZooKeeper 频繁读/写的性能瓶颈，同时也依托 Kafka 的备份机制天然地实现了位移的高可用管理。
- 消费者组的集中式管理——上面提到了 ZooKeeper 要管理位移，其实它还负责管理整个消费者组（consumer group）的成员。这进一步加重了对于 ZooKeeper 的依赖。新版本 consumer 改进了这种设计，实现了一个集中式协调者（coordinator）的角色。所有组成员的管理都交由该 coordinator 负责，因此对于 group 的管理将更加可控。

和 producer 不同的是，目前新旧 consumer 并存于 1.0.0 版本的 Kafka 中。虽然社区曾计划投票决定在 0.11.0.0 这个大版本上正式放弃对于旧版本 consumer 的支持，但是目前使用旧版本 consumer 的用户依然不在少数，故即使在 1.0.0 版本中旧版本依然没有被移除，可以预见这种共存的局面还将维持一段时间。

# 详解

在 Kafka 版本的不断演进过程中，社区分别推出了新版本的**生产者**（producer）和**消费者**（consumer）。0.8.2.x Kafka 使用 Java 重写了 producer，以替代原 Scala 版本的 producer。0.9.0.x 引入了 Java 版本的 consumer 以替代原 Scala 版本的 consumer。通常把 producer 和 consumer 通称为**客户端**（即 clients），这是与**服务器端**（broker）相对应的。

# 1 新版本功能简介

## 1.1 新版本 producer

在 Kafka 0.9.0.0 版本中，社区正式使用 Java 版本的 producer 替换了原 Scala 版本的 producer。新版本的 producer 的主要入口类是 `org.apache.kafka.clients.producer.KafkaProducer`，而非原来的 `kafka.producer.Producer`。

新版本 producer 重写了之前服务器端代码提供的很多数据结构，摆脱了对服务器端代码库的依赖，同时新版本的 producer 也不再依赖于 ZooKeeper，甚至不需要和 ZooKeeper 集群进行直接交互，降低了系统的维护成本，也简化了部署 producer 应用的开销成本。一段典型的新版本 producer 代码如下：

~~~java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("acks", "all");
props.put("retries", 0);
props.put("batch.size", 16384);
props.put("linger.ms", 1);
props.put("buffer.memory", 33554432);
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

Producer<String, String> producer = new KafkaProducer<>(props);
for(int i = 0; i < 100; i++)
    producer.send(new ProducerRecord<String, String>("my-topic", Integer.toString(i), Integer.toString(i)));

producer.close();
~~~

上面的代码中比较关键的是 `KafkaProducer.send`，它是实现发送逻辑的主要入口方法。新版本 producer 大致就是将用户待发送的消息封装成一个 ProducerRecord 对象（包含了 topic、partition、key、value、timestamp 等信息），然后使用 `KafkaProducer.send` 方法进行发送。实际上，KafkaProducer 拿到消息后对其进行序列化，然后结合本地缓存的元数据信息确立目标分区，最后写入内存缓冲区。同时，KafkaProducer 中还有一个专门的 Sender I/O 线程负责将缓冲区中的消息分批次发送给 Kafka broker。

比起旧版本的 producer，新版本在设计理念上有以下几个特点（或者说是优势）。

- 发送过程被划分到两个不同的线程：用户主线程和 Sender I/O 线程，逻辑更容易把控。
- 完全是异步发送信息，并提供回调机制（callback）用于判断发送成功与否。
- 分批机制（batching），每个批次中包括多个发送请求，提升整体吞吐量。
- 更加合理的分区策略：对于没有指定 key 的信息而言，旧版本 producer 分区策略是默认在一段时间内将消息发送到固定分区，这容易造成数据倾斜（skewed）；新版本采用轮询方式，消息发送将更加均匀化。
- 底层统一使用基于 Java Selector 的网络客户端，结合 Java 的 Future 实现更加健壮和优雅的生命周期管理。

当然，新版本 producer 的设计优势还有很多，比如监控指标更加完善等。以上 5 点只罗列了最重要的设计特性。

新版本 producer 的 API 设计得也足够简单易用，只需要记住几个常用的方法就可以了：

```java
public Future<RecordMetadata> send(ProducerRecord<K, V> pr);
public Future<RecordMetadata> send(ProducerRecord<K, V> pr, Callback c);
public void flush();
public List<PartitionInfo> partitionsFor(String s);
public Map<MetricName, Metric> metrics();
public void close();
public void close(long l, TimeUnit tu);
```

比较关键的方法如下：

- send：实现消息发送的主逻辑方法。
- close：关闭 producer。正确关闭 producer 对于程序正确性来讲至关重要。
- metrics：获取 producer 的实时监控指标数据，比如发送消息的速率等。

鉴于新版本在设计和实际使用上的诸多优势，社区已于 0.9.0.0 版本正式废弃了旧版本的 producer，并且推荐所有依然使用旧版本的 producer 的用户尽早升级到新版本。

## 1.2 新版本 consumer

Kafka 0.9.0.0 版本不仅废弃了旧版本 producer，还提供了新版本的 consumer。同样地，新版本 consumer 也是使用 Java 语言编写的，也不再需要依赖 ZooKeeper 的帮助。新版本 consumer 的入口类是 `org.apache.kafka.clients.consumer.KafkaConsumer`。由此也可以看出，新版本客户端的代码包都是 `org.apache.kafka.clients`，这一点需要特别注意，因为它是区分新旧客户端的一个重要特征。

在旧版本 consumer 中，消费位移（offset）的保存与管理都是依托于 ZooKeeper 来完成的。当数据量很大且消费很频繁时，ZooKeeper 的读/写性能往往容易成为系统瓶颈。这是旧版本 consumer 为人诟病的缺陷之一。而在新版本 consumer 中，位移的管理与保存不再依靠 ZooKeeper 了，自然这个瓶颈就消失了。

一段典型的 consumer 代码如下：

```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("group.id", "test");
props.put("enable.auto.commit", "true");
props.put("auto.commit.interval.ms", "1000");
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

KafkaConsumer<String, String> producer = new KafkaConsumer<>(props);
consumer.subscribe(Arrays.asList("foo", "bar"));
while (true) {
    ConsumerRecords<String, String> records = consumer.poll(100);
    for (ConsumerRecord<String, String> record : records)
        System.out.printf("offset = %d, key = %s, value = %s%n", record.offset(), record.key(), record.value());
}
```

同理，上面代码中比较关键的是 `KafkaConsumer.poll` 方法。它是实现消息消费的主逻辑入口方法。新版本 consumer 在设计时摒弃了旧版本多线程消费不同分区的思想，采用了类似于 Linux epoll 的轮询机制，使得 consumer 只使用一个线程就可以管理连向不同 broker 的多个 Socket，既减少了线程间的开销成本，同时也简化了系统的设计。

比起旧版本 consumer，新版本在设计上的突出优势如下。

- 单线程设计 —— 单个 consumer 线程可以管理多个分区的消费 Socket 连接，极大地简化了实现。虽然 0.10.1.0 版本额外引入了一个后台心跳线程（background heartbeat thread），不过双线程的设计依然比旧版本 consumer 鱼龙混杂的多线程设计要简单得多。
- 位移提交与保存交由 Kafka 来处理——位移不再保存在 ZooKeeper 中，而是单独保存在 Kafka 的一个内部 topic 中，这种设计既避免了 ZooKeeper 频繁读/写的性能瓶颈，同时也依托 Kafka 的备份机制天然地实现了位移的高可用管理。
- 消费者组的集中式管理——上面提到了 ZooKeeper 要管理位移，其实它还负责管理整个消费者组（consumer group）的成员。这进一步加重了对于 ZooKeeper 的依赖。新版本 consumer 改进了这种设计，实现了一个集中式协调者（coordinator）的角色。所有组成员的管理都交由该 coordinator 负责，因此对于 group 的管理将更加可控。

比起旧版本而言，新版本在 API 设计上提供了更加丰富的功能，具体 API 方法如下：

```java
public ConsumerRecords<K,V> poll(long l);
public void subscribe(Collection<String> c, ConsumerRebalanceListener crl);
public void commitSync(Map<TopicPartition, OffsetAndMatadata> m);
public void commitAsync(Map<TopicPartition, OffsetAndMatadata> m, OffsetCommitCallback occ);
public void seek(TopicPartition tp, long l);
public Set<TopicPartition> assignment();
public void assign(Collection<TopicPartition> c);
public void unsubscribe();
public void seekToBeginning(Collection<TopicPartition> c);
public void seekToEnd(Collection<TopicPartition> c);
public long position(TopicPartition tp);
public OffsetAndMetadata committed(TopicPartition tp);
public Map<MatricName, Metric> metrics();
public List<PartitionInfo> partitionsFor(String s);
public Map<String, List<PartitionInfo>> listTopics();
public Set<TopicPartition> paused();
public void paused(Collection<TopicPartition> c);
public void resume(Collection<TopicPartition> c);
public Map<TopicPartition, OffsetAndTimestamp> offsetsForTimes(Map<TopicPartition, Long> m);
public Map<TopicPartition, Long> beginningOffsets(Collection<TopicPartition> c);
public Map<TopicPartition, Long> endOffsets(Collection<TopicPartition c);
public void close(long l, TimeUnit tu);
public void wakeup();
```

API 提供的方法有很多，其中比较关键的方法如下：

- poll：最重要的方法。它是实现读取消息的核心方法。
- subscribe：订阅方法，指定 consumer 要消费哪些 topic 的哪些分区。
- commitSync / commitAsync：手动提交位移方法。新版本 consumer 运行用户手动提交位移，并提供了同步/异步两种方式。
- seek / seekToBeginning / seekToEnd：设置位移方法。除了提交位移，consumer 还可以直接消费特定位移处的消息。

和 producer 不同的是，目前新旧 consumer 并存于 1.0.0 版本的 Kafka 中。虽然社区曾计划投票决定在 0.11.0.0 这个大版本上正式放弃对于旧版本 consumer 的支持，但是目前使用旧版本 consumer 的用户依然不在少数，故即使在 1.0.0 版本中旧版本依然没有被移除，可以预见这种共存的局面还将维持一段时间。

# 2 旧版本功能简介

前面谈到的都是新版本客户端，包括了 producer 和 consumer。新版本客户端必然是社区之后极力推荐使用的，但不可否认的是，旧版本依然有着广泛的用户基础，特别是对于那些早期使用 Kafka 的公司来说，他们大多数使用的是 Kafka 0.8.x 这个版本。就拿其中最广泛应用的 0.8.2.2 这个版本而言，这个版本的 Kafka 刚刚推出 Java 版 producer，而 Java consumer 甚至还没有开发。所以，我们还是有必要简要了解一下旧版本客户端，毕竟很多核心设计思想都是一脉相承的。

## 2.1 旧版本 producer

这里频频提到的旧版本就是指由 Scala 语言编写的 producer，在比较新的 Kafka 官网介绍中用户已经找不到对于它的介绍了，但是对于依然使用 0.8.x 版本 Kafka 的用户而言，Scala producer 依然可能活跃在他们的线上系统中。

Scala producer 的入口类是 `kafka.producer.Producer`，一段典型的代码如下：

```java
Properties props = new Properties();
props.put("metadata.broker.list", "localhost:9092, localhost:9093, localhost:9094");
props.put("serializer.class", "kafka.serializer.StringEncoder");
props.put("request.required.acks", "1");

ProducerConfig config = new ProducerConfig(props);
Producer<String, String> producer = new Producer<String, String>(config);
KeyedMessage<String, String> msg = new KeyedMessage<String, String>("my-topic", "hello, world.");
Producer.send(msg);
```

很明显，上面代码中的主要逻辑是由 `Producer.send` 方法实现的。该方法默认是同步机制的，即每条消息要等待服务器端发送响应给客户端，明确告诉消息发送结果之后，才能开始下一条消息的发送，因此旧版本 producer 的吞吐量性能是很差的。当然它也提供了一个参数用于实现异步的消息发送逻辑，但是凡事有利就有弊，旧版本 producer 异步发送会有丢失消息的可能性，对于那些对数据有较强持久化要求的用户来说，异步并不是一个可选项。

旧版本 producer 的工作流程：

1. 序列化消息
2. 更新统计信息
3. 判断是否还有尝试次数且有未发送消息。“否”的话，再次判断是否还有尝试次数且有未发送消息，是则记录错误并抛出 FailedToSendMessageException 异常，否则说明消息发送完成。
4. 3 的结果为“是”的话，更新元数据 topic 信息。
5. 判断是否还有尝试次数且有未发送消息，是则发送请求更新元数据。
6. 无论 5 为是与否，执行完成后发送消息。
7. 若还有未发送消息，等待 retry.backoff.ms 重试，跳转到 3 继续执行。

新旧版本 produce 的工作流程有很大的相似性，只是新版本 producer 在各个方面都要优于旧版本。因此社区才会在 Kafka 0.9.0.0 版本中正式将旧版本“下架”。

对于 API 而言，旧版本的 producer 提供的功能也非常有限。旧版本只提供了 send 和 close 两个方法，另外还提供了一个 sync 参数用于控制该 producer 是同步发送消息还是异步发送。因此整套 API 的设计实际上是非常“简陋”的。

## 2.2 旧版本 consumer

不同于 producer，旧版本 consumer，即 Scala consumer，其实并没有那么“旧”，也没有那么弱。如前所述，依然有很多用户在生产环境中使用着旧版本 consumer。和新旧版本之间有巨大的性能差异不同，新旧版本 consumer 的性能差异似乎也没有那么大。换句话说，旧版本 consumer 没有那么“不堪”。这也是社区迟迟没有“下架”它的原因之一。

说起旧版本 consumer，就不能不提**高阶消费者**（high-level consumer）和**低阶消费者**（low-level consumer）。没错，它们是专属于旧版本而言的。切记新版本是没有 high-level 和 low-level 之分的！high-level consumer 其实就是指消费者组，而 low-level consumer 是指单个 consumer，即 standalone consumer。单个 consumer 是没有什么消费者组的概念的，每个 consumer 都单独进行自己的工作，与其他 consumer 不产生任何关联；而消费者组就是大家作为一个团队一起工作，彼此之间会“相互照应”。

我们先说 low-level consumer。low-level consumer 的底层实现就是 SimpleConsumer 类。一旦应用此类，Kafka 会认为用户有自行管理消费者的需求，从而不会为用户提供任何组管理方面的功能（包括负载均衡和故障转移等），而用户需要自己解决这方面的问题。因此使用 SimpleConsumer 可以说是既灵活又麻烦。鉴于这些特点，很多需要灵活定制实现的第三方框架往往会采用这种 low-level consumer，比如 Apache Storm 的 Kafka 插件 storm-kafka 就使用了 SimpleConsumer 来实现 KafkaSpout。

low-level consumer 的 API 设计得非常简单：（SimpleConsumer 类）

```java
public FetchResponse fetch(FetchRequest fr);
public GroupCoordinatorResponse send(GroupCoordinatorRequest gcr);
public TopicMetadataResponse send(TopicMetadataRequest tmr);
public OffsetResponse getOffsetsBefore(OffsetRequest or);
public OffsetCommitResponse commitOffsets(OffsetCommitRequest ocr);
public OffsetFetchResponse fetchOffsets(OffsetFetchReqeust ofr);
public long earliestOrLatestOffset(TopicPartition tp, long l, int i);
public void close();
```

如果我们对比新版本 API 就会发现，很多方法都是类似的，都有获取消息、提交位移等功能。当然在底层实现上两者差异明显。

细心的读者可能会发现在 SimpleConsumer 的 API 设计中还有 send 方法，难道 consumer 还需要发送消息吗？其实，这里的 send 不是指发送消息，而是指发送具体的请求。事实上，尽管旧版本的 consumer 已经不推荐用户使用了，但 Kafka 服务器底层依然有一部分代码在使用 SimpleConsumer 负责向其他 broker 发送特定类型的请求，即使用这里的 send 方法进行发送，所以读者不要把它和 producer 的 send 方法搞混淆了。

如果说 low-level consumer 既麻烦又灵活，那么 high-level consumer 便是既省事又死板。

high-level consumer 主要的方法是 `createMessageStreams`——该方法负责创建一个或多个 KafkaStream，用于真正的消息消费。如果是在多台机器上，用户只需要简单地启动多个配置有相同组 ID（group.id）的 consumer 进程；若是在同一台机器上，createMessageStreams 方法也允许用户直接指定线程数来创建多 consumer 实例。不管是哪种方法，这些 consumer 实例都会自动组成一个消费者组来共同承担消费任务，假如任意时刻有 consumer 进程或实例宕机，该消费者组都会帮用户自动处理，根本不需要人工干预。

如此看来，使用 high-level consumer 是很省事的，但为什么说它是死板的呢？high-level consumer 不似 SimpleConsumer 那样灵活，可以从分区的任意位置开始消费。它只能从上次保存的位移处开始顺序读取消息，使用起来无法实现高度定制化的消费策略，故而说它是死板的。

旧版本 high-level consumer API：（ConsumerConnector 接口）

```java
public Map<String, List<KafkaStream<K, V>> createMessageStreams(Map<String, int> m, Decode<K> dk, Decode<V> dv);
public Set<KafkaStream<K, V>> createMessageStreamsByFilter(TopicFilter tf, int i, Decode<K> dk, Decode<V> dv);
public void commitOffsets(Map<TopicPartition tp, OffsetAndMetadata oam);
public void setConsumerRebalanceListener(ConsumerRebalanceListener crl);
public void shutdown();
```



# 参考文档

- 《Apache Kafka 实战》2.2.3 新版本功能简介、2.2.4 旧版本功能简介