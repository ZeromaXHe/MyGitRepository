【尚硅谷】Kafka3.x教程（从入门到调优，深入全面） 2022-02-16 14:55:08

https://www.bilibili.com/video/BV1vr4y1677k

# P1 课程简介

# P2 概述_定义

Kafka 传统定义：Kafka 是一个分布式的基于发布/订阅模式的消息队列（Message Queue），主要应用于大数据实时处理领域。

发布/订阅：消息的发布者不会将消息直接发送给特定的订阅者，而是将发布的消息分为不同的类别，订阅者只接收感兴趣的消息。

Kafka 最新定义：Kakfa 是一个开源的分布式事件流平台（Event Streaming Platform），被数千家公司用于高性能数据管道、流分析、数据集成和关键任务应用。

# P3 概述_消息队列应用场景

## 1.2 消息队列

目前企业中比较常见的消息队列产品主要有 Kafka、ActiveMQ、RabbitMQ、RocketMQ 等。

在大数据场景主要采用 Kafka 作为消息队列。在 JavaEE 开发中主要采用 ActiveMQ、RabbitMQ、RocketMQ。

### 1.2.1 传统消息队列的应用场景

传统的消息队列的主要应用场景包括：**缓存/削峰**、**解耦**和**异步通信**

缓存/削峰：有助于控制和优化数据流经过系统的速度，解决生产消息和消费消息的处理速度不一致的情况。

解耦：允许你独立的扩展或修改两边的处理过程，只要确保它们遵守同样的接口约束

异步通信：允许用户把一个消息放入队列，但并不立即处理它，然后在需要的时候再去处理它们。

# P4 概述_消息队列两种模式

### 1.2.2 消息队列的两种模式

1. 点对点模式
   - 消费者主动拉取数据，消息收到后清除消息
2. 发布/订阅模式
   - 可以有多个 topic 主题（浏览、点赞、收藏、评论等）
   - 消费者消费数据之后，不删除数据
   - 每个消费者相互独立，都可以消费到数据

# P5 概述_基础架构

## 1.3 Kafka 基础架构

1. 为方便扩展，并提高吞吐量，一个 topic 分为多个 partition
2. 配合分区的设计，提出消费者组的概念，组内各个消费者并行消费
3. 为提高可用性，为每个 partition 增加若干个副本，类似 NameNode HA
4. ZK 中记录谁是 leader，Kafka 2.8.0 以后也可以配置不采用 ZK



Producer：消息生产者，就是向 Kafka broker 发消息的客户端

Consumer：消息消费者，向 Kafka broker 取消息的客户端

# P6 入门_安装 Kafka

- bin
  - kafka-server-start.sh
  - kafka-server-stop.sh
  - kafka-topics.sh
  - kafka-console-consumer.sh
  - kafka-console-producer.sh
- config
  - consumer.properties
  - producer.properties
  - server.properties
    - 修改 `broker.id`，不能重复
    - 修改 `log.dirs`, 日志数据放置路径，不要放到临时目录
    - 修改 `zookeeper.connect`

启动

1. 先启动 zookeeper
2. `bin/kafka-server-start.sh -daemon config/server.properties`

# P7 入门_启动停止脚本

停止 Kafka 需要一定时间

等集群所有 Kafka 进程关停后才能关闭 zookeeper

# P8 入门_Topic命令

## 2.2 Kafka 命令行操作

### 2.2.1 主题命令行操作

1. 查看操作主题命令参数

   `bin/kafka-topics.sh`

   | 参数                                               | 描述                                                         |
   | -------------------------------------------------- | ------------------------------------------------------------ |
   | --bootstrap-server <String: server toconnect to>   | 连接的 Kafka Broker 主机名称和端口号（可以使用逗号分隔多个） |
   | --topic <String: topic>                            | 操作的 topic 名称                                            |
   | --create                                           | 创建主题                                                     |
   | --delete                                           | 删除主题                                                     |
   | --alter                                            | 修改主题                                                     |
   | --list                                             | 查看所有主题                                                 |
   | --describe                                         | 查看主题详细描述                                             |
   | --partitions <Integer: # of partitions>            | 设置分区数                                                   |
   | --replication-factor <Integer: replication factor> | 设置分区副本                                                 |
   | --config <String: name=value>                      | 更新系统默认的配置                                           |

2. 查看当前服务器中的所有 topic

   `bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --list`

3. 创建 first topic

   `bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --create first --partition 1 --replication-factor 3`

4. `bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --topic first --describe`

5. `bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --topic first --alter --partitions 3` （只能从小改大）

# P9 入门_命令行操作

生产者

`bin/kafka-console-producer.sh --bootstrap-server hadoop102:9092 --topic first`

消费者

`bin/kafka-console-consumer.sh --bootstrap-server hadoop102:9092 -- topic first`（可以加 `--from-beginning`）

# P10 生产者_原理

## 3.1 生产者消息发送流程

### 3.1.1 发送原理

在消息发送的过程中，涉及到了两个线程——main 线程和 Sender 线程。在 main 线程中创建了一个双端队列 RecordAccumulator。main 线程将消息发送给 RecordAccumulator，Sender 线程不断从 RecordAccumulator 中拉取消息发送到 Kafka Broker。

- Kafka Producer 生产者

  （main 线程：Producer --send(ProducerRecord)--> Interceptors 拦截器 ----> Serializer 序列化器 ----> Patitioner 分区器）

- RecordAccumulator（默认32M）

  （多个 DQueue，每个 DQueue 中存 ProducerBatch（默认 16k））

- sender 线程

  （Sender（读取数据）----> NetworkClient（InFlightRequests，默认每个 broker 节点最多缓存 5 个请求）; Sender---->Selector）

  - `batch.size`：只有数据积累到 batch.size 之后，sender 才会发送数据。默认 16k
  - `linger.ms`：如果数据迟迟未达到 batch.size，sender 等待 linger.ms 设置的时间到了之后就会发送数据。单位 ms，默认值是 0ms，表示没有延迟。

- Kafka 集群

  （Broker1；Broker2）

  - 应答 acks：
    - 0：生产者发送过来的数据，不需要等数据落盘应答
    - 1：生产者发送过来的数据，Leader 收到数据后应答。
    - -1（all）：生产者发送过来的数据，Leader 和 ISR 队列里面的所有节点收齐数据后应答。-1 和 all 等价。

# P11 生产者_异步发送

## 3.2 异步发送 API

### 3.2.1 普通异步发送

1. 需求创建 Kafka 生产者，采用异步方式发送到 Kafka Broker

2. 代码编写

   1. 创建工程

   2. 导入依赖

      ```xml
      <dependencies>
          <dependency>
              <groupId>org.apache.kafka</groupId>
              <artifactId>kafka-clients</artifactId>
              <version>3.0.0</version>
          </dependency>
      </dependencies>
      ```

   3. 创建包名：com.atguigu.kafka.producer

   4. 编写不带回调函数的 API 代码

      ```java
      public class CustomProducer {
          public static void main(String[] args) throws InterruptedException {
              // 0. 创建 kafka 生产者的配置对象
              Properties properties = new Properties();
              // 给 kafka 配置对象添加配置信息：bootstrap.servers
              properties.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "hadoop102:9092");
              // key, value 序列化（必须）：key.serializer, value.serializer
              properties.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer"); // StringSerializer.class.getName()
              properties.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringSerializer"); // StringSerializer.class.getName()
              // 1. 创建 Kafka 生产者对象
              KafkaProducer<String, String> kafkaProducer = new KafkaProducer<>(properties);
              // 2. 发送数据
              for (int i = 0; i < 5; i++) {
      	        kafkaProducer.send(new ProducerRecord<>("first", "atguigu" + i));
              }
              // 3. 关闭资源
              kafkaProducer.close();
          }
      }
      ```

      

# P12 生产者_回调异步发送

### 3.2.2 带回调函数的异步发送

回调函数会在 producer 收到 ack 时调用，为异步调用，该方法有两个参数，分别是元数据信息（RecordMetadata）和异常信息（Exception），如果 Exception 为 null，说明消息发送成功，如果 Exception 不为 null，说明消息发送失败。

注意：消息发送失败会自动重试，不需要我们在回调函数中手动重试。

```java
kafkaProducer.send(new ProducerRecord<>("first", "atguigu" + i), new Callback() {
    @Override
    public void onCompletion(RecordMetadata metadata, Exception exception) {
        if (exception == null) {
            System.out.println("主题：" + metadata.topic() + " 分区：" + metadata.partition());
        }
    }
});
```

# P13 生产者_同步发送

## 3.3 同步发送 API

只需在异步发送的基础上，再调用一下 get() 方法即可。

```java
kafkaProducer.send(new ProducerRecord<>("first", "atguigu" + i)).get();
```

# P14 生产者_分区

## 3.4 生产者分区

### 3.4.1 分区好处

Kafka 分区好处

1. 便于合理使用存储资源。每个 Partition 在一个 Broker 上存储，可以把海量的数据按照分区切割成一块一块数据存储在多台 Broker 上。合理控制分区的任务，可以实现负载均衡的效果。
2. 提高并行度。生产者可以以分区为单位发送数据，消费者可以以分区为单位进行消费数据。

# P15 生产者_分区策略

### 3.4.2 生产者发送消息的分区策略

1. 默认的分区器 DefaultPartitioner

   在 IDEA 中 Ctrl + n, 全局查找 DefaultPartitioner 类。在类开头可以看到其注释

   - 如果设置了 partition，用它
   - 如果没有指定 partition，但有 key，就用 key 的 hash 取余
   - 如果都没有，就使用粘性分区（批次满了的时候改变）

   在 IDEA 中 Ctrl + n, 全局查找 ProducerRecord 类。在类中可以看到其构造方法，分为几类：

   1. 四个构造方法入参有 partition：指明 partition 的情况，直接将指明的值作为 partition 的值。

      例如 partition = 0，所有数据写入分区 0

   2. 一个构造方法入参为 `ProducerRecord(String topic, K key, V value)`：没有指明 partition 值但有 key 的情况下，将 key 的 hash 值与 topic 的 partition 数进行取余得到 partition 值。

   3. 一个构造方法入参为 `ProducerRecord(String topic, V value)`：既没有 partition 值又没有 key 值的情况下，Kafka 采用 Sticky Partition（黏性分区器），会随机选择一个分区，并尽可能一直使用该分区，待该分区的 batch 已满或者已完成，Kafka 再随机一个分区进行使用（和上一次的分区不同）。

      例如：第一次随机选择 0 号分区，等 0 号分区当前批次满了（默认 16k）或者 linger.ms 设置的时间到，Kafka 再随机一个分区进行使用（如果还是 0 会继续随机）。观后注：这里继续随机存疑，看演示不对？

# P16 生产者_自定义分区

### 3.4.3 自定义分区器

如果研发人员可以根据企业需求，自己重新实现分区器。

1. 需求

   例如我们实现一个分区器实现，发送过来的数据如果包含 atguigu，就发往 0 号分区，不包含 atguigu，就发往 1 号分区。

2. 实现步骤

   1. 定义类实现 Partitioner 接口
   2. 重写 partition() 方法

   ```java
   public class MyPartitioner implements Partitioner {
       @Override
       public int partition(String topic, Object key, byte[] keyBytes, Object value, byte[] valueBytes, Cluster cluster) {
           // 获取数据
   		String msgValues = value.toString();
           int partition;
           if (msgValues.contains("atguigu")) {
               partition = 0;
           } else {
               partition = 1;
           }
           return partition;
       }
       
       @Override
       public void close() {
           
       }
       
       @Override
       public void configure(Map<String, ?> configs) {
           
       }
   }
   ```

   ```java
   // 关联自定义分区器
   properties.put(ProducerConfig.PARTITIONER_CLASS_CONFIG, MyPartitioner.class.getName());
   ```

   

# P17 生产者_提高生产者吞吐量

## 3.5 生产经验——生产者如何提高吞吐量

- batch.size：批次大小，默认 16k
- linger.ms：等待时间，修改为 5-100ms
- compression.type：压缩 snappy
- RecordAccumulator：缓冲区大小，修改为 64m

```java
// batch.size：批次大小，默认 16K
properties.put(ProducerConfig.BATCH_SIZE_CONFIG, 16384);
// linger.ms：等待时间，默认 0
properties.put(ProducerConfig.LINGER_MS_CONFIG, 1);
// RecordAccumulator：缓冲区大小，默认 32M：buffer.memory
properties.put(ProducerConfig.BUFFER_MEMORY_CONFIG, 33554432);
// compression.type：压缩，默认 none，可配置值 qzip、snappy、lz4 和 zstd
properties.put(ProducerConfig.COMPRESSION_TYPE_CONFIG, "snappy");
```

# P18 生产者_数据可靠

## 3.6 生产经验——数据可靠性

0. 回顾发送流程

1. ack 应答原理

   - 0：生产者发送过来的数据，不需要等数据落盘应答（丢数）
   - 1：生产者发送过来的数据，Leader 收到数据后应答（丢数）
   - -1（all）：生产者发送过来的数据，Leader 和 ISR 队列里面的所有节点收齐数后应答。

   思考：Leader 收到数据，所有 Follower 都开始同步数据，但有一个 Follower 因为某种故障，迟迟不能与 Leader 进行同步，那这个问题怎么解决呢？

   - Leader 维护了一个动态的 in-sync replica set(ISR)，意为和 Leader 保持同步的 Follower + Leader 集合。
   - 如果 Follower 长时间未向 Leader 发送通信请求或同步数据，则该 Follower 将被踢出 ISR。该时间阈值由 replica.lag.time.max.ms 参数设定，默认 30s。
   - 这样就不用等长期联系不上或者已经故障的节点。

   数据可靠性分析：

   - 如果分区副本设置为 1 个，或者 ISR 里应答的最小副本数量（min.insync.replicas 默认为 1）设置为 1，和 ack = 1 的效果是一样的，仍然有丢数的风险。

   数据完全可靠条件 = ACK 级别设置为 -1 + 分区副本大于等于 2 + ISR 里应答的最小副本数量大于等于 2

   可靠性总结：

   - acks = 0，生产者发送过来数据就不管了，可靠性差，效率高
   - acks = 1，生产者发送过来数据 Leader 应答，可靠性中等，效率中等
   - acks = -1，生产者发送过来数据 Leader 和 ISR 队列里面所有 Follow 应答，可靠性高，效率低
   - 在生产环境中，acks = 0 很少使用；acks = 1，一般用于传输普通日志，允许丢个别数据；acks = -1，一般用于传输和钱相关的数据，对可靠性要求比较高的场景。

   数据重复分析：

   acks: -1(all)：生产者发送过来的数据，Leader 和 ISR 队列里面的所有节点收齐数据后应答。Leader 在 ack 前崩溃可能导致接收两份 Hello 数据，导致数据重复

2. 代码配置

   ```java
   // acks
   properties.put(ProducerConfig.ACK_CONFIG, "1");
   // 重试次数
   properties.put(ProducerConfig.RETRIES_CONFIG, 3);
   ```

   

# P19 生产者_数据重复

## 3.7 生产经验——数据去重

### 3.7.1 数据传递语义

- 至少一次（At Least Once） = ACK 级别设置为 -1 + 分区副本大于等于 2 + ISR 里应答的最小副本数量大于等于 2
- 最多一次（At Most Once） = ACK 级别设置为 0
- 总结：
  - At Least Once 可以保证数据不丢失，但是不能保证数据不重复
  - At Most Once 可以保证数据不重复，但是不能保证数据不丢失
- 精确一次（Exactly Once）：对于一些非常重要的信息，比如和钱相关的数据，要求数据既不重复也不丢失。

Kafka 0.11 版本以后，引入了一项重大特性：幂等性和事务

### 3.7.2 幂等性

1. 幂等性原理

   - 幂等性就是指 Producer 不论向 Broker 发送多少次重复数据，Broker 端都只会持久化一条，保证了不重复。
   - 精确一次（Exactly Once） = 幂等性 + 至少一次（ack = -1 + 分区副本数 >= 2 + ISR 最小副本数量 >= 2）
   - 重复数据的判断标准：具有<PID, Partition, SeqNumber> 相同主键的消息提交时，Broker 只会持久化一条。其中 PID 是 Kafka 每次重启都会分配一个新的；Partition 表示分区号；Sequence Number 是单调自增的。
   - 所以幂等性只能保证的是在单分区单会话内不重复。

2. 如何使用幂等性

   开启参数 enable.idempotence 默认为 true，false 关闭

### 3.7.3 生产者事务

1. Kafka 事务原理

   - 说明：开启事务，必须开启幂等性
   - Producer 在使用事务功能前，必须先自定义一个唯一的 transactional.id。有了 transactional.id，即使客户端挂掉了，它重启后也能继续处理未完成的事务

   过程：

   1. Producer 向 Broker 的 TransactionCoordinator 事务协调器请求 producer id（幂等性需要）
   2. Broker 的 TransactionCoordinator 返回 producer id
   3. Producer 发送消息到 Topic A
   4. Producer 发送 commit 请求到 TransactionCoordinator
   5. TransactionCoordinator 持久化 commit 请求到 __transaction_state-分区-Leader（存储事务信息的特殊主题。默认有 50 个分区，每个分区负责一部分事务。事务划分是根据 transactional.id 的 hashcode 值 % 50，计算出该事务属于哪个分区。该分区 Leader 副本所在的 broker 节点即为这个 transactional.id 对应的 Transaction Coordinator 节点。）
   6. TransactionCoordinator 返回成功给 Producer
   7. TransactionCoordinator 后台发送 commit 请求给 Topic A
   8. Topic A 返回成功给 TransactionCoordinator
   9. TransactionCoordinator 持久化事务成功信息

2. Kafka 的事务一共有如下 5 个 API

   ```java
   // 1. 初始化事务
   void initTransactions();
   // 2. 开启事务
   void beginTransaction() throw ProducerFencedException;
   // 3. 在事务内提交已经消费的偏移量（主要用于消费者）
   void sendOffsetsToTransaction(Map<TopicPartition, OffsetAndMetadata> offsets, String consumerGroupId) throws ProducerFencedException;
   // 4. 提交事务
   void commitTransaction() throws ProducerFencedException;
   // 5. 放弃事务（类似于回滚事务的操作）
   void abortTransaction() throws ProducerFencedException;
   ```

3. 单个 Producer，使用事务保证消息的仅一次发送

   ```java
   // 指定事务 id
   properties.put(ProducerConfig.TRANSACTIONAL_ID_CONFIG, "transactional_id_01");
   // ...
   kafkaProducer.initTransactions();
   kafkaProducer.beginTransaction();
   try {
       // 2. 发送数据
       for (int i = 0; i < 5; i++) {
           kafkaProducer.send(new ProducerRecord<>("first", "atguigu" + i));
       }
       int i = 1/0;
   	kafkaProducer.commitTransaction();
   } catch (Exception e) {
       kafkaProducer.abortTransaction();
   } finally {
       // 3. 关闭资源
       kafkaProducer.close();
   }
       
   ```

   

# P20 生产者_数据有序

## 3.8 生产经验——数据有序

单分区内，有序（有条件的，详见下节）；多分区，分区与分区间无序

# P21 生产者_数据乱序

## 3.9 生产经验——数据乱序

1. Kafka 在 1.x 版本之前保证数据单分区有序，条件如下：

   `max.in.flight.requests.per.connection=1`（不需要考虑是否开启幂等性）

2. Kafka 在 1.x 及以后版本保证数据单分区有序，条件如下：

   1. 未开启幂等性 `max.in.flight.requests.per.connection` 需要设置为 1

   2. 开启幂等性 `max.in.flight.requests.per.connection` 需要设置小于等于 5

      原因说明：因为在 Kafka 1.x 以后，启用幂等后，Kafka 服务端会缓存 Producer 发来的最近 5 个 request 的元数据，故无论如何，都可以保证最近 5 个 request 的数据都是有序的。

      如果开启了幂等性且缓存的请求个数小于 5 个，会在服务端重新排序