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

   

# P41 消费者_消费方式

第5章 Kafka 消费者

## 5.1 Kafka 消费方式

- pull（拉）模式：

  consumer 采用从 broker 中主动拉取数据。

  Kakfa 采用这种方式。

- push（推）模式

  Kafka 没有采用这种方式，因为由 broker 决定消息发送速率，很难适应所有消费者的消费速率。例如推送的速度是 50m/s，Consumer1、Consumer2 就来不及处理消息。

pull 模式不足之处是，如果 Kafka 没有数据，消费者可能会陷入循环中，一直返回空数据

# P42 消费者_消费者总体工作流程

## 5.2 Kafka 消费者工作流程

### 5.2.1 消费者总体工作流程

每个分区的数据只能由消费者组中的一个消费者消费

一个消费者可以消费多个分区数据

每个消费者的 offset 由消费者提交到系统主题保存

# P43 消费者_消费者组工作原理

### 5.2.2 消费者组原理

Consumer Group(CG)：消费者组，由多个 consumer 组成。形成一个消费者组的条件，是所有消费者的 groupid 相同。

- 消费者组内每个消费者负责消费不同分区的数据，一个分区只能由一个组内消费者消费。
- 消费者组之间互不影响。所有的消费者都属于某个消费者组，即消费者组是逻辑上的一个订阅者。
- 如果向消费者组中添加更多的消费者，超过主题分区数量，则有一部分消费者就会闲置，不会接收任何消息

# P44 消费者_消费者组初始化

1、coordinator: 辅助实现消费者组的初始化和分区的分配。

coordinator 节点选择 = groupid 的 hashcode 值 % 50 （__consumer_offsets 的分区数量）

例如：groupid 的 hashcode 值 = 1，1 % 50 = 1，那么 __consumer_offsets 主题的 1 号分区，在哪个 broker 上，就选择这个节点的 coordinator 作为这个消费者组的老大。消费者组下的所有的消费者提交 offset 的时候就往这个分区去提交 offset。

1. 每个 consumer 都发送 JoinGroup 请求
2. 选出一个 consumer 作为 leader
3. 把要消费的 topic 情况发送给 leader 消费者
4. leader 会负责制定消费方案
5. 把消费方案发给 coordinator
6. Coordinator 就把消费方案下发给各个 consumer
7. 每个消费者就会和 coordinator 保持心跳（默认 3s），一旦超时 （session.timeout.ms=45s），该消费者会被移除，并触发再平衡；或者消费者处理消息的时间过长（max.poll.interval.ms 5 分钟），也会触发再平衡

# P45 消费者_消费者组详细消费流程

group consumer

↓ sendFetches 发送消费请求

ConsumerNetworkClient

- fetch.min.bytes 每批次最小抓取大小，默认1字节
- fetch.max.wait.ms 一批数据最小值未达到的超时时间，默认 500ms
- fetch.max.bytes 每批次最大抓取大小，默认 50m

↓ send

Kafka cluster（broker topic partition）

↓ onSuccess

completedFetches (queue) → parseRecord（反序列化） → Interceptors（拦截器） → 处理数据

- max.poll.records 一次拉取数据返回消息的最大条数，默认 500 条

↑ FetchedRecords 从队列中抓取数据

group consumer

### 5.2.3 消费者重要参数

| 参数名称                                    | 描述                                                         |
| ------------------------------------------- | ------------------------------------------------------------ |
| bootstrap.servers                           | 向 Kafka 集群建立初始连接用到的 host/port 列表               |
| key.deserializer<br />和 value.deserializer | 指定接收消息的 key 和 value 的反序列化类型。一定要写全类名。 |



# P46 消费者_消费一个主题

## 5.3 消费者 API

### 5.3.1 独立消费者案例（订阅主题）

1. 需求：

   创建一个独立消费者，消费 first 主题中的数据。

   **注意：在消费者 API 代码中必须配置消费者组 id。命令行启动消费者不填写消费者组 id 会被自动填写随机的消费者组 id**

2. 实现步骤

   1. 创建包名  com.atguigu.kafka.consumer

   2. 编写代码

      ```java
      public class CustomConsumer {
          public static void main(String[] args) {
              // 0 配置
              Properties properties = new Properties();
              // 连接 bootstrap.servers
              properties.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "hadoop102:9092,hadoop103:9092");
              // 反序列化
              properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
              properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
              // 配置消费者组 id
              properties.put(ConsumerConfig.GROUP_ID_CONFIG, "test");
              // 1 创建一个消费者 "", "hello"
              KafkaConsumer<String, String> kafkaConsumer = new KafkaConsumer<>(properties);
              // 2 订阅主题 first
              ArrayList<String> topics = new ArrayList<>();
              topics.add("first");
              kafkaConsumer.subscribe(topics);
              // 3 消费数据
              while (true) {
                  ConsumerRecords<String, String> consumerRecords = kafkaConsumer.poll(Duration.ofSeconds(1));
                  for (ConsumerRecord<String, String> consumerRecord : consumerRecords) {
                      System.out.println(consumerRecord);
                  }
              }
          }
      }
      ```

      

# P47 消费者_消费一个分区

### 5.3.2 独立消费者案例（订阅分区）

1. 需求：创建一个独立消费者，消费 first 主题 0 号分区的数据

2. 实现步骤

   1. 代码编写

      ```java
      public class CustomConsumerPartition {
          public static void main(String[] args) {
              // 0 配置
              Properties properties = new Properties();
              // 连接 bootstrap.servers
              properties.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "hadoop102:9092,hadoop103:9092");
              // 反序列化
              properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
              properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
              // 配置消费者组 id
              properties.put(ConsumerConfig.GROUP_ID_CONFIG, "test");
              // 1 创建一个消费者 "", "hello"
              KafkaConsumer<String, String> kafkaConsumer = new KafkaConsumer<>(properties);
              // 2 订阅主题对应的分区
              ArrayList<TopicPartition> topicPartitions = new ArrayList<>();
              topicPartitions.add(new TopicPartition("first", 0));
              kafkaConsumer.assign(topicPartitions);
              // 3 消费数据
              while (true) {
                  ConsumerRecords<String, String> consumerRecords = kafkaConsumer.poll(Duration.ofSeconds(1));
                  for (ConsumerRecord<String, String> consumerRecord : consumerRecords) {
                      System.out.println(consumerRecord);
                  }
              }
          }
      }
      ```

      

# P48 消费者_消费者组案例

### 5.3.3 消费者组案例

1. 需求：测试同一个主题的分区数据，只能由一个消费者组中的一个消费。
2. 案例实操
   1. 复制一份基础消费者的代码，在 IDEA 中同时启动，即可启动同一个消费者组中的两个消费者。

# P49 消费者_Range 分配

## 5.4 生产经验——分区的分配以及再平衡

1. 一个 consumer group 中有多个 consumer 组成，一个 topic 有多个 partition 组成，现在的问题是，**到底由哪个 consumer 来消费哪个 partition 的数据**。

2. Kafka 有四种主流的分区分配策略：**Range、RoundRobin、Sticky、CooperativeSticky**。

   可以通过配置参数 **partition.assignment.strategy**，修改分区的分配策略。默认策略是 Range + CooperativeSticky。Kafka 可以同时使用多个分区分配策略。



1. 每个 consumer 都发送 JoinGroup 请求
2. 选出一个 consumer 作为 leader
3. 把要消费的 topic 情况发送给 leader 消费者
4. leader 会负责制定消费方案
5. 把消费方案发给 coordinator
6. Coordinator 就把消费方案下发给各个 consumer
7. 每个消费者就会和 coordinator 保持心跳（默认 3s），一旦超时 （session.timeout.ms=45s），该消费者会被移除，并触发再平衡；或者消费者处理消息的时间过长（max.poll.interval.ms 5 分钟），也会触发再平衡

| 参数名称                      | 描述                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| heartbeat.interval.ms         | Kafka 消费者和 coordinator 之间的心跳时间，**默认 3s**。<br />该条目的值必须小于 session.timeout.ms，也不应该高于 session.timeout.ms 的 1/3. |
| session.timeout.ms            | Kafka 消费者和 coordinator 之间连接超时时间，**默认 45s**。超过该值，该消费者被移除，消费者组执行再平衡。 |
| max.poll.interval.ms          | 消费者处理消息的最大时长，**默认是 5 分钟**。超过该值，该消费者被移除，消费者组执行再平衡。 |
| partition.assignment.strategy | 消费者分区分配策略，默认策略是 Range + CooperativeSticky。Kafka 可以同时使用多个分区分配策略。可以选择的策略包括：Range、RoundRobin、Sticky、CooperativeSticky |

### 5.4.1 Range 以及再平衡

1）Range 分区策略原理

Range 是对每个 topic 而言的。

首先对同一个 topic 里面的**分区按照序号进行排序**，并对**消费者按照字母顺序进行排序**。

假如现在有 7 个分区，3 个消费者，排序后的分区将会是 0, 1, 2, 3, 4, 5, 6；消费者排序完之后将会是  C0, C1, C2。

通过 **partition 数/ consumer 数**来决定每个消费者应该消费几个分区。**如果除不尽，那么前面几个消费者将会多消费 1 个分区。**

例如，7/3 = 2 余 1，除不尽，那么消费者 C0 便会多消费 1 个分区。8/3 = 2 余 2，除不尽，那么 C0 和 C1 分别多消费一个。

**注意：**如果只是针对 1 个 topic 而言，C0 消费者多消费 1 个分区影响不是很大。但是如果有 N 多个 topic，那么针对每个 topic，消费者 C0 都将多消费 1 个分区，topic 越多，C0 消费的分区会比其他消费者明显多消费 N 个分区。

**容易产生数据倾斜！**

2）Range 分区分配策略案例

1. 修改主题 first 为 7 个分区

   ```shell
   bin/kafka-topics.sh  --bootstrap-server hadoop102:9092 --alter --topic first --partitions 7
   ```

   **注意：分区数可以增加，但是不能减少。**

2. 复制 CustomConsumer 类，创建 CustomConsumer2。这样可以由三个消费者 CustomConsumer、CustomConsumer1、CustomConsumer2 组成消费者组，组名都为 “test”，同时启动 3 个消费者。

3. 启动 CustomProducer 生产者，发送 500 条消息，随机发送到不同的分区。

# P50 消费者_Roundrobin

### 5.4.2 RoundRobin 以及再平衡

1）RoundRobin 分区策略原理

RoundRobin 针对集群中**所有 Topic 而言**。

RoundRobin 轮询分区策略，是把**所有的 partition 和所有的 consumer 都列出来**，然后**按照 hashcode 进行排序**，最后通过**轮询算法**来分配 partition 给到各个消费者。

2）RoundRobin 分区分配策略案例

1. 依次在 CustomConsumer、CustomConsumer1、CustomConsumer2 三个消费者代码中修改分区分配策略为 RoundRobin。

   ```java
   // 修改分区分配策略
   properties.put(ConsumerConfig.PARTITION_ASSIGNMENT_STRATEGY_CONFIG, "org.apache.kafka.clients.consumer.RoundRobinAssignor");
   ```

2. 重启 3 个消费者，重复发送消息的步骤，观看分区结果。

# P51 消费者_Sticky

### 5.4.3 Sticky 以及再平衡

**粘性分区定义：**可以理解为分配的结果带有“粘性的”。即在执行一次新的分配之前，考虑上一次分配的结果，尽量少的调整分配的变动，可以节省大量的开销。

粘性分区是 Kafka 从 0.11.x 版本开始引入这种分配策略，**首先会尽量均衡的放置分区到消费者上面**，在出现同一消费组内消费者出现问题的时候，会**尽量保持原有分配的分区不变化。**

1. 需求

   设置主题为 first，7 个分区；准备 3 个消费者，采用粘性分区策略，并进行消费，观察消费分配情况。然后再停止其中一个消费者，再次观察消费分配情况。

2. 步骤

   1. 修改分区分配策略为粘性。

      **注意：3 个消费者都应该注释掉，之后重启 3 个消费者，如果出现报错，全部停止等会再重启，或者修改为全新的消费者组。**

      ```java
      // 修改分区分配策略
      ArrayList<String> strategys = new ArrayList<>();
      strategys.add("org.apache.kafka.clients.consumer.StickyAssignor");
      properties.put(ConsumerConfig.PARTITION_ASSIGNMENT_STRATEGY_CONFIG, strategys);
      ```

   2. 使用同样的生产者发送 500 条消息。

      可以看到会尽量保持分区的个数近似划分分区。

# P52 消费者_offset 保存位置

## 5.5 offset 位移

### 5.5.1 offset 的默认维护位置

Kafka 0.9 版本之前，consumer 默认将 offset 保存在 Zookeeper 中

从 0.9 版本开始，consumer 默认将 offset 保存在 Kafka 一个内置的 topic 中，该 topic 为 __consumer_offsets

__consumer_offsets 主题里面采用 key 和 value 的方式存储数据。key 是 group.id + topic + 分区号，value 就是当前 offset 的值。每隔一段时间，kafka 内部会对这个 topic 进行 compact，也就是每个 group.id + topic + 分区号就保留最新数据。

1）消费 offset 案例

1. 思想：__consumer_offsets 为 Kafka 中的 topic，那就可以通过消费者进行消费。

2. 在配置文件 config/**consumer.properties** 中添加配置 **exclude.internal.topics=false**, **默认是 true，表示不能消费系统主题。为了查看该系统主题数据，所以该参数修改为 false**。

3. 采用命令行方式，创建一个新的 topic。

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --create --topic atguigu --partitions 2 --replication-factor 2
   ```

4. 启动生产者往 atguigu 生产数据。

   ```shell
   bin/kafka-console-producer.sh --topic atguigu --bootstrap-server hadoop102:9092
   ```

5. 启动消费者消费 atguigu 数据

   ```shell
   bin/kafka-console-consumer.sh --topic __consumer_offsets --bootstrap-server hadoop102:9092 --consumer.config config/consumer.properties --formatter "kafka.coordinator.group.GroupMetadataManager\$OffsetsMessageFormatter" --from-beginning
   ```

   

# P53 消费者_自动 offset

### 5.5.2 自动提交 offset

为了使我们能够专注于自己的业务逻辑，Kafka 提供了自动提交 offset 的功能。

自动提交 offset 的相关参数：

- **enable.auto.commit**: 是否开启自动提交 offset 功能，默认是 true
- **auto.commit.interval.ms**: 自动提交 offset 的时间间隔，默认是 5s



1. 不断拉取数据
2. Consumer 每 5s 提交 offset

| 参数名称                | 描述                                                        |
| ----------------------- | ----------------------------------------------------------- |
| enable.auto.commit      | **默认值为 true**，消费者会自动周期性地向服务器提交偏移量。 |
| auto.commit.interval.ms | 如果设置了 enable.auto.commit 的值为 true，则该值定义了消费 |

# P54 消费者_手动 offset

### 5.5.3 手动提交 offset

虽然自动提交 offset 十分简单便利，但由于其是基于时间提交的，开发人员难以把握 offset 提交的时机。因此 Kafka 还提供了手动提交 offset 的 API。

手动提交 offset 的方法有两种：分别是 **commitSync（同步提交）**和 **commitAsync（异步提交）**。两者的相同点是，都会将**本次提交的一批数据最高的偏移量提交**；不同点是，**同步提交阻塞当前线程**，一直到提交成功，并且会自动失败重试（由不可控因素导致，也会出现提交失败）；而**异步提交则没有失败重试机制，故有可能提交失败。**

- **commitSync（同步提交）：必须等待 offset 提交完毕，再去消费下一批数据。**
- **commitAsync（异步提交）：发送完提交 offset 请求后，就开始消费下一批数据了。**

1）同步提交 offset

由于同步提交  offset 有失败重试机制，故更加可靠，但是由于一直等待提交结果，提交的效率比较低。以下为同步提交 offset 的示例。

```java
public class CustomConsumerByHandSync {
    public static void main(String[] args) {
        // ...
        
        // 手动提交
        properties.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, false);
        
        // ...
        
        // 3 消费数据
        while (true) {
            ConsumerRecords<String, String> consumerRecords = kafkaConsumer.poll(Duration.ofSeconds(1));
            for (ConsumerRecord<String, String> consumerRecord : consumerRecords) {
                System.out.println(consumerRecord);
            }
            // 手动提交 offset
            // kafkaConsumer.commitSync();
            kafkaConsumer.commitAsync();
        }
    }
}
```

# P55 消费者_指定 offset

### 5.5.4 指定 Offset 消费

**auto.offset.reset = earliest | latest | none** 默认是 latest。

当 Kafka 中没有初始偏移量（消费者组第一次消费）或服务器上不再存在当前偏移量时（例如该数据已被删除），该怎么办？

1. **earliest**：自动将偏移量重置为最早的偏移量，**--from-beginning**。

2. **latest（默认值）**：自动将偏移量重置为最新偏移量。

3. none：如果未找到消费者组的先前偏移量，则向消费者抛出异常。

4. 任意指定 offset 位移开始消费

   ```java
   public class CustomConsumerSeek {
       public static void main(String[] args) {
           // 0 配置信息
           Properties properties = new Properties();
           
           // 连接
           properties.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "hadoop102:9092,hadoop103:9092");
           
           // 反序列化
           properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
           properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
           
           // 组 id
           properties.put(ConsumerConfig.GROUP_ID_CONFIG, "test2");
           
           // 1 创建消费者
           KafkaConsumer<String, String> kafkaConsumer = new KafkaConsumer<>(properties);
           
           // 2 订阅主题
           ArrayList<String> topics = new ArrayList<>();
           topics.add("first");
           kafkaConsumer.subscribe(topics);
           
           // 指定位置进行消费
           Set<TopicPartition> assignment = kafkaConsumer.assignment();
           
           // 保证分区分配方案已经制定完毕
           while (assignment.size() == 0) {
               kafkaConsumer.poll(Duration.ofSeconds(1));
               assignment = kafkaConsumer.assignment();
           }
           
           // 指定消费的 offset
           for (TopicPartition topicPartition: assignment) {
               kafkaConsumer.seek(topicPartition, 100);
           }
           
           // 3 消费数据
           while (true) {
               ConsumerRecords<String, String> consumerRecords = kafkaConsumer.poll(Duration.ofSeconds(1));
               for (ConsumerRecord<String, String> consumerRecord : consumerRecords) {
                   System.out.println(consumerRecord);
               }
           }
       }
   }
   ```

# P56 消费者_按照时间消费

### 5.5.5 指定时间消费

需求：在生产环境中，会遇到最近消费的几个小时数据异常，想重新按照时间消费。例如要求按照时间消费前一天的数据，怎么处理？

操作步骤：

```java
// ...

// 保证分区分配方案已经制定完毕
while (assignment.size() == 0) {
    kafkaConsumer.poll(Duration.ofSeconds(1));
    assignment = kafkaConsumer.assignment();
}

// 希望把时间转换为对应的 offset
HashMap<TopicPartition, Long> topicPartitionLongHashMap = new HashMap<>();
// 封装对应集合
for (TopicPartition topicPartition: assignment) {
    topicPartitionLongHashMap.put(topicPartition, System.currentTimeMillis() - 1 * 24 * 3600 * 1000);
}
Map<TopicPartition, OffsetAndTimestamp> topicPartitionOffsetAndTimestampMap = kafkaConsumer.offsetsForTimes(topicPartitionLongHashMap);

// 指定消费的 offset
for (TopicPartition topicPartition: assignment) {
    OffsetAndTimestamp offsetAndTimestamp = topicPartitionOffsetAndTimestampMap.get(topicPartition);
    kafkaConsumer.seek(topicPartition, offsetAndTimestamp.offset());
}

// ...
```

# P57 消费者_消费者事务

### 5.5.6 漏消费和重复消费

**重复消费**：已经消费了数据，但是 offset 没提交。

**漏消费**：先提交 offset 后消费，有可能会造成数据的漏消费。



场景1：**重复消费**。自动提交 offset 引起。

1. Consumer 每 5s 提交 offset
2. 如果提交 offset 后的 2s，consumer 挂了
3. 再次重启 consumer，则从上一次提交的 offset 处继续消费，导致重复消费

场景2：**漏消费**。设置 offset 为手动提交，当 offset 被提交时，数据还在内存中未落盘，此时刚好消费者线程被 kill 掉，那么 offset 已经提交，但是数据未处理，导致这部分内存中的数据丢失。

1. 提交 offset
2. 消费者消费的数据还在内存中，消费者挂掉，导致漏消费



如果想完成 Consumer 端的精准一次性消费，那么需要 **Kafka 消费端将消费过程和提交 offset 过程做原子绑定**。此时我们需要将 Kafka 的 offset 保存到支持事务的自定义介质（比如 MySQL）。这部分知识会在后续项目部分涉及。

# P58 消费者_数据积压

## 5.7 生产经验——数据积压（消费者如何提高吞吐量）

1. 如果是 Kafka 消费能力不足，则可以考虑**增加 Topic 的分区数**，并且同时提升消费组的消费者数量，**消费者数 = 分区数**。（两者缺一不可）
2. 如果是下游的数据处理不及时：**提高每批次拉取的数量。**批次拉取数据过少（拉取数据/处理时间 < 生产速度），使处理的数据小于生产的数据，也会造成数据积压。

# P59 每日回顾（上）

## 四、broker

1. zk 存储了哪些信息

   1. broker.ids
   2. leader
   3. 辅助选举 controller

2. 工作流程

3. 服役

   1. 准备一台干净服务器 hadoop100
   2. 对哪个主题操作
   3. 形成计划
   4. 执行计划
   5. 验证计划

4. 退役

   1. 要退役的节点不让存储数据
   2. 退出节点

5. 副本

   1. 副本的好处 提高可靠性
   2. 生产环境中通常2个 默认1个
   3. 有 leader follower leader
   4. isr
   5. controller：第一次 随机 轮询
   6. leader 挂了
   7. follower 挂了
   8. 副本分配 默认
   9. 手动副本分配 指定计划 执行计划 验证计划
   10. leader partition的负载均衡 10%
   11. 手动增加副本因子

6. 存储机制

   broker topic partition log segment 1g 稀疏索引 4kb

7. 删除数据

   默认7天 3天 7小时

   两种 删除 压缩

8. 高效读写

   1. 集群 采用分区
   2. 稀疏索引
   3. 顺序读写
   4. 零拷贝和页缓存

# P60 每日回顾（下）

## 五、消费者

1. 总体流程

2. 消费者组

3. 按照主题消费

   1. 配置信息

      连接

      反序列化

      组 id

   2. 创建消费者

   3. 订阅主题

   4. 消费数据

4. 按照分区

5. 消费者组案例

   组 id

6. 分区分配策略 再平衡

   7个分区 3个消费者

   - range

     0 1 2 x

     3 4

     5 6

   - roundrobin 轮询

     0 3 6

     1 4

     2 5

   - 粘性 2 2 3

     0 3 4

     2 6

     1 5

7. offset

   1. 默认存储在系统主题
   2. 自动提交 5s 默认
   3. 手动提交 同步 异步
   4. 指定 offset 消费 seek()
   5. 按照时间消费
   6. 漏消费 重复消费

8. 事务

   生产端 =》 集群

   集群 =》 消费者

   消费者 =》 框架

9. 数据积压

   1. 增加分区 增加消费者个数
   2. 生产 =》 集群 4个参数
   3. 消费端 两个参数 50m 500条

# P61 监控_MySQL环境准备

第6章 Kafka-Eagle 监控

Kafka-Eagle 框架可以监控 Kafka 集群的整体运行情况，在生产环境中经常使用。

## 6.1 MySQL 环境准备

Kafka-Eagle 的安装依赖于 MySQL，MySQL 主要用来存储可视化展示的数据。如果集群中之前安装过 MySQL 可以跨过该步

# P62 监控_Kafka 环境准备

## 6.2 Kafka 环境准备

1. 关闭 Kafka 集群

   ```shell
   kf.sh stop
   ```

2. 修改 /opt/module/kafka/bin/kafka-server-start.sh 命令中

   ```shell
   vim bin/kafka-server-start.sh
   ```

   修改如下参数值：

   ```shell
   if [ "x$KAFKA_HEAP_OPTS" = "x" ]; then
   	export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
   fi
   ```

   为

   ```shell
   if [ "x$KAFKA_HEAP_OPTS" = "x" ]; then
   	export KAFKA_HEAP_OPTS="-server -Xms2G -Xmx2G -XX:PermSize=128m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThread=5 -XX:InitiatingHeapOccupancyPercent=70"
   	export JMX_PORT="9999"
   	#export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
   fi
   ```

   **注意：修改之后在启动 Kafka 之前要分发之其他节点**

   ```shell
   xsync kafka-server-start.sh
   ```

# P63 监控_Kafka-Eagle 安装

## 6.3 Kafka-Eagle 安装

官网：http://www.kafka-eagle.org/

1. 上传压缩包 kafka-eagle-bin-2.0.8.tar.gz 到集群 /opt/software 目录

2. 解压到本地

   ```shell
   tar -zxvf kafka-eagle-bin-2.0.8.tar.gz
   ```

3. 进入刚才解压的目录

   ```shell
   ll
   ```

4. 将 efak-web-2.0.8-bin.tar.gz 解压至 /opt/module

   ```shell
   tar -zxvf efak-web-2.0.8-bin.tar.gz -C /opt/module/
   ```

5. 修改名称

   ```shell
   mv efak-web-2.0.8/ efak
   ```

6. 修改配置文件 /opt/module/efak/conf/system-config.properties

   ```shell
   vim system-config.properties
   ```

   ```properties
   efak.zk.cluster.alias=cluster1
   cluster1.zk.list=hadoop102:2181,hadoop103:2181,hadoop104:2181/kafka
   # offset 保存在 kafka
   cluster1.efak.offset.storage=kafka
   # 配置 mysql 连接
   efak.driver=com.mysql.jdbc.Driver
   efak.url=jdbc:mysql://hadoop102:3306/ke?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull
   efak.username=root
   efak.password=000000
   ```

7. 添加环境变量

   ```shell
   sudo vim /etc/profile.d/my_env.sh
   
   # kafkaEFAK
   export KE_HOME=/opt/module/efak
   export PATH=$PATH:$KE_HOME/bin
   ```

   **注意：source /etc/profile**

   ```shell
   source /etc/profile
   ```

8. 启动

   1. **注意：启动之前需要先启动 ZK 以及 KAFKA**

      ```shell
      kf.sh start
      ```

   2. 启动 efak

      ```shell
      bin/ke.sh start
      ```

       说明：如果停止 efak，执行命令。

      ```shell
      bin/ke.sh stop
      ```

      

# P64 监控_Kafka-Eagle 监控页面

# P65 Kraft模式

第7章 Kafka-Kraft 架构

## 7.1 Kafka-Kraft 架构

左图为 Kafka 现有架构，元数据在 zookeeper 中，运行时动态选举  controller，由 controller 进行 Kafka 集群管理。右图为 kraft 模式架构（实验性），不再依赖 zookeeper 集群，而是用三台 controller 节点代替 zookeeper，元数据保存在 controller 中，由 controller 直接进行 Kafka 集群管理。

这样做的好处有以下几个：

- Kafka 不再依赖外部框架，而是能够独立运行；
- controller 管理集群时，不再需要从 zookeeper 中先读取数据，集群性能上升；
- 由于不依赖 zookeeper，集群扩展时不再受到 zookeeper 读写能力限制；
- controller 不再动态选举，而是由配置文件规定。这样我们可以有针对性的加强 controller 节点的配置，而不是像以前一样对随机 controller 节点的高负载束手无策。

## 7.2 Kafka-Kraft 集群部署

1. 再次解压一份 kafka 安装包
2. 重命名为 kafka2
3. 在 hadoop102 上修改 /opt/module/kafka2/config/kraft/server.properties 配置文件
4. 分发 kafka2
   - 在 hadoop103 和 hadoop104 上需要**对 node.id 相应改变**，值需要和 controller.quorum.voters 对应。
   - 在 hadoop103 和 hadoop104 上需要根据各自的主机名称，修改相应的 advertised.Listeners 地址。
5. 初始化集群数据目录
   1. 首先生成存储目录唯一 ID
   2. 用该 ID 格式化 kafka 存储目录（三台节点）
6. 启用 kafka 集群
7. 停止 kafka 集群

## 7.3 Kafka-Kraft 集群启动停止脚本

1. 在 /home/atguigu/bin 目录下创建文件 kf2.sh 脚本文件
2. 添加执行权限
3. 启动集群命令

# P71 集成_SpringBoot生产者

第3章 集成 SpringBoot

SpringBoot 是一个在 JavaEE 开发中非常常用的组件。可以用于 Kafka 的生产者，也可以用于 SpringBoot 的消费者。

1）在 IDEA 中安装 lombok 插件

在 Plugins 下搜索 lombok 然后在线安装即可，安装后注意重启。

2）SpringBoot 环境准备

1. 创建一个 Spring Initializr

   **注意：有时候 SpringBoot 官方脚手架不稳定，我们切换国内地址：https://start.aliyun.com**

2. 项目名称 springboot

3. 添加项目依赖

4. 检查自动生成的配置文件

## 3.1 SpringBoot 生产者

1. 修改 SpringBoot 核心配置文件 application.properties，添加生产者相关信息

   ```properties
   # 指定 kafka 的地址
   spring.kafka.bootstrap-servers=hadoop102:9092,hadoop103:9092,hadoop104:9092
   # 指定 key 和 value 的序列化器
   spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
   spring.kafka.producer.value-serializer=org.apache.kafka.common.serialization.StringSerializer
   ```

2. 创建 controller 从浏览器接收数据，并写入指定的 topic

   ```java
   @RestController
   public class ProducerController {
       // Kafka 模板用来向 kafka 发送数据
       @Autowired
       KafkaTemplate<String, String> kafka;
       
       @RequestMapping("/atguigu")
       public String data(String msg) {
           kafka.send("first", msg);
           return "ok";
       }
   }
   ```

3. 在浏览器中给 /atguigu 接口发送数据

# P72  集成_SpringBoot消费者

## 3.2 SpringBoot 消费者

1. 修改 SpringBoot 核心配置文件 application.properties

   ```properties
   # ======== 消费者配置开始 ==========
   # 指定 kafka 的地址
   spring.kafka.bootstrap-servers=hadoop102:9092,hadoop103:9092,hadoop104:9092
   # 指定 key 和 value 的反序列化器
   spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
   spring.kafka.producer.value-serializer=org.apache.kafka.common.serialization.StringSerializer
   # 指定消费者组的 group_id
   spring.kafka.consumer.group-id=atguigu
   # ======== 消费者配置结束 ==========
   ```

2. 创建类消费 Kafka 中指定 topic 的数据

   ```java
   @Configuration
   public class KafkaConsumer {
       // 指定要监听的 topic
       @KafkaListener(topics = "first")
       public void consumeTopic(String msg) { // 参数：收到的 value
           System.out.println("收到的信息： " + msg);
       }
   }
   ```

3. 向 first 主题发送数据

   ```shell
   bin/kafka-console-producer.sh --bootstrap-server hadoop102:9092 --topic first
   ```

# P75 调优_内容简介

# P76 调优_硬件选择

第1章 Kafka 硬件配置选择

## 1.1 场景说明

100万日活，每人每天 100 条日志，每天总共的日志条数是 100 万 * 100 条 = 1 亿条。

1 亿/24 小时/60 分/60 秒 = 1150 条/每秒钟

每条日志大小：0.5k ~ 2k（取 1k）。

1150 条/每秒钟 * 1k ≈ 1m/s

高峰期每秒钟：1150 条 * 20 倍 = 23000 条。

每秒多少数据量：20MB/s

## 1.2 服务器台数选择

服务器台数 = 2 * (生产者峰值生产速率 * 副本 / 100) + 1

= 2 * (20m/s * 2 / 100) + 1

= 3 台

建议 3 台服务器

## 1.3 磁盘选择

Kafka 底层主要是**顺序写**，固态硬盘和机械硬盘的顺序写速度差不多。

**建议选择普通的机械硬盘。**

每天总数据量：1 亿条 * 1k ≈ 100g

100g * 副本 2 * 保存时间 3 天 / 0.7 ≈ 1T

建议三台服务器硬盘总大小，大于等于 1T。

## 1.4 内存选择

Kafka 内存组成：堆内存 + 页缓存

1）Kafka 堆内存建议每个节点：10g ~ 15g

在 kafka-server-start.sh 中修改

1. 查看 Kafka 进程号

2. 根据 Kafka 进程号，查看 Kafka 的 GC 情况

   参数说明：

   - S0C：第一个幸存区的大小
   - S1C：第二个幸存区的大小
   - S0U：第一个幸存区的使用大小
   - S1U：第二个幸存区的使用大小
   - EC：伊甸园区的大小
   - EU：伊甸园区的使用大小
   - OC：老年代大小
   - OU：老年代使用大小
   - MC：方法区大小
   - MU：方法区使用大小
   - CCSC：压缩类空间大小
   - CCSU：压缩类空间使用大小
   - **YGC：年轻代垃圾回收次数**
   - YGCT：年轻代垃圾回收消耗时间
   - FGC：老年代垃圾回收次数
   - FGCT：老年代垃圾回收消耗时间
   - GCT：垃圾回收消耗总时间

3. 根据 Kafka 进程号，查看 Kafka 的堆内存

2）页缓存：页缓存是 Linux 系统服务器的内存。我们只需要保证 1 个 segment（1g）中 25% 的数据在内存中就好。

每个节点页缓存大小 = (分区数 * 1g * 25%) / 节点数。例如 10 个分区，页缓存大小 = (10 * 1g * 25%) / 3 ≈ 1g

建议服务器内存大于等于 11G。

## 1.5 CPU 选择

num.io.threads = 8 负责写磁盘的线程数，整个参数值要占总核数的 50%。

num.replica.fetchers = 1 副本拉取线程数，这个参数占总核数的 50% 的 1/3

num.network.threads = 3 数据传输线程数，这个参数占总核数的 50% 的 2/3

建议 32 个 cpu core。

## 1.6 网络选择

网络带宽 = 峰值吞吐量 ≈ 20MB/s 选择千兆网卡即可。

100Mbps 单位是 bit：10M/s 单位是 byte；1 byte = 8 bit，100 Mbps/8 = 12.5 M/s

一般百兆的网卡（100 Mbps）、千兆的网卡（1000 Mbps）、万兆的网卡（10000 Mbps）。

# P77 调优_生产者

第2章 Kafka 生产者

## 2.1 Kafka 生产者核心参数配置

| 参数名称                              | 描述                                                         |
| ------------------------------------- | ------------------------------------------------------------ |
| bootstrap.servers                     | 生产者连接集群所需的 broker 地址清单。例如 hadoop102:9092,hadoop103:9092,hadoop104:9092，可以设置 1 个或者多个，中间用逗号隔开。注意这里并非需要所有的 broker 地址，因为生产者从给定的 broker 里查找到其他 broker 信息。 |
| key.serializer 和 value.serializer    | 指定发送消息的 key 和 value 的序列化类型。一定要写全类名     |
| buffer.memory                         | RecordAccumulator 缓冲区总大小，**默认 32m**。               |
| batch.size                            | 缓冲区一批数据最大值，**默认 16k**。适当增加该值，可以提高吞吐量，但是如果该值设置太大，会导致数据传输延迟增加 |
| linger.ms                             | 如果数据迟迟未达到 batch.size，sender 等待 linger.time 之后就会发送数据。单位 ms，**默认值 0ms**，表示没有延迟。生产环境建议该值大小为 5 ~ 100ms 之间。 |
| acks                                  | 0：生产者发送过来的数据，不需要等数据落盘应答。<br />1：生产者发送过来的数据，Leader 收到数据后应答。<br />-1（all）：生产者发送过来的数据，Leader+ 和 isr 队列里面的所有节点收齐数据后应答。**默认值是 -1，-1 和 all 是等价的。** |
| max.in.flight.requests.per.connection | 允许最多没有返回 ack 的次数，**默认为 5**，开启幂等性要保证该值是 1 ~ 5 的数字。 |
| retries                               | 当消息发送出现错误的时候，系统会重发消息。retries 表示重试次数。**默认是 int 最大值，2147483647**。<br />如果设置了重试，还想保证消息的有序性，需要设置 MAX_IN_FLIGHT_REQUESTS_PER_CONNECTION=1 否则在重试此失败消息的时候，其他的消息可能发送成功了。 |
| retry.backoff.ms                      | 两次重试之间的时间间隔，默认是 100ms                         |
| enable.idempotence                    | 是否开启幂等性，**默认 true**，开启幂等性                    |
| compression.type                      | 生产者发送的所有数据的压缩方式。**默认是 none**，也就是不压缩。<br />支持压缩类型：**none、gzip、snappy、lz4 和 zstd**。 |

## 2.2 生产者如何提高吞吐量

| 参数名称         | 描述                                                         |
| ---------------- | ------------------------------------------------------------ |
| buffer.memory    | RecordAccumulator 缓冲区总大小，**默认 32m**。               |
| batch.size       | 缓冲区一批数据最大值，**默认 16k**。适当增加该值，可以提高吞吐量，但是如果该值设置太大，会导致数据传输延迟增加 |
| linger.ms        | 如果数据迟迟未达到 batch.size，sender 等待 linger.time 之后就会发送数据。单位 ms，**默认值 0ms**，表示没有延迟。生产环境建议该值大小为 5 ~ 100ms 之间。 |
| compression.type | 生产者发送的所有数据的压缩方式。**默认是 none**，也就是不压缩。<br />支持压缩类型：**none、gzip、snappy、lz4 和 zstd**。 |

## 2.3 数据可靠性

详见，尚硅谷大数据技术之 Kafka 3.0.0

| 参数名称 | 描述                                                         |
| -------- | ------------------------------------------------------------ |
| acks     | 0：生产者发送过来的数据，不需要等数据落盘应答。<br />1：生产者发送过来的数据，Leader 收到数据后应答。<br />-1（all）：生产者发送过来的数据，Leader+ 和 isr 队列里面的所有节点收齐数据后应答。**默认值是 -1，-1 和 all 是等价的。** |

- 至少一次（At Least Once）= ACK 级别设置为 -1 + 分区副本大于等于 2 + ISR 里应答的最小副本数量大于等于 2

## 2.4 数据去重

详见，尚硅谷大数据技术之 Kafka 3.0.0

1. 配置参数

   | 参数名称           | 描述                                      |
   | ------------------ | ----------------------------------------- |
   | enable.idempotence | 是否开启幂等性，**默认 true**，开启幂等性 |

2. Kafka 的事务一共有如下 5 个 API

   ```java
   // 1 初始化事务
   void initTransactions();
   // 2 开启事务
   void beginTransaction() throws ProducerFencedException;
   // 3 在事务内提交已经消费的偏移量（主要用于消费者）
   void sendOffsetsToTransaction(Map<TopicPartition, OffsetAndMetadata> offsets, String consumerGroupId) throws ProducerFencedException;
   // 4 提交事务
   void commitTransaction() throws ProducerFencedException;
   // 5 放弃事务（类似于回滚事务的操作）
   void abortTransaction() throws ProducerFencedException;
   ```

## 2.5 数据有序

详见，尚硅谷大数据技术之 Kafka 3.0.0

**单分区内，有序（有条件的，不能乱序）；多分区，分区与分区间无序；**

## 2.6 数据乱序

详见，尚硅谷大数据技术之 Kafka 3.0.0

| 参数名称                              | 描述                                                         |
| ------------------------------------- | ------------------------------------------------------------ |
| enable.idempotence                    | 是否开启幂等性，**默认 true**，开启幂等性                    |
| max.in.flight.requests.per.connection | 允许最多没有返回 ack 的次数，**默认为 5**，开启幂等性要保证该值是 1 ~ 5 的数字。 |

# P78 调优_Broker 调优

第3章  Kafka Broker

## 3.1 Broker 核心参数配置

| 参数名称                                | 描述                                                         |
| --------------------------------------- | ------------------------------------------------------------ |
| replica.lag.time.max.ms                 | ISR 中，如果 Follower 长时间未向 Leader 发送通信请求或同步数据，则该 Follower 将被踢出 ISR。该时间阈值，**默认 30s**。 |
| auto.leader.rebalance.enable            | **默认是 true**。自动 Leader Partition 平衡，建议关闭。      |
| leader.imbalance.per.broker.percentage  | **默认是 10%**。每个 broker 允许的不平衡的 leader 的比率。如果每个 broker 超过了这个值，控制器会触发 leader 的平衡。 |
| leader.imbalance.check.interval.seconds | **默认值 300 秒。**检查 leader 负责是否平衡的间隔时间。      |
| log.segment.bytes                       | Kafka 中 log 日志是分成一块块存储的，此配置是指 log 日志划分成块的大小，**默认值 1G**。 |
| log.index.interval.bytes                | **默认 4kb**，kafka 里面每当写入了 4kb 大小的日志（.log），然后就往 index 文件里面记录一个索引 |
| log.retention.hours                     | Kafka 中数据保存的时间，**默认 7 天**                        |
| log.retention.minutes                   | Kafka 中数据保存的时间，**分钟级别**，默认关闭。             |
| log.retention.ms                        | Kafka 中数据保存的时间，**毫秒级别**，默认关闭。             |
| log.retention.check.interval.ms         | 检查数据是否保存超时的间隔，**默认是 5 分钟**。              |
| log.retention.bytes                     | **默认等于 -1，表示无穷大。**超过设置的所有日志总大小，删除最早的 segment |
| log.cleanup.policy                      | **默认是 delete**，表示所有数据启用删除策略；<br />如果设置值为 compact，表示所有数据启用压缩策略 |
| num.io.threads                          | **默认是 8**。负责写磁盘的线程数。整个参数值要占总核数的 50% |
| num.replica.fetchers                    | **默认是 1**。副本拉取线程数，这个参数占总核数的 50% 的 1/3  |
| num.network.threads                     | **默认是 3**。数据传输线程数，这个参数占总核数的 50% 的 2/3  |
| log.flush.interval.messages             | 强制页缓存刷写到磁盘的条数，默认是 long 的最大值，9223372036854775807。**一般不建议修改**，交给系统自己管理。 |
| log.flush.interval.ms                   | 每隔多久，刷数据到磁盘，默认是 null。**一般不建议修改**，交给系统自己管理。 |

## 3.2 服役新节点/退役旧节点

详见，尚硅谷大数据技术之 Kafka 3.0.0

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

2. 生成一个负载均衡的计划。

   ```shell
   bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --topics-to-move-json-file topics-to-move.json --broker-list "0,1,2,3" --generate
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

## 3.3 增加分区

详见，尚硅谷大数据技术之 Kafka 3.0.0

1. 修改分区数（**注意：分区数只能增加，不能减少**）

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --alter --topic first --partitions 3
   ```

## 3.4 增加副本因子

详见，尚硅谷大数据技术之 Kafka 3.0.0

1. 创建 topic

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --create --partitions 3 --replication-factor 1 --topic four
   ```

2. 手动增加副本存储

   1. 创建副本存储计划（所有副本都指定存储在 broker0、broker1、broker2 中）。

      ```shell
      vim increase-replication-factor.json
      ```

      输入如下内容：

      ```json
      {"version":1,"partitions":[{"topic":"four","partition":0,"replicas":[0,1,2]},{"topic":"four","partition":1,"replicas":[0,1,2]},{"topic":"four","partition":2,"replicas":[0,1,2]}]}
      ```

   2. 执行副本存储计划

      ```shell
      bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --execute
      ```

## 3.5 手动调整分区副本存储

详见，尚硅谷大数据技术之 Kafka 3.0.0

1. 创建副本存储计划（所有副本都执行存储在 broker0、broker1 中）

   ```shell
   vim increase-replication-factor.json
   ```

   输入如下内容：

   ```json
   {
       "version":1,
       "partitions":[{"topic":"four","partition":0,"replicas":[0,1]},{"topic":"four","partition":1,"replicas":[0,1]},{"topic":"four","partition":2,"replicas":[0,1]}]
   }
   ```

2. 执行副本存储计划

   ```shell
   bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --execute
   ```

3. 验证副本存储计划

   ```shell
   bin/kafka-reassign-partitions.sh --bootstrap-server hadoop102:9092 --reassignment-json-file increase-replication-factor.json --verify
   ```

## 3.6 Leader Partition 负载平衡

详见，尚硅谷大数据技术之 Kafka 3.0.0

| 参数名称                                | 描述                                                         |
| --------------------------------------- | ------------------------------------------------------------ |
| auto.leader.rebalance.enable            | **默认是 true**。自动 Leader Partition 平衡。生产环境中，leader 重选举的代价比较大，可能会带来性能影响，**建议设置为 false 关闭**。 |
| leader.imbalance.per.broker.percentage  | **默认是 10%**。每个 broker 允许的不平衡的 leader 的比率。如果每个 broker 超过了这个值，控制器会触发 leader 的平衡。 |
| leader.imbalance.check.interval.seconds | **默认值 300 秒。**检查 leader 负责是否平衡的间隔时间。      |

## 3.7 自动创建主题

如果 broker 端配置参数 **auto.create.topics.enable** 设置为 true（默认值是 true），那么当生产者向一个未创建的主题发送消息时，会自动创建一个分区数为 num.partitions（默认值为 1）、副本因子为 default.replication.factor（默认值为 1）的主题。除此之外，当一个消费者开始从未知主题中读取消息时，或者当任意一个客户端向未知主题发送元数据请求时，都会自动创建一个相应主题。这种创建主题的方式是非预期的，增加了主题管理和维护的难度。**生产环境建议将该参数设置为 false。**

1. 向一个没有提前创建 five 主题发送数据

   ```shell
   bin/kafka-console-producer.sh --bootstrap-server hadoop102:9092 --topic five
   ```

2. 查看 five 主题的详情

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --describe --topic five
   ```

# P79 调优_消费者调优

第4章 Kafka 消费者

## 4.1 Kafka 消费者核心参数配置

| 参数名称                             | 描述                                                         |
| ------------------------------------ | ------------------------------------------------------------ |
| bootstrap.servers                    | 向 Kafka 集群建立初始连接用到的 host/port 列表。             |
| key.deserializer 和 value.serializer | 指定接收消息的 key 和 value 的反序列化类型。一定要写全类名。 |
| group.id                             | 标记消费者所属的消费者组。                                   |
| enable.auto.commit                   | **默认值为 true**，消费者会自动周期性地向服务器提交偏移量。  |
| auto.commit.interval.ms              | 如果设置了 enable.auto.commit 的值为 true，则该值定义了消费者偏移量向 Kafka 提交的频率，**默认 5s**。 |
| auto.offset.reset                    | 当 Kafka 中没有初始偏移量或当前偏移量在服务器中不存在（如，数据被删除了），该如何处理？earliest：自动重置偏移量到最早的偏移量。**latest：默认，自动重置偏移量 为最新的偏移量。**none：如果消费者组原来的（previous）偏移量不存在，则向消费者抛异常。anything：向消费者抛异常。 |
| offsets.topic.num.partitions         | __consumer_offsets 的分区数，**默认是 50 个分区。不建议修改。** |
| heartbeat.interval.ms                | Kafka 消费者和 coordinator 之间的心跳时间，**默认 3s**。<br />该条目的值必须小于 session.timeout.ms，也不应该高于 session.timeout.ms 的 1/3。**不建议修改**。 |
| session.timeout.ms                   | Kafka 消费者和 coordinator 之间连接超时时间，**默认 45s**。超过该值，该消费者被移除，消费者组执行再平衡。 |
| max.poll.interval.ms                 | 消费者处理消息的最大时长，**默认是 5 分钟**。超过该值，该消费者被移除，消费者组执行再平衡。 |
| fetch.max.bytes                      | 默认 **Default：52428800（50m）**。**消费者**获取服务器端一批消息最大的字节数。如果服务器端一批次的数据大于该值（50m）仍然可以拉取回来这批数据，因此，这不是一个绝对最大值。一批次的大小受 message.max.bytes（broker config）or max.message.bytes（topic config）影响。 |
| max.poll.records                     | 一次 poll 拉取数据返回消息的最大条数，**默认是 500 条**。    |

## 4.2 消费者再平衡

详见，尚硅谷大数据技术之 Kafka 3.0.0

| 参数名称                      | 描述                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| heartbeat.interval.ms         | Kafka 消费者和 coordinator 之间的心跳时间，**默认 3s**。<br />该条目的值必须小于 session.timeout.ms，也不应该高于 session.timeout.ms 的 1/3。 |
| session.timeout.ms            | Kafka 消费者和 coordinator 之间连接超时时间，**默认 45s**。超过该值，该消费者被移除，消费者组执行再平衡。 |
| max.poll.interval.ms          | 消费者处理消息的最大时长，**默认是 5 分钟**。超过该值，该消费者被移除，消费者组执行再平衡。 |
| partition.assignment.strategy | 消费者分区分配策略，默认策略是 Range + CooperativeSticky。Kafka 可以同时使用多个分区分配策略。可以选择的策略包括：**Range、RoundRobin、Sticky、CooperativeSticky** |

## 4.3 指定 Offset 消费

详见，尚硅谷大数据技术之 Kafka 3.0.0

```java
kafkaConsumer.seek(topic, 1000);
```

## 4.4 指定时间消费

详见，尚硅谷大数据技术之 Kafka 3.0.0

```java
HashMap<TopicPartition, Long> timestampToSearch = new HashMap<>();
timestampToSearch.put(topicPartition, System.currentTimeMillis() - 1 * 24 * 3600 * 1000);
kafkaConsumer.offsetsForTimes(timestampToSearch);
```

## 4.5 消费者事务

详见，尚硅谷大数据技术之 Kafka 3.0.0

## 4.6 消费者如何提高吞吐量

详见，尚硅谷大数据技术之 Kafka 3.0.0

增加分区数：

```shell
bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --alter --topic first --partitions 3
```

| 参数名称         | 描述                                                         |
| ---------------- | ------------------------------------------------------------ |
| fetch.max.bytes  | 默认 **Default：52428800（50m）**。**消费者**获取服务器端一批消息最大的字节数。如果服务器端一批次的数据大于该值（50m）仍然可以拉取回来这批数据，因此，这不是一个绝对最大值。一批次的大小受 message.max.bytes（broker config）or max.message.bytes（topic config）影响。 |
| max.poll.records | 一次 poll 拉取数据返回消息的最大条数，**默认是 500 条**。    |

# P80 调优_总体调优

第5章 Kafka 总体

## 5.1 如何提升吞吐量

如何提升吞吐量？

1）提升生产吞吐量

1. buffer.memory：发送消息的缓冲区大小，默认值是 32m，可以增加到 64m。
2. batch.size：默认是 16k，如果 batch 设置太小，会导致频繁网络请求，吞吐量下降；如果 batch 太大，会导致一条消息需要等待很久才能被发送出去，增加网络延时。
3. linger.ms，这个值默认是 0，意思就是消息必须立即被发送。一般设置一个 5 ~ 100 毫秒，如果 linger.ms 设置的太小，会导致频繁网络请求，吞吐量下降；如果 linger.ms 太长，会导致一条消息需要等待很久才能被发送出去，增加网络延时。
4. compression.type: 默认是 none，不压缩，但是也可以使用 lz4 压缩，效率还是不错的。压缩之后可以减小数据量，提升吞吐量，但是会加大 producer 端的 CPU 开销。

2）增加分区

3）消费者提高吞吐量

1. 调整 fetch.max.bytes 大小，默认是 50m。
2. 调整 max.poll.records 大小，默认是 500 条。

4）增加下游消费者处理能力

## 5.2 数据精确一次

1）生产者角度

- acks 设置为  -1（acks=-1）
- 幂等性（enable.idempotence=true）+ 事务

2）broker 服务端角度

- 分区副本大于等于 2（--replication-factor 2）。
- ISR 里应答的最小副本数量大于等于 2（min.insync.replicas=2）.

3）消费者

- **事务 + 手动提交 offset**（enable.auto.commit=false）
- 消费者输出的目的地必须支持事务（MySQL、Kafka）。

## 5.3 合理设置分区数

1. 创建一个只有 1 个分区的 topic
2. 测试这个 topic 的 producer 吞吐量和 consumer 吞吐量。
3. 假设他们的值分别是 Tp 和 Tc，单位可以是 MB/s。
4. 然后假设总的目标吞吐量是 Tt，那么分区数=Tt / min(Tp, Tc)

例如：producer 吞吐量 = 20m/s；consumer 吞吐量 = 50m/s，期望吞吐量 100m/s

分区数 = 100 / 20 = 5 分区

分区数一般设置为：3-10个

分区数不是越多越好，也不是越少越好，需要搭建完集群，进行压测，再灵活调整分区个数。

## 5.4 单条日志大于 1m

| 参数名称                | 描述                                                         |
| ----------------------- | ------------------------------------------------------------ |
| message.max.bytes       | 默认 1m，broker 端接收每个批次消息最大值                     |
| max.request.size        | 默认 1m，生产者发往 broker 每个请求消息最大，针对 topic 级别设置消息体的大小。 |
| replica.fetch.max.bytes | 默认 1m，副本同步数据，每个批次消息最大值                    |
| fetch.max.bytes         | 默认 **Default：52428800（50m）**。**消费者**获取服务器端一批消息最大的字节数。如果服务器端一批次的数据大于该值（50m）仍然可以拉取回来这批数据，因此，这不是一个绝对最大值。一批次的大小受 message.max.bytes（broker config）or max.message.bytes（topic config）影响。 |

## 5.5 服务器挂了

在生产环境中，如果某个 Kafka 节点挂掉。

正常处理方法：

1. 先尝试重新启动一下，如果能启动正常，那直接解决了
2. 如果重启不行，考虑增加内存、增加 CPU、网络带宽
3. 如果将 Kafka 整个节点误删除，如果副本数大于等于 2，可以按照服役新节点的方式重新服役一个新节点，并执行负载均衡。

# P81 调优_生产者压力测试

## 5.6 集群压力测试

1）Kafka 压测

用 Kafka 官方自带的脚本，对 Kafka 进行压测。

- 生产者压测：kafka-producer-perf-test.sh
- 消费者压测：kafka-consumer-perf-test.sh

2）Kafka Producer 压力测试

1. 创建一个 test topic，设置为 3 个分区 3 个副本

   ```shell
   bin/kafka-topics.sh --bootstrap-server hadoop102:9092 --create --replication-factor 3 --partitions 3 --topic test
   ```

2. 在 /opt/module/kafka/bin 目录下面有这两个文件。我们来测试一下

   ```shell
   bin/kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=hadoop102:9092,hadoop103:9092,hadoop104:9092 batch.size=16384 linger.ms=0
   ```

   参数说明：

   - record-size 是一条信息有多大，单位是字节，本次测试设置为 1k
   - num-records 是总共发送多少条消息，本次测试设置为 100 万条
   - throughput 是每秒多少条信息，设成 -1，表示不限流，尽可能快的生产数据，可测出生产者最大吞吐量。本次实验设置为每秒钟 1 万条。
   - producer-props 后面可以配置生产者相关参数，batch.size 配置为 16k。

   结果：9.76 MB/sec

3. 调整 batch.size 大小

   1. batch.size 默认值是 16k，本次实验 batch.size 设置为 32k

      ```shell
      bin/kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=hadoop102:9092,hadoop103:9092,hadoop104:9092 batch.size=32768 linger.ms=0
      ```

      结果：9.76 MB/sec

   2. batch.size 默认值是 16k，本次实验 batch.size 设置为 4k

      ```shell
      bin/kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=hadoop102:9092,hadoop103:9092,hadoop104:9092 batch.size=4096 linger.ms=0
      ```

      结果：3.81 MB/sec

4. 调整 linger.ms 时间

   linger.ms 默认是 0ms，本次实验 linger.ms 设置为 50ms

   ```shell
   bin/kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=hadoop102:9092,hadoop103:9092,hadoop104:9092 batch.size=4096 linger.ms=50
   ```

   结果：3.83 MB/sec

5. 调整压缩方式

   1. 默认的压缩方式是 none，本次实验 compression.type 设置为 snappy。

      ```shell
      bin/kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=hadoop102:9092,hadoop103:9092,hadoop104:9092 batch.size=4096 linger.ms=50 compression.type=snappy
      ```

      结果：3.77 MB/sec

   2. 默认的压缩方式是 none，本次实验 compression.type 设置为 zstd。

      ```shell
      bin/kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=hadoop102:9092,hadoop103:9092,hadoop104:9092 batch.size=4096 linger.ms=50 compression.type=zstd
      ```

      结果：5.68 MB/sec

   3. 默认的压缩方式是 none，本次实验 compression.type 设置为 gzip。

      ```shell
      bin/kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=hadoop102:9092,hadoop103:9092,hadoop104:9092 batch.size=4096 linger.ms=50 compression.type=gzip
      ```

      结果：5.90 MB/sec

   4. 默认的压缩方式是 none，本次实验 compression.type 设置为 lz4。

      ```shell
      bin/kafka-producer-perf-test.sh --topic test --record-size 1024 --num-records 1000000 --throughput 10000 --producer-props bootstrap.servers=hadoop102:9092,hadoop103:9092,hadoop104:9092 batch.size=4096 linger.ms=50 compression.type=lz4
      ```

      结果：3.72 MB/sec

# P82 调优_消费者压力测试

3）Kafka Consumer 压力测试

1. 修改 /opt/module/kafka/config/consumer.properties 文件中的一次拉取条数为 500

   ```properties
   max.poll.records=500
   ```

2. 消费 100 万条日志进行压测

   ```shell
   bin/kafka-consumer-perf-test.sh --bootstrap-server hadoop102:9092,hadoop103:9092,hadoop104:9092 --topic test --messages 1000000 --consumer.config config/consumer.properties
   ```

   参数说明：

   - --bootstrap-server 指定 Kafka 集群地址
   - --topic 指定 topic 的名称
   - --message 总共要消费的消息个数。本次实验 100 万条。

   输出结果：81.2066m/s

3. 一次拉取条数为 2000

   1. 修改 /opt/module/kafka/config/consumer.properties 文件中的一次拉取条数为 500

      ```properties
      max.poll.records=500
      ```

   2. 再次执行

      ```shell
      bin/kafka-consumer-perf-test.sh --bootstrap-server hadoop102:9092,hadoop103:9092,hadoop104:9092 --topic test --messages 1000000 --consumer.config config/consumer.properties
      ```

      输出结果：138.0992m/s

4. 调整 fetch.max.bytes 大小为 100m

   1. 修改 /opt/module/kafka/config/consumer.properties 文件中的拉取一批数据大小为 100m

      ```properties
      fetch.max.bytes=104857600
      ```

   2. 再次执行

      ```shell
      bin/kafka-consumer-perf-test.sh --bootstrap-server hadoop102:9092,hadoop103:9092,hadoop104:9092 --topic test --messages 1000000 --consumer.config config/consumer.properties
      ```

      输出结果：145.2033m/s

# P83 源码_环境准备

第1章 源码环境准备

## 1.1 源码下载地址

## 1.2 安装 JDK & Scala

需要在 Windows 本地安装 JDK 8 或者 JDK 8 以上版本

需要在 Windows 本地安装 Scala 2.12

## 1.3 加载源码

将 kafka-3.0.0-src.tgz 源码包，解压到非中文目录。

打开 IDEA，点击 File->Open...->源码包解压的位置

## 1.4 安装 gradle

Gradle 是类似于 maven 的代码管理工具。安卓程序管理通常采用 Gradle。

IDEA 自动帮你下载安装，下载的时间比较长。

# P84 源码_生产者原理回顾

第2章 生产者源码

# P85 源码_生产者初始化

## 2.1 初始化

生产者 main 线程初始化

- 用户自定义生产者
  CustomProducer.java
- main
- 创建 Kafka 生产者对象
  new KafkaProducer
- 连续点击三次 this 构造器
- 获取事务 id
  transactionalId
- 获取客户端 id
  clientId
- 监控相关配置
  new JmxReporter()
- 分区器配置
  this.partitioner
- 序列化配置
  keySerializer
  valueSerializer
- 拦截器配置
  interceptorList
- 单条信息的最大值，默认 1m
  maxRequestSize
- 缓存大小，默认32m
  totalMemorySize
- 创建缓存队列
  new RecordAccumulator()
  - 批次大下，默认 16k
    BATCH_SIZE_CONFIG
  - 是否压缩，默认 none
    compressionType
  - linger.ms，默认值 0
    lingerMs()
  - 重试间隔时间，默认值 100ms
    retryBackoffMs
- 连接 Kafka 集群
  BOOTSTRAP_SERVERS_CONFIG
- 从 Kafka 集群获取元数据
  this.metadata
- 创建 sender 线程
  newSender
- 启动发送线程
  this.ioThread.start()

生产者 sender 线程初始化

1. 初始化 sender 线程
   this.sender = newSender()
   - 创建网络请求客户端
     new NetworkClient()
     - 缓存的发送请求，默认值是 5
       maxInflightRequests
     - 请求超时时间，默认是 30s
       requestTimeoutMs
     - socket 发送数据的缓冲区大小，默认值 128k
       send.buffer.bytes
     - socket 接收数据的缓冲区大小，默认值 32k
       receive.buffer.bytes
   - 配置应答级别（0, 1, -1）
     configureAcks()
   - 创建 sender
     new Sender()
     - 生产者发往 Kafka 集群单条信息的最大值，默认值 1m。
       max.request.size
     - 重试次数，默认值 Int 的最大值
       retries
2. 启动 sender 线程
   this.ioThread = new KafkaThread(ioThreadName, **this.sender**, true);
   this.ioThread**.start()**;

sender 线程从缓冲区准备拉取数据，刚启动拉不到数据

# P86 源码_生产者发送数据到缓存

# P87 源码_生产者 Sender 线程

# P88 源码_消费者原理回顾

# P89 源码_消费者初始化

## 3.1 初始化

消费者初始化

- 用户自定义消费者
  CustomConsumer.java
- main
- 创建 Kafka 消费者对象
  new KafkaConsumer
- 连续点击三次 this 构造器
- 获取消费者组
  this.groupId
- 获取客户端 id
  this.clientId
- 拦截器配置
  interceptorList
- key 和 value 反序列化
  keyDeserializer/valueDeserializer
- offset 从什么位置开始消费
  offsetResetStrategy
- 获取元数据
  this.metadata
- 连接 Kafka 集群
  BOOTSTRAP_SERVERS_CONFIG
- 心跳时间，默认 3s
  heartbeatIntervalMs
- 创建网络客户端
  new NetworkClient()
- 创建一个消费者客户端
  new ConsumerNetworkClient()
- 获取消费者分区分配策略
  this.assignors
- 创建消费者协调器
  new ConsumerCoordinator()
- 抓取数据配置
  new Fetcher<>()

# P90 源码_消费者订阅主题

# P91 源码_消费总体流程

# P92 源码_消费者组初始化流程

# P93 源码_消费者组拉取和处理数据

# P94 源码_消费者 Offset 提交

## 3.4 消费者 Offset 提交

# P95 源码_服务器端源码

第4章 服务器源码

# P96 课程结束
