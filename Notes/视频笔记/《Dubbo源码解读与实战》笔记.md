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