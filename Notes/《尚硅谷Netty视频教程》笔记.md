尚硅谷Netty视频教程（B站超火，好评如潮）

2019-11-19 10:25:17

https://www.bilibili.com/video/BV1DJ411m7NR

# P1 课程说明和要求

# P2 Netty 是什么

## Netty 的介绍

1. Netty 是由 JBOSS 提供的一个 Java 开源框架，现为 GitHub 上的独立项目
2. Netty 是一个异步的、基于事件驱动的网络应用框架，用以快速开发高性能、高可靠性的网络 IO 程序。
3. Netty 主要针对在 TCP 协议下，面向 Clients 端的高并发应用，或者 Peer-to-Peer 场景下的大量数据持续传输的应用
4. Netty 本质是一个 NIO 框架，适用于服务器通讯相关的多种应用场景
5. 要透彻理解 Netty，需要先学习 NIO，这样我们才能阅读 Netty 的源码

# P3 应用场景和学习资料

视频加载不出来，看下一 P

# P4 IO 模型

## Netty 的应用场景

互联网行业

1. 互联网行业：在分布式系统中，各个节点之间需要远程服务调用，高性能的 RPC 框架必不可少，Netty 作为异步高性能的通信框架，往往作为基础通信组件被这些 RPC 框架使用。
2. 典型的应用有：阿里分布式服务框架  Dubbo 的 RPC 框架使用 Dubbo 协议进行节点间通信，Dubbo 协议默认使用 Netty 作为基础通信组件，用于实现各进程节点之间的内部通信

游戏行业

1. 无论是手游服务端还是大型的网络游戏，Java 语言得到了越来越广泛的应用
2. Netty 作为高性能的基础通信组件，提供了 TCP/UDP 和 HTTP 协议栈，方便定制和开发私有协议栈，账号登陆服务器
3. 地图服务器之间可以方便的通过 Netty 进行高性能的通信

大数据领域

1. 经典的 Hadoop 的高性能通信和序列化组件 Avro 的 RPC  框架，默认采用 Netty 进行跨界点通信
2. 它的 Netty Service 基于 Netty 框架二次封装实现。

其他开源项目使用到 Netty

网址：http://netty.io/wiki/related-projects.html

- Akka
- Apache HBase
- Apache Cassandra
- Apache Flink
- Apache Pulsar
- Apache Spark
- Couchbase
- Elastic Search
- gRPC
- http-client
- Lettuce
- Play Framework
- Redisson
- Vert.x
- ……

> 页面内的全部列表：
>
> - [Akka](http://akka.io/) is a Scala-based platform that provides simpler scalability, fault-tolerance, concurrency, and remoting through the actor model and software transactional
> - [Apache BookKeeper](http://bookkeeper.apache.org/) is a scalable, fault-tolerant, and low-latency log storage.
> - [Apache HBase](http://hbase.apache.org/) is the [Hadoop](https://hadoop.apache.org/) database, a distributed, scalable, big data store.
> - [Apache Cassandra](http://cassandra.apache.org/) is a column oriented distributed database.
> - [Apache Flink](https://netty.io/wiki/flink.apache.org) is a distributed, stateful stream processing framework.
> - [Apache James Server](http://james.apache.org/server) is a modular e-mail server platform that integrates SMTP, POP3, IMAP, and NNTP.
> - [Apache Pulsar](https://pulsar.incubator.apache.org/) is an open-source distributed pub-sub messaging system.
> - [Apache Spark](http://spark.apache.org/) is a fast and general purpose cluster compute framework, commonly used for "Big Data" applications.
> - [Apache Tajo](http://tajo.apache.org/) is a distributed, fault-tolerance, low-latency, and high throughput SQL engine that provides ETL features and ad-hoc query processing on large-scale data sets.
> - [Arquillian](http://www.jboss.org/arquillian.html) is an innovative in-container testing platform for the JVM
> - [Async HTTP Client](https://github.com/AsyncHttpClient/async-http-client) is a simple-to-use library that allows you to execute HTTP requests and process the HTTP responses asynchronously.
> - [Atomix](http://atomix.io/atomix/) is an event-driven framework for coordinating fault-tolerant distributed systems built on the Raft consensus algorithm.
> - [BungeeCord](http://www.spigotmc.org/threads/392/) is the de facto proxy solution for combining multiple Minecraft servers into a cloud / hub system.
> - [ClusterVAS](https://gitlab.com/opentoolset/clustervas) - A docker based node manager and an orchestrator SDK for remotely managing OpenVAS instances (communication layer is built with Netty Agents based on Netty)
> - [Copycat](http://atomix.io/copycat/) is a fault-tolerant state machine replication framework built on the Raft consensus algorithm.
> - [Couchbase](http://www.couchbase.com/) is a distributed NoSQL document-oriented database that is optimized for interactive applications.
> - [drasyl](https://drasyl.org/) is a high-performance framework for rapid development of distributed applications.
> - [Elastic Search](http://www.elasticsearch.org/) is a distributed RESTful search engine built on top of Lucene.
> - [Eucalyptus](http://open.eucalyptus.com/) is a software infrastructure for implementing on-premise cloud computing using an organization's own IT infrastructure, without modification, special-purpose hardware or reconfiguration.
> - [Finagle](http://twitter.github.io/finagle/) is an extensible RPC system for the JVM, used to construct high-concurrency servers.
> - [Forest](https://github.com/le-moulin-studio/forest) is a general purpose friend-to-friend platform.
> - [Gatling](https://gatling.io/) is an asynchronous and efficient stress tool developed with Netty and Akka.
> - [gRPC](https://grpc.io/) is a high performance, open-source universal RPC framework.
> - [Hammersmith](https://github.com/bwmcadams/hammersmith) is a pure asynchronous MongoDB driver for Scala
> - [Higgs](https://github.com/zcourts/higgs) is a high performance, message oriented network library.
> - [Holmes](https://ccheneau.github.com/Holmes/) is a Java application that implements DLNA/UPnP protocol for playing videos, music, pictures and podcasts (RSS) to compatible devices.
> - [HornetQ](http://www.jboss.org/hornetq) is a project to build a multi-protocol, embeddable, very high performance, clustered, asynchronous messaging system.
> - [http-client](https://github.com/brunodecarvalho/http-client) is a high performance and throughput oriented HTTP client library.
> - [Infinispan](http://www.jboss.org/infinispan) is an extremely scalable, highly available data grid platform.
> - [jaC64](https://code.google.com/p/jac64-op/) is a C64 emulator with multiplayer support.
> - [Jagornet DHCP](https://github.com/jagornet/dhcp) is a standards compliant, open source DHCPv4/DHCPv6 server written in Java using Netty.
> - [jasync-sql](https://github.com/jasync-sql/jasync-sql) Java, Netty based, async database driver for MySQL and PostgreSQL written in Kotlin.
> - [JBossWS](http://www.jboss.org/jbossws) is a feature-rich JAX-WS compatible web service stack.
> - [Jetserver](https://github.com/menacher/java-game-server) is a fast multiplayer java game server written using JBoss Netty and Mike Rettig's Jetlang. It supports TCP and UDP transmission and Flash AMF3 protocol.
> - [JXTA](http://jxta.kenai.com/) is a set of open protocols that enable any connected device on the network, ranging from cell phones and wireless PDAs to PCs and servers, to communicate and collaborate in a P2P manner.
> - [Lettuce](https://lettuce.io/) is a scalable Redis client for building non-blocking Reactive applications.
> - [Ldaptive](https://www.ldaptive.org/) is a simple, high performance LDAP client that uses Netty for network transport.
> - [LittleProxy](https://github.com/adamfisk/LittleProxy) is a high-performance HTTP proxy.
> - [MessagePack](http://msgpack.org/) is a binary-based efficient object serialization library that enables to exchange structured objects between many languages.
> - [Micronaut](https://micronaut.io/) is a modern, JVM-based, full-stack framework for building modular, easily testable microservice and serverless applications.
> - [Mobicents Media Server](http://www.mobicents.org/) is a media gateway server that processes the audio and/or video streams associated with telephone calls or VoIP connections.
> - [Mobicents SIP Servlets](http://www.mobicents.org/products_sip_servlets.html) is an open source certified SIP Servlet implementation.
> - [Mock Server](http://mock-server.com/) mocking and proxying framework that uses Netty for mocking of systems with an HTTP or HTTPS interface
> - [Moquette MQTT broker](https://code.google.com/p/moquette-mqtt) Simple MQTT broker that uses Netty for protocol codec.
> - [Naggati](https://github.com/twitter/naggati2) "**it's (DEPRECATED) now**" is a protocol builder for Netty, written in Scala.
> - [Netflow.io](https://github.com/wasted/netflow) is a Scala/Netty Netflow Collector used at wasted.io
> - [Netty Agents](https://gitlab.com/opentoolset/netty-agents) - Easy to use, message based communication library based on Netty
> - [Netty Tools](https://github.com/cgbystrom/netty-tools) is a small collection of tools useful when working with Netty, which includes various HTTP clients and servers, bandwidth meter, and Thrift RPC processor.
> - [Netty-ICAP Codec](https://github.com/jmimo/netty-icap) is a high performance full RFC3507 compliant ICAP codec implementation. This protocol is mostly used in proxy environments in order to offload work to external servers.
> - [Netty-Livereload](https://github.com/alexvictoor/netty-livereload) is the [Livereload](http://livereload.com/) protocol implementation on Netty WebSocket implementation.
> - [Netty-SocketIO](https://github.com/mrniko/netty-socketio) is a Socket.IO server written on top of Netty
> - [Netty-Transport-jSerialComm](https://github.com/Ziver/Netty-Transport-jSerialComm) is a serial port transport for Netty using the jSerialComm library.
> - [Netty-ZMTP](https://github.com/spotify/netty-zmtp) is a collection of Netty channel handlers that aims to implement ZMTP/1.0, the ZeroMQ Message Transport Protocol.
> - [Nitmproxy](https://github.com/chhsiao90/nitmproxy) is a proxy server supporting HTTP/SOCKS proxy, HTTP/1.1, and HTTP2 protocols.
> - [nio_uring](https://github.com/bbeaupain/nio_uring) is a Netty-inspired high-performance I/O library for Java using io_uring under the hood.
> - [Riposte](https://github.com/Nike-Inc/riposte) is a Netty-based microservice framework for rapid development of production-ready HTTP APIs.
> - [ScaleCube](https://github.com/scalecube/scalecube-services) Reactive Microservices is a message-driven and asynchronous lock free library built to scale. empowered by scalecube-cluster gossip capabilities aiming answer distributed applications cross-cutting-concerns such as; service discovery, location transparency, fault-tolerance and real time failure-detection.
> - [Slacker](https://github.com/sunng87/slacker) Asynchronous Clojure RPC client/server library, backed by Netty.
> - [Socket-IO - Service Fabric I/O](https://github.com/servicefabric/socketio) Ultra Fast Socket.IO server based on Netty.
> - [SwiftNIO](https://github.com/apple/swift-nio) is basically the twin of Netty for the iOS platform, written by the same team.
> - [Nifty](https://github.com/facebook/nifty) is a Netty-based Thrift transport implementation.
> - [NIOSMTP](https://github.com/normanmaurer/niosmtp) is an asynchronous SMTP client implementation.
> - [OpenTSDB](http://opentsdb.net/) is a distributed, scalable, Time Series Database written on top of HBase to store, index, and serve the metrics collected from computer systems.
> - [Peregrine](https://peregrine_mapreduce.bitbucket.org/) is a map reduce framework designed for running iterative jobs across partitions of data. Peregrine is designed to be FAST for executing map reduce jobs by supporting a number of optimizations and features not present in other map reduce frameworks.
> - [Play Framework](http://www.playframework.org/) is a clean alternative web application framework to J2EE stack, which focuses on developer productivity and targets RESTful architecture.
> - [PS3 Media Server](https://code.google.com/p/ps3mediaserver) is a DLNA compliant UPNP Media Server for PS3 which transcodes and streams any kind of media files.
> - [Protobuf-RPC-Pro](https://github.com/pjklauser/protobuf-rpc-pro) is a Java implementation for Google's Protocol Buffer RPC services.
> - [Pushy](http://relayrides.github.io/pushy/) is a Java library for sending APNs (iOS/OS X) push notifications.
> - [Ratpack](http://www.ratpack.io/) is a simple, capable, toolkit for creating high performance web applications.
> - [Redisson](https://github.com/mrniko/redisson) provides a distributed and scalable Java data structures (Set, SortedSet, Map, ConcurrentMap, List, Queue, Deque, Lock, AtomicLong, CountDownLatch, Publish / Subscribe, HyperLogLog) on top of Redis server.
> - [RESTExpress](https://github.com/RestExpress/RestExpress) is a lightweight, fast, micro-framework for building stand-alone REST services in Java. It supports JSON and XML serialization automagically as well as ISO 8601 date formats.
> - [RHQ collectd decoder](https://github.com/rhq-project/netty-collectd) decodes collectd UDP datagrams.
> - [Spigot](http://www.spigotmc.org/) is a high performance Minecraft server based on CraftBukkit designed to provide the highest possible performance and reliability. It uses Netty for its custom network stack.
> - [Spinach](https://github.com/mp911de/spinach) is a scalable thread-safe [Disque](https://github.com/antirez/disque) client providing both synchronous and asynchronous connections.
> - [Swift-NIO](https://github.com/apple/swift-nio) is a cross-platform asynchronous event-driven network application framework for rapid development of maintainable high performance protocol servers & clients. It's like Netty, but written for Swift (iOS).
> - [Termd](https://github.com/termd/termd) a library for building terminal applications in Java providing a Telnet server, an SSH server and a web based terminal on top of Netty
> - [Teiid](http://www.jboss.org/teiid) is a data virtualization system that allows applications to use data from multiple, heterogenous data stores.
> - [Torrent4J](https://github.com/torrent4j/torrent4j) is a BitTorrent library implemented in pure Java.
> - [TomP2P](http://tomp2p.net/) is an extended DHT (distributed hash table) which stores values for a location key in a sorted table.
> - [Unfiltered](http://unfiltered.ws/) is a toolkit for servicing HTTP requests in Scala that provides a consistent vocabulary for handing requests on various server backends.
> - [Universal Media Server](https://github.com/UniversalMediaServer/UniversalMediaServer/) is a DLNA compliant UPNP Media Server for PS3 and others renderers which transcodes and streams any kind of media files.
> - [Vert.x](http://vertx.io/) is a tool-kit for building reactive applications on the JVM.
> - [WaarpFtp](https://waarp.github.com/WaarpFtp/) is an FTP Server based on Netty
> - [Bixby](https://github.com/llnek/bixby) is a server side application framework in clojure.
> - [Webbit](http://webbitserver.org/) is an event-based WebSocket and HTTP server.
> - [Websocket-MQTT-Forwarder](https://github.com/sylvek/websocket-mqtt-forwarder) is an event-based WebSocket to MQTT broker forwarder.
> - [Xeres](https://github.com/zapek/Xeres) a peer-to-peer (friend-to-friend) application.
> - [Xitrum](https://xitrum-framework.github.io/) is an async and clustered Scala web framework and HTTP(S) server on top of Netty and Hazelcast.
> - [zooterrain](https://github.com/berndfo/zooterrain) is a small self-containing web server app which pushes all ZooKeeper znodes and their changes to the browser (using WebSocket)

## Netty 的学习参考资料

《Netty In Action》

《Netty 权威指南》

## I/O 模型

### I/O 模型基本说明

1. I/O 模型简单的理解：就是用什么样的通道进行数据的发送和接收，很大程度上决定了程序通信的性能
2. Java 共支持 3 种网络编程模型/ IO 模式：BIO、NIO、AIO
3. Java BIO：同步并阻塞（**传统阻塞型**），服务器实现模式为一个连接一个线程，即客户端有连接请求时服务器端就需要启动一个线程进行处理，如果这个连接不做任何事情会造成不必要的线程开销
4. Java NIO：**同步非阻塞**，服务器实现模式为一个线程处理多个请求（连接），即客户端发送的连接请求都会注册到多路复用器上，多路复用器轮询到连接有 I/O 请求就进行处理
5. Java AIO（NIO.2）：**异步非阻塞**，AIO 引入异步通道的概念，采用了 Proactor 模式，简化了程序编写，有效的请求才启动线程，它的特点是先由操作系统完成后才通知服务端程序启动线程去处理，一般适用于连接数较多且连接时间较长的应用

### BIO、NIO、AIO 适用场景分析

1. BIO 方式适用于连接数目比较小且固定的架构，这种方式对服务器资源要求比较高，并发局限于应用中，JDK 1.4 以前的唯一选择，但程序简单易理解
2. NIO 方式适用于**连接数目多且连接比较短**（轻操作）的架构，比如聊天服务器，弹幕系统，服务器间通讯等。编程比较复杂，JDK 1.4 开始支持。
3. AIO 方式适用于**连接数目多且连接比较长**（重操作）的架构，比如相册服务器，充分调用 OS 参与并发操作，编程比较复杂，JDK 7 开始支持。

# P5 BIO 介绍说明

## Java BIO 基本介绍

1. Java BIO 就是**传统的 java io 编程**，其相关的类和接口在 java.io
2. BIO（blocking I/O）：**同步阻塞**，服务器实现模式为一个连接一个线程，即客户端有连接请求时服务器端就需要启动一个线程进行处理，如果这个连接不做任何事情会造成不必要的线程开销，可以通过线程池机制改善。
3. BIO 方式适用于连接数目比较小且固定的架构，这种方式对服务器资源要求比较高，并发局限于应用中，JDK 1.4 以前的唯一选择，但程序简单易理解

## Java BIO 工作机制

工作原理图

Socket ->  read/write -> Thread

Socket ->  read/write -> Thread

Socket ->  read/write -> Thread

BIO 编程简单流程

1. 服务器端启动一个 ServerSocket
2. 客户端启动 Socket 对服务器进行通信，默认情况下服务器端需要对每个客户建立一个线程与之通讯
3. 客户端发出请求后，先咨询服务器是否有线程响应，如果没有则会等待，或者被拒绝
4. 如果有响应，客户端线程会等待请求结束后，再继续进行

# P6 BIO 实例及分析

## Java BIO 应用实例

**实例说明：**

1. 使用 BIO 模型编写一个服务器端，监听 6666 端口，当有客户端连接时，就启动一个线程与之通讯。
2. 要求使用线程池机制改善，可以连接多个客户端
3. 服务器端可以接收客户端发送的数据（telnet 方式即可）

```java
public class BIOServer {
    public static void main(String[] args) throws Exception {
        // 线程池机制
        // 思路
        // 1. 创建一个线程池
        // 2. 如果有客户端连接，就创建一个线程，与之通讯（单独写一个方法）
        ExecutorService newCachedThreadPool = Executors.newCachedThreadPool();
        // 创建 ServerSocket
        ServerSocket serverSocket = new ServerSocket(6666);
        
        System.out.println("服务器启动了");
        
        while (true) {
            // 监听，等待客户端连接
            final Socket socket = serverSocket.accept();
            System.out.println("连接到一个客户端");
            // 就创建一个线程，与之通讯（单独写一个方法）
            newCachedThreadPool.execute(new Runnable() {
                public void run() { // 我们重写
                    // 可以和客户端通讯
                }
            })
        }
    }
    
    // 编写一个 handler 方法，和客户端通讯
    public static void handler(Socket socket) {
        try {
            System.out.println("线程信息 id = " + Thread.currentThread().getId() + " 名字 = " + Thread.currentThread().getName());
            byte[] bytes = new byte[1024];
            // 通过 socket 获取输入流
            InputStream inputStream = socket.getInputStream();
            // 循环的读取客户端发送的数据
            while (true) {
                System.out.println("线程信息 id = " + Thread.currentThread().getId() + " 名字 = " + Thread.currentThread().getName());
                int read = inputStream.read(bytes);
                if (read != -1) {
                    System.out.println(new String(bytes, 0, read)); // 输出客户端发送的数据
                } else {
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            System.out.println("关闭和 client 的连接");
            try {
                socket.close();
            } catch (Exception e) {
            	e.printStackTrace();
            }
        }
    }
}
```

## Java BIO 问题分析

1. 每个请求都需要创建独立的线程，与对应的客户端进行数据 Read，业务处理，数据 Write。
2. 当并发数较大时，需要**创建大量线程来处理连接**，系统资源占用较大。
3. 连接建立后，如果当前线程暂时没有数据可读，则线程就阻塞在 Read 操作上，造成线程资源浪费

# P7 BIO 内容梳理小结

# P8 NIO 介绍说明

## Java NIO 基本介绍

1. Java NIO 全称 java non-blocking IO，是指 JDK 提供的新 API。从 JDK 1.4 开始，Java 提供了一系列改进的输入/输出的新特性，被统称为 NIO（即 New IO），是**同步非阻塞**的
2. NIO 相关类都被放在 java.nio 包及子包下，并且对原 java.io 包中的很多类进行改写
3. NIO 有三个核心部分：**Channel（通道）**，**Buffer（缓冲区）**、**Selector（选择器）**
4. NIO 是面向**缓冲区，或者面向块**编程的。数据读取到一个它稍后处理的缓冲区，需要时可在缓冲区中前后移动，这就增加了处理过程中的灵活性，使用它可以提供非阻塞式的高伸缩性网络
5. Java NIO 的非阻塞模式，使一个线程从某通道发送请求读取数据，但是它仅能得到目前可用的数据。如果目前没有数据可用时，就什么都不会获取，而不是保持线程阻塞，所以直至数据变的可以读取之前，该线程可以继续做其他的事情。非阻塞写也是如此，一个线程请求写入一些数据到某通道，但不需要等待它完全写入，这个线程同时可以去做别的事情。
6. 通俗理解：NIO 是可以做到用一个线程来处理多个操作的。假如有 10000 个请求过来，根据实际情况，可以分配 50 或者 100 个线程来处理。不像之前的阻塞 IO 那样，非得分配 10000 个。
7. HTTP 2.0 使用了多路复用的技术，做到同一个连接并发处理多个请求，而且并发请求的数量比 HTTP 1.1 大了好几个数量级。

# P9 NIO Buffer 的基本使用

```java
public class BasicBuffer {
    public static void main(String[] args) {
        // 举例说明 Buffer 的使用（简单说明）
        // 创建一个 Buffer，大小为 5，即可以存放 5 个 int
        IntBuffer intBuffer = IntBuffer.allocate(5);
        
        // 向 buffer 存放数据
        for (int i = 0; i < intBuffer.capacity(); i++) {
            intBuffer.put(i * 2);
        }
        
        // 如何从 buffer 读取数据
        // 将 buffer 转换，读写切换
        intBuffer.flip();
        
        while (intBuffer.hasRemaining()) {
            System.out.println(intBuffer.get());
        }
    }
}
```

## NIO 和 BIO 的比较

1. BIO 以流的方式处理数据，而 NIO 以块的方式处理数据，块 I/O 的效率比流 I/O 高很多
2. BIO 是阻塞的，NIO 则是非阻塞的
3. BIO 基于字节流和字符流进行操作，而 NIO 基于 Channel（通道）和 Buffer（缓冲区）进行操作，数据总是从通道读取到缓冲区中，或者从缓冲区写入到通道中。Selector（选择器）用于监听多个通道的事件（比如：连接请求，数据到达等），因此使用**单个线程就可以监听多个客户端**通道

# P10 NIO 三大核心组件关系

## NIO 三大核心原理示意图

一张图描述 NIO 的  Selector、Channel 和 Buffer 的关系

1. 每个 Channel 都会对应一个 Buffer
2. Selector 对对应一个线程，一个线程对应多个 channel（连接）
3. 该图反应了有三个 Channel 注册到该 selector 程序
4. 程序切换到哪个 channel 是有事件决定的，Event 就是一个重要的概念
5. Selector 会根据不同的事件，在各个通道上切换
6. Buffer 就是一个内存块，底层是有一个数组
7. 数据的读取写入是通过 Buffer，这个和 BIO、BIO 中要么是输入流，或者是输出流，不能双向，但是 NIO 的 Buffer 是可以读也可以写，需要 flip 方法切换
8. channel 是双向的，可以返回底层操作系统的情况，比如 Linux，底层的操作系统通道就是双向的。

# P11 Buffer 的机制及子类

## 缓冲区（Buffer）

### 基本介绍

缓冲区（Buffer）：缓冲区本质上是一个可以读写数据的内存块，可以理解成是一个**容器对象（含数组）**，该对象提供了**一组方法**，可以更轻松地使用内存块，缓冲区对象内置了一些机制，能够跟踪和记录缓冲区的状态变化情况。Channel 提供从文件、网络读取数据的渠道，但是读取或写入的数据都必须经由 Buffer，如图：

NIO 程序 <-data-> 缓冲区 <-channel-> 文件

### Buffer 类及其子类

1. 在 NIO 中，Buffer 是一个顶层父类，它是一个抽象类，类的层级关系图：

   **常用 Buffer 子类一览**

   1. ByteBuffer，存储字节数据到缓冲区
   2. ShortBuffer，存储字符串数据到缓冲区
   3. CharBuffer，存储字符数据到缓冲区
   4. IntBuffer，存储整数数据到缓冲区
   5. LongBuffer，存储长整型数据到缓冲区
   6. DoubleBuffer，存储小数到缓冲区
   7. FloatBuffer，存储小数到缓冲区

2. Buffer 类定义了所有的缓冲区都具有的四个属性来提供关于其所包含的数据元素的信息：

   | 属性     | 描述                                                         |
   | -------- | ------------------------------------------------------------ |
   | Capacity | 容量，即可以容纳的最大数据量；在缓冲区创建时被设定并且不能改变 |
   | Limit    | 表示缓冲区的当前终点，不能对缓冲区超过极限的位置进行读写操作。且极限是可以修改的 |
   | Position | 位置，下一个要被读或写的元素的索引，每次读写缓冲区数据时都会改变改值，为下次读写作准备 |
   | Mark     | 标记                                                         |

3. Buffer 类相关方法一览

   public final int capacity(); // 返回此缓冲区的容量

   public final int position(); // 返回此缓冲区的位置

   public final Buffer position(int newPosition); // 设置此缓冲区的位置

   public final int limit(); // 返回此缓冲区的限制

   public final Buffer limit(int newLimit) // 设置此缓冲区的限制

   ……

   public final Buffer clear(); // 清除此缓冲区，即将各个标记恢复到初始状态，但数据并没有真正擦除

   public final Buffer flip(); // 反转此缓冲区

   ……

### ByteBuffer

从前面可以看出对于 Java 中的基本类型（boolean 除外），都有一个 Buffer 类型与之相对应，**最常用**的自然是 ByteBuffer 类（二进制数据），该类的主要方法如下：

public static ByteBuffer allocateDirect(int capacity); // 创建直接缓冲区

public static ByteBuffer allocate(int capacity); // 设置缓冲区的初始容量

……

public abstract byte get(); // 从当前位置 position 上 get，get 之后，position 会自动 +1

public abstract byte get(int index); // 从绝对位置 get

public abstract ByteBuffer put(byte b); // 从当前位置上添加，put 之后，position 会自动 +1

public abstract ByteBuffer put(int index, byte b); // 从绝对位置上 put

# P12 Channel 基本介绍

## 通道（Channel）

### 基本介绍

1. NIO 的通道类似于流，但有些区别如下：

   - 通道可以同时进行读写，而流只能读或者只能写
   - 通道可以实现异步读写数据
   - 通道可以从缓冲读数据，也可以写数据到缓冲

2. BIO 中的 stream 是单向的，例如 FileInputStream 对象只能进行读取数据的操作，而 NIO 中的通道（Channel）是双向的，可以读操作，也可以写操作

3. Channel 在 NIO 中是一个接口

   **public interface Channel extends Closable {}**

4. 常用的 Channel 类有：FileChannel、DatagramChannel、ServerSocketChannel 和 SocketChannel。

5. FileChannel 用于文件和数据读写，DatagramChannel 用于 UDP 的数据读写，ServerSocketChannel 和 SocketChannel 用于 TCP 的数据读写。

### FileChannel 类

FileChannel 主要用来用来对本地文件进行 IO 操作，常见的方法有

1. public int read(ByteBuffer dst)，从通道读取数据并放到缓冲区中
2. public int write(ByteBuffer src)，把缓冲区的数据写到通道中
3. public long transferFrom(ReadableByteChannel src, long position, long count), 从目标通道中复制数据到当前通道
4. public long transferTo(long position, long count, WritableByteChannel target)，把数据从当前通道复制给目标通道

# P13 Channel 应用实例1

### 应用实例1-本地文件写数据

实例要求：

1. 使用前面学习后的 ByteBuffer（缓冲）和 FileChannel（通道），将“hello, 尚硅谷”写入到 file01.txt 中
2. 文件不存在就创建
3. 代码演示

```java
public class NIOFileChannel01 {
    public static void main(String[] args) throws Exception {
        String str = "hello, 尚硅谷";
        // 创建一个输出流 -> channel
        FileOutputStream fileOutputStream = new FileOutputStream("d:\\file01.txt");
        // 通过 fileOutputStream 获取对应的 FileChannel
        // 这个 fileChannel 真实类型是 FileChannelImpl
        FileChannel fileChannel = fileOutputStream.getChannel();
        // 创建一个缓冲区 ByteBuffer
        ByteBuffer byteBuffer = ByteBuffer.allocate(1024);
        // 将 str 放入 byteBuffer
        byteBuffer.put(str.getBytes());
        // 对 byteBuffer 进行 flip
        byteBuffer.flip();
        // 将 byteBuffer 数据写入到 fileChannel
        fileChannel.write(byteBuffer);
        fileOutputStream.close();
    }
}
```

# P14 Channel 应用实例2

### 应用实例2-本地文件读数据

实例要求：

1. 使用前面学习后的 ByteBuffer（缓冲）和 FileChannel（通道），将 file01.txt 中的数据读入到程序，并显示在控制台屏幕
2. 假定文件已经存在
3. 代码演示

```java
public class NIOFileChannel02 {
    public static void main(String[] args) throws Exception {
        // 创建文件的输入流
        File file = new File("d:\\file01.txt");
        FileInputStream fileInputStream = new FileInputStream(file);
        // 通过 fileInputStream 获取对应的 FileChannel -> 实际类型是 FileChannelImpl
        FileChannel fileChannel = fileInputStream.getChannel();
        // 创建缓冲区
        ByteBuffer byteBuffer = ByteBuffer.allocate((int) file.length());
        // 将通道的数据读入到 Buffer
        fileChannel.read(byteBuffer);
		// 将 byteBuffer 的字节数据转成 String
        System.out.println(new String(byteBuffer.array()));
        fileInputStream.close();
    }
}
```

# P15 Channel 应用实例3

### 应用实例3-使用一个 Buffer 完成文件读取

实例要求：

1. 使用 FileChannel（通道）和方法 read, write，完成文件的拷贝
2. 拷贝一个文本文件 1.txt，放在项目下即可
3. 代码演示

```java
public class NIOFileChannel03 {
    public static void main(String[] args) throws Exception {
        FileInputStream fileInputStream = new FileInputStream("1.txt");
        FileChannel fileChannel01 = fileInputStream.getChannel();
        
        FileOutputStream fileOutputStream = new FileOutputStream("2.txt");
        FileChannel fileChannel02 = fileOutputStream.getChannel();
        
        ByteBuffer byteBuffer = ByteBuffer.allocate(512);
        
        while (true) { // 循环读取
            // 这里有一个重要的操作，一定不要忘了
            byteBuffer.clear(); // 清空 buffer
            int read = fileChannel01.read(byteBuffer);
            if (read == -1) { // 表示读完
                break;
            }
            // 将 buffer 中的数据写入到 fileChannel02 -- 2.txt
            byteBuffer.flip();
            fileChannel02.write(byteBuffer);
        }
        
        // 关闭相关的流
        fileInputStream.close();
        fileOutputStream.close();
    }
}
```

# P16 Channel 拷贝文件

### 应用实例4-拷贝文件 transferFrom 方法

实例要求：

1. 使用 FileChannel（通道）和方法 transferFrom，完成文件的拷贝
2. 拷贝一张图片
3. 代码演示

```java
public class NIOFileChannel04 {
    public static void main(String[] args) throws Exception {
        // 创建相关流
        FileInputStream fileInputStream = new FileInputStream("d:\\a.jpg");
        FileOutputStream fileOutputStream = new FileOutputStream("d:\\a2.jpg");
        // 获取各个流对应的 fileChannel
        FileChannel sourceCh = fileInputStream.getChannel();
        FileChannel destCh = fileOutputStream.getChannel();
        // 使用 transferFrom 完成拷贝
        destCh.transferFrom(sourceCh, 0, sourceCh.size());
        // 关闭相关通道和流
        sourceCh.close();
        destCh.close();
        fileInputStream.close();
        fileOutputStream.close();
    }
}
```

# P17 Buffer 类型化和只读

### 关于 Buffer 和 Channel 的注意事项和细节

1. ByteBuffer 支持类型化的 put 和 get, put 放入的是什么数据类型，get 就应该使用相应的数据类型来取出，否则可能有 BufferUnferflowException 异常。
2. 可以将一个普通 Buffer 转成只读 Buffer（`buffer.asReadOnlyBuffer()`）
3. NIO 还提供了 MappedByteBuffer，可以让文件直接在内存（堆外的内存）中进行修改，而如何同步到文件由 NIO 来完成
4. 前面我们讲的读写操作，都是通过一个 Buffer 完成的，**NIO 还支持通过多个 Buffer（即 Buffer 数组）完成读写操作**，即 Scattering 和 Gatering

# P18 MappedByteBuffer 使用

```java
// MappedByteBuffer 可让文件直接在内存（堆外内存）修改，操作系统不需要拷贝一次
public class MappedByteBufferTest {
    public static void main(String[] args) throws Exception {
        RandomAccessFile randomAccessible = new RandomAccessFile("1.txt", "rw");
        // 获取对应的通道
        FileChannel channel = randomAccessibleFile.getChannel();
        // 参数1：FileChannel.MapMode.READ_WRITE 使用的读写模式
        // 参数2：0：可以直接修改的起始位置
        // 参数3：5：是映射到内存的大小，即将 1.txt 的多少个字节映射到内存
        // 可以直接修改的范围就是 0~5
        MappedByteBuffer mappedByteBuffer = channel.map(FileChannel.MapMode.READ_WRITE, 0, 5);
        mappedByteBuffer.put(0, (byte) 'H');
        mappedByteBuffer.put(3, (byte) '9');
        
        randomAccessFile.close();
        System.out.println("修改成功~");
    }
}
```

# P19 Buffer 的分散和聚集

Scattering：将数据写入到 buffer 时，可以采用 buffer 数组，依次写入【分散】

Gathering：从 buffer 读取数据时，可以采用 buffer 数组，依次读

# P20 Channel 和 Buffer 梳理

# P21 Selector 介绍和原理

## Selector（选择器）

### 基本介绍

1. Java 的 NIO，用非阻塞的 IO 方式。可以用一个线程，处理多个的客户端连接，就会使用到 **Selector（选择器）**
2. **Selector 能够检测多个注册的通道上是否有事件发生（注意：多个 Channel 以事件的方式可以注册到同一个 Selector）**，如果有事件发生，便获取事件然后针对每个事件进行相应的处理。这样就可以只用一个单线程去管理多个通道，也就是管理多个连接和请求。
3. 只有在连接真正有读写事件发生时 ，才会进行读写，就大大地减少了系统开销，并且不必为每个连接都创建一个线程，不用去维护多个线程
4. 避免了多线程之间的上下文切换导致的开销

### Selector 示意图和特点说明

**特点再说明：**

1. Netty 的 IO 线程 NioEventLoop 聚合了 Selector（选择器，也叫多路复用器），可以同时并发处理成百上千个客户端连接。
2. 当线程从某客户端 Socket 通道进行读写数据时，若没有数据可用时，该线程可以进行其他任务。
3. 线程通常将非阻塞 IO 的空闲时间用于在其他通道上执行 IO 操作，所以单独的线程可以管理多个输入和输出通道。
4. 由于读写操作都是非阻塞的，这就可以充分提升 IO 线程的运行效率，避免由于频繁 I/O 阻塞导致的线程挂起。
5. 一个 I/O 线程可以并发处理 N 个客户端连接和读写操作，这从根本上解决了传统同步阻塞 I/O 一连接一线程模式，架构的性能、弹性伸缩能力和可靠性都得到了极大的提升。

# P22 Selector API 介绍

### Selector 类相关方法

Selector 类是一个抽象类，常用方法和说明如下：

```java
public abstract class Selector implements Closable {
    public static Selector open(); // 得到一个选择器对象
    public int select(long timeout); // 监控所有注册的通道，当其中有 IO 操作可以进行时，将对应的 SelectionKey 加入到内部集合中并返回，参数用来设置超时时间
    public Set<SelectionKey> selectedKeys(); // 从内部集合中得到所有的 SelectionKey
}
```

### 注意事项

1. NIO 中的 ServerSocketChannel 功能类似 ServerSocket，SocketChannel 功能类似 Socket

2. selector 相关方法说明

   selector.select(); // 阻塞

   selector.select(1000); // 阻塞 1000 毫秒，在 1000 毫秒后返回

   selector.wakeup(); // 唤醒 selector

   selector.selectNow(); // 不阻塞，立马返还

# P23 SelectionKey 在 NIO 体系

## NIO 非阻塞 网络编程原理分析图

NIO 非阻塞 网络编程相关的（Selector、SelectionKey、ServerSocketChannel 和 SocketChannel）关系梳理图

对图的说明：

1. 当客户端连接时，会通过 ServerSocketChannel 得到 SocketChannel
2. Selector 进行监听 select 方法，返回有事件发生的通道个数。
3. 将 socketChannel 注册到 Selector 上，register(Selector sel, int ops)，一个 selector 上可以注册多个 SocketChannel
4. 注册后返回一个 SelectionKey，会和该 Selector 关联（集合）
5. 进一步得到各个 SelectionKey（有事件发生）
6. 在通过 SelectionKey 反向获取 SocketChannel，方法 channel()
7. 可以通过得到的 channel，完成业务处理
8. 代码撑腰……

# P24 NIO 快速入门（1）

## NIO 非阻塞 网络编程快速入门

案例要求：

1. 编写一个 NIO 入门案例，实现服务器端和客户端之间的数据简单通讯（非阻塞）
2. 目的：理解 NIO 非阻塞网络编程机制
3. 看老师代码演示

```java
public class NIOServer {
    public static void main(String[] args) throws Exception {
        ServerSocketChannel serverSocketChannel = ServerSocketChannel.open();
        Selector selector = Selector.open();
        serverSocketChannel.socket().bind(new InetSocketAddress(6666));
        serverSocketChannel.configureBlocking(false);
        serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);
        
        while (true) {
            if (selector.select(1000) == 0) {
                System.out.println("服务器等待了 1 秒，无连接");
                continue;
            }
            Set<SelectionKey> selectionKeys = selector.selectedKeys();
            Iterator<SelectionKey> keyIterator = selectionKeys.iterator();
            while (keyIterator.hasNext()) {
                SelectionKey key = keyIterator.next();
                if (key.isAcceptable()) {
                    SocketChannel socketChannel = serverSocketChannel.accept();
                    System.out.println("客户端连接成功 生成了一个 socketChannel " + socketChannel.hashCode());
                    socketChannel.configureBlocking(false);
                    socketChannel.register(selector, SelectionKey.OP_READ, ByteBuffer.allocate(1024));
                } 
                if (key.isReadable()) {
                    SocketChannel channel = (SocketChannel) key.channel();
                    ByteBuffer buffer = (ByteBuffer) key.attachment();
                    channel.read(buffer);
                    System.out.println("form 客户端 " + new String(buffer.array()));
                }
                keyIterator.remove();
            }
            
        }
    }
}
```

# P25 NIO 快速入门（2）

```java
public class NIOClient {
    public static void main(String[] args) throws Exception {
        SocketChannel socketChannel = SocketChannel.open();
        socketChannel.configureBlocking(false);
        InetSocketAddress inetSocketAddress = new InetSocketAddress("127.0.0.1", 6666);
        if (!socketChannel.connect(inetSocketAddress)) {
            while (!socketChannel.finishConnect()) {
                System.out.println("因为连接需要时间，客户端不会阻塞，可以做其他工作……");
            }
        }
        String str = "hello, 尚硅谷~";
        ByteBuffer buffer = ByteBuffer.wrap(str.getBytes());
        socketChannel.write(buffer);
        System.in.read();
    }
}
```

# P26 NIO 快速入门小结

# P27 SelectionKey API

## SelectionKey

1. SelectionKey，表示 Selector 和网络通道的注册关系，共四种：

   int OP_ACCEPT: 有新的网络连接可以 accept，值为 16

   int OP_CONNECT：代表连接已建立，值为 8

   int OP_READ：代表读操作，值为 1

   int OP_WRITE：代表写操作，值为 4

2. SelectionKey 相关方法

   ```java
   public abstract class SelectionKey {
       public abstract Selector selector(); // 得到与之关联的 Selector 对象
       public abstract SelectableChannel channel(); // 得到与之关联的通道
       public final Object attachment(); // 得到与之关联的共享数据
       public abstract SelectionKey interestOps(int ops); // 设置或改变监听事件
       public final boolean isAcceptable(); // 是否可以 accept
       public final boolean isReadable(); // 是否可以读
       public final boolean isWritable(); // 是否可以写
   }
   ```

   

# P28 SocketChannel API

## ServerSocketChannel

1. ServerSocketChannel 在**服务器端监听新的客户端 Socket 连接**

2. 相关方法如下：

   ```java
   public abstract class ServerSocketChannel
       extends AbstractSelectableChannel
       implements NetworkChannel
   {
       public static ServerSocketChannel open(); // 得到一个 ServerSocketChannel 通道
       public final ServerSocketChannel bind(SocketAddress local); // 设置服务器端端口号
       public final SelectableChannel configureBlocking(boolean block); // 设置阻塞或非阻塞模式，取值 false 表示采用非阻塞模式
       public SocketChannel accept(); // 接收一个连接，返回代表这个连接的通道对象
       public final SelectionKey register(Selector sel, int ops); // 注册一个选择器并设置监听事件
   }
   ```

   

## SocketChannel

1. SocketChannel，网络 IO 通道，**具体负责进行读写操作**。NIO 把缓冲区的数据写入通道，或者把通道里的数据读到缓冲区

2. 相关方法如下：

   ```java
   public abstract class SocketChannel
       extends AbstractSelectableChannel
       implements ByteChannel, ScatteringByteChannel, GatheringByteChannel, NetworkChannel {
       public static SocketChannel open(); // 得到一个 SocketChannel 通道
       public final SelectableChannel configureBlocking(boolean block); // 设置阻塞或非阻塞模式，取值 false 表示采用非阻塞模式
       public boolean connect(SocketAddress remote); // 连接服务器
       public boolean finishConnect(); // 如果上面的方法连接失败，接下来就要通过该方法完成连接操作
       public int write(ByteBuffer src); // 从通道里写数据
       public int read(ByteBuffer dst); // 从通道里读数据
       public final SelectionKey register(Selector sel, int ops, Object att); // 注册一个选择器并设置监听事件，最后一个参数可以设置共享数据
       public final void close(); // 关闭通道
   }
   ```

   

# P29 NIO 群聊系统（1）

# P30 NIO 群聊系统（2）

## NIO 网络编程应用实例-群聊系统

实例要求：

1. 编写一个 NIO 群聊系统，实现服务器端和客户端之间的数据简单通讯（非阻塞）
2. 实现多人群聊
3. 服务器端：可以检测用户上线，离线，并实现消息转发功能
4. 客户端：通过 channel 可以无阻塞发送消息给其他所有用户，同时可以接收其他用户发送的消息（有服务器转发得到）
5. 目的：进一步理解 NIO 非阻塞网络编程机制

```java
public class GroupChatServer {
    private Selector selector;
    private ServerSocketChannel listenChannel;
    private static final int PORT = 6667;
    
    public GroupChatServer() {
        try {
            selector = Selector.open();
            listenChannel = ServerSocketChannel.open();
            listenChannel.socket().bind(new InetSocketAddress(PORT));
            listenChannel.configureBlocking(false);
            listenChannel.register(selector, SelectionKey.OP_ACCEPT);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public void listen() {
        try {
            while (true) {
                int count = selector.select(2000);
                if (count > 0) {
                    Iterator<SelectionKey> iterator = selector.selectedKeys().iterator();
                    while (iterator.hasNext()) {
                        SelectionKey key = iterator.next();
                        if (key.isAcceptable()) {
                            SocketChannel sc = listenChannel.accept();
                            sc.configureBlocking(false);
                            sc.register(selector, SelectionKey.OP_READ);
                            System.out.println(sc.getRemoteAddress() + " 上线 ");
                        }
                        if (key.isReadable()) {
                            
                        }
                        iterator.remove();
                    }
                } else {
                    System.out.println("等待……")
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            
        }
    }
    
    private void readData(SelectionKey key) {
        SocketChannel channel = null;
        try {
            channel = (SocketChannel) key.channel();
            ByteBuffer buffer = ByteBuffer.allocate(1024);
            int count = channel.read(buffer);
            if (count > 0) {
                String msg = new String(buffer.array());
                System.out.println("form 客户端： " + msg);
                sendInfoToOtherClients(msg, channel);
            }
        } catch (IOException e) {
            try {
	            System.out.println(channel.getRemoteAddress() + "离线了……");
                key.cancel();
                channel.close();
            } catch (IOException e2) {
                e2.printStackTrace();
            }
        }
    }
    
    private void sendInfoToOtherClients(String msg, SocketChannel self) throws IOException {
        System.out.println("服务器转发消息中……");
        for (SelectionKey key: selector.keys()) {
            Channel targetChannel = key.channel();
            if (targetChannel instanceof SocketChannel && targetChannel != self) {
                SocketChannel dest = (SocketChannel) targetChannel;
                ByteBuffer buffer = ByteBuffer.wrap(msg.getBytes());
                dest.write(buffer);
            }
        }
    }
    
    public static void main(String[] args) {
        GroupChatServer groupChatServer = new GroupChatServer();
        groupChatServer.listen();
    }
}
```

# P31 NIO 群聊系统（3）

# P32 NIO 群聊系统（4）

```java
public class GroupChatClient {
    private final String HOST = "127.0.0.1";
    private final int PORT = 6667;
    private Selector selector;
    private SocketChannel socketChannel;
    private String username;
    
    public GroupChatClient() throws IOException {
        selector = Selector.open();
        socketChannel = SocketChannel.open(new InetSocketAddress("127.0.0.1", PORT));
        socketChannel.configureBlocking(false);
        socketChannel.register(selector, SelectionKey.OP_READ);
        username = socketChannel.getLocalAddress().toString().substring(1);
        System.out.println(username + "is ok……");
    }
    
    public void sendInfo(String info) {
        info = username + "说：" + info;
        try {
            socketChannel.write(ByteBuffer.wrap(info.getBytes()));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public void readInfo() {
        try {
            int readChannels = selector.select();
            if (readChannels > 0) {
                Iterator<SelectionKeys> iterator = selector.selectedKeys().iterator();
                while (iterator.hasNext()) {
                    SelectionKey key = iterator.next();
                    if (key.isReadable()) {
                        SocketChannel sc = (SocketChannel) key.channel();
                        ByteBuffer buffer = ByteBuffer.allocate(1024);
                        sc.read(buffer);
                        String msg = new String(buffer.array());
                        System.out.println(msg.trim());
                    }
                    iterator.remove();
                }
            } else {
                System.out.println("没有可以用的通道……");
            }
		} catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static main(String[] args) {
        GroupChatClient chatClient = new GroupChatClient();
        new Thread() {
            public void run() {
                while(true) {
                    chatClient.readInfo();
                    try {
                        Thread.currentThread().sleep(3000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }.start();
        
        Scanner scanner = new Scanner(System.in);
        
        while (scanner.hasNextLine()) {
            String s = scanner.nextLine();
            chatClient.sendInfo(s);
        }
    }
}
```

# P33 零拷贝原理剖析

## NIO 与零拷贝

### 零拷贝基本介绍

1. 零拷贝是网络编程的关键，很多性能优化都离不开。
2. 在 Java 程序中，常用的零拷贝有 mmap（内存映射）和 sendFile。那么，他们在 OS 里，到底是怎么样的一个设计？我们分析 mmap 和 sendFile 这两个零拷贝
3. 另外我们看下 NIO 中如何使用零拷贝

### 传统 IO 数据读写

1. Java 传统 IO 和网络编程的一段代码

   ```java
   File file = new File("test.txt");
   RandomAccessFile raf = new RandomAccessFile(file, "rw");
   
   byte[] arr = new byte[(int) file.length()];
   raf.read(arr);
   
   Socket socket = new ServerSocket(8080).accept();
   socket.getOutputStream().write(arr);
   ```

### mmap 优化

1. mmap 通过内存映射，将文件映射到内核缓冲区，同时，用户空间可以共享内核空间的数据。这样，在进行网络传输时，就可以减少内核空间到用户控件的拷贝次数。
2. mmap 示意图

### sendFile 优化

1. Linux 2.1 版本提供了 sendFile 函数，其基本原理如下：数据根本不经过用户态，直接从内核缓冲区进入到 Socket Buffer，同时，由于和用户态完全无关，就减少了一次上下文切换

2. 示意图和小结

3. Linux 在 2.4 版本中，做了一些修改，避免了从内核缓冲区拷贝到 Socket buffer 的操作，直接拷贝到协议栈，从而再一次减少了数据拷贝。具体如下图和小结：

   这里其实有一次 CPU 拷贝 kernel buffer -> socket buffer 但是，拷贝的信息很少，比如 length, offset，消耗低，可以忽略

### 零拷贝的再次理解

1. 我们说的零拷贝，是从操作系统的角度来说的。因为内核缓冲区之间，没有数据是重复的（只有 kernel buffer 有一份数据）。
2. 零拷贝不仅仅带来更少的数据复制，还能带来其他的性能优势，例如更少的上下文切换，更少的 CPU 缓存伪共享以及无 CPU 校验和计算。

### mmap 和 sendFile 的区别

1. mmap 适合小数据量读写，sendFile 适合大文件传输。
2. mmap 需要 4 次上下文切换，3 次数据拷贝；sendFile 需要 3 次上下次切换，最少 2 次数据拷贝。
3. sendFile 可以利用 DMA 方式，减少 CPU 拷贝，mmap 则不能（必须从内核拷贝到 Socket 缓冲区）。

# P34 零拷贝应用实例

### NIO 零拷贝案例

案例要求：

1. 使用传统的 IO 方法传递一个大文件
2. 使用 NIO 零拷贝方式传递（transferTo）一个大文件
3. 看看两种传递方式耗时时间分别是多少

```java
public class OldIOServer {
    public static void main(String[] args) throws Exception {
        ServerSocket serverSocket = new ServerSocket(7001);
        while (true) {
            Socket socket = serverSocket.accept();
            DataInputStream dataInputStream = new DataInputStream(socket.getInputStream());
            
            try {
                byte[] byteArray = new Byte[4096];
                
                while(true) {
                    int readCount = dataInputStream.read(byteArray, 0, byteArray.length);
                    if (-1 == readCount) {
                        break;
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
```



```java
public class OldIOClient {
	public static void main(String[] args) throws Exception {
        Socket socket = new Socket("localhost", 7001);

        String fileName = "protoc-3.6.1-win32.zip";
        InputStream inputStream = new FileInputStream(fileName);
        
        DataOutputStream dataOutputStream = new DataOutputStream(socket.getOutputStream());
        
        byte[] buffer = new byte[4096];
        long readCount;
        long total = 0;
        
        long startTime = System.currentTimeMillis();
        
        while((readCount = inputStream.read(buffer)) >= 0) {
            total += readCount;
            dataOutputStream.write(buffer);
        }
        
        System.out.println("发送总字节数： " + total + "，耗时： " + (System.currentTimeMillis() - startTime));
        
        dataOutputStream.close();
        socket.close();
        inputStream.close();
    }
}
```



```java
public class NewIOServer {
    public static void main(String[] args) throws Exception {
        InetSocketAddress address = new InetSocketAddress(7001);
        ServerSocketChannel serverSocketChannel = ServerSocketChannel.open();
        ServerSocket serverSocket = serverSocketChannel.socket();
        serverSocket.bind(address);
        
        // 创建 buffer
        ByteBuffer byteBuffer = ByteBuffer.allocate(4096);
        
        while (true) {
            SocketChannel socketChannel = serverSocketChannel.accept();
            int readCount = 0;
            if (-1 != readCount) {
                try {
                    readCount = socketChannel.read(byteBuffer);
                } catch (Exception ex) {
                    // ex.printStackTrace();
                    break;
                }
                byteBuffer.rewind(); // 倒带 position = 0 mark 作废
            }
        }
    }
}
```



```java
public class NewIOClient {
    public static void main(String[] args) throws Exception {
        SocketChannel socketChannel = SocketChannel.open();
        socketChannel.connect(new InetSocketAddress("localhost", 7001));
        String filename = "protoc-3.6.1-win32.zip";
        // 得到一个文件 channel
        FileChannel fileChannel = new FileInputStream(filename).getChannel();
        // 准备发送
        long startTime = System.currentTimeMillis();
        
        // 在 Linux 下一个 transferTo 方法就可以完成传输
        // 在 Windows 下一次调用 transferTo 只能发送 8m，就需要分段传输文件，而且要注意传输时的位置
        // transferTo 底层使用到零拷贝
        long transferCount = fileChannel.transferTo(0, fileChannel.size(), socketChannel);
        
        System.out.println("发送的总的字节数 = " + transferCount + " 耗时：" + (System.currentTimeMillis() - startTime));
        
        // 关闭
        fileChannel.close();
	}
}
```

# P35 零拷贝 AIO 内容梳理

## Java AIO 基本介绍

1. JDK 7 引入了 Asynchronous I/O, 即 AIO。在进行 I/O 编程中，常用到两种模式：Reactor 和 Proactor。Java 的 NIO 就是 Reactor，当有事件触发时，服务器端得到通知，进行相应的处理
2. AIO 即 NIO 2.0，叫做异步不阻塞的 IO。AIO 引入异步通道的概念，采用了 Proactor 模式，简化了程序编写，有效的请求才启动线程，它的特点是先由操作系统才通知服务端程序启动线程去处理，一般适用于连接数较多且连接时间较长的应用。
3. 目前 AIO 还没有广泛应用，Netty 也是基于 NIO，而不是 AIO，因此我们就不详解 AIO 了，有兴趣的同学可以参考《Java 新一代网络编程模型 AIO 原理及 Linux 系统 AIO 介绍》

## BIO、NIO、AIO 对比表

|          | BIO      | NIO                    | AIO        |
| -------- | -------- | ---------------------- | ---------- |
| IO 模型  | 同步阻塞 | 同步非阻塞（多路复用） | 异步非阻塞 |
| 编程难度 | 简单     | 复杂                   | 复杂       |
| 可靠性   | 差       | 好                     | 好         |
| 吞吐量   | 低       | 高                     | 高         |

举例说明：

1. **同步阻塞**：到理发店理发，就一直等理发师，直到轮到自己理发
2. **同步非阻塞**：到理发店理发，发现前面有其他人理发，给理发师说下，先干其他事情，一会过来看是否轮到自己。
3. **异步非阻塞**：给理发师打电话，让理发师上面服务，自己干其它事情，理发师自己来家给你理发

# P36 Netty 概述

## 原生 NIO 存在的问题

1. NIO 的类库和 API 繁杂，使用麻烦：需要熟练掌握 Selector、ServerSocketChannel、SocketChannel、ByteBuffer 等
2. 需要具备其他的额外技能：要熟悉 Java 多线程编程，因为 NIO 编程涉及到 Reactor 模式，你必须对多线程和网络编程非常熟悉，才能编写出高质量的 NIO 程序。
3. 开发工作量和难度都非常大：例如客户端面临断连重连、网络闪断、半包读写、失败缓存、网络拥塞和异常流的处理等等。
4. JDK NIO 的 bug：例如臭名昭著的 Epoll Bug，它会导致 Selector 空轮询，最终导致 CPU 100%，直到 JDK 1.7 版本该问题仍旧存在，没有被根本解决。

## Netty 官网说明

官网：https://netty.io/

Netty is an asynchorouns event-driven network application framework for rapid development of maintainable high performance protocol servers & clients

1. Netty 是由 JBOSS 提供的一个 Java 开源框架。Netty 提供异步的、基于事件驱动的网络应用程序框架，用以快速开发高性能、高可靠性的网络 IO 程序
2. Netty 可以帮助你快速、简单的开发出一个网络应用，相当于简化和流程化了 NIO 的开发过程
3. Netty 是目前最流行的 NIO 框架，Netty 在互联网领域、大数据分布式计算领域、游戏行业、通信行业等获得了广泛的应用，知名的 Elasticsearch、Dubbo 框架内部都采用了 Netty。

## Netty 的优点

Netty 对 JDK 自带的 NIO 的 API 进行了封装，解决了上述问题

1. 设计优雅：适用于各种传输类型的统一 API 阻塞和非阻塞 Socket；基于灵活且可扩展的事件模型，可以清晰地分离关注点；高度可定制的线程模型 - 单线程，一个或多个线程池。
2. 使用方便：详细记录的 Javadoc，用户指南和示例；没有其它依赖项，JDK 5 （Netty 3.x）或 6（Netty 4.x）就足够了。（*注：截至 2024.3.14, Netty 5.0.0-Alpha5 是 2022 年 9 月 28 发布的版本，4.1.107.Final 是 2024 年 2 月 13 日发布的版本，所以尚硅谷这个视频应该时效性不受太大影响*）
3. 高性能、吞吐量更高：延迟更低；减少资源消耗；最小化不必要的内存复制。
4. 安全：完整的 SSL/TLS 和 StartTLS 支持。
5. 社区活跃、不断更新：社区活跃，版本迭代周期短，发现的 Bug 可以被及时修复，同时，更多的新功能会被加入

## Netty 版本说明

1. Netty 版本分为 Netty 3.x 和 Netty 4.x、Netty 5.x
2. 因为 Netty 5 出现重大 bug，已经被官网废弃了，目前推荐使用的是 Netty 4.x 的稳定版本
3. 目前在官网可下载的版本 Netty 3.x Netty 4.0.x 和 Netty 4.1.x
4. 在本套课程中，我们讲解 Netty 4.1.x 版本
5. netty 下载地址：https://bintray.com/netty/downloads/netty/

（*视频里面最新是 4.1.42.Final*）