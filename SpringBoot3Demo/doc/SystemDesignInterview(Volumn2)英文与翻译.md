# 前言

# 4 分布式消息队列

在本章中，我们探讨了系统设计访谈中的一个热门问题：设计一个分布式消息队列。在现代架构中，系统被分解为小型独立的构建块，它们之间有定义明确的接口。消息队列为这些构建块提供通信。消息队列带来了什么好处？

- 解耦。消息队列消除了组件之间的紧密耦合，因此它们可以独立更新。
- 改进了可扩展性。我们可以根据流量负载独立扩展生产商和消费者。例如，在高峰时段，可以增加更多的消费者来处理增加的流量。
- 提高了可用性。如果系统的一部分脱机，其他组件可以继续与队列交互。
- 更好的性能。消息队列使异步通信变得容易。生产者可以在不等待响应的情况下将消息添加到队列中，消费者可以在消息可用时使用消息。他们不需要互相等待。

图 4.1 显示了市场上一些最流行的分布式消息队列。

### 消息队列与事件流平台

严格地说，Apache Kafka 和 Pulsa 不是消息队列，因为它们是事件流平台。然而，功能的融合开始模糊消息队列（RocketMQ、ActiveMQ、RabbitMQ、ZeroMQ 等）和事件流平台（Kafka、Pulsa）之间的区别。例如，RabbitMQ 是一个典型的消息队列，它添加了一个可选的流功能，以允许重复的消息消耗和长消息保留，并且它的实现使用了一个仅附加日志，很像事件流平台。Apache Pulsar 主要是 Kafka 的竞争对手，但它也足够灵活和高性能，可以用作典型的分布式消息队列。
在本章中，我们将设计一个具有**附加功能的分布式消息队列，如长数据保留、消息重复消耗等**，这些功能通常仅在事件流平台上可用。如果面试的重点围绕更传统的分布式消息队列，这些额外的功能可以简化设计。

## 第 1 步 - 了解问题并确定设计范围

简言之，消息队列的基本功能很简单：向队列生成发送消息，消费者从中消费消息。除此基本功能外，还有其他考虑因素，包括性能、消息传递语义、数据保留等。以下一组问题将有助于澄清需求并缩小范围。

**候选人**：邮件的格式和平均大小是多少？它只是文本吗？允许使用多媒体吗？
**面试官**：只发短信。消息通常以千字节（KB）为单位进行测量。
**候选人**：信息可以重复消费吗？
**采访者**：是的，信息可以被不同的消费者重复消费。请注意，这是添加的功能。一旦消息成功传递给使用者，传统的分布式消息队列就不会保留消息。因此，消息不能在传统的消息队列中重复使用。
**候选人**：消息的使用顺序是否与产生的顺序相同？
**采访者**：是的，信息的使用顺序应该与它们产生的顺序相同。请注意，这是添加的功能。传统的分布式消息队列通常不能保证交货订单。
**候选人**：数据是否需要持久化？数据保留是什么？
**采访者**：是的，假设数据保留期为两周。这是一个附加功能。传统的分布式消息队列不保留消息。
**候选人**：我们将支持多少生产商和消费者？
**采访者**：越多越好。
**候选人**：我们需要支持什么样的数据传递语义？例如，最多一次，至少一次，以及恰好一次。
**采访者**：我们肯定要支持至少一个。理想情况下，我们应该支持所有这些，并使它们可配置。
**候选人**：目标吞吐量和端到端延迟是多少？
**采访者**：它应该支持像日志聚合这样的用例的高吞吐量。对于更传统的消息队列用例，它还应该支持低延迟交付。

通过以上对话，让我们假设我们有以下功能需求：

- 生产者将消息发送到消息队列。
- 消费者使用消息队列中的消息。
- 消息可以重复使用，也可以只使用一次。
- 历史数据可以被截断。
- 邮件大小在千字节范围内。
- 能够按照将消息添加到队列的顺序向消费者传递消息。
- 数据传递语义（至少一次、最多一次或恰好一次）可以由用户配置。

### 非功能性要求

- 高吞吐量或低延迟，可根据使用情况进行配置。
- 可扩展。这个系统应该是分布式的。它应该能够支持消息量的突然激增。
- 持久耐用。数据应持久化在磁盘上，并跨多个节点进行复制。

### 对传统消息队列的调整

像 RabbitMQ 这样的传统消息队列不像事件流平台那样具有强大的保留要求。传统的队列将消息保留在内存中的时间刚好够它们被消耗掉。它们提供了磁盘上的溢出容量[1]，比事件流平台所需的容量小几个数量级。传统的消息队列通常不维护消息顺序。消息的使用顺序可以与它们的生成顺序不同。这些差异极大地简化了设计，我们将在适当的时候进行讨论。

## 第 2 步 - 提出高级设计并获得认可

首先，让我们讨论消息队列的基本功能。

图 4.2 显示了消息队列的关键组件以及这些组件之间的简化交互。

- 生产者将消息发送到消息队列。
- 使用者订阅队列并使用订阅的消息。
- 消息队列是中间的一个服务，它将生产者与消费者分离开来，使每个生产者都能够独立操作和扩展。
- 生产者和消费者都是客户端/服务器模型中的客户端，而消息队列是服务器。客户端和服务器通过网络进行通信。

### 消息传递模型

最流行的消息传递模型是点对点和发布-订阅。

#### 点对点

这种模型通常出现在传统的消息队列中。在点对点模型中，消息被发送到队列，并由一个且只有一个使用者使用。队列中可能有多个消费者在等待消费消息，但每个消息只能由一个消费者消费。在图 4.3 中，消息 A 仅由使用者 1 使用。

一旦使用者确认消息已被消费，就会将其从队列中删除。点对点模型中没有数据保留。相比之下，我们的设计包括一个持久层，它可以将消息保存两周，从而允许重复使用消息。

虽然我们的设计可以模拟点对点模型，但它的功能更自然地映射到发布-订阅模型。

#### 发布-订阅

首先，让我们介绍一个新的概念，主题。主题是用于组织邮件的类别。每个主题都有一个在整个消息队列服务中唯一的名称。消息发送到特定主题并从中读取。

在发布子主题模型中，一条消息被发送到某个主题，并由订阅该主题的消费者接收。如图 4.4 所示，消息 A 由使用者 1 和使用者 2 消耗。

我们的分布式消息队列支持这两种模型。发布-订阅模型由**主题**实现，点对点模型可以由**消费者群体**的概念模拟，消费者群体**将在消费者群体部分介绍。**

### 主题、分区和代理

如前所述，消息是按主题持久化的。如果一个主题中的数据量太大，单个服务器无法处理该怎么办？

解决这个问题的一种方法叫做**分区（sharding）**。如图 4.5 所示，我们将主题划分为多个分区，并在分区之间均匀地传递消息。将分区视为主题的消息的一个子集。分区均匀分布在消息队列集群中的服务器上。这些拥有分区的服务器被称为**代理**。在代理之间分配分区是支持高可伸缩性的关键因素。我们可以通过扩展分区的数量来扩展主题容量。

每个主题分区以 FIFO（先进先出）机制的队列形式运行。这意味着我们可以保持分区内消息的顺序。消息在分区中的位置称为**偏移量**。

当生产者发送消息时，它实际上被发送到主题的一个分区。每个消息都有一个可选的消息密钥（例如，用户的 ID），并且同一消息密钥的所有消息都发送到同一分区。如果没有消息密钥，则消息将随机发送到其中一个分区。

当使用者订阅某个主题时，它会从其中一个或多个分区中提取数据。当有多个使用者订阅一个主题时，每个使用者都负责该主题的分区子集。消费者组成一个主题的**消费者组**。

带有代理和分区的消息队列集群如图 4.6 所示。

### 消费者群体

如前所述，我们需要同时支持点对点和订阅发布模型**使用者组**是一组使用者，共同使用主题中的消息。

消费者可以分组。每个消费者组可以订阅多个主题，并维护自己的消费补偿。例如，我们可以按用例对消费者进行分组，一组用于计费，另一组用于记帐。

同一组中的实例可以并行消耗流量，如图 4.7 所示。

- 消费者群体 1 订阅主题 A。
- 消费者群体 2 订阅了主题 A 和 B。
- 主题 A 由使用者组-1 和组-2 订阅，这意味着同一条消息由多个使用者使用。此模式支持订阅/发布模型。

然而，有一个问题。并行读取数据提高了吞吐量，但无法保证同一分区中消息的使用顺序。例如，如果 Consumer-1 和 Consumer-2 都从分区-1 中读取，我们将无法保证分区-1 中的消息消费顺序。

好消息是，我们可以通过添加一个约束来解决这个问题，即一个分区只能由同一组中的一个用户使用。如果一个组的使用者数量大于一个主题的分区数量，则某些使用者将无法从该主题获取数据。例如，在图 4.7 中，Consumer 组 2 中的 Consumer-3 无法消费来自主题 B 的消息，因为它已经被同一个 Consumer 分组中的 Consumer-4 消费了。

有了这个约束，如果我们将所有消费者放在同一消费者组中，那么同一分区中的消息只由一个消费者消费，这相当于点对点模型。由于分区是最小的存储单元，我们可以提前分配足够的分区，以避免需要动态增加分区数量。为了处理高规模，我们只需要增加消费者。

### 高级架构

图 4.8 显示了更新后的高级设计。

客户

- 生产者：将消息推送到特定主题。
- 消费者组：订阅主题并消费消息。

核心服务和存储

- Broker：拥有多个分区。分区包含一个主题的消息子集。
- 存储：
  - 数据存储：消息持久化在分区中的数据存储中。
  - 状态存储：使用者状态由状态存储管理。
  - 元数据存储：主题的配置和属性持久化在元数据存储中。
- 协调服务：
  - 服务发现：哪些代理还活着。
  - 领导人选举：选择其中一个 broker 作为主动控制人。群集中只有一个活动控制器。活动控制器负责分配分区。
  - Apache ZooKeeper [2] 或 etcd [3] 通常用于选择控制器。

## 第 3 步 - 深入设计

为了在满足高数据保留要求的同时实现高吞吐量，我们做出了三个重要的设计选择，现在我们将对此进行详细解释。

- 我们选择了一种磁盘上数据结构，该结构利用了旋转磁盘的出色顺序访问性能和现代操作系统的激进磁盘缓存策略。
- 我们设计了消息数据结构，允许消息从生产者传递到队列，最后传递到消费者，而无需修改。这最大限度地减少了复制的需要，而复制在高容量和高流量系统中是非常昂贵的。
- 我们设计了有利于分批的系统。小 I/O 是高吞吐量的敌人。因此，在任何可能的情况下，我们的设计都鼓励分批。生产者分批发送消息。消息队列以更大的批处理方式保存消息。消费者在可能的情况下也会批量获取消息。

### 数据存储

现在，让我们更详细地探讨持久化消息的选项。为了找到最佳选择，让我们考虑消息队列的流量模式。

- 重度写，重度读。
- 没有更新或删除操作。顺便说一句，传统的消息队列不会持久保存消息，除非队列落后，在这种情况下，当队列赶上时会有“删除”操作。我们在这里谈论的是数据流平台的持久性。
- 主要是顺序读/写访问。

选项1：数据库

第一种选择是使用数据库。

- 关系数据库：创建一个主题表，并将消息作为行写入该表。
- NoSQL 数据库：创建一个集合作为主题，并将消息作为文档编写。

数据库可以处理存储需求，但并不理想，因为很难设计出一个同时支持大量写入和大量读取访问模式的数据库。数据库解决方案不太适合我们的特定数据使用模式。
这意味着数据库不是最佳选择，可能会成为系统的瓶颈。

选项2：预写日志（WAL）

第二个选项是预写日志（WAL）。WAL 只是一个普通文件，其中新条目被附加到仅附加日志中。WAL 被用于许多系统中，例如 MySQL [4] 中的重做日志和 ZooKeeper 中的 WAL。

我们建议将消息作为 WAL 日志文件保存在磁盘上。WAL 具有纯顺序读/写访问模式。顺序访问的磁盘性能非常好[5]。此外，旋转磁盘具有大容量，而且价格实惠。

如图 4.9 所示，一条新消息被附加到分区的尾部，偏移量单调增加。最简单的选择是使用日志文件的行号作为偏移量。但是，文件不能无限增长，因此最好将其划分为多个段。

对于分段，新消息仅附加到活动分段文件中。当活动分段达到一定大小时，将创建一个新的活动分段来接收新消息，并且当前活动分段与其他非活动分段一样变为非活动分段。非活动段仅提供读取请求。如果旧的非活动段文件超过保留期或容量限制，则可能会被截断。

同一分区的分段文件被组织在名为 `partition-{:patition_id}` 的文件夹中。结构如图 4.10 所示。

### 关于磁盘性能的说明

为了满足高数据保留要求，我们的设计在很大程度上依赖于磁盘驱动器来保存大量数据。有一种常见的误解是旋转磁盘速度慢，但这实际上只是随机访问的情况。对于我们的工作负载，只要我们设计磁盘上的数据结构以利用顺序访问模式，RAID 配置中的现代磁盘驱动器（即，将磁盘条带在一起以获得更高的性能）就可以轻松地实现几百 MB/秒的读写速度。这足以满足我们的需求，而且成本结构是有利的。

此外，现代操作系统非常积极地将磁盘数据缓存在主内存中，以至于它很乐意使用所有可用的空闲内存来缓存磁盘数据。WAL 也利用了繁重的操作系统磁盘缓存，正如我们上面所描述的。

### 消息数据结构

消息的数据结构是高吞吐量的关键。它定义了生产者、消息队列和消费者之间的契约。我们的设计通过在消息从生产者传输到队列并最终传输到消费者的过程中消除不必要的数据复制来实现高性能。如果系统的任何部分对此合同存在分歧，则需要对消息进行变异，这涉及到昂贵的复制。这可能会严重损害系统的性能。

以下是消息数据结构的示例模式：

| 字段名    | 数据类型 |
| --------- | -------- |
| key       | byte[]   |
| value     | byte[]   |
| topic     | string   |
| partition | integer  |
| offset    | long     |
| timestamp | long     |
| size      | integer  |
| crc       | integer  |

### 消息密钥

消息的密钥用于确定消息的分区。如果未定义密钥，则会随机选择分区。否则，分区由 `hash(key) % numPartitions` 选择。如果我们需要更多的灵活性，生产者可以定义自己的映射算法来选择分区。请注意，该键并不等同于分区号。

键可以是字符串或数字。它通常携带一些商业信息。分区号是消息队列中的一个概念，不应向客户端显式公开。

使用适当的映射算法，如果分区数量发生变化，消息仍然可以均匀地发送到所有分区。

### 消息值

消息值是消息的有效负载。它可以是纯文本，也可以是压缩的二进制块。

> 提醒
>
> 消息的密钥和值不同于密钥-值（KV）存储中的密钥-值对。在 KV 存储中，密钥是唯一的，我们可以通过密钥找到值。在消息中，密钥不需要是唯一的。有时它们甚至不是强制性的，我们不需要按键查找值。

### 消息的其他字段

- 主题：邮件所属主题的名称。
- 分区：消息所属的分区的 ID。
- 偏移量：消息在分区中的位置。我们可以通过三个字段的组合找到消息：主题、分区、偏移量。
- 时间戳：存储此消息的时间戳。
- 大小：此邮件的大小。
- CRC：循环冗余校验（CRC）用于确保原始数据的完整性。

为了支持其他功能，可以根据需要添加一些可选字段。例如，如果标记是可选字段的一部分，则可以通过标记过滤消息。

### 批处理

批处理在这种设计中很普遍。我们在生产者、消费者和消息队列本身中对消息进行批处理。批处理对系统的性能至关重要。在本节中，我们主要关注消息队列中的批处理。我们稍后将更详细地讨论生产商和消费者的批处理。

批处理对于提高性能至关重要，因为：

- 它允许操作系统在单个网络请求中将消息分组在一起，并分摊昂贵的网络往返成本。
- 代理以大块的形式将消息写入附加日志，这将导致操作系统维护的更大的顺序写入块和更大的连续磁盘缓存块。两者都可以带来更大的顺序磁盘访问吞吐量。

吞吐量和延迟之间存在折衷。如果将系统部署为延迟可能更重要的传统消息队列，则可以将系统调整为使用较小的批处理大小。在这种使用情况下，磁盘性能会受到一些影响。如果针对吞吐量进行了调整，则每个主题可能需要更高数量的分区，以弥补较慢的顺序磁盘写入吞吐量。

到目前为止，我们已经介绍了主磁盘存储子系统及其相关的磁盘上数据结构。现在，让我们切换一下，讨论生产者和消费者的流量。然后，我们将返回并完成对消息队列其余部分的深入研究。

### 生产者流量

如果生产者想向分区发送消息，那么它应该连接到哪个代理？第一种选择是引入路由层。所有发送到路由层的消息都被路由到“正确”的代理。如果复制了代理，则“正确”的代理是前导复制副本。我们稍后将介绍复制。

如图 4.11 所示，生产者试图向 Topic-A 的分区-1 发送消息。

1. 生产者向路由层发送消息。
2. 路由层从元数据存储器中读取副本分发计划，并将其缓存在本地。当消息到达时，它将消息路由到存储在 Broker-1 中的 Partition-1 的前导副本。
3. 引导者副本接收消息，并且跟随者副本从引导者提取数据。
4. 当“足够多”的副本已经同步了消息时，leader 提交数据（持久化在磁盘上），这意味着数据可以被消耗。然后它对制作人做出回应。

你可能想知道为什么我们需要领导者和追随者的复制品。原因在于容错。我们在第 113 页的“同步副本”部分深入探讨了这一过程。

这种方法有效，但也有一些缺点：

- 新的路由层意味着由开销和额外的网络跳数引起的额外的网络延迟。
- 请求批处理是提高效率的主要驱动因素之一。这个设计没有考虑到这一点。

图 4.12 显示了改进后的设计。

路由层被封装到生产者中，并且缓冲器组件被添加到生产者中。两者都可以作为生产者客户端库的一部分安装在生产者中。这一变化带来了几个好处：

- 更少的网络跃点意味着更低的延迟：
- 生产者可以有自己的逻辑来确定消息应该发送到哪个分区。
- 批处理缓冲内存中的消息，并在单个请求中发送更大的批。这增加了吞吐量。

批量大小的选择是吞吐量和延迟之间的经典折衷（图 4.13）。对于大批量，吞吐量会增加，但延迟会更高，这是因为累积批量的等待时间更长。对于小批量，请求发送得更快，因此延迟更低，但吞吐量会受到影响。生产者可以根据用例调整批量大小。

### 消费者流量

使用者指定其在分区中的偏移量，并接收从该位置开始的一堆事件。示例如图 4.14 所示。

### 推 vs 拉

需要回答的一个重要问题是，经纪人是否应该向消费者推送数据，或者消费者是否应该从经纪人那里获取数据。

#### 推模型

优点：

- 低延迟。代理可以在收到消息后立即将消息推送给消费者。

缺点：

- 如果消费率低于生产率，消费者可能会不堪重负。
- 很难与具有不同处理能力的消费者打交道，因为经纪人控制着数据传输的速率。

#### 拉模型

优点：

- 消费者控制着消费率。我们可以让一组使用者实时处理消息，另一组使用者以批处理模式处理消息。
- 如果消费率低于生产率，我们可以扩大消费者规模，或者在可能的时候赶上。
- 拉式模型更适合批量处理。在推送模型中，代理不知道消费者是否能够立即处理消息。如果代理发送一条消息，那么最终将在缓冲区中等待。拉取模型在日志中消费者的当前位置之后（或直到可配置的最大大小）拉取所有可用消息。它适用于激进的数据批处理。

缺点：

- 当代理中没有消息时，消费者可能仍会继续提取数据，从而浪费资源。为了克服这个问题，许多消息队列支持长轮询模式，这允许拉取等待指定的时间来等待新消息[6]。

基于这些考虑，大多数消息队列都选择了拉模型。

图 4.15 显示了消费者拉动模型的工作流程。

1. 最初，组中只有消费者 A。它消耗所有分区，并与协调器一起保持心跳。
2. 消费者 B 发送加入群组的请求。
3. 协调器知道是时候重新平衡了，所以它以被动的方式通知组中的所有消费者。当协调器接收到消费者 A 的心跳时，它要求消费者 A 重新加入该组。
4. 一旦所有消费者都重新加入了该组，协调员就选择其中一个作为领导者，并将选举结果通知所有消费者。
5. 引导使用者生成分区调度计划并将其发送给协调器。追随者消费者向协调人询问分区调度计划。
6. 消费者开始消费来自新分配的分区的消息。

图 4.19 显示了现有消费者 A 离开该组时的流程。

1. 消费者 A 和消费者 B 属于同一消费者群体。
2. 消费者 A 需要关闭，所以它请求离开群。
3. 协调员知道是时候重新平衡了。当协调器接收到消费者 B 的心跳时，它要求消费者 B 重新加入该组。
4. 其余步骤与图 4.18 所示步骤相同。

图 4.20 显示了现有消费者 A 崩溃时的流程。

1. 消费者 A 和 B 与协调人保持心跳。
2. 消费者 A 崩溃，因此没有从消费者 A 发送到协调器的心跳。由于协调器在指定的时间内没有从消费者 A 获得任何心跳信号，因此它将消费者标记为死亡。
3. 协调人触发再平衡过程。
4. 以下步骤与前面场景中的步骤相同。

既然我们已经完成了生产者流和消费者流的迂回，那么让我们再来深入研究消息队列代理的其余部分。

### 状态存储

在消息队列代理中，状态存储器存储：

- 分区和使用者之间的映射。
- 每个分区的使用者组的上次使用偏移量。如图 4.21 所示，消费者组-1 的最后消费偏移量为 6，消费者组-2 的偏移量为 13。

例如，如图 4.21 所示，第 1 组中的使用者按顺序使用来自分区的消息，并从状态存储中提交所使用的偏移量。

消费者状态的数据访问模式包括：

- 读写操作频繁，但音量不高。
- 数据更新频繁，很少被删除。
- 随机读取和写入操作。
- 数据一致性很重要。

许多存储解决方案可用于存储消费者状态数据。考虑到数据一致性和快速读写要求，像 ZooKeeper 这样的 KV 存储是一个不错的选择。Kafka 已将偏移存储从 ZooKeeper 转移到 Kafka 代理。感兴趣的读者可以阅读参考资料 [8] 了解更多信息。

### 元数据存储

元数据存储存储主题的配置和属性，包括多个分区、保留期和副本的分发。

元数据变化不频繁，数据量也很小，但对一致性要求很高。ZooKeeper 是存储元数据的好选择。

### 动物园管理员

通过阅读前面的部分，您可能已经意识到 ZooKeeper 对于设计分布式消息队列非常有用。如果你不熟悉它，ZooKeeper 是分布式系统的一项重要服务，它提供了分层的键值存储。它通常用于提供分布式配置服务、同步服务和命名注册表 [2]。

ZooKeeper 用于简化我们的设计，如图 4.22 所示。

让我们简单回顾一下变化。

- 元数据和状态存储被移到 ZooKeeper。
- 代理现在只需要维护消息的数据存储。
- ZooKeeper 帮助经纪人集群的领导者选举。

### 复制

在分布式系统中，硬件问题很常见，不容忽视。当磁盘损坏或永久故障时，数据会丢失。复制是实现高可用性的经典解决方案。

如图 4.23 所示，每个分区有 3 个副本，分布在不同的代理节点上。

对于每个分区，高亮显示的副本是前导，其他副本是跟随。生产者只向前导复制品发送消息。追随者复制品不断从领导者那里获取新信息。一旦消息被同步到足够多的副本，领导者就会向生产者返回一个确认。我们将在第 113 页的“同步副本”部分详细介绍如何定义“足够”。

每个分区的副本分发称为副本分发计划。例如，图 4.23 中的副本分发计划可以描述为：

- Topic-A 的分区-1：3 个副本，Broker-1 中的领导者，Broker-2 和 3 中的追随者。
- Topic-A 的分区-2：3 个副本，Broker-2 中的领导者，Broker-3 和 4 中的追随者。
- Topic-B 的分区-1：3 个副本，Broker-3 中的领导者，Broker-4 和 1 中的追随者。

谁制定复制副本分发计划？它的工作原理如下：在协调服务的帮助下，其中一个代理节点被选为领导者。它生成复制副本分发计划，并将该计划持久保存在元数据存储中。所有的经纪人现在都可以按照计划工作了。

如果您有兴趣了解有关复制的更多信息，请参阅“设计数据密集型应用程序”一书的“第 5 章复制”[9]。

### 同步复制副本

我们提到，消息被持久化在多个分区中，以避免单节点故障，并且每个分区都有多个副本。消息仅写入引导者，跟随者同步来自引导者的数据。我们需要解决的一个问题是保持它们的同步。

同步复制副本（ISR）是指与领导者“同步”的复制副本。“同步”的定义取决于主题配置。例如，如果 replica.lag.max.messages 的值为 4，则意味着只要跟随者落后于引导者不超过 3 条消息，它就不会从 ISR 中删除 [10]。默认情况下，领导者是 ISR。

让我们使用如图 4.24 所示的示例来展示 ISR 是如何工作的。

- 前导副本中已提交的偏移量为 13。有两条新的信息被写给了这位领导人，但尚未承诺。提交偏移量意味着在此偏移量之前和在此偏移量处的所有消息都已同步到 ISR 中的所有副本。
- 复制-2 和复制-3 已经完全赶上了领导者，所以他们在 ISR 中，可以获取新消息。
- 副本-4 没有在配置的滞后时间内完全赶上领先者，因此它不在 ISR 中。当它再次赶上时，可以将其添加到 ISR 中。

为什么我们需要 ISR？原因是 ISR 反映了性能和耐久性之间的权衡。如果生产商不想丢失任何消息，最安全的方法是在发送确认之前确保所有副本都已同步。但是一个缓慢的复制副本会导致整个分区变得缓慢或不可用。

既然我们已经讨论了 ISR，那么让我们来看看确认设置。生产者可以选择接收确认，直到 k 个 ISR 接收到消息为止，其中 k 是可配置的。

### ACK=all

图 4.25 说明了 ACK=all 的情况。在 ACK=all 的情况下，当所有 ISR 都收到消息时，生产者会得到一个 ACK。这意味着发送消息需要更长的时间，因为我们需要等待最慢的 ISR，但它提供了最强的消息持久性。

### ACK=1

在 ACK＝1 的情况下，一旦引导者保持消息，生产者就接收 ACK。延迟通过不等待数据同步而得到改善。如果前导在消息被确认后但在跟随节点复制之前立即失败，则消息将丢失。此设置适用于可接受偶尔数据丢失的低延迟系统。

### ACK=0

生产者不断向领导者发送消息，而不等待任何确认，并且从不重试。这种方法以潜在的消息丢失为代价提供了最低的延迟。此设置可能适用于收集度量或记录数据等用例，因为数据量很大，偶尔的数据丢失是可以接受的。

可配置 ACK 使我们能够用耐用性换取性能。

现在让我们看看消费者方面。最简单的设置是让使用者连接到领导者复制副本以使用消息。

您可能想知道领导者复制品是否会被这种设计淹没，以及为什么不从 ISR 中读取消息。原因是：

- 设计和操作简单。
- 由于一个分区中的消息只发送给使用者组中的一个使用者，因此这限制了到前导副本的连接数量。
- 只要一个主题不是超级热门，到引导副本的连接数量通常不会很大。
- 如果某个主题很热门，我们可以通过扩展分区和消费者的数量来扩展。

在某些情况下，读取引线复制副本可能不是最佳选择。例如，如果使用者位于与主副本不同的数据中心，则读取性能会受到影响。在这种情况下，让消费者能够从最近的 ISR 中读取是值得的。感兴趣的读者可以查看有关这方面的参考资料 [11]。

ISR 非常重要。它如何确定复制副本是否为 ISR？通常，每个分区的领导者通过计算每个副本本身的滞后来跟踪 ISR 列表。如果你对详细的算法感兴趣，可以在参考资料 [12] [13] 中找到实现。

### 可扩展性

到目前为止，我们在设计分布式消息队列系统方面已经取得了很大的进展。在下一步中，让我们评估不同系统组件的可伸缩性：

- 生产者
- 消费者
- Broker
- 分区

#### 生产者

生产者在概念上比消费者简单得多，因为它不需要团队协调。生产者的可伸缩性可以通过添加或删除生产者实例来轻松实现。

#### 消费者

消费者组彼此隔离，因此添加或删除消费者组很容易。在消费者群体内部，再平衡机制有助于处理消费者被添加或删除的情况，或消费者崩溃的情况。通过消费者群体和再平衡机制，可以实现消费者的可扩展性和容错性。

#### Broker

在讨论代理端的可伸缩性之前，让我们首先考虑代理的故障恢复。

让我们使用图 4.28 中的一个示例来解释故障恢复是如何工作的。

1. 假设有 4 个代理，分区（副本）分发计划如下所示：
   - 主题 A 的分区 1：Broker-1（leader）、2 和 3 中的副本。
   - 主题 A 的分区 2：Broker-2（leader）、3 和 4 中的副本。
   - 主题 B 的分区 1：Broker-3（leader）、4 和 1 中的副本。
2. Broker-3 崩溃，这意味着节点上的所有分区都丢失了。分区分布计划更改为：
   - 主题 A 的分区 1：Broker-1（leader）和 2 中的副本。
   - 主题 A 的分区 2：Broker-2（leader）和 4 中的副本。
   - 主题 B 的分区 1：Broker-4 和 1 中的副本。
3. 代理控制器检测到 broker-3 关闭，并为剩余的代理节点生成新的分区分布计划：
   - 主题 A 的分区 1：Broker-1（leader）、2 和 4（new）中的副本。
   - 主题 A 的分区 2：Broker-2（leader）、4 和 1（new）中的副本。
   - 主题 B 的分区 1：Broker-4（leader）、1 和 2（new）中的副本。
4. 新的复制品作为追随者工作，并赶上领导者。

为了使代理具有容错性，以下是其他注意事项：

- ISR 的最小数量指定了在消息被认为是成功提交之前，生产者必须接收多少副本。数字越高，越安全。但另一方面，我们需要平衡延迟和安全性。
- 如果一个分区的所有副本都在同一个代理节点中，那么我们不能容忍这个节点的故障。在同一个节点中复制数据也是对资源的浪费。因此，副本不应位于同一节点中。
- 如果一个分区的所有副本都崩溃了，那么该分区的数据将永远丢失。在选择副本数量和副本位置时，需要在数据安全性、资源成本和延迟之间进行权衡。跨数据中心分发复制副本更安全，但在复制副本之间同步数据会产生更多的延迟和成本。作为一种变通方法，数据镜像可以帮助跨数据中心复制数据，但这超出了范围。参考资料 [14] 涵盖了这一主题。

现在让我们回到讨论代理的可伸缩性。最简单的解决方案是在添加或删除代理节点时重新分发副本。

然而，还有更好的方法。代理控制器可以临时允许系统中的副本数量超过配置文件中的副本数。当新添加的代理赶上时，我们可以删除不再需要的代理。让我们使用如图 4.29 所示的示例来理解该方法。

1. 初始设置：3 个代理，2 个分区，每个分区 3 个副本。
2. 新增经纪人-4。假设代理控制器将分区 2 的副本分发更改为代理（2，3，4）。Broker-4 中的新复制副本开始从 leader Broker-2 复制数据。现在，分区 2 的副本数量暂时超过 3 个。
3. 在 Broker-4 中的副本赶上后，Broker-1 中的冗余分区将被优雅地删除。

通过遵循此过程，可以避免添加代理时的数据丢失。可以应用类似的过程来安全地删除代理。

#### 分区

由于各种操作原因，例如扩展主题、吞吐量调整、平衡可用性/吞吐量等，我们可能会更改分区的数量。当分区数量发生变化时，生产者将在与任何代理通信后得到通知，消费者将触发消费者再平衡。因此，它对生产者和消费者都是安全的。

现在让我们考虑一下分区数量发生变化时的数据存储层。如图 4.30 所示，我们为主题添加了一个分区。

- 持久化的消息仍在旧分区中，因此没有数据迁移。
- 添加新分区（分区-3）后，新消息将在所有 3 个分区中持久化。

因此，通过增加分区来扩展主题是很简单的。

### 减少分区数量

减少分区更为复杂，如图 4.31 所示。

- 分区-3 被解除授权，因此新消息仅由剩余的分区（分区-1 和分区-2）接收。
- 无法立即删除已停用的分区（分区-3），因为消费者当前可能会在一定时间内消耗数据。只有在经过配置的保留期后，才能截断数据并释放存储空间。减少分区并不是回收数据空间的快捷方式。
- 在这个过渡期内（当分区-3 被停用时），生产者只向剩余的 2 个分区发送消息，但消费者仍然可以从所有 3 个分区中消费。停用分区的保留期到期后，消费者组需要重新平衡。

### 数据传递语义

现在我们已经了解了分布式消息队列的不同组件，让我们讨论不同的传递语义：最多一次、至少一次和恰好一次。

#### 最多一次

顾名思义，最多一次意味着一条消息将不会传递不止一次。消息可能会丢失，但不会重新发送。这就是最高一次交付在高水平上的工作方式。

- 生产者向主题异步发送消息，而无需等待确认（ACK=0）。如果邮件传递失败，则不会重试。
- 消费者在处理数据之前获取消息并提交偏移量。如果使用者在偏移量提交后崩溃，则不会重新汇总消息。

它适用于监控度量等用例，其中少量数据丢失是可以接受的。

#### 至少一次

使用这种数据传递语义，可以多次传递消息，但不应丢失任何消息。以下是它在高水平上的工作原理。

- Producer 通过响应回调同步或异步发送消息，设置 ACK=1 或 ACK=all，以确保消息传递到代理。如果消息传递失败或超时，生产者将继续重试。
- 使用者只有在成功处理数据后才能获取消息并提交偏移量。如果使用者无法处理消息，它将重新使用消息，这样就不会丢失数据。另一方面，如果使用者处理了消息，但未能将偏移量提交给代理，则当使用者重新启动时，消息将被重新使用，从而导致重复。
- 消息可能会多次传递给代理和消费者。

用例：至少一次，消息不会丢失，但同一条消息可能会多次传递。虽然从用户的角度来看并不理想，但对于数据重复不是什么大问题或重复数据消除在消费者端是可能的用例来说，至少一次交付语义通常足够好。例如，如果每条消息中都有一个唯一的密钥，则在向数据库写入重复数据时，可以拒绝一条消息。

#### 正好一次

精确一次是最难实现的交付语义。它对用户很友好，但由于系统的性能和复杂性，它的成本很高。

用例：与财务相关的用例（支付、交易、会计等）。当重复是不可接受的，并且下游服务或第三方不支持幂等性时，仅一次尤为重要。

### 高级功能

在本节中，我们将简要介绍一些高级功能，例如消息过滤、延迟消息和计划消息。

#### 消息筛选
主题是包含相同类型消息的逻辑抽象。但是，一些消费者组可能只想消费某些子类型的消息。例如，订购系统将有关订单的所有活动发送到一个主题，但支付系统只关心与结账和退款相关的消息。

一种选择是为支付系统构建一个专用主题，为订购系统构建另一个主题。这种方法很简单，但可能会引起一些担忧。

- 如果其他系统要求不同的消息子类型，该怎么办？我们是否需要为每一个消费者请求构建专门的主题？
- 在不同的主题上保存相同的消息是浪费资源。
- 生产者需要在每次新的消费者需求到来时进行更改，因为生产者和消费者现在是紧密耦合的。

因此，我们需要使用不同的方法来解决这一需求。幸运的是，消息过滤起到了拯救作用。

消息过滤的一个简单解决方案是，消费者获取完整的消息集，并在处理期间过滤掉不必要的消息。这种方法很灵活，但会引入不必要的流量，从而影响系统性能。

一个更好的解决方案是在代理端过滤消息，这样消费者只会得到他们关心的消息。实现这一点需要一些仔细考虑。如果数据筛选需要数据解密或反序列化，则会降低代理的性能。此外，如果消息包含敏感数据，则它们在消息队列中不应该是可读的。

因此，代理中的过滤逻辑不应该提取消息负载。最好将用于过滤的数据放入消息的元数据中，该元数据可以由代理有效地读取。例如，我们可以为每条消息附加一个标签。通过一个消息标记，代理可以过滤该维度中的消息。如果附加了更多标签，则可以对消息进行多维过滤。因此，标签列表可以支持大多数过滤要求。为了支持更复杂的逻辑（如数学公式），代理需要一个语法分析器或脚本执行器，这对于消息队列来说可能太重了。

每个消息都附有标签，消费者可以根据指定的标签订阅消息，如图 4.35 所示。感兴趣的读者可以参考参考资料 [15]。

#### 延迟消息和计划消息

有时，您希望将向消费者传递消息的时间延迟一段指定的时间。例如，如果在创建订单后 30 分钟内未付款，则应关闭订单。延迟验证消息（检查付款是否完成）会立即发送，但 30 分钟后会发送给消费者。当消费者收到消息时，它会检查付款状态。如果未完成付款，订单将被关闭。否则，该消息将被忽略。

与发送即时消息不同，我们可以将延迟消息发送到代理端的临时存储，而不是立即发送到主题，然后在时间到时将其发送到主题。其高级设计如图4.36所示。

该系统的核心部件包括临时存储器和定时功能。

- 临时存储可以是一个或多个特殊消息主题。
- 计时功能超出范围，但以下是两种流行的解决方案：
- 具有预定义延迟级别的专用延迟队列 [16]。例如，RocketMQ 不支持具有任意时间精度的延迟消息，但支持具有特定级别的延迟消息。消息延迟级别为 1s、5s、10s、30s、1m、2m、3m、4m、6m、8m、9m、10m、20m、30m、1h 和 2h。
- 分层时间轮 [17]。

预定消息意味着应在预定时间将消息传递给消费者。整体设计与延迟消息非常相似。

## 第 4 步 - 总结

在本章中，我们介绍了一个分布式消息队列的设计，该队列具有数据流平台中常见的一些高级功能。如果面试结束时有额外的时间，以下是一些额外的谈话要点：

- 协议：它定义了关于如何在不同节点之间交换信息和传输数据的规则、语法和API。在分布式消息队列中，协议应该能够：
  - 涵盖生产、消费、心跳等所有活动。
  - 有效地传输大容量数据。
  - 验证数据的完整性和正确性。

一些流行的协议包括高级消息队列协议（AMQP）[18] 和 Kafka 协议 [19]。

- 重试消耗。如果某些消息无法成功消费，我们需要重试该操作。为了不阻止传入消息，我们如何在一段时间后重试该操作？一种想法是将失败的消息发送到专用的重试主题，以便稍后使用。
- 历史数据档案。假设存在基于时间或基于容量的日志保留机制。如果消费者需要重播一些已经被截断的历史消息，我们该怎么做？一种可能的解决方案是使用大容量的存储系统，如 HDFS [20] 或对象存储，来存储历史数据。

祝贺你走到这一步！现在拍拍自己的背。干得好！

# 4 Distributed Message Queue

In the chapter, we explore a popular question in system design interviews: design a distributed message queue. In modern architecture, systems are broken up into small and independent building blocks with well-defined interfaces between them. Message queues provide communication for those building blocks. What benefits do message queues bring?

- Decoupling. Message queues eliminate the tight coupling between components so they can be updated independently.
- Improved scalability. We can scale producers and consumers independently based on traffic load. For example, during peak hours, more consumers can be added to handle the increased traffic.
- Increased availability. If one part of the system goes offline, the other components can continue to interact with the queue.
- Better performance. Message queues make asynchronous communication easy. Producers can add messages to a queue without waiting for the response and consumers consume messages whenever they are available. They don't need to wait for each other.

Figure 4.1 shows some of the most popular distributed message queues on the market.

### Message queues vs event streaming platforms

Strictly speaking, Apache Kafka and Pulsa are not message queues as they are event streaming platforms. However, there is a convergence of features that starts to blur the distinction between message queues (RocketMQ, ActiveMQ, RabbitMQ, ZeroMQ, etc.) and event streaming platform (Kafka, Pulsa). For example, RabbitMQ, which is a typical message queue, added an optional streams feature to allow repeated message consumption and long message retention, and its implementation uses an append-only log, much like an event streaming platform would. Apache Pulsar is primarily a Kafka competitor, but it is also flexible and performant enough to be used as a typical distributed message queue.

In this chapter, we will design a distributed message queue with **additional features, such as long data retention, repeated consumption of messages, etc.**, that are typically only available on event streaming platforms. These additional features make the design could be simplified if the focus of your interview centers around the more traditional distributed message queues.

## Step 1 - Understand the Problem and Establish Design Scope

In a nutshell, the basic functionality of a message queue is straightforward: produces send messages to a queue, and consumers consume messages from it. Beyond this basic functionality, there are other considerations including performance, message delivery semantics, data detention, etc. The following set of questions will help clarify requirements and narrow down the scope.

**Candidate**: What's the format and average size of messages? Is it text only? Is multimedia allowed?

**Interviewer**: Text messages only. Messages are generally measured in the range of kilobytes (KBs).

**Candidate**: Can messages be repeatedly consumed?

**Interviewer**: Yes, messages can be repeatedly consumed by different consumers. Note that this is an added feature. A traditional distributed message queue does not retain a message once it has been successfully delivered to a consumer. Therefore, a message cannot be repeatedly consumed in a traditional message queue.

**Candidate**: Are messages consumed in the same order they were produced?

**Interviewer**: Yes, messages should be consumed in the same order they were produced. Note that this is an added feature. A traditional distributed message queue does not usually guarantee delivery orders.

**Candidate**: Does data need to be persisted and what is the data retention?

**Interviewer**: Yes, let's assume data retention is two weeks. This is an added feature. A traditional distributed message queue does not retain messages.

**Candidate**: How many producers and consumers are we going to support?

**Interviewer**: The more the better.

**Candidate**: What's the data delivery semantic we need to support? For example, at-most-once, at-least-once, and exactly once.

**Interviewer**: We definitely want to support at-least-one. Ideally, we should support all of them and make them configurable.

**Candidate**: What's the target throughput and end-to-end latency?

**Interviewer**: It should support high thoughput for use cases like log aggregation. It should also support low latency delivery for more traditional message queue use cases.

With the above conversation, let's assume we have the following functional requirements:

- Producers send messages to a message queue.
- Consumers consume messages from a message queue.
- Messages can be consumed repeatedly or only once.
- Historical data can be truncated.
- Message size is in the kilobyte range.
- Ability to deliver messages to consumers in the order they were added to the queue.
- Data delivery semantics (at-least once, at-most once, or exactly once) can be configured by users.

### Non-functional requirements

- High throughput or low latency, configurable based on use cases.
- Scalable. The system should be distributed in nature. It should be able to support a sudden surge in message volume.
- Persistent and durable. Data should be persisted on disk and replicated across multiple nodes.

### Adjustments for traditional message queues

Traditional message queues like RabbitMQ do not have as strong a retention requirement as event streaming platforms. Traditional queues retain messages in memory just long enough for them to be consumed. They provided on-disk overflow capacity [1] which is several orders of magnitude smaller than the capacity required for event streaming platforms. Traditional message queues do not typically maintain message ordering. The messages can be consumed in a different order than they were produced. These differences greatly simplify the design which we will discuss where appropriate.

## Step 2 - Propose High-level Design and Get Buy-in

First, let's discuss the basic functionalities of a message queue.

Figure 4.2 shows the key components of a message queue and the simplified interactions between these components.

- Producer sends messages to a message queue.
- Consumer subscribes to a queue and consumes the subscribed messages.
- Message queue is a service in the middle that decouples the producers from the consumers, allowing each of them to operate and scale independently.
- Both producer and consumer are clients in the client/server model, while the message queue is the server. The clients and servers communicate over network.

### Messaging models

The most popular messaging models are point-to-point and publish-subscribe.

#### Point-to-point

This model is commonly found in traditional message queues. In a point-to-point model, a message is sent to a queue and consumed by one and only one consumer. There can be multiple consumers waiting to consume messages in the queue, but each message can only be consumed by a single consumer. In Figure 4.3, message A is only consumed by consumer 1.

Once the consumer acknowledges that a message is consumed, it is removed from the queue. There is no data retention in the point-to-point model. In contrast, our design includes a persistence layer that keeps the messages for two weeks, which allows messages to be repeatedly consumed.

While our design could simulate a point-to-point model, its capabilities map more naturally to the publish-subscribe model.

#### Publish-subscribe

First, let's introduce a new concept, the topic. Topics are the categories used to organize messages. Each topic has a name that is unique across the entire message queue service. Messages are sent to and read from a specific topic.

In the publish-subcribe model, a message is sent to a topic and received by the consumers subscribing to this topic. As shown in Figure 4.4, message A is consumed by both consumer 1 and consumer 2.

Our distributed message queue supports both models. The publish-subscribe model is implemented by **topics**, and the point-to-point model can be simulated by the concept of the **comsumer group**, which will be introduced in the consumer group section.

### Topics, partitions, and brokers

As mentioned earlier, messages are persisted by topics. What if the data volume in a topic is too large for a single server to handle?

One approach to solve this problem is called **partition (sharding)**. As Figure 4.5 shows, we divide a topic into partitions and deliver messages evenly across partitions. Think of a partition as a small subset of the messages for a topic. Partitions are evenly distributed across the servers in the message queue cluster. These servers that hold partitions are called **brokers**. The distribution of partitions among brokers is the key element to support high scalability. We can scale the topic capacity by expanding the number of partitions.

Each topic partition operates in the form of a queue with the FIFO (first in, first out) mechanism. This means we can keep the order of messages inside a partition. The position of a message in the partition is called an **offset**.

When a message is sent by a producer, it is actually sent to one of the partitions for the topic. Each message has an optional message key (for example, a user's ID), and all messages for the same message key are sent to the same partition. If the message key is absent, the message is randomly sent to one of the partitions.

When a consumer subscribes to a topic, it pulls data from one or more of these partitions. When there are multiple consumers subscribing to a topic, each consumer is responsible for a subset of the partitions for the topic. The consumers form a **consumer group** for a topic.

The message queue cluster with brokers and partitions is represented in Figure 4.6.

### Consumer group

As mentioned earlier, we need to support both point-to-point and subscribe-publish models. **A consumer group** is a set of consumers, working together to consume messages from topics.

Consumers can be organized into groups. Each consumer group can subscribe to multiple topics and maintain its own consuming offsets. For example, we can group consumers by use cases, one group for billing and the other for accounting.

The instances in the same group can consume traffic in parallel, as in Figure 4.7.

- Consumer group 1 subscribes to topic A.
- Consumer group 2 subscribes to both topics A and B.
- Topic A is subscribed by both consumer groups-1 and group-2, which means the same message is consumed by multiple consumers. This pattern supports the subscribe/publish model.

However, there is one problem. Reading data in parallel improves the throughput, but the consumption order of messages in the same partition cannot be guaranteed. For example, if Consumer-1 and Consumer-2 both read from Partition-1, we will not be able to guarantee the message consumption order in Partition-1.

The good news is we can fix this by adding a constraint, that a single partition can only be consumed by one comsumer in the same group. If the number of consumers of a group is larger than the number of partitions of a topic, some consumers will not get data from this topic. For example, in Figure 4.7, Consumer-3 in Consumer group-2 cannot consume messages from topic B because it is consumed by Consumer-4 in the same consumer group, already.

With this constraint, if we put all consumers in the same consumer group, then messages in the same partition are consumed by only one consumer, which is equivalent to the point-to-point model. Since a partition is the smallest storage unit, we can allocate enough partitions in advance to avoid the need to dynamically increase the number of partitions. To handle high scale, we just need to add consumers.

### High-level architecture

Figure 4.8 shows the updated high-level design.

Clients

- Producer: pushes messages to specific topics.
- Consumer group: subscribes to topics and consumes messages.

Core service and storage

- Broker: holds multiple partitions. A partition holds a subset of messages for a topic.
- Storage:
  - Data storage: messages are persisted in data storage in partitions.
  - State storage: consumer states are managed by state storage.
  - Metadata storage: configuration and properties of topics are persisted in metadata storage.
- Coordination service:
  - Service discovery: which brokers are alive.
  - Leader election: one of the brokers is selected as the active controller. There is only one active controller in the cluster. The active controller is responsible for assigning partitions.
  - Apache ZooKeeper [2] or etcd [3] are commonly used to elect a controller.

## Step 3 - Design Deep Dive

To achieve high throughput while satisfying the high data retention requirement, we made three important design choices, which we explain in detail now.

- We chose an on-disk data structure that takes advantage of the great sequential access performance of rotational disks and the aggressive disk caching strategy of modern operating systems.
- We designed the message data structure to allow a message to be passed from the producer to the queue and finally to the consumer, with no modifications. This minimizes the need for copying which is very expensive in a high volume and high traffic system.
- We designed the system to favor batching. Small I/O is an enemy of high throughput. So, wherever possible, our design encourages batching. The producers send messages in batches. The message queue persists messages in even larger batches. The consumers fetch messages in batches when possible, too.

### Data storage

Now let's explore the options to persist messages in more detail. In order to find the best choice, let's consider the traffic pattern of a message queue.

- Write-heavy, read-heavy.
- No update or delete operations. As a side note, a traditional message queue does not persist messages unless the queue falls behind, in which case there will be "delete" operations when the queue catches up. What we are talking about here is the persistence of a data streaming platform.
- Predominantly sequential read/write access.

Option 1: Database

The first option is to use a database.

- Relational database: create a topic table and write messages to the table as rows.
- NoSQL database: create a collection as a topic and write messages as documents.

Databases can handle the storage requirements, but they are not ideal because it is hard to design a database that supports both write-heavy and read-heavy access patterns at a large scale. The database solution does not fit our specific data usage patterns very well.

This means a database is not the best choice and could become a bottleneck of the system.

Option 2: Write-ahead log (WAL)

The second option is write-ahead log (WAL). WAL is just a plain file where new entries are appended to an append-only log. WAL is used in many systems, such as the redo log in MySQL [4] and the WAL in ZooKeeper.

We recommend persisting messages as WAL log files on disk. WAL has a pure sequential read/write access pattern. The disk performance of sequential access is very good [5]. Also, rotational disks have large capacity and they are pretty affordable.

As shown in Figure 4.9, a new message is appended to the tail of a partition, with a monotonically increasing offset. The easiest option is to use the line number of the log file as the offset. However, a file cannot grow infinitely, so it is a good idea to divide it into segments.

With segments, new messages are appended only to the active segment file. When the active segment reaches a certain size, a new active segment is created to receive new messages, and the currently active segment becomes inactive, like the rest of the non-active segments. Non-active segments only serve read requests. Old non-active segment files can be truncated if they exceed the retention or capacity limit.

Segment files of the same partition are organized in a folder named `Partition-{:patition_id}`. The structure is shown in Figure 4.10.

### A note on disk performance

To meet the high data retention requirement, our design relies heavily on disk drives to hold a large amount of data. There is a common misconception that rotational disks are slow, but this is really only the case for random access. For our workload, as long as we design our on-disk data structure to take advantage of the sequential access pattern, the modern disk drives in a RAID configuration (i.e., with disks striped together for higher performance) could comfortably achieve several hundred MB/sec of read and write speed. This is more than enough for our needs, and the cost stucture is favorable.

Also, a modern operating system caches disk data in main memory very aggressively, so much so that it would happily use all available free memory to cache disk data. The WAL takes advantage of the heavy OS disk caching, too, as we described above.

### Message data structure

The data structure of a message is key to high throughput. It defines the contract between the producers, message queue, and consumers. Our design achieves high performance by eliminating unnecessary data copying while the messages are in transit from the producers to the queue and finally to the consumers. If any parts of the system disagree on this contract, messages will need to be mutated which involves expensive copying. It could seriously hurt the performance of the system.

Below is a sample schema of the message data structure:

| 字段名    | 数据类型 |
| --------- | -------- |
| key       | byte[]   |
| value     | byte[]   |
| topic     | string   |
| partition | integer  |
| offset    | long     |
| timestamp | long     |
| size      | integer  |
| crc       | integer  |

### Message key

The key of the message is used to determine the partition of the message. If the key is not defined, the partition is randomly chosen. Otherwise, the partition is chosen by `hash(key) % numPartitions`. If we need more flexibility, the producer can define its own mapping algorithm to choose partitions. Please note that the key is not equivalent to the partition number.

The key can be a string or a number. It usually carries some business information. The partition number is a concept in the message queue, which should not be explicitly exposed to clients.

With a proper mapping algorithm, if the number of partitions changes, messages can still be evenly sent to all the partitions.

### Message value

The message value is the payload of a message. It can be plain text or a compressed binary block.

> Reminder
>
> The key and value of a message are different from the key-value pair in a key-value (KV) store. In the KV store, keys are unique, and we can find the value by key. In a message, keys do not need to be unique. Sometimes they are not even mandatory, and we don't need to find a value by key.

### Other fields of a message

- Topic: the name of the topic that the message belongs to.
- Partition: the ID of the partition that the message belongs to.
- Offset: the position of the message in the partition. We can find a message via the combination of three fields: topic, partition, offset.
- Timestamp: the timestamp of when this message is stored.
- Size: the size of this message.
- CRC: Cyclic redundancy check (CRC) is used to ensure the integrity of raw data.

To support additional features, some optional fields can be added on demand. For example, messages can be filtered by tags, if tags are part of the optional fields.

### Batching

Batching is pervasive in this design. We batch messages in the producer, the consumer, and the message queue itself. Batching is critical to the performance of the system. In this section, we focus primarily on batching in the message queue. We discuss batching for producer and consumer in more detail, shortly.

Batching is critical to improving performance because:

- It allows the operating system to group messages together in a single network request and amortizes the cost of expensive network round trips.
- The broker writes messages to the append logs in large chunks, which leads to larger blocks of sequential writes and larger contiguous blocks of disk cache maintained by the operating system. Both lead to much greater sequential disk access throughput.

There is a tradeoff between throughput and latency. If the system is deployed as a traditional message queue where latency might be more important, the system could be tuned to use a smaller batch size. Disk performance will suffer a little bit in this use case. If tuned for throughput, there might need to be a higher number of partitions per topic to make up for the slower sequential disk write throughput.

So far, we've covered the main disk storage subsystem and its associated on-disk data structure. Now, let's switch gears and discuss the producer and consumer flows. Then we will come back and finish the deep dive into the rest of the message queue.

### Producer flow

If a producer wants to send messages to a partition, which broker should it connect to? The first option is to introduce a routing layer. All messages sent to the routing layer are routed to the "correct" broker. If the brokers are replicated, the "correct" broker is the leader replica. We will cover replication later.

As shown in Figure 4.11, the producer tries to send messages to Partition-1 of Topic-A.

1. The producer sends messages to the routing layer.
2. The routing layer reads the replica distribution plan from the metadata storage and caches it locally. When a message arrives, it routes the message to the leader replica of Partition-1, which is stored in Broker-1.
3. The leader replica receives the message and follower replicas pull data from the leader.
4. When "enough" replicas have synchronized the message, the leader commits the data (persisted on disk), which means the data can be consumed. Then it responds to the producer.

You might be wondering why we need both leader and follower replicas. The reason is fault tolerance. We dive deep into this process in the "In-sync replicas" section on page 113.

This approach works, but it has a few drawbacks:

- A new routing layer means additional network latency caused by overhead and additional network hops.
- Request batching is one of the big drivers of efficiency. This design doesn't take that into consideration.

Figure 4.12 shows the improved design.

The routing layer is wrapped into the producer and a buffer component is added to the producer. Both can be installed in the producer as part of the producer client library. This change brings several benefits:

- Fewer network hops mean lower latency:
- Producers can have their own logic to determine which partition the message should be sent to.
- Batching buffers messages in memory and sends out larger batches in a single request. This increases throughput.

The choice of the batch size is a classic tradeoff between throughput and latency (Figure 4.13). With a large batch size, the throughput increases but latency is higher, due to a longer wait time to accumulate the batch. With a small batch size, requests are sent sooner so the latency is lower, but throughput suffers. Producers can tune the batch size based on use cases.

### Consumer flow

The consumer specifies its offset in a partition and receives back a chuck of events beginning from that position. An example is shown in Figure 4.14.

### Push vs pull

An important question to answer is whether brokers should push data to consumers, or if consumers should pull data from the brokers.

#### Push model

Pros:

- Low latency. The broker can push messages to the consumer immediately upon receiving them.

Cons:

- If the rate of consumption falls below the rate of production, consumers could be overwhelmed.
- It is difficult to deal with consumers with diverse processing power because the brokers control the rate at which data is transferred.

#### Pull model

Pros:

- Consumers control the consumption rate. We can have one set of consumers process messages in real-time and another set of consumers process messages in batch mode.
- If the rate of consumption falls below the rate of production, we can scale out the consumers, or simply catch up when it can.
- The pull model is more suitable for batch processing. In the push model, the broker has no knowledge of whether consumers will be able to process messages immediately. If the broker sends one message will end up waiting in the buffer. A pull model pulls all available messages after the consumer's current position in the log (or up to the configurable max size). It is suitable for aggressive batching of data.

Cons:

- When there is no message in the broker, a consumer might still keep pulling data, wasting resources. To overcome this issue, many message queues support long polling mode, which allows pulls to wait a specified amount of time for new messages [6].

Based on these considerations, most message queues choose the pull model.

Figure 4.15 shows the workflow of the consumer pull model.

1. Initially, only Consumer A is in the group. It consumes all the partitions and keeps the heartbeat with the coordinator.
2. Consumer B sends a request to join the group.
3. The coordinator knows it's time to rebalance, so it notifies all the consumers in the group in a passive way. When Consumer A's heartbeat is received by the coordinator, it asks Consumer A to rejoin the group.
4. Once all the consumers have rejoined the group, the coordinator chooses one of them as the leader and informs all the consumers about the election result.
5. The leader consumer generates the partition dispatch plan and sends it to the coordinator. Follower consumers ask the coordinator about the partition dispatch plan.
6. Consumers start consuming messages from newly assigned partitions.

Figure 4.19 shows the flow when an existing Consumer A leaves the group.

1. Consumer A and B are in the same consumer group.
2. Consumer A needs to be shut down, so it requests to leave the group.
3. The coordinator knows it's time to rebalance. When Consumer B's heartbeat is received by the coordinator, it asks Consumer B to rejoin the group.
4. The remaining steps are the same as the ones shown in Figure 4.18.

Figure 4.20 shows the flow when an existing Consumer A crashes.

1. Consumer A and B keep heartbeats with the coordinator.
2. Consumer A crashes, so there is no heartbeat sent from Consumer A to the coordinator. Since the coordinator doesn't get any heartbeat signal within a specified amount of time from Consumer A, it marks the consumer as dead.
3. The coordinator triggers the rebalance process.
4. The following steps are the same as the ones in the previous scenario.

Now that we finished the detour on producer and consumer flows, let's come back and finish the deep dive on the rest of the message queue broker.

### Stage storage

In the message queue broker, the state storage stores:

- The mapping between partitions and consumers.
- The last consumed offsets of consumer groups for each partition. As shown in Figure 4.21, the last consumed offset for consumer group-1 is 6 and the offset for consumer group-2 is 13.

For example, as shown in Figure 4.21, a consumer in group-1 consumes messages from the partition in sequence and commits the consumed offset from the state storage.

The data access patterns for consumer states are:

- Frequence read and write operations but the volume is not high.
- Data is updated frequently and is rarely deleted.
- Random read and write operations.
- Data consistency is important.

Lots of storage solutions can be used for storing the consumer state data. Considering the data consistency and fast read/write requirements, a KV store like ZooKeeper is a great choice. Kafka has moved the offset storage from ZooKeeper to Kafka brokers. Interested readers can read the reference material [8] to learn more.

### Metadata storage

The metadata storage stores the configuration and properties of topics, including a number of partitions, retention period, and distribution of replicas.

Metadata does not change frequently and the data volume is small, but it has a high consistency requirement. ZooKeeper is a good choice for storing metadata.

### ZooKeeper

By reading previous sections, you probably have already sensed that ZooKeeper is very helpful for designing a distributed message queue. If you are not familiar with it, ZooKeeper is an essential service for distributed systems offering a hierarchical key-value store. It is commonly used to provide a distributed configuration service, synchronization service, and naming registry [2].

ZooKeeper is used to simplify our design as shown in Figure 4.22.

Let's briefly go over the change.

- Metadata and state storage are moved to ZooKeeper.
- The broker now only needs to maintain the data storage for messages.
- ZooKeeper helps with the leader election of the broker cluster.

### Replication

In distributed systems, hardware issues are common and cannot be ignored. Data gets lost when a disk is damaged or fails permanently. Replication is the classic solution to achieve high availability.

As in Figure 4.23, each partition has 3 replicas, distributed across different broker nodes.

For each partition, the highlighted replicas are the leaders and the others are followers. Producers only send messages to the leader replica. The follower replicas keep pulling new messages from the leader. Once messages are synchronized to enough replicas, the leader returns an acknowledgement to the producer. We will go into detail about how to define "enough" in the In-sync Replicas section on page 113.

The distribution of replicas for each partition is called a replica distribution plan. For example, the replica distribution plan in Figure 4.23 can be described as:

- Partition-1 of Topic-A: 3 replicas, leader in Broker-1, followers in Broker-2 and 3.
- Partition-2 of Topic-A: 3 replicas, leader in Broker-2, followers in Broker-3 and 4.
- Partition-1 of Topic-B: 3 replicas, leader in Broker-3, followers in Broker-4 and 1.

Who makes the replica distribution plan? It works as follows: with the help of the coordination service, one of the broker nodes is elected as the leader. It generates the replica distribution plan and persists the plan in metadata storage. All the brokers now can work according to the plan.

If you are interested in knowing more about replications, check out "Chapter 5 Replication" of the book "Design Data-Intensive Application" [9].

### In-sync replicas

We mentioned that messages are persisted in multiple partitions to avoid single node failure, and each partition has multiple replicas. Messages are only written to the leader, and followers synchronize data from the leader. One problem we need to solve is keeping them in sync.

In-sync replicas (ISR) refer to replicas that are "in-sync" with the leader. The definition of "in-sync" depends on the topic configuration. For example, if the value of replica.lag.max.messages is 4, it means that as long as the follower is behind the leader by no more than 3 messages, it will not be removed from ISR [10]. The leader is an ISR by default.

Let's use an example as shown in Figure 4.24 to shows how ISR works.

- The committed offset in the leader replica is 13. Two new messages are written to the leader, but not committed yet. Committed offset means that all messages before and at this offset are already synchronized to all the replicas in ISR.
- Replica-2 and replica-3 have fully caught up with the leader, so they are in ISR and can fetch new messages.
- Replica-4 did not fully catch up with the leader within the configured lag time, so it is not in ISR. When it catches up again, it can be added to ISR.

Why do we need ISR? The reason is that ISR reflects the trade-off between performance and durability. If producers don't want to lose any messages, the safest way to do that is to ensure all replicas are already in sync before sending an acknowledgement. But a slow replica will cause the whole partition to become slow or unavailable.

Now that we've discussed ISR, let's take a look at acknowledgement settings. Producers can choose to receive acknowledgements until the k number of ISRs has received the message, where k is configurable.

### ACK=all

Figure 4.25 illustrates the case with ACK=all. With ACK=all, the producer gets an ACK when all ISRs have received the message. This means it takes a longer time to send a message because we need to wait for the slowest ISR, but it gives the strongest message durability.

### ACK=1

With ACK=1, the producer receives an ACK once the leader persists the message. The latency is improved by not waiting for data synchronization. If the leader fails immediately after a message is acknowledged but before it is replicated by follower nodes, then the message is lost. This setting is suitable for low latency systems where occasional data loss is acceptable.

### ACK=0

The producer keeps sending messages to the leader without waiting for any acknowledgement, and it never retries. This method provides the lowest latency at the cost of potential message loss. This setting might be good for use cases like collecting metrics or logging data since data volume is high and occasional data loss is acceptable.

Configurable ACK allows us to trade durability for performance.

Now let's look at the consumer side. The easiest setup is to let consumers connect to a leader replica to consume messages.

You might be wondering if the leader replica would be overwhelmed by this design and why messages are not read from ISRs. The reasons are:

- Design and operational simplicity.
- Since messages in one partition are dispatched to only one consumer within a consumer group, this limits the number of connections to the leader replica.
- The number of connections to the leader replicas is usually not large as long as a topic is not super hot.
- If a topic is hot, we can scale by expanding the number of partitions and consumers.

In some scenarios, reading from the leader replica might not be the best option. For example, if a consumer is located in a different data center from the leader replica, the read perfermance suffers. In this case, it is worthwhile to enable consumers to read from the closest ISRs. Interested readers can check out the reference material about this [11].

ISR is very important. How does it determine if a replica is ISR or not? Usually, the leader for every partition tracks the ISR list by computing the lag of every replica from itself. If you are interested in detailed algorithms, you can find the implementations in reference materials [12] [13].

### Scalability

By now we have made great progress designing the distributed message queue system. In the next step, let's evaluate the scalability of different system components:

- Producers
- Consumers
- Brokers
- Partitions

#### Producer

The producer is conceptually much simpler than the consumer because it doesn't need group coordination. The scalability of producers can easily be achieved by adding or removing producer instances.

#### Consumer

Consumer groups are isolated from each other, so it is easy to add or remove a  consumer group. Inside a consumer group, the rebalancing mechanism helps to handle the cases where a consumer gets added or removed, or when it crashes. With consumer groups and the rebalance mechanism, the scalability and fault tolerance of consumers can be achieved.

#### Broker

Before discussing scalability on the broker side, let's first consider the failure recovery of brokers.

Let's use an example in Figure 4.28 to explain how failure recovery works.

1. Assume there are 4 brokers and the partition (replica) distribution plan is shown below:
   - Partition-1 of topic A: replicas in Broker-1 (leader), 2, and 3.
   - Partition-2 of topic A: replicas in Broker-2 (leader), 3, and 4.
   - Partition-1 of topic B: replicas in Broker-3 (leader), 4, and 1.
2. Broker-3 crashes, which means all the partitions on the node are lost. The partition distribution plan is changed to:
   - Partition-1 of topic A: replicas in Broker-1 (leader) and 2.
   - Partition-2 of topic A: replicas in Broker-2 (leader) and 4.
   - Partition-1 of topic B: replicas in Broker-4 and 1.
3. The broker controller detects Broker-3 is down and generates a new partition distribution plan for the remaining broker nodes:
   - Partition-1 of topic A: replicas in Broker-1 (leader), 2, and 4 (new).
   - Partition-2 of topic A: replicas in Broker-2 (leader), 4, and 1 (new).
   - Partition-1 of topic B: replicas in Broker-4 (leader), 1, and 2 (new).
4. The new replicas work as followers and catch up with the leader.

To make the broker fault-tolerant, here are additional considerations:

- The minimum number of ISRs specifies how many replicas the producer must receive before a message is considered to be successfully committed. The higher the number, the safer. But on the other hand, we need to balance latency and safety.
- If all replicas of a partition are in the same broker node, then we cannot tolerate the failure of this node. It is also a waste of resources to replicate data in the same node. Therefore, replicas should not be in the same node.
- If all the replicas of a partition crash, the data for that partition is lost forever. When choosing the number of replicas and replica locations, there's a trade-off between data safety, resource cost, and latency. It is safer to distribute replicas across data centers, but this will incur much more latency and cost, to synchronize data between replicas. As a workaround, data mirroring can help to copy data across data centers, but this is out of scope. The reference material [14] covers this topic.

Now let's get back to discussing the scalability of brokers. The simplest solution would be to redistribute the replicas when broker nodes are added or removed.

However, there is a better approach. The broker controller can temporarily allow more replicas in the system than the number of replicas in the config file. When the newly added broker catches up, we can remove the ones that are no longer needed. Let's use an example as shown in Figure 4.29 to understand the approach.

1. The initial setup: 3 brokers, 2 partitions, and 3 replicas for each partition.
2. New Broker-4 is added. Assume the broker controller changes the replica distribution of Partition-2 to the broker (2, 3, 4). The new replica in Broker-4 starts to copy data from leader Broker-2. Now the number of replicas for Partition-2 is temporarily more than 3.
3. After the replica in Broker-4 catches up, the redundant partition in Broker-1 is gracefully removed.

By following this process, data loss while adding brokers can be avoided. A similar process can be applied to remove brokers safely.

#### Partition

For various operational reasons, such as scaling the topic, thoughput tuning, balancing availability/throughput, etc., we may change the number of partitions. When the number of partitions changes, the producer will be notified after it communicates with any broker, and the consumer will trigger consumer rebalancing. Therefore, it is safe for both the producer and consumer.

Now let's consider the data storage layer when the number of partitions changes. As in Figure 4.30, we have added a partition to the topic.

- Persisted messages are still in the old partitions, so there's no data migration.
- After the new partition (partition-3) is added, new messages will be persisted in all 3 partitions.

So it is straightforward to scale the topic by increasing partitions.

### Decrease the number of partitions

Decreasing partitions is more complicated, as illustrated in Figure 4.31.

- Partition-3 is decommissioned so new messages are only received by the remaining partitions (partition-1 and partition-2).
- The decommissioned partition (partition-3) cannot be removed immediately because data might be currently consumed by consumers for a certain amount of time. Only after the configured retention period passes, data can be truncated and storage space is freed up. Reducing partitions is not a shortcut to reclaiming data space.
- During this transitional period (while partition-3 is decommissioned), producers only send messages to the remaining 2 partitions, but consumers can still consume from all 3 partitions. After the retention period of the decommissioned partition expires, consumer groups need rebalancing.

### Data delivery semantics

Now that we understand the different components of a distributed message queue, let's discuss different delivery semantics: at-most once, at-least once, and exactly once.

#### At-most once

As the name suggests, at-most once means a message will be delivered not more than once. Messages may be lost but are not redelivered. This is how at-most once delivery works at the high level.

- The producer sends a message asynchronously to a topic without waiting for an acknowledgement (ACK=0). If message delivery fails, there is no retry.
- Consumer fetches the message and commits the offset before the data is processed. If the consumer crashes just after offset commit, the message will not be reconsumed.

It is suitable for use cases like monitoring metrics, where a small amount of data loss is acceptable.

#### At-least once

With this data delivery semantic, it's acceptable to deliver a message more than once, but no message should be lost. Here is how it works at a high level.

- Producer sends a message synchronously or asynchronously with a reponse callback, setting ACK=1 or ACK=all, to make sure messages are delivered to the broker. If the message delivery fails or timeouts, the producer will keep retrying.
- Consumer fetches the message and commits the offset only after the data is successfully processed. If the consumer fails to process the message, it will re-consume the message so there won't be data loss. On the other hand, if a consumer processes the message but fails to commit the offset to the broker, the message will be re-consumed when the consumer restarts, resulting in duplicates.
- A message might be delivered more than once to the brokers and consumers.

Use cases: With at-least once, messages won't be lost but the same message might be delivered multiple times. While not ideal from a user perspective, at-least once delivery semantics are usually good enough for use cases where data duplication is not a big issue or deduplication is possible on the consumer side. For example, with a unique key in each message, a message can be rejected when writing duplicate data to the database.

#### Exactly once

Exactly once is the most difficult delivery semantic to implement. It is friendly to users, but it has a high cost for the system's performance and complexity.

Use cases: Financial-related use cases (payment, trading, accounting, etc.). Exactly once is especially important when duplication is not acceptable and the downstream service or third party doesn't support idempotency.

### Advanced features

In this section, we walk briefly about some advanced features, such as message filtering, delayed messages, and scheduled messages.

#### Message filtering

A topic is a logical abstraction that contains messages of the same type. However, some consumer groups may only want to consume messages of certain subtypes. For example, the ordering system sends all the activities about the order to a topic, but the payment system only cares about messages related to checkout and refund.

One option is to build a dedicated topic for the payment system and another topic for the ordering system. This method is simple, but it might raise some concerns.

- What if other systems ask for different subtypes of messages? Do we need to build dedicated topics for every single consumer request?
- It is a waste of resources to save the same messages on different topics.
- The producer needs to change every time a new consumer requirement comes, as the producer and consumer are now tightly coupled.

Therefore, we need to resolve this requirement using a different approach. Luckily, message filtering comes to the rescue.

A naive solution for message filtering is that the consumer fetches the full set of messages and filters out unnecessary messages during processing time. This approach is flexible but introduces unnecessary traffic that will affect system performance.

A better solution is to filter messages on the broker side so that consumers will only get messages they care about. Implementing this requires some careful consideration. If data filtering requires data decryption or deserialization, it will degrade the performance of the brokers. Additionally, if messages contain sensitive data, they should not be readable in the message queue.

Therefore, the filtering logic in the broker should not extract the message payload. It is better to put data used for filtering into the metadata of a message, which can be efficiently read by the broker. For example, we can attach a tag to each message. With a message tag, a broker can filter messages in that dimension. If more tags are attached, the messages can be filtered in multiple dimensions. Therefore, a list of tags can support most of the filtering requirements. To support more complex logic such as mathematical formulae, the broker will need a grammar parser or a script executor, which might be too heavyweight for the message queue.

With tags attached to each message, a consumer can subscribe to messages based on the specified tag, as shown in Figure 4.35. Interested readers can refer to the reference material [15].

#### Delayed messages & scheduled messages

Sometimes you want to delay the delivery of messages to a consumer for a specified period of time. For example, an order should be closed if not paid within 30 minutes after the order is created. A delayed verification message (check if the payment is completed) is sent immediately but is delivered to the consumer 30 minutes later. When the consumer receives the message, it checks the payment status. If the payment is not completed, the order will be closed. Otherwise, the message will be ignored.

Different from sending instant messages, we can send delayed messages to temporary storage on the broker side instead of to the topics immediately, and then deliver them to the topics when time's up. The high-level design for this is shown in Figure 4.36.

Core components of the system include the temporary storage and the timing function.

- The temporary storage can be one or more special message topics.
- The timing function is out of scope, but here are 2 popular solutions:
  - Dedicated delay queues with predefined delay levels [16]. For example, RocketMQ doesn't support delayed messages with arbitrary time precision, but delayed messages with specific levels are supported. Message delay levels are 1s, 5s, 10s, 30s, 1m, 2m, 3m, 4m, 6m, 8m, 9m,10m, 20m, 30m, 1h and 2h.
  - Hierarchical time wheel [17].

A scheduled message means a message should be delivered to the consumer at the scheduled time. The overall design is very similar to delayed messages.

## Step 4 - Wrap up

In this chapter, we have presented the design of a distributed message queue with some advanced features commonly found in data streaming platforms. If there is extra time at the end of the interview, here are some additional talking points:

- Protocol: it defines rules, syntax, and APIs on how to exchange information and transfer data between different nodes. In a distributed message queue, the protocol should be able to:
  - Cover all the activities such as production, consumption, heartbeat, etc.
  - Effectively transport data with large volumes.
  - Verify the integrity and correctness of the data.

Some popular protocols include Advanced Message Queuing Protocol (AMQP) [18] and Kafka protocol [19].

- Retry consumption. If some messages cannot be consumed successfully, we need to retry the operation. In order not to block incoming messages how can we retry the operation after a certain time period? One idea is to send failed messages to a dedicated retry topic, so they can be consumed later.
- Historical data archive. Assume there is a time-based or capacity-based log retention mechanism. If a consumer needs to replay some historical messages that are already truncated, how can we do it? One possible solution is to use storage systems with large capacities, such as HDFS [20] or object storage, to store historical data.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 5 指标监控和警报系统

在本章中，我们探讨了一个可扩展的度量监控和警报系统的设计。精心设计的监控和警报系统在提供基础设施健康状况的清晰可见性以确保高可用性和可靠性方面发挥着关键作用。

图5.1显示了市场上一些最流行的监控和警报服务指标。在本章中，我们设计了一个类似的服务，可以由大公司内部使用。

## 第 1 步 - 了解问题并确定设计范围

指标监控和警报系统对不同的公司来说可能意味着很多不同的事情，因此首先与面试官确定确切的要求至关重要。例如，如果面试官只考虑基础设施指标，那么您不想设计一个专注于 web 服务器错误或访问日志等日志的系统。

在深入了解细节之前，让我们先充分了解问题并确定设计范围。

**候选人**：我们为谁构建系统？我们是在为 Facebook 或谷歌这样的大公司构建内部系统，还是在设计 Datadog [1]、Splunk [2] 等 SaaS 服务？
**采访者**：这是一个很好的问题。我们正在建造它，仅供内部使用。
**候选人**：我们想收集哪些指标？
**采访者**：我们想收集操作系统指标。这些可以是操作系统的低级别使用数据，例如 CPU 负载、内存使用和磁盘空间消耗。它们也可以是高级概念，例如每秒服务的请求数或网络池的运行服务器数。业务指标不在此设计范围内。
**候选人**：我们用这个系统监控的基础设施规模有多大？
**采访者**：1 亿日活跃用户，1000 个服务器池，每个池 100 台机器。
**候选人**：我们应该把数据保存多久？
**面试官**：假设我们希望保留一年。
**候选人**：我们可以降低长期存储的度量数据的分辨率吗？
**采访者**：这是一个很好的问题。我们希望能够将新收到的数据保存 7 天。7 天后，您可以将它们滚动到 1 分钟的分辨率，持续 30 天。30 天后，您可以以 1 小时的分辨率将它们进一步卷起。
**候选人**：支持哪些警报渠道？
**采访者**：电子邮件、电话、PagerDuty [3] 或网络挂钩（HTTP 端点）。
**候选人**：我们是否需要收集日志，例如错误日志或访问日志？
**面试官**：没有。
**候选人**：我们需要支持分布式系统跟踪吗？
**面试官**：没有。

### 高级别要求和假设

现在，您已经完成了从面试官那里收集需求的工作，并且对设计有了明确的范围。要求是：

- 被监测的基础设施是大规模的。
  - 1 亿日活跃用户。
  - 假设我们有 1000 个服务器池，每个池 100 台机器，每台机器 100 个指标 => 约 1000 万个指标。
  - 1 年数据保留期。
  - 数据保留策略：7 天原始表单，30 天 1 分钟解析，1 年 1 小时解析。
- 可以监控各种指标，例如：
  - CPU 使用情况
  - 请求计数
  - 内存使用情况
  - 消息队列中的消息计数

### 非功能性要求

- 可扩展性：系统应具有可扩展性，以适应不断增长的指标和警报量。
- 低延迟：系统需要仪表板和警报具有低延迟。
- 可靠性：系统应高度可靠，以避免错过关键警报。
- 灵活性：技术不断变化，因此管道应该足够灵活，以便在未来轻松集成新技术。

哪些要求超出范围？

- 日志监控。Elasticsearch、Logstash、Kibana（ELK）堆栈在收集和监控日志方面非常流行 [4]。
- 分布式系统跟踪 [5] [6]。分布式跟踪是指在服务请求流经分布式系统时跟踪服务请求的跟踪解决方案。当请求从一个服务传递到另一个服务时，它会收集数据。

## 第 2 步 - 提出高级设计并获得认可

在本节中，我们将讨论构建系统的一些基本原理、数据模型和高级设计。

### 基础知识

度量监控和警报系统通常包含五个组件，如图5.2所示。

- 数据收集：收集来自不同来源的度量数据。
- 数据传输：将数据从源传输到度量监控系统。
- 数据存储：组织和存储传入的数据。
- 警报：分析传入数据、检测异常并生成警报。系统必须能够向不同的通信信道发送警报。
- 可视化：以图形、图表等形式呈现数据。当数据以可视化方式呈现时，工程师更善于识别模式、趋势或问题，因此我们需要可视化功能。

### 数据模型

度量数据通常记录为时间序列，其中包含一组具有相关时间戳的值。该系列本身可以通过其名称进行唯一标识，也可以选择通过一组标签进行标识。

让我们来看看两个例子。

#### 示例1：

20:00 生产服务器实例 i631 的 CPU 负载是多少？

图 5.3 中突出显示的数据点可由表 5.1 表示。

| metric_name | cpu_load            |
| ----------- | ------------------- |
| labels      | host:i631, env:prod |
| timestamp   | 1613707265          |
| value       | 0.29                |

在本例中，时间序列由度量名称、标签（host:i631，env:prod）和特定时间的单点值表示。

#### 示例 2：

过去 10 分钟，美国西部地区所有网络服务器的平均 CPU 负载是多少？从概念上讲，我们会从存储中提取这样的东西，其中度量名称为 `CPU.load`，区域标签为 `us-west`。

```
CPU.load host=webserver01,region=us-west 1613707265 50
CPU.load host=webserver01,region=us-west 1613707265 62
CPU.load host=webserver02,region=us-west 1613707265 43
CPU.load host=webserver02,region=us-west 1613707265 53
...
CPU.load host=webserver01,region=us-west 1613707265 76
CPU.load host=webserver01,region=us-west 1613707265 83
```
平均 CPU 负载可以通过平均每行末尾的值来计算。上述示例中的线路格式称为线路协议。它是市场上许多监控软件的常见输入格式。Prometheus [7] 和 OpenTSDB [8] 就是两个例子。

每个时间序列由以下内容组成 [9]：

| 名字                       | 类型                              |
| -------------------------- | --------------------------------- |
| 一个指标名                 | String                            |
| 一组标签/标志              | `<key:value>` 对的 List           |
| 一个值和它们的时间戳的数组 | `<value, timestamp>` 对的一个数组 |

### 数据访问模式

在图 5.4 中，y 轴上的每个标签代表一个时间序列（由名称和标签唯一标识），而 x 轴代表时间。

写入负载很重。正如您所看到的，在任何时刻都可以写入许多时间序列数据点。正如我们在第 132 页的“高级别需求”部分所提到的，每天大约有 1000 万个操作指标被写入，并且许多指标是以高频率收集的，因此流量无疑是巨大的。

同时，读取负载也很高。可视化和警报服务都会向数据库发送查询，根据图形和警报的访问模式，读取量可能是突发的。

换句话说，系统处于恒定的重写入负载下，而读取负载是尖峰的。

### 数据存储系统

数据存储系统是设计的核心。不建议为此工作构建自己的存储系统或使用通用存储系统（例如 MySQL [10]）。

理论上，通用数据库可以支持时间序列数据，但需要专家级的调整才能在我们的规模上工作。特别是，关系数据库并没有针对通常针对时间序列数据执行的操作进行优化。例如，计算滚动时间窗口中的移动平均值需要复杂的 SQL，这很难阅读（在深入部分有一个例子）。此外，为了支持标记/标记数据，我们需要为每个标记添加一个索引。此外，通用关系数据库在持续繁重的写负载下不能很好地执行。在我们的规模上，我们需要花费大量的精力来调优数据库，即使这样，它也可能表现不佳。

NoSQL 怎么样？理论上，市场上的一些 NoSQL 数据库可以有效地处理时间序列数据。例如，Cassandra 和 Bigtable [11] 都可以用于时间序列数据。然而，这需要对每个 NoSQL 的内部工作有深入的了解，才能设计出一个可扩展的模式来有效地存储和查询时间序列数据。由于工业规模的时间序列数据库很容易获得，使用通用的 NoSQL 数据库并不吸引人。

有许多可用的存储系统针对时间序列数据进行了优化。优化使我们能够使用更少的服务器来处理相同数量的数据。其中许多数据库还具有专门为分析时间序列数据而设计的自定义查询接口，这些查询接口比 SQL 更易于使用。有些甚至提供了管理数据保留和数据聚合的功能。以下是一些时间序列数据库的例子。

OpenTSDB 是一个分布式时间序列数据库，但由于它是基于 Hadoop 和 HBase 的，因此运行 Hadoop/HBase 集群会增加复杂性。Twitter 使用 MetricsDB [12]，亚马逊提供 Timestream 作为时间序列数据库 [13]。根据数据库引擎 [14]，最流行的两个时间序列数据库是 InfluxDB [15] 和 Prometheus，它们被设计用于存储大量的时间序列数据并快速对这些数据进行实时分析。两者都主要依赖于内存缓存和磁盘存储。它们的耐用性和性能都很好。如图 5.5 所示，一个拥有 8 个内核和 32GB RAM 的 InfluxDB 每秒可以处理超过 250000 次写入。

| vCPU 或 CPU | RAM       | IOPS       | 写每秒    | 查询每秒 | 独立组      |
| ----------- | --------- | ---------- | --------- | -------- | ----------- |
| 2 ~ 4 cores | 2 ~ 4 GB  | 500        | < 5,000   | < 5      | < 100,000   |
| 4 ~ 6 cores | 8 ~ 32 GB | 500 ~ 1000 | < 250,000 | < 25     | < 1,000,000 |
| 8+ cores    | 32+ GB    | 1000+      | > 250,000 | > 25     | > 1,000,000 |

由于时间序列数据库是一个专门的数据库，除非你在简历中明确提到，否则你不应该理解面试中的内部内容。为了进行采访，重要的是要理解度量数据本质上是时间序列的，我们可以选择 InfluxDB 等时间序列数据库进行存储。

强时间序列数据库的另一个特点是通过标签（在一些数据库中也称为标签）对大量时间序列数据进行有效的聚合和分析。例如，InfluxDB 在标签上构建索引，以方便标签快速查找时间序列 [15]。它提供了关于如何在不使数据库过载的情况下使用标签的明确最佳实践指南。关键是要确保每个标签的基数都很低（有一小组可能的值）。这个特性对于可视化是至关重要的，使用通用数据库构建这个特性需要花费大量精力。

### 高级设计

高级设计图如图 5.6 所示。

- **指标来源**。这可以是应用程序服务器、SQL数据库、消息队列等。
- **指标收集器**。它收集度量数据并将数据写入时间序列数据库。
- **时间序列数据库**。这将度量数据存储为时间序列。它通常提供一个自定义的查询接口，用于分析和汇总大量的时间序列数据。它在标签上维护索引，以便于按标签快速查找时间序列数据。
- **查询服务**。查询服务使查询和检索时间序列数据库中的数据变得容易。如果我们选择一个好的时间序列数据库，这应该是一个非常薄的包装。它也可以完全被时间序列数据库自己的查询接口所取代。
- **警报系统**。这将向各种警报目的地发送警报通知。
- **可视化系统**。这以各种图形/图表的形式显示度量。

## 第 3 步 - 深入设计

在系统设计面试中，候选人需要深入研究几个关键组件或流程。在本节中，我们将详细研究以下主题：

- 度量集合
- 扩展度量传输管道
- 查询服务
- 存储层
- 警报系统
- 可视化系统

### 度量集合

对于计数器或CPU使用率等指标收集，偶尔的数据丢失并不是世界末日。客户解雇并忘记是可以接受的。现在让我们来看看度量收集流程。系统的这一部分位于虚线框内（图 5.7）。

#### 拉 vs 推模式

有两种方法可以收集度量数据，拉式或推式。这是一场关于哪一个更好的例行辩论，没有明确的答案。让我们仔细看看。

##### 拉模型

图 5.8 显示了使用 HTTP 上的 pull 模型进行的数据收集。我们有专门的度量收集器，定期从运行的应用程序中提取度量值。

在这种方法中，度量收集器需要知道要从中提取数据的服务端点的完整列表。一种简单的方法是使用一个文件来保存“度量收集器”服务器上每个服务端点的 DNS/IP 信息。虽然这个想法很简单，但在频繁添加或删除服务器的大型环境中，这种方法很难维护，我们希望确保度量收集器不会错过从任何新服务器收集度量的机会。好消息是，我们有一个可靠、可扩展和可维护的解决方案，可通过服务发现获得，由 etcd [16]、ZooKeeper [17] 等提供，其中服务注册其可用性，并且每当服务端点列表发生变化时，服务发现组件都可以通知度量收集器。

服务发现包含关于何时何地收集度量的配置规则，如图 5.9 所示。

图 5.10 详细说明了拉模型。

1. 度量收集器从服务发现获取服务端点的配置元数据。元数据包括拉取间隔、IP 地址、超时和重试参数等。
2. 度量收集器通过预定义的 HTTP 端点（例如“/metrics”）提取度量数据。为了公开端点，通常需要将客户端库添加到服务中。在图 5.10 中，服务是 Web 服务器。
3. 可选地，度量收集器向服务发现注册改变事件通知，以在服务端点改变时接收更新。或者，度量收集器可以定期轮询端点更改。

按照我们的规模，单个指标收集器将无法处理数千台服务器。我们必须使用一组指标收集器来处理需求。当有多个收集器时，一个常见的问题是多个实例可能试图从同一资源中提取数据并产生重复的数据。为了避免这种情况，实例之间必须有一些协调方案。
一种潜在的方法是将每个收集器指定到一个一致的哈希环中的一个范围，然后将每个被监控的服务器映射到哈希环中其唯一名称。这确保了一个度量源服务器仅由一个收集器处理。让我们来看一个例子。

如图 5.11 所示，有四个收集器和六个度量源服务器。每个收集器负责从一组不同的服务器收集度量。收集器 2 负责从服务器 1 和服务器 5 收集度量。

##### 推送模型

如图 5.12 所示，在推送模型中，各种度量源，如 web 服务器、数据库服务器等，直接向度量收集器发送度量。

在推送模型中，收集代理通常安装在每个被监视的对象上。收集代理是一个长期运行的软件，它从服务器上运行的服务收集度量，并定期将这些度量推送给度量收集器。在将度量发送给度量收集器之前，收集代理还可以在本地聚合度量（尤其是简单计数器）。
聚合是减少发送到度量收集器的数据量的有效方法。如果推送流量很高，而度量收集器错误地拒绝推送，则代理可以在本地保留一个小的数据缓冲区（可能是通过将数据本地存储在磁盘上），然后重新发送。但是，如果服务器处于一个自动扩展组中，并且经常轮换，那么当度量收集器落后时，在本地（甚至是临时）保存数据可能会导致数据丢失。

为了防止度量收集器在推送模型中出现故障，度量收集器应位于前面有负载均衡器的自动扩展集群中（图 5.13）。集群应根据度量收集器服务器的 CPU 负载进行上下扩展。

##### 拉还是推？

那么，哪一个对我们来说是更好的选择呢？就像生活中的许多事情一样，没有明确的答案。双方都广泛采用了现实世界中的用例。

- 拉动式架构的例子包括 Prometheus。
- 推送架构的示例包括Amazon CloudWatch [18] 和 Graphite [19]。

了解每种方法的优缺点比在面试中挑选赢家更重要。表 5.3 比较了推拉架构 [20] [21] [22] [23] 的优缺点。

|                        | 拉                                                           | 推                                                           |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 易于调试               | 应用程序服务器上用于提取度量的 /metrics 端点可用于随时查看度量。你甚至可以在你的笔记本电脑上做到这一点。**拉获胜**。 |                                                              |
| 健康检查               | 如果应用程序服务器没有响应拉，您可以快速确定应用程序服务器是否已关闭。**拉获胜**。 | 如果度量收集器没有接收到度量，则问题可能是由网络问题引起的。 |
| 短期工作               |                                                              | 有些批处理工作可能是短暂的，而且持续时间不够长，无法被取消。**推获胜**。这可以通过为拉模型引入推送网关来解决 [24]。 |
| 防火墙或复杂的网络设置 | 让服务器提取度量要求所有度量端点都是可访问的。这在多个数据中心设置中可能存在问题。这可能需要更复杂的网络基础设施。 | 如果度量收集器设置有负载均衡器和自动缩放组，则可以从任何地方接收数据。**推获胜**。 |
| 性能                   | 拉方法通常使用 TCP。                                         | 推送方法通常使用 UDP。这意味着推送方法提供了较低延迟的度量传输。这里的反驳是，与发送度量有效载荷相比，建立 TCP 连接的工作量较小。 |
| 数据真实性             | 要从中收集度量的应用程序服务器预先在配置文件中定义。从这些服务器收集的度量保证是真实的。 | 任何类型的客户端都可以将度量推送到度量收集器。这可以通过将接受度量的服务器列入白名单或要求身份验证来解决。 |

如上所述，拉与推是一个常规的辩论话题，没有明确的答案。一个大型组织可能需要同时支持这两者，尤其是随着无服务器 [25] 的流行。可能没有办法安装一个代理，从中推送数据。

### 扩展度量传输管道

让我们放大度量收集器和时间序列数据库。无论您使用推送还是拉取模型，度量收集器都是一个服务器集群，集群接收大量数据。无论是推送还是拉取，度量收集器集群都设置为自动扩展，以确保有足够数量的收集器实例来处理需求。

但是，如果时间序列数据库不可用，则存在数据丢失的风险。为了缓解这个问题，我们引入了一个排队组件，如图 5.15 所示。

在这个设计中，度量收集器将度量数据发送到像 Kafka 这样的排队系统。然后，消费者或流处理服务，如 Apache Storm、Flink 和 Spark，处理数据并将其推送到时间序列数据库。这种方法有几个优点：

- Kafka 被用作一个高度可靠和可扩展的分布式消息平台。
- 它将数据收集和数据处理服务彼此解耦。
- 当数据库不可用时，通过将数据保留在Kafka中，它可以很容易地防止数据丢失。

#### 通过 Kafka 扩展

有几种方法可以利用 Kafka 内置的分区机制来扩展我们的系统。

- 根据吞吐量要求配置分区的数量。
- 按度量名称对度量数据进行分区，因此消费者可以按度量名称聚合数据。
- 使用标签/标签进一步划分度量数据。
- 对度量进行分类并排定优先级，以便可以首先处理重要的度量。

#### Kafka 的替代品

维持一个生产规模的 Kakfa 系统是一项不小的任务。你可能会遭到面试官的反驳。在不使用中间队列的情况下，存在正在使用的大规模监测摄取系统。Facebook 的 Gorilla [26] 内存时间序列数据库就是一个典型的例子；它被设计为即使在出现部分网络故障的情况下也能保持高度的写入可用性。可以说，这样的设计与拥有像 Kafka 这样的中间队列一样可靠。

#### 可能发生聚合的地方

指标可以在不同的地方进行汇总；在收集代理（客户端）、接收管道（写入存储之前）和查询端（写入存储之后）中。让我们仔细看看它们中的每一个。

**收款代理人**。客户端上安装的收集代理仅支持简单的聚合逻辑。例如，在将计数器发送到度量收集器之前，每分钟聚合一次计数器。

**摄入管道**。为了在写入存储之前聚合数据，我们通常需要Flink等流处理引擎。由于只将计算结果写入数据库，因此写入量将显著减少。然而，处理延迟到达的事件可能是一个挑战，另一个缺点是，由于不再存储原始数据，我们失去了数据精度和一些灵活性。

**查询端**。原始数据可以在查询时在给定的时间段内进行聚合。这种方法没有数据丢失，但查询速度可能较慢，因为查询结果是在查询时计算的，并且是针对整个数据集运行的。

### 查询服务

查询服务包括查询服务器集群，这些查询服务器访问时间序列数据库并处理来自可视化或警报系统的请求。拥有一组专用的查询服务器可以将时间序列数据库与客户端（可视化和警报系统）解耦。这使我们能够在需要时灵活地更改时间序列数据库或可视化和警报系统。

#### 缓存层

为了减少时间序列数据库的负载，提高查询服务的性能，增加了缓存服务器来存储查询结果，如图5.17所示。

#### 针对查询服务的案例

可能不需要引入我们自己的抽象（查询服务），因为大多数工业规模的视觉和警报系统都有强大的插件来与市场上著名的时间序列数据库对接。有了精心选择的时间序列数据库，也就不需要添加我们自己的缓存了。

#### 时间序列数据库查询语言

大多数流行的度量监控系统，如 Prometheus 和 InfluxDB，都不使用 SQL，而是有自己的查询语言。其中一个主要原因是很难构建 SQL 查询来查询时间序列数据。例如，正如这里提到的 [27]，在 SQL 中计算指数移动平均值可能如下所示：

```sql
select id,
	temp,
    avg(temp) over (partition by group_nr order by time_read) as rolling_avg
from (
	select id,
    	temp,
    	time_read,
    	interval_group,
    	id - row_number() over (partition by interval_group order by time_read) as group_nr
    from (
        select id,
        	time_read,
        	"epoch"::timestamp * "900 seconds"::interval * (extract(epoch from time_read)::int4 / 900) as interval_group,
        	temp
        from readings
    ) t1
) t2
order by time_read
```

而在 Flux 中，一种为时间序列分析优化的语言（在 InfluxDB 中使用），它看起来是这样的。正如你所看到的，它更容易理解。

```sql
from(db:"telegraf")
	|> range(start:-1h)
	|> filter(fn: (r)=>r.measurement=="foo")
	|> exponentialMovingAverage(size:-10s)
```

### 存储层

现在让我们深入了解存储层。

#### 仔细选择时间序列数据库

根据脸书发表的一篇研究论文 [26]，运营数据存储的所有查询中，至少 85% 是针对过去 26 小时内收集的数据。如果我们使用一个利用这一特性的时间序列数据库，它可能会对整个系统性能产生重大影响。如果您对存储引擎的设计感兴趣，请参阅 InfluxDB 存储引擎的文件 [28]。

#### 空间优化

正如高级需求中所解释的，要存储的度量数据量是巨大的。以下是解决这一问题的一些策略。

#### 数据编码和压缩

数据编码和压缩可以显著减小数据的大小。这些特征通常被构建到一个好的时间序列数据库中。这里有一个简单的例子。

如上图所示，1610087371 和 1610087381 仅相差 10 秒，这只需要 4 位来表示，而不是 32 位的完整时间戳。因此，不是存储绝对值，而是可以将值的增量与一个基本值一起存储，如：1610087371、10、10、9、11。

#### 下采样

下采样是将高分辨率数据转换为低分辨率以减少总体风险使用的过程。由于我们的数据保留期为1年，因此我们可以对旧数据进行下采样。例如，我们可以让工程师和数据科学家为不同的度量定义规则。以下是一个示例：

- 保留时间：7 天，不取样
- 保留时间：30 天，下采样至 1 分钟分辨率
- 保留时间：1 年，向下采样至 1 小时分辨率

让我们看看另一个具体的例子。它将 10 秒分辨率数据聚合为 30 秒分辨率数据。

| 指标 | 时间戳               | 主机名 | 指标值 |
| ---- | -------------------- | ------ | ------ |
| cpu  | 2021-10-24T19:00:00Z | host-a | 10     |
| cpu  | 2021-10-24T19:00:10Z | host-a | 16     |
| cpu  | 2021-10-24T19:00:20Z | host-a | 20     |
| cpu  | 2021-10-24T19:00:30Z | host-a | 30     |
| cpu  | 2021-10-24T19:00:40Z | host-a | 20     |
| cpu  | 2021-10-24T19:00:50Z | host-a | 30     |

从 10 秒分辨率数据汇总到 30 秒分辨率数据。

| 指标 | 时间戳               | 主机名 | 指标值（平均） |
| ---- | -------------------- | ------ | -------------- |
| cpu  | 2021-10-24T19:00:00Z | host-a | 19             |
| cpu  | 2021-10-24T19:00:30Z | host-a | 25             |

#### 冷存储

冷存储是指很少使用的非活动数据的存储。冷存储的财务成本要低得多。

简而言之，我们可能应该使用第三方可视化和警报系统，而不是构建自己的系统。

### 警报系统

为了面试的目的，让我们看看警报系统，如下图 5.19 所示。

警报流程的工作原理如下：

1. 将配置文件加载到缓存服务器。规则被定义为磁盘上的配置文件。YAML [29] 是一种常用的定义规则的格式。以下是警报规则的示例：

   ```yaml
   - name: instance_down
   rules:
   
   # Alert for any instance that is unreachable for >5 minutes
   - alert: instance_down
   	expr: up == 0
   	for: 5m
   	labels:
   	severity: page
   ```

2. 警报管理器从高速缓存中获取警报配置。

3. 根据配置规则，警报管理器以预定义的间隔调用查询服务。如果该值违反阈值，则会创建警报事件。警报经理负责以下工作：

   - 过滤、合并和重复数据消除警报。下面是一个合并短时间内在一个实例内触发的警报的示例（实例 1）（图 5.20）。
   - 访问控制。为了避免人为错误并确保系统安全，必须将某些警报管理操作的访问权限限制为仅限授权人员。
   - 重试。警报管理器检查警报状态，并确保至少发送一次通知。

4. 警报存储是一个键值数据库，如 Cassandra，用于保持所有警报的状态（非活动、挂起、启动、已解决）。它确保通知至少发送一次。

5. 在 Kafka 中插入符合条件的警报。

6. 提醒消费者从 Kafka 中提取提醒事件。

7. 警报消费者处理来自 Kafka 的警报事件，并通过电子邮件、短信、PagerDuty 或 HTTP 端点等不同渠道发送通知。

#### 警报系统 - 构建与购买

有许多现成的工业规模警报系统，大多数都与流行的时间序列数据库紧密集成。其中许多警报系统与现有的通知渠道（如电子邮件和 PagerDuty）集成良好。在现实世界中，很难证明建立自己的警报系统是合理的。在面试环境中，尤其是对于高级职位，要准备好为自己的决定辩护。

#### 可视化系统

可视化是建立在数据层之上的。度量可以在各种时间范围内显示在度量仪表板上，警报也可以显示在警报仪表板上。图 5.21 显示了一个仪表板，其中显示了一些指标，如当前服务器请求、内存/CPU 利用率、页面加载时间、流量和登录信息 [30]。

高质量的可视化系统很难构建。使用现成系统的理由非常充分。例如，Grafana 可以是一个非常好的系统。它与许多流行的时间序列数据库集成得很好，你可以买到。

## 第 4 步 - 总结

在本章中，我们介绍了度量监控和警报系统的设计。在高层次上，我们讨论了数据收集、时间序列数据库、警报和可视化。然后，我们深入探讨了一些最重要的技术/组件：

- 用于收集度量数据的推拉模型。
- 利用 Kafka 扩展系统。
- 选择正确的时间序列数据库。
- 使用下采样来减小数据大小。
- 警报和可视化系统的构建与购买选项。

我们经过了几次迭代来完善设计，最终设计如下：

祝贺你走到这一步！现在拍拍自己的背。干得好！

# 5 Metrics Monitoring and Alerting System

In this chapter, we explore the design of a scalable metrics monitoring and alerting system. A well-designed monitoring and alerting system plays a key role in providing clear visibility into the health of the infrastructure to ensure high availability and reliability.

Figure 5.1 shows some of the most popular metrics monitoring and alerting services in the marketplace. In this chapter, we design a similar service that can be used internally by a large company.

## Step 1 - Understand the Problem and Establish Design Scope

A metrics monitoring and alerting system can mean many different things to different companies, so it is essential to nail down the exact requirements first with interviewer. For example, you do not want to design a system that focus on logs such as web server error or access logs if the interviewer has only infrastructure metrics in mind.

Let's first fully understand the problem and establish the scope of the design before diving into the details.

**Candidate**: Who are we building the system for? Are we building an in-house system for a large corporation like Facebook or Google, or are we designing a SaaS service like Datadog [1], Splunk [2], etc?

**Interviewer**: That's a great question. We are building it for internal use only.

**Candidate**: Which metrics do we want to collect?

**Interviewer**: We want to collect operational system metrics. These can be low-level usage data of the operating system, such as CPU load, memory usage, and disk space consumption. They can also be high-level concepts such as requests per second of a service or the running server count of a web pool. Business metrics are not in the scope of this design.

**Candidate**: What is the scale of the infrastructure we are monitoring with this system?

**Interviewer**: 100 million daily active users, 1,000 server pools, and 100 machines per pool.

**Candidate**: How long should we keep the data?

**Interviewer**: Let's assume we want 1 year retention.

**Candidate**: May we reduce the resolution of the metrics data for long-term storage?

**Interviewer**: That's a great question. We would like to be able to keep newly received data for 7 days. After 7 days, you may roll them up to a 1 minute resolution for 30 days. After 30 days, you may further roll them up at 1 hour resolution.

**Candidate**: What are the supported alert channels?

**Interviewer**: Email, phone, PagerDuty [3], or webhooks (HTTP endpoints).

**Candidate**: Do we need to collect logs, such as error log or access log?

**Interviewer**: No.

**Candidate**: Do we need to support distributed system tracing?

**Interviewer**: No.

### High-level requirements and assumptions

Now you have finished gathering requirements from the interviewer and have a clear scope of the design. The requirements are:

- The infrastructure being monitored is large-scale.
  - 100 million daily active users.
  - Assume we have 1,000 server pools, 100 machines per pool, 100 metrics per machine => ~ 10 million metrics.
  - 1 year data retention.
  - Data retention policy: raw form for 7 days, 1 minute resolution for 30 days, 1 hour resolution for 1 year.
- A variety of metrics can be monitored, for example:
  - CPU usage
  - Request count
  - Memory usage
  - Message count in message queues

### Non-functional requirements

- Scalability: The system should be scalable to accommodate growing metrics and alert volume.
- Low latency: The system needs to have low latency for dashboards and alerts.
- Reliability: The system should be highly reliable to avoid missing critical alerts.
- Flexibility: Technology keeps changing, so the pipeline should be flexible enough to easily integrate new technologies in the future.

Which requirements are out of scope?

- Log monitoring. The Elasticsearch, Logstash, Kibana (ELK) stack is very popular for collecting and monitoring logs [4].
- Distributed system tracing [5] [6]. Distributed tracing refers to a tracing solution that tracks service requests as they flow through distributed systems. It collects data as requests go from one service to another.

## Step 2 - Propose High-level Design and Get Buy-in

In this section, we discuss some fundamentals of building the system, the data model, and the high-level design.

### Fundamentals

A metrics monitoring and alerting system generally contains five components, as illustrated in Figure 5.2.

- Data collection: collect metric data from different sources.
- Data transmission: transfer data from sources to the metrics monitoring system.
- Data storage: organize and store incoming data.
- Alerting: analyze incoming data, detect anomalies, and generate alerts. The system must be able to send alerts to different communication channels.
- Visualization: present data in graphs, charts, etc. Engineers are better at identifying patterns, trends, or problem when data is presented visually, so we need visualization functionality.

### Data model

Metrics data is usually recorded as a time series that contains a set of values with their associated timestamps. The series itself can be uniquely identified by its name, and optionally by a set of labels.

Let's take a look at two examples.

#### Example 1:

What is the CPU load on production server instance i631 at 20:00?

The data point highlighted in Figure 5.3 can be represented by Table 5.1.

| metric_name | cpu_load            |
| ----------- | ------------------- |
| labels      | host:i631, env:prod |
| timestamp   | 1613707265          |
| value       | 0.29                |

In this example, the time series is represented by the metric name, the labels (host:i631, env:prod), and a single point value at a specific time.

#### Example 2:

What is the average CPU load across all web servers in the us-west region for the last 10 minutes? conceptually, we would pull up something like this from storage where the metrics name is `CPU.load` and the region label is us-west.

```
CPU.load host=webserver01,region=us-west 1613707265 50
CPU.load host=webserver01,region=us-west 1613707265 62
CPU.load host=webserver02,region=us-west 1613707265 43
CPU.load host=webserver02,region=us-west 1613707265 53
...
CPU.load host=webserver01,region=us-west 1613707265 76
CPU.load host=webserver01,region=us-west 1613707265 83
```

The average CPU load could be computed by averaging the values at the end of each line. The format of the lines in the above example is called the line protocol. It is a common input format for many monitoring software in the market. Prometheus [7] and OpenTSDB [8] are two examples.

Every time series consists of the following [9]:

| Name                                    | Type                                   |
| --------------------------------------- | -------------------------------------- |
| A metric name                           | String                                 |
| A set of tags/labels                    | List of `<key:value>` pairs            |
| An array of values and their timestamps | An array of `<value, timestamp>` pairs |

### Data access pattern

In Figure 5.4, each label on the y-axis represents a time series (uniquely identified by the names and labels) while the x-axis represents time.

The write load is heavy. As you can see, there can be many time-series data points written at any moment. As we mentioned in the "High-level requirements" section on page 132, about 10 million operational metrics are written per day, and many metrics are collected at high frequency, so the traffic is undoubtedly write-heavy.

At the same time, the read load is spiky. Both visualization and alerting services send queries to the database, and depending on the access patterns of the graphs and alerts, the read volume could be bursty.

In other words, the system is under constant heavy write load, while the read load is spiky.

### Data storage system

The data storage system is the heart of the design. It's not recommended to build your own storage system or use a general-purpose storage system (for example, MySQL [10]) for this job.

A general-purpose database, in theory, could support time-series data, but it would require expert-level tuning to make it work at our scale. Specially, a relational database is not optimized for operations you would commonly perform against time-series data. For example, computing the moving average in a rolling time window requires complicated SQL that is difficult to read (there is an example of this in the deep dive section). Besides, to support tagging/labeling data, we need to add an index for each tag. Moreover, a general-purpose relational database does not perform well under constant heavy write load. At our scale, we would need to expend significant effort in tuning the database, and even then, it might not perform well.

How about NoSQL? In theory, a few NoSQL databases on the market could handle time-series data effectively. For example, Cassandra and Bigtable [11] can both be used for time series data. However, this would require deep knowledge of the internal workings of each NoSQL to devise a scalable schema for effectively storing and querying time-series data. With industrial-scale time-series databases readily available, using a general-purpose NoSQL database is not appealing.

There are many storage systems available that are optimized for time-series data. The optimization lets us use far fewer servers to handle the same volume of data. Many of these databases also have custom query interfaces specially designed for the analysis of time-series data that are much easier to use than SQL. Some even provide features to manage data retention and data aggregation. Here are a few examples of time-series databases.

OpenTSDB is a distributed time-series database, but since it is based on Hadoop and HBase, running a Hadoop/HBase cluster adds complexity. Twitter uses MetricsDB [12], and Amazon offers Timestream as a time-series database [13]. According to DB-engines [14], the two most popular time-series databases are InfluxDB [15] and Prometheus, which are designed to store large volumes of time-series data and quickly perform real-time analysis on that data. Both of them primarily rely on an in-memory cache and on-disk storage. And they both handle durability and performance quite well. As shown in Figure 5.5, an InfluxDB with 8 cores and 32GB RAM can handle over 250,000 writes per second.

| vCPU or CPU | RAM       | IOPS       | Writes per second | Queries per second | Unique series |
| ----------- | --------- | ---------- | ----------------- | ------------------ | ------------- |
| 2 ~ 4 cores | 2 ~ 4 GB  | 500        | < 5,000           | < 5                | < 100,000     |
| 4 ~ 6 cores | 8 ~ 32 GB | 500 ~ 1000 | < 250,000         | < 25               | < 1,000,000   |
| 8+ cores    | 32+ GB    | 1000+      | > 250,000         | > 25               | > 1,000,000   |

Since a time-series database is a specialized database, you are not expected to understand the internals in an interview unless you explicitly mentioned it in your resume. For the purpose of an interview, it's important to understand the metrics data are time-series in nature and we can select time-series databases such as InfluxDB for storage to store them.

Another feature of a strong time-series database is efficient aggregation and analysis of a large amount of time-series data by labels, also known as tags in some databases. For example, InfluxDB builds indexes on labels to facilitate the fast lookup of time-series by labels [15]. It provides clear best-practice guidelines on how to use labels, without overloading the database. The key is to make sure each label is of low cardinality (having a small set of possible values). This feature is critical for visualization, and it would take a lot of effort to build this with a general-purpose database.

### High-level design

The high-level design diagram is shown in Figure 5.6.

- **Metrics source**. This can be application servers, SQL databases, message queues, etc.
- **Metrics collector**. It gathers metrics data and writes data into the time-series database.
- **Time-series database**. This stores metrics data as time series. It usually provides a custom query interface for analyzing and summarizing a large amount of time-series data. It maintains indexes on labels to facilitate the fast lookup of time-series data by labels.
- **Query service**. The query service makes it easy to query and retrieve data from the time-series database. This should be a very thin wrapper if we choose a good time-series database. It could also be entirely replaced by the time-series database's own query interface.
- **Alerting system**. This sends alert notifications to various alerting destinations.
- **Visualization system**. This shows metrics in the form of various graphs/charts.

## Step 3 - Design Deep Dive

In a system design interview, candidates are expected to dive deep into a few key components or flows. In this section, we investigate the following topics in detail:

- Metrics collection
- Scaling the metrics transmission pipeline
- Query service
- Storage layer
- Alerting system
- Visualization system

### Metrics collection

For metrics collection like counters or CPU usage, occasional data loss is not the end of the world. It's acceptable for clients to fire and forget. Now let's take a look at the metrics collection flow. This part of the system is inside the dashed box (Figure 5.7).

#### Pull vs push models

There are two ways metrics data can be collected, pull or push. It is a routine debate as to which one is better and there is no clear answer. Let's take a close look.

##### Pull model

Figure 5.8 shows data collection with a pull model over HTTP. We have dedicated metric collectors which pull metrics values from the running applications periodically.

In this approach, the metrics collector needs to know the complete list of service end-points to pull data from. One naive approach is to use a file to hold DNS/IP information for every service endpoint on the "metric collector" servers. While the idea is simple, this approach is hard to maintain in a large-scale environment where servers are added or removed frequently, and we want to ensure that metric collectors don't miss out on collecting metrics from any new servers. The good news is that we have a reliable, scalable, and maintainable solution available through Service Discovery, provided by etcd [16], ZooKeeper [17], etc., wherein services register their availability and the metrics collector can be notified by the Service Discovery component whenever the list of service endpoints changes.

Service discovery contains configuration rules about when and where to collect metrics as shown in Figure 5.9.

Figure 5.10 explains the pull model in detail.

1. The metrics collector fetches configuration metadata of service endpoints from Service Discovery. Metadata include pulling interval, IP addresses, timeout and retry parameters, etc.
2. The metrics collector pulls metrics data via a pre-defined HTTP endpoint (for example, `/metrics`). To expose the endpoint, a client library usually needs to be added to the service. In Figure 5.10, the service is Web Servers.
3. Optionally, the metrics collector registers a change event notification with Service Discovery to receive an update whenever the service endpoints change. Alternatively, the metrics collector can poll for endpoint changes periodically.

At our scale, a single metrics collector will not be able to handle thousands of servers. We must use a pool of metrics collectors to handle the demand. One common problem when there are multiple collectors is that multiple instances might try to pull data from the same resource and produce duplicate data. There must exist some coordination scheme among the instances to avoid this.

One potential approach is to designate each collector to a range in a consistent hash ring, and then map every single server being monitored by its unique name in the hash ring. This ensures one metrics source server is handled by one collector only. Let's take a look at an example.

As shown in Figure 5.11, there are four collectors and six metrics source servers. Each collector is responsible for collecting metrics from a distinct set of servers. Collector 2 is responsible for collecting metrics from Server 1 and Server 5.

##### Push model

As shown in Figure 5.12, in a push model various metrics sources, such as web servers, database servers, etc., directly send metrics to the metrics collector.

In a push model, a collection agent is commonly installed on every being monitored. A collection agent is a piece of long-running software that collects metrics from the services running on the server and pushes those metrics periodically to the metrics collectors. The collection agent may also aggregate metrics (especially a simple counter) locally, before sending them to metric collectors.

Aggregation is an effective way to reduce the volume of data sent to the metrics collector. If the push traffic is high and the metrics collector rejects the push with an error, the agent could keep a small buffer of data locally (possibly by storing them locally on disk), and resend them later. However, if the servers are in an auto-scaling group where they are rotated out frequently, then holding data locally (even temporarily) might result in data loss when the metrics collector falls behind.

To prevent the metrics collector from failing behind in a push model, the metrics collector should be in an auto-scaling cluster with a load balancer in front of it (Figure 5.13). The cluster should scale up and down based on the CPU load of the metric collector servers.

##### Pull or push?

So, which one is the better choice for us? Just like many things in life, there is no clear answer. Both sides have widely adopted real-world use cases.

- Examples of pull architectures include Prometheus.
- Examples of push architectures include Amazon CloudWatch [18] and Graphite [19].

Knowing the advantages and disadvantages of each approach is more important than picking a winner during an interview. Table 5.3 compares the pros and cons of push and pull architectures [20] [21] [22] [23].

|                                        | Pull                                                         | Push                                                         |
| -------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Easy debugging                         | The /metrics endpoint on application servers used for pulling metrics can be used to view metrics at any time. You can even do this on your laptop. **Pull wins**. |                                                              |
| Health check                           | If an application server doesn't respond to the pull, you can quickly figure out if an application server is down. **Pull wins**. | If the metrics collector doesn't receive metrics, the problem might be caused by network issues. |
| Short-lived jobs                       |                                                              | Some of the batch jobs might be short-lived and don't last long enough to be pulled. **Push wins**. This can be fixed by introducing push gateways for the pull model [24]. |
| Firewall or complicated network setups | Having servers pulling metrics requires all metric endpoints to be reachable. This is potentially problematic in multiple data center setups. It might require a more elaborate network infrastructure. | If the metrics collector is set up with a load balancer and an auto-scaling group, it is possible to receive data from anywhere. **Push wins**. |
| Performance                            | Pull methods typically use TCP.                              | Push methods typically use UDP. This means the push method provides lower-latency transports of metrics. The counterargument here is that the effort of establishing a TCP connection is small compared to sending the metrics payload. |
| Data authenticity                      | Application servers to collect metrics from are defined in config files in advance. Metrics gathered from those servers are guaranteed to be authentic. | Any kind of client can push metrics to the metrics collector. This can be fixed by whitelisting servers from which to accept metrics, or by requiring authentication. |

As mentioned above, pull vs push is a routine debate topic and there is no clear answer. A large organization probably needs to support both, especially with the popularity of serverless [25] these days. There might not be a way to install an agent from which to push data in the first place.

### Scale the metrics transmission pipeline

Let's zoom in on the metrics collector and time-series databases. Whether you use the push or pull model, the metrics collector is a cluster of servers, and the cluster receives enormous amounts of data. For either push or pull, the metrics collector cluster is set up for auto-scaling, to ensure that there are an adequate number of collector instances to handle the demand.

However, there is a risk of data loss if the time-series database is unavailable. To mitigate this problem, we introduce a queueing component as shown in Figure 5.15.

In this design, the metrics collector sends metrics data to queuing systems like Kafka. Then consumers or streaming processing services such as Apache Storm, Flink, and Spark, process and push data to the time-series database. This approach has several advantages:

- Kafka is used as a highly reliable and scalable distributed messaging platform.
- It decouples the data collection and data processing services from each other.
- It can easily prevent data loss when the database is unavailable, by retaining the data in Kafka.

#### Scale through Kafka

There are a couple of ways that we can leverage Kafka's built-in partition mechanism to scale our system.

- Configure the number of partitions based on throughput requirements.
- Partition metrics data by metric names, so consumers can aggregate data by metrics names.
- Further partition metrics data with tags/labels.
- Categorize and prioritize metrics so that important metrics can be processed first.

#### Alternative to Kafka

Maintaining a production-scale Kafka system is no small undertaking. You might get pushback from the interviewer about this. There are large-scale monitoring ingestion systems in use without using an intermediate queue. Facebook's Gorilla [26] in-memory time-series database is a prime example; it is designed to remain highly available for writes, even when there is a partial network failure. It could be argued that such a design is as reliable as having an intermediate queue like Kafka.

#### Where aggregations can happen

Metrics can be aggregated in different places; in the collection agent (on the client-side), the ingestion pipeline (before writing to storage), and the query side (after writing to storage). Let's take a closer look at each of them.

**Collection agent**. The collection agent installed on the client-side only supports simple aggregation logic. For example, aggregate a counter every minute before it is sent to the metrics collector.

**Ingestion pipeline**. To aggregate data before writing to the storage, we usually need stream processing engines such as Flink. The write volume will be significantly reduced since only the calculated result is written to the database. However, handling late-arriving events could be a challenge and another downside is that we lose data precision and some flexibility because we no longer store the raw data.

**Query side**. Raw data can be aggregated over a given time period at query time. There is no data loss with this approach, but the query speed might be slower because the query result is computed at query time and is run against the whole dataset.

### Query service

The query service comprises a cluster of query servers, which access the time-series databases and handle requests from the visualization or alerting systems. Having a dedicated set of query servers decouples time-series databases from the clients (visualization and alerting systems). And this gives us the flexibility to change the time-series database or the visualization and alerting systems, whenever needed.

#### Cache layer

To reduce the load of the time-series database and make query service more performant, cache servers are added to store query results, as shown in Figure 5.17.

#### The case against query service

There might not be a processing need to introduce our own abstraction (a query service) because most industrial-scale visual and alerting systems have powerful plugins to interface with well-known time-series databases on the market. And with a well-chosen time-series database, there is no need to add our own caching, either.

#### Time-series database query language

Most popular metrics monitoring systems like Prometheus and InfluxDB don't use SQL and have their own query languages. One major reason for this is that it is hard to build SQL queries to query time-series data. For example, as mentioned here [27], computing an exponential moving average might look like this in SQL:

```sql
select id,
	temp,
    avg(temp) over (partition by group_nr order by time_read) as rolling_avg
from (
	select id,
    	temp,
    	time_read,
    	interval_group,
    	id - row_number() over (partition by interval_group order by time_read) as group_nr
    from (
        select id,
        	time_read,
        	"epoch"::timestamp * "900 seconds"::interval * (extract(epoch from time_read)::int4 / 900) as interval_group,
        	temp
        from readings
    ) t1
) t2
order by time_read
```

While in Flux, a language that's optimized for time-series analysis (used in InfluxDB), it looks like this. As you can see, it's much easier to understand.

```sql
from(db:"telegraf")
	|> range(start:-1h)
	|> filter(fn: (r)=>r.measurement=="foo")
	|> exponentialMovingAverage(size:-10s)
```

### Storage layer

Now let's dive into the storage layer.

#### Choose a time-series database carefully

According to a research paper published by Facebook [26], at least 85% of all queries to the operational data store were for data collected in the past 26 hours. If we use a time-series database that harnesses this property, it could have a significant impact on overall system performance. If you are interested in the design of the storage engine, please refer to the design document of the InfluxDB storage engine [28].

#### Space optimization

As explained in high-level requirements, the amount of metric data to store is enormous. Here are a few strategies for tackling this.

#### Data encoding and compression

Data encoding and compression can significantly reduce the size of data. Those features are usually built into a good time-series database. Here is a simple example.

As you can see in the image above, 1610087371 and 1610087381 differ by only 10 seconds, which takes only 4 bits to represent, instead of the full timestamp of 32 bits. So, rather than storing absolute values, the delta of the values can be stored along with one base value like: 1610087371, 10, 10, 9, 11.

#### Downsampling

Downsampling is the process of converting high-resolution data to low-resolution to reduce overall risk usage. Since our data retention is 1 year, we can downsample old data. For example, we can let engineers and data scientists define rules for different metrics. Here is an example:

- Retention: 7 days, no sampling
- Retention: 30 days, downsampling to 1 minute resolution
- Retention: 1 year, downsample to 1 hour resolution

Let's take a look at another concrete example. It aggregates 10-second resolution data to 30-second resolution data.

| metric | timestamp            | hostname | metric_value |
| ------ | -------------------- | -------- | ------------ |
| cpu    | 2021-10-24T19:00:00Z | host-a   | 10           |
| cpu    | 2021-10-24T19:00:10Z | host-a   | 16           |
| cpu    | 2021-10-24T19:00:20Z | host-a   | 20           |
| cpu    | 2021-10-24T19:00:30Z | host-a   | 30           |
| cpu    | 2021-10-24T19:00:40Z | host-a   | 20           |
| cpu    | 2021-10-24T19:00:50Z | host-a   | 30           |

Rollup from 10 second resolution data to 30 second resolution data.

| metric | timestamp            | hostname | Metric_value(avg) |
| ------ | -------------------- | -------- | ----------------- |
| cpu    | 2021-10-24T19:00:00Z | host-a   | 19                |
| cpu    | 2021-10-24T19:00:30Z | host-a   | 25                |

#### Cold storage

Cold storage is the storage of inactive data that is rarely used. The financial cost for cold storage is much lower.

In a nutshell, we should probably use third-party visualization and alerting systems, instead of building our own.

### Alerting system

For the purpose of the interview, let's look at the alerting system, shown in Figure 5.19 below.

The alert flow works as follows:

1. Load config files to cache servers. Rules are defined as config files on the disk. YAML [29] is a commonly used format to define rules. Here is an example of alert rules:
   ```yaml
   - name: instance_down
   rules:
   
   # Alert for any instance that is unreachable for >5 minutes
   - alert: instance_down
   	expr: up == 0
   	for: 5m
   	labels:
   	severity: page
   ```

2. The alert manager fetches alert configs from the cache.

3. Based on config rules, the alert manager calls the query service at a predefined interval. If the value violates the threshold, an alert event is created. The alert manager is responsible for the following:

   - Filter, merge, and dedupe alerts. Here is an example of merging alerts that are triggered within one instance within a short amount of time (instance 1) (Figure 5.20).
   - Access control. To avoid human error and keep the system secure, it is essential to restrict access to certain alert management operations to authorized individuals only.
   - Retry. The alert manager checks alert states and ensures a notification is sent at least once.

4. The alert store is a key-value database, such as Cassandra, that keeps the state (inactive, pending, firing, resolved) of all alerts. It ensures a notification is sent at least once.

5. Eligible alerts are inserted into Kafka.

6. Alert consumers pull alert events from Kafka.

7. Alert consumers process alert events from Kafka and send notifications over to different channels such as email, text message, PagerDuty, or HTTP endpoints.

#### Alerting system - build vs buy

There are many industrial-scale alerting systems available off-the-shelf, and most provide tight integration with the popular time-series databases. Many of these alerting systems integrate well with existing notification channels, such as email and PagerDuty. In the real world, it is a tough call to justify building your own alerting system. In interview settings, especially for a senior position, be ready to justify you decision.

#### Visualization system

Visualization is built on top of the data layer. Metrics can be shown on the metrics dashboard over various time scales and alerts can be shown on the alerts dashboard. Figure 5.21 shows a dashboard that displays some of the metrics like the current server requests, memory/CPU utilization, page load time, traffic, and login information [30].

A high-quality visualization system is hard to build. The argument for using an off-the-shelf system is very strong. For example, Grafana can be a very good system for this purpose. It integrates well with many popular time-series databases which you can buy.

## Step 4 - Wrap Up

In this chapter, we presented the design for a metrics monitoring and alerting system. At a high level, we talked about data collection, time-series database, alerts, and visualization. Then we went in-depth into some of the most important techniques/components:

- Push vs pull model for collecting metrics data.
- Utilize Kafka to scale the system.
- Choose the right time-series database.
- Use downsampling to reduce data size.
- Build vs buy options for alerting and visualization systems.

We went through a few iterations to refine the design, and our final design looks like this:

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 6 Ad Click Event Aggregation

With the rise of Facebook, YouTube, TikTok, and the online media economy, digital advertising is taking an ever-bigger share of the total advertising spending. As a result, tracking ad click events is very important. In this chapter, we explore how to design an ad click event aggregation system at Facebook or Google scale.

Before we dive into technical design, let's learn about the core concepts of online advertising to better understand this topic. One core benefit of online advertising is its measurability, as quantified by real-time data.

Digital advertising has a core process called Real-Time Bidding (RTB), in which digital advertising inventory is bought and sold. Figure 6.1 shows how the online advertising process works.

The speed of the RTB process is important as it usually occurs in less than a second.

Data accuracy is also very important. Ad click event aggregation plays a critical role in measuring the effectiveness of online advertising, which essentially impacts how much money advertisers pay. Based on the click aggregation results, campaign managers can control the budget or adjust bidding strategies, such as changing targeted audience groups, keywords, etc. The key metrics used in online advertising, including click-through rate (CTR) [1] and conversion rate (CVR) [2], depend on aggregated ad click data.

## Step 1 - Understand the Problem and Establish Design Scope

The following set of questions helps to clarify requirements and narrow down the scope.

**Candidate**: What is the format of the input data?

**Interviewer**: It's a log file located in different servers and the latest click events are appended to the end of the log file. The event has the following attributes: `ad_id`, `click_timestamp`, `user_id`, `ip` and `country`.

**Candidate**: What's the data volume?

**Interviewer**: 1 billion ad clicks per day and 2 million ads in total. The number of ad click events grows 30% year-over-year.

**Candidate**: What are some of the most important queries to support?

**Interviewer**: The system needs to support the following 3 queries:

- Return the number of click events for a particular ad in the last M minutes.
- Return the top 100 most clicked ads in the past 1 minute. Both parameters should be configurable. Aggregation occurs every minute.
- Support data filtering by `ip`, `user_id`, or `country` for the above two queries.

**Candidate**: Do we need to worry about edge cases? I can think of the following:

- There might be events that arrive later than expected.
- There might be duplicated events.
- Different parts of the system might be down at any time, so we need to consider system recovery.

**Interviewer**: That's a good list. Yes, take these into consideration.

**Candidate**: What is the latency requirement?

**Interviewer**: A few minutes of end-to-end latency. Note that latency requirements for RTB and ad click aggregation are very different. While latency for RTB is usually less than one second due to the responsiveness requirement, a few minutes of latency is acceptable for ad click event aggregation because it is primarily used for ad billing and reporting.

With the information gathered above, we have both functional and non-functional requirements.

### Functional requirements

- Aggregate the number of clicks of `ad_id` in the last M minutes.
- Return the top 100 most clicked `ad_id` every minute.
- Support aggregation filtering by different attributes.
- Dataset volume is at Facebook or Google scale (see the back-of-envelope estimation section below for detailed system scale requirements).

### Non-functional requirements

- Correctness of the aggregation result is important as the data is used for RTB and ads billing.
- Properly handle delayed or duplicate events.
- Robustness. The system should be resilient to partial failures.
- Latency requirement. End-to-end latency should be a few minutes, at most.

### Back-of-the-envelop estimation

Let's do an estimation to understand the scale of the system and the potential challenges we will need to address.

- 1 billion DAU (Daily Active Users).
- Assume on average each user clicks 1 ad per day. That's 1 billion ad click events per day.
- Ad click QPS = $\frac{10^9 \text{ events}}{10^5\text{ seconds in a day}}$ = 10,000
- Assume peak ad click QPS is 5 times the average number. Peak QPS = 50,000 QPS.
- Assume a single ad click event occupies 0.1 KB storage. Daily storage requirement is: 0.1 KB * 1 billion = 100 GB. The monthly storage requirement is about 3TB.

## Step 2 - Propose High-level Design and Get Buy-in

In this section, we discuss query API design, data model, and high-level design.

### Query API design

The purpose of the API design is to have an agreement between the client and the server. In a consumer app, a client is usually the end-user who uses the product. In our case, however, a client is the dashboard user (data scientist, product manager, advertiser, etc.) who runs queries against the aggregation service.

Let's review the functional requirements so we can better design the APIs:

- Aggregate the number of clicks of `ad_id` in the last M minutes.
- Return the top N most clicked `ad_ids` in the last M minutes.
- Support aggregation filtering by different attributes.

We only need two APIs to support those three use cases because filtering (the last requirement) can be supported by adding query parameters to the requests.

#### API 1: Aggregate the number of clicks of `ad_id` in the last M minutes

| API                                   | Detail                                          |
| ------------------------------------- | ----------------------------------------------- |
| GET /v1/ads/{:ad_id}/aggregated_count | Return aggregated event count for a given ad_id |

Request parameters are:

| Field  | Description                                                  | Type |
| ------ | ------------------------------------------------------------ | ---- |
| from   | Start minute (default is now minus 1 minute)                 | long |
| to     | End minute (default is now)                                  | long |
| filter | An identifier for different filtering strategies. For example, `filter = 001`  filters out non-US clicks | long |

Response:

| Field | Description                                            | Type   |
| ----- | ------------------------------------------------------ | ------ |
| ad_id | The identifier of the ad                               | string |
| count | The aggregated count between the start and end minutes | long   |

#### API 2: Return top N most clicked ad_ids in the last M minutes

| API                     | Detail                                              |
| ----------------------- | --------------------------------------------------- |
| GET /v1/ads/popular_ads | Return top N most clicked ads in the last M minutes |

Request parameters are:

| Field  | Description                                      | Type |
| ------ | ------------------------------------------------ | ---- |
| from   | Start minute (default is now minus 1 minute)     | long |
| to     | End minute (default is now)                      | long |
| filter | An identifier for different filtering strategies | long |

Response:

| Field  | Description                    | Type  |
| ------ | ------------------------------ | ----- |
| ad_ids | A list of the most clicked ads | array |

### Data model

There are two types of data in the system: raw data and aggregated data.

#### Raw data

Below shows what the raw data looks like in log files:

`[AdClickEvent] ad001, 2021-01-01 00:00:01, user 1, 207.148.22.22, USA`

Table 6.7 lists what the data fields look like in a structured way. Data is scattered on different application servers.

| ad_id | click_timestamp     | user_id | ip            | country |
| ----- | ------------------- | ------- | ------------- | ------- |
| ad001 | 2021-01-01 00:00:01 | user1   | 207.148.22.22 | USA     |
| ad001 | 2021-01-01 00:00:02 | user1   | 207.148.22.22 | USA     |
| ad002 | 2021-01-01 00:00:02 | user2   | 209.153.56.11 | USA     |

#### Aggregated data

Assume that ad click events are aggregated every minute. Table 6.8 shows the aggregated result.

| ad_id | click_minute | count |
| ----- | ------------ | ----- |
| ad001 | 202101010000 | 5     |
| ad001 | 202101010001 | 7     |

To support ad filtering, we add an additional field called `filter_id` to the table. Records with the same `ad_id` and `click_minute` are grouped by `filter_id` as shown in Table 6.9, and filters are defined in Table 6.10.

| ad_id | click_minute | filter_id | count |
| ----- | ------------ | --------- | ----- |
| ad001 | 202101010000 | 0012      | 2     |
| ad001 | 202101010000 | 0023      | 3     |
| ad001 | 202101010001 | 0012      | 1     |
| ad001 | 202101010001 | 0023      | 6     |

| filter_id | region | ip   | user_id   |
| --------- | ------ | ---- | --------- |
| 0012      | US     | 0012 | *         |
| 0013      | *      | 0023 | 123.1.2.3 |

To support the query to return the top N most clicked ads in the last M minutes, the following structure is used.

|                    |           |                                              |
| ------------------ | --------- | -------------------------------------------- |
| window_size        | integer   | The aggregation window size in minutes       |
| update_time_minute | timestamp | Last updated timestamp in minute granularity |
| most_clicked_ads   | array     | List of ad IDs in JSON format                |

#### Comparison

The comparison between storing raw data and aggregated data is shown below:

|      | Raw data only                                              | Aggregated data only                                         |
| ---- | ---------------------------------------------------------- | ------------------------------------------------------------ |
| Pros | - Full data set<br>- Support data filter and recalculation | - Smaller data set<br>- Fast query                           |
| Cons | - Huge data storage<br>- Slow query                        | - Data loss. This is derrived data. For example, 10 entries might be aggregated to 1 entry. |

Should we store raw data or aggregated data? Our recommendation is to store both. Let's take a look at why:

- It's a good idea to keep the raw data. If something goes wrong, we could use the raw data for debugging. If the aggregated data is corrupted due to a bad bug, we can recalculate the aggregated data from the raw data, after the bug is fixed.
- Aggregated data should be stored as well. The data size of the raw data is huge. The large size makes querying raw data directly very inefficient. To mitigate this problem, we run read queries on aggregated data.
- Raw data serves as backup data. We usually don't need to query raw data unless recalculation is needed. Old raw data could be moved to cold storage to reduce costs.
- Aggregated data serves as active data. It is turned for query performance.

### Choose the right database

When it comes to choosing the right database, we need to evaluate the following:

- What does the data look like? Is the data relational? Is it a document or a blob?
- Is the workflow read-heavy, write-heavy, or both?
- Is transaction support needed?
- Do the queries rely on many online analytical processing (OLAP) funcations [3] like SUM, COUNT?

Let's examine the raw data first. Even though we don't need to query the raw data during normal operations, it is useful for data scientists or machine learning engineers to study user response prediction, behavioral targeting, relevance feedback, etc. [4].

As shown in the back of the envelope estimation, the average write QPS is 10,000, and the peak QPS can be 50,000, so the system is write-heavy. On the read side, raw data is used as backup and a source for recalculation, so in theory, the read volume is low.

Relational databases can do the job, but scaling the write can be challenging. NoSQL databases like Cassandra and InfluxDB are more suitable because they are optimized for write and time-range queries.

Another option is to store the data in Amazon S3 using one of the columnar data formats like ORC [5], Parquet [6], or AVRO [7]. We could put a cap on the size of each file (say, file rotation when the size cap is reached. Since this setup may be unfamiliar for many, in this design we use Cassandra as an example).

For aggregated data, it is time-series in nature and the workflow is both read and write heavy. This is because, for each ad, we need to query the database every minute to display the latest aggregation count for customers. This feature is useful for auto-refreshing the dashboard or triggering alerts in a timely manner. Since there are two million ads in total, the workflow is read-heavy. Data is aggregated and written every minute by the aggregation service, so it's write-heavy as well. We could use the same type of database to store both raw data and aggregated data.

Now we have discussed query API design and data model, let's put together the high-level design.

### High-level design

In real-time big data [8] processing, data usually flows into and out of the processing system as unbounded data streams. The aggregation service works in the same way; the input is the raw data (unbounded data streams), and the output is the aggregated results (see Figure 6.2).

#### Asynchronous processing

The design we currently have is synchronous. This is not good because the capacity of producers and consumers is not always equal. Consider the following case; if there is a sudden increase in traffic and the number of events produced is far beyond what consumers can handle, consumers might get out-of-memory errors or experience an unexpected shutdown. If one component in the synchronous link is down, the whole system stops working.

A common solution is to adopt a message queue (Kafka) to decouple producers and consumers. This makes the whole process asynchronous and producers/consumers can be scaled independently.

Putting everything we have discussed together, we come up with the high-level design as shown in Figure 6.3. Log watcher, aggregation service, and database are decoupled by two message queues. The database writer polls data from the message queue, transforms the data into the database format, and writes it to the database.

What is stored in the first message queue? It contains ad click event data as shown in Table 6.13.

| ad_id | click_timestamp | user_id | ip   | country |
| ----- | --------------- | ------- | ---- | ------- |

What is stored in the second message queue? The second message queue contains two types of data:

1. Ad click counts aggregated at per-minute granularity.

   | ad_id | click_minute | count |
   | ----- | ------------ | ----- |

2. Top N most clicked ads aggregated at per-minute granularity.

   | update_time_minute | most_clicked_ads |
   | ------------------ | ---------------- |

You might be wondering why we don't write the aggregated results to the database directly. The short answer is that we need the second message queue like Kafka to achieve end-to-end exactly once semantics (atomic commit) [9].

Next, let's dig into the details of the aggregation service.

#### Aggregation service

The MapReduce framework is a good option to aggregate ad click events. The directed acyclic graph (DAG) is a good model for it [10]. The key to the DAG model is to break down the system into small computing units, like the Map/Aggregate/Reduce nodes, as shown in Figure 6.5.

Each node is responsible for one single task and it sends the processing result to its downstream nodes.

##### Map node

A Map node reads from a data source, and then filters and transforms the data. For example, a Map node sends ads with ad_id % 2 = 0 to node 1, and the other ads go to node 2, as shown in Figure 6.6.

You might be wondering why we need the Map node. An alternative option is to set up Kafka partitions or tags and let the aggregate nodes subscribe to Kafka directly. This works, but the input data may need to be cleaned or normalized, and these operations can be done by the Map node. Another reason is that we may not have control over how data is produced and therefore events with the same `ad_id` might land in different Kafka partitions.

##### Aggregate node 

An Aggregate node counts ad click events by `ad_id` in memory every minute. In the MapReduce paradigm, the Aggregate node is part of the Reduce. So the map-aggregate-reduce process really means map-reduce-reduce.

##### Reduce node

A Reduce node reduces aggregated results from all "Aggregate" nodes to the final result. For example, as shown in Figure 6.7, there are three aggregation nodes and each contains the top 3 most clicked ads within the node. The Reduce node reduces the total number of most clicked ads to 3.

The DAG model represents the well-known MapReduce paradigm. It is designed to take big data and use parallel distributed computing to turn big data into little- or regular-sized data.

In the DAG model, intermediate data can be stored in memory and different nodes communicate with each other through either TCP (nodes running in different processes) or shared memory (nodes running in different threads).

### Main use cases

Now that we understand how MapReduce works at the high level, let's take a look at how it can be utilized to support the main use cases:

- Aggregate the number of clicks of `ad_id` in the last M mins.
- Return top N most clicked `ad_ids` in the last M minutes.
- Data filtering.

#### Use case 1: aggregate the number of clicks

As shown in Figure 6.8, input events are partitioned by `ad_id` (`ad_id` % 3) in Map nodes and are then aggregated by Aggregation nodes.

#### Use case 2: return top N most clicked ads

Figure 6.9 shows a simplified design of getting the top 3 most clicked ads, which can be extended to top N. Input events are mapped using ad_id and each Aggregate node maintains a heap data structure to get the top 3 ads within the node efficiently. In the last step, the Reduce node reduces 9 ads (top 3 from each aggregate node) to the top 3 most clicked ads every minute.

#### Use case 3: data filtering

To support data filtering like "show me the aggregated click count for ad001 within the USA only", we can pre-define filtering criteria and aggregate based on them. For example, the aggregation results look like this for ad001 and ad002:

| ad_id | click_minute | country | count |
| ----- | ------------ | ------- | ----- |
| ad001 | 202101010001 | USA     | 100   |
| ad001 | 202101010001 | GPB     | 200   |
| ad001 | 202101010001 | others  | 3000  |
| ad002 | 202101010001 | USA     | 10    |
| ad002 | 202101010001 | GPB     | 25    |
| ad002 | 202101010001 | others  | 12    |

This technique is called the star schema [11], which is widely used in data warehouses. The filtering fields are called dimensions. This approach has the following benefits:

- It is simple to understand and build.
- The current aggregation service can be reused to create more dimensions in the star schema. No additional component is needed.
- Accessing data based on filtering criteria is fast because the result is pre-calculated.

A limitation with this approach is that it creates many more buckets and records, especially when we have a lot of filtering criteria.

## Step 3 - Design Deep Dive

In this section, we will dive deep into the following:

- Streaming vs batching
- Time and aggregation window
- Delivery guarantees
- Scale the system
- Data monitoring and correctness
- Final design diagram
- Fault tolerance

### Streaming vs batching

The high-level architecture we proposed in Figure 6.3 is a type of stream processing system. Table 6.17 shows the comparison of three types of system [12]:

|                         | Services (Online system)      | Batch system (offline system)                          | Streaming system (near real-time system)     |
| ----------------------- | ----------------------------- | ------------------------------------------------------ | -------------------------------------------- |
| Responsiveness          | Respond to the client quickly | No response to the client needed                       | No response to the client needed             |
| Input                   | User requests                 | Bounded input with finite size. A large amount of data | Input has no boundary (infinite streams)     |
| Output                  | Responses to clients          | Materialized views, aggregated metrics, etc.           | Materialized views, aggregated metrics, etc. |
| Performance measurement | Availability, latency         | Throughput                                             | Throughput, latency                          |
| Example                 | Online shopping               | MapReduce                                              | Flink [13]                                   |

In our design, both stream processing and batch processing are used. We utilized stream processing to process data as it arrives and generates aggregated results in a near real-time fashion. We utilized batch processing for historical data backup.

For a system that contains two processing paths (batch and streaming) simultaneously, this architecture is called lambda [14]. A disadvantage of lambda architecture is that you have two processing paths, meaning there are two codebases to maintain. Kappa architecture [15], which combines the batch and streaming in one processing path, solves the problem. The key idea is to handle both real-time data processing and continuous data reprocessing using a single stream processing engine. Figure 6.10 shows a comparison of lambda and kappa architecture.

Our high-level design uses Kappa architecture, where the reprocessing of historical data also goes through the real-time aggregation service. See the "Data recalculation" section below for details.

#### Data recalculation

Sometimes we have to recalculate the aggregated data, also called historical data replay. For example, if we discover a major bug in the aggregation service, we would need to recalculate the aggregated data from raw data starting at the point where the bug was introduced. Figure 6.11 shows the data recalculation flow:

1. The recalculation service retrieves data from raw data storage. This is a batched job.
2. Retrieved data is sent to a dedicated aggregation service so that the real-time processing is not impacted by historical data relay.
3. Aggregated results are sent to the second message queue, then updated in the aggregation database.

The recalculation process reuses the data aggregation service but uses a different data source (the raw data).

### Time

We need a timestamp to perform aggregation. The timestamp can be generated in two different places:

- Event time: when an ad click happens.
- Processing time: refers to the system time of the aggregation server that processes the click event.

Due to network delays and asynchronous environments (data go through a message queue), the gap between event time and processing time can be large. As shown in Figure 6.12, event 1 arrives at the aggregation service very late (5 hours later).

If event time is used for aggregation, we have to deal with delayed events. If processing time is used for aggregation, the aggregation result may not be accurate. There is no perfect solution, so we need to consider the trade-offs.

|                 | Pros                                                         | Cons                                                         |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Event time      | Aggregation results are more accurate because the client knows exactly when an ad is clicked | It depends on the timestamp generated on the client-side. Clients might have the wrong time, or the timestamp might be generated by malicious users |
| Processing time | Server timestamp is more reliable                            | The timestamp is not accurate if an event reaches the system at a much later time. |

Since data accuracy is very important, we recommend using event time for aggregation. How do we properly process delayed events in this case? A technique called "watermark" is commonly utilized to handle slightly delayed events.

In Figure 6.13, ad click events are aggregated in the one-minute tumbling window (see the "Aggregation window" section on page 177 for more details). If event time is used to decide whether the event is in the window, window 1 misses event 2, and window 3 misses event 5.

The value set for the watermark depends on the business requirement. A long watermark could catch events that arrive very late, but it adds more latency to the system. A short watermark means data is less accurate, but it adds less latency to the system.

Notice that the watermark technique does not handle events that have long delays. We can argue that it is not worth the return on investment (ROI) to have a complicated design for low probability events. We can always correct the tiny bit of inaccuracy with end-of-day reconciliation (see "Reconciliation" section on page 189). One trade-off to consider is that using watermark improves data accuracy but increases overall latency, due to extended wait time.

### Aggregation window

According to the "Designing data-intensive applications" book by Martin Kleppmann [16], there are four types of window functions: tumbling window (also called fixed window), hopping window, sliding window, and session window. We will discuss the tumbling window and sliding window as they are most relevant to our system.

In the tumbling window (highlighted in Figure 6.15), time is partitioned into same-length, non-overlapping chunks. The tumbling window is a good fit for aggregating ad click events every minute (use case 1).

In the sliding window (highlighted in Figure 6.16), events are grouped within a window that slides across the data stream, according to a specified interval. A sliding window can be an overlapping one. This is a good strategy to satisfy our second use case; to get the top N most clicked ads during the last M minutes.

### Delivery guarantees

Since the aggregation result is utilized for billing, data accuracy and completeness are very important. The system needs to be able to answer questions such as:

- How to avoid processing duplicate events?
- How to ensure all events are processed?

Message queues such as Kafka usually provide three delivery semantics: at-most once, at-least once, and exactly once.

#### Which delivery method should we choose?

In most circumstances, at-least once processing is good enough if a small percentage of duplicates are acceptable.

However, this is not the case for our system. Differences of a few percent in data points could result in discrepancies of millions of dollars. Therefore, we recommend exactly-once delivery for the system. If you are interested in learning more about a real-life ad aggregation system, take a look at how Yelp implements it [17].

#### Data deduplication

One of the most common data quality issues is duplicated data. Duplicated data can come from a wide range of sources and in this section, we discuss two common sources.

- Client-side. For example, a client might resend the same event multiple times. Duplicated events sent with malicious intent are best handled by ad fraud/risk control components. If this is of interest, please refer to the reference material [18].
- Server outage. If an aggregation service node goes down in the middle of aggregation and the upstream service hasn't yet received an acknowledgement, the same events might be sent and aggregated again. Let's take a closer look.

Figure 6.17 shows how the aggregation service node (Aggregator) outage introduces duplicate data. The aggregator manages the status of data consumption by storing the offset in upstream Kafka.

If step 6 fails, perhaps due to Aggregator outage, events from 100 to 110 are already sent to the downstream, but the new offset 110 is not persisted in upstream Kafka. In this case, a new Aggregator would consume again from offset 100, even if those events are already processed, causing duplicate data.

The most straightforward solution (Figure 6.18) is to use external file storage, such as HDFS or S3, to record the offset. However, this solution has issues as well.

In step 3, the aggregator will process events from offset 100 to 110, only if the last offset stored in external storage is 100. If the offset stored in the storage is 110, the aggregator ignores events before offset 110.

But this design has a major problem: the offset is saved to HDFS or S3 (step 3.2) before the aggregation result is sent downstream. If step 4 fails due to Aggregator outage, events from 100 to 110 will never be processed by a newly brought up aggregator node, since the offset stored in external storage is 110.

To avoid data loss, we need to save the offset once we get an acknowledgement back from downstream. The updated design is shown in Figure 6.19.

In this design, if the Aggregator is down before step 5.1 is executed, events from 100 to 110 will be sent downstream again. To achieve exactly once processing, we need to put operations between step 4 to step 6 in one distributed transaction. A distributed transaction is a transaction that works across several nodes. If any of the operations fails, the whole transaction is rolled back.

As you can see, it's not easy to dedupe data in large-scale systems. How to achieve exactly-once processing is an advanced topic. If you are interested in the details, please refer to reference material [9].

### Scale the system

From the back-of-the-envelope estimation, we know the business grows 30% per year, which doubles traffic every 3 years. How do we handle this growth? Let's take a look.

Our system consists of three independent components: message queue, aggregation service, and database. Since these components are decoupled, we can scale each one independently.

#### Scale the message queue

We have already discussed how to scale the message queue extensively in the "Distributed Message Queue" chapter, so we'll only briefly touch on a few points.

**Producers**. We don't limit the number of producer instances, so the scalability of producers can be easily achieved.

**Consumers**. Inside a consumer group, the rebalancing mechanism helps to scale the consumers by adding or removing nodes. As shown in Figure 6.21, by adding two more consumers, each consumer only processes events from one partition.

When there are hundreds of Kafka consumers in the system, consumer rebalance can be quite slow and could take a few minutes or even more. Therefore, if more consumers need to be added, try to do it during off-peak hours to minimize the impact.

#### Brokers

- **Hashing key**
  Using `ad_id` as hashing key for Kafka partition to store events from the same `ad_id` in the same Kafka partition. In this case, an aggregation service can subscribe to all events of the same `ad_id` from one single partition.

- **The number of partitions**
  If the number of partitions changes, events of the same `ad_id` might be mapped to a different partition. Therefore, it's recommended to pre-allocate enough partitions in advance, to avoid dynamically increasing the number of partitions in production.

- **Topic physical sharding**

  One single topic is usually not enough. We can split the data by geography (`topic_north_america`, `topic_europe`, `topic_asia`, etc.) or by business type (`topic_web_ads`, `topic_mobile_ads`, etc).

  - Pros: Slicing data to different topics can help increase the system throughput. With fewer consumers for a single topic, the time to rebalance consumer groups is reduced.
  - Cons: It introduces extra complexity and increases maintenance costs.

#### Scale the aggregation service

In the high-level design, we talked about the aggregation service being a map/reduce operation. Figure 6.22 shows how things are wired together.

If you are interested in the details, please refer to reference material [19]. Aggregation service is horizontally scalable by adding or removing nodes. Here is an interesting question; how do we increase the throughput of the aggregation service? There are two options.

Option 1: Allocate events with different `ad_ids` to different threads, as shown in Figure 6.23.

Option 2: Deploy aggregation service nodes on resource providers like Apache Hadoop YARN [20]. You can think of this approach as utilizing multi-processing.

Option 1 is easier to implement and doesn't depend on resource providers. In reality, however, option 2 is more widely used because we can scale the system by adding more computing resources.

#### Scale the database

Cassandra natively supports horizontal scaling, in a way similar to consistent hashing.

Data is evenly distributed to every node with a proper replication factor. Each node saves its own part of the ring based on hashed value and also saves copies from other virtual nodes.

If we add a new node to the cluster, it automatically rebalances the virtual nodes among all nodes. No manual resharding is required. See Cassandra's official documentation for more details [21].

#### Hotspot issue

A shard or service that receives much more data than the others is called a hotspot. This occurs because major companies have advertising budgets in the millions of dollars and their ads are clicked more often. Since events are partitioned by `ad_id`, some aggregation service nodes might receive many more ad click events than others, potentially causing server overload.

This problem can be mitigated by allocating more aggregation nodes to process popular ads. Let's take a look at an example as shown in Figure 6.25. Assume each aggregation node can handle only 100 events.

1. Since there are 300 events in the aggregation node (beyond the capacity of a node can handle), it applies for extra resources through the resource manager.
2. The resource manager allocates more resources (for example, add two more aggregation nodes) so the original aggregation node isn't overloaded.
3. The original aggregation node split events into 3 groups and each aggregation node handles 100 events.
4. The result is written back to the original aggregate node.

There are more sophisticated ways to handle this problem, such as Global-Local Aggregation or Split Distinct Aggregation. For more information, please refer to [22].

### Fault tolerance

Let's discuss the fault tolerance of the aggregation service. Since aggregation happens in memory, when an aggregation node goes down, the aggregated result is lost as well. We can rebuild the count by replaying events from upstream Kafka brokers.

Replaying data from the beginning of Kafka is slow. A good practice is to save the "system status" like upstream offset to a snapshot and recover from the last saved status. In our design, the "system status" is more than just the upstream offset because we need to store data like top N most clicked ads in the past M minutes.

Figure 6.26 shows a simple example of what the data looks like in a snapshot.

With a snapshot, the failover process of the aggregation service is quite simple. If one aggregation service node fails, we bring up a new node and recover data from the latest snapshot (Figure 6.27). If there are new events that arrive after the last snapshot was taken, the new aggregation node will pull those data from the Kafka broker for replay.

### Data monitoring and correctness

As mentioned earlier, aggregation results can be used for RTB and billing purposes. It's critical to monitor the system's health and to ensure correctness.

#### Continuous monitoring

Here are some metrics we might want to monitor:

- Latency. Since latency can be introduced at each stage, it's invaluable to track timestamps as events flow through different parts of the system. The differences between those timestamps can be exposed as latency metrics.
- Message queue size. If there is a sudden increase in queue size, we may need to add more aggregation nodes. Notice that Kafka is a message queue implemented as a distributed commit log, so we need to monitor the records-lag metrics instead.
- System resources on aggregation nodes: CPU, disk, JVM, etc.

#### Reconciliation

Reconciliation means comparing different sets of data in order to ensure data integrity. Unlike reconciliation in the banking industry, where you can compare your records with the bank's records, the result of ad click aggregation has no third-party result to reconcile with.

What we can do is to sort the ad click events by event time in every partition at the end of the day, by using a batch job and reconciling with the real-time aggregation result. If we have higher accuracy requirements, we can use a smaller aggregation window; for example, one hour. Please note, no matter which aggregation window is used, the result from the batch job might not match exactly with the real-time aggregation result, since some events might arrive late (see "Time" section on page 175).

Figure 6.28 shows the final design diagram with reconciliation support.

#### Alternative design

In a generalist system design interview, you are not expected to know the internals of different pieces of specialized software used in a big data pipeline. Explaining your thought process and discussing trade-offs is very important, which is why we propose a generic solution. Another option is to store ad click data in Hive, with an ElasticSearch layer built for faster queries. Aggregation is usually done in OLAP databases such as ClickHouse [23] or Druid [24]. Figure 6.29 shows the architecture.

For more detail on this, please refer to reference material [25].

## Step 4 - Wrap Up

In this chapter, we went through the process of designing an ad click event aggregation system at the scale of Facebook or Google. We covered:

- Data model and API design.
- Use MapReduce paradigm to aggregate ad click events.
- Scale the message queue, aggregation service, and database.
- Mitigate hotspot issue.
- Monitor the system continuously.
- Use reconciliation to ensure correctness.
- Fault tolerance.

The ad click event aggregation system is a typical big data processing system. It will be easier to understand and design if you have prior knowledge or experience with industry-standard solutions such as Apache Kafka, Apache Flink, or Apache Spark.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 7 Hotel Reservation System



# 11 Payment System

In this chapter, we design a payment system. E-commerce has exploded in popularity across the world in recent years. What makes every transaction possible is a payment system running behind the scene. A reliable, scalable, and flexible payment system is essential.

What is a payment system? According to Wikipedia, "a payment system is any system used to settle financial transactions through the transfer of monetary value. This includes the institutions, instruments, people, rules, procedures, standards, and technologies that make its exchange possible" [1].

A payment system is easy to understand on the surface but is also intimidating for many developers to work on. A small slip could potentially cause significant revenue loss and destroy credibility among users. But fear not! In this chapter, we demystify payment systems.

## Step 1 - Understand the Problem and Establish Design Scope

A payment system can mean very different things to different people. Some may think it's a digital wallet like Apple Pay or Google Pay. Others may think it's a backend system that handles payments such as PayPal or Stripe. It is very important to determine the exact requirements at the beginning of the interview. These are some questions you can ask the interviewer:

**Candidate**: What kind of payment system are we building?

**Interviewer**: Assume you are building a payment backend for an e-commerce application like Amazon.com. When a customer places an Amazon.com, the payment system handles everything related to money movement.

**Candidate**: What payment options are supported? Credit cards, PayPal, bank cards, etc?

**Interviewer**: The payment system should support all of these options in real life. However, in this interview, we can use credit card payment as an example.

**Candidate**: Do we handle credit card payment processing ourselves?

**Interviewer**: No, we use third-party payment processors, such as Stripe, Braintree, Square, etc.

**Candidate**: Do we store credit card data in our system?

**Interviewer**: Due to extremely high security and compliance requirements, we do not store card numbers directly in our system. We rely on third-party payment processors to handle sensitive credit card data.

**Candidate**: Is the application global? Do we need to support different currencies and international payments?

**Interviewer**: Great question. Yes, the application would be global but we assume only one currency is used in this interview.

**Candidate**: How many payment transactions per day?

**Interviewer**: 1 million transactions per day.

**Candidate**: Do we need to support the pay-out flow, which an e-commerce site like Amazon uses to pay sellers every month?

**Interviewer**: Yes, we need to support that.

**Candidate**: I think I have gathered all the requirements. Is there anything else I should pay attention to?

**Interviewer**: Yes. A payment system interacts with a lot of internal services (accounting, analytics, etc.) and external services (payment service providers). When a service fails, we may see inconsistent states among services. Therefore, we need to perform reconciliation and fix any inconsistencies. This is also a requirement.



With these questions, we get a clear picture of both the functional and non-functional requirements. In this interview, we focus on designing a payment system that supports the following.

### Functional requirements

- Pay-in flow: payment system receives money from customers on behalf of sellers.
- Pay-out flow: payment system sends money to sellers around the world.

### Non-functional requirements

- Reliability and fault tolerance. Failed payments need to be carefully handled.
- A reconciliation process between internal services (payment systems, accounting systems) and external services (payment service providers) is required. The process asynchronously verifies that the payment information across these systems is consistent.

### Back-of-the-envelope estimation

The system needs to process 1 million transactions per day, which is 1,000,000 transactions / 10^5 seconds = 10 transactions per second (TPS). 10 TPS is not a big number for a typical database, which means the focus of this system design interview is on how to correctly handle payment transactions, rather than aiming for high throughput.

## Step 2 - Propose High-level Design and Get Buy-in

At a high level, the payment flow is broken down into two steps to reflect how {} flows:

- Pay-in flow
- Pay-out flow

Take the e-commerce site, Amazon, as an example. After a buyer places a {} money flows into Amazon's bank account, which is the pay-in flow. Althoug{} is in Amazon's bank account, Amazon does not own all of the money. Th{} a substantial part of it and Amazon only works as the money custodian fo{} when the products are delivered and money is released, the balance after f{} from Amazon's bank account to the seller's bank account. This is the pay{} simplified pay-in and pay-out flows are shown in Figure 11.1.

### Pay-in flow

The high-level design diagram for the pay-in flow is shown in Figure 11.2, Let's take a look each component of the system.

#### Payment service

The payment service accepts payment events from users and coordinates the payment process. The first thing it usually does is a risk check, assessing for compliance with regulations such as AML/CFT [2], and for evidence of criminal activity such as money laundering or financing of terrorism. The payment service only processes payments that pass this risk check. Usually, the risk check service uses a third-party provider because it is very complicated and highly specialized.

#### Payment executor

The payment executor executes a single payment order via a Payment Service Provider (PSP). A payment event may contain several payment orders.

#### Payment Service Provider (PSP)

A PSP moves money from account A to account B. In this simplified example, the PSP moves the money out of the buyer's credit card account.

#### Card schemes

Card schemes are the organizations that process credit card operations. Well known card schemes are Visa, MasterCard, Discovery, etc. The card scheme ecosystem is very complex [3].

#### Ledger

The ledger keeps a financial record of the payment transaction. For example, when a user pays the seller `$1`, we record it as debit `$1` from the user and credit `$1` to the seller. The ledger system is very important in post-payment analysis, such as calculating the total revenue of the e-commerce website or forecasting future revenue.

#### Wallet

The wallet keeps the account balance of the merchant. It may also record how much a given user has paid in total.

As shown in Figure 11.2, a typical pay-in flow works like this:

1. When a user clicks the "place order" button, a payment event is generated and sent to the payment service.
2. The payment service stores the payment event in the database.
3. Sometimes, a single payment event may contain several payment orders. For example, you may select products from multiple sellers in a single checkout process. If the e-commerce website splits the checkout into multiple payment orders, the payment service calls the payment executor for each payment order.
4. The payment executor stores the payment order in the database.
5. The payment executor calls an external PSP to process the credit card payment.
6. After the payment executor has successfully processed the payment, the payment service updates the wallet to record how much money a given seller has.
7. The wallet server stores the updated balance information in the database.
8. After the wallet service has successfully updated the seller's balance information, the payment service calls the ledger to update it.
9. The ledger service appends the new ledger information to the database.

### APIs for payment service

We use the RESTful API design convention for the payment service.

#### POST /v1/payments

This endpoint executes a payment event. As mentioned above, a single payment event may contain multiple payment orders. The request parameters are listed below:

| Field            | Description                                                  | Type   |
| ---------------- | ------------------------------------------------------------ | ------ |
| buyer_info       | The information of the buyer                                 | json   |
| checkout_id      | A globally unique ID for this checkout                       | string |
| credit_card_info | This could be encrypted credit card information or a payment token. The value is PSP-specific | json   |
| payment_orders   | A list of the payment orders                                 | list   |

The `payment_orders` look like this:

| Field            | Description                           | Type                  |
| ---------------- | ------------------------------------- | --------------------- |
| seller_account   | Which seller will receive the money   | string                |
| amount           | The transaction amount for the order  | string                |
| currency         | The currency for the order            | string（ISO 4217[4]） |
| payment_order_id | A globally unique ID for this payment | string                |

Note that the `payment_order_id` is globally unique. When the payment executor sends a payment request to a third-party PSP, the `payment_order_id` is used by the PSP as the deduplication ID, also called the idempotency key.

You may have noticed that the data type of the "amount" field is "string", rather than "double". Double is not a good choice because:

1. Different protocols, software, and hardware may support different numeric precisions in serialization and deserialization. This difference might cause unintended rounding errors.
2. The number could be extremely big (for example, Japan's GDP is around 5 * 10^14 yen for the calendar year 2020), or extremely small (for example, a satoshi of Bitcoin is 10^-8).

It is recommended to keep numbers in string format during transmission and storage. They are only parsed to numbers when used for display or calculation.

#### GET /v1/payments/{:id}

This endpoint returns the execution status of a single payment order based on `payment_order_id`.

The payment API mentioned above is similar to the API of some well-known PSPs. If you are interested in a more comprehensive view of payment APIs, check out Stripe's API documentation [5].

### The data model for payment service

We need two tables for the payment service: payment event and payment order. When we select a storage solution for a payment system, performance is usually not the most important factor. Instead, we focus on the following:

1. Proven stability. Whether the storage system has been used by other big financial firms for many years (for example more than 5 years) with positive feedback.
2. The richness of supporting tools, such as monitoring and investigation tools.
3. Maturity of the database administrator (DBA) job market. Whether we can recruit experienced DBAs is a very important factor to consider.

Usually, we prefer a traditional relational database with ACID transaction support over NoSQL/NewSQL.

The payment event table contains detailed payment event information. This is what it looks like:

| Name             | Type                         |
| ---------------- | ---------------------------- |
| checkout_id      | string **PK**                |
| buyer_info       | string                       |
| seller_info      | string                       |
| credit_card_info | depends on the card provider |
| is_payment_done  | boolean                      |

The payment order table stores the execution status of each payment order. This is what it looks like:

| Name                 | Type          |
| -------------------- | ------------- |
| payment_order_id     | String **PK** |
| buyer_account        | string        |
| amount               | string        |
| currency             | string        |
| checkout_id          | string **FK** |
| payment_order_status | string        |
| ledger_updated       | boolean       |
| wallet_updated       | boolean       |

Before we dive into the tables, let's take a look at some background information.

- The `checkout_id` is the foreign key. A single checkout creates a payment event that may contain several payment orders.
- When we call a third-party PSP to deduct money from the buyer's credit card, the money is not directly transferred to the seller. Instead, the money is transferred to the e-commerce website's bank account. This process is called pay-in. When the pay-out condition is satisfied, such as when the products are delivered, the seller initiates a pay-out. Only then is the money transferred from the e-commerce website's bank account to the seller's bank account. Therefore, during the pay-in flow, we only need the buyer's card information, not the seller's bank account information.

In the payment order table (Table 11.4), `payment_order_status` is an enumerated type(enum) that keeps the execution status of the payment order. Execution status includes `NOT_STARTED`, `EXECUTING`, `SUCCESS`, `FAILED`. The update logic is:

1. The initial status of `payment_order_status` is `NOT_STARTED`.
2. When the payment service sends the payment order to the payment executor, the `payment_order_status` is `EXECUTING`.
3. The payment service updates the `payment_order_status` to `SUCCESS` or `FAILED` depending on the response of the payment executor.

Once the `payment_order_status` is `SUCCESS`, the payment service calls the wallet service to update the seller balance and update the `wallet_updated` field to `TRUE`. Here we simplify the design by assuming wallet updates always succeed.

Once it is done, the next step for the payment service is to call the ledger service to update the ledger database by updating the `ledger_updated` field to `TRUE`.

When all payment orders under the same `checkout_id` are processed successfully, the payment service updates the `is_payment_done` to `TRUE` in the payment event table. A scheduled job usually runs at a fixed interval to monitor the status of the in-flight payment orders. It sends an alert when a payment order does not finish within a threshold so that engineers can investigate it.

### Double-entry ledger system

There is a very important design principle in the ledger system: the double-entry principle (also called double-entry accounting/bookkeeping [6]). Double-entry system is fundamental to any payment system and is key to accurate bookkeeping. It records every payment transaction into two separate ledger accounts with the same amount. One account is debited and the other is credited with the same amount (Table 11.5).

The double-entry system states that the sum of all the transaction entries must be 0. One cent lost means someone else gains a cent. It provides end-to-end traceability and ensures consistency throughout the payment cycle. To find out more about implementing the double-entry system, see Square's engineering blog about immutable double-entry accounting database service [7].

### Hosted payment page

Most companies prefer not to store credit card information internally because if they do, they have to deal with complex regulations such as Payment Card Industry Data Security Standard (PCI DSS) [8] in the United States. To avoid handling credit card information, companies use hosted credit card pages provided by PSPs. For websites, it is a widget or an iframe, while for mobile applications, it may be a pre-built page from the payment SDK. Figure 11.3 illustrates an example of the checkout experience with PayPal integration. The key point here is that the PSP provides a hosted payment page that captures the customer card information directly, rather than relying on our payment service.

### Pay-out flow

The components of the pay-out flow are very similar to the pay-in flow. One difference is that instead of using PSP to move money from the buyer's credit card to the e-commerce website's bank account, the pay-out flow uses a third-party pay-out provider to move money from the e-commerce website's bank account to the seller's bank account.

Usually, the payment system uses third-party account payable providers like Tipalti [9] to handle pay-outs. There are a lot of bookkeeping and regulatory requirements with pay-outs as well.

## Step 3 - Design Deep Dive

In this section, we focus on making the system faster, more robust, and secure. In a distributed system, errors and failures are not only inevitable but common. For example, what happens if a customer pressed the "pay" button multiple times? Will they be charged multiple times? How do we handle payment failures caused by poor network connections? In this section, we dive deep into several key topics.

- PSP integration
- Reconciliation
- Handling payment processing delays
- Communication among internal services
- Handling failed payments
- Exact-once delivery
- Consistency
- Security

### PSP integration

If the payment system can directly connect to banks or card schemes such as Visa or MasterCard, payment can be made without a PSP. These direct connections are uncommon and highly specialized. They are usually reserved for really large companies that can justify such an investment. For most companies, the payment system integrates with a PSP instead, in one of two ways:

1. If a company can safely store sensitive payment information and chooses to do so, PSP can be integrated using API. The company is responsible for developing the payment web pages, collecting and storing sensitive payment information. PSP is responsible for connecting to banks or card schemes.
2. If a company chooses not to store sensitive payment information due to complex regulations and security concerns, PSP provides a hosted payment page to collect card payment details and securely store them in PSP. This is the approach most companies take.

We use Figure 11.4 to explain how the hosted payment page works in detail.

We omitted the payment executor, ledger, and wallet in Figure 11.4 for simplicity. The payment service orchestrates the whole payment process.

1. The user clicks the "checkout" button in the client browser. The client calls the payment service with the payment order information.
2. After receiving the payment order information, the payment service sends a payment registration request to the PSP. This registration request contains payment information, such as the amount, currency, expiration date of the payment request, and the redirect URL. Because a payment order should be registered only once, there is a UUID field to ensure the exactly-once registration. This UUID is also called nonce [10]. Usually, this UUID is the ID of the payment order.
3. The PSP returns a token back to the payment service. A token is a UUID on the PSP side that uniquely identifies the payment registration. We can examine the payment registration and the payment execution status later using this token.
4. The payment service stores the token in the database before calling the PSP-hosted payment page.
5. Once the token is persisted, the client displays a PSP-hosted payment page. Mobile applications usually use the PSP's SDK integration for this functionality. Here we use Stripe's web integration as an example (Figure 11.5). Stripe provides a JavaScript calls the PSP directly to complete the payment. Sensitive payment information is collected by Stripe. It never reaches our payment system. The hosted payment page usually needs two pieces of information:
   - The token we received in step 4. The PSP's javascript code uses the token to retrieve detailed information about the payment request from the PSP's backend. One important piece of information is how much money to collect.
   - Another important piece of information is the redirect URL. This is the web page URL that is called when the payment is complete. When the PSP's JavaScript finishes the payment, it redirects the browser to the redirect URL. Usually, the redirect URL is an e-commerce web page that shows the status of the checkout. Note that the redirect URL is different from the webhook [11] URL in step 9.
6. The user fills in the payment details on the PSP's web page, such as the credit card number, holder's name, expiration date, etc, then clicks the pay button. The PSP starts the payment processing.
7. The PSP returns the payment status.
8. The web page is now redirected to the redirect URL. The payment status that is received in step 7 is typically appended to the URL. For example, the full redirect URL could be [12]: https://your-company.com/?tokenID=JIOUIQ123NSF&payResult=X324FSa
9. Asynchronously, the PSP calls the payment service with the payment status via a webhook. The webhook is an URL on the payment system side that was registered with the PSP during the initial setup with the PSP. When the payment system receives payment events through the webhook, it extracts the payment status and updates the `payment_order_status` field in the Payment Order database table.

So far, we explained the happy path of the hosted payment page. In reality, the network connection could be unreliable and all 9 steps above could fail. Is there any systematic way to handle failure cases? The answer is reconciliation.

### Reconciliation

When system components communicate asynchronously, there is no guarantee that a message will be delivered, or a response will be returned. This is very common in the payment business, which often uses asynchronous communication to increase system performance. External systems, such as PSPs or banks, prefer asynchronous communication as well. So how can we ensure correctness in this case?

The answer is reconciliation. This is a practice that periodically compares the states among related services in order to verify that they are in agreement. It is usually the last line of defense in the payment system.

Every night the PSP or banks send a settlement file to their clients. The settlement file contains the balance of the bank account, together with all the transactions that took place on this bank account during the day. The reconciliation system parses the settlement file and compares the details with the ledger system. Figure 11.6 below shows where the reconciliation process fits in the system.

Reconciliation is also used to verify that the payment system is internally consistent. For example, the states in the ledger and wallet might diverge and we could use the reconciliation system to detect any discrepancy.

To fix mismatches found during reconciliation, we usually rely on the finance team to perform manual adjustments. The mismatches and adjustments are usually classified into three categories:

1. The mismatch is classifiable and the adjustment can be automated. In this case, we know the cause of the mismatch, how to fix it, and it is cost-effective to write a program to automate the adjustment. Engineers can automate both the mismatch classification and adjustment.
2. The mismatch is classifiable, but we are unable to automate the adjustment. In this case, we know the cause of the mismatch and how to fix it, but the cost of writing an auto adjustment program is too high. The mismatch is put into a job queue and the finance team fixes the mismatch manually.
3. The mismatch is unclassifiable. In this case, we do not know how the mismatch happens. The mismatch is put into a special job queue. The finance team investigates it manually.

### Handling payment processing delays

As discussed previously, an end-to-end payment request flows through many components and involves both internal and external parties. While in most cases a payment request would complete in seconds, there are situations where a payment request would stall and sometimes take hours or days before it is completed or rejected. Here are some examples where a payment request could take longer than usual:

- The PSP deems a payment request high risk and requires a human to review it.
- A credit card requires extra protection like 3D Secure Authentication [13] which requires extra details from a card holder to verify a purchase.

The payment service must be able to handle these payment requests that take a long time to process. If the buy page is hosted by an external PSP, which is quite common these days, the PSP would handle these long-running payment requests in the following ways:

- The PSP would return a pending status to our client. Our client would display that to the user. Our client would also provide a page for the customer to check the current payment status.
- The PSP tracks the pending payment on our behalf, and notifies the payment service of any status update via the webhook the payment service registered with the PSP.

When the payment request is finally completed, the PSP calls the registered webhook mentioned above. The payment service updates its internal system and completes the shipment to the customer.

Alternatively, instead of updating the payment service via a webhook, some PSP would put the burden on the payment service to poll the PSP for status updates on any pending payment requests.

### Communication among internal services

There are two types of communication patterns that internal services use to communicate: synchronous vs asynchronous. Both are explained below.

#### Synchronous communication

Synchronous communication like HTTP works well for small-scale systems, but its shortcomings become obvious as the scale increases. It creates a long request and response cycle that depends on many services. The drawbacks of this approach are:

- Low performance. If any one of the services in the chain doesn't perform well, the whole system is impacted.
- Poor failure isolation. If PSPs or any other services fail, the client will no longer receive a response.
- Tight coupling. The request sender needs to know the recipient.
- Hard to scale. Without using a queue to act as a buffer, it's not easy to scale the system to support a sudden increase in traffic.

#### Asynchronous communication

Asynchronous communication can be divided into two categories:

- Single receiver: each request (message) is processed by one receiver or service. It's usually implemented via a shared message queue. The message queue can have multiple subscribers, but once a message is processed, it gets removed from the queue. Let's take a look at a concrete example. In Figure 11.7, service A and service B both subscribe to a shared message queue. When m1 and m2 are consumed by service A and service B respectively, both messages are removed from the queue as shown in Figure 11.8.
- Multiple receives: each request (message) is processed by multiple receivers or services. Kafka works well here. When consumers receive messages, they are not removed from Kafka. The same message can be processed by different services. This model maps well to the payment system, as the same request might trigger multiple side effects such as sending push notifications, updating financial reporting, analytics, etc. An example is illustrated in Figure 11.9. Payment events are published to Kafka and consumed by different services such as the payment system, analytics service, and billing service.

Generally speaking, synchronous communication is simpler in design, but it doesn't allow services to be autonomous. As the dependency graph grows, the overall performance suffers. Asynchronous communication trades design simplicity and consistency for scalability and failure resilience. For a large-scale payment system with complex business logic and a large number of third-party dependencies, asynchronous communication is a better choice.

### Handling failed payments

Every payment system has to handle failed transactions. Reliability and fault tolerance are key requirements. We review some of the techniques for tackling those challenges.

#### Tracking payment state

Having a definite payment state at any stage of the payment cycle is crucial. Whenever a failure happens, we can determine the current state of a payment transaction and decide whether a retry or refund is needed. The payment state can be persisted in an append only database table.

#### Retry queue and dead letter queue

To gracefully handle failures, we utilize the retry queue and dead letter queue, as shown in Figure 11.10.

- Retry queue: retryable errors such as transient errors are routed to a retry queue.
- Dead letter queue [14]: if a message fails repeatedly, it eventually lands in the dead letter queue. A dead letter queue is useful for debugging and isolating problematic messages for inspection to determine why they were not processed successfully.

1. Check whether the failure is retryable.
   - Retryable failures are routed to a retry queue.
   - For non-retryable failures such as invalid input, errors are stored in a database.
2. The payment system consumes events from the retry queue and retries failed payment transactions.
3. If the payment transaction fails again:
   - If the retry count doesn't exceed the threshold, the event is routed to the retry queue.
   - If the retry count exceeds the threshold, the event is put in the dead letter queue. Those failed events might need to be investigated.

If you are interested in a real-world example of using those queues, take a look at Uber's payment system that utilizes Kafka to meet the reliability and fault-tolerance requirements [15].

### Exactly-once delivery

One of the most serious problems a payment system can have is to double charge a customer. It is important to guarantee in our design that the payment system executes a payment order exactly-once [16].

At first glance, exactly-once delivery seems very hard to tackle, but if we divide the problem into two parts, it is much easier to solve. Mathematically, an operation is executed exactly-once if:

1. It is executed at-least-once.
2. At the same time, it is executed at-most-once.

We will explain how to implement at-least-once using retry, and at-most-once using idempotency check.

#### Retry

Occasionally, we need to retry a payment transaction due to network errors or timeout. Retry provides the at-least-once guarantee. For example, as shown in Figure 11.11, where the client tries to make a $10 payment, but the payment request keeps failing due to a poor network connection. In this example, the network eventually recovered and the request succeeded at the fourth attempt.

Deciding the appropriate time intervals between retries is important. Here are a few common retry strategies.

- Immediate retry: client immediately resends a request.
- Fixed intervals: wait a fixed amount of time between the time of the failed payment and a new retry attempt.
- Incremental intervals: client waits for a short time for the first retry, and then incrementally increases the time for subsequent retries.
- Exponential backoff [17]: double the waiting time between retries after each failed retry. For example, when a request fails for the first time, we retry after 1 second; if it fails a second time, we wait 2 seconds before the next retry; if it fails a third time, we wait 4 seconds before another retry.
- Cancel: the client can cancel the request. This is a common practice when the failure is permanent or repeated requests are unlikely to be successful.

Determining the appropriate retry strategy is difficult. There is no "one size fits all" solution. As a general guideline, use exponential backoff if the network issue is unlikely to be resolved in a short amount of time. Overly aggressive retry strategies waste computing resources and can cause service overload. A good practice is to provide an error code with a `Retry-After` header.

A potential problem of retrying is double payments. Let us take a look at two scenarios.

**Scenario 1**: The payment system integrates with PSP using a hosted payment page, and the client clicks the pay button twice.

**Scenario 2**: The payment is successfully processed by the PSP, but the response fails to reach our payment system due to network errors. The use clicks the "pay" button again or the client retries the payment.

In order to avoid double payment, the payment has to be executed at-most-once. This at-most-once guarantee is also called idempotency.

#### Idempotency

Idempotency is key to ensuring the at-most-once guarantee. According to Wikipedia, "idempotence is the property of certain operations in mathematics and computer science whereby they can be applied multiple times without changing the result beyond the initial application" [18]. From an API standpoint, idempotency means clients can make the same call repeatedly and produce the same result.

For communication between clients (web and module application) and servers, an idempotency key is usually a unique value that is generated by the client and expires after a certain period of time. A UUID is commonly used as an idempotency key and it is recommended by many tech companies such as Stripe [19] and PayPal [20]. To perform an idempotent payment request, an idempotency key is added to the HTTP header: `<idempotency-key: key_value>`.

Now that we understand the basics of idempotency, let's take a look at how it helps to solve the double payment issues mentioned above.

**Scenario 1: what if a customer clicks the "pay" button quickly twice?**

In Figure 11.12, when a user clicks "pay", an idempotency key is sent to the payment system as part of the HTTP request. In an e-commerce website, the idempotency key is usually the ID of the shopping cart right before the checkout.

For the second request, it's treated as a retry because the payment system has already seen the idempotency key. When we include a previously specified idempotency key in the request header, the payment system returns the latest status of the previous request.

If multiple concurrent requests are detected with the same idempotency key, only one request is processed and the others receive the 429 Too Many Requests status code.

To support idempotency, we can use the database's unique key constraint. For example, the primary key of the database table is served as the idempotency key. Here is how it works:

1. When the payment system receives a payment, it tries to insert a row into the database table.
2. A successful insertion means we have not seen this payment request before.
3. If the insertion fails because the same primary key already exists, it means we have seen this payment request before. The second request will not be processed.

**Scenario 2: The payment is successfully processed by the PSP, but the response fails to reach our payment system due to network errors. Then the user clicks the "pay" button again.**

As shown in Figure 11.4 (step 2 and step 3), the payment service sends the PSP a nonce and the PSP returns a corresponding token. The nonce uniquely represents the payment order, and the token uniquely maps to the nonce. Therefore, the token uniquely maps to the payment order.

When the user clicks the "pay" button again, the payment order is the same, so the token sent to the PSP is the same. Because the token is used as the idempotency key on the PSP side, it is able to identify the double payment and return the status of the previous execution.

### Consistency

Several stateful services are called in a payment execution:

1. The payment service keeps payment-related data such as nonce, token, payment order, execution status, etc.
2. The ledger keeps all accounting data.
3. The wallet keeps the account balance of the merchant.
4. The PSP keeps the payment execution status.
5. Data might be replicated among different database replicas to increase reliability.

In a distributed environment, the communication between any two services can fail, causing data inconsistency. Let's take a look at some techniques to resolve data inconsistency in a payment system.

To maintain data consistency between internal services, ensuring exactly-once processing is very important.

To maintain data consistency between the internal service and external service (PSP), we usually rely on idempotency and reconciliation. If the external service supports idempotency, we should use the same idempotency key for payment retry operations. Even if an external service supports idempotent APIs, reconciliation is still needed because we shouldn't assume the external system is always right.

If data is replicated, replication lag could cause inconsistent data between the primary database and the replicas. There are generally two options to solve this:

1. Serve both reads and writes from the primary database only. This approach is easy to set up, but the obvious drawback is scalability. Replicas are used to ensure data reliability, but they don't serve any traffic, which wastes resources.
2. Ensure all replicas are always in-sync. We could use consensus algorithms such as Paxos [21] and Raft [22], or use consensus-based distributed databases such as YugabyteDB [23] or CockroachDB [24].

### Payment security

Payment security is very important. In the final part of this system design, we briefly cover a few techniques for combating cyberattacks and card thefts.

| Problem                                     | Solution                                                     |
| ------------------------------------------- | ------------------------------------------------------------ |
| Request/response eavesdropping              | Use HTTPS                                                    |
| Data tampering                              | Enforce encryption and integrity monitoring                  |
| Man-in-the-middle attack                    | Use SSL with certificate pinning                             |
| Data loss                                   | Database replication across                                  |
| Distributed denial-of-service attack (DDoS) | Rate limiting and firewall [25]                              |
| Card theft                                  | Tokenization. Instead of using real card numbers, tokens are stored and used for payment |
| PCI compliance                              | PCI DSS is an information security standard for organizations that handle branded credit cards |
| Fraud                                       | Address verification, card verification value (CVV), user behavior analysis, etc. [26] [27] |

## Step 4 - Wrap Up

In this chapter, we investigated the pay-in flow and pay-out flow. We went into great depth about retry, idempotency, and consistency. Payment error handling and security are also covered at the end of the chapter.

A payment system is extremely complex. Even though we have covered many topics, there are still more worth mentioning. The following is a representative but not an exhaustive list of relevant topics.

- Monitoring. Monitoring key metrics is a critical part of any modern application. With extensive monitoring, we can answer questions like "What is the average acceptance rate for a specific payment method?", "What is the CPU usage of our servers?", etc. We can create and display those metrics on a dashboard.
- Alerting. When something abnormal occurs, it is important to alert on-call developers so they respond promptly.
- Debugging tools. "Why does a payment fail?" is a common question. To make debugging easier for engineers and customer support, it is important to develop tools that allow staff to review the transaction status, processing server history, PSP records, etc. of a payment transaction.
- Currency exchange. Currency exchange is an important consideration when designing a payment system for an international user base.
- Geography. Different regions might have completely different sets of payment methods.
- Cash payment. Cash payment is very common in India, Brazil, and some other countries. Uber [28] and Airbnb [29] wrote detailed engineering blogs about how they handled cash-based payment.
- Google/Apple pay integration. Please read [30] if interested.

Congratulations on getting this far! Now give yourself a pat on the back. Good job!

# 12 Digital Wallet

Payment platforms usually provide a digital wallet service to clients, so they can store money in the wallet and spend it later. For example, you can add money to your digital wallet from your bank card and when you buy products online, you are given the option to pay using the money in your wallet. Figure 12.1 shows this process.

Spending money is not the only feature that the digital wallet provides. For a payment platform like PayPal, we can directly transfer money to somebody else's wallet on the same payment platform. Compared with the bank-to-bank transfer, direct transfer between digital wallets is faster, and most importantly, it usually does not charge an extra fee, Figure 12.2 shows a cross-wallet balance transfer operation.

Suppose we are asked to design the backend of a digital wallet application that supports the cross-wallet balance transfer operation. At the beginning of the interview, we will ask clarification questions to nail down the requirements.

## Step 1 - Understand the Problem and Establish Design Scope