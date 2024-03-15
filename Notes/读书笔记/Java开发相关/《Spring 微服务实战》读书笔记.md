# 第1章 欢迎迈入云世界，Spring

## 1.1 什么是微服务

微服务架构具有以下特征：

- 应用程序逻辑分解为具有明确定义了职责范围的细粒度组件，这些组件互相协调提供解决方案。
- 每个组件都有一个小的职责领域，并且完全独立部署。微服务应该对业务领域的单个部分负责。此外，一个微服务应该可以跨多个应用程序复用。
- 微服务通信基于一些基本的原则（注意，我说的是原则而不是标准），并采用 HTTP 和 JSON ( JavaScript Object Notation ）这样的轻量级通信协议，在服务消费者和服务提供者之间进行数据交换。
- 服务的底层采用什么技术实现并没有什么影响，因为应用程序始终使用技术中立的协议（JSON 是最常见的）进行通信。这意味着构建在微服务之上的应用程序能够使用多种编程语言和技术进行构建。
- 微服务利用其小、独立和分布式的性质，使组织拥有明确责任领域的小型开发团队。这些团队可能为同一个目标工作，如交付一个应用程序，但是每个团队只负责他们在做的服务。

## 1.5 使用 Spring Boot 来构建微服务

Spring 编写一个简单的 “Hello World” REST 服务。下面展示这个服务将会做什么，以及 Spring Boot 微服务将会如何处理用户请求的一般流程：

- 客户端发送一个HTTP GET请求到Hello微服务。
- **路由映射**：Spring Boot 将解析 HTTP 请求，并根据 HTTP 谓词、URL 和 URL 定义的潜在参数映射路由。路由映射到 Spring RestController 类中的方法。
- **参数解构**：Spring Boot 识别出路由后，将路由中定义的所有参数映射到执行该工作的 Java 方法中。
- **JSON 到 Java 对象映射**：对于 HTTP PUT 或 Post 请求，在 HTTP 主体中传递的 JSON 被映射到 Java 类。
- **业务逻辑执行**：映射完所有数据后，Spring Boot 就会执行业务逻辑。
- **Java 到 JSON 对象映射**：执行完业务逻辑后，Spring Boot 将 Java 对象转换为 JSON。
- 客户端以 JSON 接收来自服务的响应。调用的成功或失败则以 HTTP 状态码返回。

~~~java
package com.thoughtmechanix.simpleservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;

@SpringBootApplication // 告诉 Spring Boot 框架，该类是 Spring Boot 服务的入口点
@RestController // 告诉 Spring Boot，要将该类中的代码公开为 Spring RestController 类
@RequestMapping(value = "hello") // 此应用程序中公开的所有 URL 将以 /hello 前缀开头
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
    
    // Spring Boot 公开为一个基于 GET 方法的 REST 端点，它将使用两个参数，即 firstName 和 lastName
    @RequestMapping(value = "/{firstName}/{lastName}", method = RequestMethod.GET)
    // 将 URL 中传入的 firstName 和 lastName 参数映射为传递给 hello 方法的两个变量
    public String hello(@PathVariable("firstName") String firstName, @PathVariable("lastName") String lastName) {
        // 返回一个手动构建的简单 JSON 字符串，在第 2 章中，我们不需要创建任何 JSON
        return String.format("{\"message\":\"Hello %s %s\"}", firstName, lastName);
    }
}
~~~

## 1.6 为什么要改变构建应用的方式

- 复杂性上升
- 客户期待更快速的交付
- 性能和可伸缩性
- 客户期望他们的应用程序可用

为了满足这些期望，作为应用开发人员不得不接受这样一个悖论：构建高可伸缩性和高度冗余的应用程序。我们需要将应用程序分解成可以互相独立构建和部署的小型服务。如果将应用程序“分解”为小型服务，并将它们从单体制品中转移出来，那么就可以构建具有下面这些特性的系统：

- **灵活性**——可以将解耦的服务进行组合和重新安排，以快速交付新的功能。一个正在使用的代码单元越小，更改代码越不复杂，测试部署代码所需的时间越短。
- **有弹性**——解耦的服务意味着应用程序不再是单个“泥浆球”，在这种架构中其中一部分应用程序的降级会导致整个应用程序失败。故障可以限制在应用程序的一小部分之中，并在整个应用程序遇到中断之前被控制。这也使应用程序在出现不可恢复的错误的情况下能够优雅地降级。
- **可伸缩性**——解耦的服务可以轻松地跨多个服务器进行水平分布，从而可以适当地对功能／服务进行伸缩。单体应用程序中的所有逻辑是交织在一起的，即使只有一小部分应用程序是瓶颈，整个应用程序也需要扩展。小型服务的扩展是局部的，成本效益更高。

为此，当我们开始讨论微服务时，请记住下面一句话：**小型的、简单的和解耦的服务＝可伸缩的、有弹性的和灵活的应用程序**。

## 1.7 云到底是什么

云计算有3种基本模式：

- 基础设施即服务（Infrastructure as a Service, IaaS） 
- 平台即服务（Platform as a Service, PaaS）
- 软件即服务（Software as a Service, Saas）

每个模型中的关键项都是控制：由谁来负责维护基础设施，以及构建应用程序的技术选择是什么？

在 IaaS 模型中，云供应商提供基础设施，但你需要选择技术并构建最终的解决方案；

而在 Saas 模型中，你就是供应商所提供的服务的被动消费者，无法对技术进行选择，同时也没有任何责任来维护应用程序的基础设施。

> **新兴的云平台**
>
> 本书已经介绍了目前正在使用的 3 种核心云平台类型（即 laaS、PaaS 和 Saas） 。然而，新的云平台类型正在出现。这些新平台包括“函数即服务”（Functions as a Service, FaaS）和“容器即服务”（ Container as a Service, CaaS）。
>
> 基于 Faas 的应用程序会使用像亚马逊的 Lambda 技术和 Google Cloud 函数这样的设施，应用会将代码块以“无服务器”（ serverless ）的形式部署，这些代码会完全在云提供商的平台计算设施上运行。使用 Faas 平台，无需管理任何服务器基础设施，只需支付执行函数所需的计算周期。
>
> 使用容器即服务模型，开发人员将微服务作为便携式虚拟容器（如 Docker）进行构建并部署到云供应商。与 laaS 模型不同，使用 laaS 的开发人员必须管理部署服务的虚拟机，而 CaaS 则是将服务部署在轻最级的虚拟容器中。云供应商会提供运行容器的虚拟服务器，以及用于构建、部署、监控和伸缩容器的综合工具。亚马逊的弹性容器服务（ Amazon Elastic Container Service, Amazon ECS ) 就是一个基于 CaaS 平台的例子。
>
> 需要重点注意的是，使用云计算的 FaaS 和 CaaS 模型，开发人员仍然可以构建基于微服务的架构。

## 1.9 微服务不只是编写代码

- **大小适当**——如何确保正确地划分微服务的大小，以避免微服务承担太多的职责？请记住，适当的大小允许快速更改应用程序，并降低整个应用程序中断的总体风险。
- **位置透明**一一在微服务应用程序中，多个服务实例可以快速启动和关闭时，如何管理服务调用的物理细节？
- **有弹性**一一如何通过绕过失败的服务，确保采取“快速失败”的方法来保护微服务消费者和应用程序的整体完整性？
- **可重复**一一如何确保提供的每个新服务实例与生产环境中的所有其他服务实例具有相同的配置和代码库？
- **可伸缩**一一如何使用异步处理和事件来最小化服务之间的直接依赖关系，并确保可以优雅地扩展微服务？

本书采用基于模式的方法来回答这些问题。通过基于模式的方法，本书列出可以跨不同技术实现来使用的通用设计。虽然本书选择了使用 Spring Boot 和 Spring Cloud 来实现本书中所使用的模式，但开发人员完全可以把这些概念和其他技术平台一起使用。具体来说，本书涵盖以下 6 类微服务模式：

- 核心微服务开发模式：服务粒度、通信协议、接口设计、服务的配置管理、服务之间的事件处理
- 微服务路由模式：服务发现、服务路由
- 微服务客户端弹性模式：客户端负载均衡、断路器模式、后备模式、舱壁模式
- 微服务安全模式：验证、授权、凭据管理和传播
- 微服务日志记录和跟踪模式：日志关联、日志聚合、微服务跟踪
- 微服务构建和部署模式：构建和部署管道、基础设施即代码、不可变服务器、凤凰服务器（Phoenix server）

## 1.10 使用 Spring Cloud 构建微服务

### 1.10.1 Spring Boot

Spring Boot 是微服务实现中使用的核心技术。Spring Boot 通过简化构建基于 REST 的微服务的核心任务，大大简化了微服务开发。Spring Boot 还极大地简化了将 HTTP 类型的动词（GET、PUT、POST 和 DELETE）映射到 URL、JSON 协议序列化与 Java 对象的相互转化，以及将 Java 异常映射回标准 HTTP 错误代码的工作。

### 1.10.2 Spring Cloud Config

Spring Cloud Config 通过集中式服务来处理应用程序配置数据的管理，因此应用程序配置数据（特别是环境特定的配置数据）与部署的微服务完全分离。这确保了无论启动多少个微服务实例，这些微服务实例始终具有相同的配置 Spring Cloud Config 拥有自己的属性管理存储库，也可以与以下开源项目集成：

- Git——Git 是个开源版本控制系统，它允许开发人员管理和跟踪任何类型的文本文件的更改。Spring Cloud Config 可以与 Git 支持的存储库集成，并读出存储库中的应用程序的配置数据。
- Consul——Consul 是一种开源的服务发现工具，允许服务实例向该服务注册自己。服务客户端可以向 Consul 咨询服务实例的位置。Consul 还包括可以被 Spring Cloud Config 使用的基于键值存储的数据库，能够用来存储应用程序的配置数据。
- Eureka——Eureka 个开源的 Netflix 项目，像 Consul 一样，提供类似的服务发现功能。Eureka 同样有一个可以被 Spring Cloud Config 使用的键值数据库。

### 1.10.3 Spring Cloud 服务发现

通过 Spring Cloud 服务发现，开发人员可以从客户端消费的服务中抽象出部署服务器的物理位置（ IP 或服务器名称）。服务消费者通过逻辑名称而不是物理位置来调用服务器的业务逻辑。Spring Cloud 服务发现也处理服务实例的注册和注销（在服务实例启动和关闭时）。Spring Cloud 服务发现可以使用 Consul 和 Eureka 作为服务发现引擎。

### 1.10.4 Spring Cloud 与 Netflix Hystrix 和 Netflix Ribbon

Spring Cloud 和 Netflix 的开源项目进行了大量整合。对于微服务客户端弹性模式，Spring Cloud 封装了 Netflix Hystrix 库和 Netflix Ribbon 项目，开发人员可以轻松地在微服务中使用它们。

使用 Netflix Hystrix 库，开发人员可以快速实现服务客户端弹性模式，如断路器模式和舱壁模式。

虽然 Netflix Ribbon 项目简化了与诸如 Eureka 这样的服务发现代理的集成，但它也为服务消费者提供了客户端对服务调用的负载均衡。即使在服务发现代理暂时不可用时，客户端也可以继续进行服务调用。

### 1.10.5 Spring Cloud 与 Netflix Zuul

Spring Cloud 使用 Netflix Zuul 项目为微服务应用程序提供服务路由功能 Zuul 是代理服务请求的服务网关，确保在调用目标服务之前，对微服务的所有调用都经过一个“前门” 通过集中的服务调用，开发人员可以强制执行标准服务策略，如安全授权验证、内容过滤和路由规则。

### 1.10.6 Spring Cloud Stream

Spring Cloud Stream 是一种可让开发人员轻松地将轻量级消息处理集成到微服务中的支持技术。借助 Spring Cloud Stream，开发人员能够构建智能的微服务，它可以使用在应用程序中出现的异步事件。此外，使用 Spring Cloud Stream 可以快速将微服务与消息代理进行整合，如 RabbitMQ Kafka

### 1.10.7 Spring Cloud Sleuth

Spring Cloud Sleuth 允许将唯一跟踪标识符集成到应用程序所使用的 HTTP 调用和消息通道(RabbitMQ、Apache Kafka ）之中。这些跟踪号码（有时称为关联 ID 或跟踪 ID ）能够让开发人员在事务流经应用程序中的不同服务时跟踪事务。有了 Spring Cloud Sleuth ，这些跟踪 ID 将自动添加到微服务生成的任何日志记录中。

Spring Cloud Sleuth 与日志聚合技术工具（如 Papertrail ）和跟踪工具（如 Zipkin ）结合时，能够展现出真正的威力。Papertail 是一个基于云的日志记录平台，用于将日志从不同的微服务实时聚合到一个可查询的数据库中。Zipkin 可以获取 Sprin Cloud Sleuth 生成的数据，并允许开发人员可视化单个事务涉及的服务调用流程。

### 1.10.8 Spring Cloud Security

Spring Cloud Security 是一个验证和授权框架，可以控制哪些人可以访问服务，以及他们可以用服务做什么。Spring Cloud Security 是基于令牌的，允许服务通过验证服务器发出的令牌彼此进行通信。接收调用的每个服务可以检查 HTTP 调用中提供的令牌，以确认用户的身份以及用户对该服务的访问权限。

此外， Spring Cloud Security 支持 JSON Web Token。JSON Web Token ( JWT ）框架标准化了创建 OAuth2 令牌的格式，并为创建的令牌进行数字签名提供了标准。

### 1.10.9 代码供应

要实现代码供应，我们将会转移到其他的技术栈。Spring 框架是面向应用程序开发的，它（包括 Spring Cloud ）没有用于创建“构建和部署”管道的工具。要实现一个“构建和部署”管道，开发人员需要使用 Travis CI 和 Docker 这两样工具，前者可以作为构建工具，而后者可以构建包含微服务的服务器镜像。

## 1.11 通过示例来介绍 Spring Cloud

~~~java
package com.thoughtmechanix.simpleservice;

// 为了简洁，省略了其他 import 语句
import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixProperty;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;

@SpringBootApplication
@RestController
@RequestMapping(value = "hello")
@EnableCircuitBreaker // 使服务能够使用 Hystrix 和 Ribbon 库
@EnableEurekaClient // 告诉服务，它应该使用 Eureka 服务发现代理注册自身，并且服务调用是使用服务发现来“查找”远程服务的位置的
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
    
    @HystrixCommand(threadPoolKey = "helloThreadPool") // 包装器使用 Hystrix 断路器调用 helloRemoteServiceCall 方法
    public String helloRemoteServiceCall(String firstName, String lastName) {
        // 使用一个装饰好的 RestTemplate 类来获取一个“逻辑”服务 ID，Eureka 在幕后查找服务的物理位置
        ResponseEntity<String> restExchange = restTemplate.exchange(
            "http://logical-service-id/name/[ca]{firstName}/{lastName}",
            HttpMethod.GET,
            null, String.class, firstName, lastName);
        return restExchange.getBody();
    }
    
    @RequestMapping(value = "/{firstName}/{lastName}", method = RequestMethod.GET)
    public String hello(@PathVariable("firstName") String firstName, @PathVariable("lastName") String lastName) {
        return helloRemoteServiceCall(firstName, lastName);
    }
}
~~~

# 第2章 使用 Spring Boot 构建微服务

使用传统的瀑布方法所面临的挑战在于，许多时候，这些项目交付的软件制品的粒度具有以下特点

- **紧耦合的**一一业务逻辑的调用发生在编程语言层面，而不是通过实现中立的协议（如 SOAP 和 REST）。这大大增加了即使对应用程序组件进行小的修改也可能打破应用程序的其他部分并引入新漏洞的机会。
- **有漏洞的**一一大多数大型软件应用程序都在管理着不同类型的数据。例如，客户关系管理（ CRM ）应用程序可能会管理客户、销售和产品信息 在传统的模型里，这些数据位于相同的数据模型中并在同一个数据存储中保存。即使数据之间存在明显的界限，在绝大多数的情况下，来自一个领域的团队也很容易直接访问属于另一个团队的数据。这种对数据的轻松访问引入了隐藏的依赖关系，并让组件的内部数据结构的实现细节泄漏到整个应用程序中。即使对单个数据库表的更改也可能需要在整个应用程序中进行大量的代码更改和回归测试。
- **单体的**一一由于传统应用程序的大多数组件都存放在多个团队共享的单个代码库中，任何时候更改代码，整个应用程序都必须重新编译、重新运行并且需要通过一个完整的测试周期并重新部署。无论是新客户的需求还是修复错误，应用程序代码库的微小变化都将变得昂贵和耗时，并且几乎不可能及时实现大规模的变化。

基于微服务的架构采用不同的方法来交付功能。具体来说， 基于微服务的架构具有以下特点：

- **有约束的**一一微服务具有范围有限的单一职责集。微服务遵循 UNIX 的理念，即应用程序是服务的集合，每个服务只做一件事，并只做好一件事。
- **松耦合的**一一基于微服务的应用程序是小型服务的集合，服务之间使用非专属调用协议（如 HTTP 和 REST ）通过非特定实现的接口彼此交互。与传统的应用程序架构相比，只要服务的接口没有改变，微服务的所有者可以更加自由地对服务进行修改。
- **抽象的**一一微服务完全拥有自己的数据结构和数据源。微服务所拥有的数据只能由该服务修改。可以锁定微服务数据的数据库访问控制，仅允许该服务访问它。
- **独立的**一一微服务应用程序中的每个微服务可以独立于应用程序中使用的其他服务进行编译和部署。这意味着，与依赖更重的单体应用程序相比，这样对变化进行隔离和测试更容易。

## 2.1 架构师的故事：设计微服务架构

在构建微服务架构时，项目的架构师主要关注以下 3 个关键任务：

1. 分解业务问题
2. 建立服务粒度
3. 定义服务接口

### 2.1.1 分解业务问题

1. 描述业务问题，并聆听用来描述问题的名词。
2. 注意动词。动词突出了动作，通常代表问题域的自然轮廓。
3. 寻找数据内聚。

### 2.1.2 建立服务粒度

1. 开始的时候可以让微服务涉及的范围更广泛一些，然后将其重构到更小的服务
2. 重点关注服务如何相互交互
3. 随着对问题域的理解不断增长，服务的职责将随着时间的推移而改变

> **糟糕的微服务的“味道”**
>
> 过于粗粒度：
>
> - 服务承担过多的职责
> - 该服务正在跨大量表来管理数据
> - 测试用例太多
>
> 如果微服务过于细粒度：
>
> - 问题域的一部分微服务像兔子一样繁殖
> - 微服务彼此间严重相互依赖
> - 微服务成为简单 CRUD（Create、Read、Update、Delete） 服务的集合

### 2.1.3 互相交流：定义服务接口

1. 拥抱 REST 的理念
2. 使用 URI 来传达意图
3. 请求和响应使用 JSON
4. 使用 HTTP 状态码来传达结果

## 2.2 何时不应该使用微服务

考量因素：

1. 构建分布式系统的复杂性
2. 虚拟服务器 / 容器散乱
3. 应用程序的类型：小型的、部门级的应用程序或具有较小用户群的应用程序
4. 数据事务和一致性

## 2.3 开发人员的故事：用 Spring Boot 和 Java 构建微服务

1. 构建微服务的基本框架并构建应用程序的 Maven 脚本
2. 实现一个 Spring 引导类，它将启动用于微服务的 Spring 容器，并启动类的所有初始化工作。
3. 实现映射端点的 Spring Boot 控制器类，以公开服务的端点。

### 2.3.2 引导 Spring Boot 应用程序：编写引导类

我们的目标是在 Spring Boot 中运行一个简单的微服务，然后重复这个步骤以提供功能。为此，我们需要在微服务中创建以下两个类：

- 一个 Spring 引导类，可被 Spring Boot 用于启动和初始化应用程序。
- 一个 Spring 控制器类，用来公开可以被微服务调用的 HTTP 端点。



~~~java
package com.thoughtmechanix.licenses;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// @SpringBootApplication 告诉 Spring Boot 框架，这是项目的引导类。
@SpringBootApplication
public class Application {
    public static void main(String[] args){
        // 调用以启动整个 Spring Boot 服务
        SpringApplication.run(Application.class, args);
    }
}
~~~



引导类中注意的第一件事是 `@SpringBootApplication` 的用法。Spring Boot 用这个注解来告诉 Spring 容器，这个类是在 Spring 中使用的 bean 定义的源。

在 Spring Boot 应用程序中，可以通过以下方法定义 Spring Bean：

1. 用 `@Component`、`@Service` 或 `@Repository` 注解标签来标注一个 Java 类。
2. 用 `@Configuration` 注解标签来标注一个类，然后为每个我们想要构建的 Spring Bean 定义一个构造器方法并为方法添加上 `@Bean` 标签

在幕后，`@SpringBootApplication` 注解将代码清单中的 Application 类标记为配置类，然后开始自动扫描 Java 类路径上所有的类以形成其他的 Spring Bean。



第二件需要注意的是 Application 类的 `main()` 方法。在 `main()` 方法中，`SpringApplication.run(Application.class, args)` 调用启动了 Spring 容器，然后返回一个 Spring `ApplicationContext` 对象。

### 2.3.3 构建微服务的入口：Spring Boot 控制器

> **遵循 REST**
>
> - 使用 HTTP 作为服务的调用协议
> - 将服务的行为映射到标准 HTTP 动词
> - 使用 JSON 作为进出服务的所有数据的序列化格式
> - 使用 HTTP 状态码来传达服务调用的状态



~~~java
package com.thoughtmechanix.licenses.controllers;

// 为了简洁，省略了 import 语句

// @RestController 告诉 Spring Boot 这是一个基于 REST 的服务，它将自动序列化/反序列化服务请求/响应到 JSON
@RestController
// 在这个类中使用 /v1/organizations/{organizationId}/licenses 的前缀，公开所有 HTTP 端点
@RequestMapping(value = "/v1/organizations/{organizationId}/licenses")
public class LicenseServiceController {
    // 为了简洁，省略了该类的内容
}
~~~

我们通过查看 `＠RestController` 注解来开始探索。`@RestController` 是一个类级 Java 注解，它告诉 Spring 容器这个 Java 类将用于基于 REST 的服务。此注解自动处理以 JSON 或 XML 方式传递到服务中的数据的序列化（在默认情况下，`＠RestController` 类将返回的数据序列化为 JSON）。与传统的 Spring `@Controller` 注解不同，`＠RestController` 注解并不需要开发者从控制器类返回 `ResponseBody` 类。这一切都由 `＠RestController` 注解进行处理，它包含了 `＠ResponseBody` 注解。



> **为什么是JSON**
>
> 1. 与其他协议（如基于 XML 的 SOAP（Simple Object Access Protocol，简单对象访问协议））相比，它非常轻量级，可以在没有太多文本开销的情况下传递数据。
> 2. JSON 易于人们阅读和消费。
> 3. JSON 是 JavaScript 使用的默认序列化协议。
>
> 其他机制和协议能够比 JSON 更有效地在服务之间进行通信。Apache Thrift 框架允许构建使用二进制协议相互通信的多语言服务。Apache Avro 协议是一种数据序列化协议，可在客户端和服务器调用之间将数据转换为二进制格式。



代码清单中展示的第二个注解是 `@RequestMapping`。可以使用 `@RequestMapping` 作为类级注解和方法级注解。 `@RequestMapping` 注解用于告诉 Spring 容器该服务将要公开的 HTTP 端点。使用类级的 `@RequestMapping` 注解时，将为该控制器公开的所有其他端点建立 URL 的根。

`{organizationId}` 是一个占位符，表明如何使用在每个调用中传递的 `organizationId` 来参数化 URL。

~~~java
// 使用值创建一个 GET 端点 v1/organizations/{organizationId}/licenses/{licenseId}
@RequestMapping(value = "/{licenseId}", method = RequestMethod.GET)
public License getLicenses(
    @PathVariable("organizationId") String organizationId,
    @PathVariable("licenseId") String licenseId) { // 从 URL 映射两个参数（organizationId 和 licenseId）到方法参数
    return new License()
        .withId(licenseId)
        .withProductName("Teleco")
        .withLicenseType("Seat")
        .withOrganizationId("TestOrg");
}
~~~

这一代码清单中完成的第一件事是，使用方法级的 `@RequestMapping` 注解来标记 `getLicenses()` 方法，将两个参数传递给注解。通过方法级的 `@RequestMapping` 注解，再结合类顶部指定的根级注解，我们将所有传入该控制器的 HTTP 请求与端点 `v1/organizations/{organizationId}/licenses/{licenseId}` 匹配起来。该注解的第二个参数 `method` 指定该方法将匹配的 HTTP 动词。在前面的例子中，以 `RequestMethod.GET` 枚举的形式匹配 GET 方法。

`@PathVariable` 注解用于将传入的 URL 中传递的参数值（由 `{parameterName}` 语法表示）映射为方法的参数。



> **端点命名问题**
>
> 1. 使用明确的 URL 名称来确立服务代表的资源
> 2. 使用 URL 来确立资源之间的关系
> 3. 尽早建立 URL 的版本控制方案



## 2.4 DevOps 工程师的故事：构建运行时的严谨性

读者将基于 4 条原则开始微服务开发工作并根据这些原则去构建：

1. 微服务应该是独立的和可独立部署的，多个服务实例可以使用单个软件制品进行启动和拆卸。
2. 微服务应该是可配置的。当服务实例启动时，它应该从中央位置读取需要配置其自身的数据，或者让它的配置信息作为环境变量传递。配置服务无需人为干预。
3. 微服务实例需要对客户端是透明的。客户端不应该知道服务的确切位置。相反，微服务客户端应该与服务发现代理通信，该代理将允许应用程序定位微服务的实例，而不必知道微服务的物理位置
4. 微服务应该传达它的健康信息，这是云架构的关键部分。一旦微服务实例无法正常运行，客户端需要绕过不良服务实例。

从 DevOps 的角度来看，必须解决微服务的运维需求，并将这 4 条原则转化为每次构建和部署微服务到环境中时发生的一系列生命周期事件。这 4 条原则可以映射到运维生命周期步骤：

- **服务装配**——如何打包和部署服务以保证可重复性和一致’性，以便相同的服务代码和运行时被完全相同地部署？
- **服务引导**——如何将应用程序和环境特定的配置代码与运行时代码分开，以便可以在任何环境中快速启动和部署微服务实例，而无需对配置微服务进行人为干预？
- **服务注册 / 发现**——部署一个新的微服务实例时，如何让新的服务实例可以被其他应用程序客户端发现。
- **服务监控**——在微服务环境中，由于高可用性需求，同一服务运行多个实例非常常见。从 DevOps 的角度来看，需要监控微服务实例，并确保绕过微服务中的任何故障，而且状况不佳的服务实例会被拆卸。



> **构建 12-Factor 微服务应用程序**
>
> 本书最大的希望之一就是读者能意识到成功的微服务架构需要强大的应用程序开发和 DevOps 实践。这些做法中最简明扼要的摘要可以在 Heroku 的 12-Factor 应用程序宣言中找到。此文档提供了 12 种最佳实践，在构建微服务的时候应该始终将它们记在脑海中。在阅读本书时，读者将看到这些实践相互交织成例子。我将其总结如下。
>
> - **代码库**——所有应用程序代码和服务器供应信息都应该处于版本控制中。每个微服务都应在源代码控制系统内有自己独立的代码存储库。
> - **依赖**——通过构建工具，如 Maven（Java），明确地声明应用程序使用的依赖项。应该使用其特定版本号声明第三方 JAR 依赖，这样能够保证微服务始终使用相同版本的库来构建。
> - **配置**——将应用程序配置（特别是特定子环境的配置）与代码分开存储。应用程序配置不应与源代码在同一个存储库中。 
> - **后端服务**——微服务通常通过网络与数据库或消息系统进行通信。如果这样做，应该确保随时可以将数据库的实施从内部管理的服务换成第三方服务。第 10 章将演示如何将服务从本地管理的 Postgres 数据库移动到由亚马逊管理的数据库。
> - **构建、发布和运行**——保持部署的应用程序的构建、发布和运行完全分开。一旦代码被构建，开发人员就不应该在运行时对代码进行更改。饪何更改都需要回退到构建过程并重新部署。一个已构建服务是不可变的并且是不能被改变的
> - **进程**——微服务应该始终是无状态的。它们可以在任何超时时被杀死和替换，而不用担心一个服务实例的丢失会导致数据丢失。
> - **绑定**——微服务在打包的时候应该是完全独立的 ，可运行的微服务中要包含一个运行时引擎。运行服务时不需要单独的 Web 或应用程序服务器。服务应该在命令行上自行启动，并通过公开的 HTTP 端口立即访问。
> - **并发**——需要扩大时，不要依赖单个服务中的线程模型。相反，要启动更多的微服务实例并水平伸缩。这并不妨碍在微服务中使局线程，但不要将其作为伸缩的唯一机制。横向扩展而不是纵向扩展。
> - **可任意处置**——微服务是可任意处置的，可以根据需要启动和停止。应该最小化启动时间，当从操作系统收到 kill 信号时，进程应该正常关闭。
> - **开发环境与生产环境等同**一一最小化服务运行的所有环境（包括开发人员的台式机）之间存在的差距。开发人员应该在本地开发时使用与微服务运行相同的基础设施。这也意味着服务在环境之间部署的时间应该是数小时，而不是数周。代码被提交后，应该被测试，然后尽快从测试环境一直提升到生产环境。
> - **日志**——日志是一个事件流。当日志被写出时，它们应该可以流式传输到诸如 Splunk 或 Fluentd 这样的工具，这些工具将整理日志并将它们写入中央位置。微服务不应该关心这种情况发生的机制， 开发人员应该在它们被写出来的时候通过标准输出直观地查看日志。
> - **管理进程**——开发人员通常不得不针对他们的服务执行管理任务（数据移植或转换）。这些任务不应该是临时指定的， 而应该通过源代码存储库管理和维护的脚本来完成。这些脚本应该是可重复的，并且在每个运行的环境中都是不可变的（脚本代码不会针对每个环境进行修改）。

## 2.5 将视角综合起来

1. 架构师一一专注于业务问题的自然轮廓。描述业务问题域，并昕取别人所讲述的故事，按照这种方式，筛选出目标备选微服务。还要记住，最好从“粗粒度”的微服务开始，并重构到较小的服务，而不是从一大批小型服务开始。微服务架构像大多数优秀的架构一样，是按需调整的，而不是预先计划好的。
2. 软件工程师一一尽管服务很小，但并不意味着就应该把良好的设计原则抛于脑后。专注于构建分层服务，服务中的每一层都有离散的职责。避免在代码中构建框架的诱惑，并尝试使每个微服务完全独立。过早的框架设计和采用框架可能会在应用程序生命周期的后期产生巨大的维护成本。
3. DevOps 工程师一一服务不存在于真空中。尽早建立服务的生命周期。DevOps 视角不仅要关注如何自动化服务的构建和部署，还要关注如何监控服务的健康状况，并在出现问题时做出反应。实施服务通常需要比编写业务逻辑更多的工作，也更需要深谋远虑。

# 第3章 使用 Spring Cloud 配置服务器控制配置

基于云的微服务开发强调以下几点：

1. 应用程序的配置与正在部署的实际代码完全分离。
2. 构建服务器、应用程序以及一个不可变的镜像，它们在各环境中进行提升时永远不会发生变化。
3. 在服务器启动时通过环境变量注入应用程序配置信息，或者在微服务启动时通过集中式存储库读取应用程序配置信息。

## 3.1 管理配置（和复杂性）

应用程序配置管理的 4 条原则：

1. **分离**——我们希望将服务配置信息与服务的实际物理部署完全分开。应用程序配置不应与服务实例一起部署。相反，配置信息应该作为环境变量传递给正在启动的服务，或者在服务启动时从集中式存储库中读取。
2. **抽象**——将访问配置数据的功能抽象到一个服务接口中。应用程序使用基于 REST 的 JSON 服务来检索配置数据，而不是编写直接访问服务存储库的代码（也就是从文件或使用 JDBC 从数据库读取数据）。
3. **集中**——因为基于云的应用程序可能会有数百个服务，所以最小化用于保存配置信息的不同存储库的数量至关重要。将应用程序配置集中在尽可能少的数据库中。
4. **稳定**——因为应用程序的配置信息与部署的服务完全隔离并集中存放，所以不管采用何种方案实现，至关重要的一点就是保证其高可用和冗余。

### 3.1.1 配置管理架构

服务引导过程：

1. 当一个微服务实例出现时，它将调用一个服务端点来读取其所在环境的特定配置信息。配置管理的连接信息（连接凭据、服务端点等）将在微服务启动时被传递给微服务。
2. 实际的配置信息驻留在存储库中。基于配置存储库的实现，可以选择使用不同的实现来保存配置数据。配置存储库的实现选择可以包括源代码控制下的文件、关系数据库或键值数据存储。
3. 应用程序配置数据的实际管理与应用程序的部署方式无关。配置管理的更改通常通过构建和部署管道来处理，其中配置的更改可以通过版本信息进行标记，并通过不同的环境进行部署。
4. 进行配置管理更改时，必须通知使用该应用程序配置数据的服务，并刷新应用程序数据的副本。

### 3.1.2 实施选择

| 项目名称            | 描述                                                         | 特点                                                         |
| ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Etcd                | 使用 Go 开发的开源项目，用于服务发现和键值管理，使用 raft 协议作为它的分布式计算模型 | 非常快和可伸缩<br/>可分布式<br/>命令行驱动<br/>易于搭建和使用 |
| Eureka              | 由 Netflix 开发，久经测试，用于服务发现和键值管理            | 分布式键值存储<br/>灵活，需要费些功夫去设置<br/>提供开箱即用的动态客户端刷新 |
| Consul              | 由 Hashicorp 开发，特性上类似于 Etcd 和 Eureka，它的分布式计算模型使用了不同的算法（SWIM 协议） | 快速<br/>提供本地服务发现功能，可直接与 DNS 集成<br/>没有提供开箱即用的动态客户端刷新 |
| ZooKeeper           | 一个提供分布式锁定功能的 Apache 项目，经常用作访问键值数据的配置管理解决方案 | 最古老的、最久经测试的解决方案<br/>使用最为复杂<br/>可用作配置管理，但只有在其他架构中已经使用了 ZooKeeper 的时候才考虑使用它 |
| Spring Cloud Config | 一个开源项目，提供不同后端支持的通用配置管理解决方案。它可以将 Git、Eureka 和 Consul 作为后端进行整合 | 非分布式键值存储<br/>提供了对 Spring 和非 Spring 服务的紧密集成<br/>可以使用多个后端来存储配置数据，包括共享文件系统、Eureka、Consul 和 Git |

对于本章和本书其余部分的示例，都将使用 Spring Cloud 配置服务器。选择这个解决方案出于多种原因：

1. Spring Cloud 配置服务器易于搭建和使用。
2. Spring Cloud 配置与 Spring Boot 紧密集成。开发人员可以使用一些简单易用的注解来读取所有应用程序的配置数据。
3. Spring Cloud 配置服务器提供多个后端用于存储配置数据。如果读者已经使用了 Eureka 和 Consul 等工具，那么可以将它们直接插入 Spring Cloud 配置服务器中。
4. 上表所示的所有解决方案中，Spring Cloud 配置服务器可以直接与 Git 源控制平台集成。Spring Cloud 配置与 Git 的集成消除了解决方案的额外依赖，并使版本化应用程序配置数据成为可能。

## 3.2 构建 Spring Cloud 配置服务器

Maven 文件中，首先声明了要用于微服务的 Spring Boot 版本。

下一个重要的 Maven 定义部分是将要使用的 Spring Cloud Config 父物料清单（Bill of Materials, BOM）。

剩余部分负责声明将在服务中使用的特定 Spring Cloud 依赖项。

- 第一个依赖项是所有 Spring Cloud 项目使用的 `spring-cloud-starter-config`
- 第二个依赖项是 `spring-cloud-config-server` 起步项目，它包含了 spring-cloud-config-server 的核心库。

我们仍然需要再多创建一个文件来让核心配置服务器正常运行。这个文件是位于 confsvr/src/main/resources 目录中的 application.yml 文件。application.yml 文件告诉 Spring Cloud 配置服务要侦听哪个端口以及在哪里可以找到提供配置数据的后端。

在 Spring Cloud 配置中，一切都是按照层次结构进行的。应用程序配置由应用程序的名称表示。我们为需要拥有配置信息的每个环境提供一个属性文件。

在构建配置服务时，它将成为在环境中运行的另一个微服务。一旦建立配置服务，服务的内容就可以通过基于 HTTP 的 REST 端点进行访问。

应用程序配置文件的命名约定是“*应用程序名称-环境名称.yml*”。环境名称直接转换为可以浏览配置信息的URL（licensingservice.yml 转换为 /licensingservice/default，licensingservice-dev.yml 转换为 /licensingservice/dev）。随后，启动微服务时，要运行哪个服务环境是由在命令行服务启动时传入的 Spring Boot 的 profile 指定的。如果命令行上没有传入 profile，Spring Boot 将始终默认加载随应用程序打包的 application.yml 文件中的配置数据。

### 3.2.1 创建 Spring Cloud Config 引导类

~~~java
package com.thoughtmechanix.confsvr;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

// Spring Cloud Config 服务是 Spring Boot 应用程序，因此需要用 @SpringBoot Application 进行标记
@SpringBootApplication
// @EnableConfigServer 使服务成为 Spring Cloud Config 服务
@EnableConfigServer
public class ConfigServerApplication {
    public static void main(String[] args) {
        // main 方法启动服务并启动 Spring 容器
        SpringApplication.run(ConfigServerApplication.class, args);
    }
}
~~~

### 3.2.2 使用带有文件系统的 Spring Cloud 配置服务器

~~~yaml
server:
	port: 8888 # Spring Cloud 配置服务器将要监听的端口
spring:
	profiles:
		active: native # 用于存储配置的后端存储库（文件系统）
	cloud:
		config:
			server:
				native:
					searchLocations: file:///Users/johncarnell1/book/spmia-code/chapter3-code/confsvr/src/main/resources/config/licensingservice # 配置文件存储位置的路径
~~~

使用 `mvn spring-boot:run` 命令启动配置服务器。服务器现在应该在命令行上出现一个 Spring Boot 启动画面。

如果用浏览器访问 http://localhost:8888/licensingservice/default，那么将会看到 JSON 净荷与 licensingservice.yml 文件中包含的所有属性一起返回。

如果想要查看基于开发环境的许可证服务的配置信息，可以对 http://localhost:8888/licensingservice/dev 端点发起 GET 请求。

请求特定环境的 profile 时，将返回所请求的 profile 和默认的 profile。Spring Cloud 配置返回两组配置信息的原因是，Spring 框架实现了一种用于解析属性的层次结构机制。当 Spring 框架执行属性解析时，它将始终先查找默认属性中的属性，然后用特定环境的值（如果存在）去覆盖默认属性。

## 3.3 将 Spring Cloud Config 与 Spring Boot 客户端集成

在下一个示例中，我们将构建许可证服务，并与持有许可证数据的 Postgres 数据库进行交流。

我们将使用 Spring Data 与数据库进行通信，并将数据从许可证表映射到保存数据的 POJO。数据库连接和一条简单的属性将从 Spring Cloud 配置服务器中读出。

1. **将 Spring Profile 和端点信息传递给许可证服务**：当许可证服务首次启动时，将通过命令行传递两条信息，Spring 的 profile 和许可证服务用于与 Spring Cloud 配置服务通信的端点。Spring 的 profile 值映射到为 Spring 服务检索属性的环境。
2. **许可证服务联系 Spring Cloud 配置服务**：当许可证服务首次启动时，它将通过从 Spring 的 profile 传入构建的端点与 Spring Cloud Config 服务进行联系。
3. **从存储库检索特定 profile 的配置信息**：然后，Spring Cloud Config 服务将会根据 URI 上传递过来的特定 Spring profile，使用已配置的后端配置存储库（文件系统、Git、Consul 或 Eureka）来检索相应的配置信息。
4. **属性值传回给许可证服务**：然后将适当的属性值传回许可证服务。接着，Spring Boot 框架将这些值注入应用程序的相应部分。

### 3.3.1 建立许可证服务对 Spring Cloud Config 服务器的依赖

第一个和第二个依赖项 `spring-boot-starter-data-jpa` 和 `postgresql` 导入了 Spring Data Java Persistence API（JPA） 和 Postgres JDBC 驱动程序。最后一个依赖项是 `spring-cloud-config-client`，它包含与 Spring Cloud 配置服务器交互所需的所有类。

### 3.3.2 配置许可证服务以使用 Spring Cloud Config

在定义了 Maven 依赖项后，需要告知许可证服务在哪里与 Spring Cloud 配置服务器进行联系。在使用 Spring Cloud Config 的 Spring Boot 服务中，配置信息可以在 bootstrap.yml 和 application.yml 这两个配置文件之一中设置。

在其他所有配置信息被使用之前，bootstrap.yml 文件要先读取应用程序属性。一般来说，bootstrap.yml 文件包含服务的应用程序名称、应用程序 profile 和连接到 Spring Cloud Config 服务器的 URI。

要使许可证服务与 Spring Cloud Config 服务进行通信，需要添加一个 licensing-service/src/main/resources/bootstrap.yml 文件，并设置 3 个属性，即 `spring.application.name`、`spring.profiles.active` 和 `spring.cloud.config.uri`。

~~~yaml
spring:
	application:
		name: licensingservice # 指定许可证服务的名称，以便 Spring Cloud Config 客户端知道正在查找哪个服务
	profiles:
		active: default # 指定服务应该运行的默认 profile，profile 映射到环境
	cloud:
		config:
			uri: http://localhost:8888 # 指定 Spring Cloud Config 服务器的位置
~~~

> **注意**
>
> Spring Boot 应用程序支持两种定义属性的机制：YAML（Yet another Markup Language）和使用“.”分隔的属性名称。我们选择 YAML 作为配置应用程序的方法。YAML 属性值的分层格式直接映射到 `spring.application.name`、`spring.profiles.active` 和 `spring.cloud.config.uri` 名称。

如果要覆盖这些默认值并指向另一个环境，可以通过将许可证服务项目编译到 JAR，然后使用 -D 系统属性来运行这个 JAR 来实现。下面的命令行演示了如何使用非默认 profile 启动许可证服务：

~~~sh
java -Dspring.cloud.config.uri=http://localhost:8888 \
-Dspring.cprofiles.active=dev \
-jar target/licensing-service-0.0.1-SNAPSHOT.jar
~~~

> **使用环境变量传递启动信息**
>
> 在这些示例中，将这些值硬编码传递给 -D 参数值。在云众所需的大部分应用程序配置数据都将位于配置服务器中。但是，对于启动服务所需的信息（如配置服务器的数据），则需要启动 VM 实例或 Docker 容器并传入环境变量。
>
> 在由容器运行的启动脚本中，我们将这些环境变量以 -D 参数传递到启动应用程序的 JVM。在每个项目中，可以制作一个 Docker 容器，然后该 Docker 容器使用启动脚本启动该容器中的软件。

### 3.3.3 使用 Spring Cloud 配置服务器连接数据源

License 类是模型类，它将持有从许可证数据库检索的数据。

~~~java
package com.thoughtmechanix.licenses.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

// @Entity 注解告诉 Spring 这是一个 JPA 类
@Entity
// @Table 映射到数据库的表
@Table(name = "licenses")
public class License {
    // @Id 将该字段标记为主键
    @Id
    // @Column 将该字段映射到特定数据库表中的列
    @Column(name = "license_id", nullable = false)
    private String licenseId;
    
    @Column(name = "organization_id", nullable = false)
    private String organizationId;
    
    @Column(name = "product_name", nullable = false)
    private String productName;
    
    /* 为了简介，省略了其余的代码 */
}
~~~

Spring Data 和 JPA 框架提供访问数据库的基本 CRUD 方法。如果要构建其他方法，可以使用 Spring Data 存储库接口和基本命名约定来进行构建。Spring 将在启动时从 Repository 接口解析方法的名称，并将它们转换为基于名称的 SQL 语句，然后在幕后生成一个动态代理类来完成这项工作。

~~~java
package com.thoughtmechanix.licenses.repository;

import com.thoughtmechanix.licenses.model.License;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

// 告诉 Spring Boot 这是一个 JPA 存储器类
@Repository
// 定义正在扩展 Spring CrudRepository
public interface LicenseRepository extends CrudRepository<License, String> {
    // 每个查询方法被 Spring 解析为 SELECT ... FROM 查询
    public List<License> findByOrganizationId(String organizationId);
    public License findByOrganizationIdAndLicenseId(String organizationId, String licenseId);
}
~~~

存储库接口 `LicenseRepository` 用 `@Repository` 注解标记，这个注解告诉 Spring 应该将这个接口视为存储库并为它生成动态代理。Spring 提供不同类型的数据访问存储库。我们选择使用 Spring `CrudRepository` 基类来扩展 `LicenseRepository` 类。`CrudRepository` 基类包含基本的 CRUD 方法。除了从 `CrudRepository` 扩展的 CRUD 方法外，我们还添加了两个用于从许可表中检索数据的自定义查询方法。Spring Data 框架将拆开这些方法的名称以构建访问底层数据的查询。

> **注意**
>
> Spring Data 框架提供各种数据库平台上的抽象层，并不仅限于关系数据库。该框架还支持 NoSQL 数据库，如 MongoDB 和 Cassandra。

与第 2 章中的许可证服务不同，我们现在已将许可证服务的业务逻辑和数据访问逻辑从 `LicenseController` 中分离出来，并划分在名为 `LicenseService` 的独立服务类中。

~~~java
package com.thoughtmechanix.licenses.services;

import com.thoughtmechanix.licenses.config.ServiceConfig;
import com.thoughtmechanix.licenses.model.License;
import com.thoughtmechanix.licenses.repository.LicenseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.UUID;

@Service
public class LicenseService {
    @Autowired
    private LicenseRepository licenseRepository;
    
    @Autowired
    ServiceConfig config;
    
    public License getLicense(String organizationId, String licenseId) {
        License license = licenseRepository.findByOrganizationIdAndLicenseId(organizationId, licenseId);
        return license.withComment(config.getExampleProperty());
    }
    
    public List<License> getLicensesByOrg(String organizationId) {
        return licenseRepository.findByOrganizationId(organizationId);
    }
    
    public void saveLicense(License license) {
        license.withId(UUID.randomUUID().toString());
        licenseRepository.save(license);
    }
    /*为了简洁，省略了其余的代码*/
}
~~~

### 3.3.4 使用 @Value 注解直接读取属性

上一节的 `LicenseService` 类中，读者可能已经注意到，在 `getLicense()` 中使用了来自 `config.getExampleProperty()` 的值来设置 `license.withComment()` 的值。

如果查看 ServiceConfig.java 代码，将看到使用 @Value 注解标注的属性。

~~~java
package com.thoughtmechanix.licenses.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class ServiceConfig {
    @Value("${example.property}")
    private String exampleProperty;
    
    public String getExampleProperty() {
        return exampleProperty;
    }
}
~~~

虽然 Spring Data “自动神奇地”将数据库的配置数据注入数据库连接对象中，但所有其他属性都必须使用 `@Value` 注解进行注入。

> **提示**
>
> 虽然可以将配置的值直接注入各个类的属性中，但我发现将所有配置信息集中到一个配置类，然后将配置类注入需要它的地方是很有用的。

### 3.3.5 使用 Spring Cloud 配置服务器和 Git

要使用 Git，需要在配置服务的 bootstrap.yml 文件中使用代码清单所示的配置替换文件系统的配置。

~~~yaml
server:
	port: 8888
spring:
	cloud:
		config:
			server:
				git: # 告诉 Spring Cloud Config 使用 Git 作为后端存储库
					# 告诉 Spring Cloud Git 服务器和 Git 存储库的 URL
					uri: https://github.com/carnellj/config-repo/ 
					# 告诉 Spring Cloud Config 在 Git 中查找配置文件的相对路径
					searchPaths: licensingservice,organizationservice
					username: native-cloud-apps
					password: Offended
~~~

### 3.3.6 使用 Spring Cloud 配置服务器刷新属性

Spring Boot Actuator 提供了一个 `@RefreshScope` 注解，允许开发团队访问 `/refresh` 端点，这会强制 Spring Boot 应用程序重新读取应用程序配置。

~~~java
package com.thoughtmechanix.licenses;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.context.config.annotation.RefreshScope;

@SpringBootApplication
@RefreshScope
public class Application {
    public static void main(String[] args){
        SpringApplication.run(Application.class, args);
    }
}
~~~

我们需要注意一些有关 `@RefreshScope` 注解的事情。首先，注解只会重新加载应用程序配置中的自定义 Spring 属性。Spring Data 使用的数据库配置等不会被 `@RefreshScope` 注解重新加载。要执行刷新，可以访问 `http://<yourserver>:8080/refresh` 端点。

> **关于刷新微服务**
>
> 将微服务与 Spring Cloud 配置服务一起使用时，在动态更改属性之前需要考虑的一件事是，可能会有同一服务的多个实例正在运行，需要使用新的应用程序配置刷新所有这些服务。有几种方法可以解决这个问题。
>
> - Spring Cloud 配置服务确实提供了一种称为 Spring Cloud Bus 的“推送”机制，使 Spring Cloud 配置服务器能够向所有使用服务的客户端发布有更改发生的消息。Spring Cloud 配置需要一个额外的中间件（RabbitMQ）运行。这是检测更改的非常有用的手段，但并不是所有的 Spring Cloud 配置后端都支持这种“推送”机制（也就是 Consul 服务器）。
> - 在下一章中，我们将使用 Spring Service Discovery 和 Eureka 来注册所有服务实例。我用过的用于处理应用程序配置刷新事件的一种技术是，刷新 Spring Cloud 配置中的应用程序属性，然后编写一个简单的脚本来查询服务发现引擎以查找服务的所有实例，并直接调用 `/refresh` 端点。
> - 最后一种方法是重新启动所有服务器或容器来接收新的属性。这项工作很简单，特别是在 Docker 等容器服务中运行服务时。重新启动 Docker 容器差不多需要几秒，然后将强制重新读取应用配置。
>
> 记住，基于云的服务器是短暂的。不要害怕使用新配置启动服务的新实例，直接使用新服务，然后拆除旧的服务。

## 3.4 保护敏感的配置信息

Spring Cloud Config 可以让我们轻松加密敏感属性。Spring Cloud Config 支持使用对称加密（共享密钥）和非对称加密（公钥 / 私钥）。

1. **下载并安装加密所需的 Oracle JCE jar**：Oracle 的不限长度的 Java 加密扩展（Unlimited Strength Java Cryptography Extension，JCE）
2. **创建加密密钥**：使用 Spring Cloud 配置服务器，对称加密密钥是通过操作系统环境变量 `ENCRYPT_KEY` 传递给服务的字符串。对称密钥的长度应该是12个或更多个字符，最好是一个随机字符集。不要丢失对称密钥。
3. **加密和解密属性**：在启动实例时，Spring Cloud Config 将检测到环境变量 `ENCRYPT_KEY` 已设置，并自动将两个新端点（`/encrypt` 和 `/decrypt`）添加到 Spring Cloud Config 服务。确保对两个端点进行 POST 请求。
   Spring Cloud 配置服务器要求所有已加密的属性前面加上 `{cipher}`。`{cipher}` 告诉 Spring Cloud 配置服务器它正在处理已加密的值。
   默认情况下，Spring Cloud Config 将在服务器上解密所有属性，并将未加密的纯文本作为结果回传给请求属性的应用程序。但是开发人员可以告诉 Spring Cloud Config 不要在服务器上进行解密，并让应用程序负责检索配置数据以解密已加密的属性。
4. **配置微服务以在客户端使用加密**
   1. 配置 Spring Cloud Config 的 src/main/resources/application.yml 文件中的 `spring.cloud.config.server.encrypt.enabled` 属性为 `false` 以禁用服务端的属性解密。
   2. 在许可证服务器上设置对称密钥。
   3. 将 `spring-security-rsa` JAR 添加到许可证服务的 pom.xml 文件中。

## 3.5 最后的想法

传统部署模型中，开发人员会将应用程序制品（如 JAR 或 WAR 文件）连同它的属性文件一起部署到一个“固定的”环境中。

使用基于云的模型，应用程序配置数据应该与应用程序完全分离，并在运行时注入相应的配置数据，以便在所有环境中一致地提升相同的服务器和应用程序制品。

# 第4章 服务发现