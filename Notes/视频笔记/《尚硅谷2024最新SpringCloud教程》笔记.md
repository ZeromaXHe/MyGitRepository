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

# P56 Resilience4j 之 RateLimiter 和常见限流算法

限流（RateLimiter）

- 官网

  - 中文

- 是什么

  - 限流（频率控制）
    - 限流 就是限制最大访问流量。系统能提供的最大并发是有限的，同时来的请求又太多，就需要限流。
    - 比如商城秒杀业务，瞬时大量请求涌入，服务器忙不过就只好排队限流了。
    - 所谓限流 ，就是通过对并发访问/请求进行限速，或者对一个时间窗口内的请求进行限速，以保护应用系统，一旦达到限制速率则可以拒绝服务、排队或等待、降级等处理

- 面试题：说说常见限流算法

  1. 漏斗算法（Leaky Bucket）
     - 一个固定容量的漏桶，按照设定常量固定速率流出水滴，类似医院打吊针，不管你源头流量多大，我设定匀速流出。如果流入水滴超出了桶的容量，则流入的水滴将会溢出了（被丢弃），而漏桶容量是不变的。
     - 缺点
       - 这里有两个变量，一个是桶的大小，支持流量突发增多时可以存多少的水（burst），另一个是水桶漏洞的大小（rate）。因为漏桶的漏出速率是固定的参数，所以，即使网络中不存在资源冲突（没有发生拥塞），漏桶算法也不能使流突发（burst）到端口速率。**因此，漏桶算法对于存在突发特性的流量来说缺乏效率。**
  2. 令牌桶算法（Token Bucket）
     - SpringCloud 默认使用该算法
     - 匀速添加一个令牌，每执行一个请求则从桶中丢弃一个令牌
  3. 滚动时间窗口（tumbling time window）
     - 允许固定数量的请求进入（比如 1 秒取 4 个数据相加，超过 25 值就 over）超过数量就拒绝或者排队，等下一个时间段进入。
     - 由于是在一个时间间隔内进行限制，如果用户在上一个时间间隔结束前请求（但没有超过限制），同时在当前时间间隔刚开始请求（同样没超过限制），在各自的时间间隔内，这些请求都是正常的。下图统计了 3 次，but……
     - 缺点：间隔临界的一段时间内的请求就会超过系统限制，可能导致系统被压垮
       - 假如设定 1 分钟最多可以请求 100 次某个接口，如 12:00:00-12:00:59 时间段内没有数据请求，但 12:00:59 ~ 12:01:00 时间段内突然并发 100 次请求，紧接着瞬间跨入下一个计数周期计数器清零；在 12:01:00 ~ 12:01:01 内又有 100 次请求。那么就是说在时间临界点左右可能同时有 2 倍的峰值进行请求，从而造成后台处理请求加倍负载的 bug，导致系统运营能力不足，甚至导致系统崩溃
     - double kill
  4. 滑动时间窗口（sliding time window）
     - 顾名思义，该时间窗口是滑动的。所以，从概念上讲，这里有两个方面的概念需要理解：
       - 窗口：需要定义窗口的大小
       - 滑动：需要定义在窗口中滑动的大小。但理论上讲滑动的大小不能超过窗口大小
     - 滑动窗口算法是把固定时间片进行划分并且随着时间移动，移动方式为开始时间点变为时间列表中的第 2 个时间点，结束时间点增加一个时间点，不断重复 ，通过这种方式可以巧妙的避开计数器的临界点的问题。

- cloud-provider-payment8001 支付微服务

  修改 PayCircuitController 新增 myRatelimit 方法

- PayFeignApi 接口新增限流 api 方法

- 修改 cloud-consumer-feign-order80

- 测试

# P57 Resilience4j 之 RateLimiter 案例实战演示

cloud-provider-payment8001 支付微服务

修改 PayCircuitController 新增 myRatelimit 方法

- ```java
  @GetMapping(value = "/pay/ratelimit/{id}")
  public String myRatelimit(@PathVariable("id") Integer id) {
      return "Hello, ratelimit! inputId: " + id + "\t " + IdUtil.simpleUUID();
  }
  ```

PayFeignApi 接口新增限流 api 方法

- ```java
  @GetMapping(value = "/pay/ratelimit/{id}")
  public String myRatelimit(@PathVariable("id") Integer id);
  ```

修改 cloud-consumer-feign-order80

- POM

  - ```xml
    <!-- resilience4j-ratelimiter -->
    <dependency>
        <groupId>io.github.resilience4j</groupId>
        <artifactId>resilience4j-ratelimiter</artifactId>
    </dependency>
    ```

- YML

  - ```yaml
    # resilience4j ratelimiter 限流的例子
    resilience4j:
      ratelimiter:
        configs:
          default:
            limitForPeriod: 2 # 在一次刷新周期内，允许执行的最大请求数
            limitRefreshPeriod: 1s # 限流器每隔 limitRefreshPeriod 刷新一次，将允许处理的最大请求数量重置为 limitForPeriod
            timeout-duration: 1 # 线程等待权限的默认等待时间
        instances:
          cloud-payment-service:
            baseConfig: default
    ```

- order 的 controller

  - @RateLimiter

  - ```java
    @GetMapping(value = "/feign/pay/ratelimit/{id}")
    @RateLimiter(name = "cloud-payment-service", fallbackMethod = "myRatelimitFallback")
    public String myRatelimit(@PathVariable("id") Integer id) {
        return payFeignApi.myRatelimit(id);
    }
    
    public String myRatelimitFallback(Interger id, Throwable t) {
        return "你被限流了，禁止访问----/(ToT)/~~"
    }
    ```

测试

- 结果
  - 刷新上述地址，正常后 F5 按钮狂刷一会儿，停止刷新看到被限流的效果

# P58 Micrometer 之分布式链路追踪概述

8、Sleuth（Micrometer）+ ZipKin 分布式链路追踪

- Sleuth 目前也进入维护模式

  - Sleuth 官宣，改头换面
  - Sleuth 未来替换方案
    - Micrometer Tracing

- 分布式链路追踪概述

  - 为什么会出现这个技术？

    需要解决哪些问题？

    - 问题
      - 在微服务框架中，一个由客户端发起的请求在后端系统中会经过多个不同的服务节点调用来协同产生最后的请求结果，每一个前段请求都会形成一条复杂的分布式服务调用链路，链路中的任何一环出现高延时或错误都会引起整个请求最后的失败。

  - 随着问题的复杂化 + 微服务的增多 + 调用链条的变长

    画面不要太美丽

  - 在分布式与微服务场景下需要解决的问题

    - 如何实时观测系统的整体调用链路情况

    - 如何快速发现并定位问题

    - 如何尽可能精确的判断故障对系统的影响范围与影响程度

    - 如何尽可能精确的梳理出服务之间的依赖关系，并判断出服务之间的依赖关系是否合理

    - 如何尽可能精确的分析整个系统调用链路的性能与瓶颈点

    - 如何尽可能精确的分析系统的存储瓶颈与容量规划

    - 上述问题就是我们的落地议题答案：

      分布式链路追踪技术要解决的问题，分布式链路追踪（Dustributed Tracing），就是将一次分布式请求还原成调用链路，进行日志记录，性能监控并将一次分布式请求的调用情况集中展示。比如各个服务节点上的耗时、请求具体到达哪台机器上、每个服务节点的请求状态等等。

- 新一代 Spring Cloud Sleuth：Micrometer

- 分布式链路追踪原理

- Zipkin

- Micrometer + ZipKin 搭建链路监控案例步骤

# P59 Micrometer 之 Micrometer 和 zipkin 各自分工

新一代 Spring Cloud Sleuth：Micrometer

- （官网重要提示）

  - 新一代 Sleuth
    - sleuth 被 micrometer 替代
  - 官网
  - 说明
    - 老项目还能用 Sleuth 开发吗
    - 版本注意
      - 不支持 Spring Boot 3.x

- zipkin 呢？

  - Spring Cloud Sleuth(micrometer) 提供了一套完整的**分布式链路追踪（Distributed Tracing）**解决方案且兼容支持了 zipkin 展现

- 小总结

  - 将一次分布式请求还原成调用链路，进行日志记录和性能监控，并将一次分布式请求的调用情况集中 web 展示

- 行业内比较成熟的其他分布式链路追踪技术解决方案

  - | 技术       | 说明                                                         |
    | ---------- | ------------------------------------------------------------ |
    | Cat        | 由大众点评开源，基于 Java 开发的实时应用监控平台，包括实时应用监控、业务监控。集成方案是通过代码埋点的方式来实现监控，比如：拦截器，过滤器等。对代码的侵入性很大，集成成本较高。风险较大。 |
    | ZipKin     | 由 Twitter 公司开源，开放源代码分布式的跟踪系统，用于收集服务的定时数据，以解决微服务架构中的延迟问题，包括：数据的收集、存储、查找和展现。结合 spring-cloud-sleuth 使用较为简单，集成方便，但是功能较简单。 |
    | Pinpoint   | Pinpoint 是一款开源的基于字节码注入的调用链分析，以及应用监控分析工具。特点是支持多种插件，UI 功能强大，接入端无代码侵入 |
    | Skywalking | Skywalking 是国人开源的基于字节码注入的调用链分析，以及应用监控分析工具。特点是支持多种插件，UI 功能较强，接入端无代码侵入。 |

# P60 Micrometer 之分布式链路追踪原理

分布式链路追踪原理

- 假定 3 个微服务调用的链路：

  Service1 调用 Service2，Service2 调用 Service3 和 Service 4

  - 00:58

- 上一步完整的调用链路

  - 01:30

  - **那么一条链路追踪会在每个服务调用的时候加上 TraceID 和 SpanID**

    链路通过 TraceId 唯一标识，Span 标识发起的请求信息，各 span 通过 parent id 关联起来（Span：标识调用链路来源，通俗的理解 span 就是一次请求信息）

- 彻底把链路追踪整明白

  - 07:20

# P61 Micrometer 之 Zipkin 下载安装运行一套带走

Zipkin

- 官网

- 是什么

  - 00:46
  - Zipkin 是一种分布式链路跟踪系统**图形化工具**。Zipkin 是 Twitter 开源的分布式跟踪系统，能够收集微服务运行过程中的实时调用链路信息，并能够将**这些调用链路信息展示到 Web 图形化界面上**供开发人员分析，开发人员能够从 ZipKin 中分析出调用链路中的性能瓶颈，识别出存在问题的应用程序，进而定位问题和解决问题。

- Zipkin 为什么出现？

  - 单有 Sleuth（Micrometer）行不行？

    - 01:27

    - 说明：

      当没有配置 Sleuth 链路追踪的时候，INFO 信息里面是 [passjava-question,,,]，后面跟着三个空字符串。

      当配置了  Sleuth 链路追踪的时候，追踪到的信息是 [passjava-question,504a5360ca906016,e55ff064b3941956,false]，第一个是 Trace ID，第二个是 Span ID。**只有日志没有图，观看不方便，不美观，so，**引入图形化 Zipkin 链路监控让你好看。

- 下载 + 安装 + 运行一套带走

  - 下载主页
    - 支持 3 个方式
  - 下载地址
    - 03:47
  - 运行 jar
  - 运行控制台

# P62 Micrometer 之监控链路案例整合实战

Micrometer + ZipKin 搭建链路监控案例步骤

- Micrometer + ZipKin 两者各自的分工
  - Micrometer
    - 数据采样
  - ZipKin
    - 图形展示
- 步骤
  - 总体父工程 POM
    - 本案例
      - 01:16
      - 引入的 jar 包分别是什么意思
        - 02:51
    - all
      - 04:44
  - 服务提供者 8001
    - cloud-provider-payment8001
    - POM
      - 06:37
    - YML
      - 07:31
    - 新建业务类 PayMicrometerController
      - 09:00
  - Api 接口 PayFeignApi
    - 09:38
  - 服务调用者 80
    - cloud-consumer-feign-order80
    - POM
      - 10:11
      - All
        - 10:44
    - YML
      - 11:00
    - 新建业务类 OrderMicrometerController
      - 11:40
- 测试
  - 本次案例，默认已经成功启动 ZipKin
  - 依次启动 8001/80 两个微服务并注册进入 Consul
  - 测试地址
  - 打开浏览器访问：http://localhost:9411

# P63 GateWay 之网关微服务定位和理论概述

9、Gateway 新一代网关

- 概述
  - 是什么
    - 官网
      - 01:19
      - Gateway 是在 Spring 生态系统之上构建的 API 网关服务，基于 Spring 6，Spring Boot 3 和 Project Reactor 等技术。它旨在为微服务架构提供一种简单有效的**统一的 API 路由管理方式**，并为它们提供跨领域的关注点，例如：安全性、监控/度量和恢复能力
    - 体系定位
      - 02:48
      - Cloud 全家桶中有个很重要的组件就是网关，在 1.x 版本中都是采用的 Zuul 网关；但在 2.x 版本中，Zuul 的升级一直跳票，Spring Cloud 最后自己研发了一个网关 Spring Cloud Gateway 替代 Zuul。
      - 一句话：gateway 是原 zuul 1.x 版的替代
  - 微服务架构中网关在哪里
    - 05:26
  - 能干嘛
    - 反向代理
    - 鉴权
    - 流量控制
    - 熔断
    - 日志监控
  - 总结
    - 07:28
    - Spring Cloud Gateway 组件的核心是一系列的过滤器，通过这些过滤器可以将客户端发送的请求转发（路由）到对应的微服务。
    - Spring Cloud Gateway 是加在整个微服务最前沿的防火墙和代理器，隐藏微服务节点 IP 端口信息，从而加强安全保护。Spring Cloud Gateway 本身也是一个微服务，需要注册进服务注册中心。
- Gateway 三大核心
- Gateway 工作流程
- 入门配置
- 9527 网关如何做路由映射
- GateWay 高级特性
- Gateway 整合阿里巴巴 Sentinel 实现容错

# P64 GateWay 之路由断言过滤器三大核心

Gateway 三大核心

- 总述官网
  - 00:35
- 分
  - Route（路由）
    - 路由是构建网关的基本模块，它由 ID，目标 URI，一系列的断言和过滤器组成，如果断言为 true 则匹配该路由
  - Predicate（断言）
    - 参考的是 Java8 的 java.util.function.Predicate。开发人员可以匹配 HTTP 请求中的所有内容（例如请求头或请求参数），如果请求与断言相匹配则进行路由
  - Filter（过滤）
    - 指的是 Spring 框架中 GatewayFilter 的实例，使用过滤器，可以在请求被路由前或之后对请求进行修改
- 总结
  - 04:20
  - web 前端请求，通过一些匹配条件，定位到真正的服务节点。并在这个转发过程的前后，进行一些精细化控制。predicate 就是我们的匹配条件；filter，就可以理解为一个无所不能的拦截器。有了这两个元素，再加上目标 uri，就可以实现一个具体的路由了。

# P65 GateWay 之网关工作流程

Gateway 工作流程

- 官网总结
  - 00:21
  - 客户端向 Spring Cloud Gateway 发出请求。然后在 Gateway Handler Mapping 中找到与请求相匹配的路由，将其发送到 Gateway Web Handler。Handler 再通过指定的过滤器链来将请求发送到我们实际的服务执行业务逻辑，然后返回。
  - 过滤器之间用虚线分开是因为过滤器可能会在发送代理请求之前（Pre）或之后（Post）执行业务逻辑。
  - 在“pre”类型的过滤器可以做参数校验、权限校验、流量监控、日志输出、协议转换等；
  - 在“post”类型的过滤器中可以响应内容、响应头的修改，日志的输出，流量监控等有着非常重要的作用。
- 核心逻辑
  - 路由转发 + 断言判断 + 执行过滤器链

# P66 GateWay 之网关搭建入门配置步骤

入门配置

- 建立 Module
  - cloud-gateway9527
- 改 POM（2:31）
- 写 YML（3:09）
- 主启动（3:27）
- 业务类
  - 无，不写任何业务代码，网关和业务无关
- 测试
  - 先启动 8500 服务中心 Consul
  - 再启动 9527 网关入驻

# P67 GateWay 之网关 9527 路由映射 8001-上

9527 网关如何做路由映射

- 9527 网关如何做路由映射那？？？
  - 诉求
    - 我们目前不想暴露 8001 端口，希望在 8001 真正的支付微服务外面套一层 9527 网关
  - 8001 新建 PayGateWayController（2:59）
  - 启动 8001 支付
  - 8001 自测通过
- 9527 网关 YML 新增配置（6:15）
- 测试1
  - 启动 Consul 8500 服务
  - 启动 8001 支付
  - 启动 9527 网关
  - 访问说明
    - 添加网关前
      - http://localhost:8001/pay/gateway/get/1
      - http://localhost:8001/pay/gateway/info
    - 隐真示假，映射说明（9:42）
    - 添加网关后
      - http://localhost:9527/pay/gateway/get/1
      - http://localhost:9527/pay/gateway/info
  - 目前 8001 支付微服务前面添加 GateWay 成功（10:38）
- 测试2
- 还有问题

# P68 GateWay 之网关 9527 路由映射 8001-下

测试2

- 启动订单微服务测试，看看是否通过网关？（0:23）
  1. 修改 cloud-api-commons
     - PayFeignApi 接口（0:59）
  2. 修改 cloud-consumer-feign-order80
     - 新建 OrderGateWayController（2:01）
  3. 网关开启
     - 测试通过
  4. 网关关闭
     - 测试通过
  5. 结论
     - **9527 网关是否启动，毫无影响**
     - 目前的配置来看，网关被绕开了……
- 正确做法
  - 同一家公司自己人，系统内环境，直接找微服务（5:30）
  - 不同家公司有外人，系统外访问，先找网关再服务（6:27）
    - 刷新 feign 接口 jar 包
    - 重启 80 订单微服务
    - 有网关正常 success（9:02）
    - 无网关异常（9:35）

还有问题

-  请看看网关 9527 的 yml 配置，映射写死问题（10：21）

# P69 GateWay 之按微服务名动态路由服务 URI

GateWay 高级特性

- Route 以微服务名-动态获取服务 URI
  - 痛点（1:14）
  - 是什么(1:47)
  - 解决 uri 地址写死问题
    - 9527 修改前 YML（2：51）
    - 9527 修改后 YML（2：56）
  - 测试1
    - 重启网关 9527，80/8001 保持不变
  - 测试2
    - 如果将 8001 微服务 yml 文件端口修改为 8007，照样访问我实际启动的程序是 main8001 但是端口名改为 8007
    - 我们依据微服务名字，匹配查找即可 `uri: lb://cloud-payment-service`
- Predicate 断言（谓词）
- Filter 过滤

# P70 GateWay 之 Predicate 源码架构分析

Predicate 断言（谓词）

- 是什么
  - Route Predicate Factories 这个是什么东东？（2：09）
- 启动微服务 gateway9527，看看 IDEA 后台的输出
- 整体架构概述（4：50）
- 常用的内置 Route Predicate
- 自定义断言，XXXRoutePredicateFactory 规则

# P71 GateWay 之 Predicate 两种配置 shortcuts 和 fully

常用的内置 Route Predicate

- 配置语法总体概述
  - 两种配置，二选一（1：18）
    - Most examples below use the shortcut way
  - 1 Shortcut Configuration（2：08）
  - 2 Fully Expanded Arguments（3:11）
- 测试地址
- 常用断言 api（4：16）
  1. After Route Predicate
  2. Before Route Predicate（家庭作业）
     - YML
  3. Between Route Predicate（家庭作业）
     - YML
  4. Cookie Route Predicate
  5. Header Route Predicate
  6. Host Route Predicate
  7. Path Route Predicate
  8. Query Route Predicate
  9. RemoteAddr Route Predicate
     - YML
  10. Method Route Predicate（家庭作业）
- 上述配置小总结

# P72 GateWay 之 Predicate 配置 01

1. After Route Predicate（3：37）
   - 如何获得 ZonedDateTime（3：56）
   - YML（6：25）
2. Before Route Predicate（家庭作业）
   - YML（6：55）
3. Between Route Predicate（家庭作业）
   - YML（7：01）

# P73 GateWay 之 Predicate 配置 02

4、Cookie Route Predicate（0：35）

- YML（1:09）
- 方法1，原生命令
  - 不带 cookies 访问（2：41）
  - 自带 cookies 访问（3：18）
- 方法2，postman（4：12）
- 方法3，chrome 浏览器（6：15）

# P74 GateWay 之 Predicate 配置 03

5、Header Route Predicate（00：43）

- YML（0：55）
- 方法1，原生命令（1:38）
- 方法2，postman（2:46）

6、Host Route Predicate（3：42）

- YML（4：13）
- 方法1，原生命令（5：14）
- 方法2，postman（7：00）

7、Path Route Predicate（7：39）

- YML（7：48）

# P75 GateWay 之 Predicate 配置 04

8、Query Route Predicate（0：10）

- YML（1：01）
- 测试（1：24）

9、RemoteAddr Route Predicate（2：09）

- YML（4：42）
- CIDR网路IP划分（无类别域间路由 Classless Inter-Domain Routing 缩写）（3：24）

10、Method Route Predicate（家庭作业）（6：59）

- 配置某个请求地址，只能用 Get/Post 方法访问，方法限制

上述配置小总结

- All

  - （8：17）

  - ```yaml
    server:
      port: 9527
    spring:
      application:
        name: cloud-gateway # 以微服务注册进 consul 或 nacos 服务列表内
      cloud:
        consul: # 配置consul地址
          host: localhost
          port: 8500
          discovery:
            prefer-ip-address: true
            service-name: ${spring.application.name}
        gateway:
          routes:
            - id: pay_route1 # 路由的 ID（类似 mysql 主键 ID），没有固定规则但要求唯一，建议配合服务名
              uri: lb://cloud-payment-service # 匹配后提供服务的路由地址
              predicates:
                - Path=/pay/gateway/get/** # 断言，路径相匹配的进行路由
                - After=2023-12-30T23:02:39.079979400+8:00[Asia/Shanghai]
                # - Cookie=username,zzyy
                # - Header=X-Request-Id, \d+ # 请求头要有 X-Request-Id 属性并且值为整数的正则表达式
                # - Query=username, \d+ # 要有参数名 username 并且值还要是整数才能路由
                - RemoteAddr=192.168.124.1/24 # 外部访问我的 IP 限制，最大跨度不超过 32，目前是 1~24 它们是 CIDR 表示法。
            - id: pay_route2 # 路由的 ID（类似 mysql 主键 ID），没有固定规则但要求唯一，建议配合服务名
              uri: lb://cloud-payment-service # 匹配后提供服务的路由地址
              predicates:
                - Path=/pay/gateway/info/** # 断言，路径相匹配的进行路由
    ```

- Predicate 就是为了实现一组匹配规则，让请求过来找到对应的 Route 进行处理

# P76 GateWay 之自定义 Predicate 需求说明

自定义断言，XXXRoutePredicateFactory 规则

- 痛点
  - 原有的断言配置不满足业务怎么办？
  - 看看 AfterRoutePredicateFactory（1：56）
  - 架构概述（2：32）
  - 模板套路
    - 要么继承 AbstractRoutePredicateFactory 抽象类
    - 要么实现 RoutePredicateFactory 接口
    - 开头任意取名，但是必须以 RoutePredicateFactory 后缀结尾
- 自定义路由断言规则步骤套路
  - 编写步骤
    1. 新建类名 XXX 需要以 RoutePredicateFactory 结尾，并继承 AbstractRoutePredicateFactory 类(4:30)
    2. 重写 apply 方法
    3. 新建 apply 方法所需要的静态内部类 MyRoutePredicateFactory.Config，这个 Config 类就是我们的路由断言规则，重要
    4. 空参构造方法，内部调用 super
    5. 重写 apply 方法第二版
  - 完整代码 V1
- 测试 1
- bug 分析
- 测试 2

# P77 GateWay 之自定义 Predicate 编码实战

1. 新建类名 XXX 需要以 RoutePredicateFactory 结尾，并继承 AbstractRoutePredicateFactory 类（1：55）
2. 重写 apply 方法（6：03）
3. 新建 apply 方法所需要的静态内部类 MyRoutePredicateFactory.Config，这个 Config 类就是我们的路由断言规则，重要（4：43）
4. 空参构造方法，内部调用 super（5：50）
5. 重写 apply 方法第二版（8：57）

完整代码 V1（9：18）

```java
@Component
public class MyRoutePredicateFactory extends AbstractRoutePredicateFactory<MyRoutePredicateFactory.Config> {
    public MyRoutePredicateFactory() {
        super(MyRoutePredicateFactory.Config.class);
    }
    
    @Validated
    public static class Config {
        @Setter
        @Getter
        @NotEmpty
        private String userType; // 钻、金、银等用户等级
    }
    
    @Override
    public Predicate<ServerWebExchange> apply(MyRoutePredicateFactory.Config config) {
        return new Predicate<ServerWebExchange>() {
            @Override
            public boolean test(ServerWebExchange serverWebExchange) {
                // 检查 request 的参数里面，userType 是否为指定的值，符合配置就通过
                String userType = serverWebExchange.getRequest().getQueryParams().getFirst("userType");
                if (userType == null) return false;
                // 如果参数存在，就和 config 的数据进行比较
                if (userType.equals(config.getUserType())) {
                    return true;
                }
                return false;
            }
        }
    }
}
```

# P78 GateWay 之自定义 Predicate 功能测试和支持 shortcut

- 测试 1
  - YML（0：52）
  - 启动后？？？
    - 故障现象（2：58）
    - 导致原因
      - 为什么 Shortcut Configuration 不生效？（3：21）
    - 解决方案
      - 先解决问题，让我们自定义的能用
      - Fully Expanded Arguments
        - YML(4:07)
      - success（5：28）
- bug 分析
  - 缺少 shortcutFieldOrder 方法的实现，所以不支持短格式（6：34）
- 测试 2
  - 完整代码 02（6：45）
  - YML（6：48）
  - 重启 9527 并测试

# P79 GateWay 之 Filter 理论知识

Filter 过滤

- 概述
  - 官网
  - 一句话
    - **Spring MVC 里面的拦截器 Interceptor，Servlet 的过滤器**
    - “pre” 和 “post” 分别会在请求被执行前调用和被执行后调用，用来修改请求和响应信息（1：41）
  - 能干嘛
    - 请求鉴权
    - 异常处理
    - 记录接口调用时长统计，重点，大厂面试设计题
    - ……
  - 类型
    1. 全局默认过滤器 Global Filters
       - gateway 出厂默认已有的，直接用即可，主要作用于所有的路由
       - 不需要在配置文件中配置，作用在所有的路由上，实现 GlobalFilter 接口即可
    2. 单一内置过滤器 GatewayFilter
       - 也可以称为网关过滤器，这种过滤器主要是作用于单一路由或者某个路由分组
    3. 自定义过滤器
- GateWay 内置的过滤器
- GateWay 自定义过滤器

# P80 GateWay 之 Filter 配置 01

GateWay 内置的过滤器

- 是什么
  - 官网
  - 单一内置过滤器 GatewayFilter
- 只讲解常见和通用的，Not All
- 常用的内置过滤器
  1. 请求头（RequestHeader）相关组
     - 6.1 The AddRequestHeader GatewayFilter Factory
       - 指定请求头内容 ByName
       - 8001 微服务 PayGateWayController 新增方法（4：40）
       - 9527 网关 YML 添加过滤内容（7：11）
       - 重启 9527 和 8001 并再次调用地址
     - 6.18 The RemoveRequestHeader GatewayFilter Factory
     - 6.29 The SetRequestHeader GatewayFilter Factory
  2. 请求参数（RequestParameter）相关组
  3. 回应头（ResponseHeader）相关组
  4. 前缀和路径相关组
  5. 其它

# P81 GateWay 之 Filter 配置 02

6.18 The RemoveRequestHeader GatewayFilter Factory

- 删除请求头 ByName
- 修改前（0:43）
- YML（1:37）
- 重启 9527 和 8001 并再次调用地址
- 修改后

6.29 The SetRequestHeader GatewayFilter Factory

- 修改请求头 ByName
- 修改前（sec-fetch-mode）（3：18）
- YML（3：30）
- 重启 9527 和 8001 并再次调用地址
- 修改后

# P82 GateWay 之 Filter 配置 03

2、请求参数（RequestParameter）相关组

- 6.3 The AddRequestParameter GatewayFilter Factory
- 6.19 The RemoveRequestParameter GatewayFilter Factory
- 上述两个合一块
  - YML（0:45）
  - 修改 PayGateWayController（1：22）
  - 测试

# P83 GateWay 之 Filter 配置 04

3、回应头（ResponseHeader）相关组

- 开启配置前，按照地址 chrome 查看一下（0：30）
- 6.4 The AddResponseHeader GatewayFilter Factory
  - YML（1：15）
- 6.30 The SetResponseHeader GatewayFilter Factory
  - YML（1：49）
- 6.20 The RemoveResponseHeader GatewayFilter Factory
  - YML（2:20）
- 开启配置后，上面三个配置打包一块上（4：00）

# P84 GateWay 之 Filter 配置 05

4、前缀和路径相关组

- 6.14 The PrefixPath GatewayFilter Factory
  - 自动添加路径前缀
  - 之前的正确地址
  - YML（0：53）
    - 分拆说明（2：33）
  - Chrome 测试（3：11）
- 6.29 The SetPath GatewayFilter Factory
  - 访问路径修改
  - 测试
    - YML（4：33）
      - 说明（5：41）
      - 带占位符的地址替换
    - 结果（7：32）
- 6.16 The RedirectTo GatewayFilter Factory
  - 重定向到某个页面
  - YML(8:17)

# P85 GateWay 之 Filter 配置 06

5、其它

- 6.37 Default Filters
- 配置在此处相当于全局通用，自定义秒变 Global（1：36）
- 本次案例全部 YML 配置全集（1：41）

# P86 GateWay 之自研统计接口性能网关需求说明

Gateway 自定义过滤器

- 自定义全局 Filter
  - 面试题
    - 统计接口调用耗时情况，如何落地，谈谈设计思路
    - 通过自定义全局过滤器搞定上述需求
  - 案例
    - 自定义接口调用耗时统计的全局过滤器
    - 知识出处
    - 步骤
    - 测试
- 自定义条件 Filter

# P87 GateWay 之自研统计接口性能网关编码实战

- 步骤
  - 新建类 MyGlobalFilter 并实现 GlobalFilter，Ordered 两个接口
  - YML（8：55）
  - code
- 测试

# P88 GateWay 之自研单一内置过滤器 GatewayFilter 实战

自定义条件 Filter

- 自定义，单一内置过滤器 GatewayFilter

- 先参考 GateWay 内置出厂默认的

  - for example
    - SetStatusGatewayFilterFactory
    - SetPathGatewayFilterFactory
    - AddResponseHeaderGatewayFilterFactory
    - ……

- 自定义网关过滤器规则步骤套路

  - 新建类名 XXX 需要以 GatewayFilterFactory 结尾，并继承 AbstractGatewayFilterFactory 类（5：04）

  - 新建 XXXGatewayFilterFactory.Config 内部类（5：53）

  - 重写 apply 方法

  - 重写 shortcutFieldOrder

  - 空参构造方法，内部调用 super

  - 完整代码 01

    - （13:38）

      ```java
      @Component
      public class MyGatewayFilterFactory extends AbstractGatewayFilterFactory<MyGatewayFilterFactory.Config> {
          public MyGatewayFilterFactory() {
              super(MyGatewayFilterFactory.Config.class);
          }
          
          @Override
          public List<String> shortcutFieldOrder() {
              List<String> list = new ArrayList<String>();
              list.add("status");
              return list;
          }
          
          @Override
          public GatewayFilter apply(MyGatewayFilterFactory.Config config) {
              return new GatewayFilter() {
                  @Override
                  public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
                      ServerHttpRequest request = exchange.getRequest();
                      System.out.println("进入自定义网关过滤器 MyGatewayFilterFactory, status ===" + config.getStatus);
                      if (request.getQueryParams().containsKey("atguigu")) {
                          return chain.filter(exchange);
                      } else {
                          exchange.getResponse().setStatusCode(HttpStatus.BAD_REQUEST);
                          return exchange.getResponse().setComplete();
                      }
                  }
              };
          }
          
          public static class Config {
              @Setter @Getter
              private String status;
          }
      }
      ```

- YML（15：23）

  - My 补充说明
    - 出厂默认（14：31）
    - 自己定制 My（15：12）

- 测试

# P89 SpringCloudAlibaba 是什么

10、SpringCloud Alibaba 入门简介

- 零基础小白必看，懂的同学请跳过
- SpringCloud alibaba 入门简介
  - 是什么
    - 诞生（3：08）
    - 介绍（7：42）
    - 何为必须组件（8：44）
  - 能干嘛
  - 去哪下
  - 怎么玩
  - 毕业版本依赖关系（推荐使用）

# P90 SpringCloudAlibaba 主要功能和版本定型

- 能干嘛

  - https://github.com/alibaba/spring-cloud-alibaba/blob/2022.x/README-zh.md

    - （0：17）

      主要功能：

      - 服务限流降级
      - 服务注册与发现
      - 分布式配置管理
      - 消息驱动能力
      - 分布式事务
      - 阿里云对象存储
      - 分布式任务调度
      - 阿里云短信服务

- 去哪下

  - 官网定义

- 怎么玩（3：29）

- 毕业版本依赖关系（推荐使用）

- SpringCloud Alibaba 开发参考文档

  - 英文
  - 中文

# P91 Nacos 之是什么

11、SpringCloud Alibaba Nacos 服务注册和配置中心

- 总体介绍（0：49）

- Nacos 简介

  - 为什么叫 Nacos 这个名字（2：31）

    - Nacos：Dynamic Naming and Configuration Service
    - 前四个字母分别为 Naming 和 Configuration 的前两个字母，最后的 s 为 Service

  - 是什么

    - 一个更易于构建云原生应用的动态服务发现、配置管理和服务管理平台
    - 一句话
      - Nacos 就是注册中心 + 配置中心的组合
      - 等价于
        - Nacos = Eureka + Config + Bus
        - Nacos = Spring Cloud Consul

  - 能干嘛

    - 替代 Eureka/Consul 微服务注册中心
    - 替代（Config+Bus）/Consul 做服务配置中心和满足动态刷新广播通知

  - 去哪下

  - 各种注册中心比较

    - （6：31）

      | 服务注册与发现框架 | CAP模型 | 控制台管理 | 社区活跃度         |
      | ------------------ | ------- | ---------- | ------------------ |
      | Eureka             | AP      | 支持       | 低（2.x 版本闭源） |
      | Zookeeper          | CP      | 不支持     | 中                 |
      | Consul             | CP      | 支持       | 高                 |
      | Nacos              | AP      | 支持       | 高                 |

      据说 Nacos 在阿里巴巴内部有超过 10 万的实例运行，已经过了类似双十一等各种大型流量的考验，Nacos 默认是 AP 模式，但也可以调整切换为 CP，我们一般用默认 AP 即可

- Nacos 下载安装

- Nacos Discovery 服务注册中心

- Nacos Config 服务配置中心

- Nacos 数据模型之 Namespace-Group-DataId

# P92 Nacos 之下载安装本地运行

Nacos 下载安装

- 本地 Java17 + maven 环境已经 OK
  - 注意 Nacos 版本
- 先从官网下载 Nacos
- 解压安装包，直接运行 bin 目录下的 startup.cmd
  - startup.cmd -m standalone
- 命令运行成功后直接访问
  - http://localhost:8848/nacos
  - 默认账号密码都是 nacos
- 结果页面（4：21）
- 关闭服务器
  - shutdown.cmd

# P93 Nacos 之服务提供者 9001 入驻 Nacos 中心

Nacos Discovery 服务注册中心

- 概述
- SpringCloud Alibaba 参考中文文档
- 基于 Nacos 的服务提供者
  - 新建 Module
    - cloudalibaba-provider-payment9001
  - POM（2：50）
  - YML（3：46）
  - 主启动（4：48）
  - 业务类（6：13）
  - 测试
    - nacos 控制台
    - nacos 8848 注册中心 + 服务提供者 pay9001 都 OK 了
- 基于 Nacos 的服务消费者
- 负载均衡

# P94 Nacos 之服务消费者 83 入驻 Nacos 中心

基于 Nacos 的服务消费者

- 新建 Module
  - cloudalibaba-consumer-nacos-order83
- POM（2：15）
- YML（3：10）
- 主启动（4：07）
- 业务类
  - 配置 config（5：05）
  - OrderNacosController（5：54）
- 测试
  - nacos 控制台

# P95 Nacos 之负载均衡 Nacos 支持演示

负载均衡

- 参照 9001 新建 9002
  - 要么老实创建，cloudalibaba-provider-payment9002，要么取巧不想新建重复体力劳动，直接拷贝虚拟端口映射
  - 步骤
    - 1（1：31）
    - 2（2：18）
      - -DServer.port=9002
    - 3（2：38）
- 测试
  - 看到端口号 9001/9002 交替出现，负载均衡达到

# P96 Nacos 之配置中心业务规则和动态刷新-上

Nacos Config 服务配置中心

- 概述

  - 之前案例 Consul 8500 服务配置动态变更功能可以被 Nacos 取代
  - 通过 Nacos 和 spring-cloud-starter-alibaba-nacos-config 实现中心化全局配置的动态变更

- 官网文档

  - SpringCloud Alibaba 参考中文文档

- Nacos 作为配置中心配置步骤

  - 建 Module

    - cloudalibaba-config-nacos-client3377

  - POM（1：28）

  - YML

    - why 配置两个

      - （2：44）

        Nacos 同 Consul 一样，在项目初始化时，要保证先从配置中心进行配置拉取，拉取配置之后，才能保证项目的正常启动，为了满足动态刷新和全局广播通知

        springboot 中配置文件的加载是存在优先级顺序的，**bootstrap 优先级高于 application**

    - YML 2024

      - bootstrap.yml（3：29）
      - application（4：49）

  - 主启动（5：24）

  - 业务类

    - NacosConfigClientController(6:13)
    - @RefreshScope
      - 通过 Spring Cloud 原生注解 `@RefreshScope` 实现配置自动更新

  - 在 Nacos 中添加配置信息（重点）

  - 测试

  - 自带动态刷新

  - 历史配置

# P97 Nacos 之配置中心业务规则和动态刷新-下

在 Nacos 中添加配置信息（重点）

- Nacos 中的匹配规则
  - 设置 DataId 理论
    - Nacos 中的 dataid 的组成格式及与 SpringBoot 配置文件中的匹配规则
    - 官网（1：43）
  - 配置 DataId 实操
    - 公式
      - `${spring.application.name}-${spring.profiles.active}.${spring.cloud.nacos.config.file-extension}`
    - prefix 默认为 spring.application.name 的值
    - spring.profile.active 即为当前环境对应的 profile，可以通过配置项 spring.profile.active 来配置
    - file-extension 为配置内容的数据格式，可以通过配置项 spring.cloud.nacos.config.file-extension 来配置
    - 小总结说明（5：46）
- 案例步骤
  - 查看 YML（6：10）
  - 创建配置
  - 配置 DataId 和对应文件
    - Data ID：
      - nacos-config-client-dev.yaml
    - 三码合一（7：02）

测试

- 启动 Nacos 且在 nacos 后台管理-配置列表下**已经存在对应的 yaml 配置文件**（8：32）
- 运行 cloud-config-nacos-client3377 的主启动类
- 调用接口查看配置信息

自带动态刷新

- 修改下 Nacos 中的 yaml 配置文件，再次调用查看配置的接口，就会发现配置已经刷新

历史配置

- Nacos 会记录配置文件的历史版本默认保留 30 天，此外还有一键回滚功能，回滚操作将会触发配置更新
- 回滚（11：48）

# P98 Nacos 之 Namespace-Group-DataId 三元组-上

Nacos 数据模型之 Namespace-Group-DataId

- 问题
  - 多环境多项目管理（1：08）
- 官网
- Namespace + Group + DataId 三者关系？为什么这么设计？（4：45）
  - 三者说明（4：51）
- Nacos 的图形化管理界面
  - 命名空间 Namespace（7：45）
  - 配置管理（7：50）
- 三种方案加载配置

# P99 Nacos 之 Namespace-Group-DataId 三元组-下

三种方案加载配置

1. DataID 方案
   - 指定 spring.profile.active 和配置文件的 DataID 来使不同环境下读取不同的配置
   - 默认空间 public + 默认分组 DEFAULT_GROUP + 新建 DataID
     - 新建 test 配置 DataID（0：47）
       - nacos-config-client-test.yaml
     - nacos 后台（2：09）
   - 修改 YML
     - 通过 spring.profile.active 属性就能进行多环境下配置文件的读取（2：23）
     - bootstrap.yml（2：48）
     - application.yml（2：56）
       - test
   - 测试
     - 配置是什么就加载什么
       - test
2. Group 方案
   - 通过 Group 实现环境区分
   - 默认空间 public + 新建 PROD_GROUP + 新建 DataID
     - 新建 prod 配置 DataID
       - nacos-config-client-prod.yaml
     - 新建 Group（4：50）
       - PROD_GROUP
     - nacos 后台（5：46）
   - 修改 YML
     - 在 config 下增加一条 group 的配置即可。可配置为 PROD_GROUP
     - bootstrap.yml（6：03）
     - application.yml
       - prod
   - 测试
     - 配置是什么就加载什么
3. Namespace 方案
   - 通过 Namespace 实现命名空间环境区分
     - 新建 Namespace：Prod_Namespace（7：50）
     - 新建 Namespace 但命名空间 ID 不填（系统自动生成）：Prod2_Namespace
     - 后台（9：32）
   - Prod_Namespace + PROD_GROUP + DataID(nacos-config-client-prod.yaml)
     - 选定 Prod_Namespace 后新建
       - 1（9：58）
       - 2（10：19）
         - 命名空间
           - Prod_Namespace
         - Data ID
           - nacos-config-client-prod.yaml
         - GROUP
           - PROD_GROUP
       - 效果（10：40）
     - 后台（11：38）
   - 修改 YML
     - 在 config 下增加一条 `namespace: ProdNamespace`
     - bootstrap.yml（11：57）
     - application.yml（12：40）
       - prod
   - 测试
     - 配置是什么就加载什么

# P100 Sentinel 之是什么

12、SpringCloud Alibaba Sentinel 实现熔断与限流

- Sentinel
  - 官网
    - 等价对标
      - Spring Cloud Circuit Breaker
  - 是什么(1:49)
  - 去哪下
  - 能干嘛（7：18）
    - 从流量路由、流量控制、流量整形、熔断降级、系统自适应过载保护、热点流量防护等多个维度来帮助开发者保障微服务的稳定性
  - 怎么玩（面试题）
- 安装 Sentinel
- 微服务 8401 整合 Sentinel 入门案例
- 流控规则
- 熔断规则
- @SentinelResource 注解
- 热点规则
- 授权规则
- 规则持久化
- OpenFeign 和 Sentinel 集成实现 fallback 服务降级
- GateWay 和 Sentinel 集成实现服务限流

# P101 Sentinel 之分布式常见面试题

怎么玩（面试题）

- 讲讲什么是缓存穿透？击穿？雪崩？如何解决？
- 服务雪崩（3：16）
- 服务降级（3：48）
- 服务熔断（4：20）
- 服务限流（5：04）
- 服务隔离（6：02）
- 服务超时（6：17）

# P102 Sentinel 之下载安装运行

安装 Sentinel

- Sentinel 组件由 2 部分构成（0：21）
  - 后台 8719 默认
  - 前台 8080 开启
- 安装步骤
  - 下载
    - 下载到本地 sentinel-dashboard-1.8.6.jar
  - 运行命令
    - 前提
      - Java 环境 OK
      - 8080 端口不能被占用
    - 命令
      - java -jar sentinel-dashboard-1.8.6.jar
  - 访问 sentinel 管理界面
    - 登陆账号密码均为 sentinel

# P103 Sentinel 之微服务 8401 纳入 Sentinel 监控

微服务 8401 整合 Sentinel 入门案例

- 启动 Nacos 8848 成功
  - startup.cmd -m standalone
- 启动 Sentinel 8080 成功
  - java -jar sentinel-dashboard-1.8.6.jar
- 新建微服务 8401
  - cloudalibaba-sentinel-service8401
    - 将被哨兵纳入管控的 8401 微服务提供者
  - POM（2：08）
  - YML（2：57）
  - 主启动（4：05）
  - 业务类 FlowLimitController（5：26）
  - 启动微服务 8401 并访问
- 启动 8401 微服务后查看 sentinel 控制台
  - 空空如也，啥都没有（6：57）
  - Sentinel 采用的懒加载说明
    - 注意
      - 想使用 Sentinel 对某个接口进行限流 和降级等操作，一定要先访问下接口，使 Sentinel 检测出相应的接口
    - 执行一次访问即可
    - 效果

# P104 Sentinel 之流控模式-直接

流控规则

- 基本介绍（0：57）
  - 概述（1：29）
- 流控模式（2：44）
  - 直接
    - **默认的流控模式，当接口达到限流条件时，直接开启限流功能。**
    - 配置及说明（3：02）
    - 测试
      - 快速点击访问
      - 结果
        - Blocked by Sentinel (flow limiting)
      - 思考？？？
        - 直接调用默认报错信息，技术方面 OK，but，是否应该有我们自己的后续处理？
          - 类似有个 fallback 的兜底方法？
  - 关联
  - 链路
- 流控效果
- 流控效果 V2（并发线程数）

# P105 Sentinel 之流控模式-关联

关联

- 是什么
  - 当关联的资源达到阈值时，就限流自己
  - 当与 A 关联的资源 B 达到阈值后，就限流 A 自己
  - **B 惹事，A 挂了**
    - 张三感冒，李四吃药
- 配置 A（0：42）
- Jmeter 模拟并发密集访问 testB
  - Apache JMeter 5.6.2（Requires Java 8+）
  - 访问 testB 成功
  - Run
  - **大批量线程高并发访问 B，导致 A 失效了**
- 运行后发现 testA 挂了
  - 结果
    - Blocked by Sentinel (flow limiting)

# P106 Sentinel 之流控模式-链路

链路

- 来自不同链路的请求对同一个目标访问时，实施针对性的不同限流措施，比如 C 请求来访问就限流，D 请求来访问就是 OK
- 修改微服务 cloudalibaba-sentinel-service8401
  - YML（4：08）
  - 业务类
    - 新建 FlowLimitService
      - @SentinelResource 后面介绍
    - 修改 FlowLimitController
- sentinel 配置
- 测试
  - C 链路
  - D 链路 OK

# P107 Sentinel 之流控效果-预热 WarmUp

流控效果

1. 直接 -> 快速失败（默认的流控处理）
   - 直接失败，抛出异常
     - Blocked by Sentinel（flow limiting）
2. 预热 WarmUp
   - 限流 冷启动
     - 说明（2：02）
   - 说明
     - 公式：阈值除以冷却因子 coldFactor（默认值为 3），经过预热时长后才会达到阈值
   - 官网（3：08）
     - 默认 `coldFactor` 为 3，即请求 QPS 从 `threshold / 3` 开始，经预热时长逐渐升至设定的 QPS 阈值
     - 源码
       - com.alibaba.csp.sentinel.slots.block.flow.controller.WarmUpController
   - WarmUp 配置（4：20）
   - 多次点击
     - 刚开始不行，后续慢慢 OK
   - 应用场景（7：44）
3. 排队等待

# P108 Sentinel 之流控效果-排队等待

3、排队等待

- 是什么（0：44）
- 修改 FlowLimitController（2：04）
- sentinel 配置（3：10）

# P109 Sentinel 之流控效果-并发线程数

流控效果 V2（并发线程数）

- sentinel 配置
- Jmeter 模拟多个线程并发 + 循环请求（2：14）

# P110 Sentinel 之熔断规则理论简介

熔断规则

- 官网
- 基本介绍（3：11）
  - 官网说明（4：32）
- 新增熔断规则实战
  1. 慢调用比例
  2. 异常比例
  3. 异常数

# P111 Sentinel 之熔断规则-慢调用比例

1、慢调用比例

- 是什么（0：18）

- 名词解释（3：40）

- 触发条件 + 熔断状态

  - （5：38）

    进入熔断状态判断依据：在统计时长内，实际请求数目 > 设定的最小请求数 且 实际慢调用比例 > 比例阈值，进入熔断状态。

    1 熔断状态（保险丝跳闸断电，不可访问）：在接下来的熔断时长内请求会自动被熔断

    2 探测恢复状态（探路先锋）：熔断时长结束后进入探测恢复状态

    3 结束熔断（保险丝闭合恢复，可以访问）：在探测恢复状态，如果接下来的一个请求响应时间小于设置的慢调用 RT，则结束熔断，否则继续熔断

- 测试

  - 代码（6：47）
  - 配置（7：44）
  - jmeter 压测（9：23）
  - 结论（9：37）

# P112 Sentinel 之熔断规则-异常比例

2、异常比例

- 是什么(0:49)
  - Blocked by Sentinel (flow limiting)
- 测试
  - 代码（2：27）
  - 配置（3：47）
  - jmeter（8：18）
  - 结论（8：31）

# P113 Sentinel 之熔断规则-异常数

3、异常数

- 是什么（0：31）
- 测试
  - 代码（1：35）
  - 配置（1：59）
  - jmeter（4：02）
  - 结论（4：48）

# P114 Sentinel 之 @SentinelResource 注解理论简介

@SentinelResource 注解

- 是什么
  - SentinelResource 是一个流量防卫防护组件注解，用于指定防护资源，对配置的资源进行流量控制、熔断降级等功能
  - @SentinelResource 注解说明（1：42）
- 启动 Nacos 成功
  - startup.cmd -m standalone
- 启动 Sentinel 成功
  - java -jar sentinel-dashboard-1.8.6.jar
- 1 按照 rest 地址限流 + 默认限流返回
- 2 按 SentinelResource 资源名称限流 + 自定义限流返回
- 3 按 SentinelResource 资源名称限流 + 自定义限流返回 + 服务降级处理

# P115 Sentinel 之 @SentinelResource 注解-默认不使用

1 按照 rest 地址限流 + 默认限流返回

- 通过访问的 rest 地址来限流，会返回 Sentinel 自带默认的限流处理信息
- 业务类 RateLimitController（3：07）
- 访问一次
- Sentinel 控制台配置（4：03）
- 测试
  - 疯狂点击
  - 结果（4：51）

# P116 Sentinel 之 @SentinelResource 注解开启并使用 blockHandler

2 按 SentinelResource 资源名称限流 + 自定义限流返回

- 不想用默认的限流提示（Blocked by Sentinel（flow limiting）），想返回自定义限流的提示
- 微服务 cloudalibaba-sentinel-service8401
  - 业务类 RateLimitController
- 测试地址
- 配置流控规则
  - 配置步骤
  - 图形配置和代码关系（4：46）
- 测试
  - 1 秒钟点击 1 下，OK
  - 超过上述，疯狂点击，返回了自定义的限流处理信息，限流发生
    - sentinel 默认（5：19）
    - 自定义限流提示（5：21）

# P117 Sentinel 之 @SentinelResource 注解开启并使用 blockHandler 和 fallback

3 按 SentinelResource 资源名称限流 + 自定义限流返回 + 服务降级处理

- 按 SentinelResource 配置，点击超过限流配置返回自定义限流提示+程序异常返回 fallback 服务降级
- 微服务 cloudalibaba-sentinel-service8401
  - 业务类 RateLimitController(2:36)
- 配置流控规则
  - 图形配置和代码关系（4：38）
  - 表示 1 秒钟内查询次数大于 1，就跑到我们自定义的处流，限流
- 测试
  - 1 秒钟点击 1 下，OK
  - 超过上述，疯狂点击，返回了自己定义的限流处理信息，限流发生，配合了 sentinel 设定的规则
  - p1 参数为零，异常发生，返回了自己定义的服务降级处理
  - 小结
    - blockHandler，主要针对 sentinel 配置后出现的违规情况处理
    - fallback，程序异常了 JVM 抛出的异常服务降级
    - 两者可以同时共存

# P118 Sentinel 之热点规则案例配置

热点规则

- 基本介绍
  - 是什么（1：21）
- 官网
- 代码（3：58）
- 配置（5：18）
  - 方法 testHotKey 里面第一个参数 P1 只要 QPS 超过每秒 1 次，马上降级处理
- 测试
  - error
    - 仅含有参数P1，当每秒访问的频率超过 1 次时，会触发 Sentinel 的限流操作
  - error
    - 含有参数 P1、P2，当每秒访问的频率超过 1 次时，会触发 Sentinel 的限流操作
  - right
    - 没有热点参数 P1，不断访问则不会触发限流操作
- 参数例外项

# P119 Sentinel 之热点规则-参数例外项

参数例外项

- 上述案例演示了第一个参数 p1，当 QPS 超过 1 秒 1 次点击后马上被限流
- 特例情况
  - 普通正常限流
    - 含有 P1 参数，超过 1 秒钟一个后，达到阈值 1 后马上被限流
  - 例外特殊限流
    - 我们期望 p1 参数当它是某个特殊值时，到达某个约定值后【普通正常限流】规则突然例外、失效了，它的限流值和平时不一样
    - 假如当 p1 的值等于 5 时，它的阈值可以达到 200 或其它值
- 配置
  - 添加按钮不能忘
- 测试
- 前提条件
  - 热点参数的注意点，参数必须是基本类型或者 String

# P120 Sentinel 之授权规则

授权规则

- 授权规则概述（0：35）
- 官网
- 演示授权规则，黑名单禁止
  - 代码
    - EmpowerController（3：27）
    - MyRequestOriginParser
  - 启动 8401 后先访问成功
- 配置（7：39）
- 测试
  - 说明
    - 不断在浏览器中刷新
    - 上述 2 个 rest 地址，serverName=test 或 serverName=test2 是处于黑名单的状态，无法访问，会发现无法访问，被 Sentinel 限流了。

# P121 Sentinel 之持久化规则

规则持久化

- 是什么
  - 一旦我们重启微服务应用，sentinel 规则将消失，生产环境需要将配置规则进行持久化
- 怎么玩
  - 将限流配置规则持久化进 Nacos 保存，只要刷新 8401 某个 rest 地址，sentinel 控制台的流控规则就能看到，只要 Nacos 里面的配置不删除，针对 8401 上 sentinel 上的流控规则持续有效
- 步骤
  - 修改 cloudalibaba-sentinel-service8401
  - POM（3：40）
  - YML（4：18）
    - 添加 Nacos 数据源配置（6：26）
    - 源代码（6：32）
    - 进一步说明（7：00）
  - 添加 Nacos 业务规则配置（7：38）
    - 内容解析（8：45）
  - 快速访问测试接口
    - 上面地址访问后等待 3 秒钟
    - 启动 8401 后刷新 sentinel 发现业务规则有了
    - 默认
      - Blocked by Sentinel (flow limiting)
  - 停止 8401 再看 sentinel（11：45）
  - 重新启动 8401 再看 sentinel
    - 乍一看还是没有，稍等一会儿
    - 多次调用
    - 重新配置出现了，持久化验证通过

# P122 Sentinel 之整合 OpenFeign 统一 fallback 服务降级需求

OpenFeign 和 Sentinel 集成实现 fallback 服务降级

- 需求说明（1：27）
- 程序解耦
  - 前述参考（6：17）
  - 本例说明（7：21）
- 编码步骤
- 测试验证

# P123 Sentinel 之整合 OpenFeign 统一服务降级编码-上

编码步骤

- 启动 nacos 服务器 8848
  - startup.cmd -m standalone
- 启动 Sentinel 成功
  - java -jar sentinel-dashboard-1.8.6.jar
- 1 修改服务提供方 cloudalibaba-provider-payment9001
  - 改 POM（1：15）
  - 写 YML（1：41）
  - 主启动（2：19）
  - 业务类
    - Controller（3：15）
  - 启动 9001 微服务自测一下
- 2 修改 cloud-api-commons
- 3 修改 cloudalibaba-consumer-nacos-order83

# P124 Sentinel 之整合 OpenFeign 统一服务降级编码-中

2 修改 cloud-api-commons

- POM（0：26）
- 新增 PayFeignSentinelApi 接口
- 为远程调用新建全局统一服务降级类，fallback = PayFeignSentinelApiFallBack.class（4：28）
- gav 坐标（5：01）

3 修改 cloudalibaba-consumer-nacos-order83

- POM（5：54）
- YML（6：22）
- 主启动（6：59）
  - 添加 @EnableFeignClients 启动 Feign 的功能
- 业务类
  - OrderNacosController（7：46）
- 启动 83 微服务，第 1 次
  - 故障现象（11：28）
  - 导致原因
    - springboot + springcloud 版本太高导致和阿里巴巴 Sentinel 不兼容
  - 解决方案
    - 总体父工程，boot+cloud 降低版本（12：24）
- 启动 83 微服务，第 2 次

# P125 Sentinel 之整合 OpenFeign 统一服务降级编码-下

测试验证

- 9001 正常启动后，再启动 83 通过 feign 调用
- 测试地址
- sentinel 流控为例，进行配置
  - 频繁访问后触发了 Sentinel 的流控规则，blockHandler 起效（2：37）
- 9001 宕机了，83 通过 feign 调用
- 最后一步
  - 恢复父工程版本号，升（4：05）

# P126 Sentinel 之 GateWay 和 Sentinel 集成实现服务限流-上

GateWay 和 Sentinel 集成实现服务限流

- 需求说明（0：51）
- 启动 nacos 服务器 8848
- 启动 sentinel 服务器 8080
- 步骤
  - 建 Module
    - cloudalibaba-sentinel-gateway9528
  - 改 POM（1：36）
  - 写 YML（2：39）
  - 主启动（3：38）
  - 业务类
    - 参考官网配置说明案例改写
    - 配置 coding
- 测试

# P127 Sentinel 之 GateWay 和 Sentinel 集成实现服务限流-下

测试

- 原生 url
- 加网关
- sentinel + gateway：加快点击频率，出现限流容错

# P128 Seata 之分布式事务常见面试题

13、SpringCloud Alibaba Seata 处理分布式事务

- 面试题
  - 你简历上写用微服务 boot/cloud 做过项目，你不可能只有一个数据库吧？请谈谈多个数据库之间你如何处理分布式事务？（2：32）
  - 我若拿出如下场景，阁下将如何应对？
    - 下订单
    - 冻库存
    - 做支付
    - 减库存
    - 抵扣减
      - 积分冲抵
      - XX 豆冲抵
      - 礼品券冲抵
      - ……
    - 送积分
    - 做推送
      - 微信
      - 短信
      - 邮件
      - ……
    - 派物流
    - ……
  - 阿里巴巴的 Seata-AT 模式如何做到对业务的无侵入？
  - 对于分布式事务问题，你知道的解决方案有哪些？请你谈谈？
    1. 2PC（两阶段提交）
    2. 3PC（三阶段提交）
    3. TCC 方案
       - TCC(Try-Confirm-Cancel)又被称为补偿事务
       - 类似 2PC 的柔性分布式解决方案，2PC 改良版
    4. LocalMessage 本地消息表
    5. 独立消息微服务 + RabbitMQ/Kafka 组件，实现可靠消息最终一致性方案
    6. 最大努力通知方案
  - ……
- 分布式事务问题如何产生？请先看业务
- Seata 简介
- Seata 工作流程简介
- Seata-Server2.0.0 安装
- Seata案例实战-数据库和表准备
- Seata案例实战-微服务编码落地实现
- Seata案例实战-测试
- Seata原理小总结和面试题

# P129 Seata 之背景和诞生原因

分布式事务问题如何产生？请先看业务

- 上述面试问题都指向一个重要问题（0：15）
- 分布式事务 before
  - 单机单库没这个问题
  - 表结构的关系从 1:1 -> 1:N -> N:N
- 分布式事务 after（1:34）
- 结论
  - 迫切希望提供一种分布式事务框架，解决微服务架构下的分布式事务问题

# P130 Seata 之 Seata 简介

Seata 简介

- 是什么
  - Simple Extensible Autonomous Transaction Architecture
    - 简单可扩展自治事务框架
  - 官网解释
    - Seata 是一款开源的分布式事务解决方案，致力于在微服务架构下提供高性能和简单易用的分布式事务服务
  - Seata 的发展历程（1：06）
- 能干嘛
  - Seata 是一款开源的分布式事务解决方案，致力于在微服务架构下提供高性能和简单易用的分布式事务服务
- 去哪下
  - 官网地址
  - 源码地址
- 怎么玩
  - 本地 @Transactional
  - 全局 @GlobalTransactional
  - Seata 的分布式交易解决方案（7：16）

# P131 Seata 之工作流程及 TC TM RM 分别是什么

Seata 工作流程简介

- 纵观整个分布式事务的管理，就是全局事务 ID 的传递和变更，要让开发者无感知（1：11）

- Seata 对分布式事务的协调和控制就是 1+3

  - 1 个 XID

    - XID 是全局事务的唯一标识，它可以在服务的调用链路中传递，绑定到服务的事务上下文中

  - 官网版 3 个概念（TC -> TM -> RM）

    - （4：03）

      TC(Transaction Coordinator) - 事务协调者

      维护全局和分支事务的状态，驱动全局事务提交或回滚

      TM(Transaction Manager) - 事务管理器

      定义全局事务的范围：开始全局事务、提交或回滚全局事务

      RM(Resource Manager) - 资源管理器

      管理分支事务处理的资源，与 TC 交谈以注册分支事务和报告分支事务的状态，并驱动分支事务提交或回滚

  - 阳哥版 3 个概念（TC -> TM -> RM）（4：59）

    - TC(Transaction Coordinator) 事务协调者
      - 就是 Seata，负责维护全局事务和分支事务的状态，驱动全局事务提交或回滚
    - TM(Transaction Manager) 事务管理器
      - 标注全局 @GlobalTransactional 启动入口动作的微服务模块（比如订单模块），它是事务的发起者，负责定义全局事务的范围，并根据 TC 维护的全局事务和分支事务状态，做出开始事务、提交事务、回滚事务的决议
    - RM(Resource Manager) 资源管理器
      - 就是 MySQL 数据库本身，可以是多个 RM，负责管理分支事务上的资源，向 TC 注册分支事务，汇报分支事务状态，驱动分支事务的提交或回滚

- 分布式事务的执行流程-小总结

  - （9：20）
    1. TM 向 TC 申请开启一个全局事务，全局事务创建成功并生成一个全局唯一的 XID
    2. XID 在微服务调用链路的上下文中传播
    3. RM 向 TC 注册分支事务，将其纳入 XID 对应全局事务的管辖
    4. TM 向 TC 发起针对 XID 的全局提交或回滚决议
    5. TC 调度 XID 下管辖的全部分支事务完成提交或回滚请求

- 各事务模式

  - AT 模式、TCC 模式、Saga 模式、XA 模式
  - 日常工作 + 企业调研 + 本次课时安排限制，以 AT 模式作为入手突破

# P132 Seata 之 Seata-Server 安装理论知识

Seata-Server2.0.0 安装

1. 下载地址
2. 下载版本
3. 各种 seata 参数官网参考
4. Seata 新手部署指南（4：25）
5. mysql 8.0 数据库里面建库 + 建表
6. 更改配置
7. 先启动 Nacos 2.2.3 端口号 8848
8. 再启动 seata-server-2.0.0

# P133 Seata 之 Seata-Server 安装步骤详解

5、mysql 8.0 数据库里面建库 + 建表

- 建库 seata
- 在上一步 seata 库里建表
  - 建表 SQL 地址
  - SQL 脚本内容（2：24）
  - 结果

6、更改配置

- 修改 seata-server-2.0.0\conf\application.yml 配置文件，记得先备份（3：30）
- application.yml 定稿版（7：29）

7、先启动 Nacos 2.2.3 端口号 8848

- startup.cmd -m standalone
- 命令运行成功后直接访问 http://localhost:8848/nacos
  - 默认账号密码

8、再启动 seata-server-2.0.0

- D:\devSoft\seata-server-2.0.0\bin
- seata-server.bat 命令执行后
- http://localhost:7091
- 看看 Nacos

# P134 Seata 之项目实战-订单库存账户3个业务数据库安装脚本

Seata案例实战-数据库和表准备

- 订单 + 库存 + 账户，3 个业务数据库 MySQL 准备
  - 以下演示都需要先启动 Nacos 后启动 Seata，保证两个都 OK
  - 分布式事务本案例业务说明（0：46）
  - 1 创建 3 个业务数据库 DATABASE
    - seata_order：存储订单的数据库
    - seata_storage：存储库存的数据库
    - seata_account：存储账户信息的数据库
    - 建库 SQL（2：12）
  - 2 按照上述 3 库分别建对应的 undo_log 回滚日志表
    - 订单-库存-账户 3 个库下都需要建各自的 undo_log 回滚日志表
    - seata 官网
    - undo_log 建表 SQL（4：17）
      - AT 模式专用，其它模式不需要
  - 3 按照上述 3 库分别建对应业务表
    - t_order 脚本 SQL（5：30）
    - t_account 脚本 SQL（6：09）
    - t_storage 脚本 SQL（6：58）
  - 最终 All-SQL（同学们自用）
    - 建 seata_order 库 + 建 t_order 表 + undo_log 表（8：07）
    - 建 seata_storage 库 + 建 t_storage 表 + undo_log 表（8：32）
    - 建 seata_account 库 + 建 t_account 表 + undo_log 表
  - 最终效果（9：17）

# P135 Seata 之项目实战-mybatis一键生成和通用接口编写

Seata 案例实战-微服务编码落地实现

- 订单/库存/账户业务微服务 Java 开发准备
  - 业务需求
    - 一句话
    - 下订单 -> 减库存 -> 扣余额 -> 改（订单）状态
  - 1 Mybatis 一键生成
    - config.properties（2：39）
    - generatorConfig.xml（3:24）
  - 2 修改公共 cloud-api-commons 新增库存和账户两个 Feign 服务接口
    - StorageFeignApi（5：07）
    - AccountFeignApi（6：16）
  - 3 新建订单 Order 微服务
  - 4 新建库存 Storage 微服务
  - 5 新建账户 Account 微服务

# P136 Seata 之项目实战-Order 订单微服务-上

3 新建订单 Order 微服务

1. 建 Module
   - seata-order-service2001
2. 改 POM（1：46）
3. 写 YML（3：17）
   - Namespace + Group + DataId 三者关系？为什么这样设计？（6：56）
   - 对应说明（7：07）
   - 详细过度版（了解即可，太详细也不好维护）（12：53）
4. 主启动（13：17）
5. 业务类
   - entities
     - Order
   - OrderMapper
   - Service 接口及实现
     - OrderService
     - OrderServiceImpl
   - Controller

# P137 Seata 之项目实战-Order 订单微服务-下

5、业务类

- entities
  - Order
- OrderMapper
  - OrderMapper 接口（1：30）
  - resources 文件夹下新建 mapper 文件夹后添加
    - OrderMapper.xml（1：37）
- Service 接口及实现
  - OrderService（2：19）
  - OrderServiceImpl（2：47）
- Controller

# P138 Seata 之项目实战-Storage 订单微服务

4 新建库存 Storage 微服务

1. 建 Module
   - seata-order-service2002
2. 改 POM（0：40）
3. 写 YML（1：01）
4. 主启动（1：29、3：37）
5. 业务类
   - entites
   - StorageMapper
     - StorageMapper 接口（5：01）
     - resources 文件夹下新建 mapper 文件夹后添加
       - StorageMapper.xml（6：08）
   - Service 接口及实现
     - StorageService（6：50）
     - StorageServiceImpl（7：15）
   - Controller（7：53）

# P139 Seata 之项目实战-Account 订单微服务

5 新建账户 Account 微服务

1. 建 Module
   - seata-order-service2003
2. 改 POM
3. 写 YML
4. 主启动（1：39）
5. 业务类
   - entities
     - Account
   - AccountMapper
     - AccountMapper 接口
     - resources 文件夹下新建 mapper 文件夹后添加
       - AccountMapper.xml
   - Service 接口及实现
   - Controller

# P140 Seata 之项目实战-测试环境和数据预加载

Seata 案例实战-测试

- 服务启动情况
  - 启动 Nacos
  - 启动 Seata
  - 启动订单微服务 2001
  - 启动库存微服务 2002
  - 启动账户微服务 2003
- 数据库初始情况（2：32）
- 1 正常下单
- 2 超时异常出错，没有 @GlobalTransactional
- 3 超时异常解决，添加 @GlobalTransactional

# P141 Seata 之项目实战-下单测试流程和版本踩坑说明

1 正常下单

- 下订单 -> 减库存 -> 扣余额 -> 改（订单）状态
- 此时我们没有在订单模块添加 @GlobalTransactional
- 1 号用户花费 100 块钱买了 10 个 1 号产品
- 正常下单，第1次
  - 故障现象（4：08）
  - 导致原因
    - springboot + springcloud 版本太高导致和阿里巴巴 Seata 不兼容
  - 解决方案
    - 总体父工程，boot+cloud 降低版本
- 正常下单，第2次
  - OK
  - 数据库情况

# P142 Seata 之项目实战-没有 @GlobalTransactional 异常情况

2 超时异常出错，没有 @GlobalTransactional

- 修改 seata-account-service2003 微服务 AccountServiceImpl 添加超时（0：40）
- 故障情况
  - 当库存和账户金额扣减后，订单状态并没有设置为已经完成，没有从零改为 1
  - 数据库情况

# P143 Seata 之项目实战-添加 @GlobalTransactional 异常情况

3 超时异常解决，添加 @GlobalTransactional

- AccountServiceImpl 保留超时方法
- OrderServiceImpl @GlobalTransactional（1：15）
- 查看 Seata 后台
  - 全局事务 ID（7：43）
  - 全局锁（8：00）
- 下单后数据库 3 个库数据并没有任何改变，被回滚了
  - 业务中……（11：27）
  - 回滚后
    - order 记录都添加不进来
    - 全部回退

# P144 Seata 之项目实战-添加 @GlobalTransactional 正常情况



# P145 Seata 之 Seata 原理小总结

Seata 原理小总结和面试题

- AT 模式如何做到对业务的无侵入

  - 是什么（0：58）

  - 一阶段加载

    - （2：38）

      在一阶段，Seata 会拦截"业务 SQL"

      1. 解析 SQL 语义，找到“业务 SQL”要更新的业务数据，在业务数据被更新前，将其保存成“before image”
      2. 执行“业务 SQL”更新业务数据，在业务数据更新之后
      3. 其保存成“after image”，最后生成行锁

      以上操作全部在一个数据库事务内完成，这样保证了一阶段操作的原子性

  - 二阶段分 2 种情况

    - 正常提交

      - （5：58）

        二阶段如是顺利提交的话

        因为“业务 SQL”在一阶段已经提交至数据库，所以 Seata 框架只需将一阶段保存的快照数据和行锁删掉，完成数据清理即可。

    - 异常回滚

      - （6：48）

        二阶段回滚：

        二阶段如果是回滚的话，Seata 就需要回滚一阶段已经执行的“业务 SQL”,还原业务数据

        回滚方式便是用“before image”还原业务数据；但在还原前要首先要校验脏写，对比“数据库当前业务数据”和“after image”，如果两份数据完全一致就说明没有脏写，可以还原业务数据，如果不一致就说明有脏写，出现脏写就需要转人工处理

# P146 终章总结