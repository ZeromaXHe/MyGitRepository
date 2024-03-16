Dubbo源码解读与实战

原作应该是拉勾教育

up 主：[gzqhero](https://space.bilibili.com/381340790) 2023-03-30 20:26:01 这个分P排序乱了，但我笔记按的是这个看的。所以分 P 是按这个视频写的，但是后面序号是按真正视频教程的序号写的

https://www.bilibili.com/video/BV1Bc411V7AR

up 主：[正经教主](https://space.bilibili.com/1886736397) 2023-01-27 02:36:02 这个分p是顺序的

https://www.bilibili.com/video/BV1TY411Q7va

# P1 00 开篇词 深入掌握 Dubbo 原理与实现，提升你的职场竞争力

## 为什么要学习 Dubbo

技术的价值——解决一些业务场景难题



DAU、订单量、数据量的不断增长

用来支撑业务的系统复杂度不断提高

模块之间的依赖关系日益复杂



单体架构 VS 集群架构



**将一个巨型业务系统拆分成多个微服务**

**根据不同服务对资源的不同要求，选择更合理的硬件资源**

例如，有些流量较小的服务只需要几台机器构成的集群

核心业务需要成百上千的机器来支持



**在服务维度进行重用**

在需要某个服务时，直接接入



Apache Dubbo 是一款高性能、轻量级的开源 Java RPC 框架

- 面向接口的远程方法调用
- 可靠、智能的容错和负载均衡
- 服务自动注册和发现能力



Dubbo 是一个分布式服务框架

致力于提供高性能、透明化的 RPC 远程服务调用方案以及服务治理方案

解决微服务架构落地时的问题



Dubbo 由阿里开源，后加入 Apache 基金会

Apache Dubbo 目前已经有接近 32.8K 的 Star、21.4K 的 Fork

很多互联网大厂（如 阿里、滴滴、去哪儿网等）使用 Dubbo 作为其 RPC 框架

有些大厂会基于 Dubbo 进行二次开发实现自己的 RPC 框架，如当当网的 DubboX



Dubbo 和 Spring Cloud 是目前主流的微服务框架

RPC 框架的核心原理和设计是相通的

## 阅读 Dubbo 源码的痛点

技能学习三层次图

- 是什么
- 怎么用
- 原理



- 阅读 Dubbo 官方文档或是几篇介绍性的文章
- 用 Dubbo 写几个项目
- 研究 Dubbo 的源码实现以及底层原理



- 网络资料大多是复制 Dubbo 官方文档，没有任何个人实现和经验分享，花费精力且收获不大
- 相关资料讲述的 Dubbo 版本比较陈旧，或者切入点很小
- 对于一个相对陌生的开源项目，自己直接去阅读 Dubbo 源码是一个非常痛苦的过程



## 课程设置

我曾经分享过各种开源项目的源码分析资料

本课程——**根据自己丰富的开源项目分析经验来带你一起阅读 Dubbo 源码**

# P2 01 Dubbo 源码环境搭建：千里之行，始于足下

- 整体过一下 Dubbo 的架构
- 动手搭建 Dubbo 源码环境，构建一个 Demo 示例可运行的最简环境
- 深入介绍 Dubbo 源码中各个核心模块的功能

## Dubbo 核心架构图

0.Container -start-> Provider (init)

1. Provider -register-> Registry (init)
2. Consumer -subscribe-> Registry (init)
3. Registry -notify-> Consumer (async)
4. Consumer -invoke-> Provider (sync)
5. Monitor count Consumer\Provider (async)

## 搭建 Dubbo 源码环境

从官方仓库 https://github.com/apache/dubbo Fork 到自己的仓库

```shell
git clone git@github.com:xxxxxxx/dubbo.git
```

切换分支

```shell
git checkout -b dubbo-2.7.7 dubbo-2.7.7
```

执行 mvn 命令进行编译

```shell
mvn clean install -Dmaven.test.skip=true
```

转换成 IDEA 项目

```shell
mvn idea:idea
# 要是执行报错，就执行这个 mvn idea:workspace
```

IDEA 成功导入 Dubbo 源码之后的项目结构（4:53）



dubbo-common 模块（5:06）

src/main/java/org.apache.dubbo/common/

- compiler 动态编译相关的实现
- config 配置相关实现
- constants 一些常量定义，尤其是 URL 参数的 Key
- convert 比较实用的类型转换器集合
- extension Dubbo SPI 的核心实现
- io 一些 IO 相关的工具类
- logger 对多款 Java 日志框架的集成
- threadlocal ThreadLocal 相关工具类
- threadpool 线程池相关的工具类
- timer 时间轮的核心实现
- utils 一些通用的工具类集合



dubbo-remoting 模块

远程通信模块。子模块根据各个开源组件实现远程通信

- dubbo-remoting-api 定义了该模块的核心概念
- dubbo-remoting-etcd3
- dubbo-remoting-grizzly
- dubbo-remoting-http
- dubbo-remoting-mina
- dubbo-remoting-netty
- dubbo-remoting-netty4
- dubbo-remoting-p2p
- dubbo-remoting-zookeeper



dubbo-rpc 模块

远程调用模块。1对1的调用，不关心集群的相关内容

- dubbo-rpc-api
- dubbo-rpc-dubbo 基于 dubbo 协议的实现
- dubbo-rpc-grpc
- dubbo-rpc-hessian
- dubbo-rpc-http
- dubbo-rpc-injvm
- dubbo-rpc-memcached
- dubbo-rpc-native-thrift
- dubbo-rpc-redis
- dubbo-rpc-rest
- dubbo-rpc-rmi
- dubbo-rpc-thrift
- dubbo-rpc-webservice
- dubbo-rpc-xml



dubbo-cluster 模块：

Dubbo 中负责管理集群的模块，提供了负载均衡、容错、路由等一系列集群相关的功能

最终的目的是将多个 Provider 伪装为一个 Provider

这样 Consumer 就可以像调用一个 Provider 那样调用 Provider 集群



dubbo-registry 模块：

Dubbo 中负责与多个开源注册中心进行交互的模块，提供注册中心的能力

- dubbo-registry-api 抽象
- dubbo-registry-consul
- dubbo-registry-default
- dubbo-registry-etcd3
- dubbo-registry-eureka
- dubbo-registry-multicast
- dubbo-registry-multiple
- dubbo-registry-nacos
- dubbo-registry-redis
- dubbo-registry-sofa
- dubbo-registry-zookeeper 接入 ZooKeeper 的具体实现



dubbo-monitor 模块：

Dubbo 的监控模块，主要用于统计服务调用次数、调用时间以及实现调用链跟踪的服务



dubbo-config 模块

Dubbo 对外暴露的配置，都是由该模块进行解析的。有了 dubbo-config 模块，用户只需了解 Dubbo 配置的规则，即可使用 Dubbo，无需了解内部细节

- dubbo-config-api 负责处理 API 方式使用时的相关配置
- dubbo-config-spring 负责处理与 Spring 集成时使用的相关配置



dubbo-metadata 模块

元数据模块

- dubbo-metadata-api
- dubbo-metadata-definition-protobuf
- dubbo-metadata-processor
- dubbo-metadata-report-consul
- dubbo-metadata-report-etcd
- dubbo-metadata-report-nacos
- dubbo-metadata-report-redis
- dubbo-metadata-report-zookeeper



dubbo-configcenter 模块

Dubbo 的动态配置模块，负责外部化配置，以及服务治理。提供了多个子模块，用来接入多个开源的服务发现组件

- dubbo-configcenter-apollo
- dubbo-configcenter-consul
- dubbo-configcenter-etcd
- dubbo-configcenter-nacos
- dubbo-configcenter-zookeeper



## Dubbo 源码中的 Demo 示例

使用 XML 配置的 Demo 示例

使用注解配置的 Demo 示例

直接使用 API 的 Demo 示例



## 启动 ZooKeeper

Dubbo 基本都是**用 ZooKeeper 作为注册中心**



下载 zookeeper-3.4.14.tar.gz 包之后执行如下命令解压缩：

```shell
tar -zxf zookeeper-3.4.14.tar.gz
```

执行如下命令：

```shell
./bin/zkServer.sh start
# 下面为输出内容
# ZooKeeper JMX enabled by default
# Using config: /Users/xxx/zookeeper-3.4.14/bin/../conf/zoo.cfg # 配置文件
# Starting zookeeper ... STARTED # 启动成功
```

## 业务接口

Dubbo Provider 如何提供服务、提供的服务名称是什么、需要接收什么参数、需要返回什么响应

Dubbo Consumer 如何使用服务、使用的服务名称是什么、需要传入什么参数、会得到什么响应



执行如下命令：

```java
public interface DemoService {
    String sayHello(String name); // 同步调用
    
    // 异步调用
    default CompletableFuture<String> sayHelloAsync(String name) {
        return CompletableFuture.completedFuture(sayHello(name));
    }
}
```



## Demo 1: 基于 XML 配置

dubbo-demo-xml-provider

依赖了 DemoService 公共接口：

```xml
<dependency>
    <groupId>org.apache.dubbo</groupId>
    <artifactId>dubbo-demo-interface</artifactId>
    <version>${project.parent.version}</version>
</dependency>
```

代码如下：

```xml
<!-- 配置为 Spring Bean -->
<bean id="demoService" class="org.apache.dubbo.demo.provider.DemoServiceImpl"/>
<!-- 作为 Dubbo 服务暴露出去 -->
<dubbo:service interface="org.apache.dubbo.demo.DemoService" ref="demoService"/>
```

指定注册中心地址

```xml
<!-- ZooKeeper 地址 -->
<dubbo:registry address="zookeeper://127.0.0.1:2181"/>
```

在 Application 中写一个 main() 方法，指定 Spring 配置文件并启动 ClassPathXmlApplicationContext 即可



dubbo-demo-xml-consumer 模块

指定注册中心地址

```xml
<!-- ZooKeeper 地址 -->
<dubbo:registry address="zookeeper://127.0.0.1:2181"/>
```

代码如下：

```xml
<!-- 引入 DemoService 服务，并配置成 Spring Bean -->
<dubbo:reference id="demoService" check="false" interface="org.apache.dubbo.demo.DemoService"/>
```



## Demo 2: 基于注解配置

dubbo-demo-annotation-provider 模块

```java
public class Application {
    public static void main(String[] args) throws Exception {
        // 使用 AnnotationConfigApplicationContext 初始化 Spring 容器
        // 从 ProviderConfiguration 这个类的注解上拿相关配置信息
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(ProviderConfiguration.class);
        context.start();
        System.in.read();
    }
    
    @Configuration // 配置类
    // @EnableDubbo 注解指定包下的 Bean 都会被扫描，并做了 Dubbo 服务暴露出去
    @EnableDubbo(scanBasePackages="org.apache.dubbo.demo.provider")
    // PropertySource 注解指定了其它配置信息
    @PropertySource("classpath:/spring/dubbo-provider.properties")
    static class ProviderConfiguration {
        @Bean
        public RegistryConfig registryConfig() {
            RegistryConfig registryConfig = new RegistryConfig();
            registryConfig.setAddress("zookeeper://127.0.0.1:2181");
            return registryConfig;
        }
    }
}
```

dubbo-demo-annotation-consumer 模块

```java
@Component("demoServiceComponent")
public class DemoServiceComponent implements DemoService {
    @Reference // 注入 Dubbo 服务
    private DemoService demoService;
    
    @Override
    public String sayHello(String name) {
        return demoService.sayHello(name);
    }
    // 其它方法
}
```

## Demo 3: 基于 API 配置

dubbo-demo-api-provider 模块

```java
// 创建一个 ServiceConfig 的实例，泛型参数是业务接口实现类
// 即 DemoServiceImpl
ServiceConfig<DemoServiceImpl> service = new ServiceConfig<>();
// 指定业务接口
service.setInterface(DemoService.class);
// 指定业务接口的实现，由该对象来处理 Consumer 的请求
service.setRef(new DemoServiceImpl());

// 获取 DubboBootstrap 实例，这是个单例的对象
DubboBootstrap bootstrap = DubboBootstrap.getInstance();
// 生成一个 ApplicationConfig 的实例、指定 ZK 地址以及 ServiceConfig 实例
bootstrap.application(new ApplicationConfig("dubbo-demo-api-provider"))
    .registry(new RegistryConfig("zookeeper://127.0.0.1:2181"))
    .service(service)
    .start()
    .await();
```

dubbo-demo-api-consumer 模块

```java
// 创建 ReferenceConfig, 其中指定了引用的接口 DemoService
ReferenceConfig<DemoService> reference = new ReferenceConfig<>();
reference.setInterface(DemoService.class);
reference.setGeneric("true");

// 创建 DubboBootstrap, 指定 ApplicationConfig 以及 RegistryConfig
DubboBootstrap bootstrap = DubboBootstrap.getInterface();
bootstrap.application(new ApplicationConfig("dubbo-demo-api-consumer"))
    .registry(new RegistryConfig("zookeeper://127.0.0.1:2181"))
    .reference(reference)
    .start();
// 获取 DemoService 实例并调用其方法
DemoService demoService = ReferenceConfigCache.getCache()
    .get(reference);
String message = demoService.sayHello("dubbo");
System.out.println(message);
```

## 总结

本课时

介绍了 Dubbo 的核心架构以及各核心组件的功能

搭建了 Dubbo 源码环境，并详细介绍了 Dubbo 核心模块的功能，为后续分析 Dubbo 源码打下了基础

深入分析了 Dubbo 源码中自带的三个  Demo 示例，以这三个 Demo 示例为入口 Debug Dubbo 源码



Dubbo 是如何与 ZooKeeper 等注册中心进行交互的？

为什么我们在编写业务代码的时候，感受不到任何网络交互？

Dubbo Provider 发布到注册中心的数据是什么？

Provider 与 Consumer 之间是如何交互的？

两者的统一契约是什么？

这个契约还会用在 Dubbo 的哪些地方？

这个契约是如何做到可扩展的？

# P3 02 Dubbo 的配置总线：抓住 URL，就理解了半个 Dubbo

## URL

一个标准的 URL 格式包含如下的几个部分：

```
protocol://username:password@host:port/path?key=value&key=value
```

- protocol：URL 的协议
- username:password ：用户名/密码
- host:port ：主机/端口
- path：请求的路径
- parameters：参数键值对



**URL** 是整个 Dubbo 中非常基础，也是非常核心的一个组件

以 URL 作为参数的，在方法内部解析传入的 URL 得到有用的参数

**URL 被称为 Dubbo 的配置总线**

- URL 参与了扩展实现的确定
- Provider 信息封装成 URL 注册到 ZooKeeper
- Consumer 通过 URL 确定订阅了哪些 Provider



## Dubbo 中的 URL

执行如下命令：

```
dubbo://172.17.32.91:20880/org.apache.dubbo.demo.DemoService?anyhost=true&application=dubbo-demo-api-provider&dubbo=2.0.2&interface=org.apache.dubbo.demo.DemoService&methods=sayHello,sayHelloAsync&pid=32508&release=&side=provider&timestamp=1593253404714
```

- **protocol**：dubbo 协议
- **username/password**：没有用户名和密码
- **host/port**：172.17.32.91:20880
- **path**：org.apache.dubbo.demo.DemoService
- **parameters**：参数键值对，这里是问号后面的参数



URL 的构造方法：

```java
public URL(String protocol, String username, String password, String host, int port, String path, Map<String, String> parameters, Map<String, Map<String, String>> methodParameters) {
    // ...
}
```



**在 dubbo-common 包中还提供了 URL 的辅助类**：

- URLBuilder，辅助构造 URL
- URLStrParser，将字符串解析成 URL 对象



## 契约的力量

- 配置总线
- 统一配置模型

URL 在 Dubbo 中被当作是“公共的契约”

- 一个优秀的开源产品都有一套灵活清晰的**扩展契约**

  不仅是第三方可以按照这个契约进行扩展，其自身的内核也可以按照这个契约进行搭建

- 如果没有一个公共的契约，只是针对每个接口或方法进行约定

  导致不同的接口甚至同一接口中的不同方法



Dubbo 中使用 URL

- 代码更加易读、易懂，不用花大量时间去揣测传递数据的格式和含义

  进而形成一个统一的规范，使得代码易写、易读

- 入参所表达的含义比单个参数更丰富，在代码需要扩展的时候

  将新的参数以 Key/Value 的形式追加到 URL 之中，而不需要改变入参或是返回值的结构

- 使用统一的契约、术语、词汇范围，省去很多沟通成本，尽可能地提高沟通效率



## Dubbo 中的 URL 示例

URL 在 SPI 中的应用

- Dubbo SPI 中有一个依赖 URL 的重要场景——**适配器方法**，被 @Adaptive 注解标注的
- **URL 一个很重要的作用**就是与 @Adaptive 注解一起选择合适的扩展实现类



## URL 在 SPI 中的应用

如下所示：

```java
public class RegistryFactory$Adaptive implements RegistryFactory {
    public Registry getRegistry(org.apache.dubbo.common.URL arg0) {
        if (arg0 == null) throw new IllegalArgumentException("...");
        org.apache.dubbo.common.URL url = arg0;
        // 尝试获取 URL 的 Protocol，如果 Protocol 为空，则使用默认值“dubbo”
        String extName = (url.getProtocol() == null? "dubbo": url.getProtocol());
        if (extName == null) 
            throw new IllegalStateException("...");
        // 根据扩展名选择相应的扩展实现，Dubbo SPI 的核心原理在下一课时深入分析
        RegistryFactory extension = (RegistryFactory) ExtensionLoader
            .getExtensionLoader(RegistryFactory.class)
            .getExtension(extName);
        return extension.getRegistry(arg0);
    }
}
```



## URL 在服务订阅中的应用

Consumer 是如何告诉注册中心自己关注哪些 Provider 呢？

```
consumer://...?application=dubbo-demo-api-consumer&category=providers,configurators,routers&interface=org.apache.dubbo.demo.DemoService...
```

consumer：订阅协议

category：订阅的分类

interface：订阅哪个服务口

## 总结

本课时

重点介绍了 **Dubbo 对 URL 的封装以及相关的工具类**，然后说明了统一契约的好处

Dubbo 使用了 URL 作为统一配置总线的好处

介绍了 **Dubbo SPI、Provider 注册、Consumer 订阅等场景中与 URL 相关的实现**

这些都可以帮助你更好地感受 URL 在其中发挥的作用



在其它框架或是实际工作中，有没有类似 Dubbo URL 这种统一的契约？

# P4 03 Dubbo SPI 精析，接口实现两级反转（上）

OCP 原则

“微内核+插件”



## 微内核架构

被称为插件化架构（Plug-in Architecture）是一种面向功能进行拆分的可扩展性架构

内核功能是比较稳定的，只负责管理插件的生命周期，不会因为系统功能的扩展而不断进行修改



**插件模块**是独立存在的模块，包含特定的功能，能扩展内核系统的功能



内核通常采用 Factory、IoC、OSGi 等方式管理插件生命周期

Dubbo 最终决定采用 SPI 机制来加载插件，Dubbo SPI 参考 JDK 原生的 SPI 机制



## JDK SPI

- **SPI**（Service Provider Interface）主要是被框架开发人员使用的一种技术

- 例如，使用 Java 语言访问数据库时我们会使用到 java.sql.Driver 接口

  不同数据库产品底层的协议不同，提供的 java.sql.Driver 实现也不同

- 在开发 java.sql.Driver 接口时，开发人员并不清楚用户最终会使用哪个数据库

  在这种情况下就可以使用 **Java SPI 机制**在实际运行过程中

  为 java.sql.Driver 接口寻找具体的实现

- **当服务的提供者提供了一种接口的实现之后**

  需要在 Classpath 下的 META-INF/services/ 目录里创建一个以服务接口命名的文件

  此文件记录了该 jar 包提供的服务接口的具体实现类

- **当某个应用引入了该 jar 包且需要使用该服务时**

  JDK SPI 机制就可以通过查找这个 jar 包的 META-INF/services/ 中的配置文件来获得具体的实现类名

  进行实现类的加载和实例化，最终使用该实现类完成业务功能

## JDK SPI 源码分析

````java
ServiceLoader.load(Class<S>)
-> ServiceLoader.load(Class<S>, ClassLoader)
-> ServiceLoader.ServiceLoader(Class<S>, ClassLoader)
-> ServiceLoader.reload()
````

- 在 reload() 方法中，首先会**清理 provider 缓存**（LinkedHashMap 类型的集合）

  该缓存用来记录 ServiceLoader 创建的实现对象

  其中 Key 为实现类的完整类名，Value 为实现类的对象，之后创建 LazyIterator 迭代器

## JDK SPI 在 JDBC 中的应用

JDK 中只定义了一个 java.sql.Driver 接口，具体的实现是由不同数据库厂商来提供的

以 MySQL 提供的 JDBC 实现包为例进行分析



## 总结

本课时

通过一个示例入手，介绍了 **JDK 提供的 SPI 机制的基本使用**

深入分析了 **JDK SPI 的核心原理和底层实现**，对其源码进行了深入剖析

以 MySQL 提供的 JDBC 实现为例，分析了 JDK SPI 在实践中的使用方式

# P28 04 Dubbo SPI 精析，接口实现两级反转（下）

Dubbo SPI

- 扩展点
- 扩展点实现

## Dubbo SPI

- **JDK SPI** 在查找扩展实现类的过程中，需要遍历 SPI 配置文件中定义的所有实现类

  该过程中会将这些实现类全部实例化

- 如果 SPI 配置文件中定义了多个实现类，只需要使用其中一个实现类时，就会生成不必要的对象

**Dubbo SPI** 不仅解决了上述资源浪费的问题，还对 SPI 配置文件扩展和修改

**Dubbo 按照 SPI 配置文件的用途，将其分成了三类目录**

-  META-INF/services/ 目录：该目录下的 SPI 配置文件用来兼容 JDK SPI
- META-INF/dubbo/ 目录：该目录用于存放用户自定义的 SPI 配置文件
- META-INF/dubbo/internal/ 目录：该目录用于存放 Dubbo 内部使用的 SPI 配置文件



**Dubbo 将 SPI 配置文件改成了 KV 格式**：

```properties
dubbo=org.apache.dubbo.rpc.protocol.dubbo.DubboProtocol
```

使用 KV 格式的 SPI 配置文件的另一个好处是：**让我们更容易定位到问题**

```java
@SPI("dubbo")
public interface Protocol {
    // ...
}
```



## @SPI 注解

ExtensionLoader

其使用方式如下所示：

```java
Protocol protocol = ExtensionLoader.getExtensionLoader(Protocol.class).getExtension("dubbo");
```

strategies（LoadingStrategy[] 类型）

```
DubboInternalLoadingStrategy > DubboLoadingStrategy > ServicesLoadingStrategy
```



```java
public class ExtensionLoader<T> {
    private static final ConcurrentMap<Class<?>, Object> EXTENSION_INSTANCES = new ConcurrentHashMap<>();
    // 当前 ExtensionLoader 实例负责加载扩展接口
    private final Class<?> type;
    
    // 缓存了该 ExtensionLoader 加载的扩展实现类与扩展名之间的映射关系。
    private final ConcurrentMap<Class<?>, String> cachedNames = new ConcurrentHashMap<>();
    // 缓存了该 ExtensionLoader 加载的扩展名与扩展实现类之间的映射关系。cachedNames 集合的反向关系缓存。
    private final Holder<Map<String, Class<?>>> cachedNames = new Holder<>();
    
    // 缓存了该 ExtensionLoader 加载的扩展名与扩展实现对象之间的映射关系
    private final ConcurrentMap<String, Holder<Object>> cachedInstances = new ConcurrentHashMap<>();
    
    // 记录了 type 这个扩展接口上 @SPI 注解的 value 值，也就是默认扩展名
    private String cachedDefaultName;
    // ...
}
```

(07:11)

ExtensionLoader.getExtensionLoader() 方法会根据扩展接口从 EXTENSION_LOADERS 缓存中查找相应的 ExtensionLoader 实例，核心实现如下：

得到接口对应的 ExtensionLoader 对象之后会调用其 getExtension() 方法，根据传入的扩展名称从 cachedInstances 缓存中查找扩展实现的实例，最终将其实例化后返回



## @Adaptive 注解与适配器

AdaptiveExtensionFactory 实现类上 @Adaptive 注解



继承了 Transporter 接口：

```java
public class Transporter$Adaptive implements Transporter {
    public org.apache.dubbo.remoting.Client connect(URL arg0, ChannelHandler arg1) throws RemotingException {
        // 必须传递 URL 参数
        if (arg0 == null) throw new IllegalArgumentException("url == null");
        URL url = arg0;
        // 确定扩展名，优先从 URL 中的 client 参数获取，其次是 transporter 参数
        // 这两个参数名称由 @Adaptive 注解指定，最后是 @SPI 注解中的默认值
        String extName = url.getParameter("client", url.getParameter("transporter", "netty"));
        if (extName == null)
            throw new IllegalStateException("...");
        // 通过 ExtensionLoader 加载 Transporter 接口的指定扩展实现
        Transporter extension = (Transporter) ExtensionLoader
            .getExtensionLoader(Transporter.class)
            .getExtension(extName);
        return extension.connect(arg0, arg1);
    }
    
    // 省略 bind() 方法
}
```



```java
ExtensionLoader.leadClass(Map<String, Class<?>>, URL, Class<?>, String, boolean)
-> ExtensionLoader.loadResource(Map<String, Class<?>>, ClassLoader, URL, boolean, String...)
-> ExtensionLoader.loadDirectory(Map<String, Class<?>>, String, String, boolean, boolean, String...)
-> ExtensionLoader.loadExtensionClasses()
-> ExtensionLoader.getExtensionClasses()
-> ExtensionLoader.createExtension(String)
```

通过 API 方式（addExtension() 方法）设置 cachedAdaptiveClass 字段

指定适配器类型

## 自动包装特性

- Dubbo 将多个扩展实现类的公共逻辑，抽象到 Wrapper 类中

  **Wrapper 类**与普通的扩展实现类一样，也实现了扩展接口

  在获取真正的扩展实现对象时，在其外面包装一层 Wrapper 对象

- 在 createExtension() 方法中，Dubbo SPI 在拿到扩展实现类的对象

  调用 **injectExtension() 方法**扫描其全部 setter 方法，并根据 setter 方法的名称以及参数的类型

  然后调用相应的 setter 方法填充属性，这就实现了 Dubbo SPI 的自动装配特性



## @Activate 注解与自动激活特性

@Activate 注解标注在扩展实现类上

- group 属性：修饰的实现类是在 Provider 端被激活还是在 Consumer 端被激活
- value 属性：修饰的实现类只在 URL 参数中出现指定的 key 时才会被激活
- order 属性：用来确定扩展实现类的排序



（19:47）

loadClass() 方法对 @Activate 的处理

```java
private void loadClass() {
    if (clazz.isAnnotationPresent(Adaptive.class)) {
        // 处理 @Adaptive 注解
        cacheAdaptiveClass(clazz, overridden);
    } else if (isWrapperClass(clazz)) { // 处理 Wrapper 类
        cacheWrapperClass(clazz);
    } else { // 处理真正的扩展实现类
        clazz.getConstructer(); // 扩展实现类必须有无参构造函数
        ... // 兜底：SPI 配置文件中未指定扩展名称，则用类的简单名称作为扩展名（略）
        String[] names = NAME_SEPARATOR.split(name);
        if (ArrayUtils.isNotEmpty(names)) {
            // 将包含 @Activate 注解的实现类缓存到 cachedActivates 集合中
            cacheActivateClass(clazz, names[0]);
            for (String n: names) {
                // 在 cachedNames 集合中缓存实现类 -> 扩展名的映射
                cacheName(clazz, n);
                // 在 cachedClasses 集合中缓存扩展名 -> 实现类的映射
                saveInExtensionClass(extensionClasses, clazz, n, overriden);
            }
        }
    }
}
```



假设 cachedActivates 集合缓存的扩展实现如下表所示：

| 扩展名      | @Activate 中的 group | @Activate 中的 order |
| ----------- | -------------------- | -------------------- |
| demoFilter1 | Provider             | 6                    |
| demoFilter2 | Provider             | 5                    |
| demoFilter3 | Provider             | 4                    |
| demoFilter4 | Provider             | 3                    |
| demoFilter5 | Consumer             | 2                    |
| demoFilter6 | Provider             | 1                    |

得到默认激活的扩展实现集合中有 demoFilter4、6

排序后为 6、4

按序添加自定义扩展实例之后得到 3、6、4、1

## 总结

本课时

深入全面地讲解了 Dubbo SPI 的核心实现：

介绍了 **@SPI 注解的底层实现**，这是 Dubbo SPI 最核心的基础

介绍了 **@Adaptive 注解与动态生成适配器类的核心原理和实现**

分析了 **Dubbo SPI 中的自动包装和自动装配特性**，以及 @Adaptive 注解的原理



# P5 05 海量定时任务，一个时间轮搞定

在很多开源框架中，都需要**定时任务**的管理功能

例如 ZooKeeper、Netty、Quartz、Kafka 以及 Linux 操作系统

- JDK 提供的 java.util.Timer 和 DelayedQueue 等工具类，其底层实现使用堆

  存取操作的复杂度都是 **O(nlog(n))**

- 在定时任务量比较大、性能要求比较高的场景中，为了将定时任务的存取操作

  以及取消操作的时间复杂度降为 O(1)，一般会使用**时间轮**的方式

**时间轮**是一种高效的、批量管理定时任务的调度模型



对于精度要求特别高、时间跨度特别大或是海量定时任务需要调度的场景

使用**多级时间轮以及持久化存储**与时间轮结合

## 核心接口

所有的定时任务都要继承 TimerTask 接口

```java
interface Timeout {
    boolean cancel();
	boolean isCancelled();
    boolean isExpired();
    TimeTask task();
    Timer timer();
}
```

Timer 接口定义了定时器的基本行为

```java
interface Timer {
    boolean isStop();
    Timeout newTimeout(TimerTask, long, TimeUnit);
    Set<Timeout> stop();
}
```

## HashedWheelTimeout

**HashedWheelTimeout 扮演了两个角色：**

- 时间轮中双向链表的节点，即定时任务 TimerTask 在 HashedWheelTimer 中的容器

- 定时任务 TimerTask 提交到 HashedWheelTimer 之后返回的句柄（Handle）

  用于在时间轮外部查看和控制定时任务



**HashWheelTimeout 中的核心字段如下：**

prev、next（HashWheelTimeout 类型）

分别对应当前定时任务在链表中的前驱节点和后继节点



deadline (long 类型)

指定时任务执行的时间

计算公式是：currentTime（创建 HashedWheelTimeout 的时间）+ delay（任务延迟时间）- startTime（HashedWheelTimer 的启动时间），时间单位为纳秒



state（volatile int 类型）

指定时任务当前所处状态，分别是 INIT（0）、CANCELLED（1）和 EXPIRED（2）

STATE_UPDATER 字段（`AtomicIntegerFieldUpdater<HashedWheelTimeout>` 类型）



remainingRounds（long 类型）

指当前任务剩余的时钟周期数



**HashedWheelTimeout 中的核心方法有：**

isCancelled()、isExpired()、state() 方法

cancel() 方法 状态置为 CANCELLED

expire() 方法

remove() 方法 从时间轮中删除



## HashedWheelBucket

- 时间轮中的一个槽，**时间轮中的槽**实际上就是一个用于缓存和管理双向链表的容器
- 双向链表中的每一个节点就是一个 HashedWheelTimeout 对象，关联一个 TimerTask 定时任务

HashWheelBucket 持有双向链表的首尾两个节点，分别是 **head 和 tail** 两个字段

再加上每个 **HashedWheelTimeout 节点**均持有前驱和后继的引用



**HashedWheelBucket 中的核心方法**

- addTimeout() 方法：新增 HashedWheelTimeout 到双向链表的尾部
- pollTimeout() 方法：移除双向链表中的头节点，并将其返回
- remove() 方法：从双向链表中移除指定的 HashedWheelTimeout 节点
- clearTimeouts() 方法：循环调用 pollTimeout() 方法处理整个双向链表返回所有为超时或者未被取消的任务
- expireTimeouts() 方法：遍历双向链表中的全部 HashedWheelTimeout 节点



## HashedWheelTimer

- HashedWheelTimer 是 Timer 接口的实现，通过**时间轮算法**实现了一个定时器

- HashedWheelTimer 会根据当前时间轮指针选定对应的槽（HashedWheelBucket）

  从双向链表的头部开始迭代，对每个定时任务（HashedWheelTimeout）进行计算



**HashedWheelTimer 的核心属性**

- workerState（volatile int 类型）
- startTime（long 类型）
- wheel（HashedWheelBucket[] 类型）
- timeouts、cancelledTimeouts
- tick（long 类型） 指针
- mask（int 类型）
- ticksDuration（long 类型）
- pendingTimeouts（AtomicLong 类型）
- workerThread（Thread 类型）
- worker（Worker 类型）



**newTimeout() 接口定时任务完成的关键步骤**

- 确定时间轮的 startTime 字段
- 启动 workerThread 线程，开始执行 worker



**时间轮指针一次转动的全流程**

1. 时间轮指针转动，时间轮周期开始
2. 清理用户主动取消的定时任务
3. 将缓存在 timeouts 队列中的定时任务转移到时间轮中对应的槽中
4. 根据当前指针定位对应槽，处理该槽位的双向链表中的定时任务
5. 检测时间轮的状态
6. 最后再次清理 cancelledTimeouts 队列中用户主动取消的定时任务



## Dubbo 中如何使用定时任务

- 时间轮只向时间轮提交指定单次的定时任务

- 在上一次任务执行完成的时候，调用 **newTimeout() 方法**再次提交当前任务

  即使在任务执行过程中出现了 GC、I/O 阻塞等情况，导致任务延迟或卡住

  也不会有同样的任务源源不断地提交进来，导致任务堆积

Dubbo 中对时间轮的应用主要体现两个方面：

- 失败重试
- 周期性定时任务



## 总结

本课时

介绍了 **JDK 提供的 Timer 定时器以及 DelayedQueue 等工具类的问题**，时间轮的解决方案

深入讲解了 **Dubbo 对时间轮的抽象**，以及具体实现细节

说明了 **Dubbo 中时间轮的应用场景**，介绍 Dubbo 其他模块，时间轮

## 思考题

如果存在海量任务，并且这些任务的开始时间跨度非常长

那你该如何对时间轮进行扩展，处理这些定时任务呢？

# P6 06 Zookeeper 与 Curator，求你别用 ZkClient 了（上）

- 介绍 Dubbo 简化架构，Dubbo Provider 在启动时会将自身的服务信息整理成 URL 注册到注册中心

  Dubbo Consumer 在启动时会向注册中心订阅感兴趣的 Provider 信息

- 一个稳定、高效的**注册中心**对基于 Dubbo 的微服务来说是至关重要的



dubbo-registry-zookeeper



ZooKeeper 原生客户端

ZkClient、**Apache Curator** 等第三方开源客户端

## ZooKeeper 核心概念

**Apache Zookeeper** 是一个针对分布式系统的、可靠的、可扩展的协调服务

ZooKeeper 已经成为现代分布式系统的标配



Client

从业务角度来看，这是分布式应用中的一个节点

从 ZooKeeper 集群的角度来看，它是 ZooKeeper 集群的一个客户端



Leader 

ZooKeeper 集群的主节点，负责整个 ZooKeeper 集群的写操作，保证集群内事务处理的顺序性

负责整个集群中所有 Follower 节点与 Observer 节点的数据同步



Follower

ZooKeeper 集群中的从节点，接收 Client 读请求并向 Client 返回结果，并不处理写请求

转发到 Leader 节点完成写入操作，Follower 节点还会参与 Leader 节点的选举



Observer

- ZooKeeper 集群中特殊的从节点，不参与 Leader 节点的选举，其它功能与 Follower 节点相同
- **引入 Observer 角色**的目的是增加 ZooKeeper 集群读操作的吞吐量
- **引入 Observer 节点**使 ZooKeeper 集群在写能力不降低的情况下，大大提升了读操作的吞吐量



ZooKeeper 树形存储结构

**Znode 节点类型有四种**

- 持久节点
- 持节顺序节点
- 临时节点
- 临时顺序节点

如下表所示：

| 序号 | 属性            | 数据结构 | 描述                                                         |
| ---- | --------------- | -------- | ------------------------------------------------------------ |
| 1    | czxid           | long     | 节点被创建的 Zxid 值                                         |
| 2    | mzxid           | long     | 节点被修改的 Zxid 值                                         |
| 3    | pzxid           | long     | 子节点最后一次被修改的事务 ID                                |
| 4    | ctime           | long     | 节点被创建的时间                                             |
| 5    | mtime           | long     | 节点最后一次被修改的时间                                     |
| 6    | version         | long     | 节点被修改的版本号                                           |
| 7    | cversion        | long     | 节点的所拥有子节点被修改的版本号                             |
| 8    | aversion        | long     | 节点的 ACL 被修改的版本号                                    |
| 9    | emphemeralOwner | long     | 如果此节点为临时节点，那么它的值为这个节点拥有者的会话 ID；否则，它的值为 0 |
| 10   | dataLength      | int      | 节点数据域的长度                                             |
| 11   | numChildren     | int      | 节点拥有的子节点个数                                         |

{czxid、mzxid、pzxid}：事务 ID 可以识别出请求的全局顺序

{version、cversion、aversion}：基于 CAS 理论保证分布式数据原子性操作



**Watcher 特点**

- 主动推送：Watcher 被触发时，由 ZooKeeper 集群主动将更新推送给客户端
- 一次性：数据变化时，Watcher 只会被触发一次
- 可见性：换句话说，更新通知先于更新结果
- 顺序性：如果多个更新触发了多个 Watcher，Watcher 被触发的顺序与更新顺序一致



## 消息广播流程概述

**如果 Client 连接的是 Follower 节点（或 Observer 节点）**

在 Follower 节点（或 Observer 节点）收到写请求将会被转发到 Leader 节点



**Leader 处理写请求的核心流程**：

- Leader 节点接收写请求后，zxid，通过 zxid 的大小比较实现写操作的顺序一致性

- Leader 通过先进先出队列，将带有 zxid 的消息 proposal（提案）分发给所有 Follower 节点

- 当 Follower 节点接收到 proposal 之后，将 proposal 写到本地事务日志

- 当 Leader 节点接收到过半 Follower 的 ACK 响应之后

  Leader 节点就向所有 Follower 节点发送 COMMIT 命令，本地执行提交

- 当 Follower 收到消息的 COMMIT 命令之后也会提交操作，写操作完成

- Follower 节点会返回 Client 写请求相应的响应



## 崩溃恢复

- **当 Leader 节点收到半数以上 Follower 节点的 ACK 响应之后**

  向各个 Follower 节点广播 COMMIT 命令，在本地执行 COMMIT 并向连接的客户端进行响应

- 如果在各个 Follower 收到 COMMIT 命令前 Leader 就宕机了，导致剩下的服务器无法执行

**当 Leader 节点生成 proposal 之后宕机**

其它 Follower 并没有受到此 proposal（或者只有一小部分 Follower 节点收到了 proposal）

**ZooKeeper 对新 Leader 有如下两个要求：**

- 对于原 Leader 已经提交了的 proposal，新 Leader 必须能够广播并提交

- 对于原 Leader 还未广播或只部分广播成功的 proposal

  新 Leader 能够通知原 Leader 和已经同步了的 Follower 删除



当前集群中有 5 个 ZooKeeper 节点构成

sid 分别为 1、2、3、4 和 5，zxid 分别为 10、10、9、9 和 8



zxid 包含了 epoch（高 32 位）和自增计数器（低 32 位）



- 某一时刻，节点 1 的服务器宕机了，ZooKeeper 集群开始进行选主

- 由于无法检测到集群中其它节点的状态信息（处于 Looking 状态）

  因此每个节点都将自己作为被选举的对象来进行投票

- 对于节点 2 来说，接收到 (3，9)、（4，9）、（5，8）的投票，zxid 最大

- 对于节点 3 来说，接收到（2，10）、（4，9）、（5，8）的投票

  对比后由于 2 的 zxid 比自己的 zxid 要大，因此需要更改投票，改投（2，10）

- 对于节点 4 来说，接收到（2，10）、（3，9）、（5，8）的投票

  对比后由于 2 的 zxid 比自己的 zxid 要大，因此需要更改投票，改投（2，10）

- 对于节点 5 来说，也是一样，最终改投（2，10）

**节点 2 成了新 Leader 节点**

- Leader 节点此时会将 epoch 值加 1，并将新生成的 epoch 分发给各个 Follower 节点

  各个 Follower 节点收到全新的 epoch 后，返回 ACK 给 Leader 节点，并带上各自最大的 zxid

- Leader 选出最大的 zxid，并更新自身历史事务日志，示例中节点 2 无须更新

## 总结

本课时

介绍了 **ZooKeeper 集群中各个节点的角色以及职能**

介绍了 **ZooKeeper 中存储数据的逻辑结构以及 ZNode 节点的相关特性**

讲解了 **ZooKeeper 集群读写数据的核心流程**

通过示例分析了 ZooKeeper 集群的崩溃恢复流程



# P29 07 Zookeeper 与 Curator，求你别用 ZkClient 了（下）

- 从 ZooKeeper 架构的角度看，使用 Dubbo 的业务节点也只是一个 ZooKeeper 客户端

- ZooKeeper 官方提供的客户端支持了一些基本操作

  例如，创建会话、创建节点、读取节点、更新数据、删除节点和检查节点是否存在等

**ZooKeeper 本身的一些 API 的不足**

- ZooKeeper 的 Watcher 是一次性的，每次触发之后都需要重新进行注册
- 会话超时之后，没有实现自动重连的机制
- ZooKeeper 提供了非常详细的异常，异常处理显得非常繁琐
- 只提供了简单的 byte[] 数组的接口，没有提供基本类型以及对象级别的序列化
- 创建节点时，如果节点存在抛出异常，需要自行检查节点是否存在
- 删除节点就无法实现级联删除

常见的第三方开源 ZooKeeper 客户端有 ZkClient 和 Apache Curator

## Apache Curator 基础

**Apache Curator**, 提供了一套易用性和可读性非常强的 Fluent 风格的客户端 API

快速搭建稳定可靠的 ZooKeeper 客户端程序

如表所示：

| 名称                      | 描述                                                         |
| ------------------------- | ------------------------------------------------------------ |
| curator-framework         | ZooKeeper API 的高层封装，简化 ZooKeeper 客户端编程，添加了 ZooKeeper 连接管理、重试机制、重复注册 Watcher 等功能 |
| curator-recipes           | ZooKeeper 典型应用场景的实现，这些实现是基于 Curator Framework。例如，Leader 选举、分布式锁、Barrier、分布式队列等 |
| curator-client            | Zookeeper Client 的封装，用于取代原生 ZooKeeper 客户端，提供一些非常有用的客户端特性 |
| curator-x-discovery       | 在 curator-framework 上构建的服务发现实现                    |
| curator-x-discoveryserver | 可以和 curator-x-discovery 一起使用的 RESTful 服务器         |
| curator-examples          | 指各种使用 Curator 特性的案例                                |



**基本使用**

```java
public class Main {
    public static void main(String[] args) throws Exception {
        // Zookeeper 集群地址，多个节点地址可以用逗号分割
        String zkAddress = "127.0.0.1:2181";
        // 重试策略，如果连接不上 ZooKeeper 集群，会重试三次，重试间隔会递增
        RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 3);
        // 创建 Curator Client 并启动，启动成功之后，就可以与 ZooKeeper 进行交互了
        CuratorFramework client = CuratorFrameworkFactory.newClient(zkAddress, retryPolicy);
        client.start();
        
        // 下面简单说明 Curator 中常用的 API
        // create() 方法创建 ZNode，可以调用额外方法来设置节点类型、添加 Watcher
        // 下面是创建一个 user 节点，其中会存储一个 test 字符串
        String path = client.create().withMode(CreateMode.PERSISTENT).forPath("/user", "test".getBytes());
        System.out.println(path);
        
        // checkExists() 方法可以检查一个节点是否存在
        Stat stat = client.checkExists().forPath("/user");
        System.out.println(stat != null);
        // getData() 方法可以获取一个节点中的数据
        byte[] data = client.getData().forPath("/user");
        System.out.println(new String(data));
        // setData() 方法可以设置一个节点中的数据
        stat = client.setData().forPath("/user", "setData-Test".getBytes());
        data = client.getData().forPath("/user");
        System.out.println(new String(data));
        
        for (int i = 0; i < 3; i++) {
            client.create().withMode(CreateMode.EPHEMERAL_SEQUENTIAL).forPath("/user/child-");
        }
        // 获取所有子节点
        List<String> children = client.getChildren().forPath("/user");
        System.out.println(children);
        // delete() 方法可以删除指定节点，deletingChildrenIfNeeded() 方法会级联删除子节点
        client.delete().deletingChildrenIfNeeded().forPath("/user");
    }
}
```



CuratorEvent

Background

CuratorListener

（06：41）

```java
public class Main2 {
    // ...
    client.getCuratorListenable().addListener(new CuratorListener() {
        public void eventReceived(CuratorFramework client, CuratorEvent event) throws Exception {
            // ...
        }
    });
    // ...
    client.setData().inBackground().forPath("/user", "setData-Test".getBytes());
    client.getData().inBackground().forPath("/user");
    // ...
}
```



连续状态监听

- Curator 还提供了监听连接状态的监听器——ConnectionStateListener

- 主要是处理 Curator 客户端和 ZooKeeper 服务器间连接的异常情况

  例如，短暂或长时间断开连接

**短暂断开连接**

ZooKeeper 客户端与服务端的连接断开，服务端维护的客户端 Session 尚未过期，重新建立连接

当客户端重新连接后，Session 没有过期，ZooKeeper 保证连接恢复后正常服务

**长时间断开连接**

Session 已过期，Watcher 和临时节点都会丢失

当 Curator 重新创建与 ZooKeeper 的连接时，Session 过期的相关异常，会创建一个新的 Session



Session

ZooKeeper 服务器和客户端的会话

- 设置客户端会话的超时时间（sessionTimeout）

- ZooKeeper 通过 sessionID 唯一标识 Session

  在 ZooKeeper 集群中，sessionID 保证全局唯一

（10:10）

```java
public class Main3 {
    // ...
     client.getConnectionStateListenable().addListener(new ConnectionStateListener() {
         public void stateChanged(CuratorFramework client, ConnectionState newState) {
             // ...
         }
     })
}
```



**Watcher**

分布式锁

集群管理

（11：46）

```java
public class Main4 {
    // ...
    List<String> children = client.getChildren().usingWatcher(new CuratorWatcher() {
        public void process(WatchedEvent event) throws Exception {
            System.out.println(event.getType() + "," + event.getPath());
        }
    }).forPath("/user");
    // ...
}
```



Apache Curator 引入了 **Cache** 来实现对 ZooKeeper 服务端事件的监听

**Cache**：

NodeCache

PathChildrenCache

TreeCache

（14：25）

```java
public class Main5 {
    // ...
    
    // 创建 NodeCache，监听的是"/user"这个节点
    NodeCache nodeCache = new NodeCache(client, "/user");
    // 该方法有个 boolean 类型的参数，默认是 false。如果设置为 true，那么 NodeCache 在第一次启动的时候就会立刻从 ZooKeeper 上读取对应节点的数据内容，并保存在 Cache 中。
    nodeCache.start(true);
    if (nodeCache.getCurrentData() != null) {
        System.out.println("...");
    } else {
        System.out.println("NodeCache 节点数据为空！");
    }
    // 添加监听器
    nodeCache.getListenable().addListener(() -> {
        // ...
    });
    
    // 创建 PathChildrenCache 实例，监听的是"user"这个节点
    PathChildrenCache childrenCache = new PathChildrenCache(client, "/user", true);
    // StartMode 指定初始化的模式
    // NORMAL: 普通异步初始化
    // BUILD_INITIAL_CACHE: 同步初始化
    // POST_INITIALIZED_EVENT: 异步初始化，初始化之后会触发事件
    childrenCache.start(PathChildrenCache.StartMode.BUILD_INITIAL_CACHE);
    // childrenCache.start(PathChildrenCache.StartMode.POST_INITIALIZED_EVENT);
    // childrenCache.start(PathChildrenCache.StartMode.NORMAL);
    List<ChildData> children = childrenCache.getCurrentData();
    // ...
    childrenCache.getListenable().addListener((client1, event) -> {
        //... 监听子节点初始化成功、添加子节点、删除子节点、修改子节点
    });
    
    TreeCache cache = TreeCache.newBuilder(client, "/user").setCacheData(false).build();
    cache.getListenable().addListener((c, event) -> {
        // ... 打印 event 的 data、type
    });
    //...
}
```

## curator-x-discover 扩展库

**curator-x-discovery 扩展包**是一个服务发现的解决方案



**curator-x-discovery 扩展包的核心概念如下：**

ServiceInstance



**ServiceProvider**

这是 curator-x-discovery 扩展包的核心组件之一

可以调用 getInstance() 方法，getAllInstances() 方法



**ServiceDiscovery**

这是 curator-x-discovery 扩展包的入口类，开始必须调用 start() 方法

当使用完成应该调用 close() 方法进行销毁



**ServiceCache**

查询 ServiceCache 的方式是 getInstance() 方法

ServiceCache 上可以添加 Listener 来监听缓存变化



(18:47)

```java
public class ZookeeperCoordinator {
    private ServiceDiscovery<ServerInfo> serviceDiscovery;
    private ServiceCache<ServerInfo> serviceCache;
    private CuratorFramework client;
    private String root;
    // ...
}
```

## curator-recipes 简介

Queues

Counters

Locks

Barries

Elections

## 总结

本课时

将 Apache Curator 与其它 ZooKeeper 客户端进行了对比，Apache Curator 的易用性

通过示例介绍了 **Apache Curator 的基本使用方式**以及实际使用过程中的一些注意点

介绍了 **curator-x-discovery 扩展库的基本概念和使用**

介绍了 **curator-recipes** 提供的强大功能

# P7 08 代理模式与常见实现

- Spring AOP、MyBatis、Hibernate 等常用的开源框架，使用到了**动态代理机制**

- Dubbo 中也使用到了动态代理，简易版 RPC 框架的时候

  Dubbo 使用动态代理机制来屏蔽底层的网络传输以及服务发现的相关实现

## 代理模式

在程序中不会直接调用 RealSubject 对象的方法

**使用 Proxy 对象实现相关功能**



**代理模式**

Proxy.operation() 方法会在 RealSubject.operation() 方法

调用前后进行一些预处理以及一些后置处理



使用代理模式可以**控制程序对 RealSubject 对象的访问**

代理模式还可以用于**实现延迟加载**的功能

## JDK 动态代理

**JDK 动态代理的核心是** InvocationHandler 接口



JDK 动态代理创建代理类的底层实现原理



反编译后得到的代码如下：

```java
public final class $Proxy37 extends Proxy implements Subject { // 实现了 Subject 接口
    // 这里省略了从 Object 类继承下来的相关方法和属性
    private static Method m3;
    
    static {
        // 省略了 try/catch 代码块
        // 记录了 operation() 方法对应的 Method 对象
        m3 = Class.forName("com.xxx.Subject")
            .getMethod("operation", new Class[0]);
    }
    
    // 构造方法的参数就是我们在示例中使用的 DemoInvokerHandler 对象
    public $Proxy11(InvocationHandler var1) throws {
        super(var1);
    }
    
    public final void operation() throws {
        // 省略了 try/catch 代码块
        // 调用 DemoInvokerHandler 对象的 invoke() 方法
        // 最终调用 RealSubject 对象的对应方法
        super.h.invoke(this, m3, (Object[]) null);
    }
}
```



- **JDK 动态代理的实现原理**是动态创建代理类并通过指定类加载器进行加载

  在创建代理对象时将 InvocationHandler 对象作为构造参数传入

- 当调用代理对象时，调用 InvocationHandler.invoke() 方法，执行代理逻辑并最终调用真正业务对象的相应方法

## CGLib

CGLib 是一个基于 ASM 的字节码生成库



**CGLib 与 JDK 动态代理之间可以相互补充**

在目标类实现接口时，使用 JDK 动态代理创建代理对象

在目标类没有实现接口时，使用 CGLib 实现动态代理的功能



CGLib 的两个重要成员

Enhancer

MethodInterceptor



```java
public class CglibProxy implements MethodInterceptor {
    private Enhancer enhancer = new Enhancer();
    
    public Object getProxy(Class clazz) {
        enhancer.setSuperclass(clazz); // 指定生成的代理类的父类
        enhancer.setCallback(this); // 设置 Callback 对象
        return enhancer.create(); // 通过 ASM 字节码技术动态创建子类实例
    }
    
    public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxy) throws Throwable {
        System.out.println("前置处理");
        Object result = proxy.invokeSuper(obj, args);
        System.out.println("前置处理");
        return result;
    }
}
```

```java
public class CGLibTest {
    public String method(String str) {
        System.out.println("str");
        return "CGLibTest.method():" + str;
    }
    
    public static void main(String[] args) {
        CglibProxy proxy = new CglibProxy();
        CGLibTest proxyImp = (CGLibTest) proxy.getProxy(CGLibTest.class);
        String result = proxyImp.method("test");
        System.out.println(result);
    }
}
```



## Javassist

**Javassist** 是一个开源的生成 Java 字节码的类库



（13:04）

```java
public class JavassistMain {
    // ...
}
```

（14：01）

```java
public class JavassistDemo {
    // ...
}
```

（14：19）

```java
public class JavassistMain2 {
    // ... ProxyFactory
}
```



**Javassist 的性能**，是 Dubbo 默认的代理生成方式

## 总结

本课时

介绍了**代理模式的核心概念和用途**

介绍了 **JDK 动态代理的使用**，分析了 JDK 动态代理的实现原理，JDK 动态代理的局限性

介绍了 **CGLib 和 Javassist** 的基本使用，简述了两者生成原理的原理



# P8 09 Netty 入门，用它做网络编程都说好（上）

- **Java NIO 的 API 非常复杂**
- 直接**使用 Java NIO 进行开发**，难度和开发量非常大
- **JDK 本身的 Bug**（epoll bug）



**Netty 的优点**：

- 入门简单，使用方便，文档齐全，无其他依赖
- 高性能，高吞吐，低延迟，资源消耗少
- 灵活的线程模型，支持阻塞和非阻塞的 I/O 模型
- 代码质量高，目前主流版本基本没有 Bug

## Netty I/O 模型设计

**Netty 就采用了 NIO 的 I/O 模型**

这也是其高性能的重要原因之一

## 传统阻塞 I/O 模型

（2:22）

## I/O 多路复用模型

（3:04）



在 NIO 中则抛弃了传统的 I/O 流概念

引入了 **Channel** 和 **Buffer** 的概念

## Netty 线程模型设计

**Netty 采用了 Reactor 线程模型的设计**

核心原理是 Selector 负责监听 I/O 事件

在监听到 I/O 事件之后，分发（Dispatch）给相关线程进行处理

## 单 Reactor 单线程

（6：16）



**优点**：线程模型简单，没有引入多线程

**缺点**：性能瓶颈问题

## 单 Reactor 多线程

**唯一的区别**就是执行 Handler 逻辑的线程隶属于一个线程池



利用**多核 CPU** 的处理能力

提高整个系统的吞吐量



线程并发

数据共享

线程调度

## 主从 Reactor 多线程

- **Reactor 主线程**负责通过 Acceptor 对象处理 MainReactor 监听到的连接建立事件

- 当 Acceptor 完成网络连接的建立之后

  MainReactor 将建立好的连接分配给 SubReactor 进行后续监听



**主 Reactor** 只负责监听连接建立事件

**SubReactor** 只负责监听读写事件

## Netty 线程模型

```mermaid
graph TB
c1[Client]
c2[Client]
c3[Client]
subgraph Boss Group
neg[NioEventGroup]
end
c1 --> neg
c2 --> neg
c3 --> neg
neg --> circle1(select\processSelectedKeys\runAllTasks)
subgraph Work Group
neg1[NioEventGroup]
neg2[NioEventGroup]
end
circle1 --> neg1
circle1 --> neg2
neg2 --> circle2(select\processSelectedKeys\runAllTasks)
subgraph Pipeline
ch1[ChannelHandler]
ch2[ChannelHandler]
ch3[ChannelHandler]
end
circle2 --> ch2
```

NioEventLoop 表示一个不断循环的、执行处理任务的线程

## 总结

本课时

**Java NIO 的一些缺陷和不足**，这也是 Netty 等网络库出现的重要原因之一

**Netty 在 I/O 模型上的设计**，阐述了 I/O 多路复用的优势

从基础的单 Reactor 单线程模型开始，介绍了**网络 I/O 线程模型**，Netty 目前使用的线程模型

# P30 10 Netty 入门，用它做网络编程都说好（下）

从 I/O 模型以及线程模型两个角度，宏观介绍了 **Netty** 的设计

Netty 框架核心组件的功能，并概述它们的实现原理

- **Netty** 对 I/O 模型设计中的概念的抽象，如 Selector 等组件
- **线程模型**和相关组件介绍，主要是 NioEventLoop、NioEventLoopGroup 等
- Netty 处理数据的相关组件，例如 ByteBuf、内存管理的相关知识

## Channel

**常见的 NIO Channel 类型：**

- NioSocketChannel：对应异步的 TCP Socket 连接
- NioServerSocketChannel：对应异步的服务器端 TCP Socket 连接
- NioDatagramChannel：对应异步的 UDP 连接



Channel 主要提供了**异步**的网络 I/O 操作

I/O 操作返回的是一个 **ChannelFuture** 对象



Netty **支持**同步 I/O 操作

Netty **中**异步 I/O 操作

## Selector

Selector 是对多路复用器的抽象

**Java NIO** 的核心基础组件之一



可读事件（OP_READ）

可写事件（OP_WRITE）

网络连接事件（OP_ACCEPT）

## ChannelPipeline & ChannelHandler

**ChannelPipeline** 将一个 ChannelHandler 处理后的

数据作为下一个 ChannelHandler 的输入



入站事件

出站事件

责任链模式



```java
ChannelPipeline p = socketChannel.pipeline();
p.addLast("1", new InboundHandlerA());
p.addLast("2", new InboundHandlerB());
p.addLast("3", new OutboundHandlerA());
p.addLast("4", new OutboundHandlerB());
p.addLast("5", new InboundOutboundHandlerX());
```

对于入站（Inbound）事件，处理序列为：1 -> 2 -> 5

对于出站（Outbound）事件，处理序列为：5 -> 4 -> 3



入站（Inbound）事件一般由 **I/O 线程**触发



消息

消息头：消息类型、控制位、数据长度

消息体：包含了真正传输的数据



出站（Outbound）事件与入站（Inbound）事件相反

一般是由**用户**触发的



ChannelHandler 接口



实现类：ChannelInboundHandlerAdapter、ChannelOutboundHandlerAdapter

主要是帮助完成**事件流转**功能

即自动调用传递事件的相应方法



ChannelPipeline 中的事件传播主要依赖于 **ChannelHandlerContext** 实现

## NioEventLoop

- 一个 **EventLoop 对象**由一个永远都不会改变的线程驱动

- 一个 **NioEventLoop** 包含了一个 Selector 对象

  支持多个 Channel 注册，可以同时服务多个 Channel

  每个 Channel 只能与一个 NioEventLoop 绑定



ChannelHandler 的逻辑都是由相应 **NioEventLoop** 关联的那个线程执行



**普通任务队列**

1. 在把任务提交给 execute() 方法之后进行判断：当前线程是否在 EventLoop 中
2. 在：如果是 EventLoop 线程，则直接执行
3. 不在：如果是非 EventLoop 线程，则入队，由 EventLoop 中的线程执行

**定时任务队列**

当用户在非 I/O 线程产生定时操作，Netty 将用户的定时操作封装成定时任务

并将其放入该定时任务队列中等待相应 NioEventLoop 串行执行



**NioEventLoop 主要做三件事：**

监听 I/O 事件、执行普通任务以及执行定时任务

## NioEventLoopGroup

**NioEventLoopGroup** 表示的是一组 NioEventLoop

具体计算公式是：CPU 的核心数 * 2



1. 所有 EventLoop 都是由 EventLoopGroup 分配和管理的

2. 每个 EventLoop 将处理分配给自己的 Channel，

   即处理这些 Channel 上的网络 I/O 事件。

   每个 EventLoop 会关联一个 Thread

3. 在每个 Channel 的生命周期中，

   只会分配给一个 EventLoop 进行处理

## ByteBuf

ByteBuf 扮演一个**数据容器**的角色



两者符合下面的不等式

`0 <= readerIndex <= writerIndex <= capacity`



可丢弃 | readerIndex | 可读 | writerIndex | 可写



Direct Buffer（直接缓冲区）

使用堆外内存存储数据，使用的最大内存容量以及如何及时释放

使用 Socket 传递数据时性能很好，Netty 主要使用内存池来解决释放的问题



Composite Buffer（复合缓冲区）

创建多个不同的 ByteBuf，提供 CompositeByteBuf

一个列表，动态添加和删除其中的 ByteBuf

## 内存管理

ByteBuf

- Unpooled

  指非池化的内存管理方式

  每次分配时直接调用系统 API 向操作系统申请 ByteBuf

- Pooled

  指池化的内存管理方式

  预先申请一块大内存形成内存池



- Netty 向系统申请一整块连续内存，称为 **Chunk**（默认大小为 16MB）

  连续的内存通过 PoolChunk 对象进行封装

- Netty 将 Chunk 空间进一步拆分为 Page

  每个 Chunk 默认包含 2048 个 Page，每个 Page 的大小为 8 KB

## 大对象 & 小对象的处理

- 当申请分配的对象是**超过 Chunk 容量**的大型对象，Netty 就不再使用池化管理方式

  在每次请求分配内存时单独创建特殊的非池化 PoolChunk 对象进行管理

- 当对象内存释放时整个 PoolChunk 内存释放

- 如果需要一定数量空间远小于 PageSize 的 ByteBuf 对象

  Netty 通过 **Page 细分**的方式，解决这个问题

- Netty 将请求的空间大小向上取最近的 16 的倍数（或 2 的幂）

  规整后小于 PageSize 的小 Buffer 可分为两类



**微型对象：**规整后的大小为 16 的整倍数，如 16、32、48、……、496，一共 31 种大小

**小型对象：**规整后的大小为 2 的幂，如 512、1024、2048、4096，一共 4 种大小



Netty  通过 PoolArena 管理 **PoolChunkList** 以及 **PoolSubpage**

## 并发处理

- PoolChunk 的**完全平衡树**标记以及 PoolSubpage 的 bitmap 标记

  都是多线程不安全，都是需要加锁同步的

- 为了减少线程间的竞争，Netty 会提前创建多个 **PoolArena**

  当线程首次请求池化内存分配，找被最少线程持有的 PoolArena

- Netty 提供了**延迟释放**的功能，提升并发性能

- 当有新的分配请求时，PoolArena 会优先访问线程本地的缓存队列

  查询是否有缓存可用，如果有，则直接分配，提高分配效率

## 总结

本课时

Channel、ChannelFuture、Selector 等组件，它们是**构成 I/O 多路复用的核心**

**EventLoop、EventLoopGroup** 等组件，它们与 Netty 使用的主从 Reactor 线程模型息息相关

**Netty 的内存管理**，主要从内存分配管理、内存碎片优化以及并发分配内存等角度进行了介绍

# P9 11 简易版 RPC 框架实现（上）

**RPC** 是“远程过程调用（Remote Procedure Call）”的缩写形式

像本地方法调用一样调用远程的服务



简易 RPC 框架的架构图

```mermaid
graph TB
b1[业务] --> n1
n1 --> b1
subgraph 客户端
	服务发现
	subgraph 集群代理模块
		负载均衡
		容错
		透明
	end
	subgraph RPC协议
		序列化
		编码
		n1[网络传输]
	end
end
服务发现 --> 注册中心
subgraph 服务端
	服务暴露
	subgraph 代理模块
		线程池
		...
	end
	subgraph RPC协议.
		s2[序列化]
		encode2[编码]
        n2[网络传输]
	end
end
n1 --> n2
n2 --> n1
注册中心 --> 服务暴露
n2 --> b2[业务]
b2 --> n2
```

**简易版 RPC 框架一次远程调用的核心流程：**

1. Client 首先会调用本地的代理，也就是图中的 Proxy
2. Client 端 Proxy 会按照协议（Protocol），将调用中传入的数据序列化成字节流
3. 之后 Client 会通过网络，将字节数据发送到 Server 端
4. Server 端接收到字节数据后，会按照协议进行反序列化，得到相应的请求信息
5. Server 端 Proxy 会根据序列化后的请求信息，调用相应的业务逻辑
6. Server 端业务逻辑的返回值，也会按照上述逻辑返回给 Client 端



## 自定义协议

http://1.x

只支持半双工传输模式、不支持服务端主动推送数据

有效负载少，效率低

天然穿透防火墙，大量的框架和开源软件支持 HTTP 接口

配合 REST 规范使用也是很便捷



**简易版的 Demo RPC 协议**

| short | byte     | byte(0)                  | byte(1~2)  | byte(3~4) | byte(5~6)                      | long      | int        | n byte       |
| ----- | -------- | ------------------------ | ---------- | --------- | ------------------------------ | --------- | ---------- | ------------ |
| magic | version  | extraInfo                | extraInfo  | extraInfo | extraInfo                      | messageId | size       | message body |
| 魔数  | 协议版本 | 消息类型（请求还是响应） | 序列化方式 | 压缩方式  | 请求类型（正常请求、心跳请求） | 消息 ID   | 消息体长度 | 消息体       |



## 编解码实现

（6:20）

**Netty 提供的 Decoder 和 Encoder 实现**

ByteToMessageDecoder

MessageToMessageDecoder

MessageToMessageEncoder

MessageToByteEncoder



（7:09）

**Netty 中 HTTP 协议的 Decoder 和 Encoder 实现**

HttpServerResponseEncoder

HttpServerRequestDecoder



简单继承

ByteToMessageDecoder

MessageToMessageEncoder

## 总结

本课时

介绍了简易 RPC 框架的**基本架构**以及其处理一次远程调用的基本流程

讲解了简易 RPC 框架使用的**自定义协议格式、序列化/反序列化方式以及压缩方式**

介绍了 Netty 中的**编解码体系**，以及 HTTP 协议相关的编解码器实现

分析了简易 RPC 协议对应的**编解码器**，即 DemoRpcEncoder 和 DemoRpcDecoder

# P31 12 简易版 RPC 框架实现（下）

**简易 RPC 框架项目的结构和工作原理**

简易 RPC 框架底层的协议结构、序列化/反序列化实现、压缩实现以及编解码器的具体实现

## transport 相关实现

Server 端

DemoRpcDecoder

ChannelHandler

Client 端



DemoRpcClient Client

DemoRpcServer Server



ChannelHandler 的执行顺序如下：

网络 --DemoRpcEncoder--DemoRpcClientHandler--> 客户端业务逻辑 --DemoRpcDecoder--> 网络

网络 --DemoRpcClientHandler--DemoRpcEncoder--> 服务端业务逻辑 --DemoRpcDecoder--> 网络

## registry 相关实现

**registry 包**

主要是依赖 Apache Curator 实现了一个简易版本的 ZooKeeper 客户端

基于 ZooKeeper 实现了注册中心最基本的两个功能：Provider 注册以及 Consumer 订阅



基于 Curator 中的 ServiceDiscovery 组件与 ZooKeeper 进行交互

对 Registry 接口的实现通过直接调用 **ServiceDiscovery** 的相关方法实现



ServiceCache 底层在本地维护了一个 **ConcurrentHashMap** 缓存

通过 PathChildrenCache 监听 ZooKeeper 中各个子节点的变化

## proxy 相关实现

**Proxy** 主要是为 Client 端创建一个代理

帮助客户端程序屏蔽底层的网络操作以及与注册中心之间的交互



DemoRpcProxy

newInstance() 方法

invoke() 方法



**简易版 DemoRpcProxy 的实现优化：**

- 缓存 DemoRpcClient 客户端对象以及相应的 Connection 对象，不必每次进行创建

- 添加失败重试机制，在请求出现超时的时候，进行重试

- 添加更加复杂和灵活的负载均衡机制，例如，根据 Hash 值散列进行负载均衡

  根据节点 load 情况进行负载均衡等

## 总结

本课时

介绍了**简易 RPC 框架中的 transport 包**，实现了服务端和客户端的通信能力

讲解了 **registry 包如何实现与 ZooKeeper 的交互**，完善了简易 RPC 框架的服务注册与服务发现的能力

**分析了 proxy 包的实现**，其中通过 JDK 动态代理的方式，帮接入方屏蔽了底层网络通信的复杂性

编写了一个简单的 DemoService 业务接口，以及相应的 Provider 和 Consumer 接入简易 RPC 框架

## 思考题

在 transport 中创建 EventLoopGroup 的时候

**为什么**针对 Linux 系统使用的 EventLoopGroup 会有所不同呢？

# P10 13 本地缓存：降低 ZooKeeper 压力的一个常用手段

**注册中心（Registry）**

服务提供者（Provider）和消费者（Consumer）



**真正的“注册中心”服务**是其他独立部署的进程

或进程组成的集群，比如 ZooKeeper 集群



Dubbo Framework

- Service
- Config
- Proxy
- Registry
- Cluster
- Monitor
- Protocol
- Exchange
- Transport
- Serialize

## 核心接口

Node

- **getUrl() 方法**返回表示当前节点的 URL
- **isAvailable()** 检测当前节点是否可用
- **destroy()** 方法负责销毁当前节点并释放底层资源

**RegistryService 接口**

- register() 方法和 unregister() 方法分别表示**注册和取消注册**一个 URL
- subscribe() 方法和 unsubscribe() 方法分别表示**订阅和取消**订阅一个 URL
- lookup() 方法能够**查询**符合条件的注册数据

**Registry 接口**

继承 Node、RegistryService 接口

**RegistryFactory 接口**

```java
@SPI("dubbo")
public interface RegistryFactory {
    @Adaptive({"protocol"})
    Registry getRegistry(URL url);
}
```

## AbstractRegistry

**Registry 接口**的所有实现类都继承了 **AbstractRegistry**



registryUrl

Properties、file

syncSaveFile

registryCacheExecutor

notified

lastCacheChanged

registered

subscribed

## 本地缓存

**作为一个 RPC 框架**，Dubbo 在微服务架构中解决了各个服务间协作的难题

**作为 Provider 和 Consumer 的底层依赖**，它会与服务一起打包部署



（9:00）

**notify() 方法的核心实现**：

```java
protected void notify(URL url, NotifyListener listener, List<URL> urls) {
    
}
```



(10:22)

**本地缓存文件的具体路径是：**

```
/.dubbo/dubbo-registry-[当前应用名]-[当前Registry所在的IP地址].cache
```



**第一个细节：UrlUtils.isMatch() 方法**

- 匹配 Consumer 和 Provider 的接口
- 匹配 Consumer 和 Provider 的 category
- 检测 Consumer URL 和 Provider URL 中的 enable
- 检测 Consumer 和 Provider 端的 group、version 以及 classifier

**第二个细节是：URL.getServiceKey() 方法**

```
[group]/{interface(或 path)}[:version]
```



**AbstractRegistry 的核心**是本地文件缓存的功能



**AbstractRegistry** 通过本地缓存提供了一种容错机制

保证了服务的可靠性

## 注册/订阅

- AbstractRegistry 实现了 Registry 接口

  它实现的 **registry() 方法**会将当前节点要注册的 URL 缓存到 registered 集合

- **unregistry() 方法**会从 registered 集合删除指定的 URL

- **subscribe() 方法**会将当前节点作为 Consumer 的 URL

  以及相关的 NotifyListener 记录到  subscribed **集合**

- **unsubscribe() 方法**会将当前节点的 URL

  以及关联的 NotifyListener 从 subscribed **集合删除**

## 恢复/销毁

recover() 方法

将 registered 集合中的全部 URL 重新走一遍 register() 方法

将 subscribed 集合中的 URL 重新走一遍 subscribe() 方法



destroy() 方法

调用 unregister() 方法和 unsubscribe() 方法

将当前节点注册的 URL 以及订阅的监听全部清理掉

## 总结

本课时

**介绍了注册中心在整个 Dubbo 架构中的位置**

Registry、RegistryService、RegistryFactory 等核心功能

**详细讲解了 AbstractRegistry 这个抽象类提供的公共能力**

主要是从本地缓存、注册/订阅、恢复/销毁这三方面进行了分析

# P11 14 重试机制是网络操作的基本保证

ZooKeeper、etcd 等服务发现组件一般会独立部署成一个集群

业务服务通过网络连接这些服务发现节点，完成**注册和订阅**操作



**为了保证服务的可靠性，重试机制就变得必不可少了**



**重试机制**

在请求失败时，客户端重新发起一个一模一样的请求

尝试调用相同或不同的服务端，完成相应的业务操作



register()/unregister()

subscribe()/unsubscribe()

notify()

通过本地缓存实现的容错功能

**重试机制的关注点**



dubbo-registry 将重试机制的相关实现

放到了 AbstractRegistry 的子类 ——**FailbackRegistry**

## 核心字段介绍

- **retryTimer（HashedWheelTimer 类型）**：用于定时执行失败重试操作的时间轮
- **retryPeriod（int 类型）**：重试操作的时间间隔
- **failedRegistered（ConcurrentMap<URL, FailedRegisteredTask> 类型）**：注册失败的 URL 集合，其中 Key 是注册失败的 URL，Value 是对应的重试任务
- **failedUnregistered（ConcurrentMap<URL, FailedUnregisteredTask> 类型）**：取消注册失败的 URL 集合，其中 Key 是取消注册失败的 URL，Value 是对应的重试任务
- **failedSubscribed（ConcurrentMap<Holder, FailedSubscribedTask> 类型）**：订阅失败 URL 集合，其中 Key 是订阅失败的 URL + Listener 集合，Value 是相应的重试任务
- **failedUnsubscribed（`ConcurrentMap<URL, Set<NotifyListener>>` 类型）**：取消订阅失败的 URL 集合，其中 Key  是取消订阅失败的 URL + Listener 集合，Value 是相应的重试任务
- **failedNotify（ConcurrentMap<Holder, FailedNotifiedTask> 类型）**：通知失败的 URL 集合，其中 Key 是通知失败的 URL + Listener 集合，Value 是相应的重试任务



register() 方法的具体实现流程

## 重试任务

（6：01）

**继承了 AbstractRetryTask 抽象类，如图所示：**

## 其他核心方法

**FailbackRegistry.subscribe() 方法处理异常**

先获取缓存的订阅数据并调用 notify() 方法

如果没有缓存相应的订阅数据，才会检查 check 参数决定是否抛出异常



**recover() 方法**

通过 FailedRegisteredTask 任务处理 registered 集合中的全部 URL

通过 FailedSubscribedTask 任务处理 subscribed 集合中的 URL 以及关联的 NotifyListener



FailbackRegistry

destroy()

retryTimer 字段

stop() 方法

## 总结

本课时

重点介绍了 AbstractRegistry 的实现类——**FailbackRegistry 的核心实现**

主要是在 AbstractRegistry 的基础上，提供了重试机制

**在 register() / unregister()、subscribe() / unsubcribe() 等核心方法失败时**

添加重试定时任务，实现重试机制，同时也添加了相应的定时任务清理逻辑

# P12 15 ZooKeeper 注册中心实现，官方推荐注册中心实践

Dubbo 支持 **ZooKeeper** 作为注册中心服务

Dubbo 推荐使用的注册中心



Dubbo 本身是一个分布式的 RPC 开源框架

依赖于一个**一致性的服务发现组件**实现注册和订阅



**ZooKeeper 为分布式应用所设计的高可用且一致性的开源协调服务**



**Dubbo 在 ZooKeeper 中的节点层级结构：**

- Root
- Service（Monitor subscribe）
- Type（Consumer subscribe 'providers'）
- URL（Provider register、Consumer register）

## ZooKeeperRegistryFactory

**在 dubbo-registry-zookeeper 模块中的 SPI 配置文件**



AbstractRegistryFactory

setZookeeperTransporter()

## ZookeeperTransporter

dubbo-remoting-zookeeper 模块是 dubbo-remoting 模块的子模块

相对独立

在 Apache Curator 的基础上封装了一套 Zookeeper 客户端



dubbo-remoting-zookeeper 模块

ZookeeperTransporter 接口

ZookeeperClient 接口



提供了如下的 URL 配置

```
zookeeper://127.0.0.1:2181/org.apache.dubbo.registry.RegistryService?backup=127.0.0.1:8989,127.0.0.1:9999
```

## ZookeeperClient

- **create() 方法**：创建 ZNode 方法，还提供了创建临时 ZNode 节点的重载方法
- **getChildren() 方法**：获取指定节点的子节点集合
- **getContent() 方法**：获取某个节点存储的内容
- **delete() 方法**：删除节点
- **addXxxListener() / removeXxxListener() 方法**：添加/删除监听器
- **close() 方法**：关闭当前 ZooKeeperClient 实例



**AbstractZookeeperClient 作为 ZookeeperClient 接口的抽象实现**

- 缓存当前 ZookeeperClient 实例创建的持久 ZNode 节点
- 管理当前 ZookeeperClient 实例添加的各类监听器
- 管理当前 ZookeeperClient 的运行状态



StateListener

DataListener

ChildListener



为什么 AbstractZookeeperClient 要使用泛型定义？

不同的 ZookeeperClient 的实现可能依赖不同的 Zookeeper 客户端组件

不同 Zookeeper 客户端组件的监听器实现也有所不同



**dubbo-remoting-zookeeper 模块的核心实现**

重点关心基于 Zookeeper 的注册中心实现

## ZookeeperRegistry

RECONNECTED 状态

NEW_SESSION_CREATED 状态



**注意：**doRegister() 方法注册 Provider URL 的时候

根据 dynamic 参数决定创建临时 ZNode 节点还是持久 ZNode 节点



toRootDir() 方法：获取 ZookeeperRegistry 的 root

toServicePath() 方法：获取 Provider URL 的 interface 参数，默认值使用 Provider URL path

toCategoryPath() 方法：获取 Provider URL 的 category 参数，默认值是 provider

toUrlPath() 方法：添加整个 Provider URL

## 总结

本课时

回顾了 **Zookeeper 的基础内容**，以及作为 Dubbo 注册中心时 Zookeeper 存储的具体内容

介绍了针对 Zookeeper 的 RegistryFactory 实现——**ZookeeperRegistryFactory**

讲解了 Dubbo 接入 Zookeeper 时使用的组件实现

重点分析了 **ZookeeperTransporter 和 ZookeeperClient 实现**

说明了 ZookeeperRegistry 是如何通过 ZookeeperClient 接入 Zookeeper