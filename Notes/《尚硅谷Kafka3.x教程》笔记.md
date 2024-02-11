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

# P22 Broker_ZK 存储

第 4 章 Kafka Broker

## 4.1 Kafka Broker 工作流程

### 4.1.1 Zookeeper 存储的 Kafka 信息

（1）启动 Zookeeper 客户端

（2）通过 ls 命令可以查看 Kafka 相关信息

```shell
ls /kafka/
```



在 Zookeeper 的服务端存储的 Kafka 相关信息：

1. /kafka/brokers/ids 记录有哪些服务器
2. /kafka/brokers/topics/first/partitions/0/state 记录谁是 Leader，有哪些服务器可用
3. /kafka/controller 辅助选举 Leader

/kafka

- admin
  - delete_topics
- brokers
  - ids
  - topics
    - first
      - partitions
  - seqid
- cluster
  - id
- consumers
  - 0.9 版本之前用于保存 offset 信息
  - 0.9 版本之后 offset 存储在 kafka 主题中
- controller
- config
  - brokers
  - changes
  - topics
  - clients
  - users
- Controller_epoch
- log_dir_event_notification
- lastest_producer_id_block
- lsr_change_notification

# P23 Broker_工作原理

### 4.1.2 Kafka Broker 总体工作流程

1. Broker 启动后在 zk 中注册

2. controller 谁先注册，谁说了算

3. 由选举出来的 Controller 监听 brokers 节点变化

4. Controller 决定 Leader 选举

   选举规则：在 ISR 中存活为前提，按照 AR 中排在前面的优先。（AR：Kafka 分区中的所有副本统称）

5. Controller 将节点信息上传到 ZK

6. 其他 Controller 从 ZK 同步相关信息

7. 假设 Broker1 中 Leader 挂了

8. Controller 监听到节点变化

9. 获取 ISR

10. 选举新的 Leader

11. 更新 Leader 及 ISR

# P24 Broker_上下线

# P25 Broker_服役新节点（上）

## 4.2 生产经验——节点服役和退役

### 4.2.1 服役新节点

# P26 Broker_服役新节点（下）

1. 新节点准备

   1. 关闭 hadoop104，并右键执行克隆操作
   2. 开启 hadoop105，并修改 IP 地址
   3. 在 hadoop105 上，修改主机名称为 hadoop105
   4. 重新启动 hadoop104，hadoop105
   5. 修改 hadoop105 中 kafka 的 broker.id 为 3。
   6. 删除 hadoop105 中 kafka 下的 datas 和 logs。
   7. 启动 hadoop102、hadoop103、hadoop104 下的 kafka 集群。
   8. 单独启动 hadoop105 中的 kafka。

2. 执行负载均衡操作

   1. 创建一个要均衡的主题

      ```shell
      vim topics-to-move.json
      ```

      ```json
      {
          "topics": [
              {"topic": "first"}
          ],
          "version": 1
      }
      ```

   2. 生成一个负载均衡的计划

      ```shell
      bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --topics-to-move-to-json-file topics-to-move.json --broker-list "0,1,2,3" --generate
      ```

   3. 创建副本存储计划（所有副本存储在 broker0、broker1、broker2、broker3 中）。

      ```shell
      vim increase-replication-factor.json
      ```

   4. 执行副本存储计划

      ```shell
      bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --execute
      ```

   5. 验证副本存储计划

      ```shell
      bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --verify
      ```

      

# P27 Broker_退役旧节点

### 4.2.2 退役旧节点

1. 执行负载均衡操作

   先按照退役一台节点，生成执行计划，然后按照服役时操作流程执行负载均衡。

   1. 创建一个要均衡的主题

      ```shell
      vim topics-to-move.json
      ```

   2. 创建执行计划

      ```shell
      bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --topics-to-move-json-file topics-to-move.json --broker-list "0,1,2" --generate
      ```

   3. 创建副本存储计划（所有副本存储在 broker0、broker1、broker2 中）

      ```shell
      vim increase-replication-factor.json
      ```

   4. 执行副本存储计划

      ```shell
      bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --execute
      ```

   5. 验证副本存储计划

      ```shell
      bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --verify
      ```

2. 执行停止命令

   在 hadoop105 上执行停止命令即可

# P28 每日回顾（上）

## 一、概述

1. 定义

   1. 传统定义

      分布式 发布订阅 消息队列

      发布订阅：分为多种类型 订阅者根据需求 选择性订阅

   2. 最新定义

      流平台（存储、计算）

2. 消息队列应用场景

   1. 缓存削峰
   2. 解耦
   3. 异步通信

3. 两种模式

   1. 点对点

      一个生产者 一个消费者 一个 topic 会删除数据，用得不多

   2. 发布订阅

      多个生产者 多个消费者 而且相互独立 多个 topic 不会删除数据

4. 架构

   1. 生产者
   2. broker
      1. broker 服务器
      2. topic 主题 对数据分类
      3. 分区
      4. 可靠性 副本
      5. leader follower
      6. 生产者和消费者 只针对 leader 操作
   3. 消费者
      1. 消费者和消费者相互独立
      2. 消费者组（某个分区 只能由一个消费者消费）
   4. zookeeper
      1. broker.ids 0 1 2
      2. leader

## 二、入门

1. 安装
   1. broker.id 必须全局唯一
   2. broker.id、log.dirs zk/kafka
   3. 启动停止 先停止 kafka 再停 zk
   4. 脚本
2. 常用命令行
   1. 主题 kafka-topic.sh
      1. --bootstrap-server hadoop102:9092,hadoop103:9092
      2. --topic first
      3. --create
      4. --delete
      5. --alter
      6. --list
      7. --describe
      8. --partitions
      9. --replication-factor
   2. 生产者 kafka-console-producer.sh
      1. --bootstrap-server hadoop102:9092,hadoop103:9092
      2. --topic first
   3. 消费者 kafka-console-consumer.sh
      1. --bootstrap-server hadoop102:9092,hadoop103:9092
      2. --topic first

# P29 每日回顾（下）

## 三、生产者

1. 原理

2. 异步发送 API

   1. 配置

      1. 连接 bootstrap-server
      2. key value 序列化

   2. 创建生产者

      `KafkaProducer<String, String>()`

   3. 发送数据

      send()， send(, new Callback)

   4. 关闭资源

3. 同步发送

   send()， send(, new Callback).get()

4. 分区

   1. 好处

      存储 计算

   2. 默认分区规则

      1. 指定分区 按分区走
      2. key key 的 hashcode 值 % 分区数
      3. 没有指定 key 没有指定分区 粘性

   3. 自定义分区

      定义类 实现 Partitioner 接口

5. 吞吐量提高

   1. 批次大小 16k 32k
   2. linger.ms 0 => 5-100ms
   3. 压缩
   4. 缓存大小 32m => 64m

6. 可靠性

   acks

   - 0 丢失数据
   - 1 也可能会丢 传输普通日志
   - -1 完全可靠 + 副本大于等于2 isr >= 2 => 数据重复

7. 数据重复

   1. 幂等性

      <pid, 分区号, 序列号>

      默认打开

   2. 事务

      底层基于幂等性

      1. 初始化
      2. 启动
      3. 消费者 offset
      4. 提交
      5. 终止

8. 数据有序

   单分区内有序（有条件）

   多分区有序怎么办？

9. 乱序

   1. inflight =1
   2. 没有幂等性 inflight =1
   3. 有幂等性

## 四、broker

1. zk 存储了哪些信息
   1. broker.ids
   2. leader
   3. 辅助选举 controller
2. 工作流程
3. 服役
4. 退役

# P30 Broker_副本基本信息

## 4.3 Kafka 副本

### 4.3.1 副本基本信息

1. Kafka 副本作用：提高数据可靠性。

2. Kafka 默认副本 1 个，生产环境一般配置为 2 个，保证数据可靠性；太多副本会增加磁盘存储空间，增加网络上数据传输，降低效率。

3. Kafka 中副本分为：Leader 和 Follower，Kafka 生产者只会把数据发往 Leader，然后 Follower 找 Leader 进行同步数据。

4. Kafka 分区中的所有副本统称为 AR（Assigned Replicas）。

   AR = ISR + OSR

   ISR，表示和 Leader 保持同步的 Follower 集合。如果 Follower 长时间未向 Leader 发送通信请求或同步数据，则该 Follower 将被踢出 ISR。该时间阈值由 replica.lag.time.max.ms 参数设定，默认 30s。Leader 发生故障之后，就会从 ISR 中选举新的 Leader。

   OSR，表示 Follower 与 Leader 副本同步时，延迟过多的副本。

# P31 Broker_Leader 选举

### 4.3.2 Leader 选举流程

Kafka 集群中有一个 broker 的 Controller 会被选举为 Controller Leader，负责管理集群 broker 的上下线，所有 topic 的分区副本分配和 Leader 选举等工作。

Controller 的信息同步工作是依赖于 Zookeeper 的。



Leader 选举流程：

1. 假设 Broker1 中 Leader 挂了
2. Controller 监听到节点变化
3. 获取 ISR
4. 选举新的 Leader
5. 更新 Leader 及 ISR

1. broker 启动后在 zk 中注册

2. controller 谁先注册，谁先说了算

3. 由选举出来的 Controller 监听 brokers 节点变化

4. Controller 决定 Leader 选举

   选举规则：在 ISR 中存活为前提，按照 AR 中排在前面的优先。

5. Controller 将节点信息上传到 ZK

6. 其他 Controller 从 ZK 同步相关信息

7. 假设 Broker1 中 Leader 挂了

8. Controller 监听到节点变化

9. 获取 ISR

10. 选举新的 Leader

11. 更新 Leader 及 ISR



1. 创建一个新的 topic，4 个分区，4 个副本

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --create --topic atguigu1 --partitions 4 --replication-factor 4
   ```

2. 查看 Leader 分布情况

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --describe --topic atguigu1
   ```

3. 停止掉 hadoop105 的 kafka 进程，并查看 Leader 分区情况

   ```shell
   bin/kafka-server-stop.sh
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --describe --topic atguigu1
   ```

   

# P32 Broker_Follower 故障

### 4.3.3 Leader 和 Follower 故障处理细节

LEO（Log End Offset）：每个副本的最后一个 offset，LEO 其实就是最新的 offset + 1。

HW（High Watermark）：所有副本中最小的 LEO。

1. Follower 故障
   1. Follower 发生故障后会被临时踢出 ISR
   2. 这个期间 Leader 和 Follower 继续接收数据
   3. 待该 Follower 恢复后，Follower 会读取本地磁盘记录的上次的 HW，并将 log 文件高于 HW 的部分截取掉，从 HW 开始向 Leader 进行同步。
   4. 等该 Follower 的 LEO 大于等于该 Partition 的 HW，即 Follower 追上 Leader 之后，就可以重新加入 ISR 了。

# P33 Broker_Leader 故障

1. Leader 故障
   1. Leader 发生故障后，会从 ISR 中选出一个新的 Leader
   2. 为保证多个副本之间的数据一致性，其余的 Follower 会先将各自的 log 文件高于 HW 的部分截掉，然后从新的 Leader 同步数据。

注意：这只能保证副本之间的数据一致性，并不能保证数据不丢失或者不重复

# P34 Broker_分区副本分配

### 4.3.4 分区副本分配

如果 kafka 服务器只有 4 个节点，那么设置 kafka 的分区数大于服务器台数，在 kafka 底层如何分配存储副本呢？

# P35 Broker_手动调整分区副本分配

### 4.3.5 生产经验——手动调整分区副本存储

在生产环境中，每台服务器的配置和性能不一致，但是 Kafka 只会根据自己的代码规则创建对应的分区副本，就会导致个别服务器存储压力较大，所有需要手动调整分区副本的存储。

需求：创建一个新的 topic，4 个分区，两个副本，名称为 three，将该 topic 的所有副本都存储到 broker0 和 broker1 两台机器上。

手动调整分区副本的步骤如下：

1. 创建一个新的 topic，名称为 three

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --create --partitions 4 --replication-factor 2 --topic three
   ```

2. 查看分区副本存储情况

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --describe --topic three
   ```

3. 创建副本存储计划（所有副本都指定存储在 broker0、broker1 中）。

   ```shell
   vim increase-replication-factor.json
   ```

   ```json
   {
       "version": 1,
       "partitions": [{"topic":"three","partition":0,"replicas":[0,1]},{"topic":"three","partition":1,"replicas":[0,1]},{"topic":"three","partition":2,"replicas":[1,0]},{"topic":"three","partition":3,"replicas":[1,0]}]
   }
   ```

4. 执行副本存储计划。

   ```shell
   bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --execute
   ```

5. 验证副本存储计划

   ```shell
   bin/kafka-reassign-partitions.sh --bootstarp-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --verify
   ```

6. 查看分区副本存储情况

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --describe --topic three
   ```

   

# P36 Broker_LeaderPartition 负载平衡

### 4.3.6 生产经验——Leader Partition 负载平衡

正常情况下，Kafka 本身会自动把 Leader Partition 均匀分散在各个机器上，来保证每台机器的读写吞吐量都是均匀的。但是如果某些 broker 宕机，会导致 Leader Partition 过于集中在其他少部分几台 broker 上，这会导致少数几台 broker 的读写请求压力过高，其他宕机的 broker 重启之后都是 follower partition，读写请求很低，造成集群负载不均衡。

- auto.leader.rebalance.enable，默认是 true。自动 Leader Partition 平衡
- leader.imbalance.per.broker.percentage，默认是 10%。每个 broker 允许的不平衡的 leader 的比率。如果每个 broker 超过了这个值，控制器会触发 leader 的平衡。
- leader.imbalance.check.interval.seconds，默认值 300 秒。检查 leader 负载是否平衡的间隔时间。



# P37 Broker_增加副本因子

### 4.3.7 生产经验——增加副本因子

在生产环境当中，由于某个主题的重要等级需要提升，我们考虑增加副本。副本数的增加需要先制定计划，然后根据计划指定。

1. 创建 topic

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --create --partitions 3 --replication-factor 1 --topic four
   ```

2. 手动增加副本存储

   1. 创建副本存储计划（所有副本都指定存储在 broker0、broker1、broker2 中）

      ```shell
      vim increase-replication-factor.json
      ```

      ```json
      {
          "version": 1,
          "partitions": [{"topic":"four","partition":0,"replicas":[0,1,2]},{"topic":"four","partition":1,"replicas":[0,1,2]},{"topic":"four","partition":2,"replicas":[0,1,2]}]
      }
      ```

   2. 执行副本存储计划

      ```shell
      bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --execute
      ```

      

# P38 Broker_文件存储机制

## 4.4 文件存储

### 4.4.1 文件存储机制

1. Topic 数据的存储机制

   Topic 是逻辑上的概念，而 partition 是物理上的概念，每个 partition 对应于一个 log 文件，该 log 文件中存储的就是 Producer 生产的数据。Producer 生产的数据会被不断追加到该 log 文件末端，为防止 log 文件过大导致数据定位效率低下，Kafka 采取了分片和索引机制，将每个 partition 分为多个 segment。每个 segment 包括：`.index` 文件、`.log` 文件和 `.timeindex` 等文件。这些文件位于一个文件夹下，该文件夹的命名规则为：topic 名称+分区序号，例如：first-0。

   - 一个 partition 分为多个 segment
     - .log 日志文件
     - .index 偏移量索引文件
     - .timeindex 时间戳索引文件
     - 其他文件
     - （说明：index 和 log 文件以当前 segment 的第一条消息的 offset 命名）
   - 一个 topic 分为多个 partition

2. 思考：Topic 数据到底存储在什么位置

   1. 启动生产者，并发送消息。

      ```shell
      bin/kafka-console-producer.sh --bootstrap-server hadoop102:9092 --topic first
      ```

   2. 查看 hadoop102（或者 hadoop103、hadoop104）的 /opt/module/kafka/datas/first-1（first-0、first-2）路径上的文件。

      ```shell
      [atguigu@hadoop104 first-1]$ ls
      00000000000000000092.index
      00000000000000000092.log
      00000000000000000092.snapshot
      00000000000000000092.timeindex
      leader-epoch-checkpoint
      partition.metadata
      ```

   3. 直接查看 log 日志，发现是乱码

      ```shell
      cat 00000000000000000092.log
      ```

   4. 通过工具查看 index 和 log 信息

      ```shell
      kafka-run-class.sh kafka.tools.DumpLogSegments --files ./00000000000000000092.index
      kafka-run-class.sh kafka.tools.DumpLogSegments --files ./00000000000000000092.log
      ```

3. index 文件和 log 文件详解

   注意：

   1. index 为稀疏索引，大约每往 log 文件写入 4kb 数据，会往 index 文件写入一索引。参数 log.index.internal.bytes 默认 4kb。
   2. index 文件中保存的 offset 为相对 offset，这样能确保 offset 的值所占空间不会过大，因此能将 offset 的值控制在固定大小

   如何在 log 文件中定位到 offset=600 的 Record？

   1. 根据目标 offset 定位 Segment 文件
   2. 找到小于等于目标 offset 的最大 offset 对应的索引项
   3. 定位到 log 文件
   4. 向下遍历找到目标 Record

# P39 Broker_文件清除策略

### 4.4.2 文件清理策略

Kafka 中默认的日志保存时间是 7 天，可以通过调整如下参数修改保存时间。

- log.retention.hours，最低优先级小时，默认 7 天。
- log.retention.minutes，分钟。
- log.retention.ms，最高优先级毫秒。
- log.retention.check.interval.ms，负责设置检查周期，默认 5 分钟。

那么日志一旦超过了设置的时间，怎么处理呢？

Kafka 中提供的日志清理策略有 delete 和 compact 两种。

1. delete 日志删除：将过期数据删除

   - log.cleanup.policy=delete 所有数据启用删除策略

     1. 基于时间：默认打开。以 segment 中所有记录中的最大时间戳作为该文件时间戳。
     2. 基于大小：默认关闭。超过设置的所有日志总大小，删除最早的 segment。`log.retention.bytes`，默认等于 -1，表示无穷大。

     思考：如果一个 segment 中有一部分数据过期，一部分没有过期，怎么处理？

2. compact 日志压缩

   对于相同 key 的不同 value 值，只保留最后一个版本

   - log.cleanup.policy=compact 所有数据启用压缩策略

   压缩后的 offset 可能是不连续的，当从这些 offset 消费信息时，将会拿到比这个 offset 大的 offset 对应的消息，并从这个位置开始消费。

   这种策略只适合特殊场景，比如消息的 key 是用户 ID，value 是用户的资料，通过这种压缩策略，整个消息集里就保存了所有用户最新的资料。

# P40 Broker_高效读写

## 4.5 高效读写数据

1. Kafka 本身是分布式集群，可以采用分区技术，并行度高

2. 读数据采用稀疏索引，可以快速定位要消费的数据

3. 顺序写磁盘

   Kafka 的 producer 生产数据，要写入到 log 文件中，写的过程是一直追加到文件末端，为顺序写。官网有数据表明，同样的磁盘，顺序写能达到 600M/s，而随机写只有 100K/s。这与磁盘的机械结构有关，顺序写之所以快，是因为其省去了大量磁头寻址的时间。

4. 页缓存 + 零拷贝技术

   零拷贝：Kafka 的数据加工处理操作交由 Kafka 生产者和 Kafka 消费者处理。Kafka Broker 应用层不关心存储的数据，所以就不用走应用层，传输效率高。

   PageCache 页缓存：Kafka 重度依赖底层操作系统提供的 PageCache 功能。当上层有写操作时，操作系统只是将数据写入 PageCache。当读操作发生时，先从 PageCache 中查找，如果找不到，再去磁盘中读取。实际上 PageCache 是把尽可能多的空闲内存都当作了磁盘缓存来使用。

   

