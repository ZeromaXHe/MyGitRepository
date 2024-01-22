[图灵vip讲师诸葛](https://space.bilibili.com/414451999) 《一个半小时学会轻量级、跨语言的RPC框架Thrift【通俗易懂】》

https://www.bilibili.com/video/BV1LP4y1w7e6

# P1 Thrift 课程介绍



# P2 什么是 Thrift

## Thrift 的定义

Thrift 是一个轻量级、跨语言的 RPC 框架，主要用于各个服务之间的 RPC 通信。最初由 Facebook 于 2007 年开发，2008 年进入 Apache 开源项目。它通过自身的 IDL 中间语言，并借助代码生成引擎生成各种主流语言的 RPC 服务端/客户端模板代码。Thrift 支持多种不同的编程语言，包括 C++、Java、Python、PHP、Ruby、Erlang、Haskell、C#、Cocoa、Javascript、Node.js、Smalltalk、OCaml、Golang 等，本系列主要讲述基于 Java 语言的 Thrift 的配置方式和具体使用。

> RPC 全程 Remote Procedure Call —— 远程过程调用。RPC 技术简单说就是为了解决远程调用服务的一种技术，使得调用者像调用本地服务一样方便透明。

## Thrift 的架构

Thrift 技术栈分层从下向上分别为：传输层（Transport Layer）、协议层（Protocol Layer）、处理层（Processor Layer）和服务层（Server Layer）。

- **传输层（Transport Layer）**：传输层负责直接从网络中读取和写入数据，它定义了具体的网络传输协议；比如说 TCP/IP 传输等。
- **协议层（Protocol  Layer）**：协议层定义了数据传输格式，负责网络传输数据的序列化和反序列化；比如说 JSON、XML、二进制数据等。
- **处理层（Processor Layer）**：处理层是由具体的 IDL（接口描述语言）生成的，封装了具体的底层网络传输和序列化方式，并委托给用户实现的 Handler 进行处理。
- **服务层（Server Layer）**：整合上述组件，提供具体的网络 IO 模型（单线程/多线程/事件驱动），形成最终的服务。

# P3 Thrift 的特性和优势

## Thrift 的特性

### 开发速度快

通过编写 RPC 接口 Thrift IDL 文件，利用编译生成器自动生成服务端骨架（Skeletons）和客户端桩（Stubs）。从而省去开发者自定义和维护接口编解码、消息传输、服务器多线程模型等基础工作。

服务端：只需要按照服务骨架即接口，编写好具体的业务处理程序（Handler）即实现类即可。

客户端：只需要拷贝 IDL 定义好的客户端桩和服务对象，然后就像调用本地对象的方法一样调用远端服务。

### 接口维护简单

通过维护 Thrift 格式的 IDL（接口描述语言）文件（注意写好注释），即可作为给 Client 使用的接口文档使用，也自动生成接口代码，始终保持代码和文档的一致性。且 Thrift 协议可灵活支持接口的可扩展性。

### 学习成本低

因为其来自 Google Protobuf 开发团队，所以其 IDL 文件风格类似 Google Protobuf，且更加易读易懂；特别是 RPC 服务接口的风格就像写一个面向对象的 Class 一样简单。

初学者只需参照：http://thrift.apache.org/，一个多小时就可以理解 Thrift IDL 文件的语法使用。

### 多语言/跨语言支持

Thrift 支持 C++、Java、Python、PHP、Ruby、Erlang、Perl、Haskell、C#、Cocoa、Javascript、Node.js、Smalltalk、OCaml、Golang 等多种语言，即可生成上述语言的服务器端和客户端程序。

### 稳定/广泛使用

Thrift 在很多开源项目中已经被验证是稳定和高效的，例如 Cassandra、Hadoop、HBase 等；国外在 Facebook 中有广泛使用，国内包括百度、美团、小米和饿了么等公司

# P4 Thrift IDL 语法详解

Thrift 是一个典型的 CS（客户端/服务端）结构，客户端和服务端可以使用不同的语言开发。既然客户端和服务端能使用不同的语言开发，那么一定就要有一种中间语言来关联客户端和服务端的语言，这种语言就是 IDL（Interface Description Language）

Thrift 采用 IDL（Interface Definition Language）来定义通用的服务接口，然后通过 Thrift 提供的编译器，可以将服务接口编译成不同语言编写的代码，通过这个方式来实现跨语言的功能。

## IDL 语法

### 基本类型（Base Types）

基本类型就是：不管哪一种语言，都支持的数据形式表现。Apache Thrift 中支持以下几种基本类型：

| Type   | Desc                         | Java             | Go      |
| ------ | ---------------------------- | ---------------- | ------- |
| i8     | 有符号的 8 位整数            | byte             | int8    |
| i16    | 有符号的 16 位整数           | short            | int16   |
| i32    | 有符号的 32 位整数           | int              | int32   |
| i64    | 有符合的 64 位整数           | long             | int64   |
| double | 64 位浮点数                  | double           | float64 |
| bool   | 布尔值                       | boolean          | bool    |
| string | 文本字符串（UTF-8 编码格式） | java.lang.String | string  |

### 特殊类型（Special Types）

binary：未编码的字节序列，是 string 的一种特殊形式；这种类型主要是方便某些场景下 JAVA 调用。JAVA 中对应的是 java.nio.ByteBuffer 类型，GO 中是 []byte。

### 集合容器（Containers）

有 3 种可用容器类型：

| Type       | Desc                               | JAVA           | GO       | remark                     |
| ---------- | ---------------------------------- | -------------- | -------- | -------------------------- |
| `List<T>`  | 元素有序列表，允许重复             | java.util.List | []T      |                            |
| `Set<T>`   | 元素无序列表，不允许重复           | java.util.Set  | []T      | Go 没有 Set 集合以数组代替 |
| `Map<K,V>` | key-value 结构数据，key 不允许重复 | java.util.Map  | map[K] V |                            |

在使用容器类型时必须指定泛型，否则无法编译 idl 文件。其次，泛型中的基本类型，JAVA 语言中会被替换为对应的包装类型。

集合中的元素可以是除了 service 之外的任何类型，包括 exception。

```idl
struct Test {
	1: map<string, User> usermap,
	2: set<i32> intset,
	3: list<double> doublelist
}
```

### 常量及类型别名（Const & Typedef）

```idl
// 常量定义
const i32 MALE_INT = 1
const map<i32, string> GENDER_MAP = {1: "male", 2: "female"}
// 某些数据类型比较长可以用别名简化
typedef map<i32, string> gmp
```

### struct 类型

在面向对象语言中，表现为“类定义”；在弱类型语言、动态语言中，表现为“结构/结构体”。定义格式如下：

```idl
struct <结构体名称> {
	<序号>: [字段性质] <字段类型> <字段名称> [= <默认值>] [;|,]
}
```

例如：

```idl
struct User {
	1: required string name, // 该字段必须填写
	2: optional i32 age = 0; // 默认值
	3: bool gender // 默认字段类型为 optional
}

struct bean {
	1: i32 number = 10,
	2: i64 bigNumber,
	3: double decimals,
	4: string name = "thrifty"
}
```

struct 有以下一些约束：

1. struct 不能继承，但是可以嵌套，不能嵌套自己。
2. 其成员都是有明确类型
3. 成员是被正整数编号过的，其中的编号是不能重复的，这个是为了在传输过程中编码使用。
4. 成员分隔符可以是逗号（,）或者是分号（;），而且可以混用
5. 字段会有 optional 和 required 之分和 protobuf 一样，但是如果不指定则为无类型——可以不填充该值，但是在序列化传输的时候也会序列化进去，optional 是不填充则不序列化，required 是必须填充也必须序列化。
6. 每个字段可以设置默认值
7. 同一文件可以定义多个 struct，也可以定义在不同的文件，进行 include 引入。

### 枚举（enum）

Thrift 不支持枚举类嵌套，枚举常量必须是 32 位的正整数

```idl
enum HttpStatus {
	OK = 200,
	NOTFOUND = 404
}
```

### 异常（Exception）

异常在语法和功能上类似于结构体，差别是异常使用关键字 exception，而且异常是继承每种语言的基础异常类。

```idl
exception MyException {
	1: i32 errorCode
	2: string message
}

service ExampleService {
	string GetName() throws (1: MyException e)
}
```

Service（服务定义类型）

服务的定义方法在语义上等同于面向对象语言中的接口。

```idl
service HelloService {
	i32 sayInt(1:i32 param)
	string sayString(1:string param)
	bool sayBoolean(1:bool param)
	void sayVoid()
}
```

编译后的 Java 代码

```java
public class HelloService {
    public interface Iface {
        public int sayInt(int param) throws org.apache.thrift.TException;
        public java.lang.String sayString(int param) throws org.apache.thrift.TException;
        public boolean sayBoolean(boolean param) throws org.apache.thrift.TException;
        public void sayVoid() throws org.apache.thrift.TException;
    }
    // ... 省略很多代码
}
```

### Namespace（名字空间）

Thrift 中的命名空间类似于 C++ 中的 namespace 和 Java 中的 package，它们提供了一种组织（隔离）代码的简便方式。名字空间也可以用于解决类型定义中的名字冲突。

由于每种语言均有自己的命名空间定义方式（如 python 中有 module），thrift 允许开发者针对特定语言定义 namespace。

```idl
namespace java com.example.test
```

转化成

```java
package com.example.test
```

### Comment（注释）

Thrift 支持 C 多行风格和 Java/C++ 单行风格。

```idl
/**
 * This is a multi-line comment.
 * Just like in C
 */
// C++/Java style single-line comments work just as well.
```

### Include

便于管理、重用和提高模块性/组织性，我们常常分割 Thrift 定义在不同的文件中。包含文件搜索方式与 C++ 一样。Thrift 允许文件包含其它 thrift 文件，用户需要使用 thrift 文件名作为前缀访问被包含的对象。

```idl
include "test.thrift"
```

thrift 文件名要用双引号包含，末尾没有逗号或者分号

# P5 Thrift 编译器安装 & IDL 编译

## IDL 文件编译

IDL 文件可以直接用生成各种语言的代码，下面给出常用的各种不同语言的代码生成命令：

```shell
# 生成 Java
thrift --gen java user.thrift
# 生成 C++
thrift --gen cpp user.thrift
# 生成 PHP
thrift --gen php user.thrift
# 生成 Node.js
thrift --gen js:node user.thrift

# 可以通过以下命令查看生成命令的格式
thrift -help

# 指定输出目录
# 生成 Java
thrift --gen java -o target user.thrift
```

# P6 Thrift 常见协议和传输层

## Thrift 的协议

Thrift 可以让用户选择客户端与服务端之间传输通信协议的类别，在传输协议上总体划分为文本（text）和二进制（binary）传输协议。为节约带宽，提高传输效率，一般情况下使用二进制类型的传输协议为多数，有时还会使用基于文本类型的协议，这需要根据项目/产品中的实际需求。常用协议有以下几种：

- TBinaryProtocol：二进制编码格式进行数据传输
- TCompactProtocol：高效率的、密集的二进制编码格式进行数据传输
- TJSONProtocol：使用 JSON 文本的数据编码协议进行数据传输
- TSimpleJSONProtocol：只提供 JSON 只写的协议，适用于通过脚本语言解析

## Thrift 的传输层

常用的传输层有以下几种：

- TSocket：使用阻塞式 I/O 进行传输，是最常见的模式
- TNonblockingTransport：使用非阻塞方式，用于构建异步客户端
- TFrameTransport：使用非阻塞方式，按块的大小进行传输，类似于 Java 中的 NIO

# P7 快速入门Demo实现

1. 编写 user.thrift 文件
   ```idl
   namespace java com.tuling
   
   struct User {
   	1:i32 id
   	2:string name
   	3:i32 age=0
   }
   
   service UserService {
   	User getById(1:i32 id)
   	bool isExist(1:string name)
   }
   ```

2. 通过编译器编译 user.thrift 文件，生成 Java 接口类文件
   ```shell
   # 编译 user.thrift
   thrift --gen java user.thrift
   ```

   由于未指定代码生成的目标目录，生成的类文件默认存放在 `gen-java` 目录下

   对于开发人员而言，使用原生的 Thrift 框架，仅需要关注以下四个核心内部接口/类：Iface，AsyncIface，Client 和 AsyncClient。

   - Iface：服务端通过实现 UserService.Iface 接口，向客户端的提供具体的同步业务逻辑。
   - AsyncIface：服务端通过实现 UserService.Iface 接口，向客户端的提供具体异步业务逻辑
   - Client：客户端通过 UserService.Client 的实例对象，以同步的方式访问服务端提供的服务方法
   - AsyncClient：客户端通过 UserService.AsyncClient 的实例对象，以异步的方式访问服务端提供的服务方法

3. 单线程同步阻塞 demo

   新建 maven 工程，引入 thrift 依赖

   ```xml
   <dependency>
       <groupId>org.apache.thrift</groupId>
       <artifactId>libthrift</artifactId>
       <version>0.15.0</version>
   </dependency>
   ```

   将生成类的 UserService.java 源文件拷贝进项目源文件目录中，并实现 UserService.Iface 的定义的 getById() 方法。

   ```java
   public class UserServiceImpl implements UserService.Iface {
       @Override
       public User getById(int id) throws TException {
           System.out.println("=====调用getById=====");
           // todo 模拟业务调用
           User user = new User();
           user.setId(id);
           user.setName("fox");
           user.setAge(30);
           return user;
       }
       
       @Override
       public boolean isExist(String name) throws TException {
           return false;
       }
   }
   ```

4. 服务端程序编写

   ```java
   public class SimpleService {
       public static void main(String[] args) {
           try {
               TServerTransport serverTransport = new TServerSocket(9090);
               
               // 获取 processor
               UserService.Processor processor = new UserService.Processor(new UserServiceImpl());
               // 指定 TBinaryProtocol
               TBinaryProtocol.Factory protocolFactory = new TBinaryProtocol.Factory();
               
               TSimpleServer.Args targs = new TSimpleServer.Args(serverTransport);
               targs.processor(processor);
               targs.protocolFactory(protocolFactory);
               
               // 单线程服务模型
               TServer server = new TSimpleServer(targs);
               
               System.out.println("Starting the simple server...");
               server.serve();
           } catch (Exception e) {
               e.printStackTrace();
           }
       }
   }
   ```

   运行服务端程序，服务端在指定端口监听客户端的连接请求

5. 客户端程序编写

   ```java
   public class SimpleClient {
       public static void main(String[] args) {
           TTransport transport = null;
           try {
               // 使用阻塞 IO
               transport = new TSocket("localhost", 9090);
               // 指定二进制编码格式
               TProtocol protocol = new TBinaryProtocol(transport);
               UserService.Client client = new UserService.Client(protocol);
               transport.open();
               
               // 发起 rpc 调用
               User result = client.getById(1);
               System.out.println("Result: " + result);
           } catch (TException e) {
               e.printStackTrace();
           } finally {
               if (null != transport) {
                   transport.close();
               }
           }
       }
   }
   ```

   运行客户端程序，客户端通过网络请求 HelloWorldService 的 getById() 方法的具体实现，控制台输出返回结果

# P8 Python 跨语言调用 Java 服务

1. 通过编译器编译 user.thrift 文件，生成 python 代码

   ```shell
   thrift --gen py user.thrift
   ```

   然后将生成的 python 代码和文件，放到新建的 python 项目中

2. python 中使用 thrift 需要安装 thrift 模块

   ```
   pip install thrift
   ```

3. 创建 python 客户端程序

   ```python
   from thrift.transport import TSocket, TTransport
   from thrift.protocol import TBinaryProtocol
   
   from com.tuling import UserService
   
   # Make socket
   transport = TSocket.TSocket('localhost', 9090)
   transport.setTimeout(600)
   
   # Buffering is critical. Raw sockets are very slow
   transport = TTransport.TBufferedTransport(transport)
   
   # Wrap in a protocol
   protocol = TBinaryProtocol.TBinaryProtocol(transport)
   
   # Create a client to use the protocol encoder
   client = UserService.Client(protocol)
   
   # Connect!
   transport.open()
   
   result = client.getById(1)
   
   print(result)
   ```

# P9 单线程阻塞模型 TSimpleServer 详解

## 网络服务模型详解

Thrift 提供的网络服务模型：单线程、多线程、事件驱动，从另一个角度划分为：阻塞服务模型、非阻塞服务模型。

- 阻塞服务模型：TSimpleServer、TThreadPoolServer。
- 非阻塞服务模型：TNonblockingServer、THsHaServer 和 TThreadedSelectorServer

### TServer

TServer 定义了静态内部类 Args，Args 继承自抽象类 AbstractServerArgs。AbstractServerArgs 采用了建造者模式，向 TServer 提供各种工厂

| 工厂属性               | 工厂类型          | 作用                                               |
| ---------------------- | ----------------- | -------------------------------------------------- |
| ProcessFactory         | TProcessFactory   | 处理层工厂类，用于具体的 TProcessor 对象的创建     |
| InputTransportFactory  | TTransportFactory | 传输层输入工厂类，用于具体的 TTransport 对象的创建 |
| OutputTransportFactory | TTransportFactory | 传输层输出工厂类，用于具体的 TTransport 对象的创建 |
| InputProtocolFactory   | TProtocolFactory  | 协议层输入工厂类，用于具体的 TProtocol 对象的创建  |
| OutputProtocolFactory  | TProtocolFactory  | 协议层输出工厂类，用于具体的 TProtocol 对象的创建  |

TServer 的三个方法：serve()、stop() 和 isServing()。serve() 用于启动服务，stop() 用于关闭服务，isServing() 用于检测服务的启停状态。

### TSimpleServer

TSimpleServer 的工作模式采用最简单的阻塞 IO，实现方法简洁明了，便于理解，但是一次只能接收处理一鞥socket 连接，效率比较低。它主要用于演示 Thrift 的工作过程，在实际开发过程中很少用到它。

# P10 多线程阻塞模型 TThreadPoolServer 详解

## TThreadPoolServer

TThreadPoolServer 模式采用阻塞 socket 方式工作，主线程负责阻塞式监听是否有新 socket 到来，具体的业务处理交由一个线程池来处理。

### 优点

拆分了监听线程（Accept Thread）和处理客户端连接的工作线程（Worker Thread），数据读取和业务处理都交给线程池处理。因此在并发量较大时新连接也能够被及时接受。

线程池模式比较适合服务器端能预知最多有多少个客户端并发的情况，这时每个请求都能被业务线程池即时处理，性能也非常高。

### 缺点

线程池模式的处理能力受限于线程池的工作能力，当并发请求数大于线程池中的线程数时，新请求也只能排队等待。

默认线程池运行创建的最大线程数量为 Integer.MAX_VALUE，可能会创建出大量线程，导致 OOM（内存溢出）

# P11 单线程非阻塞模型 TNonblockingServer 详解

## TNonblockingServer

TNonblockingServer 模式也是单线程工作，但是采用 NIO 的模式，利用 IO 多路复用模型处理 socket 就绪事件，对于有数据到来的 socket 进行数据读取操作，对于有数据发送的 socket 则进行数据发送操作，对于监听 socket 则产生一个新业务 socket 并将其注册到 selector 上。

> 注意：TNonblockingServer 要求底层的传输通道必须使用 TFramedTransport

### 优点

相比于 TSimpleServer 效率提升主要体现在 IO 多路复用上，TNonblockingServer 采用非阻塞 IO，对 accept/read/write 等 IO 事件进行监控和处理，同时监控多个 socket 的状态变化。

### 缺点

TNonblockingServer 模式在业务处理上还是采用单线程顺序来完成。在业务处理比较复杂、耗时的时候，例如某些接口函数需要读取数据库执行时间较长，会导致整个服务被阻塞住，此时该模式效率也不高，因为多个调用请求任务依然是顺序一个接一个执行。

# P12 多线程非阻塞模型 THsHaServer 详解

## THsHaServer

鉴于 TNonblockingServer 的缺点，THsHaServer 继承于 TNonblockingServer，引入了线程池提高了任务处理的并发能力。

> 注意：THsHaServer 和 TNonblockingServer 一样，要求底层的传输通道必须使用 TFramedTransport

### 优点

THsHaServer 与 TNonblockingServer 模式相比，THsHaServer 在完成数据读取之后，将业务处理过程交由一个线程池来完成，主线程直接返回下一次循环操作，效率大大提升。

### 缺点

主线程仍然需要完成所有 socket 的监听接收、数据读取和数据写入操作。当并发请求数较大时，且发送数据量较多时，监听 socket 上新连接请求不能被及时接受。

# P13 多 Reactor 模型 TThreadedSelectorServer 详解

## TThreadedSelectorServer

TThreadedSelectorServer 是对 THsHaServer 的一种补充，它将 selector 中的读写 IO 事件（read/write）从主线程中分离出来。同时引入 worker 工作线程池。

TThreadedSelectorServer 模式是目前 Thrift 提供的最高级的线程服务模型，它内部有几个部分构成：

1. 一个 AcceptThread 专门用于处理监听 socket 上的新连接。
2. 若干个 SelectorThread 专门用于处理业务 socket 的网络 I/O 读写操作，所以网络数据的读写均是有这些线程来完成。
3. 一个负载均衡器 SelectorThreadLocalBalancer 对象，主要用于 AcceptThread 线程接收到一个新 socket 连接请求时，决定将这个新连接请求分配给哪个 SelectorThread 线程。
4. 一个 ExecutorService 类型的工作线程池，在 SelectorThread 线程中，监听到有业务 socket 中有调用请求过来，则将请求数据读取之后，交给 ExecutorService 线程池中的线程完成此次调用的具体执行。主要用于处理每个 rpc 请求的 handler 回调结果。

# P14 补充：Reactor 模型理解

Scalable IO in Java