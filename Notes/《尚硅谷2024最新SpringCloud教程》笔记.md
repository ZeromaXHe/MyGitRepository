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

Consul 服务注册与发现

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
              # 		/cloud-payment-service-dev/data
              # 		/cloud-payment-service-prod/data
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

LoadBalancer 负载均衡服务调用

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