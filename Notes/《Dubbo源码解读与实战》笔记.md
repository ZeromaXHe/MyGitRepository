Dubbo源码解读与实战

up 主：gzqhero 原作应该是拉勾教育

2023-03-30 20:26:01

https://www.bilibili.com/video/BV1Bc411V7AR

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