# 第1章 微服务的发展史

## 1.1 从单体架构到分布式架构的演进

### 1.1.1 单体架构

通常来说，如果一个 war 包或者 jar 包里面包含一个应用的所有功能，则我们称这种架构为单体架构。

### 1.1.2 集群及垂直化

业务场景越多越复杂，意味着 war 包中的代码量会持续上升，并且各个业务代码之间的耦合度也会越来越高，后期的代码维护和版本发布涉及的测试和上线，也会很困难。

我们可以从两个方面进行优化：

1. 通过横向增加服务器，把单台机器变成多台机器的集群。
2. 按照业务的垂直领域进行拆分，减少业务的耦合度，以及降低单个 war 包带来的伸缩性困难问题。

针对数据库进行垂直分库，主要是考虑到 Tomcat 服务器能够承载的流量大了之后，如果流量都传导到数据库上，会给数据库造成比较大的压力。

### 1.1.3 SOA

SOA（Service-Oriented Architecture），面向服务的架构。核心目标是把一些通用的、会被多个上层服务调用的共享业务提取成独立的基础服务，这些被提取出来的共享服务相对来说比较独立，并且可以重用。所以在 SOA 中，服务是最核心的抽象手段，业务被划分为一些粗粒度的业务服务和业务流程。

在 SOA 中，会采用 ESB（企业服务总线）来作为系统和服务之间的通信桥梁，ESB 本身还提供服务地址的管理、不同系统之间的协议转化和数据格式的转化等。调用端不需要关心目标服务的位置，从而使得服务之间的交互是动态的，这样做的好处是实现了服务的调用者和服务的提供者之间的高度解耦。

SOA 主要解决的问题是：

- 信息孤岛
- 共享业务的重用

### 1.1.4 微服务架构

从名字上看，面向对象（SOA）和微服务本质上都是服务化思想的一种体现。如果 SOA 是面向服务开发思想的雏形，那么微服务就是针对可重用业务服务的更进一步优化，我们可以把 SOA 看成微服务的超集，也就是多个微服务可以组成一个 SOA 服务。

实施微服务的前提是软件交付链路及基础设施的成熟化。

由于 SOA 和微服务两者的关注点不一样，造成了这两者有非常大的区别：

- SOA 关注的是服务的重用性及解决信息孤岛问题。
- 微服务关注的是解耦，虽然解耦和可重用性从特定角度来看是一样的，但本质上是有区别的，解耦是降低业务之间的耦合度，而重用关注的是服务的复用。
- 微服务会更多地关注在 DevOps 的持续交付上，因为服务粒度细化之后使得开发运维变得更加重要，因此微服务与容器化技术的结合更加紧密。

## 1.2 微服务架构带来的挑战

### 1.2.1 微服务架构的优点

- **复杂度可控**：通过对共享业务服务更细粒度的拆分，一个服务只需要关注一个特定的业务领域，并通过定义良好的接口清晰表述服务边界。由于体积小、复杂度低，开发、维护会更加简单。
- **技术选型更灵活**：每个微服务都由不同的团队来维护，所以可以结合业务特性自由选择技术栈。
- **可扩展性更强**：可以根据每个微服务的性能要求和业务特点来对服务进行灵活扩展，比如通过增加单个服务的集群规模，提升部署了该服务的节点的硬件配置。
- **独立部署**：由于每个微服务都是一个独立运行的进程，所以可以实现独立部署。当某个微服务发生变更时不需要重新编译部署整个应用，并且单个微服务的代码量比较小，使得发布更加高效。
- **容错性**：在微服务架构中，如果某一个服务发生故障，我们可以使故障隔离在单个服务中。其他服务可以通过重试、降级等机制来实现应用层面的容错。

### 1.2.2 微服务架构面临的挑战

- **故障排除**：一次请求可能会经历多个不同的微服务的多次交互，交互的链路可能会比较长，每个微服务会产生自己的日志，在这种情况下如果出现一个故障，开发人员定位问题的根源会比较困难。
- **服务监控**：在一个单体架构中很容易实现服务的监控，因为所有的功能都在一个服务中。在微服务架构中，服务监控开销会非常大，可以想象一下，在几百个微服务组成的架构中，我们不仅要对整个链路进行监控，还需要对每个微服务都实现一套类似单体架构的监控。
- **分布式架构的复杂性**：微服务本身构建的是一个分布式系统，分布式系统涉及服务之间的远程通信，而网络通信中网络的延迟和网络故障是无法避免的，从而增加了应用程序的复杂度。
- **服务依赖**：微服务数量增加之后，各个服务之间会存在更多的依赖关系，使得系统整体更为复杂。
- **运维成本**：在微服务中，需要保证几百个微服务的正常运行，对于运维的挑战是巨大的。比如单个服务流量激增时如何快速扩容、服务拆分之后导致故障点增多如何处理、如何快速部署和统一管理众多的服务等。

## 1.3 如何实现微服务架构

### 1.3.2 微服务架构下的技术挑战

- 分布式配置中心
- 服务路由
- 负载均衡
- 熔断限流
- 链路监控

# 第2章 微服务解决方案之 Spring Cloud

## 2.1 什么是 Spring Cloud

简单地说，Spring Cloud 提供了一些可以让开发者快速构建微服务应用的工具，比如配置管理、服务发现、熔断、智能路由等，这些服务可以在任何分布式环境下很好地工作。Spring Cloud 主要致力于解决如下问题：

- 分布式及版本化配置。
- 服务注册与发现
- 服务路由
- 服务调用
- 负载均衡
- 断路器
- 全局锁
- Leader 选举及集群状态
- 分布式消息

需要注意的是，Spring Cloud 并不是 Spring 团队全新研发的框架，它只是把一些比较优秀的解决微服务架构中常见问题的开源框架基于 Spring Cloud 规范进行了整合，通过 Spring Boot 这个框架进行再次封装后屏蔽掉了复杂的配置，给开发者提供良好的开箱即用的微服务开发体验。

不难看出，Spring Cloud 其实就是一套规范，而 Spring Cloud Netflix、Spring Cloud Consul、Spring Cloud Alibaba 才是 Spring Cloud 规范的实现。

## 2.2 Spring Cloud 版本简介

采用了伦敦地铁站的名字根据字母表的顺序结合对应版本的时间顺序来定义大版本。

Spring Cloud 的每个大版本通过 BOM （Bill Of Materials）来管理每个子项目的版本清单。

Spring Cloud 项目的发布内容积累到一个临界点或者解决一些严重的Bug后，会发布一个 Service Release 的版本，简称为 SR + 一个递增的数字

值得注意的是，Spring Cloud 中所有子项目都依赖 Spring Boot 框架，所以 Spring Boot 框架的版本号和 Spring Cloud 的版本号之间也存在依赖及兼容的关系。

## 2.3 Spring Cloud 规范下的实现

在 Spring Cloud 这个规范下，有很多实现：

- Spring-Cloud-Bus
- Spring-Cloud-Netflix
- Spring-Cloud-Zookeeper
- Spring-Cloud-Gateway

在这些实现中，绝大部分组件都使用“别人已经造好的轮子”，然后基于 Spring Cloud 规范进行整合，使用者只需要使用非常简单的配置即可完成微服务架构下复杂的需求。

这也是 Spring 团队最厉害的地方，它们很少重复造轮子。回想一下，最早的 Spring Framework，它只提供了 IoC 和 AOP 两个核心功能，对于 ORM、MVC 等其他的功能，Spring 都提供非常好的兼容性，比如 Hibernate、MyBatis、Struts 2。

只有在别人提供的东西不够好的情况下，Spring 团队才会考虑自己研发。比如 Struts 2 经常有安全漏洞，所以 Spring 团队自己研发了 Spring MVC 框架，并且成了现在非常主流的 MVC 框架。再比如 Spring Cloud Netflix 中的 Zuul 网关，因为性能及版本迭代较慢，所以 Spring 团队孵化了一个 Spring Cloud Gateway 来取代 Zuul。

Spring Cloud 生态下服务治理的解决方案主要有两个： Spring Cloud Netflix 和 Spring Cloud Alibaba。

## 2.4 Spring Cloud Netflix

包括以下组件：

- Eureka，服务注册与发现
- Zuul，服务网关
- Ribbon，负载均衡
- Feign，远程服务的客户端代理
- Hystrix，断路器，提供服务熔断和限流功能
- Hystrix Dashboard，监控面板
- Turbine，将各个服务实例上的 Hystrix 监控信息进行统一聚合

Spring Cloud Netflix 是 Spring Boot 和 Netflix OSS 在 Spring Cloud 规范下的集成。其中，Netflix OSS（Netflix Open Source Software）是由 Netflix 公司开发的一套开源框架和组件库，Eureka、Zuul 等都是 Netflix OSS 中的开源组件。

Netflix OSS 本身是一套非常好的组件，由于 Netflix 对 Zuul 1、Ribbon、Archaius 等组件的维护不利，Spring Cloud 决定在 Greenwich 中将如下项目都改为“维护模式”：

- Spring-Cloud-Netflix-Hystrix
- Spring-Cloud-Netflix-Ribbon
- Spring-Cloud-Netflix-Zuul

| 当前                        | 替换                                              |
| --------------------------- | ------------------------------------------------- |
| Hystrix                     | Resilience4j                                      |
| Hystrix Dashboard / Turbine | Micrometer + Monitoring System                    |
| Ribbon                      | Spring Cloud Loadbalancer                         |
| Zuul 1                      | Spring Cloud Gateway                              |
| Archaius 1                  | Spring Boot external config + Spring Cloud Config |

## 2.5 Spring Cloud Alibaba

以下是 Spring Cloud Alibaba 生态下的主要功能组件，这些组件包含开源组件和阿里云产品组件，云产品是需要付费使用的：

- Sentinel，流量控制和服务降级
- Nacos，服务注册与发现
- Nacos，分布式配置中心
- RocketMQ，消息驱动
- Seate，分布式事务
- Dubbo，RPC 通信
- OSS，阿里云对象存储（收费的云服务）

### 2.5.1 Spring Cloud Alibaba 的优势

- Alibaba 的开源组件在没有织入 Spring Cloud 生态之前，已经在各大公司广泛应用，所以集成到 Spring Cloud 生态使得开发者能够很轻松地实现技术整合及迁移。
- Alibaba 的开源组件在服务治理上和处理高并发的能力上有天然的优势，毕竟这些组件都经历过数次双11的考验，也在各大互联网公司大规模应用过。所以，相比 Spring Cloud Netflix 来说，Spring Cloud Alibaba 在服务治理这块的能力更适合国内的技术场景，同时，Spring Cloud Alibaba 在功能上不仅完全覆盖了 Spring Cloud Netflix 原生特性，而且还提供了更加稳定和成熟的实现。

# 第3章 Spring Cloud 的核心之 Spring Boot

Spring Boot 是帮助开发者快速构建一个基于 Spring Framework 及 Spring 生态体系的应用解决方案，也是 Spring Framework 对于“约定优于配置（Convention over Configuration）”理念的最佳实践。

## 3.1 重新认识 Spring Boot

Spring 是一个轻量级框架，它的主要目的是简化 JavaEE 的企业级应用开发，而达到这个目的的两个关键手段是 IoC/DI 和 AOP。除此之外，Spring 就像一个万能胶，对 Java 开发中的常用技术进行合理的封装和设计，使之能够快速方便地集成和开发，比如 Spring 集成 MyBatis、Spring 集成 Struts 等。

### 3.1.1 Spring IoC / DI

IoC（Inversion of Control）和 DI（Dependency Injection）的全称分别是控制反转和依赖注入。

IoC（控制反转）实际上就是把对象的生命周期托管到 Spring 容器中，而反转是指对象的获取方式被反转了。传统意义上的对象的创建是通过 new 来构建，这种方式会使代码之间的耦合度非常高。当使用 Spring IoC 容器之后，是直接从 IoC 容器中获得。

Spring IoC 容器中的对象的构建时机，在早期的Spring中，主要通过 XML 的方式来定义 Bean，Spring 会解析 XML 文件，把定义的 Bean 装载到 IoC 容器中。

DI（Dependency Inject），也就是依赖注入，简单理解就是 IoC 容器在运行期间，动态地把某种依赖关系注入组件中。

实现依赖注入的方法有三种，分别是接口注入、构造方法注入和 setter 方法注入。不过现在基本都基于注解的方式来描述 Bean 之间的依赖关系，比如 @Autowired、@Inject 和 @Resource。但是不管形式怎么变化，本质上还是一样的。

### 3.1.2 Bean 装配方式的升级

基于 XML 配置的方式很好地完成了对象声明周期的描述和管理，但是随着项目规模不断扩大，XML 的配置也逐渐增多，使得配置文件难以管理。另一方面，项目中的依赖关系越来越复杂，配置文件变得难以理解。

随着 JDK 1.5 带来的注解支持，Spring 从 2.x 开始，可以使用注解的方式来对 Bean 进行声明和注入，大大减少了 XML 的配置量。

Spring 升级到 3.x 后，提供了 JavaConfig 的能力，它可以完全取代 XML，通过 Java 代码的方式来完成 Bean 的注入。

虽然通过注解的方式来装配 Bean，可以在一定程度上减少 XML 配置带来的问题，本质问题仍然没有解决，比如：

- 依赖过多。Spring 可以整合几乎所有常用的技术框架，比如 JSON、MyBatis、Redis、Log 等，不同依赖包的版本很容易导致版本兼容问题。
- 配置过多。以 Spring 使用 JavaConfig 方式整合 MyBatis 为例，需要配置注解驱动、配置数据源、配置 MyBatis、配置事务管理器等，这些只是集成一个技术组件需要的基础配置，在一个项目中这类配置很多，开发者需要做很多类似的重复工作。
- 运行和部署很繁琐。需要先把项目打包，再部署到容器上。

### 3.1.3 Spring Boot 的价值

Spring Boot 并不是一个新的技术框架，其主要作用就是简化 Spring 应用的开发，开发者只需要通过少量的代码就可以创建一个产品级的 Spring 应用，而达到这一目的的最核心的思想就是“约定优于配置（Convention over Configuration）”。

约定优于配置（Convention over Configuration）是一种软件设计范式，目的在于减少配置的数量或者降低理解难度，从而提升开发效率。

在 Spring Boot 中，约定优于配置的思想主要体现在以下方面（包括但不限于）：

- Maven 目录结构的约定
- Spring Boot 默认的配置文件及配置文件中配置属性的约定
- 对于 Spring MVC 的依赖，自动依赖内置的 Tomcat 容器
- 对于 Starter 组件自动完成装配

Spring Boot 是基于 Spring Framework 体系来构建的，所以它并没有什么新东西，它的核心是：

- Starter 组件，提供开箱即用的组件
- 自动装配，自动根据上下文完成 Bean 的装配
- Actuator，Spring Boot 应用的监控
- Spring Boot CLI，基于命令行工具快速构建 Spring Boot 应用

其中，最核心的部分应该是自动装配，Starter 组件的核心部分也是基于自动装配来实现的。

## 3.2 快速构建 Spring Boot 应用

构建完成后，会包含以下核心配置和类：

- Spring Boot 的启动类 SpringBootDemoApplication
- resource 目录，包含 static 和 templates 目录，分别存放静态资源及前端模板，以及 application.properties 配置文件。
- Web 项目的 starter 依赖包

以往我们使用 Spring MVC 来构建一个 Web 项目需要很多基础操作：添加很多的 Jar 包依赖、在 web.xml 中配置控制器、配置 Spring 的 XML 文件或者 JavaConfig 等。而 Spring Boot 帮开发者省略了这些繁琐的基础性工作，使得开发者只需要关注业务本身，基础性的装配工作是由 Starter 组件及自动装配来完成的。

## 3.3 Spring Boot 自动装配的原理

在 Spring Boot 中，自动装配是 Starter 的基础，也是 Spring Boot 的核心。简单来说，它就是自动将 Bean 装配到 IoC 容器中，接下来，我们通过一个 Spring Boot 整合 Redis 的例子来了解一下自动装配。

- 添加 Starter 依赖

  ~~~xml
  <dependency>
  	<groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-redis</artifactId>
  </dependency>
  ~~~

- 在 application.properties 中配置 Redis 的数据源：

  ~~~properties
  spring.redis.host=localhost
  spring.redis.port=6379
  ~~~

- 在 HelloController 中使用 RedisTemplate 实现 Redis 的操作：

  ~~~java
  @RestController
  public class HelloController {
      @Autowired
      RedisTemplate<String, String> redisTemplate;
      @GetMapping("/hello")
      public String hello() {
          redisTemplate.opsForValue().set("key","value");
          return "Hello World";
      }
  }
  ~~~

在这个案例中，我们并没有通过 XML 形式或者注解形式把 RedisTemplate 注入 IoC 容器中，但是在 HelloController 中却可以直接使用 @Autowired 来注入 redisTemplate 实例，这就说明，IoC 容器中已经存在 RedisTemplate。这就是 Spring Boot 的自动装配机制。

### 3.3.1 自动装配的实现

自动装配在 Spring Boot 中是通过 @EnableAutoConfiguration 注解来开启的，这个注解的声明在启动类注解 @SpringBootApplication 内。

~~~java
@SpringBootApplication
public class SpringBootDemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(SpringBootDemoApplication.class, args);
    }
}
~~~

进入 @SpringBootApplication 注解，可以看到 @EnableAutoConfiguration 注解的声明。

~~~java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan(excludeFilters = {
    @Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class),
    @Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class)
})
public @interface SpringBootApplication {
}
~~~

其实 Spring 3.1 版本就已经支持 @Enable 注解了，它的主要作用把相关组件的 Bean 装配到 IoC 容器中。@Enable 注解对 JavaConfig 的进一步完善，为使用 Spring Framework 的开发者减少了配置代码量，降低了使用的难度。比如常见的 @Enable 注解有 @EnableWebMvc、@EnableScheduling 等。

在前面的章节中讲过，如果基于 JavaConfig 的形式来完成 Bean 的装载，则必须要使用 @Configuration 注解及 @Bean 注解。而 @Enable 本质上就是针对这两个注解的封装，所以大家如果仔细关注过这些注解，就不难发现这些注解都会携带一个 @Import 注解，比如 @EnableScheduling：

~~~java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Import({SchedulingConfiguration.class})
@Documented
public @interface EnableScheduling {
}
~~~

因此，使用 @Enable 注解后，Spring 会解析到 @Import 导入的配置类，从而根据这个配置类中的描述来实现 Bean 的装配。

### 3.3.2 EnableAutoConfiguration

进入 @EnableAutoConfiguration 注解里，可以看到除 @Import 注解之外，还多了一个 @AutoConfigurationPackage 注解（它的作用是把使用了该注解的类所在的包及子包下所有组件扫描到 Spring IoC 容器中）。并且，@Import 注解中导入的并不是一个 Configuration 的配置类，而是一个 AutoConfigurationImportSelector 类。

~~~java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@AutoConfigurationPackage
@Import(AutoConfigurationImportSelector.class)
public @interface EnableAutoConfiguration
~~~

### 3.3.3 AutoConfigurationImportSelector

AutoConfigurationImportSelector 实现了 ImportSelector，它只有一个 selectImports 抽象方法，并且返回一个 String 数组，在这个数组中可以指定需要装配到 IoC 容器的类，当在 @Import 中导入一个 ImportSelector 的实现类之后，会把该实现类中返回的 Class 名称都装载到 IoC 容器中。

~~~java
public interface ImportSelector {
    String[] selectImports(AnnotationMetadata var1);
}
~~~

和 @Configuration 不同的是，ImportSelector 可以实现批量装配，并且还可以通过逻辑处理来实现 Bean 的选择性装配，也就是可以根据上下文来决定哪些类能够被 IoC 容器初始化。



通过一个简单的例子了解 ImportSelector 的使用。

- 首先创建两个类，我们需要把这两个类装配到 IoC 容器中。

  ~~~java
  public class FirstClass {}
  public class SecondClass {}
  ~~~

- 创建一个 ImportSelector 的实现类，在实现类中把定义的两个 Bean 加入 String 数组，这意味着这两个 Bean 会装配到 IoC 容器中。

  ~~~java
  public class GpImportSelector implements ImportSelector {
      @Override
      public String[] selectImports(AnnotationMetadata importingClassMetadata) {
          return new String[]{FirstClass.class.getName(), SecondClass.class.getName()};
      }
  }
  ~~~

- 为了模拟 EnableAutoConfiguration，我们可以自定义一个类似的注解，通过 @Import 导入 GpImportSelector。

  ~~~java
  @Target(ElementType.TYPE)
  @Retention(RetentionPolicy.RUNTIME)
  @Documented
  @Inherited
  @AutoCOnfigurationPackage
  @Import(GpImportSelector.class)
  public @interface EnableAutoImport {
  }
  ~~~

- 创建一个启动类，在启动类上使用 @EnableAutoImport 注解后，即可通过 ca.getBean 从 IoC 容器中得到 FirstClass 对象实例。

  ~~~java
  @SpringBootApplication
  @EnableAutoImport
  public class ImportSelectorMain {
      public static void main(String[] args) {
          ConfigurableApplicationContext ca = SpringApplication.run(ImportSelectorMain.class, args);
          FirstClass fc = ca.getBean(FirstClass.class);
      }
  }
  ~~~

这种实现方式相比 `@Import(*Configuration.class)` 的好处在于装配的灵活性，还可以实现批量。比如 GpImportSelector 还可以直接在 String 数组中定义多个 Configuration 类，由于一个配置类代表的是某一个技术组件中批量的 Bean 声明，所以在自动装配这个过程中只需要扫描到指定路径下对应的配置类即可。

~~~java
public class GpImportSelector implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        return new String[]{FirstConfiguration.class.getName(), SecondConfiguration.class.getName()};
    }
}
~~~

### 3.3.4 自动装配原理分析

基于前面章节的分析可以猜想到，自动装配的核心是扫描约定目录下的文件进行解析，解析完成之后把得到的 Configuration 配置类通过 ImportSelector 进行导入，从而完成 Bean 的自动装配过程。那么接下来我们通过分析 AutoConfigurationImportSelector 的实现来求证这个猜想是否正确。

定位到 AutoConfigurationImportSelector 中的 selectImports 方法，它是 ImportSeletor 接口的实现，这个方法中主要有两个功能：

- AutoConfigurationMetadataLoader.loaderMetadata 从 META-INF/spring-autoconfigure-metadata.properties 中加载自动装配的条件元数据，简单来说就是只有满足条件的 Bean 才能够进行装配。
- 收集所有符合条件的配置类 autoConfigurationEntry.getConfigurations()，完成自动装配。

~~~java
@Override
public String[] selectImports(AnnotationMetadata annotationMetadata) {
    if (!isEnabled(annotationMetadata)){
        return NO_IMPORTS;
    }
    AutoConfigurationMetadata autoConfigurationMetadata = AutoConfigurationMetadataLoader.loadMetadata(this.beanClassLoader);
    AutoConfigurationEntry autoConfigurationEntry = getAutoConfigurationEntry(autoConfigurationMetadata, annotationMetadata);
    return StringUtils.toStringArray(autoConfigurationEntry.getConfigurations());
}
~~~

需要注意的是，在 AutoConfigurationImportSelector 中不执行 selectImports 方法，而是通过 ConfigurationClassPostProcessor 中的 processConfigBeanDefinitions 方法来扫描和注册所有配置类的 Bean，最终还是会调用 getAutoConfigurationEntry 方法获得所有需要自动装配的配置类。

我们重点分析一下配置类的收集方法 getAutoConfigurationEntry，结合之前 Starter 的作用不难猜测到，这个方法应该会扫描指定路径下的文件解析得到需要装配的配置类，而这里面用到了 SpringFactoriesLoader，这块内容后续随着代码的展开再来讲解。简单分析一下这段代码，它主要做几件事情：

- getAttributes 获得 @EnableAutoConfiguration 注解中的属性 exclude、excludeName 等。
- getCandidateConfigurations 获得所有自动装配的配置类，后续会重点分析。
- removeDuplicates 去除重复的配置项。
- getExclusions 根据 @EnableAutoConfiguration 注解中配置的 exclude 等属性，把不需要自动装配的配置类移除。
- fireAutoConfigurationImportEvents 广播事件。
- 最后返回经过多层判断和过滤之后的配置类集合。

~~~java
protected AutoConfigurationEntry getAutoConfigurationEntry(AutoConfigurationMetadata autoConfigurationMetadata, AnnotationMetadata annotationMetadata) {
    if (!isEnabled(annotationMetadata)){
        return EMPTY_ENTRY;
    }
    AnnotationAttributes attributes = getAttributes(annotationMetadata);
    List<String> configurations = getCandidateConfigurations(annotationMetadata, attributes);
    configurations = removeDuplicates(configurations);
    Set<String> exclusions = getExclusions(annotationMetadata, attributes);
    checkExcludedClasses(configurations, exclusions);
    configurations.removeAll(exclusions);
    configurations = filter(configurations, autoConfigurationMetadata);
    fireAutoConfigurationImportEvents(configurations, exclusions);
    return new AutoConfigurationEntry(configurations, exclusions);
}
~~~

总的来说，它先获得所有的配置类，通过去重、exclude 排除等操作，得到最终需要实现自动装配的配置类。这里需要重点关注的是 getCandidateConfigurations ，它是获得配置类最核心的方法。

~~~java
protected List<String> getCandidateConfigurations(AnnotationMetadata metadata, AnnotationAttributes attributes) {
    List<String> configurations = SpringFactoriesLoader.loadFactoryNames(getSpringFactoriesLoaderFactoryClass(), getBeanClassLoader());
    Assert.notEmpty(configurations, "No auto configuration classes found in META-INF/spring.factories. "
                    + "If you are using a custom packaging, make sure that file is correct.");
    return configurations;
}
~~~

这里用到了 SpringFactoriesLoader，它是 Spring 内部提供的一种约定俗成的加载方式，类似于 Java 中的 SPI。简单来说，它会扫描 classpath 下的 META-INF/spring.factories 文件，spring.factories 文件中的数据以 Key = Value 形式存储，而 SpringFactoriesLoader.loaderFactoryNames 会根据 Key 得到对应的 value 值。因此在这个场景中，Key 对应为 EnableAutoConfiguration，Value 是多个配置类，也就是 getCandidateConfigurations 方法所返回的值。

~~~properties
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
org.springframework.boot.autoconfigure.admin.SpringApplicationAdminJmxAutoConfiguration,\
org.springframework.boot.autoconfigure.aop.AopAutoConfiguration,\
org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration,\
org.springframework.boot.autoconfigure.batch.BatchAutoConfiguration,\
org.springframework.boot.autoconfigure.cache.CacheAutoConfiguration,\
// 省略部分
~~~

打开 RabbitAutoConfiguration，可以看到，它就是一个基于 JavaConfig 形式的配置类。

~~~java
@Configuration(proxyBeanMethods = false)
@ConditionalOnClass({RabbitTemplate.class, Channel.class})
@EnableConfigurationProperties(RabbitProperties.class)
@Import(RabbitAnnotationDrivenConfiguration.class)
public class RabbitAutoConfiguration
~~~

除了基本的 @Configuration 注解，还有一个 @ConditionalOnClass 注解，这个条件控制机制在这里的用途是，判断 classpath 下是否存在 RabbitTemplate 和 Channel 这两个类，如果是，则把当前配置类注册到 IoC 容器。另外，@EnableConfigurationProperties 是属性配置，也就是说我们可以按照约定在 application.properties 中配置 RabbitMQ 的参数，而这些配置会加载到 RabbitProperties 中。实际上，这些东西都是 Spring 本身就有的功能。

至此，自动装配的原理基本上就分析完了，简单来总结一下核心过程：

- 通过 @Import（AutoConfigurationImportSelector）实现配置类的导入，但是这里并不是传统意义上的单个配置类装配。
- AutoConfigurationImportSelector 类实现了 ImportSelector 接口，重写了方法 selectImports，它用于实现选择性批量配置类的装配。
- 通过 Spring 提供的 SpringFactoriesLoader 机制，扫描 classpath 路径下的 META-INF/spring.factories，读取需要实现自动装配的配置类。
- 通过条件筛选的方式，把不符合条件的配置类移除，最终完成自动装配。

### 3.3.5 @Conditional 条件装配

@Conditional 是 Spring Framework 提供的一个核心注解，这个注解的作用是提供自动装配的条件约束，一般与 @Configuration 和 @Bean 配合使用。

简单来说，Spring 在解析 @Configuration 配置类时，如果该配置类增加了 @Conditional 注解，那么会根据该注解配置的条件来决定是否要实现 Bean 的装配。

#### 3.3.5.1 @Conditional 的使用

@Conditional 的注解类声明代码如下，该注解可以接收一个 Condition 的数组。

~~~java
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Conditional {
    Class<? extends Condition>[] value();
}
~~~

Condition 是一个函数式接口，提供了 matches 方法，它主要提供一个条件匹配规则，返回 true 表示可以注入 Bean，反之则不注入。

~~~java
@FunctionalInterface
public interface Condition {
    boolean matches(ConditionContext var1, AnnotatedTypeMetadata var2);
}
~~~

我们接下来基于 @Conditional 实现一个条件装配的案例。

- 自定义一个 Condition，逻辑很简单，如果当前操作系统是 Windows，则返回 true，否则返回 false。

  ~~~java
  public class GpCondition implements Condition {
      @Override
      public boolean matches(ConditionContext conditionContext, AnnotatedTypeMetadata annotatedTypeMetadata) {
          // 此处进行条件判断，如果返回 true，表示需要加载该配置类或者 Bean
          // 否则，表示不加载
          String os = conditionContext.getEnvironment().getProperty("os.name");
          if (os.contains("Windows")) {
              return true;
          }
          return false;
      }
  }
  ~~~

- 创建一个配置类，装载一个 BeanClass （自定义的一个类）。

  ~~~java
  @Configuration
  public class ConditionConfig {
      @Bean
      @Conditional(GpCondition.class)
      public BeanClass beanClass() {
          return new BeanClass();
      }
  }
  ~~~

  在 BeanClass 的 bean 声明方法中增加 @Conditional(GpCondition.class)，其中具体的条件是我们自定义的 GpCondition 类。

  上述代码所表达的意思是，如果 GpCondition 类中的 matchs 返回 true，则将 BeanClass 装载到 Spring IoC 容器中。

#### 3.3.5.2 Spring Boot 中的 @Conditional

在 Spring Boot 中，针对 @Conditional 做了扩展，提供了更简单的使用方式，扩展注解如下：

- ConditionalOnBean / ConditionalOnMissingBean : 容器中存在某个类或者不存在某个 Bean 时进行 Bean 装载。
- ConditionalOnClass / ConditionalOnMissingClass: classpath 下存在指定类或者不存在指定类时进行 Bean 装载。
- ConditionalOnCloudPlatform： 只有运行在指定的云平台上才加载指定的 Bean。
- ConditionalOnExpression：基于 SpEl 表达式的条件判断。
- ConditionalOnJava：只有运行指定版本的 Java 才会加载 Bean。
- ConditionalOnJndi：只有指定的资源通过 JNDI 加载后才加载 Bean。
- ConditionalOnWebApplication / ConditionalOnNotWebApplication : 如果是 Web 应用或者不是 Web 应用，才加载指定的 Bean。
- ConditionalOnProperty：系统中指定的对应的属性是否有对应的值。
- ConditionalOnResource：要加载的 Bean 依赖指定资源是否存在于 classpath 中。
- ConditionalOnSingleCandidate：只有在确定了给定 Bean 类的单个候选项时才会加载 Bean。

### 3.3.6 spring-autoconfigure-metadata

除了 @Conditional 注解类，在 Spring Boot 中还提供了 spring-autoconfigure-metadata.properties 文件来实现批量自动装配条件配置。

它的作用和 @Conditional 是一样的，只是将这些条件配置放在了配置文件中。

同样这种形式也是“约定优于配置”的体现，通过这种配置化的方式来实现条件过滤必须要遵循两个条件：

- 配置文件的路径和名称必须是 /META-INF/spring-autoconfigure-metadata.properties。
- 配置文件中 key 的配置格式：自动配置类的类全路径名.条件 = 值

这种配置方法的好处在于，它可以有效地降低 Spring Boot 的启动时间，通过这种过滤方式可以减少配置类的加载数量，因为这个过滤发生在配置类的装载之前，所以它可以降低 Spring Boot 启动时装载 Bean 的耗时。

## 3.4 手写实现一个 Starter

从 Spring Boot 官方提供的 Starter 的作用来看，Starter 组件主要有三个功能：

- 涉及相关组件的 Jar 包依赖。
- 自动实现 Bean 的装配。
- 自动声明并且加载 application.properties 文件中的属性配置。

### 3.4.1 Starter 的命名规范

Starter 的命名主要分为两类，一类是官方命名，另一类是自定义组件命名。这种命名格式并不是强制性的，也是一种约定俗成的方式，可以让开发者更容易识别。

- 官方命名的格式为：spring-boot-starter-模块名称，比如 spring-boot-starter-web。
- 自定义命名格式为：模块名称-spring-boot-starter，比如 mybatis-spring-boot-starter。

简单来说，官方命名中模块名放在最后，而自定义组件中模块名放在最前面。

### 3.4.2 实现基于 Redis 的 Starter

虽然 Spring Boot 官方提供了 spring-boot-starter-data-redis 组件来实现 RedisTemplate 的自动装配，但是我们仍然基于前面学到的思想实现一个基于 Redis 简化版本的 Starter 组件。

- 创建一个工程，命名为 redis-spring-boot-starter。

- 添加 Jar 包依赖，Redisson 提供了在 Java 中操作 Redis 的功能，并且基于 Redis 的特性封装了很多可直接使用的场景，比如分布式锁。

  ~~~xml
  <dependency>
  	<groupId>org.redisson</groupId>
      <artifactId>redisson</artifactId>
      <version>3.11.1</version>
  </dependency>
  ~~~

- 定义属性类，实现在 application.properties 中配置 Redis 的连接参数，由于只是一个简单版本的 Demo，所以只简单定义了一些必要参数。另外 @ConfigurationProperties 这个注解的作用是把当前类中的属性和配置文件（properties / yml）中的配置进行绑定，并且前缀是 gp.redisson。

  ~~~java
  @ConfigurationProperties(prefix = "gp.redisson")
  public class RedissonProperties {
      private String host = "localhost";
      private String password;
      private int port = 6379;
      private int timeout;
      private boolean ssl;
      /* 省略 getter 和 setter */
  }
  ~~~

- 定义需要自动装配的配置类，主要就是把 RedissonClient 装配到 IoC 容器，值得注意的是 @ConditionalOnClass，它表示一个条件，在当前场景中表示的是：在 classpath 下存在 Redisson 这个类的时候，RedissonAutoConfiguration 才会实现自动装配。这里只演示了一种单机的配置模式，除此之外，Redisson 还支持集群、主从、哨兵等模式的配置，大家有兴趣的话可以基于当前案例去扩展，建议使用 config.fromYAML 方式，直接加载配置完成不同模式的初始化，这会比根据不太模式的判断来实现配置化的方式更加简单。

  ~~~java
  @Configuration
  @ConditionalOnClass(Redisson.class)
  @EnableConfigurationProperties(RedissonProperties.class)
  public class RedissonAutoConfiguration {
      @Bean
      RedissonClient redissonClient(RedissonProperties redissonProperties) {
          Config config = new Config();
          String prefix = "redis://";
          if (redissonProperties.isSsl()) {
              prefix = "rediss://";
          }
          SingleServerConfig singleServerConfig = config.useSingleServer()
              .setAddress(prefix + redissonProperties.getHost() + ":" + redissonProperties.getPort())
              .setConnectTimeout(redissonProperties.getTimeout());
          if (!StringUtils.isEmpty(redissonProperties.getPassword())) {
              singleServerConfig.setPassword(redissonProperties.getPassword());
          }
          return Redisson.create(config);
      }
  }
  ~~~

- 在 resources 下创建 META-INF/spring.factories 文件，使得 Spring Boot 程序可以扫描到该文件完成自动装配，key 和 value 对应如下：

  ~~~properties
  org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
  com.gupaoedu.book.RedisAutoConfiguration
  ~~~

- 最后一步，使用阶段只需要做两个步骤：添加 Starter 依赖、设置属性设置：

  ~~~xml
  <dependency>
      <groupId>com.gupaoedu.book</groupId>
      <artifactId>redis-spring-boot-starter</artifactId>
      <version>1.0-SNAPSHOT</version>
  </dependency>
  ~~~

  在 application.properties 中配置 host 和 port，这个属性会自动绑定到 RedissonProperties 中定义的属性上。

  ~~~properties
  gp.redisson.host=192.168.13.106
  gp.redisson.port=6379
  ~~~

至此，一个非常简易的手写 Starter 就完成了。

# 第4章 微服务架构下的服务治理

Dubbo 是阿里巴巴内部使用的一个分布式服务治理框架，于 2012 年开源。

由于某些原因 Dubbo 在 2014 年停止了维护，所以那些使用 Dubbo 框架的公司开始自己维护，比较知名的是当当网开源的 DubboX。值得高兴的是，2017 年 9 月，阿里巴巴重启了 Dubbo 的维护并且做好了长期投入的准备，也对 Dubbo 的未来做了很多规划。2018 年 2 月份，Dubbo 进入 Apache 孵化，这意味着它将不只是阿里巴巴的 Dubbo，而是属于开源社区的，也意味着会有更多的开源贡献者参与到 Dubbo 的开发中来。

2019 年 5 月，Apache Dubbo 正式从孵化器中毕业，代表着 Apache Dubbo 正式成为 Apache 的顶级项目。

## 4.1 如何理解 Apache Dubbo

Apache Dubbo 是一个分布式服务框架，主要实现多个系统之间的高性能、透明化调用，简单来说它就是一个 RPC 框架，但是和普通的 RPC 框架不同的是，它提供了服务治理功能，比如服务注册、监控、路由、容错等。

促使 Apache Dubbo 框架产生的原因有两个：

- 在大规模服务化之后，服务越来越多，服务消费者在调用服务提供者的服务时，需要在配置文件中维护服务提供者的 URL 地址，当服务提供者出现故障或者动态扩容时，所有相关的服务消费者都需要更新本地配置的 URL 地址，这种维护成本非常高。这个时候实现服务的上下线动态感知及服务地址的动态维护就显得非常重要。
- 随着用户的访问量增大，后端服务为了支撑更大的访问量，会通过增加服务器来扩容。但是，哪些服务要扩容，哪些服务要缩容，需要一个判断依据，也就是说需要知道每个服务的调用量及响应时间，这个时候，就需要有一种监控手段，使用监控的数据作为容量规划的参考值，从而实现根据不同服务的访问情况来合理地调控服务器资源，提高机器的利用率。

除了基本的 RPC 框架的职能，它的核心功能便是监控及服务注册。

## 4.2 Apache Dubbo 实现远程通信

- **dubbo:application** 用来描述提供方的应用信息，比如应用名称、维护人、版本等，其中应用名称是必填项。开发者或者运维人员可以通过监控平台查看这些信息来更快速地定位和解决问题。
- **dubbo:registry** 配置注册中心的地址，如果不需要注册中心，可以设置为 N/A。Dubbo 支持多种注册中心，比如 ZooKeeper、Nacos 等。
- **dubbo:protocol** 配置服务提供者的协议信息，Dubbo 支持多种协议来发布服务，默认采用 Dubbo 协议，可选的协议有很多，比如 Hessian、Webservice、Thrift 等。这意味着如果公司之间采用的协议是 Webservice，想切换到 Dubbo 上来，几乎没有太大的迁移成本。
- **dubbo:service** 描述需要发布的服务接口，也就是这个接口可供本网络上的其他进程访问 interface 表示定义的接口， ref 表示这个接口的实现。

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans 
                           http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
                           http://dubbo.apache.org/schema/dubbo
                           http://dubbo.apache.org/schema/dubbo/dubbo.xsd">
	<!-- 提供方应用信息，用于计算依赖关系 -->
    <dubbo:application name="user-service"/>
    <!-- 服务注册中心的地址，N/A 表示不注册 -->
    <dubbo:registry address="N/A"/>
    <!-- 用 Dubbo 协议在 20880 端口暴露服务 -->
    <dubbo:protocol name="dubbo" port="20880"/>
    <!-- 声明需要暴露的服务接口 -->
    <dubbo:service interface="com.gupaoedu.book.dubbo.IUserService" ref="userService" />
    <!-- 和本地 Bean 一样实现服务 -->
    <bean id="userService" class="com.gupaoedu.book.dubbo.UserServiceImpl"/>
</beans>
~~~

**dubbo:reference** 会生成一个针对当前 interface 的远程服务的代理，指向的远程服务地址是发布的 Dubbo 协议的 URL 地址。

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans 
                           http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
                           http://dubbo.apache.org/schema/dubbo
                           http://dubbo.apache.org/schema/dubbo/dubbo.xsd">
	<!-- 提供方应用信息，用于计算依赖关系 -->
    <dubbo:application name="order-service"/>
    <dubbo:registry address="N/A"/>
    <!-- 生成远程服务代理，可以和本地 Bean 一样使用 userService -->
    <dubbo:reference id="userService" interface="com.gupaoedu.book.dubbo.IUserService"
                     url="dubbo://192.168.13.1:20880/com.gupaoedu.book.dubbo.IUserService"/>
</beans>
~~~

基于 XML 形式的服务发布和服务消费方式还是比较烦琐的，而且在发布的服务接口比较多的情况下，配置会非常复杂，所以 Apache Dubbo 也提供对注解的支持

## 4.3 Spring Boot 集成 Apache Dubbo

**服务提供者开发流程**

- 创建一个普通的 Maven 工程 `springboot-provider`，并创建两个模块：`sample-api` 和 `sample-provider`，其中 `sample-provider` 模块是一个 Spring Boot 工程。

- 在 sample-api 模块中定义一个接口，并且通过 `mvn install` 安装到本地私服。

  ~~~java
  public interface IHelloService {
      String sayHello(String name);
  }
  ~~~

- 在 sample-provider 中引入以下依赖，其中 `dubbo-spring-boot-starter` 是 Apache Dubbo 官方提供的开箱即用的组件。

  ~~~xml
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter</artifactId>
  </dependency>
  <dependency>
  	<groupId>org.apache.dubbo</groupId>
      <artifactId>dubbo-spring-boot-starter</artifactId>
      <version>2.7.5</version>
  </dependency>
  <dependency>
  	<groupId>com.gupaoedu.book.dubbo</groupId>
      <version>1.0-SNAPSHOT</version>
      <artifactId>sample-api</artifactId>
  </dependency>
  ~~~

- 在 sample-provider 中实现 IHelloService，并且使用 Dubbo 中提供的 `@Service` 注解发布服务。

  ~~~java
  @Service
  public class HelloServiceImpl implements IHelloService {
      @Value("${dubbo.application.name}")
      private String serviceName;
      @Override
      public String sayHello(String name) {
          return String.format("[%s]: Hello,%s", serviceName, name);
      }
  }
  ~~~

- 在 application.properties 文件中添加 Dubbo 服务的配置信息，配置元素在前面的章节中讲过，只是换了一种配置形式。

  ~~~properties
  spring.application.name=springboot-dubbo-demo
  
  dubbo.application.name=springboot-provider
  dubbo.protocol.name=dubbo
  dubbo.protocol.port=20880
  dubbo,registry.address=N/A
  ~~~

- 启动 Spring Boot，需要注意的是，需要在启动方法上添加 `@DubboComponentScan` 注解，它的作用和 Spring Framework 提供的 `@ComponentScan` 一样，只不过这里扫描的是 Dubbo 中提供的 `@Service` 注解。

  ~~~java
  @DubboComponentScan
  @SpringBootApplication
  public class ProviderApplication {
      public static void main(String[] args) {
          SpringApplication.run(ProviderApplication.class, args);
      }
  }
  ~~~

**服务调用者的开发流程**

- 创建一个 Spring Boot 项目 `springboot-consumer`，添加 Jar 包依赖。

  ~~~xml
  <dependency>
  	<groupId>org.apache.dubbo</groupId>
      <artifactId>dubbo-spring-boot-starter</artifactId>
      <version>2.7.5</version>
  </dependency>
  <dependency>
      <groupId>com.gupaoedu.book.dubbo</groupId>
      <version>1.0-SNAPSHOT</version>
      <artifactId>sample-api</artifactId>
  </dependency>
  ~~~

- 在 application.properties 中配置项目名称。

  ~~~properties
  dubbo.application.name=springboot-consumer
  ~~~

- 在 Spring Boot 启动类中，使用 Dubbo 提供的 `@Reference` 注解来获得一个远程代理对象。

  ~~~java
  @SpringBootApplication
  public class SpringbootConsumerApplication {
      @Reference(url = "dubbo://192.168.13.1:20880/com.gupaoedu.book.dubbo.IHelloService")
      private IHelloService helloService;
      
      public static void main(String[] args) {
          SpringApplication.run(SpringbootConsumerApplication.class, args);
      }
      @Bean
      public ApplicationRunner runner() {
          return args -> System.out.println(helloService.sayHello("Mic"));
      }
  }
  ~~~

相比基于 XML 的形式来说，基于 Dubbo-Spring-Boot-Starter 组件来使用 Dubbo 完成服务发布和服务消费会使得开发更加简单。另外，官方还提供了 Dubbo-Spring-Boot-Actuator 模块，可以实现针对 Dubbo 服务的健康检查；还可以通过 Endpoints 实现 Dubbo 服务信息的查询和控制等，为生产环境中对 Dubbo 服务的监控提供了很好的支持。

## 4.4 快速上手 ZooKeeper

ZooKeeper 是一个高性能的分布式协调中间件，所谓的分布式协调中间件的作用类似于多线程环境中通过并发工具包来协调线程的访问控制，只是分布式协调中间件主要解决分布式环境中各个服务进程的访问控制问题，比如访问顺序控制。所以，在这里需要强调的是，ZooKeeper 并不是注册中心，只是基于 ZooKeeper 本身的特性可以实现注册中心这个场景而已。

### 4.4.2 ZooKeeper 的数据结构

ZooKeeper 的数据模型和分布式文件系统类似，是一种层次化的属性结构。和文件系统不同的是，ZooKeeper 的数据是结构化存储的，并没有在物理上体现出文件和目录。

ZooKeeper 树中的每个节点被称为 Znode，Znode 维护了一个 stat 状态信息，其中包含数据变化的时间和版本等。并且每个 Znode 可以设置一个 value 值，ZooKeeper 并不用于通用的数据库或者大容量的对象存储，它只是管理和协调有关的数据，所以 value 的数据大小不建议设置得非常大，较大的数据会带来更大的网络开销。

ZooKeeper 上的每个节点的数据都是运行读与写的，读表示获得指定 Znode 上的 value 数据，写表示修改指定 Znode 上的 value 数据。另外，节点的创建规则和文件系统中文件的创建规则类似，必须要按照层级创建。

### 4.4.3 ZooKeeper 的特性

ZooKeeper 中的 Znode 在被创建的时候，需要指定节点的类型，节点类型分为：

- 持久化节点，节点的数据会持久化到磁盘。
- 临时节点，节点的生命周期和创建该节点的客户端的生命周期保持一致，一旦该客户端的会话结束，则该客户端所创建的临时节点会把自动删除。
- 有序节点，在创建的节点后面会增加一个递增的序列，该序列在同一级父节点之下是唯一的。需要注意的是，持久化节点或者临时节点也是可以设置为有序节点的，也就是持久化有序节点或者临时有序节点。

在 3.5.3 版本之后，又增加了两种节点类型，分别是：

- 容器节点，当容器节点下的最后一个子节点被删除时，容器节点就会被自动删除。
- TTL 节点，针对持久化节点或者持久化有序节点，我们可以设置一个存活时间，如果在存活时间之内该节点没有任何修改并且没有任何子节点，它就会被自动删除。

需要注意的是，在同一层级目录下，节点的名称必须是唯一的，就像我们在同一个目录下不能创建两个有相同名字的文件夹一样。

### 4.4.4 Watcher 机制

ZooKeeper 提供了一种针对 Znode 的订阅 / 通知机制，也就是当 Znode 节点状态发生变化时或者 ZooKeeper 客户端连接状态发生变化时，会触发事件通知。这个机制在服务注册与发现中，针对服务调用者及时感知到服务提供者的变化提供了非常好的解决方案。

在 ZooKeeper 提供的 Java API 中，提供了三种机制来针对 Znode 进行注册监听，分别是：

- getData()，用于获取指定节点的 value 信息，并且可以注册监听，当监听的节点进行创建、修改、删除操作时，会触发相应的事件通知。
- getChildren()，用于获取指定节点的所有子节点，并且允许注册监听，当监听节点的子节点进行创建、修改、删除操作时，触发相应的事件通知。
- exists()，用于判断指定节点是否存在，同样可以注册针对指定节点的监听，监听的时间类型和 getData() 相同。

Watcher 事件的触发都是一次性的，比如客户端通过 getData("/node", true) 注册监听，如果 /node 节点发生数据修改，那么该客户端会收到一个修改事件通知，但是 /node 再次发生变化时，客户端无法收到 Watcher 事件，为了解决这个问题，客户端必须在收到的事件回调中再次注册事件。

### 4.4.5 常见应用场景分析

**分布式锁**

用过多线程的读者应该都知道锁，比如 synchronized 或者 Lock，它们主要用于解决多线程环境下共享资源访问的数据安全性问题，但是它们所处理的范围是线程范围的。在分布式架构中，多个进程对同一个共享资源的访问，也存在数据安全的问题，因此也需要使用锁形式来解决这类问题，而解决分布式环境下多线程对于共享资源访问带来的安全性问题的方案就是使用分布式锁。锁的本质是排他性的，也就是避免在同一时刻多个进程同时访问某一个共享资源。

如果使用 ZooKeeper 实现分布式锁达到排他的目的，只需要用到节点的特性：临时节点，以及同级节点的唯一性。

- 获得锁的过程
  在获得排他锁时，所有客户端可以去 ZooKeeper 服务器上 /Exclusive_Locks 节点下创建一个临时节点 /lock。Zookeeper 基于同级节点的唯一性，会保证所有客户端中只有一个客户端能创建成功，创建成功的客户端获得了排他锁，没有获得锁的客户端就需要通过 Watcher 机制监听 /Exclusive_Locks 节点下子节点的变更事件，用于实时监听 /lock 节点的变化情况以做出反应。
- 释放锁的过程
  在获得锁的过程中，我们定义的锁节点 /lock 为临时节点，那么在以下两种情况下会触发锁的释放。
  - 获得锁的客户端因为异常断开了和服务端的连接，基于临时节点的特性，/lock 节点会被自动删除。
  - 获得锁的客户端执行完业务逻辑之后，主动删除了创建的 /lock 节点。

当 /lock 节点被删除之后，ZooKeeper 服务器会通知所有监听了 /Exclusive_Locks 子节点变化的客户端。这些客户端收到通知后，再次发起创建 /lock 节点的操作来获得排他锁。

**Master 选举**

Master 选举是分布式系统中非常常见的场景，在分布式架构中，为了保证服务的可用性，通常会采用集群模式，也就是当其中一个机器宕机后，集群中的其他节点会接替故障节点继续工作。在这种场景中，就需要从集群中选举一个节点作为 Master 节点，剩余的节点都作为备份节点随时待命。当原有的 Master 节点出现故障之后，还需要从集群中的其他备份节点中选举一个节点作为 Master 节点继续提供服务。

ZooKeeper 就可以帮助集群中的节点实现 Master 选举。具体而言，ZooKeeper 中有两种方式来实现 Master 选举这一场景：

- 同一级节点不能重复创建一个已经存在的节点，这个有点类似于分布式锁的实现场景，其实 Master 选举的场景也是如此。假设集群中有 3 个节点，需要选举出 Master，那么这三个节点同时去 Zookeeper 服务器上创建一个临时节点 /master-election，由于节点的特性，只会有一个客户端创建成功，创建成功的客户端所在机器就成了 Master。同时，其他没有创建成功的客户端，针对该节点注册 Watcher 事件，用于监控当前的 Master 机器是否存活，一旦发现 Master ”挂了“，也就是 /master-election 节点被删除了，那么其他的客户端将会重新发起 Master 选举操作。
- 利用临时有序节点的特性来实现。所有参与选举的客户端在 Zookeeper 服务器的 /master 节点下创建一个临时有序节点，编号最小的节点表示 Master，后续的节点可以监听前一个节点的删除事件，用于触发重新选举。

## 4.5 Apache Dubbo 集成 ZooKeeper 实现服务注册

大规模服务化之后，在远程 RPC 通信过程中，会遇到两个比较尖锐的问题：

- **服务动态上下线感知**，就是服务要感知到服务提供者上下线的变化。需要一个第三方软件来统一管理服务提供者的 URL 地址，服务调用者可以从这个软件中获得目标服务的相关地址，并且第三方软件需要动态感知服务提供者状态的变化来维护所管理的 URL，进而使得服务调用者能够及时感知到变化而做出相应的处理。
- **负载均衡**这个概念大家都熟悉，就是当服务提供者是由多个节点组成的集群环境时，服务调用者需要通过负载均衡算法来动态选择一台目标服务器进行远程通信。负载均衡的主要目的是通过多个节点的集群来均衡服务器的访问压力，提升整体性能。实现负载均衡的前提是，要得到目标服务集群的所有地址，在服务调用者进行计算，而地址的获取也同样依赖于第三方软件。

第三方软件的主要功能其实就是服务注册和发现，可以看到引入服务注册中心后服务调用者和服务提供者之间的访问变化。Apache Dubbo 支持多种注册中心，比如 ZooKeeper、Nacos、Redis 等。在开源版本中，官方推荐使用的注册中心是 ZooKeeper，所以使用 Apache Dubbo 的公司大部分都用 ZooKeeper 来实现服务注册和发现，在本节中会简单介绍 ZooKeeper，后续章节会详细分析 Nacos。

### 4.5.1 Apache Dubbo 集成 ZooKeeper 实现服务注册的步骤

在这个案例中，只需要非常简单的几个步骤就能完成服务注册的功能：

- 在 springboot-provider 项目的 sample-provider 模块中添加 ZooKeeper 相关依赖，其中 curator-framework 和 curator-recipes 是 ZooKeeper 的开源客户端。

  ~~~xml
  <dependency>
  	<groupId>org.apache.zookeeper</groupId>
      <artifactId>zookeeper</artifactId>
      <version>3.5.3-beta</version>
  </dependency>
  <dependency>
      <groupId>org.apache.curator</groupId>
      <artifactId>curator-framework</artifactId>
      <version>4.0.1</version>
  </dependency>
  <dependency>
  	<groupId>org.apache.curator</groupId>
      <artifactId>curator-recipes</artifactId>
      <version>4.0.1</version>
  </dependency>
  ~~~

- 修改 application.properties 文件，修改 dubbo.registry.address 的地址为 ZooKeeper 服务器的地址，表示当前 Dubbo 服务需要注册到 ZooKeeper 上。

  ~~~properties
  spring.application.name=springboot-dubbo-demo
  
  dubbo.application.name=springboot-provider
  dubbo.protocol.name=dubbo
  dubbo.protocol.port=20880
  dubbo.registry.address=zookeeper://192.168.13.106:2181
  ~~~

- 服务调用方只需要修改 application.properties，设置 Dubbo 服务注册中心的地址即可，当 Dubbo 调用方发起远程调用时，会去注册中心获取目标服务的 URL 地址已完成最终通信。

### 4.5.2 ZooKeeper 注册中心的实现原理

Dubbo 服务注册到 ZooKeeper 上之后，可以在 ZooKeeper 服务器上看到如下的树形结构

~~~
/dubbo
	┗ com.gupaoedu.book.dubbo.IHelloService
		┣ /providers
		┃	┣ dubbo://192.168.13.1:20880
		┃	┗ dubbo://192.168.13.2:20880
		┗ /consumers
			┗ consumer://192.168.13.1:20880
~~~

当 Dubbo 服务消费者启动时，会对 /dubbo/com.gupaoedu.book.dubbo.IHelloService/providers 节点下的子节点注册 Watcher 监听，这样便可以感知到服务提供方节点的上下线变化，从而防止请求发送到已经下线的服务器造成访问失败。同时，服务消费者会在 dubbo/com.gupaoedu.book.dubbo.IHelloService/consumers 下写入自己的 URL，这样做的目的是可以在监控平台上看到某个 Dubbo 服务正在被哪些服务调用。最重要的是，Dubbo 服务的消费者如果需要调用 IHelloService 服务，那么它会先去 /dubbo/com.gupaoedu.book.dubbo.IHelloService/providers 路径下获得所有该服务的提供方 URL 列表，然后通过负载均衡算法计算出一个地址进行远程访问。

整体来看，服务注册和动态感知的功能用到了 ZooKeeper 中的临时节点、持久化节点、Watcher 等，回过头看前面分析的 ZooKeeper 的应用场景可以发现，几乎所有的场景都是基于这些来完成的。另外，不得不提的是，Dubbo 还可以针对不同的情况来实现以下功能。

- 基于临时节点的特性，当服务提供者宕机或者下线时，注册中心会自动删除该服务提供者的信息。
- 注册中心重启时，Dubbo 能够自动恢复注册数据及订阅请求。
- 为了保证节点操作的安全性，ZooKeeper 提供了 ACL 权限控制，在 Dubbo 中可以通过 dubbo.registry.username/dubbo.registry.password 设置节点的验证信息。
- 注册中心默认的根节点是 /dubbo，如果需要针对不同环境配置不同的根节点，可以使用 dubbo.registry.group 修改根节点名称。

## 4.6 实战 Dubbo Spring Cloud

Spring Cloud 为 Java 环境中解决微服务问题提供了非常完整的方案，所以在最近几年时间，Spring Cloud 成了很多公司首选的技术方案。但是随着运用规模的扩大，Spring Cloud 在服务治理领域的局限性逐步显露出来。相对来说，在服务治理方面，Apache Dubbo 有着非常大的优势，并且在 Spring Cloud 出现之前，它就已经被很多公司作为服务治理及微服务基础设施的首选框架。Dubbo Spring Cloud 的出现，使得 Dubbo 既能够完全整合到 Spring Cloud 的技术栈中，享受 Spring Cloud 生态中的技术支持和标准化输出，又能够弥补 Spring Cloud 中服务治理这方面的短板。

Dubbo Spring Cloud 是 Spring Cloud Alibaba 的核心组件，它构建在原生的 Spring Cloud 标准之上，不仅覆盖了 Spring Cloud 原生特性，还提供了更加稳定和成熟的实现。

### 4.6.1 实现 Dubbo 服务提供方

创建一个普通的 Maven 工程，并在该工程中创建两个模块：`spring-cloud-dubbo-sample-api`、`spring-cloud-dubbo-sample-provider`。其中 `spring-cloud-dubbo-sample-api` 是一个普通的 Maven 工程，`spring-cloud-dubbo-sample-provider` 是一个 Spring Boot 工程。细心的读者应该会发现，对于服务提供者而言，都会存在一个 API 声明，因为服务的调用者需要访问服务提供者声明的接口，为了确保契约的一致性，Dubbo 官方推荐的做法是把服务接口打成 Jar 包发布到仓库上。服务调用者可以依赖该 Jar 包，通过接口调用方式完成远程通信。对于服务提供者来说，也需要依赖该 Jar 包完成接口的实现。

> **注意**
>
> 当前案例中使用的 Spring Cloud 版本为 Greenwich.SR2，Spring Cloud Alibaba 的版本为 2.2.2.RELEASE，Spring Boot 的版本为 2.1.11.RELEASE

- 在 `spring-cloud-dubbo-sample-api` 中声明接口，并执行 `mvn install` 将 Jar 包安装到本地仓库。

  ~~~java
  public interface IHelloService {
      String sayHello(String name);
  }
  ~~~

- 在 `spring-cloud-dubbo-sample-provider` 中添加依赖。

  ~~~xml
  <dependencies>
  	<dependency>
      	<groupId>org.springframework.cloud</groupId>
          <artifactId>spring-cloud-starter</artifactId>
      </dependency>
      <dependency>
          <groupId>com.alibaba.cloud</groupId>
          <artifactId>spring-cloud-starter-dubbo</artifactId>
      </dependency>
      <dependency>
          <groupId>com.gupaoedu.book.springcloud</groupId>
          <artifactId>spring-cloud-dubbo-sample-api</artifactId>
          <version>1.0-SNAPSHOT</version>
      </dependency>
      <dependency>
          <groupId>org.springframework.cloud</groupId>
          <artifactId>spring-cloud-starter-zookeeper-discovery</artifactId>
      </dependency>
  </dependencies>
  ~~~

  依赖说明如下：

  - spring-cloud-starter：Spring Cloud 核心包
  - spring-cloud-dubbo-sample-api：API 接口声明
  - spring-cloud-starter-dubbo：引入 Spring Cloud Alibaba Dubbo
  - spring-cloud-starter-zookeeper-discovery：基于 ZooKeeper 实现服务注册发现的 artifactId

  需要注意的是，上述依赖的 artifact 没有指定版本，所以需要在父 pom 中显式声明 dependencyManagement。

  ~~~xml
  <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-dependencies</artifactId>
      <version>Greenwich.SR2</version>
      <type>pom</type>
      <scope>import</scope>
  </dependency>
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-dependencies</artifactId>
      <version>2.1.11.RELEASE</version>
      <type>pom</type>
      <scope>import</scope>
  </dependency>
  <dependency>
      <groupId>org.alibaba.cloud</groupId>
      <artifactId>spring-cloud-alibaba-dependencies</artifactId>
      <version>2.1.1.RELEASE</version>
      <type>pom</type>
      <scope>import</scope>
  </dependency>
  ~~~

- 在 application.properties 中配置 Dubbo 相关的信息。

  ~~~properties
  dubbo.protocol.port=20880
  dubbo.protocol.name=dubbo
  
  spring.application.name=spring-cloud-dubbo-sample
  spring.cloud.zookeeper.discovery.register=true
  spring.cloud.zookeeper.connect-string=192.168.13.106:2181
  ~~~

  其中 `spring.cloud.zookeeper.discovery.register=true` 表示服务是否需要注册到注册中心。`spring.cloud.zookeeper.connect-string` 表示 ZooKeeper 的连接字符串。

- 在启动类中声明 `@DubboComponentScan` 注解，并启动服务。

  ~~~java
  @DubboComponentScan
  @SpringBootApplication
  public class SpringCloudDubboSampleProviderApplication {
      public static void main(String[] args) {
          SpringApplication.run(SpringCloudDubboSampleProviderApplication.class, args);
      }
  }
  ~~~

  `@DubboComponentScan` 扫描当前注解所在的包路径下的 `@org.apache.dubbo.config.annotation.Service` 注解，实现服务的发布。发布完成之后，就可以在 ZooKeeper 服务器上看到一个 `/services/${project-name}` 节点，这个节点中保存了服务提供方相关的地址信息。

### 4.6.2 实现 Dubbo 服务调用方

Dubbo 服务提供方 `spring-cloud-dubbo-sample` 已经准备完毕，只需要创建一个名为 `spring-cloud-dubbo-consumer` 的 Spring Boot 项目，就可以实现 Dubbo 服务调用了。

- 创建一个名为 spring-cloud-dubbo-consumer 的 Spring Boot 工程，添加与服务提供方所依赖的配置没什么区别的依赖。为了演示需要，增加了 spring-boot-starter-web 组件，表示这是一个 Web 项目。

- 在 application.properties 文件中添加 Dubbo 相关配置信息。

  ~~~properties
  dubbo.cloud.subscribed-services=spring-cloud-dubbo-provider
  
  spring.application.name=spring-cloud-dubbo-consumer
  spring.cloud.zookeeper.discovery.register=false
  spring.cloud.zookeeper.connect-string=192.168.13.106:2181
  ~~~

  配置信息和 spring-cloud-dubbo-sample 项目的配置信息差不多，有两个配置需要单独说明一下：

  - `spring.cloud.zookeeper.discovery.register=false` 表示当前服务不需要注册到 ZooKeeper 上，默认为 true。
  - `dubbo.cloud-subscribed-services` 表示服务调用者订阅的服务提供方的应用名称列表，如果有多个应用名称，可以通过 “,” 分隔开，默认值为 “*”，不推荐使用默认值。当 `dubbo.cloud.subscribed-services` 为默认值时，控制台的日志中会输入一段警告信息。

- 创建一个 `HelloController` 类，暴露一个 `/say` 服务，来消费 Dubbo 服务提供者的 IHelloService 服务。

  ~~~java
  @RestController
  public class HelloController {
      @Reference
      private IHelloService iHelloService;
      
      @GetMapping("/say")
      public String sayHello() {
          return iHelloService.sayHello("Mic");
      }
  }
  ~~~

- 启动 Spring Boot 服务。

  ~~~java
  @SpringBootApplication
  public class SpringCloudDubboConsumerApplication {
      public static void main(String[] args) {
          SpringApplication.run(SpringCloudDubboConsumerApplication.class, args);
      }
  }
  ~~~

  通过 curl 命令执行 HTTP GET 方法：

  ~~~sh
  curl http://127.0.0.1:8080/say
  ~~~

  响应结果为：

  ~~~
  [spring-cloud-dubbo-sample]: Hello,Mic
  ~~~

## 4.7 Apache Dubbo 的高级应用

Apache Dubbo 更像一个生态，它提供了很多比较主流框架的集成，比如：

- 支持多种协议的服务发布，默认是 dubbo://，还可以支持 rest://、webservice://、thrift:// 等。
- 支持多种不同的注册中心，如 Nacos、ZooKeeper、Redis，未来还将会支持 Consul、Eureka、Etcd 等。
- 支持多种序列化技术，如 avro、fst、fastjson、hessian2、kryo 等。

除此之外，Apache Dubbo 在服务治理方面的功能非常完善，比如集群容错、服务路由、负载均衡、服务降级、服务限流、服务监控、安全验证等。

### 4.7.1 集群容错

容错就是服务容忍错误的能力。我们都知道网络通信中会存在很多不确定的因素导致请求失败，比如网络延迟、网络中断、服务异常等。当服务调用者（消费者）调用服务提供者的接口时，如果因为上述原因出现请求失败，那对于服务调用者来说，需要一种机制来应对。Dubbo 提供了集群容错的机制来优雅地处理这种错误。

**容错模式**

Dubbo 默认提供了 6 种容错模式，默认为 Failover Cluster。如果这 6 种容错模式不能满足你的实际需求，还可以自行扩展。这也是 Dubbo 的强大之处，几乎所有的功能都提供了插拔式的扩展。

- **Failover Cluster**，失败自动切换。当服务调用失败后，会切换到集群中的其他机器进行重试，默认重试次数为2，通过属性 `retries=2` 可以修改次数，但是重试次数增加会带来更长的响应延迟。这种容错模式通常用于读操作，因为事务型操作会带来数据重复的问题。
- **Failfast Cluster**，快速失败。当服务调用失败后，立即报错，也就是只发起一次调用。通常用于一些非幂等的写操作，比如新增数据，因为当服务调用失败时，很可能这个请求已经在服务器端处理成功，只是因为网络延迟导致响应失败，为了避免在结果不确定的情况下导致数据重复插入的问题，可以使用这种容错机制。
- **Failsafe Cluster**，失败安全。也就是出现异常时，直接忽略异常。
- **Failback Cluster**，失败后自动回复。服务调用出现异常时，在后台记录这条失败的请求定时重发。这种模式适合用于消息通知操作，保证这个请求一定发送成功。
- **Forking Cluster**，并行调用集群中的多个服务，只要其中一个成功就返回。可以通过 `forks=2` 来设置最大并行数。
- **Broadcast Cluster**，广播调用所有的服务提供者，任意一个服务报错则表示服务调用失败。这种机制通常用于通知所有的服务提供者更新缓存或者本地资源信息。

**配置方式**

配置方式非常简单，只需要在指定服务的 @Service 注解上增加一个参数即可。注意，在没有特殊说明的情况下，后续代码都是基于前面的 Dubbo Spring Cloud 的代码进行改造的。在 @Service 注解中增加 `cluster="failfast"` 参数，表示当前服务的容错方式为快速失败。

~~~java
@Service(cluster = "failfast")
public class HelloServiceImpl implements IHelloService {
    @Value("${dubbo.application.name}")
    private String serviceName;
    
    @Override
    public String sayHello(String name) {
        return String.format("[%s]: Hello,%s", serviceName, name);
    }
}
~~~

在实际应用中，查询语句容错策略建议使用默认的 Failover Cluster，而增删改操作建议使用 Failfast Cluster 或者使用 Failover Cluster(retries = "0") 策略，防止出现数据重复添加等其他问题！建议在设计接口的时候把查询接口方法单独做成一个接口提供查询。

### 4.7.2 负载均衡

负载均衡应该不是一个陌生的概念，在访问量较大的情况下，我们会通过水平扩容的方式增加多个节点来平衡请求的流量，从而提升服务的整体性能。

当服务调用者面对 5 个节点组成的服务提供方集群时，请求应该分发到集群中的哪个节点，取决于负载均衡算法，通过该算法可以让每个服务器节点获得适合自己处理能力的负载。负载均衡可以分为硬件负载均衡和软件负载均衡，硬件负载均衡比较常见的就是 F5，软件负载均衡目前比较主流的是 Nginx。

在 Dubbo 中提供了 4 种负载均衡策略，默认负载均衡策略是 random。同样，如果这 4 种策略不能满足实际需求，我们可以基于 Dubbo 中的 SPI 机制来扩展。

- Random LoadBalance，随机算法。可以针对性能较好的服务器设置较大的权重值，权重值较大，随机的概率也会越大。
- RoundRobin LoadBalance，轮询。按照公约后的权重设置轮询比例。
- LeastActive LoadBalance，最少活跃调用数。处理较慢的节点将会收到更少的请求。
- ConsistentHash LoadBalance，一致性 Hash。相同参数的请求总是发送到同一个服务提供者。

**配置方式**

在 @Service 注解上增加 loadbalance 参数：

~~~java
@Service(cluster = "failfast", loadbalance = "roundrobin")
~~~

### 4.7.3 服务降级

服务降级是一种系统保护策略，当服务器访问压力较大时，可以根据当前业务情况对不重要的服务进行降级，以保证核心服务的正常运行。所谓的降级，就是把一些非必要的功能在流量较大的时间端暂时关闭。

降级有多个层面的分类：

- 按照是否自动化可分为自动降级和人工降级。
- 按照功能可分为读服务降级和写服务降级。

人工降级一般具有一定的前置性，而自动降级更多的来自于系统出现某些异常的时候自动触发“兜底的流畅”，比如：

- 故障降级，调用的远程服务“挂了”，网络故障或者 RPC 服务返回异常。这类情况在业务允许的情况下可以通过设置兜底数据响应给客户端。
- 限流降级，不管是什么类型的系统，它所支撑的流量是有限的，为了保护系统不被压垮，在系统中会针对核心业务进行限流。当请求流量达到阈值时，后续的请求会被拦截，这类请求可以进入排队系统，也可以直接返回降级页面。

Dubbo 提供了一种 Mock 配置来实现服务降级，也就是说当服务提供方出现网络异常无法访问时，客户端不抛出异常，而是通过降级配置返回兜底数据，操作步骤如下：

- 在 spring-cloud-dubbo-consumer 项目中创建 MockHelloService 类，这个类只需要实现自动降级的接口即可，然后重写接口中的抽象方法实现本地数据的返回。

  ~~~java
  public class MockHelloService implements IHelloService {
      @Override
      public String sayHello(String s) {
          return "Sorry, 服务无法访问，返回降级数据";
      }
  }
  ~~~

- 在 HelloController 类中修改 `@Reference` 注解增加 Mock 参数。其中设置了属性 `cluster = "failfast"`，因为默认的容错策略会发起两次重试，等待的时间较长。

  ~~~java
  @RestController
  public class HelloController {
      @Reference(mock = "com.gupaoedu.book.springcloud.springclouddubboconsumer.MockHelloService", cluster = "failfast")
      private IHelloService iHelloService;
      
      @GetMapping("/say")
      public String sayHello() {
          return iHelloService.sayHello("Mic");
      }
  }
  ~~~

- 在不启动 Dubbo 服务端或者服务端的返回值超过默认的超时时间时，访问 /say 接口得到的结构就是 MockHelloService 中返回的数据。

### 4.7.4 主机绑定规则

主机绑定表示的是 Dubbo 服务对外发布的 IP 地址，默认情况下 Dubbo 会按照以下顺序来查找并绑定主机 IP 地址：

- 查找环境变量中 DUBBO_IP_TO_BIND 属性配置的 IP 地址。
- 查找 dubbo.protocol.host 属性配置的 IP 地址，默认是空，如果没有配置或者 IP 地址不合法，则继续往下查找。
- 通过 LocalHost.getHostAddress 获取本地 IP 地址，如果获取失败，则继续往下查找。
- 如果配置了注册中心的地址，则使用 Socket 通信连接到注册中心的地址后，使用 for 循环通过 socket.getLocalAddress().getHostAddress() 扫描各个网卡获取网卡 IP 地址。

上述过程中，任意一个步骤检测到合法的 IP 地址，便会将其返回作为对外暴露的服务 IP 地址。需要注意的是，获取的 IP 地址并不是写入注册中心的地址，默认情况下，写入注册中心的 IP 地址优先选择环境变量中 DUBBO_IP_TO_REGISTRY 属性配置的 IP 地址。在这个属性没有配置的情况下，才会选取前面获得的 IP 地址并写入注册中心。

使用默认的主机绑定规则，可能会存在获取的 IP 地址不正确的情况，导致服务消费者与注册中心上拿到的 URL 地址进行通信。因为 Dubbo 检测本地 IP 地址的策略是先调用 LocalHost.getHostAddress，这个方法的原理是通过获取本机的 hostname 映射 IP 地址，如果它指向的是一个错误的 IP 地址，那么这个错误的地址将会作为服务发布的地址注册到 ZooKeeper 节点上，虽然 Dubbo 服务能够正常启动，但是服务消费者却无法正常调用。按照 Dubbo 中 IP 地址的查找规则，如果遇到这种情况，可以使用很多种方式来解决：

- 在 /etc/hosts 中配置机器名对应正确的 IP 地址映射。
- 在环境变量中添加 DUBBO_IP_TO_BIND 或者 DUBBO_IP_TO_REGISTRY 属性，Value 值为绑定的主机地址。
- 通过 dubbo.protocol.host 设置主机地址。

除获取绑定主机 IP 地址外，对外发布的端口也是需要注意的，Dubbo 框架中针对不同的协议都提供了默认的端口号：

- Dubbo 协议的默认端口号是 20880
- Webservice 协议的默认端口号是 80

在实际使用过程中，建议指定一个端口号，避免和其他 Dubbo 服务的端口产生冲突。

## 4.8 Apache Dubbo 核心源码分析

Apache Dubbo 的源码相对来说还是比较容易理解的，只需要理解几个点：

- SPI 机制
- 自适应扩展点
- IoC 和 AOP
- Dubbo 如何与 Spring 集成

### 4.8.2 Dubbo 的核心之 SPI

在 Dubbo 的源码中，很多地方会存下面这样三种代码，分别是自适应扩展点、指定名称的扩展点、激活扩展点：

~~~java
ExtensionLoader.getExtensionLoader(XXX.class).getAdaptiveExtension();
ExtensionLoader.getExtensionLoader(XXX.class).getExtension(name);
ExtensionLoader.getExtensionLoader(XXX.class).getActivateExtension(url, key);
~~~

这种扩展点实际上就是 Dubbo 中的 SPI 机制。关于 SPI，不知道大家是否还有印象，我们在分析 Spring Boot 自动装配的时候提到过 SpringFactoriesLoader，它也是一种 SPI 机制。实际上，这两者的实现思想是类似的。

#### 4.8.2.1 Java SPI 扩展点实现

SPI 全称是 Service Provider Interface，原本是 JDK 内置的一种服务提供发现机制，它主要用来做服务的扩展实现。SPI 机制在很多场景中都有运用，比如数据库连接，JDK 提供了 java.sql.Driver 接口，这个驱动类在 JDK 中并没有实现，而是由不同的数据库厂商来实现，比如 Oracle、MySQL 这些数据库驱动包都会实现这个接口，然后 JDK 利用 SPI 机制从 classpath 下找到相应的驱动来获得指定数据库的连接。这种插拔式的扩展加载方式，也同样遵循一定的协议协定。比如所有的扩展点必须要放在 resources/META-INF/services 目录下，SPI 机制会默认扫描这个路径下的属性文件以完成加载。

- 创建一个普通的 Maven 工程 Driver，定义一个接口。这个接口只是一个规范，并没有实现，由第三方厂商来提供实现。

  ~~~java
  public interface Driver {
      String connect();
  }
  ~~~

- 创建另一个普通的 Maven 工程 Mysql-Driver，添加 Driver 的 Maven 依赖。

- 创建 MysqlDriver，实现 Driver 接口，这个接口表示一个第三方的扩展实现。

  ~~~java
  public class MysqlDriver implements Driver {
      @Override
      public String connect() {
          return "连接Mysql数据库";
      }
  }
  ~~~

- 在 resources/META-INF/services 目录下创建一个以 Driver 接口全路径名命名的文件 `com.gupaoedu.book.spi.Driver`，在里面填写这个 Driver 的实现类扩展。

  ~~~
  com.gupaoedu.book.spi.MysqlDriver
  ~~~

- 创建一个测试类，使用 ServiceLoader 加载对应的扩展点。从结果来看，MysqlDriver 这个扩展点被加载并且输出了相应的内容。

  ~~~java
  public class SpiMain {
      public static void main(String[] args) {
          ServiceLoader<Driver> serviceLoader = ServiceLoader.load(Driver.class);
          serviceLoader.forEach(driver -> System.out.println(driver.connect()));
      }
  }
  ~~~

#### 4.8.2.2 Dubbo 自定义协议扩展点

前面我们用 `ExtensionLoader.getExtensionLoader.getExtension()` 来演示了 Dubbo 中 SPI 的用法，下面我们基于这个方法来分析 Dubbo 源码中是如何实现 SPI 的。

这段代码分为两部分：首先我们通过 ExtensionLoader.getExtensionLoader 来获得一个 ExtensionLoader 实例，然后通过 getExtension() 方法获得指定名称的扩展点。

**ExtensionLoader.getExtensionLoader**

这个方法用于返回一个 ExtensionLoader 实例，主要逻辑如下：

- 先从缓存中获取与扩展类对应的 ExtensionLoader。
- 如果缓存未命中，则创建一个新的实例，保存到 EXTENSION_LOADERS 集合中缓存起来。
- 在 ExtensionLoader 构造方法中，初始化一个 objectFactory，后续会用到，暂时先不管。

~~~java
public static <T> ExtensionLoader<T> getExtensionLoader(Class<T> type) {
    // 避免篇幅过长，省略部分代码
    ExtensionLoader<T> loader = (ExtensionLoader<T>) EXTENSION_LOADERS.get(type);
    if (loader == null) {
        EXTENSION_LOADERS.putIfAbsent(type, new ExtensionLoader<T>(type));
        loader = (ExtensionLoader<T>) EXTENSION_LOADERS.get(type);
    }
    return loader;
}
// 构造方法
private ExtensionLoader(Class<?> type) {
    this.type = type;
    objectFactory = (type == ExtensionFactory.class ? null :
                     ExtensionLoader.getExtensionLoader(ExtensionFactory.class).getAdaptiveExtension());
}
~~~

**getExtension()**

这个方法用于根据指定名称获得对应的扩展点并返回。在前面的演示案例中，如果 name 是 mysqlDriver，那么返回的实现类应该是 MysqlDriver。

- name 用于参数的判断，其中，如果 `name = "true"`，则返回一个默认的扩展实现。
- 创建一个 Holder 对象，用户缓存该扩展点的实例。
- 如果缓存中不存在，则通过 createExtension(name) 创建一个扩展点。

~~~java
public T getExtension(String name) {
    if (StringUtils.isEmpty(name)) {
        throw new IllegalArgumentException("Extension name == null");
    }
    if ("true".equals(name)) { // 如果 name 的值
        return getDefaultExtension();
    }
    // 创建或者返回一个 Holder 对象，用于缓存实例
    final Holder<Object> holder = getOrCreateHolder(name);
    Object instance = holder.get();
    if (instance == null) { // 如果缓存中不存在，则创建一个实例
        synchronized (holder) {
            instance = holder.get();
            if (instance == null) {
                instance = createExtension(name);
                holder.set(instance);
            }
        }
    }
    return (T) instance;
}
~~~

上面这段代码非常简单，无非就是先查缓存，缓存未命中，则创建一个扩展对象。不难猜出，createExtension() 应该就是去指定的路径下查找 name 对应的扩展点的实现，并且实例化之后返回。

- 通过 getExtensionClasses().get(name) 获得一个扩展类。
- 通过反射实例化之后缓存到 EXTENSION_INSTANCES 集合中。
- injectExtension 实现依赖注入，后面会单独讲解。
- 把扩展类对象通过 Wrapper 进行包装。

~~~java
private T createExtension(String name) {
    // 根据 name 返回扩展类
    Class<?> clazz = getExtensionClasses().get(name);
    if (clazz == null) {
        throw findException(name);
    }
    try {
        // 从缓存中查找该类是否已经被初始化
        T instance = (T) EXTENSION_INSTANCES.get(clazz);
        if (instance == null) {
            EXTENSION_INSTANCES.putIfAbsent(clazz, clazz.newInstance());
            instance = (T) EXTENSION_INSTANCES.get(clazz);
        }
        // 依赖注入
        injectExtension(instance);
        // 通过 Wrapper 进行包装
        Set<Class<?>> wrapperClasses = cachedWrapperClasses;
        if (CollectionUtils.isNotEmpty(wrapperClasses)) {
            for (Class<?> wrapperClass : wrapperClasses) {
                instance = injectExtension((T) wrapperClass.getConstructor(type).newInstance(instance));
            }
        }
        initExtension(instance);
        return instance;
    } catch (Throwable t) {
        throw new IllegalStateException("Extension instance (name: " + name + ", class: "
                                        + type + ") couldn't be instantiated: " + t.getMessage(), t);
    }
}
~~~

在上述的代码中，第一部分是加载扩展类的关键实现，其他部分是辅助性的功能，其中依赖注入和 Wrapper 会单独来分析。我们继续来分析 getExtensionClasses().get(name) 这部分代码，核心是 getExtensionClasses，返回一个 Map 集合，Key 和 Value 分别对应配置文件中的 Key 和 Value。

- 从缓存中获取已经被加载的扩展类。
- 如果未命中缓存，则调用 loadExtensionClasses 加载扩展类。

~~~java
private Map<String, Class<?>> getExtensionClasses() {
    Map<String, Class<?>> classes = cachedClasses.get();
    if (classes == null) {
        synchronized (cachedClasses) {
            classes = cachedClasses.get();
            if (classes == null) {
                classes = loadExtensionClasses();
                cachedClasses.set(classes);
            }
        }
    }
    return classes;
}
~~~

Dubbo 中的代码实现套路基本都差不多，先访问缓存，缓存未命中再通过 loadExtensionClasses 加载扩展类，这个方法主要做两件事：

- 通过 cacheDefaultExtensionName 方法获得当前扩展接口的默认扩展对象，并且缓存。
- 调用 loadDirectory 方法加载指定文件目录下的配置文件。

~~~java
private Map<String, Class<?>> loadExtensionClasses() {
    cacheDefaultExtensionName(); // 获得当前 type 接口默认的扩展类
    
    Map<String, Class<?>> extensionClasses = new HashMap<>();
    // 解析指定路径下的文件
    loadDirectory(extensionClasses, DUBBO_INTERNAL_DIRECTORY, type.getName(), true);
    loadDirectory(extensionClasses, DUBBO_INTERNAL_DIRECTORY, type.getName().replace("org.apache", "com.alibaba"), true);
    
    loadDirectory(extensionClasses, DUBBO_DIRECTORY, type.getName());
    loadDirectory(extensionClasses, DUBBO_DIRECTORY, type.getName().replace("org.apache", "com.alibaba"));
    loadDirectory(extensionClasses, SERVICES_DIRECTORY, type.getName());
    loadDirectory(extensionClasses, SERVICES_DIRECTORY, type.getName().replace("org.apache", "com.alibaba"));
    return extensionClasses;
}
~~~

loadDirectory 方法的逻辑比较简单，无非就是从指定的目录下，根据传入的 type 全路径名找到对应的文件，解析内容后加载并保存到 extensionClasses 集合中。cacheDefaultExtensionName 方法也比较简单，但是它和业务有一定的关系，所以单独再分析一下。

- 获得指定扩展接口的 @SPI 注解
- 得到 @SPI 注解中的名字，保存到 cachedDefaultName 属性中。

~~~java
private void cacheDefaultExtensionName() {
    // 获得 type 类声明的注解 @SPI
    final SPI defaultAnnotation = type.getAnnotation(SPI.class);
    if (defaultAnnotation == null) {
        return;
    }
    // 得到注解中定义的 value 值
    String value = defaultAnnotation.value();
    if ((value = value.trim()).length() > 0) {
        String[] names = NAME_SEPARATOR.split(value);
        if (name.length > 1) {
            throw new IllegalStateException("More than 1 default extension name on extension "
                                            + type.getName() + ": " + Arrays.toString(names));
		}
        if (name.length == 1) {
            cachedDefaultName = names[0];
        }
    }
}
~~~

以 Dubbo 中的 org.apache.dubbo.rpc.Protocol 接口为例，在 @SPI 注解中有一个默认值 dubbo，这意味着如果没有显式地指定协议类型，默认采用 Dubbo 协议来发布服务。

~~~java
@SPI("dubbo")
public interface Protocol {
    // ...
}
~~~

这便是 Dubbo 中指定名称的扩展类加载的流程，其实并不是很复杂。

在分析 createExtension 方法时，如下代码片段没有分析，这段代码的主要作用是针对扩展类进行包装。

~~~java
Set<Class<?>> wrapperClasses = cachedWrapperClasses;
if (CollectionUtils.isNotEmpty(wrapperClasses)) {
    for (Class<?> wrapperClass : wrapperClasses) {
        instance = injectExtension((T) wrapperClass.getConstructor(type).newInstance(instance));
    }
}
~~~

这里其实用到的是装饰器模式，通过装饰器增强扩展类的功能。在分析它的源码实现之前，简单了解一下装饰器的作用。

在 Dubbo 源码包中的 META-INF/dubbo/internal 目录下，找到 org.apache.dubbo.rpc.Protocol 文件，内容如下：

~~~java
filter=org.apache.dubbo.rpc.protocol.ProtocolFilterWrapper
listener=org.apache.dubbo.rpc.protocol.ProtocolListenerWrapper
mock=org.apache.dubbo.rpc.support.MockProtocol
dubbo=org.apache.dubbo.rpc.support.dubbo.DubboProtocol
injvm=org.apache.dubbo.rpc.protocol.injvm.InjvmProtocol
rmi=org.apache.dubbo.rpc.protocol.rmi.RmiProtocol
hessian=org.apache.dubbo.rpc.protocol.hessian.HessianProtocol
http=org.apache.dubbo.rpc.protocol.http.HttpProtocol
// 省略部分代码
~~~

除了基本的以 Protocol 结尾的扩展类，有两个扩展类是比较特殊的，分别是 ProtocolFilterWrapper 和 ProtocolListenerWrapper，从名字来看像装饰类。可以猜测到，它们会对当前扩展点中原有的扩展类进行包装，假设当前的扩展点是 DubboProtocol，那么实际返回的扩展类对象可能为 ProtocolFilterWrapper（ProtocolListenerWrapper（DubboProtocol））。这个功能的实现代码如下：

~~~java
Set<Class<?>> wrapperClasses = cachedWrapperClasses;
if (CollectionUtils.isNotEmpty(wrapperClasses)) {
    for (Class<?> wrapperClass : wrapperClasses) {
        instance = injectExtension((T) wrapperClass.getConstructor(type).newInstance(instance));
    }
}
~~~

cachedWrapperClasses 集合就是当前扩展点中配置的 Wrapper 类，它是在 loadDirectory 方法中初始化的，代码路径是 loadDirectory → loadResource → loadClass。

~~~java
private void loadClass(Map<String, Class<?>> extensionClasses, java.net.URL resourceURL, Class<?> clazz, String name)
    throws NoSuchMethodException {
    // 省略部分代码
    if (clazz.isAnnotationPresent(Adaptive.class)) {
        cacheAdaptiveClass(clazz);
    } else if (isWrapperClass(clazz)) {
        cacheWrapperClass(clazz);
    } else {
        clazz.getConstructor();
    }
    // 省略部分代码
}
~~~

isWrapperClass 是判断方法，如果为 true，表示当前的 clazz 是一个装饰器类。这个判断逻辑很简单，就是判断 clazz 类中是否存在一个带有扩展类的构造函数，比如 ProtocolListenerWrapper 类，就有一个带有扩展类 Protocol 参数的构造函数。

~~~java
public class ProtocolListenerWrapper implements Protocol {
    private final Protocol protocol;
    
    public ProtocolListenerWrapper(Protocol protocol) {
        if (protocol == null) {
            throw new IllegalArgumentException("protocol == null");
        }
        this.protocol = protocol;
    }
}
~~~

得到这些装饰器类后保存到 cachedWrapperClasses 集合，然后遍历集合，通过 `wrapperClass.getConstructor(type).newInstance(instance)` 进行实例化。

### 4.8.3 无处不在的自适应扩展点

自适应（Adaptive）扩展点也可以理解为适配器扩展点。简单来说就是能够根据上下文动态匹配一个扩展类。它的使用方式如下：

~~~java
ExtensionLoader.getExtensionLoader(class).getAdaptiveExtension();
~~~

自适应扩展点通过 @Adaptive 注解来声明，它有两种使用方式：

- @Adaptive 注解定义在类上面，表示当前类为自适应扩展类。

  ~~~java
  @Adaptive
  public class AdaptiveCompiler implements Compiler {
      // 省略
  }
  ~~~

  AdaptiveCompiler 类就是自适应扩展类，通过 `ExtensionLoader.getExtensionLoader(Compiler.class).getAdaptiveExtension();` 可以返回 AdaptiveCompiler 类的实例。

- @Adaptive 注解定义在方法层面，会通过动态代理的方式生成一个动态字节码，进行自适应匹配。

  ~~~java
  @SPI("dubbo")
  public interface Protocol {
      int getDefaultPort();
      
      @Adaptive
      <T> Exporter<T> export(Invoke<T> invoker) throws RpcException;
      
      @Adaptive
      <T> Invoker<T> refer(Class<T> type, URL url) throws RpcException;
      // 省略部分代码
  }
  ~~~

  Protocol 扩展类中的两个方法声明了 @Adaptive 注解，意味着这是一个自适应方法。在 Dubbo 源码中很多地方通过下面这行代码来获得一个自适应扩展点：

  ~~~java
  Protocol protocol = ExtensionLoader.getExtensionLoader(Protocol.class).getAdaptiveExtension();
  ~~~

  但是，在 Protocol 源码的源码中，自适应扩展点的声明在方法层面上，所以它和类级别的声明不一样。这里的 protocol 实例，是一个动态代理类，基于 javassist 动态生成的字节码来实现方法级别的自适应调用。简单来说，调用 export 方法时，会根据上下文自动匹配到某个具体的实现类的 export 方法中。

接下来，基于 Protocol 的自适应扩展点方法 ExtensionLoader.getExtensionLoader(Protocol.class).getAdaptiveExtension() 来分析它的源码实现。

从源码来看，getAdaptiveExtension 方法非常简单，只做了两件事：

- 从缓存中获取自适应扩展点实例。
- 如果缓存未命中，则通过 createAdaptiveExtension 创建自适应扩展点。

~~~java
public T getAdaptiveExtension() {
    // 从缓存中获取自适应扩展点实例
    Object instance = this.cachedAdaptiveInstance.get();
    if (instance == null) {
        if (this.createAdaptiveInstanceError != null) {
            throw new IllegalStateException("Failed to create adaptive instance: " + this.createAdaptiveInstanceError.toString(), this.createAdaptiveInstanceError);
        }
        // 创建自适应扩展点实例，并放置到缓存中
        synchronized(this.cachedAdaptiveInstance) {
            instance = this.cachedAdaptiveInstance.get();
            if (instance == null) {
                try {
                    instance = this.createAdaptiveExtension();
                    this.cachedAdaptiveInstance.set(instance);
                } catch (Throwable var5) {
                    this.createAdaptiveInstanceError = var5;
                    throw new IllegalStateException("Failed to create adaptive instance: " + var5.toString(), var5);
                }
            }
        }
    }
    return instance;
}
~~~

按照之前对于自适应扩展点的分析，可以基本上猜测出 createAdaptiveExtension 方法的实现机制，我们来看它的源码。

- getAdaptiveExtensionClass 获得一个自适应扩展类的实例。
- injectExtension 完成依赖注入。

~~~java
private T createAdaptiveExtension() {
    try {
        return this.injectExtension(this.getAdaptiveExtensionClass().newInstance());
    } catch (Exception var2) {
        throw new IllegalStateException("Can't create adaptive extension " + this.type
                                        + ", cause: " + var2.getMessage(), var2);
    }
}
~~~

在这个方法中，并没有很多具体的逻辑，injectExtension 会在后面的章节来分析，我们继续看 getAdaptiveExtensionClass。

- 通过 getExtensionClasses 方法加载当前传入类型的所有扩展点，缓存在一个集合中。
- 如果 cachedAdaptiveClass 为空，则调用 createAdaptiveExtensionClass 进行创建。

~~~java
private Class<?> getAdaptiveExtensionClass() {
    this.getExtensionClasses();
    return this.cachedAdaptiveClass != null ? this.cachedAdaptiveClass
        : (this.cachedAdaptiveClass = this.createAdaptiveExtensionClass());
}
~~~

getExtensionClasses 方法在上一节中讲过，不知道大家是否还有印象，这里就不再重复分析了。如果 cachedAdaptiveClass 不为空，直接返回，这个类是什么大家应该能够猜测出来。cachedAdaptiveClass 应该是 load 在 loadDirectory 方法解析指定目录下扩展点的时候加载进来的。在加载完之后如果某个类上定义了 @Adaptive 注解，则会赋值给 cachedAdaptiveClass。

这里主要关注 createAdaptiveExtensionClass 方法，它涉及动态字节码的生成和加载。

- code 是一个动态拼接的类。
- 通过 Compiler 进行动态编译。

~~~java
private Class<?> createAdaptiveExtensionClass() {
    String code = (new AdaptiveClassCodeGenerator(this.type, this.cachedDefaultName)).generate();
    ClassLoader classLoader = findClassLoader();
    Compiler compiler = (Compiler)getExtensionLoader(Compiler.class).getAdaptiveExtension();
    return compiler.compile(code, classLoader);
}
~~~

在基于 Protocol 接口的自适应扩展点加载中，此时 code 拼接的字符串如下：

~~~java
public class Protocol$Adaptive implements Protocol {
    // 省略部分代码
    public Exporter export(Invoker arg0) throws org.apache.dubbo.rpc.RpcException {
        if (arg0 == null)
            throw new IllegalArgumentException("Invoker argument == null");
        if (arg0.getUrl() == null)
            throw new IllegalArgumentException("Invoker argument getUrl() == null");
        URL url = arg0.getUrl();
        String extName = (url.getProtocol() == null ? "dubbo" : url.getProtocol());
        if (extName == null)
            throw new IllegalStateException("Failed to get extension (Protocol) name from url ("
                                            + url.toString() + ") use keys([protocol])");
        // 根据名称获得指定扩展点
        Protocol extension = ExtensionLoader.getExtensionLoader(Protocol.class).getExtension(extName);
        return extension.export(arg0);
    }
    
    public Invoker refer(Class arg0, URL arg1) throws RpcException {
        if (arg1 == null)
            throw new IllegalArgumentException("url == null");
        URL url = arg1;
        String extName = (url.getProtocol() == null ? "dubbo" : url.getProtocol());
        if (extName = null)
            throw new IllegalStateException("Failed to get extension (Protocol) name from url ("
                                            + url.toString() + ") use keys([protocol])");
        Protocol extension = ExtensionLoader.getExtensionLoader(Protocol.class).getExtension(extName);
        return extension.refer(arg0, arg1);
    }
}
~~~

Protocol$Adaptive 是一个动态生成的自适应扩展类，可以按照下面这种方式使用：

~~~java
Protocol protocol = ExtensionLoader.getExtensionLoader(Protocol.class).getAdaptiveExtension();
protocol.export(...);
~~~

当调用 protocol.export() 时，实际上会调用 Protocol$Adaptive 类中的 export 方法。而这个方法，无非就是根据 Dubbo 服务配置的协议名称，通过 getExtension 获得相应的扩展类。

~~~java
public Exporter export(Invoker arg0) throws org.apache.dubbo.rpc.RpcException {
    URL url = arg0.getUrl();
    String extName = (url.getProtocol() == null ? "dubbo" : url.getProtocol());
    Protocol extension = ExtensionLoader.getExtensionLoader(Protocol.class).getExtension(extName);
    return extension.export(arg0);
}
~~~

所以，整体来看 Protocol$Adaptive 其实就是一种适配器模式，根据上下文信息自动适配到相应的协议扩展点来完成服务的发布。

### 4.8.4 Dubbo 中的 IoC 和 AOP

IoC（控制反转）和 AOP（面向切面）我们并不陌生，它是 Spring Framework 中的核心功能。实际上 Dubbo 中也用到了这两种机制。下面从源码层面逐个来分析这两种机制的体现。

#### 4.8.4.1 IoC

IoC 中一个非常重要的思想是，在系统运行时，动态地向某个对象提供它所需要的其他对象，这种机制是通过 Dependency Injection（依赖注入）来实现的。

在分析 Dubbo SPI 机制时，createExtension 方法中有一段代码如下：

~~~java
private T createExtension(String name) {
    // 省略部分代码
    try {
        T instance = (T) EXTENSION_INSTANCES.get(clazz);
        if (instance == null) {
            EXTENSION_INSTANCES.putIfAbsent(clazz, clazz.newInstance());
            instance = (T) EXTENSION_INSTANCES.get(clazz);
        }
        injectExtension(intance);
        // 省略部分代码
        return instance;
    } catch (Throwable t) {
        // 省略部分代码
    }
}
~~~

injectExtension 就是依赖注入的实现，整体逻辑比较简单：

- 遍历被加载的扩展类中所有的 set 方法。
- 得到 set 方法中的参数类型，如果参数类型是对象类型，则获得这个 set 方法中的属性名称。
- 使用自适应扩展点加载该属性名称对应的扩展类。
- 调用 set 方法完成赋值。

~~~java
private T injectExtension(T instance) {
    if (objectFactory == null) {
        return instance;
    }
    
    try {
        for (Method method : instance.getClass().getMethods()) {
            if (!isSetter(method)) {
                continue;
            }
            if (method.getAnnotation(DisableInject.class) != null) {
                continue;
            }
            // 获得扩展类中方法的参数类型
            Class<?> pt = method.getParameterTypes()[0];
            // 如果不是对象类型，则跳过
            if (ReflectUtils.isPrimitives(pt)) {
                continue;
            }
            try {
                // 获得方法对应的属性名称
                String property = getSetterProperty(method);
                // 根据 class 及 name，使用自适应扩展点加载并且通过 set 方法进行赋值
                Object object = objectFactory.getExtension(pt, property);
                if (object != null) {
                    method.invoke(instance, object);
                }
            } catch (Exception e) {
                logger.error("Failed to inject via method " + method.getName()
                            + " of interface " + type.getName() + ": " + e.getMessage(), e);
            }
        }
    } catch (Exception e) {
        logger.error(e.getMessage(), e);
    }
    return instance;
}
~~~

简单来说，injectExtension 方法的主要功能就是，如果当前加载的扩展类存在一个成员对象，并且为它提供了 set 方法，那么就会通过自适应扩展点进行加载并赋值。以 org.apache.dubbo.registry.integration.RegistryProtocol 类为例，它里面有一个 Protocol 成员对象，并且为它提供了 setProtocol 方法，那么当 RegistryProtocol 扩展类被加载时，就会自动注入 protocol 成员属性的实例。

~~~java
public class RegistryProtocol implements Protocol {
    // 省略部分代码
    private Protocol protocol;
    
    public void setProtocol(Protocol protocol) {
        this.protocol = protocol;
    }
    // 省略部分代码
}
~~~

#### 4.8.4.2 AOP

AOP 全称为 Aspect Oriented Programming，意思是面向切面编程，它是一种思想或者编程范式。它的主要意图是把业务逻辑和功能逻辑分离，然后在运行期间或者类加载期间进行织入。这样做的好处是，可以降低代码的复杂性，以及提高重用性。

在 Dubbo SPI 机制中，同样在 ExtensionLoader 类中的 createExtension 方法中体现了 AOP 的设计思想。

~~~java
private T createExtension(String name) {
    // ...
    try {
        // ...
        Set<Class<?>> wrapperClasses = cachedWrapperClasses;
        if (CollectionUtils.isNotEmpty(wrapperClasses)) {
            for (Class<?> wrapperClass : wrapperClasses) {
                instance = injectExtension((T) wrapperClass.getConstructor(type).newInstance(instance));
            }
        }
        initExtension(instance);
        return instance;
    } catch (Throwable t) {
        // ...
    }
}
~~~

这段代码在前面的章节中讲过，仔细分析一下下面这行代码：

~~~java
instance = injectExtension((T) wrapperClass.getConstructor(type).newInstance(instance));
~~~

其中分别用到了依赖注入和 AOP 思想，AOP 思想的体现是基于 Wrapper 装饰器类实现对原有扩展类 instance 进行包装。

### 4.8.5 Dubbo 和 Spring 完美集成的原理

使用 Dubbo 最方便的地方在于，它和 Spring 能够非常方便地集成，在享受这种便利的同时，难免会思考并挖掘它的实现原理。实际上，Dubbo 对于配置的优化，也是随着 Spring 一同发展的，从最早的 XML 形式到后来的注解方式及自动装配，都是在不断地简化开发过程以提升开发效率。

在 Spring Boot 集成 Dubbo 这个案例中，服务发布主要有以下几个步骤：

- 添加 dubbo-spring-boot-starter 依赖。
- 定义 @org.apache.dubbo.config.annotation.Service 注解。
- 声明 @DubboComponentScan，用于扫描 @Service 注解。

基于前面的分析，其实不难猜出它的实现原理。@Service 与 Spring 中的 @org.springframework.stereotype.Service，用于实现 Dubbo 服务的暴露。与它相对应的是 @Reference，它的作用类似于 Spring 中的 @Autowired。

而 @DubboComponentScan 和 Spring 中的 @ComponentScan 作用类似，用于扫描 @Service、@Reference 等注解。下面我们通过源码逐步分析它的实现机制。

#### 4.8.5.1 @DubboComponentScan 注解解析

DubboComponentScan 注解的定义如下，这个注解主要通过 @Import 导入一个 DubboComponentScanRegistrar 类。

~~~java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Import(DubboComponentScanRegistrar.class)
public @interface DubboComponentScan {
    String[] value() default {};
    
    String[] basePackages() default {};
    
    Class<?>[] basePackageClasses() default {};
}
~~~

DubboComponentScanRegistrar 实现了 ImportBeanDefinitionRegistrar 接口，并且重写了 registerBeanDefinition 方法。

- 获取扫描包的路径，在默认情况下扫描当前配置类所在的包。
- 注册 @Service 注解的解析类。
- 注册 @Reference 注解的解析类。

~~~java
public class DubboComponentScanRegistrar implements ImportBeanDefinitionRegisterar {
    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetaData, BeanDefinitionRegistry registry) {
        // 获取扫描包的路径
        Set<String> packagesToScan = getPackagesToScan(importingClassMetadata);
        // 注册 @Service 的解析类
        registerServiceAnnotationBeanPostProcessor(packagesToScan, registry);
        // 注册 @Reference 的解析类
        registerReferenceAnnotationBeanPostProcessor(registry);
    }
    // ...
}
~~~

ImportBeanDefinitionRegistrar 是 Spring 提供的一种动态注入 Bean 的机制，和前面章节中讲过的 ImportSelector 接口的功能类似。在 registerBeanDefinitions 方法中，主要会实例化一些 BeanDefinition 注入 Spring IoC 容器。

继续看 registerServiceAnnotationBeanPostProcessor 方法，逻辑很简单，就是把 ServiceAnnotationBeanPostProcessor 注册到容器。

~~~java
private void registerServiceAnnotationBeanPostProcessor(Set<String> packagesToScan, BeanDefinitionRegistry registry) {
    // 构建 ServiceAnnotationBeanPostProcessor 的 BeanDefinitionBuilder
    BeanDefinitionBuilder builder = rootBeanDefinition(ServiceAnnotationBeanPostProcessor.class);
    builder.addConstructorArgValue(packagesToScan);
    builder.setRole(BeanDefinition.ROLE_INFRASTRUCTURE);
    AbstractBeanDefinition beanDefinition = builder.getBeanDefinition();
    // 将 beanDefinition 注册到 IoC 容器
    BeanDefinitionReaderUtils.registerWithGeneratedName(beanDefinition, registry);
}
~~~

总的来看，@DubboComponentScan 只是注入一个 ServiceAnnotationBeanPostProcessor（用于解析 @Service） 和一个 ReferenceAnnotationBeanPostProcessor （用于解析 @Reference）对象。

#### 4.8.5.2 ServiceAnnotationBeanPostProcessor

ServiceAnnotationBeanPostProcessor 类的定义如下，在 org.apache.dubbo.config.spring.beans.factory.annotation 包路径下，核心逻辑是解析 @Service 注解。

~~~java
public class ServiceAnnotationBeanPostProcessor
    implements BeanDefinitionRegistryPostProcessor, EnvironmentAware, ResourceLoaderAware, BeanClassLoaderAware {}
~~~

BeanDefinitionRegistryPostProcessor 接口继承自 BeanFactoryPostProcessor，是一种比较特殊的 BeanFactoryPostProcessor。BeanDefinitionRegistryPostProcessor 中定义的 postProcessBeanDefinitionRegistry 方法可以让我们实现自定义的 Bean 定义的逻辑。

下面具体分析 postProcessBeanDefinitionRegistry 方法，主要逻辑是：

- 调用 registerBeans 注册 DubboBootstrapApplicationListener 类。
- 通过 resolvePackagesToScan 对 packagesToScan 参数进行去空格处理，并把配置文件中配置的扫描参数也一起处理一下。
- 调用 registerServiceBeans 完成 Bean 的注册。

~~~java
public void postProcessBeanDefinitionRegistry(BeanDefinitionRegistry registry) throws BeansException {
    // @since 2.7.5
    registerBeans(registry, DubboBootstrapApplicationListener.class);
    Set<String> resolvedPackagesToScan = resolvePackagesToScan(packagesToScan);
    if (!CollectionUtils.isEmpty(resolvedPackagesToScan)) {
        registerServiceBeans(resolvedPackagesToScan, registry);
    } else {
        if (logger.isWarnEnabled()) {
            logger.warn("packagesToScan is empty, ServiceBean registry will be ignored!");
        }
    }
}
~~~

核心逻辑在 registerServiceBeans 方法中，这个方法会查找需要扫描的指定包里面有 @Service 注解的类并注册成 Bean。

- 定义 DubboClassPathBeanDefinitionScanner 扫描对象，扫描指定路径下的类，将符合条件的类装配到 IoC 容器。
- BeanNameGenerator 是 Beans 体系中比较重要的一个组件，会通过一定的算法计算出需要装配的 Bean 的 name。
- addIncludeFilter 设置 Scan 的过滤条件，只扫描 @Service 注解修饰的类。
- 遍历指定的包。通过 findServiceBeanDefinitionHolders 查找 @Service 注解修饰的类。
- 通过 registerServiceBean 完成 Bean 的注册。

~~~java
private void registerServiceBeans(Set<String> packagesToScan, BeanDefinitionRegistry registry) {
    // 定义扫描对象
    DubboClassPathBeanDefinitionScanner scanner =
        new DubboClassPathBeanDefinitionScanner(registry, environment, resourceLoader);
    // beanName 解析器
    BeanNameGenerator beanNameGenerator = resolveBeanNameGenerator(registry);
    scanner.setBeanNameGenerator(beanNameGenerator);
    // 添加过滤器，用于过滤 @Service 注解修饰的对象
    scanner.addIncludeFilter(new AnnotationTypeFilter(Service.class));
    scanner.addIncludeFilter(new AnnotationTypeFilter(com.alibaba.dubbo.config.annotation.Service.class));
    for (String packageToScan : packagesToScan) {
        scanner.scan(packageToScan);
        // 查找 @Service 修饰的类
        Set<BeanDefinitionHolder> beanDefinitionHolders =
            findServiceBeanDefinitionHolders(scanner, packageToScan, registry, beanNameGenerator);
        if (!CollectionUtils.isEmpty(beanDefinitionHolders)) {
            for (BeanDefinitionHolder beanDefinitionHolder : beanDefinitionHolders) {
                // 注册 Bean
                registerServiceBean(beanDefinitionHolder, registry, scanner);
            }
        }
        // 省略部分代码
    }
}
~~~

这段代码其实也比较简单，主要作用就是通过扫描指定路径下添加了 @Service 注解的类，通过 registryServiceBean 来注册 ServiceBean。整体来看，Dubbo 的注解扫描进行服务发布的过程，实际上就是基于 Spring 的扩展。

继续来分析 registerServiceBean 方法，这里的 ServiceBean 是指 org.apache.dubbo.config.spring.ServiceBean。

- resolveClass 获取 BeanDefinitionHolder 中的 Bean。
- findServiceAnnotation 方法会从 beanClass 类中找到 @Service 注解。
- getAnnotationAttributes 获得注解中的属性，比如 loadbalance、cluster 等。
- resolveServiceInterfaceClass 用于获得 beanClass 对应的接口定义，这里要注意的是，在 `@Service(interfaceClass = IHelloService.class)` 注解中也可以声明 interfaceClass，注解中声明的优先级最高，如果没有声明该属性，则会从父类中查找。
- annotatedServiceBeanName 代表 Bean 的名称。
- 从名字可以看出，buildServiceBeanDefinition 用来构造 org.apache.dubbo.config.spring.ServiceBean 对象。每个 Dubbo 服务的发布最终都会出现一个 ServiceBean。
- 调用 registerBeanDefinition 将 ServiceBean 注入 Spring IoC 容器。

~~~java
private void registerServiceBean(BeanDefinitionHolder beanDefinitionHolder,
                                 BeanDefinitionRegistry registry,
                                 DubboClassPathBeanDefinitionScanner scanner) {
    // 获得需要发布的服务类
    Class<?> beanClass = resolveClass(beanDefinitionHolder);
    // 得到该服务类上的注解
    Annotation service = findServiceAnnotation(beanClass);
    // 获得注解中的属性
    AnnotationAttributes serviceAnnotationAttributes = getAnnotationAttributes(service, false, false);
    // 获得服务类的接口声明
    Class<?> interfaceClass = resolveServiceInterfaceClass(serviceAnnotationAttributes, beanClass);
    
    String annotatedServiceBeanName = beanDefinitionHolder.getBeanName();
    // 构造 ServiceBean
    AbstractBeanDefinition serviceBeanDefinition =
        buildServiceBeanDefinition(service, serviceAnnotationAttributes, interfaceClass, annotatedServiceBeanName);
    // 生成 ServiceBean 的 beanName
    String beanName = generateServiceBeanName(serviceAnnotationAttributes, interfaceClass);
    // check duplicated candidate bean
    if (scanner.checkCandidate(beanName, serviceBeanDefinition)) {
        // 完成注册
        registry.registerBeanDefinition(beanName, serviceBeanDefinition);
        // 省略部分代码
    }
}
~~~

从整个代码分析来看，在 registerServiceBean 方法中主要是把一个 ServiceBean 注入 Spring IoC 容器中。读者看到这里可能会有点晕，以如下代码为例：

~~~java
@Service
public class HelloServiceImpl implements IHelloService {
}
~~~

它并不是像普通的 Bean 注入一样直接将 HelloServiceImpl 对象的实例注入容器，而是注入一个 ServiceBean 对象。对于 HelloServiceImpl 来说，它并不需要把自己注入 Spring IoC 容器，而是需要把自己发布到网络上，提供给网络上的服务消费者来访问。那么它是怎么发布到网络上的呢？

不知道大家是否还记得前面分析 postProcessBeanDefinitionRegistry 方法的时候，有一个 registryBeans 方法，它注册了一个 DubboBootstrapApplicationListener 事件监听 Bean。

~~~java
public class DubboBootstrapApplicationListener
    extends OneTimeExecutionApplicationContextEventListener implements Ordered {
    private final DubboBootstrap dubboBootstrap;
    public DubboBootstrapApplicationListener() {
        this.dubboBootstrap = DubboBootstrap.getInstance();
    }
    @Override
    public void onApplicationContextEvent(ApplicationContextEvent event) {
        if (event instanceof ContextReferencedEvent) {
            onContextRefreshedEvent((ContextReferencedEvent) event);
        } else if (event instanceof ContextClosedEvent) {
            onContextClosedEvent((ContextClosedEvent) event);
        }
    }
    private void onContextRefreshedEvent(ContextRefreshedEvent event) {
        dubboBootstrap.start();
    }
    // 省略
}
~~~

当所有的 Bean 都处理完成之后，Spring IoC 会发布一个事件，事件类型为 ContextRefreshedEvent，当触发这个事件时，会调用 onContextRefreshedEvent 方法。在这个方法中，可以看到 Dubbo 服务启动的触发机制 `dubboBootstrap.start()`。“一路跟进下去”，便可以进入 org.apache.dubbo.config.ServiceConfig 类中的 export() 方法，这个方法启动一个网络监听，从而实现服务发布。

# 第5章 服务注册与发现

服务消费者要去调用多个服务提供者组成的集群。首先，服务消费者需要在本地配置文件中维护服务提供者集群的每个节点的请求地址。其次，服务提供者集群中如果某个节点下线或者宕机，服务消费者的本地配置中需要同步删除这个节点的请求地址，防止请求发送到已宕机的节点下线或者宕机，服务消费者的本地配置中需要同步删除这个节点的请求地址，防止请求发送到已宕机的节点上造成请求失败。为了解决这类的问题，就需要引入服务注册中心，它主要有以下功能：

- 服务地址的管理
- 服务注册
- 服务动态感知

## 5.1 什么是 Alibaba Nacos

Nacos 致力于解决微服务中的统一配置、服务注册与发现等问题。它提供了一组简单易用的特性集，帮助开发者快速实现动态服务发现、服务配置、服务元数据及流量管理及流量管理。

Nacos 的关键特性如下。

### 服务发现和服务健康监测

Nacos 支持基于 DNS 和基于 RPC 的服务发现。服务提供者使用原生 SDK、OpenAPI 或一个独立的 Agent TODO 注册 Service 后，服务消费者可以使用 DNS 或 HTTP & API 查找和发现服务。

Nacos 提供对服务的实时的健康检查，阻止向不健康的主机或服务实例发送请求。Nacos 支持传输层（PING 或 TCP）和应用层（如 HTTP、MySQL、用户自定义）的健康检查。对于复杂的云环境和网络拓扑环境中（如 VPC、边缘网络等）服务的健康检查，Nacos 提供了 agent 上报和服务端主动检测两种健康检查模式。Nacos 还提供了统一的健康检查仪表盘，帮助用户根据健康状态管理服务的可用性及流量。

### 动态配置服务

业务服务一般都会维护一个本地配置文件，然后会把一些常量配置到这个文件中。这种方式在某些场景中会存在问题，比如配置需要变更时要重新部署应用。而动态配置服务可以以中心化、外部化和动态化的方式管理所有环境的应用配置和服务配置，可以使配置管理变得更加高效和敏捷。配置中心化管理让实现无状态服务变得更简单，让服务按需弹性扩展变得更容易。

另外，Nacos 提供了一个简洁易用的 UI（控制台样例 Demo）帮助用户管理所有服务和应用的配置。Nacos 还提供了包括配置版本跟踪、金丝雀发布、一键回滚配置及客户端配置更新状态跟踪在内的一系列开箱即用的配置管理特性，帮助用户更安全地在生产环境中管理配置变更，降低配置变更带来的风险。

### 动态 DNS 服务

动态 DNS 服务支持权重路由，让开发者更容易地实现中间层负载均衡、更灵活的路由策略、流量控制，以及数据中心内网的简单 DNS 解析服务。

### 服务及其元数据管理

Nacos 可以使开发者从微服务平台建设的视角管理数据中心的所有服务及元数据，包括管理服务的描述、生命周期、服务的静态依赖分析、服务的健康状态、服务的流量管理、路由及安全策略、服务的 SLA 及最重要的 metrics 统计数据。

## 5.2 Nacos 的基本使用

### 5.2.1 Nacos 的安装

Nacos 支持三种部署模式，分别是单机、集群和多集群。需要注意的是，Nacos 依赖 Java 环境，并且要求使用 JDK 1.8 以上版本。

### 5.2.2 Nacos 服务发现注册相关 API 说明

Nacos 提供了 SDK 及 Open API 的方式来完成服务注册和发现等操作，由于服务端只提供了 REST 接口，所以 SDK 本质上是对于 HTTP 请求的封装。下面简单列一下和服务注册相关的核心接口。

#### 注册实例

将服务地址信息注册到 Nacos Server：

```java
Open API: /nacos/v1/ns/instance (POST)
SDK:
void registerInstance(String serviceName, String ip, int port) throws NacosException;
void registerInstance(String serviceName, String ip, int port, String clusterName) throws NacosException;
void registerInstance(String serviceName, Instance instance) throws NacosException;
```

参数说明如下。

- serviceName：服务名称。
- ip：服务实例 IP。
- port：服务实例 Port。
- clusterName：集群名称，表示该服务实例属于哪个集群。
- instance：实例属性，实际上就是把上面这些参数封装成一个对象。

调用方式：

```java
NamingService naming = NamingFactory.createNamingService(System.getProperty("serveAddr"));
naming.registerInstance("nacos_test", "192.168.1.1", 8080, "DEFAULT");
```

#### 获取全部实例

根据服务名称从 Nacos Server 上获取所有服务实例：

```java
Open API: /nacos/v1/ns/instance/list (GET)
SDK:
List<Instance> getAllInstance(String serviceName) throws NacosException;
List<Instance> getAllInstance(String serviceName, List<String> clusters) throws NacosException;
```

参数说明如下：

- serviceName：服务名称
- cluster：集群列表，可以传递多个值。

调用方式：

```java
NamingService naming = NamingFactory.createNamingService(System.getProperty("serveAddr"));
System.out.println(naming.getAllInstances("nacos_test", true));
```

#### 监听服务

监听服务是指监听指定服务下的实例变化。在前面的分析中我们知道，客户端从 Nacos Server 上获取的实例必须是健康的，否则会造成客户端请求失败。监听服务机制可以让客户端及时感知服务提供者实例的变化。

```java
Open API: /nacos/v1/ns/instance/list (GET)
SDK:
void subscribe(String serviceName, EventListener listener) throws NacosException;
void subscribe(String serviceName, List<String> clusters, EventListener listener) throws NacosException;
```

参数说明如下：

- EventListener：当服务提供者实例发生上、下线时，会触发一个事件回调。

需要注意的是，监听服务的 Open API 也访问 /nacos/v1/ns/instance/list，具体的原理会在源码分析中讲解。

服务监听有两种方式：

- 第一种是客户端调用 /nacos/v1/ns/instance/list 定时轮询。
- 第二种是基于 DatagramSocket 的 UDP 协议，实现服务端的主动推送。

### 5.2.3 Nacos 集成 Spring Boot 实现服务注册与发现

本节通过 Spring Boot 集成 Nacos 实现一个简单的服务注册与发现功能。

- 创建一个 Spring Boot 工程 spring。

- 添加 Maven 依赖。

  ```xml
  <dependency>
      <groupId>com.alibaba.boot</groupId>
      <artifactId>nacos-discovery-spring-boot-starter</artifactId>
      <version>0.2.4</version>
  </dependency>
  ```

- 创建 DiscoveryController 类，通过 `@NacosInjected` 注入 Nacos 的 NamingService，并提供 discovery 方法，可以根据服务名称获得注册到 Nacos 上的服务地址。

  ```java
  @RestController
  public class DiscoveryController {
      @NacosInjected
      private NamingService namingService;
      
      @GetMapping("/discovery")
      public List<Instance> discovery(@RequestParam String serviceName) throws NacosException {
          return namingService.getAllInstances(serviceName);
      }
  }
  ```

- 在 application.properties 中添加 Nacos 服务地址的配置。

  ```properties
  nacos.discovery.server-addr=127.0.0.1:8848
  ```

- 启动 SpringBootNacosDiscoveryApplication，调用 `curl http://127.0.0.1:8080/discovery?serviceName=example` 去 Nacos 服务器上查询服务名称 example 所对应的地址信息，此时由于 Nacos Server 并没有 example 的服务实例，返回一个空的 JSON 数组[]。

- 接着，通过 Nacos 提供的 Open API，向 Nacos Server 注册一个名字为 example 的服务。

  ```sh
  curl -X PUT 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=example&ip=127.0.0.1&port=8080'
  ```

- 再次访问 `curl http://127.0.0.1:8080/discovery?serviceName=example`，将返回以下信息。

  ```json
  [
      {
          instanceId: "127.0.0.1#8080#DEFAULT#DEFAULT_GROUP@@example",
          ip: "127.0.0.1",
          port: 8080,
          weight: 1,
          healthy: true,
          enabled: true,
          ephemeral: true,
          clusterName: "DEFAULT",
          serviceName: "DEFAULT_GROUP@@example",
          metadata: {},
          instanceHeartBeatInterval: 5000,
          instanceIdGenerator: "simple",
          instanceHeartBeatTimeOut: 15000,
          ipDeleteTimeout: 30000
      }
  ]
  ```

## 5.3 Nacos 的高可用部署

在分布式架构中，任何中间件或者应用都不允许单点存在，所以开源组件一般都会自己支持高可用集群解决方案。Nacos 提供了类似于 ZooKeeper 的集群架构，包含一个 Leader 节点和多个 Follower 节点。和 ZooKeeper 不同的是，它的数据一致性算法采用的是 Raft，同样采用了该算法的中间件有 Redis Sentinel 的 Leader 选举、Etcd 等。

## 5.4 Dubbo 使用 Nacos 实现注册中心

Dubbo 可以支持多种注册中心，比如在前面章节中讲的 ZooKeeper，以及 Consul、Nacos 等。本节主要讲解如何使用 Nacos 作为 Dubbo 服务的注册中心，为 Dubbo 提供服务注册与发现的功能，实现步骤如下。

- 创建一个普通 Maven 项目 spring-boot-dubbo-nacos-sample，添加两个模块：nacos-sample-api 和 nacos-sample-provider。其中，nacos-sample-provider 是一个 Spring Boot 工程。

- 在 nacos-sample-api 中声明接口

  ```java
  public interface IHelloService {
      String sayHello(String name);
  }
  ```

- 在 nacos-sample-provider 中添加依赖。

  ```xml
  <dependency>
      <groupId>com.gupaoedu.book.nacos</groupId>
      <version>1.0-SNAPSHOT</version>
      <artifactId>nacos-sample-api</artifactId>
  </dependency>
  <dependency>
      <groupId>com.alibaba.boot</groupId>
      <artifactId>nacos-discovery-spring-boot-starter</artifactId>
      <version>0.2.4</version>
      <exclusions>
          <exclusion>
              <groupId>com.alibaba.spring</groupId>
              <artifactId>spring-context-support</artifactId>
          </exclusion>
      </exclusions>
  </dependency>
  <dependency>
      <groupId>org.apache.dubbo</groupId>
      <artifactId>dubbo-spring-boot-starter</artifactId>
      <version>2.7.5</version>
  </dependency>
  ```

  上述依赖包的简单说明如下：

  - dubbo-spring-boot-starter，Dubbo 的 Starter 组件，添加 Dubbo 依赖。
  - nacos-discovery-spring-boot-starter，Nacos 的 Starter 组件。
  - nacos-sample-api，接口定义类的依赖。

- 创建 HelloServiceImpl 类，实现 IHelloService 接口。

  ```java
  @Service
  public class HelloServiceImpl implements IHelloService {
      @Override
      public String sayHello(String name) {
          return "Hello World:" + name;
      }
  }
  ```

- 修改 application.properties 配置。仅将 dubbo.registry.address 中配置的协议改成了 `nacos://127.0.0.1:8848`，基于 Nacos 协议。

  ```properties
  dubbo.application.name=spring-boot-dubbo-nacos-sample
  dubbo.registry.address=nacos://127.0.0.1:8848
  
  dubbo.protocol.name=dubbo
  dubbo.protocol.port=20880
  ```

- 运行 Spring Boot 启动类，注意需要声明 `@DubboComponentScan`。

  服务启动成功后，访问 Nacos 控制台，进入 “服务管理” → “服务列表”，可以看到所有注册在 Nacos 上的服务。

## 5.5 Spring Cloud Alibaba Nacos Discovery

Nacos 作为 Spring Cloud Alibaba 中服务注册与发现的核心组件，可以很好地帮助开发者将服务自动注册到 Nacos 服务端，并且能够动态感知和刷新某个服务实例的服务列表。使用 Spring Cloud Alibaba Nacos Discovery 可以基于 Spring Cloud 规范快速接入 Nacos，实现服务注册与发现功能。

在本节中，我们通过将 Spring Cloud Alibaba Nacos Discovery 集成到 Spring Cloud Alibaba Dubbo，完成服务注册与发现的功能。

### 5.5.1 服务端开发

创建一个普通的 Maven 项目 spring-cloud-nacos-sample，在项目中添加两个模块：

- spring-cloud-nacos-sample-api，暴露服务接口，作为服务提供者及服务消费者的接口契约。
- spring-cloud-nacos-sample-provider，项目类型为 Spring Cloud，它是接口的实现。

项目的创建方式和类型与前面所演示的步骤一样。服务提供方的操作步骤如下：

- 在 spring-cloud-nacos-sample-api 项目中定义一个接口 IHelloService。
- 
