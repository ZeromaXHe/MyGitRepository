尚硅谷2024最新SpringCloud教程，springcloud从入门到大牛

https://www.bilibili.com/video/BV1gW421P7RD

2024-02-27 15:00:00

# P1 SpringCloud-前言闲聊开篇简介

1. 从 Boot 和 Cloud 的版本选型开始说起
2. 关于 Cloud 各种组件的 停更/升级/替换
3. 微服务架构编码 Base 工程模块构建
4. Consul 服务注册与发现
5. LoadBalancer 负载均衡服务调用
6. OpenFeign 服务接口调用
7. CircuitBreaker 断路器
8. Sleuth（Micrometer）+ZipKin 分布式链路追踪
9. Gateway 新一代网关
10. SpringCloud Alibaba 入门简介
11. SpringCloud Alibaba Nacos 服务注册和配置中心
12. SpringCloud Alibaba Sentinel 实现熔断与限流
13. SpringCloud Alibaba Seata 处理分布式事务
14. 总结和回顾，闲聊和祝福

# P2 SpringBoot 和 SpringCloud 版本选型

# P3 SpringCloud 是什么能干吗

## 什么是微服务

微服务架构就是把一个大系统按业务功能分解成多个职责单一的小系统，每一个小模块尽量专一的只做一件事，并利用简单的方法使多个小系统相互协作，组合成一个大系统后再统一对外提供整体服务。

## Spring Cloud 是什么？能干嘛？产生背景？

让程序员专注于业务逻辑，有第三方支撑

# P4 SpringCloud 各组件的停更升级替换说明

## Netflix OSS 被移除的原因

Netflix 公司是目前微服务落地中最成功的公司。它开源了诸如 **Eureka、Hystrix、Zuul、Feign、Ribbon** 等等广大开发者所知微服务套件，统称为 **Netflix OSS**，在当时 Netflix OSS 成为微服务组件上事实的标准。但是微服务兴起不久，也就是在 2018 年前后 Netflix 公司宣布其核心组件  Hystrix、Ribbon、Zuul、Eureka 等进入了**维护状态**，不再进行新特性开发，只修 BUG

这直接影响了 Spring Cloud 项目的发展路线，**Spring** 官方不得不采取了应对措施，在 2019 年的在 **SpringOne 2019** 大会中，**Spring Cloud** 宣布 **Spring Cloud Netflix** 项目进入**维护模式**，并在 2020 年移除相关的  **Netflix OSS** 组件。

### Netflix 哪些被移除了

1. spring-cloud-netflix-archaius
2. spring-cloud-netflix-hystrix-contract
3. spring-cloud-netflix-hystrix-dashboard
4. spring-cloud-netflix-hystrix-stream
5. spring-cloud-netflix-hystrix
6. spring-cloud-netflix-ribbon
7. spring-cloud-netflix-turbine-stream
8. spring-cloud-netflix-turbine
9. spring-cloud-netflix-zuul

### Spring Cloud Netflix 项目进入维护模式

停更不停用

1. 被动修复 bugs
2. 不再接受合并请求
3. 不再发布新版本



## Cloud 2024

- 服务注册与发现
  - Eureka
  - Consul
  - Etcd
  - Nacos
- 服务调用和负载均衡
  - ~~Ribbon~~
  - OpenFeign
  - LoadBalancer
- 分布式事务
  - Seata
  - LCN
  - Hmily
- 服务熔断和降级
  - ~~Hystrix~~
  - Circuit Breaker
    - Resilience4J
  - Sentinel
- 服务链路追踪
  - ~~Sleuth 数据收集 + Zipkin 图形化展现~~
  - Micrometer Tracing
- 服务网关
  - ~~Zuul~~
  - Gateway
- 分布式配置管理
  - ~~Config + Bus~~
  - Consul
  - Nacos

# P5 项目实战之需求说明

1. 订单 -> 支付，业务需求说明
   - 服务注册发现 Nacos
   - 配置中心 Consul
   - 服务网关 Gateway
   - 远程调用 OpenFeign
   - 容错限流 Circuit Breaker 之 Resilience4J、Sentinel
   - 调用链监控 Micrometer
   - 分布式事务 Seata
2. 约定 > 配置 > 编码
3. IDEA 新建  Project 和 Maven 父工程
4. Mapper4 之一键生成
5. Rest 通用 Base 工程构建
6. 引入微服务理念，从这里开始

# P6 项目实战之 Maven 父工程聚合说明和 mysql 驱动选择

## 微服务 Cloud 整体聚合 Maven 父工程 Project

Maven 父工程步骤

1. New Project
2. 聚合总父工程名字
3. 字符编码
4. 注解生效激活
5. Java 编译版本选 17
6. File Type 过滤

## 父工程 POM 文件内容

## Maven 工程落地细节复习

### dependencyManagement

Maven 使用 dependencyManagement 元素来提供了一种管理依赖版本号的方式。

**通常会在一个组织或者项目的最顶层的父 POM 中看到 dependencyManagement 元素**

使用 pom.xml 中的 dependencyManagement 元素能让所有在子项目中引用一个依赖而不用显式的列出版本号。Maven 会沿着父子层次向上走，直到找到一个拥有 dependencyManagement 元素的项目，然后它就会使用这个 dependencyManagement 元素中指定的版本号。

这样做的好处就是：如果有多个子项目都引用同一样依赖，则可以避免在每个使用的子项目里都声明一个版本号，优势：

1. 这样当想升级或切换到另一个版本时，只需要在顶层父容器里更新，而不需要一个一个子项目的修改
2. 另外如果某个子项目需要另外的一个版本，只需要声明 version 就可。

dependencyManagement 里只是声明依赖，并不实现引入，因此子项目需要显示的声明需要用的依赖。

### Maven 中跳过单元测试

## mysql 驱动说明

### MySQL 5

```properties
# mysql 5.7 --- JDBC 四件套
jdbc.driverClass=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/db2024?useUnicode=true&characterEncoding=UTF-8&useSSL=false
jdbc.user=root
jdbc.password=123456
```

```xml
<!-- Maven 的 POM 文件处理 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.47</version>
</dependency>
```

### MySQL 8

```properties
# mysql 5.7 --- JDBC 四件套
jdbc.driverClass=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/db2024?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=GMT%2B8&rewriteBatchedStatements=true&allowPublicKeyRetrieval=true
jdbc.user=root
jdbc.password=123456
```

```xml
<!-- Maven 的 POM 文件处理 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.11</version>
</dependency>
```

# P7 项目实战之 Mapper4 一键生成 Dao 层代码

- mybatis-generator
- MyBatis 通用 Mapper 4
- MyBatis 通用 Mapper 5

## 一键生成步骤

- SQL
- Module
- POM
- 配置
- 一键生成

# P8 项目实战之微服务工程化编写步骤

## 工程V1

1. cloud-provider-payment8001 微服务提供者支付 Module 模块
   - 微服务小口诀
     1. 建 module
     2. 改 POM
     3. 写 YML
     4. 主启动
     5. 业务类
   - 步骤
   - 测试
     - Postman
     - Swagger 3
2. 上述模块还有哪些问题
   1. 时间格式问题
   2. Java 如何设计 API 接口实现统一格式返回
   3. 全局异常接入返回的标准格式
   4. ......

# P9 项目实战之 Pay 支付微服务编码落地实战

# P10 项目实战之 Postman 测试通过

# P11 项目实战之 Swagger 3 测试通过

- 常用注解

  - 注解列表

    - | 注解         | 标注位置            | 作用                   |
      | ------------ | ------------------- | ---------------------- |
      | @Tag         | Controller 类       | 标识 Controller 作用   |
      | @Parameter   | 参数                | 标识参数作用           |
      | @Parameters  | 参数                | 参数多重说明           |
      | @Schema      | model 层的 JavaBean | 描述模型作用及每个属性 |
      | @Operation   | 方法                | 描述方法作用           |
      | @ApiResponse | 方法                | 描述响应状态码等       |

  - Controller

    - @Tag
    - 修改 PayController

  - 方法

    - @Operation

  - entity 或者 DTO

    - @Schema

- 含分组迭代的 Config 配置类

  - Swagger3Config

    - ```java
      @Configuration
      public class Swagger3Config {
          @Bean
          public GroupedOpenApi PayApi() {
              return GroupedOpenApi.builder().group("支付微服务模块").pathsToMatch("/pay/**").build();
          }
          
          //...
          
          @Bean
          public OpenAPI docsOpenApi() {
              return new OpenAPI()
                  .info(new Info().title("cloud2024")
                       .description("通用设计rest")
                       .version("v1.0"))
                  .externalDocs(new ExternalDocumentation()
                               .description("www.atguigu.com")
                               .url("https://yiyan.baidu.com/"));
          }
      }
      ```

- 调用方式

# P12 项目实战之完善时间格式

## 工程V2

- 解决：时间格式问题

  - 可以在相应的类的属性上使用 @JsonFormat 注解

    ```java
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date billtime;
    ```

  - 如果是 Spring Boot 项目，也可以在 application.yml 文件中指定：

    ```yaml
    spring:
      jackson:
        date-format: yyyy-MM-dd HH:mm:ss
        time-zone: GMT+8
    ```

- 解决：统一返回值

- 解决：全局异常接入返回的标准格式

# P13 项目实战之完善统一返回枚举 ReturnCodeEnum

- 思路

  - 定义返回标准格式，3 大标配
    - code 状态值：由后端统一定义各种返回结果的状态码
    - message 描述：本次接口调用的结果描述
    - data 数据：本次返回的数据
  - 扩展
    - 接口调用时间之类
      - timestamp: 接口调用时间

- 步骤

  - 新建枚举类 ReturnCodeEnum

    - HTTP 请求返回的状态码

      - | 分类 | 区间      | 分类描述                                       |
        | ---- | --------- | ---------------------------------------------- |
        | 1**  | 100 ~ 199 | 信息，服务器收到请求，需要请求者继续执行操作   |
        | 2**  | 200 ~ 299 | 成功，操作被成功接受并处理                     |
        | 3**  | 300 ~ 399 | 重定向，需要进一步的操作以完成请求             |
        | 4**  | 400 ~ 499 | 客户端错误，请求包含语法错误或无法完成请求     |
        | 5**  | 500 ~ 599 | 服务端错误，服务器在处理请求的过程中发生了错误 |

    - `ReturnCodeEnum`

  - 新建统一定义返回对象 ResultData

    - `ResultData<T>`

- 修改 PayController

- 测试

- 结论

  - 通过 ResultData.success() 对返回结果进行包装后返回给前端

# P14 项目实战之完善统一返回对象 ResultData

# P15 项目实战之完善测试返回时间和统一值

# P16 项目实战之完善全局异常处理

- 为什么需要全局异常处理器

  - 不用再手写 try ... catch
  - 当然非要写 try-catch-finally 也是可以的

- 新建全局异常类 GlobalExceptionHandler

  ```java
  @Slf4j
  @RestControllerAdvice
  public class GlobalExceptionHandler {
      @ExceptionHandler(RuntimeException.class)
      @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
      public ResultData<String> exception(Exception e) {
          log.error("全局异常信息:{}", e.getMessage(), e);
          return ResultData.fail(ReturnCodeEnum.RC500.getCode(), e.getMessage())
      }
  }
  ```

- 修改 Controller

# P17 项目实战之 Order 订单微服务编码落地实战

引入微服务理念，从这里开始

- 订单微服务80如何才能调用到支付微服务8001？
- cloud-consumer-order80 微服务调用者订单 Module 模块
  - 建 cloud-consumer-order80
  - 改 POM
  - 写 YML
  - 主启动（修改  Main 类名为 Main80）
  - 业务类
    - entities
      - 传递数值 PayDTO
    - RestTemplate
      - 是什么
      - 官网地址
      - 常用 API 使用说明
        - 使用说明
          - 使用 restTemplate 访问  restful 接口非常的简单粗暴无脑。
          - （url, requestMap, ResponseBean.class）这三个参数分别代表：REST 请求地址、请求参数、HTTP 响应转换被转换成的对象模型。
        - getForObject 方法/getForEntity 方法
        - postForObject / postForEntity
        - GET 请求方法
        - POST 请求方法
    - config 配置类
    - Controller
  - postman 测试
- 工程重构
- 目前工程样图
- 为什么要引入微服务

# P18 项目实战之工程重构重复代码提取

工程重构

- 观察问题

  - 系统中有重复部分，重构

- 新建 Module

  - cloud-api-commons
  - 对外暴露通用的组件/api/接口/工具类等

- 改 POM

- entities

  - PayDTO
  - 统一返回

- 全局异常类，可加可不加，酌情

- maven 命令 clean install

- 订单 80 和支付 8001 分别改造

  - 删除各自的原先有过的 entities 和统一返回体等内容

  - 各自粘贴 POM 内容

    ```xml
    <!-- 引入自己定义的 api 通用包 -->
    <dependency>
        <groupId>com.atguigu.cloud</groupId>
        <artifactId>cloud-api-commons</artifactId>
        <version>1.0-SNAPSHOT</version>
    </dependency>
    ```

- postman 测试

目前工程样图

- 截止到目前，没有引入任何 SpringCloud 相关内容

为什么要引入微服务

- 上一步 Controller 的问题？？

  - 硬编码写死问题

    微服务所在的 IP 地址和端口号硬编码到订单微服务中，会存在非常多的问题

    1. 如果订单微服务和支付微服务的 IP 地址或者端口号**发生了变化**，则支付微服务将变得不可用，需要同步修改订单微服务中调用支付微服务的 IP 地址和端口号。
    2. 如果系统中提供了多个订单微服务和支付微服务，则无法实现微服务的**负载均衡**功能。
    3. 如果系统需要支持**更高的并发**，需要部署更多的订单微服务和支付微服务，硬编码订单微服务则后续的维护会变得异常复杂

    所以，在微服务开发的过程中，需要引入服务治理功能，实现微服务之间的动态注册与发现，从此刻开始我们正式进入 SpringCloud 实战

# P19 consul 之学习方法论和 eureka 为什么凉凉

4、Consul 服务注册与发现

- 为什么要引入服务注册中心

- 为什么不再使用传统老牌的 Eureka

  1. Eureka 停更进入维护模式

  2. Eureka 对初学者不友好

     - 首次看到自我保护机制

  3. 注册中心独立且和微服务功能解耦

     - 目前主流服务中心，希望单独隔离出来而不是作为一个独立微服务嵌入到系统中

       - 按照 Netflix 的之前的思路，注册中心 Eureka 也是作为一个微服务且需要程序员自己开发部署

         实际情况：

         希望微服务和注册中心分离解耦，注册中心和业务无关的，不要混为一谈。

         提供类似 tomcat 一样独立的组件，微服务注册上去使用，是个成品。

  4. 阿里巴巴 Nacos 的崛起

- consul 简介

  - 是什么
  - 能干嘛
  - 去哪下
  - 怎么玩

- 安装并运行 consul

- 服务注册与发现

- 服务配置与刷新

# P20 Consul 之是什么怎么玩

是什么

- consul 官网地址
- What is Consul?
  - Consul  是一套开源的分布式服务发现和配置管理系统，由 HashCorp 公司用 Go 语言开发。
  - 提供了微服务系统中的服务治理、配置中心、控制总线等功能。这些功能中的每一个都可以根据需要单独使用，也可以一起使用以构建全方位的服务网格，总之 Consul 提供了一种完整的服务网格解决方案。它具有很多优点。包括：基于 raft 协议，比较简洁；支持健康检查，同时支持 HTTP 和 DNS 协议；支持跨数据中心的 WAN 集群；提供图形界面；跨平台，支持 Linux、Mac、Windows
- 禁止使用问题
  - 条款链接
    - 中国禁用 Vault 企业版
  - 放心用
- Spring Consul

能干嘛

- 服务发现
  - 提供 HTTP 和 DNS 两种发现方式
- 健康检测
  - 支持多种方式，HTTP、TCP、Docker、Shell 脚本定制
- KV 存储
  - Key、Value 的存储方式
- 多数据中心
  - Consul 支持多数据中心
- 可视化 Web 界面

# P21 Consul 之下载安装运行

安装并运行 Consul

- 官网下载
- 下载完成后只有一个 consul.exe 文件，对应全路径下查看版本号信息
  - consul --version
- 使用开发模式启动
  - consul agent -dev
  - 通过以下地址可以访问 Consul 的首页：http://localhost:8500
  - 结果页面

# P22 Consul 之回答同学 8500 提问

# P23 Consul 之 Pay 支付微服务入驻

服务注册与发现

- 服务提供者 8001

  - 支付服务  provider 8001 注册进 Consul

  - POM

    - ```xml
      <dependency>
          <groupId>org.springframework.cloud</groupId>
          <artifactId>spring-cloud-starter-consul-discovery</artifactId>
      </dependency>
      ```

  - YML

    - ```yaml
      cloud:
        consul:
          host: localhost
          port: 8500
          discovery:
            service-name: ${spring.application.name} # 对应 yaml 里面的 spring:application:name: 的值
      ```

  - 主启动

    - @EnableDiscoveryClient
    - 开启服务发现

  - 启动 8001 并查看 Consul 控制台

- 服务消费者 80

- 三个注册中心异同点

# P24 Consul 之 Order 订单微服务入驻

服务消费者 80

- 修改微服务 cloud-consumer-order80

- POM

  - ```xml
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-consul-discovery</artifactId>
    </dependency>
    ```

- YML

  - ```yaml
    server:
      port: 80
    
    spring:
      application:
        name: cloud-consumer-order
      cloud:
        consul:
          host: localhost
          port: 8500
          discovery:
            prefer-ip-address: true # 优先使用服务 ip 进行注册
        server-name: ${spring.application.name}
    ```

- 主启动类

  - @EnableDiscoveryClient
  - 开启服务发现

- Controller

- 启动 80 并查看 Consul 控制台

- 访问测试地址

  - 结果如何
    - 一个 bug
    - java.net.UnknownHostException: cloud-payment-service

- 配置修改 RestTemplateConfig

  - @LoadBalanced

# P25 Consul 之其它注册中心的对比

三个注册中心异同点

| 组件名    | 语言 | CAP  | 服务健康检查 | 对外暴露接口 | Spring Cloud 集成 |
| --------- | ---- | ---- | ------------ | ------------ | ----------------- |
| Eureka    | Java | AP   | 可配支持     | HTTP         | 已集成            |
| Consul    | Go   | CP   | 支持         | HTTP/DNS     | 已集成            |
| Zookeeper | Java | CP   | 支持         | 客户端       | 已集成            |

- CAP
  - C：Consistency（强一致性）
  - A：Available（可用性）
  - P：Partition tolerance（分区容错性）
- 经典 CAP 图
  - **最多只能同时较好的满足两个。**
  - CAP 理论的核心是：**一个分布式系统不可能同时很好的满足一致性，可用性和分区容错性这三个需求**。
  - 因此，根据 CAP 原理将 NoSQL 数据库分成了满足 CA 原则、满足 CP 原则和满足 AP 原则三大类：
    - CA - 单点集群，满足一致性，可用性的系统，通常在可扩展性上不太强大。
    - CP - 满足一致性，分区容忍性的系统，通常性能不是特别高
    - AP - 满足可用性，分区容忍性的系统，通常可能对一致性要求低一些。
  - AP（Eureka）
    - AP 架构
    - 当网络分区出现后，为了保证可用性，系统 B 可以返回旧值，保证系统的可用性。
    - 当数据出现不一致时，虽然 A、B 上的注册信息不完全相同，但每个 Eureka 节点依然能够正常对外提供服务，这会出现查询服务信息时如果请求 A 查不到。但请求 B 就能查到。如此保证了可用性但牺牲了一致性结论：违背了一致性 C 的要求，只满足可用性和分区容错，即 AP
  - CP（Zookeeper/Consul）
    - CP 架构
    - 当网络分区出现后，为了保证一致性，就必须拒接请求，否则无法保证一致性，Consul 遵循 CAP 原理中的 CP 原则，保证了强一致性和分区容错性，且使用的是 Raft 算法，比 zookeeper 使用的 Paxos 算法更加简单。虽然保证了强一致性，但是可用性就相应下降了，例如服务注册的时间会稍长一些，因为 Consul 的 raft 协议要求必须过半数的节点都写入成功才认为注册成功；在 leader 挂掉了之后，重新选举出 leader 之前会导致 Consul 服务不可用。结论：违背了可用性 A 的要求，只满足一致性和分区容错，即 CP

# P26 consul 之分布式配置-上

服务配置与刷新

- 分布式系统面临的 -> 配置问题

  - 微服务意味着要将单体应用中的业务拆分成一个个子服务，每个服务的粒度相对较小，因此系统中会出现大量的服务。由于每个服务都需要必要的配置信息才能运行，所以一套集中式的、动态的配置管理设施是必不可少的。比如某些配置文件中的内容大部分都是相同的，只有个别的配置项不同。就拿数据库配置来说吧，如果每个微服务使用的技术栈都是相同的，则每个微服务中关于数据库的配置几乎都是相同的，有时候主机迁移了，我希望一次修改，处处生效。
  - 当下我们每一个微服务自己带着一个 application.yml，上百个配置文件的管理……

- 官网说明

  - Distributed Configuration with Consul

- 服务配置案例步骤

  - 需求

    - 通用全局配置信息，直接注册进 Consul 服务器，从 Consul 获取
    - 既然从 Consul 获取自然要遵守 Consul 的配置规则要求

  - 修改 cloud-provider-payment8001

  - POM

    - ```xml
      <dependency>
          <groupId>org.springframework.cloud</groupId>
          <artifactId>spring-cloud-starter-consul-config</artifactId>
      </dependency>
      <dependency>
          <groupId>org.springframework.cloud</groupId>
          <artifactId>spring-cloud-starter-bootstrap</artifactId>
      </dependency>
      ```

  - YML

    - 配置规则说明

      - >  if you have set `spring.cloud.bootstrap.enabled=true` or `spring.config.use-legacy-processing=true`, or included `spring-cloud-starter-bootstrap`, then the above values will need to be placed in `bootstrap.yml` instead of `application.yml`.

      - YAML must be set in the appropriate `data` key in consul. Using the defaults above the keys would look like:

        ```
        config/testApp,dev/data
        config/testApp/data
        config/application,dev/data
        config/application/data
        ```

        You could store a YAML document in any of the keys listed above.

    - 新增配置文件 bootstrap.yml

      - 是什么

        - application.yml 是用户级的资源配置项
        - bootstrap.yml 是系统级的，优先级更加高
        - Spring Cloud 会创建一个“Bootstrap Context”，作为 Spring 应用的“Application Context”的**父上下文**。初始化的时候，“Bootstrap Context” 负责从**外部源**加载配置属性并解析配置。这两个上下文共享一个从外部获取的“Environment”。
        - “Bootstrap” 属性有高优先级，默认情况下，它们不会被本地配置覆盖。“Bootstrap context” 和 “Application Context” 有着不同的约定，所以新增了一个“bootstrap.yml” 文件，保证“Bootstrap Context” 和 “Application Context” 配置的分离。
        - **application.yml 文件改为 bootstrap.yml，这是很关键的或者两者并存**
        - 因为 bootstrap.yml 是比 application.yml 先加载的。bootstrap.yml 优先级高于 application.yml

      - bootstrap.yml 内容

        - ```yaml
          spring:
            application:
              name: cloud-payment-service
            cloud:
              consul:
                host: localhost
                port: 8500
                discovery:
                  service-name: ${spring.application.name}
                config:
                  profile-separator: '-' # default value is ','. We update '-'
                  format: YAML
            # config/cloud-payment-service/data
            #       /cloud-payment-service-dev/data
            #       /cloud-payment-service-prod/data
          ```

    - application.yml 内容

      - ```yaml
        spring:
          datasource:
            type: com.alibaba.druid.pool.DruidDataSource
            driver-class-name: com.mysql.cj.jdbc.Driver
            url: jdbc:mysql://localhost:3306/db2024?characterEncoding=utf8&useSSL=false&serverTimezone=GMT%2B8&rewriteBatchedStatements=true&allowPublicKeyRetrieval=true
            username: root
            password: 123456
          profiles:
            active: dev # 多环境配置加载内容 dev/prod，不写就是默认 default 配置
        mybatis:
          mapper-locations: classpath:mapper/*.xml
          type-aliases-package: com.atguigu.cloud.entities
          configuration:
            map-underscore-to-camel-case: true
        ```

  - Consul 服务器 key/value 配置填写

  - Controller

  - 测试

- 动态刷新案例步骤

- 思考

# P27 consul 之分布式配置-下

Consul 服务器 key/value 配置填写

1. 参考规则

   ```yaml
   # config/cloud-payment-service/data
   # 		/cloud-payment-service-dev/data
   # 		/cloud-payment-service-prod/data
   ```

2. 创建 config 文件夹，以 / 结尾

3. config 文件夹下分别创建其他 3 个文件夹，以 / 结尾

   - cloud-payment-service
   - cloud-payment-service-dev
   - cloud-payment-service-prod

4. 上述 3 个文件夹下分别创建 data 内容，data 不再是文件夹

# p28 consul 之及时动态刷新

动态刷新案例步骤

- 问题

  - 接上一步，我们在 consul 的 dev 配置分支修改了内容马上访问，结果无效

- 步骤

  - @RefreshScope 主启动类添加

  - bootstrap.yml 修改下（只为教学实际别改）spring.cloud.consul.config.watch.wait-time

    - 官网说明

      - 默认 55
      - The number of seconds to wait (or block) for watch query, defaults to 55. Needs to be less than default ConsulClient (defaults to 60). To increase ConsulClient timeout create a ConsulClient bean with a custom ConsulRawClient with a custom HttpClient.

    - 修改步骤

      - ```yaml
        spring:
          cloud:
            consul:
              config:
                watch:
                  wait-time: 1
        ```

  - controller

思考

- 截止到这，服务配置和动态刷新全部通过，假设我重启 Consul，之前的配置还在吗？
- 试试
  - 引出问题
    - Consul 配置持久化

# P29 LoadBalancer 之基本简介

5、LoadBalancer 负载均衡服务调用

- Ribbon 目前也进入维护模式

  - 是什么
    - Spring Cloud Ribbon 是基于 Netflix Ribbon 实现的一套**客户端负载均衡工具**
    - 简单的说，Ribbon 是 Netflix 发布的开源项目，主要功能是提供**客户端的软件负载均衡算法和服务调用**。Ribbon 客户端组件提供一系列完善的配置项如 连接超时，重试等。简单的说，就是在配置文件中列出 Load Balancer（简称 LB）后面所有的机器，Ribbon 会自动的帮助你基于某种规则（如简单轮询，随机连接等）去连接这些机器。我们很容易使用 Ribbon 实现自定义的负载均衡算法。
  - 维护模式不再介绍，了解即可
  - Ribbon 未来替换方案
    - spring-cloud-loadbalancer

- spring-cloud-loadbalancer 概述

  - 官网

  - 是什么

    - **LB 负载均衡（Load Balance）是什么**

      简单的说就是将用户的请求平摊的分配到多个服务上，从而达到系统的 HA（高可用），常见的负载均衡有软件 Nginx，LVS，硬件 F5 等

    - **spring-cloud-starter-loadbalancer 组件是什么**

      Spring Cloud LoadBalancer 是由 SpringCloud 官方提供的一个开源的、简单易用的**客户端负载均衡器**，它包含在 SpringCloud-commons 中**用它来替换了以前的 Ribbon 组件**。相比较于 Ribbon，Spring Cloud LoadBalancer 不仅能够支持 RestTemplate，还支持 WebClient（Web Client 是 Spring Web Flux 中提供的功能，可以实现响应式异步请求）

  - 面试题

    - 客户端负载 VS 服务器端负载区别

      - **loadbalancer 本地负载均衡客户端 vs Nginx 服务端负载均衡区别**

        Nginx 是服务器负载均衡，客户端所有请求都会交给 nginx，然后由 nginx 实现转发请求，即负载均衡是由服务端实现的。

        loadbalancer 本地负载均衡，在调用微服务接口时候，会在注册中心上获取注册信息服务列表之后缓存到 JVM 本地，从而在本地实现 RPC 远程服务调用技术。

- spring-cloud-loadbalancer 负载均衡解析

- 负载均衡算法原理

# P30 LoadBalancer 之服务调用负载均衡实战-上

spring-cloud-loadbalancer 负载均衡解析

- 负载均衡演示案例-理论

  - 架构说明：80 通过轮询负载访问 8001/8002/8003

    - LoadBalancer 在工作时分成两部

    - **第一步**，先选择 ConsulServer 从服务端查询并拉取服务列表，知道了它有多个服务（上图 3 个服务），这 3 个实现是完全一样的。

      默认轮询调用谁都可以正常执行。类似生活中求医挂号，某个科室今日出诊的全部医生，客户端你自己选一个

    - **第二步**，按照指定的负载均衡策略从  server 取到的服务注册列表中由客户端自己选择一个地址，所以 **LoadBalancer 是一个客户端的负载均衡器**

- 负载均衡演示案例-实操

  - 官网参考如何正确使用？

  - 按照 8001 拷贝后新建 8002 微服务

  - 启动 Consul，将 8001/8002 启动后注册进微服务

    - consul agent -dev

    - 将 8001/8002 启动后注册进微服务

    - bug

      - 我们之前配置完全消失了……

        没有持久化保存

      - Consul 数据持久化配置并且注册为 Windows 服务

    - 后台自启动 Consul 测试地址

      - http://localhost:8001/pay/get/info

  - 订单 80 模块修改 POM 并注册进 Consul，新增 LoadBalancer 组件

  - 订单 80 模块修改 Controller 并启动 80

  - 目前 Consul 上的服务

  - 测试

- 负载均衡演示案例-小总结

# P31 LoadBalancer 之 Consul 配置持久化

Consul 数据持久化配置并且注册为 Windows 服务

1. D:\devSoft\consul_1.17.0_windows_386 目录下新建

   - 空文件夹 mydata
   - 新建文件 consul_start.bat  后缀为 .bat

2. consul_start.bat 内容信息

   - ```bash
     @echo.服务启动......
     @echo off
     @sc create Consul binpath= "D:\devSoft\consul_1.17.0_windows_386\consul.exe agent -server -ui -bind=127.0.0.1 -client=0.0.0.0 -bootstrap-expect 1 -data-dir D:\devSoft\consul_1.17.0_windows_386\mydata "
     @net start Consul
     @sc config Consul start= AUTO
     @echo.Consul start is OK......success
     @pause
     ```

3. 右键管理员权限打开

4. 启动结果

5. win 后台

6. 后续 consul 的配置数据会保存进 mydata 文件夹，重启有了

# P32 LoadBalancer 之服务调用负载均衡实战-下

订单 80 模块修改 POM 并注册进 Consul，新增 LoadBalancer 组件

- 3.13. Spring Cloud LoadBalancer Starter

  We also provide a starter that allows you to easily add Spring Cloud LoadBalancer in a Spring Boot app. In order to use it,  just add `org.springframework.cloud:spring-cloud-starter-loadbalancer` to your Spring Cloud dependency in your build file.

  > Note
  >
  > Spring Cloud LoadBalancer starter includes Spring Boot Caching and Evictor

  ```xml
  <!-- Loadbalancer -->
  <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-loadbalancer</artifactId>
  </dependency>
  ```

订单 80 模块修改 Controller 并启动 80

- ```java
  @GetMapping(value = "/consumer/pay/get/info")
  private String getInfoByConsul() {
      return restTemplate.getForObject(PaymentSrv_URL + "/pay/get/info", String.class);
  }
  ```

测试

- http://localhost/consumer/pay/get/info
- 通过上述地址，交替访问到了 8001/8002

# P33 LoadBalancer 之服务调用负载均衡原理

负载均衡演示案例-小总结

- 编码使用 DiscoveryClient 动态获取所有上线的服务列表

  - Using the DiscoveryClient

  - ```java
    @Autowired
    private DiscoveryClient discoveryClient;
    ```

- 代码解释，修改 80 微服务的 Controller

  - ```java
    @Resource
    private DiscoveryClient discoveryClient;
    @GetMapping("/consumer/discovery")
    public String discovery() {
        List<String> services = discoveryClient.getServices();
        for (String element: services) {
            System.out.println(elements);
        }
        System.out.println("===============");
        
        List<ServiceInstance> instances = discoveryClient.getInstances("cloud-payment-service");
        for (ServiceInstance element: instances) {
            System.out.println(element.getServiceId() + "\t" + element.getHost() + "\t" + element.getPort() + "\t" + element.getUri());
        }
        
        return instances.get(0).getServiceId() + ":" + instances.get(0).getPort();
    }
    ```

- 结合前面实操，负载选择原理小总结

  - 负载均衡算法：rest 接口第几次请求数 % 服务器集群总数量 = 实际调用服务器位置下标，每次服务重启动后 rest 接口计数从 1 开始。

  - `List<ServiceInstance> instances = discoveryClient.getInstances("cloud-payment-service");`

    如： List[0] instances = 127.0.0.1:8002

    List[1] instances = 127.0.0.1:8001

  - 8001+8002 组合成为集群，它们共计 2 台机器，集群总数为 2，按照轮询算法原理：

    当总请求数为 1 时：1 % 2 = 1 对应下标位置为 1，则获得服务地址为 127.0.0.1:8001

    当总请求数为 2 时：2 % 2 = 1 对应下标位置为 0，则获得服务地址为 127.0.0.1:8002

    当总请求数为 3 时：3 % 2 = 1 对应下标位置为 1，则获得服务地址为 127.0.0.1:8001

    当总请求数为 4 时：4 % 2 = 1 对应下标位置为 0，则获得服务地址为 127.0.0.1:8002

    如此类推……

# P34 LoadBalancer 之负载算法切换

负载均衡算法原理

- 默认算法是什么？有几种？

  - 官网 Load balancing algorithm
    - `ReactiveLoadBalancer` 接口实现默认是 `RoundRobinLoadBalancer`
  - 默认 2 种
    - 轮询 `RoundRobinLoadBalancer` implements ReactorServiceInstanceLoadBalancer
    - 随机 `RandomLoadBalancer` implements ReactorServiceInstanceLoadBalancer
  - 源码流程浅读，不用深入非重点
    - org.springframework.cloud.client.loadbalancer.reactive.ReactiveLoadBalancer
    - 接口 ReactiveLoadBalancer

- 算法切换

  - 从默认的轮询，切换为随机算法，修改 RestTemplateConfig

    - ```java
      @Configuration
      @LoadBalancerClient(
      	// 下面的 value 值大小写一定要和 Consul 里面的名字一样，必须一样
          value = "cloud-payment-service", configuration = RestTemplateConfig.class)
      public class RestTemplateConfig {
          @Bean
          @LoadBalanced // 使用 @LoadBalanced 注解赋予 RestTemplate 负载均衡的能力
          public RestTemplate restTemplate() {
              return new RestTemplate();
          }
          
          @Bean
          ReactorLoadBalancer<ServiceInstance> randomLoadBalancer(Environment environment, LoadBalancerClientFactory loadBalancerClientFactory) {
              String name = environment.getProperty(LoadBalancerClientFactory.PROPERTY_NAME);
              return new RandomLoadBalancer(loadBalancerClientFactory.getLazyProvider(name, ServiceInstanceListSupplier.class), name);
          }
      }
      ```

- 测试

# P35 OpenFeign 之基本介绍

6、OpenFeign 服务接口调用

- 提问

  - 已经有 loadbalancer 为什么还要学习 OpenFeign?
  - 两个都有道理的话，我日常用哪个？

- 是什么

  - 官网翻译

    - Feign 是**一个声明性 Web 服务客户端**。它使编写 web 服务客户端变得更容易。**使用 Feign 创建一个接口并对其进行注解**。它具有可插入的注解支持，包括 Feign 注解和 JAX-RS 注解。Feign 还支持可插拔编码器和解码器。Spring Cloud 添加了对 Spring MVC 注解的支持，以及对使用 Spring Web 中默认使用的 HttpMessageConverter 的支持。Spring Cloud 集成了 Eureka、Spring Cloud CircuitBreaker 以及 Spring Cloud LoadBalancer，以便在使用 Feign 时提供 负载均衡的 http 客户端。
    - Feign is a declarative web service client. It makes writing web service clients easier. To use Feign create an interface and annotate it.

  - GitHub

  - 一句话

    - openfeign 是一个声明式的 Web 服务客户端，只需创建一个 Rest 接口并在该接口上添加注解 @FeignClient 即可

      - 1、Declarative REST Client: Feign

        Feign is a declarative web service client. It makes writing web service easier. To use Feign create an interface and annotate it.

        ```java
        @FeignClient("stores")
        public interface StoreClient {
            @RequestMapping(method = RequestMethod.GET, value = "/stores")
            List<Store> getStores();
            
            //...
        }
        ```

    - OpenFeign 基本上就是当前微服务之间调用的事实标准

- 能干嘛

  - 可插拔的注解支持，包括 Feign 注解和 JAX-RS 注解
  - 支持可插拔的 HTTP 编码器和解码器
  - 支持 Sentinel 和它的 Fallback
  - 支持 SpringCloudLoadBalancer 的负载均衡
  - 支持 HTTP 请求和响应的压缩

  Open Feign 能干什么

  - 前面在使用 SpringCloud LoadBalancer + RestTemplate 时，利用 RestTemplate 对 http 请求的封装处理形成了一套模板化的调用方法。**但是在实际开发中**，由于对服务依赖的调用可能不止一处，**往往一个接口会被多处调用，所以通常都会针对每个微服务自行封装一些客户端类来包装这些依赖服务的调用**。所以，OpenFeign 在此基础上做了进一步封装，由他来帮助我们定义和实现依赖服务接口的定义。在 OpenFeign 的实现下，**我们只需创建一个接口并使用注解的方式来配置它（在一个微服务接口上面标注一个 @FeignClient 注解即可）**，即可完成对服务提供方的接口绑定，统一对外暴露可以被调用的接口方法，大大简化和降低了调用客户端的开发量，也即由服务提供者给出调用接口清单，消费者直接通过 OpenFeign 调用即可。

  OpenFeign 同时还集成 SpringCloud LoadBalancer

  - 可以在使用 OpenFeign 时提供 Http 客户端的负载均衡，也可以集成阿里巴巴 Sentinel 来提供熔断、降级等功能。而与 SpringCloud LoadBalancer 不同的是，通过 OpenFeign 只需要定义服务绑定接口且以声明式的方法，优雅而简单的实现了服务调用。

- OpenFeign 通用步骤（怎么玩）

- OpenFeign 高级特性

- OpenFeign 和 Sentinel 集成实现 fallback 服务降级

# P36 OpenFeign 之通用步骤实战编码

OpenFeign 通用步骤（怎么玩）

- 接口+注解

  - 微服务 Api 接口 + **@FeignClient 注解标签**
  - 架构说明图
    - 服务消费者 80 -> 调用含有 @FeignClient 注解的 Api 服务接口 -> 服务提供者（8001/8002）

- 流程步骤

  - 建 Module

    - cloud-consumer-feign-order80
      - Feign 在消费端使用

  - 改 POM

    - 引入依赖

      - ```xml
        <!-- openfeign -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
        ```

  - 写 YML

    - ```yaml
      server:
        port: 80
      
      spring:
        application:
          name: cloud-consumer-openfeign-order
        cloud:
          consul:
            host: localhost
            port: 8500
            discovery:
              prefer-ip-address: true # 优先使用服务 ip 进行注册
              service-name: ${spring.application.name}
      ```

  - 主启动（修改类名为 MainOpenFeign80）

    - 主启动类上面配置 @EnableFeignClients 表示开启 OpenFeign 功能并激活

    - @EnableFeignClients

    - ```java
      @SpringBootApplication
      @EnableDiscoveryClient // 该注解用于向使用 consul 为注册中心时注册服务
      @EnableFeignClients // 启用 feign 客户端，定义服务+绑定接口，以声明式的方法优雅而简单的实现服务调用
      public class MainOpenFeign80 {
          public static void main(String[] args) {
              SpringApplication.run(MainOpenFeign80.class, args);
          }
      }
      ```

  - 业务类

    - 按照架构说明图进行编码准备

      - 订单模块要去调用支付模块，订单和支付两个微服务，需要通过 Api 接口解耦，一般不要在订单模块写非订单相关的业务，自己的业务自己做 + 其他模块走 FeignApi 接口调用

    - 修改 cloud-api-commons 通用模块

      - 引入 openfeign 依赖

        - ```xml
          <!-- openfeign -->
          <dependency>
              <groupId>org.springframework.cloud</groupId>
              <artifactId>spring-cloud-starter-openfeign</artifactId>
          </dependency>
          ```

      - 新建服务接口 PayFeignApi，头上配置 @FeignClient 注解

      - 参考微服务 8001 的 Controller 层，新建 PayFeignApi 接口

        - ```java
          @FeignClient(value = "cloud-payment-service")
          public interface PayFeignApi {
              @PostMapping("/pay/add")
              public ResultData addPay(@RequestBody PayDTO payDTO);
              
              @GetMapping("/pay/get/{id}")
              public ResultData getPayInfo(@PathVariable("id") Integer id);
              
              @GetMapping("pay/get/info")
              public String mylb();
          }
          ```

      - bug 提醒一下

        - `@PathVariable("id")` 别漏了 "id"

    - 拷贝之前的 80 工程进 cloud-consumer-feign-order80，记得去掉部分代码和 LoadBalancer 不相关特

    - 修改 Controller 层的调用

- 测试

- 小总结

# P37 OpenFeign 之通用步骤测试和小总结

测试

- 先启动 Consul 服务器
- 再启动微服务 8001
- 再启动 cloud-consumer-feign-order80
- Postman 测试
  - 新增
  - 查询
- 再启动微服务 8002，测试看看
  - http://localhost/feign/pay/mylb
  - OpenFeign 默认集成了 LoadBalancer
  - 上述官网说明
    - `spring-cloud-starter-openfeign` supports `spring-cloud-starter-loadbalancer`. However, as is an optional dependency, you need to make sure it has been added to your project if you want to use it.

# P38 OpenFeign 之超时控制

OpenFeign 高级特性

1. OpenFeign 超时控制

   - 本次 OpenFeign 的版本要注意，最新版和网络上你看到的配置不一样

     - 在 Spring Cloud 微服务架构中，大部分公司都是利用 OpenFeign 进行服务间的调用，而比较简单的业务使用默认配置是不会有多大问题的，但是如果是业务比较复杂，服务要进行比较繁杂的业务计算，那后台很有可能会出现 Read Timeout 这个异常，因此定制化配置超时时间就有必要了。

   - 超时设置，故意设置超时演示出错请求，自己使坏写 bug

     - 服务提供方 cloud-provider-payment8001 故意写暂停 62 秒钟程序
     - 服务调用方 cloud-consumer-feign-order80 写好捕捉超时异常
     - 测试
       - 错误页面
     - 结论
       - OpenFeign 默认等待 60 秒钟，超过后报错

   - 官网解释 + 配置处理

     - 两个关键参数

       - 1.3. Timeout Handling

       - 默认 OpenFeign 客户端等待 60 秒钟，但是服务端处理超过规定时间会导致 Feign 客户端返回报错。为了避免这样的情况，有时候我们需要设置 Feign 客户端的超时控制，默认 60 秒太长或者业务时间太短都不好

       - yml 文件中开启配置：

         connectTimeout 连接超时时间

         readTimeout 请求处理超时时间

     - 超时配置参考官网要求

   - 修改 cloud-consumer-feign-order80 YML 文件里需要开启 OpenFeign 客户端超时控制

     - 官网出处

     - 全局配置

       - 关键内容

         - ```yaml
           spring:
             cloud:
               openfeign:
                 client:
                   config:
                     default:
                       # 连接超时时间
                       connectTimeout: 3000
                       # 读取超时时间
                       readTimeout: 3000
           ```

       - all

       - 3 秒测试

     - 指定配置

       - 单个服务配置超时时间（家庭作业）

         - 家庭作业

           - ```yaml
             spring:
               cloud:
                 openfeign:
                   client:
                     config:
                       # default 设置的全局超时时间，指定服务名称可以设置单个服务的超时时间
                       default:
                         # 连接超时时间
                         connectTimeout: 4000
                         # 读取超时时间
                         readTimeout: 4000
                       # 为 serviceC 这个服务单独配置超时时间，单个配置的超时时间将会覆盖全局配置
                       serviceC:
                         # 连接超时时间
                         connectTimeout: 2000
                         # 读取超时时间
                         readTimeout: 2000
             ```

       - 关键内容

         - default -> cloud-payment-service

       - all

         - ```yaml
           spring:
             application:
               name: cloud-consumer-openfeign-order
             cloud:
               consul:
                 host: localhost
                 port: 8500
                 discovery:
                   prefer-id-address: true
                   service-name: ${spring.application.name}
               openfeign:
                 client:
                   config:
                     # default:
                       # connectTimeout: 4000 # 连接超时时间
                       # readTimeout: 4000 # 读取超时时间
                     cloud-payment-service:
                       # 连接超时时间
                       connectTimeout: 8000
                       # 读取超时时间
                       readTimeout: 8000
           ```

       - 5 秒测试

         - default 和 service 配置可以共存，选择符合的更细维度的配置

2. OpenFeign 重试机制

3. OpenFeign 默认 HttpClient 修改

4. OpenFeign 请求/响应压缩

5. OpenFeign 日志打印功能

# P39 OpenFeign 之重试机制

OpenFeign 重试机制

- 步骤

  - 默认重试是关闭的，给了默认值

    - 默认情况下会创建 `Retryer.NEVER_RETRY` 类型为 `Retryer` 的 bean，这将禁用重试。请注意，这种重试行为与 Feign 默认行为不同，它会自动重试 IOExceptions，将它们视为与网络相关的瞬态异常，以及从 ErrorDecoder 抛出的任何 RetryableException。

  - 默认关闭重试机制，测试看看

    - 结果，只会调用一次就结束

  - 开启 Retryer 功能

    - 新增配置类 FeignConfig 并修改 Retryer 配置

      - ```java
        @Configuration
        public class FeignConfig {
            @Bean
            public Retryer myRetryer() {
                // return Retryer.NEVER_RETRY; // Feign 默认配置是不走重试策略的
                
                // 最大请求次数为 3（1+2），初始间隔时间为 100ms，重试间最大间隔时间为 1s
                return new Retryer.Default(100, 1, 3);
            }
        }
        ```

    - 结果，总体调用 3 次

      - 3 = 1(default) + 2

- 补充一句

  - 如果你觉得效果不明显的同学，后续演示 feign 日志功能的时候再演示，目前控制台没有看到 3 次重试过程，只看到结果，正常的，正确的，是 feign 的日志打印问题

# P40 OpenFeign 之性能优化 HttpClient5

OpenFeign 默认 HttpClient 修改

- 是什么

  - OpenFeign 中 http client 如果不做特殊配置，**OpenFeign 默认使用 JDK 自带的 HttpURLConnection 发送 HTTP 请求**，由于默认 HttpURLConnection 没有连接池、性能和效率比较低，如果采用默认，性能上不是最牛 B 的，所以加到最大。

- 替换之前，还是按照超时报错的案例

  - ```java
    @GetMapping("/feign/pay/get/{id}")
    public ResultData getPayInfo(@PathVariable("id") Integer id) {
        System.out.println("------- 支付微服务远程调用，按照 id 查询订单支付流水信息");
        ResultData resultData = null;
        try {
            System.out.println("--- 调用开始：" + DateUtil.now());
            resultData = payFeignApi.getPayInfo(id);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("--- 调用结束：" + DateUtil.now());
            return ResultData.fail(ReturnCodeEnum.RC500.getCode(), e.getMessage());
        }
        return resultData;
    }
    ```

  - 替换之前，默认用的是什么

    - 看报错堆栈，看出是 HttpURLConnection

- Apache HttpClient 5 替换 OpenFeign 默认的 HttpURLConnection

  - why

  - 修改微服务 feign80 cloud-consumer-openfeign-order

    - FeignConfig 类里面将 Retryer 属性修改为默认

    - POM 修改

      - ```xml
        <!-- httpclient5 -->
        <dependency>
            <groupId>org.apache.httpcomponents.client5</groupId>
            <artifactId>httpclient5</artifactId>
            <version>5.3</version>
        </dependency>
        <!-- feign-hc5 -->
        <dependency>
        	<groupId>io.github.openfeign</groupId>
            <artifactId>feign-hc5</artifactId>
            <version>13.1</version>
        </dependency>
        ```

    - Apache HttpClient5 配置开启说明

      - ```yaml
        # Apache HttpClient5 配置开启
        spring:
          cloud:
            openfeign:
              httpclient:
                hc5:
                  enabled: true
        ```

    - YML 修改

- 替换之前

- 替换之后

# P41 OpenFeign 之请求回应压缩

OpenFeign 请求/响应压缩

- 官网说明

  - 1.10. Feign request/response compression

- 是什么

  - **对请求和响应进行 GZIP 压缩**

    Spring Cloud OpenFeign 支持对请求和响应**进行 GZIP 压缩**，以减少通信过程中的性能损耗。通过下面的两个参数设置，就能开启请求与相应的压缩功能：

    ```properties
    spring.cloud.openfeign.compression.request.enabled=true
    spring.cloud.openfeign.compression.response.enabled=true
    ```

  - **细粒度化设置**

    对请求压缩做一些更细致的设置，比如下面的配置内容指定压缩的请求数据类型并设置了请求压缩的大小下限，只有超过这个大小的请求才会进行压缩：

    ```properties
    spring.cloud.openfeign.compression.request.enabled=true
    spring.cloud.openfeign.compression.request.mime-types=text/xml,application/xml,application/json # 触发压缩数据类型
    spring.cloud.openfeign.compression.request.min-request-size=2048 # 最小触发压缩的大小
    ```

- YML

  - ```yaml
    spring:
      cloud:
        openfeign:
          compression:
            request:
              enabled: true
              min-request-size: 2048 # 最小触发压缩的大小
              mime-types: text/xml,application/xml,application/json # 触发压缩数据类型
            response:
              enabled: true
    ```

- 压缩效果测试在下一章节体现

# P42 OpenFeign 之 feign 日志打印

OpenFeign 日志打印功能

- 日志打印功能

- 是什么

  - Feign 提供了日志打印功能，我们可以通过配置来调整日志级别，从而了解 Feign 中 Http 请求的细节，说白了就是**对 Feign 接口的调用情况进行监控和输出**

- 日志级别

  - **NONE：默认的，不显示任何日志**
  - BASIC：仅记录请求方法、URL、响应状态码及执行时间；
  - HEADERS：除了 BASIC 中定义的信息之外，还有请求和响应的头信息；
  - FULL：除了 HEADERS 中定义的信息之外，还有请求和响应的正文及元数据。

- 配置日志 bean

  - ```java
    @Configuration
    public class FeignConfig {
        // ...
        
        @Bean
        Logger.Level feignLoggerLevel() {
            return Logger.Level.FULL;
        }
    }
    ```

- YML 文件里需要开启日志的 Feign 客户端

  - 1.11. Feign logging

    Feign logging only responds to the `DEBUG` level.

  - 公式（三段）：`logging.level + 含有 @FeignClient 注解的完整带包名的接口名 + debug`

  - ```yaml
    # feign 日志以什么级别监控哪个接口
    logging:
      level:
        com:
          atguigu:
            cloud:
              apis:
                PayFeignApi: debug
    ```

- 后台日志查看

  - 带着压缩调用
  - 去掉压缩调用

- 补充实验，重试机制控制台看到 3 次过程

  - 类 FeignConfig
  - YML（看到效果改为 2 秒）
  - 测试地址
  - 控制台 3 次重试触发效果的过程

- 本节内容最后的 YML

  - ```yaml
    spring:
      application:
        name: cloud-consumer-openfeign-order
      cloud:
        consul:
          host: localhost
          port: 8500
          discovery:
            prefer-id-address: true
            service-name: ${spring.application.name}
        openfeign:
          client:
            config:
              # default:
                # connectTimeout: 3000 # 连接超时时间
                # readTimeout: 3000 # 读取超时时间
              cloud-payment-service:
                # 连接超时时间
                connectTimeout: 2000
                # 读取超时时间
                readTimeout: 2000
          httpclient:
            hc5:
              enabled: true
          compression:
            request:
              enabled: true
              min-request-size: 2048 # 最小触发压缩的大小
              mime-types: text/xml,application/xml,application/json # 触发压缩数据类型
            response:
              enabled: true
    # feign 日志以什么级别监控哪个接口
    logging:
      level:
        com:
          atguigu:
            cloud:
              apis:
                PayFeignApi: debug
    ```

# P43 Resilience4j 之 Hystrix 停更进维概述

7、CircuitBreaker 断路器

- Hystrix 目前也进入了维护模式
  - 是什么
    - Hystrix 是一个用于处理分布式系统的**延迟**和**容错**的开源库，在分布式系统里，许多依赖不可避免的会调用失败，比如超时、异常等，Hystrix 能够保证在一个依赖出问题的情况下，**不会导致整体服务失败，避免级联故障，以提高分布式系统的弹性**。
    - 了解一下即可，2024 年了不再使用 Hystrix
    - 豪猪，不是刺猬
  - Hystrix 官宣，停更进维
  - Hystrix 未来替换方案
    - Resilience4j
- 概述
- Circuit Breaker 是什么
- Resilience4J
- 案例实战

# P44 Resilience4j 之分布式系统服务降级熔断故障概述

概述

- 2023 年影响极大的真实生产故障

  - 语雀崩了（2023.10.23）
  - 阿里系大部分产品（2023.11.12）
  - 阿里云产品控制台

- 分布式系统面临的问题

  - **复杂分布式体系结构中的应用程序有数十个依赖关系，每个依赖关系在某些时候将不可避免地失败。**

  - **服务雪崩**

    多个微服务之间调用的时候，假设微服务 A 调用微服务 B 和微服务 C，微服务 B 和微服务 C 又调用其它的微服务，这就是所谓的**“扇出”**。如果扇出的链路上某个微服务的调用响应时间过长或者不可用，对微服务 A 的调用就会占用越来越多的系统资源，进而引起系统崩溃，所谓的“雪崩效应”。

    对于高流量的应用来说，单一的后端依赖可能会导致所有服务器上的所有资源都在几秒钟内饱和。比失败更糟糕的是，这些应用程序还可能导致服务之间的延迟增加，备份队列，线程和其他系统资源紧张，导致整个系统发生更多的级联故障。这些都表示需要对故障和延迟进行隔离的管理，以便单个依赖关系的失败，不能取消整个应用程序或系统。

    所以，通常当你发现一个模块下的某个实例失败后，这时候这个模块依然还会接收流量，然后这个有问题的模块还调用了其他的模块，这样就会发生级联故障，或者叫雪崩。

- 我们的诉求

  - **问题：**

    禁止服务雪崩故障

  - **解决：**

    有问题的节点，快速熔断（快速返回失败处理或者返回默认兜底数据【服务降级】）。

    “断路器”本身是一种开关装置，当某个服务单元发生故障之后，通过断路器的故障监控（类似熔断保险丝），**向调用方返回一个符合预期的、可处理的备选响应（Fallback），而不是长时间的等待或者 抛出调用方无法处理的异常**，这样就保证了服务调用方的线程不会被长时间、不必要地占用，从而避免了故障在分布式系统中的蔓延，乃至雪崩。

    一句话，**出故障了“保险丝”跳闸，别把整个家给烧了**

- 如何搞定上述问题，避免整个系统大面积故障

  - 给我搞定

    - 服务熔断

      - 类似保险丝，保险丝闭合状态（CLOSE）可以正常使用，当达到最大服务访问后，直接拒绝访问跳闸限电（OPEN），此刻调用方会接受服务降级的处理并返回友好兜底提示
      - 就是家里保险丝，从闭合 CLOSE 供电状态 -> 跳闸 OPEN 打开状态

    - 服务降级

      - 服务器忙，请稍后再试。

        不让客户端等待并立即返回一个友好提示，fallback

    - 服务限流

      - 秒杀高并发等操作，严禁一窝蜂的过来拥挤，大家排队，一秒钟 N 个，有序进行

    - 服务限时

    - 服务预热

    - 接近实时的监控

    - 兜底的处理动作

    - ……

  - NOW

    - 我们用什么替代？
      - Spring Cloud Circuit Breaker

# P45 Resilience4j 之 Circuit Breaker 是什么

Circuit Breaker 是什么

- 官网
- 实现原理
  - Circuit Breaker 的目的是保护分布式系统免受故障和异常，提高系统的可用性和健壮性。
  - 当一个组件或服务出现故障时，Circuit Breaker 会迅速切换到开放 OPEN 状态（保险丝跳闸断电），阻止请求发送到该组件或服务从而避免更多的请求发送到该组件或服务。这可以减少对该组件或服务的负载，防止该组件或服务进一步崩溃，并使整个系统能够继续正常运行。同时，Circuit Breaker 还可以提高系统的可用性和健壮性，因为它可以在分布式系统的各个组件之间自动切换，从而避免单点故障的问题。
  - three normal states: CLOSED, OPEN and HALF_OPEN and two spacial states DISABLED and FORCED_OPEN.
- 一句话
  - **Circuit Breaker 只是一套规范和接口，落地实现者是 Resilience4J**

# P46 Resilience4j 之 Resilience4j 轻量级容错框架

Resilience4J

- 是什么

  - **一、简介**

    Resilience4j 是一个专为函数式编程设计的轻量级容错库。Resilience4j 提供高阶函数（装饰器），以通过断路器、速率限制器、重试或隔板增强任何功能接口、lambda 表达式或方法引用。您可以在任何函数式接口、lambda 表达式或方法引用上堆叠多个装饰器。优点是您可以选择您需要的装饰器，而没有其他选择。

    Resilience4j 2 需要 Java 17。

- 能干嘛

  - **3、概述**

    Resilience4j 提供了几个核心模块：

    - resilience4j-Circuitbreaker: 断路
    - resilience4j-ratelimiter: 速率限制
    - resilience4j-bulkhead: 舱壁
    - resilience4j-retry: 自动重试（同步和异步）
    - resilience4j-timelimiter: 超时处理
    - resilience4j-cache: 结果缓存

    还有用于指标、Feign、Kotlin、Spring、Ratpack、Vertx、RxJava2 等的附加模块。

- 怎么玩

  - 官网
  - 中文手册

# P47 Resilience4j 之断路器底层原理和状态转换分析

案例实战

- 熔断（CircuitBreaker）（服务熔断 + 服务降级）
  - 断路器 3 大状态
  - 断路器 3 大状态之间的转换
    - 断路器有三个普通状态：关闭（CLOSED）、开启（OPEN）、半开（HALF_OPEN），还有两个特殊状态：禁用 （DISABLED）、强制开启（FORCED_OPEN）。
    - 当熔断器关闭时，所有的请求都会通过熔断器。
      - 如果失败率超过设定的阈值，熔断器就会从关闭状态转换到打开状态，这时所有的请求都会被拒绝。
      - 当经过一段时间后，熔断器会从打开状态转换到半开状态，这时仅有一定数量的请求会被放入，并重新计算失败率
      - 如果失败率超过阈值，则变为打开状态，如果失败率低于阈值，则变为关闭状态。
    - 断路器使用滑动窗口在存储和统计调用的结果。你可以选择基于调用数量的滑动窗口或者基于时间的滑动窗口。
      - 基于访问数量的滑动窗口统计了最近 N 次调用的返回结果。居于时间的滑动窗口统计了最近 N 秒的调用返回结果。
    - 除此以外，熔断器还会有两种特殊状态：DISABLED（始终允许访问）和 FORCED_OPEN（始终拒绝访问）。
      - 这两个状态不会生成熔断器事件（除状态转换外），并且不会记录事件的成功或者失败。
      - 退出这两个状态的唯一方法是触发状态转换或者重置熔断器。
  - 断路器所有配置参数参考
  - 熔断 + 降级案例需求说明
  - 干，按照 COUNT_BASED（计数的滑动窗口）
  - 干，按照 TIME_BASED（时间的滑动窗口）
  - 小总结
- 隔离（BulkHead）
- 限流（RateLimiter）

# P48 Resilience4j 之断路器配置解析

断路器所有配置参数参考

- 英文

- 中文手册

  - | 配置属性                                     | 默认值                                                       | 描述                                                         |
    | -------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | failureRateThreshold                         | 50                                                           | 以百分比配置失败率阈值。当失败率等于或大于阈值时，断路器状态并关闭变为开启，并进行服务降级。 |
    | slowCallRateThreshold                        | 100                                                          | 以百分比的方式配置，断路器把调用时间大于 slowCallDurationThreshold 的调用视为慢调用，当慢调用比例大于等于阈值时，断路器开启，并进行服务降级。 |
    | slowCallDurationThreshold                    | 60000[ms]                                                    | 配置调用时间的阈值，高于该阈值的呼叫视为慢调用，并增加慢调用比例。 |
    | permittedNumberOfCallsInHalfOpenState        | 10                                                           | 断路器在半开状态下允许通过的调用次数。                       |
    | maxWaitDurationInHalfOpenState               | 0                                                            | 断路器在半开状态下的最长等待时间，超过该配置值的话，断路器会从半开状态恢复为开启状态。配置是 0 时表示断路器会一直处于半开状态，直到所有允许通过的访问结束。 |
    | slidingWindowType                            | COUNT_BASED                                                  | 配置滑动窗口的类型，当断路器关闭时，将调用的结果记录在滑动窗口中。滑动窗口的类型可以是 count-based 或 time-based。如果滑动窗口类型是 COUNT_BASED，将会统计记录最近 slidingWindowSize 次调用的结果。如果是 TIME_BASED，将会统计记录最近 slidingWindowSize 秒的调用结果。 |
    | slidingWindowSize                            | 100                                                          | 配置滑动窗口的大小。                                         |
    | minimumNumberOfCalls                         | 100                                                          | 断路器计算失败率或慢调用率之前所需的最小调用数（每个滑动窗口周期）。例如，如果 minimumNumberOfCalls 为 10，则必须至少记录 10 个调用，然后才能计算失败率。如果只记录了 9 次调用，即使所有 9 次调用都失败，断路器也不会开启。 |
    | waitDurationInOpenState                      | 60000[ms]                                                    | 断路器从开启过渡到半开应等待的时间。                         |
    | automaticTransitionFromOpenToHalfOpenEnabled | false                                                        | 如果设置为 true，则意味着断路器将自动从开启状态过渡到半开状态，并且不需要调用来触发转换。创建一个线程来监视断路器的所有实例，以便在 WaitDurationInOpenstate 之后将它们转换为半开状态。但是，如果设置为 false，则只有在发出调用时才会转换到半开，即使在 waitDurationInOpenState 之后也是如此。这里的优点是没有线程监视所有断路器的状态。 |
    | recordExceptions                             | empty                                                        | 指定认为失败的异常列表。除非通过 ignoreException 显式忽略，否则与列表中某个匹配或继承的异常都将被视为失败。如果指定异常列表，则所有其他异常均视为成功，除非它们被 ignoreExceptions 显式忽略。 |
    | ignoreExceptions                             | empty                                                        | 被忽略且既不算失败也不算成功的异常列表。任何与列表之一匹配或继承的异常都不会被视为失败或成功，即使异常是 recordExceptions 的一部分 |
    | recordException                              | throwable -> true<br />By default all exceptions are recorded as failures | 一个自定义断言，用于评估异常是否应记录为失败。如果异常应计为失败，则断言必须返回 true。如果出断言返回 false，应算作成功，除非 ignoreExceptions 显式忽略异常 |
    | ignoreException                              | throwable -> false<br />By default no exceptions is ignored  | 自定义断言来判断一个异常是否应该被忽略异常，则谓词必须返回 true。如果异常应算作失败，则断言必须返回 false |

  - 默认 CircuitBreaker.java 配置类

    - io.github.resilience4j.circuitbreaker.CircuitBreakerConfig

  - 中文手册精简版

    - | 配置                                         | 解释                                                         |
      | -------------------------------------------- | ------------------------------------------------------------ |
      | failure-rate-threshold                       | 以百分比配置失败率峰值                                       |
      | sliding-window-type                          | 断路器的滑动窗口期类型<br />可以基于“次数”（COUNT_BASED）或者“时间”（TIME_BASED）进行熔断。默认是 COUNT_BASED |
      | sliding-window-size                          | 若 COUNT_BASED，则 10 次调用中有 50% 失败（即 5 次）打开熔断断路器；<br />若为 TIME_BASED 则，此时还有额外的两个设置属性，含义为：在 N 秒内（sliding-window-size）100%（slow-call-rate-threshold）的请求超过 N 秒（slow-call-duration-threshold）打开断路器 |
      | slowCallRateThreshold                        | 以百分比的方式配置，断路器把调用时间大于 slowCallDurationThreshold 的调用视为慢调用，当慢调用比例大于等于峰值时，断路器开启，并进入服务降级。 |
      | slowCallDurationThreshold                    | 配置调用时间的峰值，高于该峰值的视为慢调用。                 |
      | permitted-number-of-calls-in-half-open-state | 运行断路器在 HALF_OPEN 状态下时进行 N 次调用，如果故障或慢速调用仍然高于阈值，断路器再次进入打开状态。 |
      | minimum-number-of-calls                      | 在每个滑动窗口期样本数，配置断路器计算错误率或者慢调用率的最小调用数。比如设置为 5 意味着，在计算故障率之前，必须至少调用 5 次。如果只记录了 4 次，即使 4 次都失败了，断路器也不会进入到打开状态。 |
      | wait-duration-in-open-state                  | 从 OPEN 到 HALF_OPEN 状态需要等待的时间                      |

# P49 Resilience4j 之需求分析说明和闲聊大厂面试

熔断 + 降级案例需求说明

- 6 次访问中当执行方法的失败率达到 50% 时 CircuitBreaker 将进入开启 OPEN 状态（保险丝跳闸断电）拒绝所有请求。
- 等待 5 秒后，CircuitBreaker 将自动从开启 OPEN 状态过渡到半开 HALF_OPEN 状态，允许一些请求通过以测试服务是否恢复正常
- 如还是异常 CircuitBreaker 将重新进入开启 OPEN 状态；如正常将进入关闭 CLOSE 闭合状态恢复正常处理请求。
- 具体时间和频次等属性见具体实际案例，这里只是作为 case 举例讲解，最下面笔记面试题概览，闲聊大厂面试

# P50 Resilience4j 之熔断降级 COUNT_BASED 案例实战

干，按照 COUNT_BASED（计数的滑动窗口）

- 修改 cloud-provider-payment8001

  - 新建 PayCircuitController

    - ```java
      @RestController
      public class PayCircuitController {
          @GetMapping(value = "/pay/circuit/{id}")
          public String myCircuit(@PathVariable("id") Integer id) {
              if (id == -4) throw new RuntimeException("----circuit id 不能负数");
              if (id == 9999) {
                  try {
                      TimeUnit.SECONDS.sleep(5);
                  } catch (InterruptedException e) {
                      e.printStackTrace();
                  }
              }
              return "Hello, circuit! inputId: " + id + "\t " + IdUtil.simpleUUID();
          }
      }
      ```

- 修改 PayFaignApi 接口

  - ```java
    @GetMapping(value = "/pay/circuit/{id}")
    public String myCircuit(@PathVariable("id") Integer id);
    ```

- 修改 cloud-consumer-feign-order80

  - 改 POM

    - ```xml
      <!-- resilience4j-circuitbreaker -->
      <dependency>
          <groupId>org.springframework.cloud</groupId>
          <artifactId>spring-cloud-starter-circuitbreaker-resilience4j</artifactId>
      </dependency>
      <!-- 由于断路保护等需要 AOP 实现，所以必须导入 AOP 包 -->
      <dependency>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter-aop</artifactId>
      </dependency>
      ```

  - 写 YML

    - ```yaml
      server:
        port: 80
      spring:
        application:
          name: cloud-consumer-openfeign-order
        cloud:
          consul:
            host: localhost
            port: 8500
            discovery:
              prefer-ip-address: true # 优先使用服务 ip 进行注册
              service-name: ${spring.application.name}
          openfeign:
            client:
              config:
                default:
                  connectTimeout: 20000
                  readTimeout: 20000
            httpclient:
              hc5:
                enabled: true
            compression:
              request:
                enabled: true
                min-request-size: 2048
                mime-types: text/xml,application/xml,application/json
              response:
                enabled: true
            # 开启 circuitbreaker 和分组激活 spring.cloud.openfeign.circuitbreaker.enabled
            circuitbreaker:
              enabled: true
              group:
                enabled: true # 没开分组永远不用分组的配置。精确优先，分组次之（开了分组），默认最后
      
      # feign 日志以什么级别监控哪个接口
      logging:
        level:
          com:
            atguigu:
              cloud:
                apis:
                  PayFeignApi: debug
      
      # Resilience4j CircuitBreaker 按照次数：COUNT_BASED 的例子
      resilience4j:
        circuitbreaker:
          configs:
            default:
              failureReteThreshold: 50 # 设置 50% 的调用失败时打开断路器，超过失败请求百分比 CircuitBreaker 变为 OPEN 状态
              slidingWindowType: COUNT_BASED # 滑动窗口的类型
              slidingWindowSize: 6 # 滑动窗口的大小 配置 COUNT_BASED 表示 6 个请求，配置 TIME_BASED 表示 6 秒
              minimumNumberOfCalls: 6 # 断路器计算失败率或慢调用率之前所需的最小样本（每个滑动窗口周期）。如果 minimumNumberOfCalls 为 10，则必须最少记录 10 个样本，然后才能计算失败率。如果只记录了 9 次调用，即使所有 9 次调用都失败，断路器也不会开启。
              automaticTransitionFromOpenToHalfOpenEnabled: true # 是否启用自动从开启状态过渡到半开状态，默认值为 true，如果启用，CircuitBreaker 将自动从开启状态过渡到半开状态，并允许一些请求通过以测试服务是否恢复正常
              waitDurationInOpenState: 5s # 从 OPEN 到 HALF_OPEN 状态需要等待的时间
              permittedNumberOfCallsInHalfOpenState: 2 # 半开状态允许的最大请求数，默认值为 10。在半开状态下，CircuitBreaker 将允许最多 permittedNumberOfCallsInHalfOpenState 个请求通过，如果其中有任何一个请求失败，CircuitBreaker 将重新进入开启状态。
              recordExceptions:
                - java.lang.Exception
          instances:
            cloud-payment-service:
              baseConfig: default
      ```

  - 新建 OrderCircuitController

    - ```java
      @RestController
      public class OrderCircuitController {
          @Resource
          private PayFeignApi payFeignApi;
          
          @GetMapping(value = "/feign/pay/circuit/{id}")
          @CircuitBreaker(name = "cloud-payment-service", fallbackMethod = "myCircuitFallback")
          public String myCircuitBreaker(@PathVariable("id") Integer id) {
              return payFeignApi.myCircuit(id);
          }
          
          // myCircuitFallback 就是服务降级后的兜底处理方法
          public String myCircuitFallback(Throwable t) {
              return "myCircuitFallback, 系统繁忙，请稍后再试----/(ToT)/~~"
          }
      }
      ```

    - @CircuitBreaker

    - 系统繁忙，请稍后再试。

      不让调用者等待并立刻返回一个友好提示，fallback

- 测试（按照错误次数达到多少后开启断路）

  - 自测 cloud-consumer-feign-order80
  - 查看 YML
  - 正确
  - 错误
  - 一次 error 一次 OK，试试看
    - 50% 错误后触发熔断并给出服务降级，告知调用者服务不可用
    - 此时就算是输入正确的访问地址也无法调用服务（我明明是正确的也不让用），它还在断路中（OPEN 状态），一会儿过度到半开并继续正确地址访问，慢慢切换回 CLOSE 状态，可以正常访问了链路回复
  - 多次故意填写错误值（-4）

# P51 Resilience4j 之默认配置 CircuitBreakerConfig 说明

# P52 Resilience4j 之熔断降级 TIME_BASED 案例实战

干，按照 TIME_BASED（时间的滑动窗口）

- 基于时间的滑动窗口

  - 基于时间的滑动窗口是通过有 N 个桶的环形数组实现
  - 如果滑动窗口的大小为 10 秒，这个环形数组总是有 10 个桶，每个桶统计了在这一秒产生的所有调用的结果（部分统计结果），数组中的第一个桶存储了当前这一秒内的所有调用的结果，其他的桶存储了之前每秒调用的结果。
  - 滑动窗口不会单独存储所有的调用结果，而是对每个桶内的统计结果和总的统计值进行增量的更新，当新的调用结果被记录时，总的统计值会进行增量更新。
  - 检索快照（总的统计值）的时间复杂度为 O(1)，因为快照已经预先统计好了，并且和滑动窗口大小无关。
  - 关于此方法实现的空间需求（内存消耗）约等于 O(n)。由于每次调用结果（元组）不会被单独存储，只是对 N 个桶进行单独统计的一次总分的统计。
  - 每个桶在进行部分统计时存在三个整型，为了计算失败调用数，慢调用数，总调用数。还有一个 long 类型变量，存储所有调用的响应时间。

- 修改 cloud-consumer-feign-order80

  - 写 YML

    - ```yaml
      # Resilience4j CircuitBreaker 按照时间：TIME_BASED 的例子
      resilience4j:
        timelimiter:
          configs:
            default:
              timeout-duration: 10s # 深坑的位置，timeLimiter 默认限制远程 1s，超过 1s 就超时异常，配置了降级，就走降级逻辑
        circuitbreaker:
          configs:
            default:
              failureReteThreshold: 50 # 设置 50% 的调用失败时打开断路器，超过失败请求百分比 CircuitBreaker 变为 OPEN 状态
              slowCallDurationThreshold: 2s # 慢调用时间阈值，高于这个阈值的视为慢调用并增加慢调用比例。
              slowCallRateThreshold: 30 # 慢调用百分比峰值，断路器把调用时间多于 slowCallDurationThreshold，视为慢调用，当慢调用比例高于阈值，断路器打开，并开启服务降级
              slidingWindowType: TIME_BASED # 滑动窗口的类型
              slidingWindowSize: 2 # 滑动窗口的大小配置，配置 TIME_BASED 表示 2 秒
              minimumNumberOfCalls: 2 # 断路器计算失败率或慢调用率之前所需的最小样本（每个滑动窗口周期）。
              permittedNumberOfCallsInHalfOpenState: 2 # 半开状态允许的最大请求数，默认值为 10。
              waitDurationInOpenState: 5s # 从 OPEN 到 HALF_OPEN 状态需要等待的时间
              recordExceptions:
                - java.lang.Exception
          instances:
            cloud-payment-service:
              baseConfig: default
      ```

- 为避免影响实验效果，记得关闭 FeignConfig 自己写的重试 3 次

- 测试（慢查询）

  - 一次超时，一次正常访问，同时进行
    - 故意超时，将会单独报错
    - 可以访问，我是正常的
  - 第 1 ~ 4 次超时，整多一点干 4 个，一次正常访问，同时进行
    - 正常访问也受到了牵连，因为服务熔断不能访问了
    - 运气好的话，可以看到全线崩，刺激。

小总结

- 断路器开启或者关闭的条件
  - 当满足一定的峰值和失败率达到一定条件后，断路器将会进入 OPEN 状态（保险丝跳闸），服务熔断
  - 当 OPEN 的时候，所有请求都不会调用主业务逻辑方法，而是直接走 fallbackmethod 兜底背锅方法，服务降级
  - 一段时间后，这个时候断路器会从 OPEN 进入到 HALF_OPEN 半开状态，会放几个请求过去探探链路是否通？如成功，断路器会关闭 CLOSE（类似保险丝闭合，恢复可用）；如失败，继续开启。重复上述
- 个人建议不要混合用，推荐按照调用次数 count_based，一家之言仅供参考

# P53 Resilience4j 之 BulkHead 舱壁隔板简介

隔离（BulkHead）

- 官网

  - 中文

- 是什么

  - bulkhead（船的）舱壁/（飞机的）隔板

    隔板来自造船行业，船舱内部一般会分成很多小隔舱，一旦一个隔舱漏水因为隔板的存在而不至于影响其它隔舱和整体船。

- 能干嘛

  - **依赖隔离 & 负载保护**：用来限制对于下游服务的最大并发数量的限制

- Resilience4j 提供了如下两种隔离的实现方式，可以限制并发执行

- 实现 SemaphoreBulkhead（信号量舱壁）

- 实现 FixedThreadPoolBulkhead（固定线程池舱壁）

# P54 Resilience4j 之 SemaphoreBulkhead（信号量舱壁）

实现 SemaphoreBulkhead（信号量舱壁）

- 概述

  - 基本上就是我们 JUC 信号量内容的同样思想（java.util.concurrent.Semaphore）

  - 信号量舱壁（SemaphoreBulkhead）原理

    当信号量有空闲时，进入系统的请求会直接获取信号量并开始业务处理。

    当信号量全被占用时，接下来的请求将会进入阻塞状态，SemaphoreBulkhead 提供了一个阻塞计时器。

    如果阻塞状态的请求在阻塞计时内无法获取到信号量则系统会拒绝这些请求。

    若请求在阻塞计时内获取到了信号量，那将直接获取信号量并执行相应的业务处理。

- 源码分析

  - io.github.resilience4j.bulkhead.internal.SemaphoreBulkhead

- cloud-provider-payment8001 支付微服务

  修改 PayCircuitController

  - ```java
    @GetMapping(value = "/pay/bulkhead/{id}")
    public String myBulkhead(@PathVariable("id") Integer id) {
        if (id == -4) throw new RuntimeException("----bulkhead id 不能负数");
        if (id == 9999) {
            try {
                TimeUnit.SECONDS.sleep(5);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        return "Hello, bulkhead! inputId: " + id + "\t " + IdUtil.simpleUUID();
    }
    ```

- PayFeignApi 接口新增舱壁 api 方法

  - ```java
    @GetMapping(value = "/pay/bulkhead/{id}")
    public String myBulkhead(@PathVariable("id") Integer id);
    ```

- 修改 cloud-consumer-feign-order80

  - POM

    - ```xml
      <!-- resilience-bulkhead -->
      <dependency>
          <groupId>io.github.resilience4j</groupId>
          <artifactId>resilience4j-bulkhead</artifactId>
      </dependency>
      ```

  - YML

    - 示例

      - | 属性配置           | 默认值 | 含义                                       |
        | ------------------ | ------ | ------------------------------------------ |
        | maxConrurrentCalls | 25     | 舱壁允许的最大并行执行量                   |
        | maxWaitDuration    | 0      | 尝试进入饱和舱壁时，应阻塞线程的最长时间。 |

      - 示例（使用 yml）：

        ```yaml
        resilience4j:
          bulkhead:
            configs:
              default:
                maxConcurrentCalls: 5
                maxWaitDuration: 20ms
            instances:
              backendA:
                baseConfig: default
              backendB:
                maxWaitDuration: 10ms
                maxConcurrentCells: 20
        ```

    - 内容

      - ```yaml
        resilience4j:
          bulkhead:
            configs:
              default:
                maxConcurrentCalls: 2 # 隔离允许并发线程执行的最大数量
                maxWaitDuration: 1s # 当达到并发调用数量时，新的线程的阻塞时间，我只愿意等待 1 秒，过时不候进舱壁兜底 fallback
            instances:
              cloud-payment-service:
                baseConfig: default
          timelimiter:
            configs:
              default:
                timeout-duration: 20s
        ```

  - 业务类

    - OrderCircuitController

      - ```java
        @GetMapping(value = "/feign/pay/bulkhead/{id}")
        @Bulkhead(name = "cloud-payment-service", fallbackMethod = "myBulkheadFallback", type = Bulkhead.Type.SEMAPHORE)
        public String myBulkhead(@PathVariable("id") Integer id) {
            return payFeignApi.myBulkhead(id);
        }
        
        public String myBulkheadFallback(Throwable t) {
            return "myBulkheadFallback, 隔板超出最大数量限制，系统繁忙，请稍后再试----/(ToT)/~~"
        }
        ```

      - @Bulkhead

      - Bulkhead.Type.SEMAPHORE

- 测试

  - 步骤
    - 浏览器新打开 2 个窗口，各点一次，分别点击 http://localhost/feign/pay/bulkhead/9999
    - 每个请求调用需要耗时 5 秒，2 个线程瞬间达到配置过的最大并发数 2
    - 此时第 3 个请求**正常的**请求访问，http://localhost/feign/pay/bulkhead/3
    - 直接被舱壁限制隔离了，碰不到 8001
    - **等其中一个窗口停止了，再去正常访问，并发数小于 2 了，可以 OK**
  - 结果
    - 1、2 号请求要占用 5 秒，第 3 个请求按照配置只愿意等待 1 秒钟，隔离成功
    - 可以看到因为本案例并发线程数为 2（maxConcurrentCalls: 2），只让 2 个线程进入执行，其他请求将直接降级。

# P55 Resilience4j 之 FixedThreadPoolBulkhead（固定线程池舱壁）

实现 FixedThreadPoolBulkhead（固定线程池舱壁）

- 概述

  - 基本上就是我们 JUC-线程池内容的同样思想（java.util.concurrent.ThreadPoolExecutor）

  - 固定线程池舱壁（FixedThreadPoolBulkhead）

    FixedThreadPoolBulkhead 的功能与 SemaphoreBulkhead 一样也是**用于限制并发执行的次数**的，但是二者的实现原理存在差别而且表现效果也存在细微的差别。FixedThreadPoolBulkhead 使用**一个固定线程池和一个等待队列**来实现舱壁。

    当线程池中存在空闲时，则此时进入系统的请求将直接进入线程池开启新线程或使用空闲线程来处理请求。

    当线程池中无空闲时，接下来的请求将进入等待队列，若等待队列仍然无剩余空间时接下来的请求将直接被拒绝。在队列中的请求等待线程池出现空闲时，将进入线程池进行业务处理。

    另外：ThreadPoolBulkhead 只对 CompletableFuture 方法有效，所以我们必创建返回 CompletableFuture 类型的方法

- 源码分析

  - io.github.resilience4j.bulkhead.internal.FixedThreadPoolBulkhead
  - 底子就是 JUC 里面的线程池 ThreadPoolExecutor
  - submit 进线程池返回 `CompletableFuture<T>`

- 修改 cloud-consumer-feign-order80

  - POM

    - ```xml
      <!-- resilience-bulkhead -->
      <dependency>
          <groupId>io.github.resilience4j</groupId>
          <artifactId>resilience4j-bulkhead</artifactId>
      </dependency>
      ```

  - YML

    - 示例

      - **实现 FixedThreadPoolBulkhead（固定线程池舱壁）**

        FixedThreadPoolBulkhead 的配置项如下：

        | 配置名称           | 默认值                                         | 含义                                                         |
        | ------------------ | ---------------------------------------------- | ------------------------------------------------------------ |
        | maxThreadPoolSize  | Runtime.getRuntime().availableProcessors()     | 配置最大线程池大小                                           |
        | coreThreadPoolSize | Runtime.getRuntime().availableProcessors() - 1 | 配置核心线程池大小                                           |
        | queueCapacity      | 100                                            | 配置队列的容量                                               |
        | keepAliveDuration  | 20ms                                           | 当线程数大于核心时，这是多余空闲线程在终止前等待新任务的最长时间 |

      - 示例（使用 yml）：

        ```yaml
        resilience4j:
          thread-pool-bulkhead:
            configs:
              default:
                maxThreadPoolSize: 4
                coreThreadPoolSize: 2
                queueCapacity: 2
            instances:
              backendA:
                baseConfig: default
              backendB:
                maxThreadPoolSize: 1
                coreThreadPoolSize: 1
                queueCapacity: 1
        ```

        如上，我们定义了一段简单的 FixedThreadPoolBulkhead 配置，我们指定的默认配置为：`maxThreadPoolSize: 4, coreThreadPoolSize: 2, queueCapacity: 2`，并且指定了两个实例，其中 backendA 使用了默认配置而 backendB 使用了自定义的配置。

    - 内容

      - ```yaml
        resilience4j:
          thread-pool-bulkhead:
            configs:
              default:
                maxThreadPoolSize: 1
                coreThreadPoolSize: 1
                queueCapacity: 1
            instances:
              cloud-payment-service:
                baseConfig: default
        ```

    - 上述内容解释

  - controller

    - Bulkhead.Type.THREADPOOL

- 测试地址

