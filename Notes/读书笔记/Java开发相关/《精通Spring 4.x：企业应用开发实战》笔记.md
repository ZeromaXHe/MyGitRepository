# 第一篇 基础篇

# 第1章 Spring概述

## 1.1 认识Spring

Spring是分层的Java SE/EE应用一站式的轻量级开源框架，以IoC(Inverse of Control，控制反转)和AOP（Aspect Oriented Programming，切面编程）为内核，提供了展现层Spring MVC、持久层Spring JDBC及业务层事务管理等一站式的企业级应用技术。此外，Spring以海纳百川的胸怀整合了开源世界里众多著名的第三方框架和类库，逐渐成为使用最多的轻量级JavaEE企业应用开源框架。

Spring的缔造者Rod Johnson

## 1.2 关于SpringSource

当Spring1.0发布时，Rod就和他的骨干团队成立了SpringSource公司，以商业化的方式对开源的Spring进行运作。以Spring应用的开源框架为依托，成功开展了很多代表不同技术领域的子项目，将Spring的触角延伸到应用安全、云计算、批量数据处理等技术领域。

## 1.3 Spring带给我们什么

也许有很多开发者曾经被EJB的过度宣传所迷惑，成为EJB的拥趸者，并因此拥有一段痛苦的开发经历。EJB的复杂源于它对所有的企业应用采用统一的标准，它认为所有的企业应用都需要分布式对象、远程事务，因此造就了EJB框架的极度复杂。这种复杂不仅造成了陡峭的学习曲线，而且给开发、测试、部署工作造成了很多额外的要求和工作量。其中最大的诟病就是难于测试，因为这种测试不能脱离EJB容器，每次测试都需要进行应用部署并启动EJB容器，而部署和启动EJB容器是一项费时费力的重型操作，其结果是测试工作往往成为开发工作的瓶颈。

但EJB并非一无是处，它提供了很多可圈可点的服务，如声明事务、透明持久化等。Spring承认EJB中存在优秀的东西，只是它的实现太复杂、要求过严过高，所以Spring在努力提供类似服务的同时尽量简化开发，Spring认为Java EE的开发应该更容易、更简单。在实现这一目标时，Spring一直贯彻并遵守”好的设计优于具体实现，代码应易于测试“这一理念，最终带给我们一个易于开发、便于测试且功能齐全的开发框架。概括起来，Spring给我们带来以下好处。

- 方便解耦，简化开发。通过Spring提供的IoC容器，用户可以将对象之间的依赖关系交由Spring进行控制，避免硬编码所造成的过度程序耦合。有了Spring，用户不必再为单实例模式类、属性文件解析等这些底层的需求编写代码，可以更专注于上层的应用。

- AOP编程的支持。通过Spring提供的AOP功能，方便进行面向切面的编程，很多不容易用传统OOP实现的功能可以通过AOP轻松应对。

- 声明式事务的支持。在Spring中，用户可以从单调烦闷的事务管理代码中解脱出来，通过声明的方式灵活地进行事务管理，提高开发效率和质量。

- 方便程序地测试。可以用非容器依赖的编程方式进行几乎所有的测试工作。在Spring里，测试不再是昂贵的操作，而是随手可做的事情。

- 方便集成各种优秀框架。Spring不排斥各种优秀的开源框架，相反，Spring可以降低各种框架的使用难度。Spring提供了对各种优秀框架（如Struts、Hibernate、Hessian、Quartz等）的直接支持。

- 降低Java EE API的使用难度。Spring对很多难用的Java EE API（如JDBC、JavaMail、远程调用等）提供了一个薄层封装，通过Spring的简易封装，这些Java EE API的使用难度大大降低。

- Java源码是经典的学习范例。Spring的源码设计精妙、结构清晰、匠心独运，处处体现着大师对Java设计模式的灵活运用及对Java技术的高深造诣。Spring框架源码无疑是Java技术的最佳实践范例。如果想在短时间内迅速提高自己的Java技术水平和应用开发水平，学习和研究Spring源码将会收到意想不到的效果。

## 1.4 Spring体系结构

Spring核心框架由4000多个类组成，整个框架按其所属功能可以划分为5个主要模块。

~~~
IoC:            Bean, Context, 表达式语言
AOP:            Spring AOP, Aspects, Instrument
数据访问和集成:    JDBC, ORM, OXM, JMS, 事务管理
Web及远程操作:   MVC, Portlet, Web Service, WebSocket
测试框架
~~~

从整体来看，这5个主要模块几乎为企业应用提供了所需的一切，从持久层、业务层到展现层都拥有相应的支持。IoC和AOP是Spring所依赖的根本。在此基础上，Spring整合了各种企业应用开源框架和许多优秀的第三方类库，成为Java企业应用full-stack的开发框架。

1.IoC

Spring核心模块实现了IoC的功能，它将类与类之间的依赖从代码中脱离出来，用配置的方式进行依赖关系描述，由IoC容器负责依赖类之间的创建、拼接、管理、获取等工作。BeanFactory接口是Spring框架的核心接口，它实现了容器许多核心的功能。

Context模块构建于核心模块之上，扩展了BeanFactory的功能，添加了i18n国际化、Bean生命周期控制、框架事件体系、资源加载透明化等多项功能。此外，该模块还提供了许多企业级服务的支持，如邮件服务、任务调度、JNDI获取、EJB集成、远程访问等。ApplicationContext是Context模块的核心接口。

表达式语言模块是统一表达式语言（Unified EL)的一个扩展，该表达式语言用于查询和管理运行期的对象，支持设置/获取对象属性，调用对象方法，操作数组、集合等。此外，该模块还提供了逻辑表达式运算、变量定义等功能，可以方便地通过表达式串和Spring IoC容器进行交互。

2.AOP

AOP是继OOP之后，对编程设计思想影响极大的技术之一。AOP是进行横切逻辑编程的思想，它开拓了考虑问题的思路。在AOP模块里，Spring提供了满足AOP Alliance规范的实现，还整合了AspectJ这种AOP语言级的框架。在Spring里实现AOP编程有众多选择。Java5.0引入java.lang.instrument，允许在JVM启动时启用一个代理类，通过该代理类在运行期修改类的字节码，改变一个类的功能，从而实现AOP的功能。

3.数据访问和集成

任何应用程序的核心问题是对数据的访问和操作。数据有多种表现形式，如数据表、XML、消息等，而每种数据形式又拥有不同的数据访问技术（如数据表的访问即可以直接通过JDBC，也可以通过Hibernate或MyBatis）。

首先，Spring站在DAO的抽象层面，建立了一套面向DAO层的统一的异常体系，同时将各种访问数据的检查型异常转换为非检查型异常，为整合各种持久层框架提供基础。其次，Spring通过模板化技术对各种数据访问技术进行了薄层封装，将模式化的代码隐藏起来，使数据访问的程序得到大幅简化。这样，Spring就建立起了和数据形式及访问技术无关的统一的DAO层，借助AOP技术，Spring提供了声明式事务的功能。

4.Web及远程操作

该模块建立在Application Context模块之上，提供了Web应用的各种工具类，如通过Listener或Servlet初始化Spring容器，将Spring容器注册到Web容器中。该模块还提供了多项面向Web的功能，如透明化文件上传、Velocity、FreeMarker、XSLT的支持。此外，Spring可以整合Struts、WebWork等MVC框架。

5.Web及远程访问

Spring自己提供了一个完整的类似于Struts的MVC框架，称为Spring MVC。据说Spring之所以也提供了一个MVC框架，是因为Rod Johnson想证明实现MVC其实是一项简单的工作。当然，如果你不希望使用Spring MVC，那么Spring对Struts、WebWork等MVC框架的整合，一定也可以给你带来方便。相对于Servlet的MVC，Spring在简化Portlet的开发上也做了很多工作，开发者可以从中受益。

6.WebSocket

WebSocket提供了一个在Web应用中高效、双向的通信，需要考虑到客户端（浏览器）和服务器之间的高频和低时延信息交换。一般的应用场景有在线交易、游戏、协作、数据可视化等。

此外，Spring在远程访问及Web Service上提供了对很多著名框架的整合。由于Spring框架的扩展性，特别是随着Spring框架影响性的扩大，越来越多的框架主动支持Spring框架，使得Spring框架应用的涵盖面越来越宽广。

## 1.5 Spring对Java版本的要求

Spring 4.0基于Java 6.0，全面支持Java 8.0。运行Spring 4.0必须使用Java 6.0以上版本，推荐使用Java 8.0及以上版本，如果要编译Spring 4.0，则必须使用Java 8.0。此外，Spring保持和Java EE 6.0的兼容，同时也对Java EE 7.0提供一些早期的支持。

## 1.6 Spring 4.0 新特性

### 1.6.1 全面支持Java 8.0

1.Java 8.0的Lambda表达式

2.Java 8.0的时间与日期API

3.重复注解支持

4.空指针终结者：Optional<>

### 1.6.2 核心容器的增强

Spring 4.0对核心容器进行了增强，支持泛型依赖注入，对CgLib类代理不再要求必须有空参构造器（这个特性带来很大便利）；在基于Java的配置里添加了@Description；提供@Conditional注解来实现Bean的条件过滤；提供@Lazy注解解决Bean延时依赖注入；支持Bean被注入List或者Array时可以通过@Order注解或基于Ordered接口进行排序。如果使用Spring的注解支持，则可以使用自定义注解来组合多个注解，方便对外公开特定的属性。

- 泛型依赖注入：Spring 4.0可以为子类的成员变量注入泛型类型
~~~java
public abstract class BaseService<M extends Serializable> {
    @Autowired
    protected BaseDao<M> dao;
    ...
}
@Service
public class UserService extends BaseService<User> {
}
@Service
public class ViewSpaceService extends BaseService<ViewSpace>{
}
~~~

- Map依赖注入。
~~~java
@Autowired
private Map<String, BaseService> map;
~~~
上述写法将BaseService类型注入map中。其中，key是Bean的名字；value是所有实现了BaseService的Bean。

- @Lazy延迟依赖注入。
~~~java
@Lazy
@Service
public class UserService extends BaseService<User>{
}
~~~
也可以把@Lazy放在@Autowired之上，即依赖注入也是延时的，当调用userService时才会注入。同样适用于@Bean。

- List注入。
~~~java
@Autowired
private List<BaseService> list;
~~~
这样就会注入所有实现了BaseService的Bean,但顺序是不确定的。在Spring 4.0中可以使用@Order或Ordered接口来实现排序，例如：
~~~java
@Order(value=1)
@Service
public class UserService extends BaseService<User>{
}
~~~

- @Conditional注解：@Conditional类似于@Profile，一般用于在多个环境（开发环境、测试环境、正式机环境）中进行配置切换，即通过某个配置来开启某个环境。@Conditional注解的优点是允许自己定义规则。可以指定在如@Component、@Bean、@Configuration等注解的类上，以决定是否创建Bean等。

- CGLIB代理类增强：在Spring4.0中，基于CGLIB的代理类不再要求类必须有空参构造器，这是一个很好的特性。使用构造器注入有很多好处，比如，可以确保只在创建Bean时注入依赖，以保证Bean不可更改；又如，如果对UserService类进行事务增强，此时要求UserService类必须有空参构造器，就会造成很多不便。

### 1.6.3 支持用Groovy定义Bean

### 1.6.4 Web的增强

从Spring 4.0开始，Spring MVC基于Servlet3.0开发，如需使用Spring MVC测试框架，则要依赖Servlet 3.0相关.jar包（因为Mock的对象都是基于Servlet 3.0的）。另外，为了方便REST开发，引入新的@RestController控制器注解，这样就不需要在每个@RequestMapping方法上加@ResponceBody了。同时添加了一个AsyncRestTemplate，支持REST客户端的异步无阻塞请求。

### 1.6.5 支持WebSocket

### 1.6.6 测试的增强

### 1.6.7 其他

## 1.7 Spring子项目

## 1.8 如何获取Spring

## 1.9 小结

# 第2章 快速入门

## 2.1 实例概述

### 2.1.1 比Hello World更适用的实例

为了让Spring的功能轮廓更加清晰，笔者试图通过一个功能涵盖面更广的论坛登录模块替换经典的Hello World实例。

# 第3章 Spring Boot

## 3.1 Spring Boot概览

Spring Boot是由Pivotal团队设计的全新框架，其目的是用来简化Spring应用开发过程。该框架使用了特定的方式来进行配置，从而使得开发人员不再需要定义一系列样板化的配置文件，而专注于核心业务开发，项目涉及的一些基础设施则交由Spring Boot来解决。

### 3.1.1 Spring Boot发展背景

多年来，Spring配置复杂性一直为人所诟病，Spring IO子项目试图化解这一问题，但由于其主要侧重于解决集成方面的问题，因此Spring配置复杂性并没有得到本质的改观，如何实现简化Spring配置的呼声依旧高亢，直到Spring Boot的出现。Spring Boot可让开发人员不再需要编写复杂的XML配置文件，仅仅通过几行代码就能实现一个可运行的Web应用。

Spring Boot不是去再造一个“轮子”，它的“革命宣言”是为Spring项目开发带来一种全新的体验，从而大大降低Spring框架的使用门槛。

Spring Boot革新Spring项目开发体验之道，其实是借助强大的Groovy动态语言实现的，如借助Groovy强大的MetaObject协议、可插拔的AST转换器及内置的依赖解决方案引擎等。在其核心的编译模型中，Spring Boot使用Groovy来构建工程文件，所以它可以轻松地利用导入模板及方法模板对类所生成地字节码进行改造，从而让开发者仅用很简单的代码就可以完成很复杂的操作。

### 3.1.2 Spring Boot特点

Spring Boot包含如下特性：

- 为开发者提供Spring快速入门体验
- 内嵌Tomcat和Jetty容器，不需要部署WAR文件到Web容器就可独立运行应用。
- 提供许多基于Maven的pom配置模板来简化工程配置。
- 提供实现自动化配置的基础设施。
- 提供可以直接在生产环境中使用的功能，如性能指标、应用信息和应用健康检查。
- 开箱即用，没有代码生成，也无须XML配置文件，支持修改默认值来满足特定需求。

通过Spring Boot，创建一个新的Spring应用变得非常简单，只需几步即可完成。

### 3.1.3 Spring Boot启动器

| 启动器名称                             | 启动器说明                                                   |
| -------------------------------------- | ------------------------------------------------------------ |
| spring-boot-starter                    | 核心模块，包含自动配置支持、日志库和对YAML配置文件的支持     |
| spring-boot-starter-amqp               | 支持AMQP，包含spring-rabbit                                  |
| spring-boot-starter-aop                | 支持面向切面编程（AOP），包含spring-aop和AspectJ             |
| spring-boot-starter-artemis            | 通过Apache Artemis支持JMS的API（Java Message Service API）   |
| spring-boot-starter-batch              | 支持Spring Batch，包含HSQLDB                                 |
| spring-boot-starter-cache              | 支持Spring的Cache抽象                                        |
| spring-boot-starter-cloud-connectors   | 支持Spring Cloud Connectors, 简化了在像Cloud Foundry或Heroku这样的云平台上连接服务 |
| spring-boot-starter-data-gemfire       | 支持GemFire分布式数据存储，包含spring-data-gemfire           |
| spring-boot-starter-data-jpa           | 支持JPA，包含spring-data-jpa、spring-orm和Hibernate          |
| spring-boot-starter-data-elasticsearch | 支持ElasticSearch搜索和分析引擎，包含spring-data-elasticsearch |
| spring-boot-starter-data-solr          | 支持Apache Solr搜索平台，包含spring-data-solr                |
| spring-boot-starter-data-mongodb       | 支持MongoDB，包含spring-data-mongodb                         |
| spring-boot-starter-data-rest          | 支持以REST方式暴露Spring Data仓库，包含spring-data-rest-webmvc |
| spring-boot-starter-redis              | 支持Redis键值存储数据库，包含spring-redis                    |
| spring-boot-starter-jdbc               | 支持使用JDBC访问数据库                                       |
| spring-boot-starter-jta-atomikos       | 通过Atomikos支持JTA分布式事务处理                            |
| spring-boot-starter-jta-bitronix       | 通过Bitronix支持JTA分布式事务处理                            |
| spring-boot-starter-security           | 包含spring-security                                          |
| spring-boot-starter-test               | 包含常用的测试所需的依赖，如TestNG、Hamcrest、Mockito和spring-test等 |
| spring-boot-starter-velocity           | 支持使用Velocity作为模板引擎                                 |
| spring-boot-starter-freemarker         | 支持FreeMarker模板引擎                                       |
| spring-boot-starter-thymeleaf          | 支持Thymeleaf模板引擎，包括与Spring的集成                    |
| spring-boot-starter-mustache           | 支持Mustache模板引擎                                         |
| spring-boot-starter-web                | 支持Web应用开发，包含tomcat、spring-mvc、spring-webmvc和jackson |
| spring-boot-starter-websocket          | 支持使用Tomcat开发WebSocket应用                              |
| spring-boot-starter-ws                 | 支持Spring Web Service                                       |
| spring-boot-starter-groovy-templates   | 支持Groovy模板引擎                                           |
| spring-boot-starter-hateoas            | 通过spring-hateoas支持基于Hateoas的RESTful Web服务           |
| spring-boot-starter-hornetq            | 通过HornetQ支持JMS                                           |
| spring-boot-starter-log4j              | 添加Log4j的支持                                              |
| spring-boot-starter-logging            | 使用Spring Boot默认的日志框架Logback                         |
| spring-boot-starter-integration        | 支持通用的spring-integaration模块                            |
| spring-boot-starter-jersey             | 支持Jersey RESTful Web服务框架                               |
| spring-boot-starter-mail               | 支持javax.mail模块                                           |
| spring-boot-starter-mobile             | 支持spring-mobile                                            |
| spring-boot-starter-social-facebook    | 支持spring-social-facebook                                   |
| spring-boot-starter-social-linkedin    | 支持spring-social-linkedin                                   |
| spring-boot-starter-social-twitter     | 支持spring-social-twitter                                    |
| spring-boot-starter-actuator           | 添加适用于生产环境的功能，如性能指标和监测等功能             |
| spring-boot-starter-remote-shell       | 支持远程SSH命令操作                                          |
| spring-boot-starter-tomcat             | 使用Spring Boot默认的Tomcat作为应用服务器                    |
| spring-boot-starter-jetty              | 引入了Jetty HTTP引擎（用于替换Tomcat）                       |
| spring-boot-starter-undertow           | 引入了Undertow HTTP引擎（用于替换Tomcat）                    |

>计算机引导启动的英文单词是boot，可是，boot原意是靴子，“启动”与“靴子”有何关系？原来，这里的boot是bootstrap（鞋带）的缩写，它来自西方一句“拉鞋带”的谚语“pull oneself up by one's bootstraps”，译为“拽着鞋带把自己拉起来”，这就相当于项羽坐在椅子上要把自己举起来的典故一样，当然是不可能的。计算机启动本身就是一个很矛盾的过程：必须先运行程序，然后计算机才能启动，但是计算机不启动就无法运行程序——就像鸡生蛋、蛋生鸡一样！所以，工程师把这个启动过程叫做“拉鞋带”，久而久之就简称为boot了。

## 3.2 快速入门

首先需要在pom.xml文件中引入Spring Boot依赖

~~~xml
<dependecies>
	<dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <version>1.3.3.RELEASE</version>
    </dependency>
</dependecies>
~~~

当使用Maven"mvn dependency:tree"命令或IDEA依赖查看视图功能（在pom.xml文件视图中单击鼠标右键选择Diagrams->Show Dependencies）时，会发现spring-boot-starter-web内部已经封装了spring-web、spring-webmvc、jackson-databind等模块依赖。

配置好Spring Boot相关依赖之后，接下来就可以通过几行代码，快速创建一个Web应用

~~~java
@RestController
@EnableAutoConfiguration
public class BbsDaemon{
    @RequestMapping("/")
    public String index(){
        return "欢迎光临小春论坛！";
    }
    
    public static void main(String[] args) throws Exception {
        SpringApplication.run(BbsDaemon.class, args);
    }
}
~~~

其中，@EnableAutoConfiguration注解是由Boot提供的，用于对Spring框架进行自动配置，减少了开发人员的工作量；@RestController和@RequestMapping注解是由SpringMVC提供的，用于创建Rest服务。

直接运行BbsDaemon类会启动一个运行于8080端口的内嵌Tomcat服务，在浏览器中访问"http://localhost:8080"，即可看到页面上显示“欢迎光临小春论坛！”。也就是说，只需简单的两个步骤就完成了一个可独立启动运行的Web应用。既没有配置安装Tomcat或Jetty这样的应用服务器，也没有打包成WAR文件——与传统开发方式相比，Spring Boot堪称犀利！

## 3.3 安装配置

## 3.4 持久层

Spring框架提供了几种可选的操作数据库方式，可以直接使用Spring内置轻量级JdbcTemplate，也可以使用第三方持久化框架Hibernate或MyBatis。Spring Boot为这两种操作数据库方式分别提供了相应的启动器spring-boot-starter-jdbc和spring-boot-starter-jpa。应用Spring Boot启动器使数据库持久化操作变得更加简单，因为Spring Boot会自动配置访问数据库相关设施。只需在工程模块pom.xml文件中添加spring-boot-starter-data-jdbc或spring-boot-starter-data-jpa依赖即可。

## 3.5 业务层

在编写业务层代码时有两个重要的步骤：一是编写正确的业务逻辑；二是对业务事务的管控。在Spring Boot中，使用事务非常简单，首先在主类Application上标注@EnableTransactionManagerment注解（开启事务支持，相当于XML中的`<tx:annotation-driven/>`配置方式），然后在访问Service方法上标注@Transactional注解即可。如果将@Transactional注解标注在Service类级别上，那么当前Service类的所有方法都将被事务增强，建议不要在类级别上标注@Transactional注解

~~~java
@SpringBootApplication
@EnableTransactionManagement //启动注解事务管理
public class Application {
    public static void main(String[] args) throws Exception {
        SpringApplication.run(Application.class, args);
    }
}
~~~

通过@EnableTransactionManagement注解，Boot为应用自己装配了事务支持。这对用户并不透明，用户如果想自己定义事务管理器，则在Application类中添加一个即可。

~~~java
@SpringBootApplication
@EnableTransactionManagement // 启用注解事务管理
public class Application{
    @Bean
    public PlatformTransactionManager txManager(DataSource dataSource){
        return new DataSourceTransactionManager(dataSource);
    }
    ...
}
~~~

在Application中添加自定义事务管理器方法txManager(),并在方法上标注@Bean注解，此时SpringBoot会加载自定义的事务管理器，不会重新实例化其他事务管理器。

## 3.6 展示层

> 基于Spring Boot应用，由于当前应用包含了一个可直接运行的Application类，所以在开发过程中，大家很容易在IDE（如IDEA工具）中单击鼠标右键运行当前类。虽然可以启动当前应用，在非Web应用中可能不会有什么问题，但在Web应用中，如果采用上述方法直接运行应用，那么在访问有视图的页面时（如JSP），会一直报404错误。
>
> 因为直接运行当前启动类，Spring Boot无法找到当前页面资源。因此，基于Spring Boot的应用在开发调试的时候，一定要基于Spring Boot提供的spring-boot-maven-plugin插件命令来运行应用或通过Spring Boot命令行来运行应用。

## 3.7 运维支持

Spring Boot对运维监控相关的类库进行了整合，形成了一个功能完备和可定制的启动器，称为Actuator。

基于Spring Boot应用，添加监控功能非常简单，只需在应用的pom.xml文件中添加spring-boot-starter-actuator依赖即可。

Spring Boot默认提供了对应用本身、关系数据库连接、MongoDB、Redis、Solr、ElasticSearch、JMS和RabbitMQ等服务的健康状态的检测功能。这些服务都可以在application.properties的management.health.*选项中进行配置

~~~properties
#数据库监控配置
management.health.db.enabled=true
management.health.defaults.enabled=true
#应用磁盘空间检查配置
management.health.diskspace.enabled=true
management.health.diskspace.path=D:/masterSpring/code
management.health.diskspace.threshold=0
#ElaticSearch服务健康检查配置
management.health.elasticsearch.enabled=true
management.health.elasticsearch.indices=index1,index2
management.health.elasticsearch.response-timeout=100
#Solr服务健康检查配置
management.health.solr.enabled=true
#JMS服务健康检查配置
management.health.jms.enabled=true
#Mail服务健康检查配置
management.health.mail.enabled=true
#MongoDB服务健康检查配置
management.health.mongo.enabled=true
#Rabbit MQ服务健康检查配置
management.health.rabbit.enabled=true
#Redis服务健康检查配置
management.health.redis.enabled=true
management.health.status.order=DOWN, OUT_OF_SERVICE, UNKNOWN, UP
~~~

配置好Actuator相关依赖及服务健康检查属性配置，重新启动应用，就可以在控制台上看到很多服务映射，如"/health"、"/env"、"/info"等。

在浏览器地址栏中输入其中的一个服务地址”http://localhost:8080/health“，就可以在浏览器中看到服务信息。

| 服务名称     | 服务说明                                                |
| ------------ | ------------------------------------------------------- |
| /health      | 显示应用的健康状态信息                                  |
| /configprops | 显示应用中的配置参数的实际值                            |
| /beans       | 显示应用中包含的Spring Bean的信息                       |
| /env         | 显示从ConfigurableEnvironment得到的环境配置信息         |
| /metrics     | 显示应用的性能指标                                      |
| /trace       | 显示应用相关的跟踪（trace）信息                         |
| /dump        | 生成一个线程dump                                        |
| /autoconfig  | 显示Spring Boot自动配置的信息                           |
| /mappings    | 显示Spring MVC应用中通过“@RequestMapping”添加的路径映射 |
| /info        | 显示应用的基本信息                                      |
| /shutdown    | 关闭应用                                                |

## 3.8 小结

# 第二篇 核心篇

# 第4章 IoC容器

## 4.1 IoC概述

IoC(Inverse of Control, 控制反转)是Spring容器的内核，AOP、声明式事务等功能在此基础上开花结果。IoC确实包括很多内涵，它涉及代码解耦、设计模式、代码优化等问题的考量，我们试图通过一个小例子来说明这个概念。

### 4.1.1 通过实例理解IoC的概念

贺岁大片《墨攻》中有一个场景，当刘德华所饰演的墨者革离到达梁国都城下时，城上梁国守军问道：“来者何人？”刘德华回答：“墨者革离！”我们不妨通过Java语言为这个“城门叩问”的场景编写剧本，并借此理解IoC的概念

~~~java
public class MoAttack{
    public void cityGateAsk(){
        //①演员直接侵入剧本
        LiuDeHua ldh = new LiuDeHua();
        ldh.responseAsk("墨者革离！");
    }
}
~~~

我们会发现，以上剧本在①处，作为具体角色饰演者的刘德华直接侵入剧本，使剧本和演员直接耦合在一起

~~~mermaid
classDiagram
  class MoAttack{
  	+cityGateAsk(): void
  }
  class LiuDeHua{
  	+responseAsk(): void
  }
  MoAttack..>LiuDeHua
~~~

一个明智的编剧在剧情创作时应围绕故事的角色进行，而不应考虑角色的具体饰演者，这样才可能在剧本投拍时自由地遴选任何适合的演员，而非绑定在某一人身上。通过以上分析，我们知道需要为该剧本的主人公革离定义一个接口

~~~java
public class MoAttack{
    public void cityGateAsk(){
        //①引入革离角色接口
        GeLi geli = new LiuDeHua();
        //②通过接口展开剧情
        geli.responseAsk("墨者革离！");
    }
}
~~~

在①处引入了剧本的角色——革离，剧本的情节通过角色展开，在拍摄时角色由演员饰演，如②处所示。因此，墨攻、革离、刘德华三者的类图关系如下：

~~~mermaid
classDiagram
  class MoAttack{
  	+cityGateAsk(): void
  }
  class LiuDeHua{
  	+responseAsk(): void
  }
  class GeLi{
  	<<interface>>
  	+responseAsk(): void
  }
  MoAttack ..> LiuDeHua : <<create>>
  MoAttack ..> GeLi
  LiuDeHua ..|> GeLi
~~~

MoAttack同时依赖于GeLi接口和LiuDeHua类，并没有达到我们所期望的剧本仅依赖于角色的目的。但是角色最终必须通过具体的演员才能完成拍摄，如何让LiuDeHua和剧本无关而又能完成GeLi的具体动作呢？当然是在影片投拍时，导演将LiuDeHua安排在GeLi的角色上，导演负责剧本、角色、饰演者三者的协调控制。

~~~mermaid
classDiagram
  class MoAttack{
  	+cityGateAsk(): void
  }
  class LiuDeHua{
  	+responseAsk(): void
  }
  class GeLi{
  	<<interface>>
  	+responseAsk(): void
  }
  class Director{
  	+directMovie(): void
  }
  Director ..> MoAttack
  
  Director ..> GeLi
  MoAttack ..> LiuDeHua
  Director ..> LiuDeHua : <<create>>
  MoAttack ..> GeLi
  LiuDeHua ..|> GeLi
~~~

通过引入导演，使得剧本和具体饰演者解耦。对应到软件中，导演就像一台装配器，安排演员表演具体的角色。



现在我们可以反过来讲解IoC的概念了。IoC（Inverse of Control）的字面意思是控制反转，它包括两方面的内容：

- 其一是控制
- 其二是反转

那到底是什么东西的“控制”被“反转”了呢？对应到前面的例子，“控制”是指选择GeLi角色扮演者的控制权；“反转”是指这种控制权从《墨攻》剧本中移除，转交到导演手中。对于软件来说，即某一接口具体实现类的选择控制权从调用类中移除，转交给第三方决定，即由Spring容器借由Bean配置来进行控制。

因为IoC确实不够开门见山，因此业界曾进行了广泛的讨论，最终软件界的泰斗级人物Martin Fowler提出了DI(Dependecy Injection, 依赖注入)的概念用来代替IoC，即让调用类对某一接口实现类的依赖关系由第三方（容器或协作类）注入，以移除调用类对某一接口实现类的依赖。“依赖注入”这个名词显然比“控制反转”直接明了、易于理解。

### 4.1.2 IoC的类型

从注入方法上看，IoC主要可以划分为3种类型：构造函数注入、属性注入和接口注入。Spring支持构造函数注入和属性注入。下面我们继续使用以上的例子说明这3种注入方式的区别。

#### 1.构造函数注入

在构造函数注入中，通过调用类的构造函数，将接口实现类通过构造函数变量传入

~~~java
public class MoAttack{
    private GeLi geli;
    
    //①注入革离的具体饰演者
    public MoAttack(GeLi geli){
        this.geli = geli;
    }
    public void cityGateAsk(){
        geli.responseAsk("墨者革离！");
    }
}
~~~

MoAttack的构造函数不关心具体由谁来饰演革离这个角色，只要在①处传入的饰演者按剧本要求完成相应的表演即可，角色的具体饰演者由导演来安排

~~~java
public class Director{
    public void direct(){
        //①指定角色的饰演者
        GeLi geli = new LiuDeHua();
        
        //②注入具体饰演者到剧本中
        MoAttack moAttack = new MoAttack(geli);
        moAttack.cityGateAsk();
    }
}
~~~

在①处导演安排刘德华饰演革离，并在②处将刘德华“注入”到《墨攻》剧本中，然后开始“城门叩问”剧情的演出工作。

#### 2.属性注入

有时，导演会发现，虽然革离是影片《墨攻》的第一主角，但并非每个场景都需要革离的出现，在这种情况下通过构造函数注入并不妥当，这时可以考虑使用属性注入。属性注入可以有选择地通过Setter方法完成调用类所需依赖的注入，更加灵活方便。

~~~java
public class MoAttack{
    private GeLi geli;
    
    //①属性注入方法
    public void setGeli(GeLi geli){
        this.geli = geli;
    }
    public void cityGateAsk(){
        geli.responseAsk("墨者革离！");
    }
}
~~~

MoAttack在①处为geli属性提供了一个Setter方法，以便让导演在需要时注入geli的具体饰演者

~~~java
public class Director{
    public void direct(){
        MoAttack moAttack = new MoAttack();
        //①调用属性Setter方法注入
        GeLi geli = new LiuDeHua();
        moAttack.setGeli(geli);
        moAttack.cityGateAsk();
    }
}
~~~

和通过构造函数注入革离饰演者不同，在实例化MoAttack剧本时，并未指定任何饰演者，而是在实例化MoAttack后，在需要革离出场时，才调用其setGeli()方法注入饰演者。按照类似的方式，还可以分别为剧本中的其他诸如梁王、巷淹中等角色提供输入的Setter方法，这样，导演就可以根据所拍剧段的不同，按需注入相应的角色。

#### 3.接口注入

将调用类所有依赖注入的方法抽取到一个接口中，调用类通过实现该接口提供相应的注入方法。为了采取接口注入的方式，必须先声明一个ActorArrangable接口，如下：

~~~java
public interface ActorArrangable{
    void injectGeli(Geli geli);
}
~~~

然后，MoAttack通过ActorArrangable接口提供具体的实现

~~~java
public class MoAttack implements ActorArrangable{
    private GeLi geli;
    
    //①实现接口方法
    public void injectGeli(GeLi geli){
        this.geli = geli;
    }
    public void cityGateAsk(){
        geli.responseAsk("墨者革离！");
    }
}
~~~

Director通过ActorArrangable的injectGeli()方法完成饰演者的注入工作

~~~java
public class Director{
    public void direct(){
        MoAttack moAttack = new MoAttack();
        GeLi geli = new LiuDeHua();
        moAttack.injectGeli(geli);
        moAttack.cityGateAsk();
    }
}
~~~

由于通过接口注入需要额外声明一个接口，增加了类的数目，而且它的效果和属性注入并无本质区别，因此我们不提倡采用这种注入方式。

### 4.1.3 通过容器完成依赖关系的注入

虽然MoAttack和LiuDeHua实现了解耦，MoAttack无须关注角色实现类的实例化工作，但这些工作在代码种依然存在，只是转移到Director类种而已。假设某一制片人想改变这一局面，在选择某个剧本之后，希望通过媒体“海选”或者第三方代理机构来选择导演、演员，让他们各司其职，那么剧本、导演、演员就都实现了解耦。

所谓媒体“海选”和第三方代理机构，在程序领域就是一个第三方的容器，它帮助完成类的初始化与装配工作，让开发者从这些底层实现类的实例化、依赖关系装配等工作种解脱出来，专注于更有意义的业务逻辑开发工作。这无疑是一件令人向往的事情。Spring就是这样一个容器，它通过配置文件或注解描述类与类之间的依赖关系，自动完成类的初始化和依赖注入工作。下面是Spring配置文件对以上实例进行配置的配置文件片段：

~~~xml
<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w4.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">
	<!--①实现类实例化-->
    <bean id="geli" class="LiuDeHua"/>
    <bean id="moAttack" class="com.smart.ioc.MoAttack" p:geli-ref="geli"/><!--②通过geli-ref建立依赖关系-->
</beans>
~~~

通过new XmlBeanFactory("bean.xml")等方式即可启动容器。在容器启动时，Spring根据配置文件的描述信息，自动实例化Bean并完成依赖关系的装配，从容器中即可返回准备就绪的Bean实例，后续可直接使用之。

Spring为什么会有这种“神奇”的力量，仅凭一个简单的配置文件，就能魔法般地实例化并装配好程序所用地Bean呢？这种“神奇”地力量归功于Java语言本身的类反射功能。下面我们独辟章节专门讲解Java语言的反射知识，为大家深刻理解Spring的技术内幕做好准备。

## 4.2 相关Java基础知识

Java语言允许通过程序化的方式间接对Class进行操作。Class文件由类装载器装载后，在JVM中将形成一份描述Class结构的元信息对象，通过该元信息对象可以获知Class的结构信息，如构造函数、属性和方法等。Java允许用户借由这个与Class相关的元信息对象间接调用Class对象的功能，这就为使用程序化方式操作Class对象开辟了途径。

### 4.2.1 简单实例

我们将从一个简单的例子开始探访Java反射机制的征程。下面的Car类拥有两个构造函数、一个方法及3个属性，如下：

~~~java
package com.smart.reflect;
public class Car{
    private String brand;
    private String color;
    private int maxSpeed;
    // ①默认构造函数
    public Car(){}
    // ②带参构造函数
    public Car(String brand, String color, int maxSpeed){
        this.brand = brand;
        this.color = color;
        this.maxSpeed = maxSpeed;
    }
    // ③未带参的方法
    public void introduce() {
        System.out.println("brand:" + brand + ";color:" + color + ";maxSpeed" + maxSpeed);
    }
    // 省略参数的getter/setter方法
    ...
}
~~~

一般情况下，我们会使用如下代码创建Car的实例：

~~~java
Car car = new Car();
car.setBrand("红旗CA72");
~~~

或者：

~~~java
Car car = new Car("红旗CA72", "黑色");
~~~

以上两种方法都采用传统方式直接调用目标类的方法。下面我们通过Java反射机制以一种间接的方式操控目标类，如下<span id="code4_10">代码清单4-10</span>：

~~~java
package com.smart.reflect;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
public class ReflectTest {
    public static Car initByDefaultConst() throws Throwable {
        // ①通过类装载器获取Car类对象
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        Class clazz = loader.loadClass("com.smart.reflect.Car");
        
        // ②获取类的默认构造器对象并通过它实例化Car
        Constructor cons = clazz.getDeclaredConstructor((Class[])null);
        Car car = (Car)cons.newInstance();
        
        // ③通过反射方法设置属性
        Method setBrand = clazz.getMethod("setBrand", String.class);
        serBrand.invoke(car, "红旗CA72");
        Method setColor = clazz.getMethod("setColor", String.class);
        setColor.invoke(car, "黑色");
        Method setMaxSpeed = clazz.getMethod("setMaxSpeed", int.class);
        setColor.invoke(car, 200);
        return car;
    }
    
    public static void main(String[] args) throws Throwable{
        Car car = initByDefaultConst();
        car.introduce();
    }
}
~~~

运行以上程序，在控制台上将打印出以下信息：

~~~
brand:红旗CA72;color:黑色;maxSpeed:200
~~~

这说明我们完全可以通过编程方式调用Class的各项功能，与通过构造函数和方法直接调用类功能的效果是一致的，只不过前者是间接调用，后者是直接调用罢了。

在ReflectTest中使用了几个重要的反射类，分别是ClassLoader、Class、Constructor和Method，通过这些反射类就可以间接调用目标Class的各项功能。

- 在①处，我们获取当前线程的ClassLoader，然后通过指定的全限定类名"com.smart.beans.Car"装载Car类对应的反射实例。
- 在②处，我们通过Car的反射类对象获取Car的构造函数对象cons，通过构造函数对象的newInstance()方法实例化Car对象，其效果等同于`new Car()`。
- 在③处，我们又通过Car的反射类对象的`getMethod(String method name, Class paramClass)`获取属性的Setter方法对象，其中第一个参数是目标Class的方法名；第二个参数是方法入参的对象类型。在获取方法反射对象后，即可通过`invoke(Object object, Object param)`方法调用目标类的方法，该方法的第一个参数是操作的目标类对象实例，第二个参数是目标方法的入参。

在代码清单4-10中，"com.smart.reflect.Car"、“setBrand”、“红旗CA72”之类的信息即通过反射方法操控目标类的元信息，如果我们将这些信息以一个配置文件的方法提供，就可以使用Java语言的反射功能编写一段通用的代码，对类似于Car的类进行实例化及功能调用操作。

### 4.2.2 类装载器ClassLoader

#### 1.类装载器的工作机制

类装载器就是寻找类的字节码文件并构造出类在JVM内部表示对象的组件。在Java中，类装载器把一个类装入JVM中，需要经过以下步骤：

1. 装载：查找和导入Class文件。
2. 链接：执行校验、准备和解析步骤，其中解析步骤是可以选择的。
   1. 校验：检查载入Class文件数据的正确性。
   2. 准备：给类的静态变量分配存储空间。
   3. 解析：将符号引用转换成直接引用。
3. 初始化：对类的静态变量、静态代码块执行初始化工作。

类装载工作由ClassLoader及其子类负责。ClassLoader是一个重要的Java运行时系统组件，它负责在运行时查找和装入Class字节码文件。JVM在运行时会产生3个ClassLoader：根装载器、ExtClassLoader（扩展类装载器）和AppClassLoader（应用类装载器）。其中，根装载器不是ClassLoader的子类，它使用C++语言编写，因而在Java中看不到它，根装载器负责装载JRE的核心类库，如JRE目标下的rt.jar、charsets.jar等。ExtClassLoader和AppClassLoader都是ClassLoader的子类，其中ExtClassLoader负责装载JRE扩展目录ext中的JAR类包；AppClassLoader负责装载Classpath路径下的类包。

这3个类装载器之间存在父子层级关系，即根装载器是ExtClassLoader的父装载器，ExtClassLoader是AppClassLoader的父装载器。在默认情况下，使用AppClassLoader装载应用程序的类。我们可以做一个实验，如下面代码清单4-11所示。

~~~java
public class ClassLoaderTest {
    public static void main(String[] args){
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        System.out.println("current loader:" + loader);
        System.out.println("parent loader:" + loader.getParent());
        System.out.println("grandparent loader:" + loader.getParent().getParent());
    }
}
~~~

运行以上代码，在控制台上将打印出以下信息：

~~~java
current loader: sum.misc.Launcher$AppClassLoader@131f71a
parent loader: sum.misc.Launcher$ExtClassLoader@15601ea
// ①根装载器在Java中访问不到，所以返回null
grandparent loader: null
~~~

通过以上输出信息，我们知道当前的ClassLoader是AppClassLoader，其父ClassLoader是ExtClassLoader，祖父ClassLoader是根装载器，因为在Java中无法获得它的句柄，所以仅返回null。

JVM装载类时使用“全盘负责委托机制”，“全盘负责”是指当一个ClassLoader装载一个类时，除非显式地使用另一个ClassLoader，该类所依赖及引用的类也由这个ClassLoader载入：“委托机制”是指先委托父装载器寻找目标类，只有在找不到的情况下才从自己的类路径中查找并装载目标类。这一点是从安全角度考虑的，试想，如果有人编写了一个恶意的基础类（如java.lang.String）并装载到JVM中，将会引起多么可怕的后果？但是由于有了“全盘负责委托机制”，java.lang.String永远是由根装载器来装载的，这样就避免了上述安全隐患的发生。

> Java的开发者想必都遇到过java.lang.NoSuchMethodError的错误信息吧。究其根源，这个错误基本上都是由JVM的“全盘负责委托机制”引发的问题。因为在类路径下放置了多个不同版本的类包，如commons-lang2.x.jar和commons-lang4.x.jar都位于类路径中，代码用到了commons-lang4.x类的某个方法，而这个方法在commons-lang2.x中并不存在，JVM加载器碰巧又从commons-lang2.x.jar中加载类，运行时就会抛出NoSuchMethodError错误。

#### 2.ClassLoader的重要方法

在Java中，ClassLoader是一个抽象类，位于java.lang包中。下面对该类的一些重要接口方法进行介绍。

- `Class loadClass(String name)`：
  name参数指定类装载器需要装载类的名字，必须使用全限定类名，如com.smart.beans.Car。该方法有一个重载方法loadClass(String name, boolean resolve)，resolve函数告诉类装载器是否需要解析该类。在初始化类之前，应考虑进行类解析的工作，但并不是所有的类都需要解析。如果JVM只需要知道该类是否存在或找出该类的超类，那么就不需要进行解析。
- `Class defineClass(String name, byte[] b, int off, int len)`：
  将类文件的字节数组转换成JVM内部的java.lang.Class对象。字节数组可以从本地文件系统、远程网络获取。参数name为字节数组对应的全限定类名。
- `Class findSystemClass(String name)`：
  从本地文件系统载入Class文件。如果本地文件系统不存在该Class文件，则将抛出ClassNotFoundException异常。该方法是JVM默认使用的装载机制。
- `Class findLoadedClass(String name)`：
  调用该方法来查看ClassLoader是否已装入某个类。如果已装入，那么返回java.lang.Class对象；否则返回null。如果强行装载已存在的类，那么将会抛出链接错误。
- `ClassLoader getParentO()`：
  获取类装载器的父装载器。除根装载器外，所有的类装载器都有且仅有一个父装载器。ExtClassLoader的父装载器是根装载器，因为根装载器非Java语言编写，所以无法获得，将返回null。

除JVM默认的3个ClassLoader外，用户可以编写自己的第三方类装载器，以实现一些特殊的需求。类文件被装载并解析后，在JVM内将拥有一个对应的java.lang.Class类描述对象，该类的实例都拥有指向这个类描述对象的引用，而类描述对象又拥有指向关联ClassLoader的引用。

每个类在JVM中都拥有一个对应的java.lang.Class对象，它提供了类结构信息的描述。数组、枚举、注解及基本Java类型（如int、double等），甚至void都拥有对应的Class对象。Class没有public的构造方法。Class对象是在装载类时由JVM通过调用类装载器中的defineClass()方法自动构造的。

### 4.2.3 Java反射机制

Class反射对象描述类语义结构，可以从Class对象中获取构造函数、成员变量、方法类等类元素的反射对象，并以编程的方式通过这些反射对象对目标类对象进行操作。这些反射对象类在java.reflect包中定义。下面介绍3个主要的反射类。

- Constructor：类的构造函数反射类，通过`Class#getConstructors()`方法可以获取类的所有构造函数反射对象数组。在Java 5.0中，还可以通过`getConstructor(Class... parameterTypes)`获取拥有特定入参的构造函数反射对象。Constructor的一个主要方法是`newInstance(Object[] initargs)`，通过该方法可以创建一个对象类的实例，相当于new关键字。在Java 5.0中，该方法演化为更为灵活的形式：`newInstance(Object... initargs)`。
- Method：类方法的反射类，通过`Class#getDeclaredMethods()`方法可以获取类的所有方法反射类对象数组Method[]。在Java 5.0中，可以通过`getDeclaredMethod(String name, Class... parameterTypes)`获取特定签名的方法，其中name为方法名；Class...为方法入参类型列表。Method最主要的方法是invoke(Object obj, Object[] args)，其中obj表示操作的目标对象；args为方法入参，[代码清单4-10](#code4_10) 中的③处演示了这个反射类的使用方法。在Java 5.0中，该方法的形式调整为invoke(Object obj, Object... args)。此外，Method还有很多用于获取类方法更多信息的方法。
  - `Class getReturnType()`：获取方法的返回值类型。
  - `Class[] getParameterTypes()`：获取方法的入参类型数组。
  - `Class[] getExceptionTypes()`：获取方法的异常类型数组。
  - `Annotation[][] getParameterAnnotations()`：获取方法的注解信息，是Java 5.0中的新方法。
- Field：类的成员变量的反射类，通过`Class#getDeclaredFields()`方法可以获取类的成员变量反射对象数组，通过`Class#getDeclaredFields(String name)`则可以获取某个特定名称的成员变量反射对象。Field类最主要的方法是`set(Object obj, Object value)`，其中obj表示操作的目标对象，通过value为目标对象的成员变量设置值。如果成员变量为基础类型，则用户可以使用Field类中提供的带类型名的值设置方法，如setBoolean(Object obj, boolean value)、setInt(Object obj, int value)等。

此外，Java还为包提供了Package反射类，在Java 5.0中还为注解提供了AnnotatedElement反射类。总之，Java的反射体系保证了可以通过程序化的方式访问目标类中所有的元素，对于private或protected成员变量和方法，只要JVM的安全机制允许，也可以通过反射进行调用，请看下面的例子代码清单4-12：

~~~java
package com.smart.reflect;
public class PrivateCar {
    // ①private成员变量：使用传统的类实例调用方式，只能在本类中访问
    private String color;
    
    // ②protected方法：使用传统的类实例调用方式，只能在子类和本包中访问
    protected void drive(){
        System.out.println("drive private car! the color is:" + color);
    }
}
~~~

color变量和drive()方法都是私有的，通过类实例变量无法在外部访问私有变量、调用私有方法，但通过反射机制则可以绕过这个限制，如下代码清单4-13：

~~~java
...
public class PrivateCarReflect {
    public static void main(String[] args) throws Throwable {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        Class clazz = loader.loadClass("com.smart.reflect.PrivateCar");
        PrivateCar pcar = (PrivateCar)clazz.newInstance();
        Field colorFld = clazz.getDeclaredField("color");
        
        // ①取消Java语言访问检查以访问private变量
        colorFld.setAccessible(true);
        colorFld.set(pcar, "红色");
        
        Method driveMtd = clazz.getDeclaredMethod("drive", (Class[])null);
        // Method driveMtd = clazz.getDeclaredMethod("drive"); JDK 5.0下使用
        
        // ②取消Java语言访问检查以访问protected方法
        driveMtd.setAccessible(true);
        driveMtd.invoke(pcar, (Object[])null);
    }
}
~~~

运行该类，打印出以下信息：

~~~
drive private car! the color is: 红色
~~~

在访问private或protected成员变量和方法时，必须通过setAccessible(boolean access)方法取消Java语言检查，否则将抛出IllegalAccessException。如果JVM的安全管理器设置了相应的安全机制，那么调用该方法将抛出SecurityException。

## 4.3 资源访问利器

### 4.3.1 资源抽象接口

JDK所提供的访问资源的类（如java.net.URL、File类）并不能很好地满足各种底层资源的访问需求，比如确少从类路径或者Web容器的上下文中获取资源的操作类。鉴于此，Spring设计了一个Resource接口，它为应用提供了更强的底层资源访问能力。该接口具有对应不同资源类型的实现类。先来了解一下Resource接口的主要方法。

- `boolean exists()`： 资源是否存在。
- `boolean isOpen()`： 资源是否打开。
- `URL getURL() throws IOException`：如果底层资源可以表示成URL，则该方法返回对应的URL对象。
- `File getFile() throws IOException`： 如果底层资源对应一个文件，则该方法返回对应的File对象。
- `InputStream getInputStream() throws IOException`： 返回资源对应的输入流。

Resource在Spring框架中起着不可或缺的作用，Spring框架使用Resource装载各种资源，包括配置文件资源、国际化属性文件资源等。下面我们来了解一下Resource的具体实现类。

~~~mermaid
classDiagram
	Resource<|..AbstractResource
	Resource<|--WritableResource
	AbstractResource<|--ByteArrayResource
	AbstractResource<|--InputStreamResource
	AbstractResource<|--ClassPathResource
	AbstractResource<|--PortletContextResource
	AbstractResource<|--ServletContextResource
	AbstractResource<|--DescriptiveResource
	AbstractResource<|--UrlResource
	AbstractResource<|--PathResource
	WritableResource<|..PathResource
	AbstractResource<|--FileSystemResource
	WritableResource<|..FileSystemResource
~~~

- WritableResource：可写资源接口，是Spring 3.1版本新加的接口，有两个实现类，即FileSystemResource和PathResource，其中PathResource是Spring 4.0提供的实现类。
- ByteArrayResource：二进制数组表示的资源，二进制数组资源可以在内存中通过程序构造。
- ClassPathResource：类路径下的资源，资源以相对于类路径的方式表示。
- FileSystemResource：文件系统资源，资源以文件系统路径的方式表示，如`D:/conf/bean.xml`等。
- InputStreamResource：以输入流返回表示的资源。
- ServletContextResource：为访问Web容器上下文中的资源而设计的类，负责以相对于Web应用根目录的路径加载资源。它支持以流和URL的方式访问，在WAR解包的情况下，也可以通过File方式访问。该类还可以直接从JAR包中访问资源。
- UrlResource：URL封装了java.net.URL，它使用户能够访问任何可以通过URL表示的资源，如文件系统的资源、HTTP资源、FTP资源等。
- PathResource：Spring 4.0提供的读取资源文件的新类。Path封装了java.net.URL、java.nio.file.Path（Java 7.0 提供）、文件系统资源，它使用户能够访问任何可以通过URL、Path、系统文件路径表示的资源，如文件系统的资源、HTTP资源、FTP资源等。

有了这个抽象的资源类后，就可以将Spring的配置信息放置在任何地方（如数据库、LDAP中），只要最终可以通过Resource接口返回配置信息即可。

> 提示：Spring的Resource接口及其实现类可以在脱离Spring框架的情况下使用，它比通过JDK访问资源的API更好用、更强大。

假设有一个文件位于Web应用的类路径下，用户可以通过以下方式对这个方式资源进行访问：

- 通过FileSymtemResource以文件系统绝对路径的方式进行访问。
- 通过ClassPathResource以类路径的方式进行访问。
- 通过ServletContextResource以相对于Web应用根目录的方式进行访问。

相比于通过JDK的File类访问文件资源的方式，Spring的Resource实现类无疑提供了更加灵活便捷的访问方式，用户可以根据实际情况选择适合的Resource实现类访问资源。

在获取资源后，用户就可以通过Resource接口定义的多个方法访问文件的数据和其他信息。如可以通过getFileName()方法获取文件名，通过getFile()方法获取资源对应的File对象，通过getInputStream()方法直接获取文件的输入流。通过WritableResource接口定义的多个方法向文件写数据，通过getOutputStream()方法直接获取文件的输出流。此外，还可以通过createRelative(String relativePath)在资源相对地址上创建新的文件。

在Web应用中，用户还可以通过ServletContextResource以相对于Web应用根目录的方式访问文件资源。

对于位于远程服务器（Web服务器或FTP服务器）的文件资源，用户可以方便地通过UrlResource进行访问。

资源加载时默认采用系统编码读取资源内容。如果资源文件采用特殊的编码格式，那么可以通过EncodedResource对资源进行编码，以保证资源内容操作的正确性。

### 4.3.2 资源加载

为了访问不同类型的资源，必须使用相应的Resource实现类，这是比较麻烦的。Spring提供了一个强大的加载资源的机制，不但能够通过“classpath:”、“file:”等资源地址前缀识别不同的资源类型，还支持Ant风格带通配符的资源地址。

#### 1、资源地址表达式

| 地址前缀   | 示例                                       | 对应的资源类型                                               |
| ---------- | ------------------------------------------ | ------------------------------------------------------------ |
| classpath: | classpath: com/smart/beanfactory/beans.xml | 从类路径中加载资源，classpath:和classpath:/是等价的，都是相对于类的根路径。资源文件可以在标准的文件系统中，也可以在JAR或ZIP的类包中。 |
| file:      | file:/conf/com/smart/beanfactory/beans.xml | 使用UrlResource从文件系统目录中装载资源，可采用绝对或相对路径 |
| http://    | http://www.smart.com/resource/bean.xml     | 使用UrlResource从Web服务器中装载资源                         |
| ftp://     | ftp://www.smart.com/resource/beans.xml     | 使用UrlResource从FTP服务器中装载资源                         |
| 没有前缀   | com/smart/beanfactory/beans.xml            | 根据 ApplicationContext的具体实现类采用对应类型的Resource    |

其中，和“classpath:”对应的还有另一种比较难理解的"`classpath*:`"前缀。假设有多个JAR包或文件系统类路径都拥有相同的包名（如com.smart）。“classpath:”只会在第一个加载的com.smart包的类路径下查找，而"`classpath*:`"会扫描所有这些JAR包及类路径下出现的com.smart类路径。

这对于分模块打包的应用非常有用。

Ant风格的资源地址支持3种匹配符。

- `?`：匹配文件名中的一个字符
- `*`：匹配文件名中的任意字符
- `**`：匹配多层路径

下面是几个Ant风格的资源路径的示例：

- `classpath:/t?st.xml`：匹配com类路径下的com/test.xml、com/tast.xml或者com/txst.xml文件
- `file:D:/conf/*.xml`：匹配文件系统D:/conf目录下所有以.xml为后缀的文件
- `classpath:com/**/test.xml`：匹配com类路径下（当前目录及其子孙目录）的test.xml文件。
- `classpath:org/springframework/**/*.xml`： 匹配类路径org/springframework下所有以.xml为后缀的文件。
- `classpath:org/**/servlet/bla.xml`：不仅匹配类路径org/springframework/servlet/bla.xml，也匹配org/springframework/testing/servlet/bla.xml，还匹配org/servlet/bla.xml。

#### 2、资源加载器

Spring定义了一套资源加载的接口，并提供了实现类，如下图所示

~~~mermaid
classDiagram
	class ResourcePatternResolver{
		+ getResources(String locationPattern): Resource[]
	}
	class ResourceLoader{
		+ getResources(String location): Resource
	}
	class Resource{
		+ getFile(): File
		+ getURI(): URI
	}
	ResourcePatternResolver<|..PathMatchingResourcePatternResolver
	ResourceLoader<|--ResourcePatternResolver
	ResourceLoader-->Resource
~~~

ResourceLoader接口仅有一个getResource(String location)方法，可以根据一个资源地址加载文件资源。不过，资源地址仅支持带资源类型前缀的表达式，不支持Ant风格的资源路径表达式。

ResourcePatternResolver扩展ResourceLoader接口，定义了一个新的接口方法getResources(String locationPattern)，该方法支持带资源类型前缀及Ant风格的资源路径表达式。

PathMatchingResourcePatternResolver是Spring提供的标准实现类。

> 实战经验： 用Resource操作文件时，如果资源配置文件在项目发布时会被打包到JAR中，那么不能使用Resource#getFile()方法，否则会抛出FileNotFoundException。但可以使用Resource#getInputStream()方法读取。
>
> 这个问题在实际项目开发过程中很容易被忽视，因为在项目开发时，资源配置文件一般是在文件夹下的，所以Resource#getFile()是可以正常工作的。但在发布时，如果资源配置文件被打包到JAR中，这时getFile()就无法读取了，从而造成部署实施的时候出现意想不到的问题。因此，我们建议尽量以流的方式读取，避免环境不同造成的问题。

## 4.4 BeanFactory和ApplicationContext

Spring通过一个配置文件描述Bean及Bean之间的依赖关系，利用Java语言的反射功能实例化Bean并建立Bean之间的依赖关系。Spring的IoC容器在完成这些底层工作的基础上，还提供了Bean实例缓存、生命周期管理、Bean实例代理、事件发布、资源装载等高级服务。

**Bean工厂**（com.springframework.beans.factory.BeanFactory）是Spring框架最核心的接口，它提供了高级IoC的配置机制。BeanFactory使管理不同类型的Java对象成为可能，**应用上下文**（com.springframework.context.ApplicationContext）建立在BeanFactory基础之上，提供了更多面向应用的功能，它提供了国际化支持和框架事件体系，更易于创建实际应用。我们一般称BeanFactory为IoC容器，而称ApplicationContext为应用上下文。但有时为了行文方便，我们也将ApplicationContext成为Spring容器。

对于二者的用途，我们可以进行简单的划分：BeanFactory是Spring框架的基础设施，面向Spring本身：ApplicationContext面向使用Spring框架的开发者，几乎所有的应用场合都可以直接使用ApplicationContext而非底层的BeanFactory。

### 4.4.1 BeanFactory介绍

诚如其名，BeanFactory是一个类工厂，但和传统的类工厂不同，传统的类工厂仅负责构造一个或几个类的实例：而BeanFactory是类的通用工厂，它可以创建并管理各种类的对象。这些可被创建和管理的对象本身没有什么特别之处，仅是一个POJO，Spring称这些被创建和管理的Java对象为Bean。我们知道JavaBean是要满足一定规范的，如必须提供一个默认不带参的构造函数、不依赖于某一特定的容器等，但Spring所说的Bean比JavaBean更宽泛一些，所有可以被Spring容器实例化并管理的Java类都可以成为Bean。

#### 1、BeanFactory的类体系结构

Spring为BeanFactory提供了多种实现，最常用的是XmlBeanFactory，但在Spring3.2中已被废弃，建议使用XmlBeanDefinationReader、DefaultListableBeanFactory替代。BeanFactory的类继承体系设计优雅，堪称经典。通过继承体系，我们可以很容易地了解到BeanFactory具有哪些功能，如下图所示。

~~~mermaid
classDiagram
class BeanFactory{
	<<interface>>
}
class ListableBeanFactory{
	<<interface>>
}
class HierachicalBeanFactory{
	<<interface>>
}
class ConfigurableBeanFactory{
	<<interface>>
}
class ConfigurableListableBeanFactory{
	<<interface>>
}
class BeanDefinationRegistry{
	<<interface>>
}
class SingletonBeanRegistry{
	<<interface>>
}
class AutowireCapableBeanFactory{
	<<interface>>
}
	BeanFactory<|--ListableBeanFactory
	BeanFactory<|--HierachicalBeanFactory
	HierachicalBeanFactory<|--ConfigurableBeanFactory
	ListableBeanFactory<|--ConfigurableListableBeanFactory
	ConfigurableBeanFactory<|--ConfigurableListableBeanFactory
	BeanDefinationRegistry<|..DefaultListableBeanFactory
	ConfigurableListableBeanFactory<|..DefaultListableBeanFactory
	ConfigurableBeanFactory<|..AbstractBeanFactory
	AbstractAutowireCapableBeanFactory<|--DefaultListableBeanFactory
	AbstractBeanFactory<|--AbstractAutowireCapableBeanFactory
	DefaultSingletonBeanRegistry<|--AbstractBeanFactory
	SingletonBeanRegistry<|..DefaultSingletonBeanRegistry
	AutowireCapableBeanFactory<|..AbstractAutowireCapableBeanFactory
~~~

BeanFactory接口位于类结构树的顶端，它最主要的方法就是getBean(String beanName)，该方法从容器中返回特定名称的Bean。BeanFactory的功能通过其他接口得到不断扩展。下面对图中其他接口分别进行说明。

- ListableBeanFactory：该接口定义了访问容器中Bean基本信息的若干方法，如查看Bean的个数、获取某一类型Bean的配置名、查看容器中是否包括某一Bean等。
- HierarchicalBeanFactory：父子级联IoC容器的接口，子容器可以通过接口方法访问父容器。
- ConfigurableBeanFactory：这是一个重要的接口，增强了IoC容器的可定制性。它定义了设置类装载器、属性编辑器、容器初始化后置处理器等方法。
- AutowireCapableBeanFactory：定义了将容器中的Bean按某种规则（如按名字匹配、按类型匹配等）进行自动装配的方法。
- SingletonBeanRegistry：定义了允许在运行期向容器注册单实例Bean的方法。
- BeanDefinitionRegistry：Spring配置文件中每一个`<bean>`节点元素在Spring容器里都通过一个BeanDefinition对象表示，它描述了Bean的配置信息。而BeanDefinitionRegistry接口提供了向容器手工注册BeanDefinition对象的方法。

#### 2、初始化BeanFactory

下面使用Spring配置文件为Car提供配置信息，然后通过BeanFactory装载配置文件，启动Spring IoC容器。Spring配置文件如下代码清单4-18所示：

~~~xml
<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w4.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">
    <bean id="car1" class="com.smart.Car" 
          p:brand="红旗CA72" 
          p:color="黑色" 
          p:maxSpeed="200" />
</beans>
~~~

下面通过XmlBeanDefinitionReader、DefaultListableBeanFactory实现类启动Spring IoC容器，如下代码清单4-19所示

~~~java
package com.smart.beanfactory;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.beans.factory.xml.XmlBeanDefinitionReader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.io.support.ResourcePatternResolver;
import com.smart.Car;
import org.testng.annotations.*;
import static org.testng.Assert.*;

public class BeanFactoryTest{
    @Test
    public void getBean() throws Throwable{
        ResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource res = resolver.getResource("classpath:com/smart/beanfactory/beans.xml");
        System.out.println(res.getURL());
        
        // 被废弃，不建议使用
        // BeanFactory bf = new XmlBeanFactory(res);
        DefaultListableBeanFactory factory = new DefaultListableBeanFactory();
        XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(factory);
        reader.loadBeanDefinitions(res);
        
        System.out.println("init BeanFactory.");
        
        Car car = factory.getBean("car", Car.class);
        System.out.println("car bean is ready for use!");
        car.introduce();
    }
}
~~~

XmlBeanDefinitionReader通过Resource装载Spring配置信息并启动IoC容器，然后就可以通过BeanFactory#getBean(beanName)方法从IoC容器中获取Bean。通过BeanFactory启动IoC容器时，并不会初始化配置文件中定义的Bean，初始化动作发生在第一个调用时。对于单实例（singleton）的Bean来说，BeanFactory会缓存Bean实例，所以第二次使用getBean()获取Bean时，将直接从IoC容器的缓存中获取Bean实例。

Spring在DefaultSingletonBeanRegistry类中提供了一个用于缓存单实例Bean的缓存器，它是一个用HashMap实现的缓存器，单实例的Bean以beanName为键保存在这个HashMap中。

值得一提的是，在初始化BeanFactory时，必须为其提供一种日志框架，我们使用Log4j，即在类路径下提供Log4j配置文件，这样启动Spring容器才不会报错。

### 4.4.2 ApplicationContext介绍

如果说BeanFactory是Spring的“心脏”，那么ApplicationContext就是完整的“身躯”了。ApplicationContext由BeanFactory派生而来，提供了更多面向实际应用的功能。在BeanFactory中，很多功能需要以编程的方式实现，而在ApplicationContext中则可以通过配置的方式实现。

#### 1、ApplicationContext类体系结构

ApplicationContext的主要实现类是ClassPathXmlApplicationContext和FileSystemXmlApplicationContext，前者默认从类路径加载配置文件，后者默认从文件系统中装载配置文件。下面了解一下ApplicationContext的类继承体系，如下图所示。

~~~mermaid
classDiagram
class ApplicationEventPublisher{
	<<interface>>
}
class MessageSource{
	<<interface>>
}
class ApplicationContext{
	<<interface>>
}
class ResourcePatternResolver{
	<<interface>>
}
class ResourceLoader{
	<<interface>>
}
class BeanFactory{
	<<interface>>
}
class HierachicalBeanFactory{
	<<interface>>
}
class ListableBeanFactory{
	<<interface>>
}
class LifeCycle{
	<<interface>>
}
class ConfigurableApplicationContext{
	<<interface>>
}
ApplicationEventPublisher<|--MessageSource
MessageSource<|--ApplicationContext
ApplicationEventPublisher<|--ApplicationContext
ResourceLoader<|--ResourcePatternResolver
ResourcePatternResolver<|--ApplicationContext
BeanFactory<|--HierachicalBeanFactory
BeanFactory<|--ListableBeanFactory
HierachicalBeanFactory<|--ApplicationContext
ListableBeanFactory<|--ApplicationContext
ApplicationContext<|--ConfigurableApplicationContext
LifeCycle<|--ConfigurableApplicationContext
ConfigurableApplicationContext<|..AbstractApplicationContext
AbstractApplicationContext<|--GenericApplicationContext
GenericApplicationContext<|--GenericGroovyApplicationContext
GenericApplicationContext<|--AnnotationConfigApplicationContext
AbstractApplicationContext<|--AbstractRefreshableApplicationContext
AbstractRefreshableApplicationContext<|--AbstractRefreshableConfigApplicationContext
AbstractRefreshableConfigApplicationContext<|--AbstractXmlApplicationContext
AbstractXmlApplicationContext<|--ClassPathXmlApplicationContext
AbstractXmlApplicationContext<|--FileSymstemXmlApplicationContext
~~~

ConfigurableApplicationContext扩展于ApplicationContext，它新增了两个主要的方法：refresh()和close()，让ApplicationContext具有启动、刷新和关闭上下文的能力。在应用上下文关闭的情况下调用refresh()即可启动应用上下文，在已经启动的状态下调用refresh()则可清除缓存并重新装载配置信息，而调用close()则可关闭应用上下文。这些接口方法为容器的控制管理带来了便利，但作为开发者，我们并不需要过多关心这些方法。

和BeanFactory初始化相似，ApplicationContext的初始化也很简单。如果配置文件放置在类路径下，则可以优先考虑使用ClassPathXmlApplicationContext实现类。

~~~java
ApplicationContext ctx = new ClassPathXmlApplicationContext("com/smart/context/beans.xml");
~~~

对于ClassPathXmlApplicationContext来说，“com/smart/context/beans.xml”等同于“classpath:com/smart/context/beans.xml”。

如果配置文件放置在文件系统的路径下，则可以优先考虑使用FileSystemXmlApplicationContext实现类。

~~~java
ApplicationContext ctx = new FileSystemXmlApplicationContext(
    new String[]{"conf/beans1.xml","conf/beans2.xml"});
~~~

当然，FileSystemXmlApplicationContext和ClassPathXmlApplicationContext都可以显式使用带资源类型前缀的路径，它们的区别在于如果不显式指定资源类型前缀，则分别将路径解析为文件系统路径和类路径。

在获取ApplicationContext实例后，就可以像BeanFactory一样调用getBean(beanName)返回Bean了。ApplicationContext的初始化和BeanFactory有一个重大的区别：BeanFactory在初始化容器时，并未实例化Bean，直到第一次访问某个Bean时才实例化目标Bean；

而ApplicationContext则在初始化应用上下文时就实例化所有单实例的Bean。因此，ApplicationContext的初始化时间会比BeanFactory稍长一些，不过稍后的调用则没有“第一次惩罚”的问题。

Spring支持基于类注解的配置方式，主要功能来自Spring的一个名叫JavaConfig的子项目。JavaConfig现已升级为Spring核心框架的一部分。一个标注@Configuration注解的POJO即可提供Spring所需的Bean配置信息，如下面代码清单4-20所示：

~~~java
package com.smart.context;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.smart.Car;

// ①表示是一个配置信息提供类
@Configuration
public class Beans {
    // ②定义一个Bean
    @Bean(name = "car")
    public Car buildCar(){
        Car car = new Car();
        car.setBrand("红旗CA72");
        car.setMaxSpeed(200);
        return car;
    }
}
~~~

和基于XML文件的配置方式相比，类注解的配置方式可以很容易地让开发者控制Bean地初始化过程，比基于XML文件地配置方式更加灵活。

Spring为基于注解类的配置提供了专门的ApplicationContext实现类：AnnotationConfigApplicationContext。来看一个使用AnnotationConfigApplicationContext启动Spring容器的示例，如代码清单4-21所示：

~~~java
package com.smart.context;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import com.smart.Car;
import static org.testng.Assert.*;
import org.testng.annotations.*;

public class AnnotationApplicationContextTest {
    @Test
    public void getBean(){
        // ①通过一个带@Configuration的POJO装载Bean配置
        ApplicationContext ctx = new AnnotationConfigApplicationContext(Beans.class);
        Car car = ctx.getBean("car", Car.class);
        assertNotNull(car);
    }
}
~~~

AnnotationConfigApplicationContext将加载Bean.class中的Bean定义并调用Beans.class中的方法实例化Bean，启动容器并装配Bean。关于使用JavaConfig配置方式的详细内容，将在第5章详细介绍。

Spring 4.0支持使用Groovy DSL来进行Bean定义配置。其与基于XML文件的配置类似，只不过基于Groovy脚本语言，可以实现负责、灵活的Bean配置逻辑，来看一个例子，如代码清单4-22所示。

~~~java
package com.smart.context;
import com.smart.Car;

beans{
    car(Car){ // ①名字（类型）
        brand = "红旗CA72" //②注入属性
        maxSpeed = "200"
        color = "red"
    }
}
~~~

基于Groovy的配置方式可以很容易地让开发者配置复杂Bean的初始化过程，比基于XML文件、注解的配置方式更加灵活。

Spring为基于Groovy的配置提供了专门的ApplicationContext实现类：GenericGroovyApplicationContext。来看一个如何使用GenericGroovyApplicationContext启动Spring容器的示例，如代码清单4-23所示：

~~~java
package com.smart.context;

import com.smart.Car;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.GenericGroovyApplicationContext;
import org.testng.annotations.*;
import static org.testng.Assert.*;

public class AnnotationApplicationContextTest {
    @Test
    public void getBean(){
        // ①通过一个带@Configuration的POJO装载Bean配置
        ApplicationContext ctx = new GenericGroovyApplicationContext("classpath:com/smart/context/groovy-beans.groovy");
        Car car = (Car) ctx.getBean("car");
        assertNotNull(car);
        assertEquals(car.getColor(), "red");
    }
}
~~~

#### 2、WebApplicationContext类体系结构

WebApplicationContext是专门为Web应用准备的，它允许从相对于Web根目录的路径中装载配置文件完成初始化工作。从WebApplicationContext中可以获得ServletContext的引用，整个Web应用上下文对象将作为属性放置到ServletContext中，以便Web应用环境可以访问Spring应用上下文。Spring专门为此提供了一个工具类WebApplicationContextUtils，通过该类的getWebApplicationContext(ServletContext sc)方法，可以从ServletContext中获取WebApplicationContext实例。

在非Web应用的环境下，Bean只有singleton和prototype两种作用域。WebApplicationContext为Bean添加了三个新的作用域：request、session和global session。

下面来看一下WebApplicationContext的类继承体系，如下图所示：

~~~mermaid
classDiagram
class ApplicationContext{
	<<interface>>
}
class ConfigurableApplicationContext{
	<<interface>>
}
class WebApplicationContext{
	<<interface>>
}
class ConfigurableWebApplicationContext{
	<<interface>>
}
ApplicationContext<|--ConfigurableApplicationContext
ApplicationContext<|--WebApplicationContext
ConfigurableApplicationContext<|..AbstractApplicationContext
AbstractApplicationContext<|--AbstractRefreshableApplicationContext
AbstractRefreshableApplicationContext<|--AbstractRefreshableConfigApplicationContext
AbstractRefreshableConfigApplicationContext<|--AbstractXmlApplicationContext
AbstractRefreshableConfigApplicationContext<|--AbstractRefreshableWebApplicationContext
WebApplicationContext<|--ConfigurableWebApplicationContext
ConfigurableWebApplicationContext<|..AbstractRefreshableWebApplicationContext
AbstractRefreshableWebApplicationContext<|--XmlWebApplicationContext
AbstractRefreshableWebApplicationContext<|--AnnotationConfigWebApplicationContext
AbstractRefreshableWebApplicationContext<|--GroovyWebApplicationContext
~~~

由于Web应用比一般的应用拥有更多的特性，因此WebApplicationContext扩展了ApplicationContext。WebApplicationContext定义了一个常量ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE，在上下文启动时，WebApplication实例即以此为键放置在ServletContext的属性列表中，可以通过以下语句中从Web容器中获取WebApplicationContext：

~~~java
WebApplicationContext wac = (WebApplicationContext)servletContext.getAttribute(
WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
~~~

这正是前面提到的WebApplicationContextUtils工具类getWebApplicationContext(ServletContext sc)方法的内部实现方式。这样，Spring的Web应用上下文和Web容器的上下文应用就可以实现互访，二者实现了融合。

ConfigurableWebApplicationContext扩展了WebApplicationContext，它允许通过配置的方式实例化WebApplicationContext，同时定义了两个重要的方法。

- `setServletContext(ServletContext servletContext)`：为Spring设置Web应用上下文，以便两者整合。
- `setConfigLocations(String[] configLocations)`：设置Spring配置文件地址，一般情况下，配置文件地址是相对于Web根目录的地址，如/WEB-INF/smart-dao.xml、/WEB-INF/smart-service.xml等。但用户也可以使用带资源类型前缀的地址，如classpath:com/smart/beans.xml等。

#### 3、WebApplicationContext初始化

WebApplicationContext的初始化方式和BeanFactory、ApplicationContext有所区别，因为WebApplicationContext需要ServletContext实例，也就是说，它必须在拥有Web容器的前提下才能完成启动工作。有过Web开发经验的读者都知道，可以在web.xml中配置自启动的Servlet或定义Web容器监听器(ServletContextListener)，借助二者中的任何一个，就可以完成启动Spring Web应用上下文的工作。

> 提示：所有版本的Web容器都可以定义自启动的Servlet，但只有Servlet 2.3及以上版本的Web容器才支持Web容器监听器。有些即使支持Servlet 2.3的Web服务器，也不能在Servlet初始化之前启动Web监听器，如Weblogic 8.1、WebSphere 5.x、Oracle OC4J 9.0。

Spring分别提供了用于启动WebApplicationContext的Servlet和Web容器监听器：

- org.springframework.web.context.ContextLoaderServlet。
- org.springframework.web.context.ContextLoaderListener。

二者的内部都实现了启动WebApplicationContext实例的逻辑，只要根据Web容器的具体情况选择二者之一，并在web.xml中完成配置即可。

代码清单4-24是使用ContextLoaderListener启动WebApplicationContext的具体配置。

~~~xml
...
<!--①指定配置文件-->
<context-param>
	<param-name>contextConfigLocation</param-name>
    <param-value>
        WEB-INF/smart-dao.xml, /WEB-INF/smart-service.xml
    </param-value>
</context-param>

<!--②声明Web容器监听器-->
<listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
~~~

ContextLoaderListener通过Web容器上下文参数contextConfigLocation获取Spring配置文件的位置。用户可以指定多个配置文件，用逗号、空格或冒号分隔均可。对于未带资源类型前缀的配置文件路径，WebApplicationContext默认这些路径相对于Web的部署根路径。当然，也可以采用带资源类型前缀的路径配置，如“`classpath*:/smart-*.xml`”和上面的配置是等效的。

如果在不支持容器监听器的低版本Web容器中，则可以采用ContextLoaderServlet完成相同的工作，如代码清单4-25所示：

~~~xml
...
<context-param>
	<param-name>contextConfigLocation</param-name>
    <param-value>
        WEB-INF/smart-dao.xml, /WEB-INF/smart-service.xml
    </param-value>
</context-param>
...
<!--①声明自启动的Servlet-->
<servlet>
	<servlet-name>springContextLoaderServlet</servlet-name>
    <servlet-class>org.springframework.web.context.ContextLoaderServlet</servlet-class>
    
    <!--②启动顺序-->
    <load-on-startup>1</load-on-startup>
</servlet>
~~~

由于WebApplicationContext需要使用日志功能，所以用户可以将Log4J的配置文件放置在类路径WEB-INF/classes下，这时Log4J引擎即可顺利启动。如果Log4J配置文件放置在其他位置，那么用户必须在web.xml中指定Log4J配置文件的位置。Spring为启动Log4J引擎提供了两个类似于启动WebApplicationContext的实现类：Log4jConfigServlet和Log4jConfigListener，不管采用哪种方式，都必须保证能够在装载Spring配置文件前先装载Log4J配置信息，如代码清单4-26所示。

~~~xml
<context-param>
	<param-name>contextConfigLocation</param-name>
    <param-value>
        WEB-INF/smart-dao.xml, /WEB-INF/smart-service.xml
    </param-value>
</context-param>
<!--①指定Log4J配置文件的位置-->
<context-param>
	<param-name>log4jConfigLocation</param-name>
    <param-value>WEB-INF/log4j.properties</param-value>
</context-param>
<!--②装载Log4J配置文件的自启动Servlet-->
<servlet>
	<servlet-name>log4jConfigServlet</servlet-name>
    <servlet-class>org.springframework.web.util.Log4jConfigServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
</servlet>
<servlet>
	<servlet-name>springContextLoaderServlet</servlet-name>
    <servlet-class>org.springframework.web.context.ContextLoaderServlet</servlet-class>
    <load-on-startup>2</load-on-startup>
</servlet>
~~~

注意上面将log4jConfigServlet的启动顺序号设置为1，而将springContextLoaderServlet的启动顺序号设置为2。这样，前者将先启动，完成装载Log4J配置文件并初始化Log4J引擎的工作，紧接着后者再启动。如果使用Web监听器，则必须将Log4jConfigListener放置在ContextLoaderListener前面。采用以上配置方式，Spring将自动使用XmlWebApplicationContext启动Spring容器，即通过XML文件为Spring容器提供Bean的配置信息。

如果使用标注@Configuration的Java类提供配置信息，则web.xml需要按以下方式配置，如代码清单4-27所示。

~~~xml
<web-app>
	<!--通过指定context参数，让Spring使用AnnotationConfigWebApplicationContext而非XmlWebApplicationContext启动容器-->
    <context-param>
    	<param-name>contextClass</param-name>
        <param-value>
        	org.springframework.web.context.support.AnnotationConfigWebApplicationContext
        </param-value>
    </context-param>
    
    <!--指定标注了@Configuration的配置类，多个可以使用逗号或空格分隔-->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>
        	com.smart.AppConfig1,com.smart.AppConfig2
        </param-value>
    </context-param>
    
    <!-- ContextLoaderListener监听器将根据上面的配置使用
		AnnotationConfigWebApplicationContext根据contextConfigLocation
		指定的配置类启动Spring容器-->
    <listener>
        <listener-class>
        	org.springframework.web.context.ContextLoaderListener
        </listener-class>
    </listener>
</web-app>
~~~

ContextLoaderListener如果发现配置了contextClass上下文参数，就会使用参数所指定的WebApplicationContext实现类（AnnotationConfigWebApplicationContext）初始化容器，该实现类会根据contextConfigLocation上下文参数指定的标注@Configuration的配置类所提供的Spring配置信息初始化容器。

如果使用Groovy DSL配置Bean信息，则web.xml需要按以下方式配置，如代码清单4-28所示。

~~~xml
<web-app>
    <!--通过指定context参数，让Spring使用GroovyWebApplicationContext而非XmlWebApplicationContext或AnnotationConfigWebApplicationContext启动容器-->
    <context-param>
    	<param-name>contextClass</param-name>
        <param-value>
        	org.springframework.web.context.support.GroovyWebApplicationContext
        </param-value>
    </context-param>
    
    <!--指定标注了Groovy的配置类-->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>
        	Classpath*:conf/spring-mvc.groovy
        </param-value>
    </context-param>
    
    <!-- ContextLoaderListener监听器将根据上面的配置使用
		GroovyWebApplicationContext根据contextConfigLocation
		指定的配置类启动Spring容器-->
    <listener>
        <listener-class>
        	org.springframework.web.context.ContextLoaderListener
        </listener-class>
    </listener>
</web-app>
~~~

GroovyWebApplicationContext实现类会根据contextConfigLocation上下文参数指定的conf/spring-mvc.groovy所提供的Spring配置信息初始化容器。

### 4.4.3 父子容器

通过HierarchicalBeanFactory接口，Spring的IoC容器可以建立父子层级关联的容器体系，子容器可以访问父容器中的Bean，但父容器不能访问子容器中的Bean。在容器内，Bean的id必须是唯一的，但子容器可以拥有一个和父容器id相同的Bean。父子容器层级体系增强了Spring容器架构的扩展性和灵活性，因为第三方可以通过编程的方式为一个已经存在的容器添加一个或多个特殊用途的子容器，以提供一些额外的功能。

Spring使用父子容器实现了很多功能，比如在SpringMVC中，展示层Bean位于一个子容器中，而业务层和持久层Bean位于父容器中。这样，展现层Bean就可以引用业务层和持久层Bean，而业务层和持久层Bean则看不到展现层Bean。

## 4.5 Bean的生命周期

我们知道Web容器的Servlet拥有明确的生命周期，Spring容器中的Bean也拥有相似的生命周期。Bean生命周期由多个特定的生命阶段组成，每个生命阶段都开出了一扇门，允许外界借由此门对Bean施加控制。

在Spring中，可以从两个层面定义Bean的生命周期：第一个层面是Bean的作用范围；第二个层面是实例化Bean时所经历的一系列阶段。下面分别对BeanFactory和ApplicationContext中Bean的生命周期进行分析。

### 4.5.1 BeanFactory中Bean的生命周期

#### 1、生命周期图解

由于Bean的生命周期所经历的阶段比较多，下面将通过图形化的方式进行描述。<span id="graph4-11">图4-11</span>描述了BeanFactory中Bean生命周期的完整过程

~~~mermaid
graph TB
start(( ))--通过getBean方法调用某一个Bean-->postProcessBeforeInstantiation(*调用InstantiationAwareBeanPostProcessor的postProcessBeforeInstantiation方法)
postProcessBeforeInstantiation-->实例化
实例化-->postProcessAfterInstantiation(*调用InstantiationAwareBeanPostProcessor的postProcessBeforeInstantiation方法)
postProcessAfterInstantiation-->postProcessPropertyValues(*调用InstantiationAwareBeanPostProcessor的postProcessPropertyValues方法)
postProcessPropertyValues-->设置属性值
设置属性值-->setBeanName(调用BeanNameAware的setBeanName方法)
setBeanName-->setBeanFactory(调用BeanFactoryAware的setBeanFactory方法)
setBeanFactory-->postProcessBeforeInitialization(*调用BeanPostProcessor的postProcessBeforeInitialization方法)
postProcessBeforeInitialization-->afterPropertiesSet(调用InitializingBean的afterPropertiesSet方法)
afterPropertiesSet-->init-method(通过init-method属性配置的初始化方法)
init-method--singleton-->缓冲池Bean((Spring缓存池中准备就绪的Bean))
init-method--prototype-->调用者Bean((将准备就绪的Bean交给调用者))
缓冲池Bean--容器销毁-->destroy(调用DisposableBean的destroy方法)
destroy-->destroy-method(通过destroy-method属性配置的销毁方法)
destroy-method-->stop(( ))
style 调用者Bean stroke:#f66,stroke-width:2px,stroke-dasharray: 5, 5
~~~

具体过程如下。

1. 当调用者通过getBean(beanName)向容器请求某一个Bean时，如果容器注册了org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor接口，则在实例化Bean之前，将调用接口的postProcessBeforeInstantiation()方法。
2. 根据配置情况调用Bean构造函数或工厂方法实例化Bean。
3. 如果容器注册了InstantiationAwareBeanPostProcessor接口，那么在实例化Bean之后，调用该接口的postProcessAfterInstantiation()方法，可在这里对已经实例化的对象进行一些“梳妆打扮”。
4. 如果Bean配置了属性信息，那么容器在这一步着手将配置值设置到Bean对应的属性中，不过在设置每个属性之前将先调用InstantiationAwareBeanPostProcessor接口的postProcessPropertyValues()方法。
5. 调用Bean的属性设置方法设置属性值。
6. 如果Bean实现了org.springframework.beans.factory.BeanNameAware接口，则将调用setBeanName()接口方法，将配置文件中该Bean对应的名称设置到Bean中。
7. 如果Bean实现了org.springframework.beans.factory.BeanFactoryAware接口，则将调用setBeanFactory()接口方法，将BeanFactory容器实例设置到Bean中。
8. 如果BeanFactory装配了org.springframework.beans.factory.config.BeanPostProcessor后处理器，则将调用BeanPostProcessor的Object postProcessBeforeInitialization(Object bean, String beanName)接口方法对Bean进行加工操作。其中，入参bean是当前正在处理的Bean，而beanName是当前Bean的配置名，返回的对象为加工处理后的Bean。用户可以使用该方法对某些Bean进行特殊的处理，甚至改变Bean的行为。BeanPostProcessor在Spring框架中占有重要的地位，为容器提供对Bean进行后续加工处理的切入点，Spring容器所提供的各种“神奇功能”（如AOP、动态代理等）都通过BeanPostProcessor实施。
9. 如果Bean实现了InitializingBean接口，则将调用接口的afterPropertiesSet()方法。
10. 如果在`<bean>`中通过init-method属性定义了初始化方法，则将执行这个方法。
11. BeanPostProcessor后处理器定义了两个方法：其一是postProcessorBeforeInitialization()，在第8步调用；其二是Object postProcessAfterInitialization(Object bean, String beanName)，这个方法在此时调用，容器再次获得对Bean进行加工处理的机会。
12. 如果在`<bean>`中指定Bean的作用范围为scope="prototype"，则将Bean返回给调用者，调用者负责Bean后续生命的管理，Spring不再管理这个Bean的生命周期。如果将作用范围设置为scope="singleton"，则将Bean放入Spring IoC容器的缓存池中，并将Bean引用返回给调用者，Spring继续对这些Bean进行后续的生命管理。
13. 对于scope="singleton"的Bean（默认情况），当容器关闭时，将触发Spring对Bean后续生命周期的管理工作。如果Bean实现了DisposableBean接口，则将调用接口的destroy()方法，可以在此编写释放资源、记录日志等操作。
14. 对于scope="singleton"的Bean，如果通过`<bean>`的destroy-method属性指定了Bean的销毁方法，那么Spring将执行Bean的这个方法，完成Bean资源的释放等操作。

Bean的完整生命周期从Spring容器着手实例化Bean开始，直到最终销毁Bean。其中经过了许多关键点，每个关键点都涉及特定的方法调用，可以将这些方法大致划分为4类。

- Bean自身的方法：如调用Bean构造函数实例化Bean、调用Setter设置Bean的属性值及通过`<bean>`的init-method和destroy-method所指定的方法。
- Bean级生命周期接口方法：如BeanNameAware、BeanFactoryAware、InitializingBean和DisposableBean，这些接口方法由Bean类直接实现。
- 容器级生命周期接口方法：在[图4-11](#graph4-11)中带"`*`"的步骤是由InstantiationAwareBeanPostProcessor和BeanPostProcessor这两个接口实现的，一般称它们的实现类为“后处理器”。后处理器接口一般不由Bean本身实现，它们独立于Bean，实现类以容器附加装置的形式注册到Spring容器中，并通过接口反射为Spring容器扫描识别。当Spring容器创建任何Bean的时候，这些后处理都会发生作用，所以这些后处理器的影响是全局性的。当然，用户可以通过合理地编写后处理器，让其仅对感兴趣的Bean进行加工处理。
- 工厂后处理器接口方法：包括AspectJWeavingEnabler、CustomAutowireConfigurer、ConfigurationClassPostProcessor等方法。工厂后处理器也是容器级的，在应用上下文装配配置文件后立即调用。

Bean级生命周期接口和容器级生命周期接口是个性和共性辩证统一思想的体现，前者解决Bean个性化处理的问题，而后者解决容器中某些Bean共性化处理的问题。

Spring容器中是否可以注册多个后处理器呢？答案是肯定的。只要它们同时实现org.springframework.core.Ordered接口，容器将按特定的顺序依次调用这些后处理器。所以[图4-11](#graph4-11)带"`*`"的步骤都可能调用多个后处理器进行一系列加工操作。

InstantiationAwareBeanPostProcessor其实是BeanPostProcessor接口的子接口，Spring为其提供了一个适配器类InstantiationAwareBeanPostProcessorAdapter，一般情况下，可以方便地扩展该适配器覆盖感兴趣的方法以定义实现类。下面将通过一个具体的实例来更好地理解Bean生命周期的各个步骤。

#### 2、窥探Bean生命周期的实例

依旧采用前面介绍的Car类，让它实现所有Bean级的生命周期接口。此外，还定义了初始化和销毁的方法，这两个方法将通过`<bean>`的init-method和destroy-method属性指定，如代码清单4-29所示。

~~~java
package com.smart;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.BeanFactoryAware;
import org.springframework.beans.factory.BeanNameAware;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;

// ①管理Bean生命周期的接口
public class Car implements BeanFactoryAware, BeanNameAware, InitializingBean, DisposableBean {
    private String brand;
    private String color;
    private int maxSpeed;
    
    private BeanFactory beanFactory;
    private String beanName;
    
    public Car(){
        System.out.println("调用Car()构造函数。");
    }
    public void setBrand(String brand){
        System.out.println("调用setBrand()设置属性。");
        this.brand = brand;
    }
    public void introduce(){
        System.out.println("brand:" + brand + ";color:" + color + ";maxSpeed:" + maxSpeed);
    }
    
    // ②BeanFactoryAware接口方法
    public void setBeanFactory(BeanFactory beanFactory) throws BeansException {
        System.out.println("调用BeanFactoryAware.setBeanFactory()。");
        this.beanFactory = beanFactory;
    }
    
    // ③BeanNameAware接口方法
    public void setBeanName(String beanName) {
        System.out.println("调用BeanNameAware.setBeanName()。");
        this.beanName = beanName;
    }
    
    // ④InitializingBean接口方法
    public void afterPropertiesSet() throws Exception {
        System.out.println("调用InitializingBean.afterPropertiesSet()。");
    }
    
    // ⑤DisposableBean接口方法
    public void destroy() throws Exception {
        System.out.println("调用Disposable.destroy()。");
    }
    
    // ⑥通过<bean>的init-method属性指定的初始化方法
    public void myInit() {
        System.out.println("调用init-method所指定的myInit()，将maxSpeed设置为240。");
        this.maxSpeed = 240;
    }
    
    // ⑦通过<bean>的destroy-method属性指定的销毁方法
    public void myDestroy() {
        System.out.println("调用destroy-method所指定的myDestroy()。");
    }
}
~~~

Car类在②、③、④、⑤处实现了BeanFactoryAware、BeanNameAware、InitializingBean、DisposableBean这些Bean级的生命周期控制接口；在⑥和⑦处定义了myInit()和myDestroy()方法，以便在配置文件中通过init-method和destroy-method属性定义初始化和销毁方法。

MyInstantiationAwareBeanPostProcessor通过扩展InstantiationAwareBeanPostProcessor适配器InstantiationAwareBeanPostProcessorAdapter提供实现，如代码清单4-30所示。

~~~java
package com.smart.beanfactory;
import java.beans.PropertyDescriptor;
import org.springframework.beans.BeansException;
import org.springframework.beans.PropertyValues;
import org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessorAdapter;
import com.smart.Car;

public class MyInstantiationAwareBeanPostProcessor extends InstantiationAwareBeanPostProcessorAdapter {
    // ①接口方法：在实例化Bean前调用
    public Object postProcessBeforeInstantiation(Class beanClass, String beanName) throws BeansException {
        // ①-1仅对容器中的car Bean处理
        if("car".equals(beanName)){
            System.out.println("InstantiationAware BeanPostProcessor.postProcessBeforeInstantiation");
        }
        return null;
    }
    
    // ②接口方法：在实例化Bean后调用
    public boolean postProcessAfterInstantiation(Object bean, String beanName) throws BeansException {
        // ②-1仅对容器中的car Bean处理
        if("car".equals(beanName)){
            System.out.println("InstantiationAware BeanPostProcessor.postProcessAfterInstantiation");
        }
        return true;
    }
    
    // ③接口方法：在设置某个属性时调用
    public PropertyValues postProcessPropertyValues(PropertyValues pvs, PropertyDescriptor[] pds, Object bean, String beanName) throws BeanException {
        // ③-1仅对容器中的car Bean进行处理，还可以通过pdst入参进行过滤，
        // 仅对car的某个特定属性值进行处理
        if("car".equals(beanName)){
            System.out.println("Instantiation AwareBeanPostProcessor.postProcessPropertyValues");
        }
        return pvs;
    }
}
~~~

在MyInstatiationAwareBeanPostProcessor中，通过过滤条件仅对car Bean进行处理，对其他的Bean一概视而不见。

此外，还提供了一个BeanPostProcessor实现类，在该实现类中仅对car Bean进行处理，对配置文件所提供的属性设置值进行判断，并执行相应的“补缺补漏”操作，如代码清单4-31所示：

~~~java
package com.smart.beanfactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import com.smart.Car;
public class MyBeanPostProcessor implements BeanPostProcessor {
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        if(beanName.equals("car")){
            Car car = (Car)bean;
            if(car.getColor()==null){
                System.out.println("调用BeanPostProcessor.postProcessBeforeInitialization(), color为空，设置为默认黑色。");
                car.setColor("黑色");
            }
        }
        return bean;
    }
    
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        if(beanName.equals("car")){
            Car car = (Car)bean;
            if(car.getMaxSpeed()) >= 200){
                System.out.println("调用BeanPostProcessor.postProcessAfterInitialization(),将maxSpeed调整为200。");
                car.setMaxSpeed(200);
            }
        }
        return bean;
    }
}
~~~

在MyBeanPostProcessor类的postProcessBeforeInitialization()方法中，首先判断所处理的Bean是否名为car，如果是，则进一步判断该Bean的color属性是否为空；如果为空，则将该属性设置为“黑色”。在postProcessAfterInitialization()方法中，仅对名为car的Bean进行处理，判断其maxSpeed是否超过最大速度200，如果超过，则将其设置为200。

至于如何将MyInstantiationAwareBeanPostProcessor和MyBeanPostProcessor这两个处理器注册到BeanFactory容器中，请参看代码清单4-32：

~~~xml
<bean id="car" class="com.smart.Car"
      init-method="myInit"
      destroy-method="myDestroy"
      p:brand="红旗CA72"
      p:maxSpeed="200"/>
~~~

通过init-method指定Car的初始化方法为myInit();通过destroy-method指定Car的销毁方法为myDestroy(); 同时通过scope定义了Car的作用范围（关于Bean作用范围的详细讨论，请参见5.8节）。

下面让容器装载配置文件，然后分别注册上面所提供的两个后处理器，如代码清单4-33所示：

~~~java
package com.smart.beanfactory;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.beans.factory.xml.xmlBeanFactory;
import org.springframework.beans.core.io.ClassPathResource;
import org.springframework.beans.core.io.Resource;
import com.smart.Car;

public class BeanLifeCycle{
    private static void LifeCycleInBeanFactory(){
        // ①下面两句装载配置文件并启动容器
        Resource res = new ClassPathResource("com/smart/beanfactory/beans.xml");
        
        BeanFactory bf = new DefaultListableBeanFactory();
        XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader((DefaultListableBeanFactory)bf);
        reader.loadBeanDefinitions(res);
        
        // ②向容器中注册MyBeanPostProcessor后处理器
        ((ConfigurableBeanFactory)bf).addBeanPostProcessor(new MyBeanPostProcessor());
        
        // ③向容器中注册MyInstantiationAwareBeanPostProcessor后处理器
        ((ConfigurableBeanFactory)bf).addBeanPostProcessor(new MyInstantiationAwareBeanPostProcessor());
        
        // ④第一次从容器中获取car，将触发容器实例化该Bean，这将引发Bean生命周期方法的调用
        Car car1 = (Car)bf.getBean("car");
        car1.introduce();
        car1.setColor("红色");
        
        // ⑤第二次从容器中获取car，直接从缓存池中获取
        Car car = (Car)bf.getBean("car");
        
        // ⑥查看car1和car2是否指向同一引用
        System.out.println("car1==car2:"+(car1==car2));
        
        // ⑦关闭容器
        ((DefaultListableBeanFactory)bf).destroySingletons();
    }
    
    public static void main(String[] args){
        LifeCycleInBeanFactory();
    }
}
~~~

在①处，装载了配置文件并启动容器。在②处，向容器中注册了MyBeanPostProcessor后处理器，注意对BeanFactory类型的bf变量进行了强制类型转换，因为用于注册后处理器的addBeanPostProcessor()方法是在ConfigurableBeanFactory接口中定义的。如果有多个后处理器，则可以按照相似的方式调用addBeanPostProcessor()方法进行注册。需要强调的是，后处理器的实际调用顺序和注册顺序是无关的，在具有多个后处理器的情况下，必须通过实现的org.springframework.core.Ordered接口来确定调用顺序。

在③处，按照注册MyBeanPostProcessor后处理器相同的方法注册MyInstantiationAwareBeanPostProcessor后处理器，Spring容器会自动检查后处理器是否实现了InstantiationAwareBeanPostProcessor接口，并据此判断后处理器的类型。

在④处，第一次从容器中获取car Bean，容器将按[图4-11](#graph4-11)中描述的Bean生命周期过程，实例化Car并将其放入缓存池中，然后再将这个Bean引用返回给调用者。在⑤处，再次从容器中获取car Bean，Bean将从容器缓存池中直接取出，不会引发生命周期相关方法的执行。如果Bean的作用范围定义为scope="prototype"，则第二次getBean()时，生命周期方法会再次被调用，因为prototype范围的Bean每次都返回新的实例。在⑥处，检验car1和car2是否指向相同的对象。

运行BeanLifeCycle，在控制台得到以下输出信息：

~~~
InstantiationAwareBeanPostProcessor.postProcessorBeforeInstantiation
调用Car()构造函数。
InstantiationAwareBeanPostProcessor.postProcessorAfterInstantiation
InstantiationAwareBeanPostProcessor.postProcessorPropertyValues
调用setBrand()设置属性。
调用BeanNameAware.setBeanName()。
调用BeanFactoryAware.setBeanFactory()。
调用BeanPostProcessor.postProcessBeforeInitialization(), color为空，设置为默认黑色。
调用InitializingBean.afterPropertiesSet()。
调用myInit()，将maxSpeed设置为240。
调用BeanPostProcessor.postProcessAfterInitialization(),将maxSpeed调整为200。
brand:奇瑞QQ;color:黑色;maxSpeed:200
brand:奇瑞QQ;color:红色;maxSpeed:200
2016-01-03 15:47:10,640 INFO [main] (DefaultSingletonBeanRegistry.java:272) - Destroying singletons in (org.springframework.beans.factory.xml.XmlBeanFactory defining beans [car]; root of BeanFactory hierarchy)
调用DisposableBean.destroy()。
调用myDestroy()。
~~~

仔细观察输出的信息，发现其验证了前面所介绍的Bean生命周期的完整过程。在⑦处，通过destroySingletons()方法关闭了容器，由于Car实现了销毁接口并指定了销毁方法，所以容器将触发调用这两个方法。

#### 3、关于Bean生命周期接口的探讨

通过实现Spring的Bean生命周期接口对Bean进行额外控制，虽然让Bean具有了更细致的生命周期阶段，但也带来了一个问题：Bean和Spring框架紧密地绑定在一起，这和Spring一直推崇的“不对应用程序类作任何限制”的理念是相悖的。因此，如果用户希望将业务类完全POJO化，则可以只实现自己的业务接口，不需要和某个特定框架（包括Spring框架）的接口关联。可以通过`<bean>`的init-method和destroy-method属性配置方式为Bean指定初始化和销毁的方法，采用这种方式对Bean生命周期的控制效果和通过实现InitializingBean和DisposableBean接口所达到的效果是完全不同的。采用前者的配置方式可以使Bean不需要和特定的Spring框架接口绑定，达到了框架解耦的目的。此外，Spring还拥有一个Bean后置处理器initDestroyAnnotationBeanPostProcessor，它负责对标注了@PostConstruct、@PreDestroy的Bean进行处理，在Bean初始化后及销毁前执行相应的逻辑。喜欢注解的读者，可以通过InitDestroyAnnotationBeanPostProcessor达到和以上两种方式相同的效果（如果在ApplicationContext中，则已经默认装配了该处理器）。

对于BeanFactoryAware和BeanNameAware接口，前者让Bean感知容器（BeanFactory实例），而后者让Bean获得配置文件中对应的配置名称。一般情况下，用户几乎不需要关心这两个接口。如果Bean希望获取容器中的其他Bean，则可以通过属性注入的方式引用这些Bean；如果Bean希望在运行期获知在配置文件中的Bean名称，则可以简单地将名称作为属性注入。

综上所述，我们认为，除非编写一个基于Spring之上的扩展插件或子项目之类的东西，否则用户完全可以抛开以上4个Bean生命周期的接口类，使用更好的方案替代之。

但BeanPostProcessor接口却不一样，它不要求Bean去继承它，可以完全像插件一样注册到Spring容器中，为容器提供额外的功能。Spring容器充分利用了BeanPostProcessor对Bean进行加工处理，当我们讲到Spring的AOP功能时，还会对此进行分析，了解BeanPostProcessor对Bean的影响，对于深入理解Spring核心功能的工作机理将会有很大的帮助。很多Spring扩展插件或Spring子项目都是使用这些后处理器完成激动人心的功能的。

### 4.5.2 ApplicationContext中Bean的生命周期

Bean在应用上下文中的生命周期和在BeanFactory中的生命周期类似，不同的是，如果Bean实现了org.springframework.context.ApplicationContextAware接口，则会增加一个调用该接口方法setApplicationContext()的步骤，如图4-12所示。

~~~mermaid
graph TB
start(( ))--启动容器-->postProcessBeanFatory(调用BeanFactoryPostProcessor的postProcessBeanFactory方法对工厂定义信息进行后处理)
postProcessBeanFatory--通过getBean调用某一个Bean-->postProcessBeforeInstantiation(*调用InstantiationAwareBeanPostProcessor的postProcessBeforeInstantiation方法)
postProcessBeforeInstantiation-->实例化
实例化-->postProcessAfterInstantiation(*调用InstantiationAwareBeanPostProcessor的postProcessBeforeInstantiation方法)
postProcessAfterInstantiation-->postProcessPropertyValues(*调用InstantiationAwareBeanPostProcessor的postProcessPropertyValues方法)
postProcessPropertyValues-->设置属性值
设置属性值-->setBeanName(调用BeanNameAware的setBeanName方法)
setBeanName-->setBeanFactory(调用BeanFactoryAware的setBeanFactory方法)
setBeanFactory-->setApplicationContext(调用ApplicationContextAware的setApplicationContext方法)
setApplicationContext-->postProcessBeforeInitialization(*调用BeanPostProcessor的postProcessBeforeInitialization方法)
postProcessBeforeInitialization-->afterPropertiesSet(调用InitializingBean的afterPropertiesSet方法)
afterPropertiesSet-->init-method(通过init-method属性配置的初始化方法)
init-method--singleton-->缓冲池Bean((Spring缓存池中准备就绪的Bean))
init-method--prototype-->调用者Bean((将准备就绪的Bean交给调用者))
缓冲池Bean--容器销毁-->destroy(调用DisposableBean的destroy方法)
destroy-->destroy-method(通过destroy-method属性配置的销毁方法)
destroy-method-->stop(( ))
style 调用者Bean stroke:#f66,stroke-width:2px,stroke-dasharray: 5, 5
~~~

此外，如果在配置文件中声明了工厂后处理器接口BeanFactoryPostProcessor的实现类，则应用上下文在装载配置文件之后、初始化Bean实例之前将调用这些BeanFactoryPostProcessor对配置信息进行加工处理。Spring框架提供了多个工厂后处理器，如CustomEditorConfigurer、PropertyPlaceholderConfigurer等，我们将在第5章中详细介绍它们的功用。如果在配置文件中定义了多个工厂后处理器，那么最好让它们实现org.springframework.core.Ordered接口，以便Spring以确定的顺序调用它们。工厂后处理器是容器级的，仅在应用上下文初始化时调用一次，其目的是完成一些配置文件的加工处理工作。

ApplicationContext和BeanFactory另一个最大的不同之处在于：前者会利用Java反射机制自动识别出配置文件中定义的BeanPostProcessor、InstantiationAwareBeanPostProcessor和BeanFactoryPostProcessor，并自动将它们注册到应用上下文中；而后者需要在代码中通过手工调用addBeanPostProcessor()方法进行注册。这也是为什么在应用开发时普遍使用ApplicationContext而很少使用BeanFactory的原因之一。

在ApplicationContext中，只需在配置文件中通过`<bean>`定义工厂后处理器和Bean后处理器，它们就会按预期的方式运行。

来看一个使用工厂后处理器的实例。假设我们希望对配置文件中car的brand配置属性进行调整，则可以编写一个如代码清单4-34所示的工厂后处理器。

~~~java
package com.smart.context;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import com.smart.Car;

public class MyBeanFactoryPostProcessor implements BeanFactoryPostProcessor {
    // ①对car <bean>的brand属性配置信息进行“偷梁换柱”的加工操作
    public void postProcessBeanFactory(ConfigurableListableBeanFactory bf) throws BeansException {
        BeanDefinition bd = bf.getBeanDefinition("car");
        
        bd.getPropertyValues().addPropertyValue("brand", "奇瑞QQ");
        System.out.println("调用BeanFactoryPostProcessor.postProcessBeanFactory()!");
    }
}
~~~

ApplicationContext在启动时，将首先为配置文件中的每个`<bean>`生成一个BeanDefinition对象，BeanDefinition是`<bean>`在Spring容器中的内部表示。当配置文件中所有的`<bean>`都被解析成BeanDefinition时，ApplicationContext将调用工厂后处理器的方法，因此，我们有机会通过程序的方式调整Bean的配置信息。在这里，我们将car对应的BeanDefinition进行调整，将brand属性设置为"奇瑞QQ"，具体配置如代码清单4-35所示

~~~xml
<!--①这个brand属性的值将被工厂后处理器更改掉-->
<bean id="car" class="com.smart.Car" init-method="myInit" destroy-method="myDestroy"
      p:brand="红旗CA72"
      p:maxSpeed="200"/>
<!--②工厂后处理器-->
<bean id="myBeanPostProcessor"
      class="com.smart.context.MyBeanPostProcessor"/>
<!--③注册Bean后处理器-->
<bean id="myBeanFactoryPostProcessor"
      class="com.smart.context.MyBeanFactoryPostProcessor"/>
~~~

在②和③处定义的BeanPostProcessor和BeanFactoryPostProcessor会自动被ApplicationContext识别并注册到容器中。在②处注册的工厂后处理器将会对在①处配置的属性值进行调整。在③处还声明了一个Bean后处理器，它也可以对Bean的属性进行调整。启动容器并查看car Bean的信息，将发现car Bean的brand属性成功被工厂后处理器更改了。

## 4.6 小结

# 第5章 在IoC容器中装配Bean

## 5.1 Spring配置概述

### 5.1.1 Spring容器高层视图

要使应用程序中的Spring容器成功启动，需要同时具备以下三方面的条件：

- Spring框架的类包都已经放到应用程序的类路径下。
- 应用程序为Spring提供了完备的Bean配置信息。
- Bean的类都已经放到应用程序的类路径下。

Spring启动时读取应用程序提供的Bean配置信息，并在Spring容器中生成一份响应的Spring配置注册表，然后根据这张注册表实例化Bean，装配好Bean之间的依赖关系，为上层应用提供准备就绪的运行环境。

Bean配置信息是Bean的元数据信息，它由以下4个方面组成：

- Bean的实现类。
- Bean的属性信息，如数据源的连接数、用户名、密码等。
- Bean的依赖关系，Spring根据依赖关系配置完成Bean之间的装配。
- Bean的行为配置，如生命周期范围及生命周期各过程的回调函数等。

Bean元数据信息在Spring容器中的内部对应物是由一个个BeanDefinition形成的Bean注册表，Spring实现了Bean元数据信息内部表示和外部定义的解耦。Spring支持多种形式的Bean配置方式。Spring1.0仅支持基于XML的配置，Spring2.0新增基于注解配置的支持，Spring3.0新增基于Java类配置的支持，而Spring4.0则新增基于Groovy动态语言配置的支持。

Bean配置信息首先定义了Bean的实现及依赖关系，Spring容器根据各种形式的Bean配置信息在容器内建立Bean定义注册表；然后根据注册表加载、实例化Bean，并建立Bean和Bean之间的依赖关系；最后将这些准备就绪的Bean放到Bean缓存池中，以供外层的应用程序进行调用。

### 5.1.2 基于XML的配置

对于基于XML的配置，Spring1.0的配置文件采用DTD格式，Spring2.0以后采用Schema格式，后者让不同类型的配置拥有了自己的命名空间，使得配置文件更具扩展性。此外，Spring基于Schema配置方案为许多领域的问题提供了简化的配置方法，配置工作因此得到了大幅简化。

## 5.2 Bean基本配置

### 5.2.1 装配一个Bean

### 5.2.2 Bean的命名

一般情况下，在配置一个Bean时，需要为其指定一个id属性作为Bean的名称。id在IoC容器中必须是唯一的，而且id的命名需要满足XML对id的命名规范（id是XML规定的特殊属性）：必须以字母开始，后面可以是字母、数字、连字符、下划线、句号、冒号等完整结束（full stops）的符号，逗号和空格这些非完整结束符是非法的。在实际情况下，id命名约束并不会给用户带来影响，但如果用户确实希望用一些特殊字符进行Bean命名，则可以使用`<bean>`的name属性。name属性没有字符上的限制，几乎可以使用任何字符，如`?ab`、`123`等。

id和name都可以指定多个名字，名字之间可用逗号、分号或者空格进行分隔。

Spring配置文件不允许出现两个相同id的`<bean>`，但却可以出现两个相同name的`<bean>`。如果有多个name相同的`<bean>`，那么通过getBean(beanName)获取Bean时，将返回后面声明的那个Bean，原因是后面的Bean覆盖了前面同名的Bean。所以为了避免无意间Bean覆盖的隐患，尽量使用id而非name命名Bean。

如果id和name两个属性都未指定，那么Spring自动将全限定类名作为Bean的名称，这时用户可以通过`getBean("com.smart.simple.Car")`获取car Bean。如果存在多个实现类相同的匿名`<bean>`,如下：

~~~xml
<bean class="com.smart.simple.Car"/>
<bean class="com.smart.simple.Car"/>
<bean class="com.smart.simple.Car"/>
~~~

第一个Bean通过`getBean("com.smart.simple.Car")`获得；第二个Bean通过`getBean("com.smart.simple.Car#1")`获得；第三个Bean通过`getBean("com.smart.simple.Car#3")`获得，以此类推。一般匿名`<bean>`在内部Bean为外层Bean提供注入值时使用，正如Java匿名类一样。

> 提示： 各种眼花缭乱、花拳绣腿式的命名方式着实让我们见识了Spring配置的灵活性和包容性，但在一般情况下，那些奇怪的命名大多是唬人的噱头，不值得在实际项目中使用，通过id为Bean指定唯一的名称才是“康庄大道”。

## 5.3 依赖注入

Spring支持两种依赖注入方式，分别是属性注入和构造函数注入。除此之外，Spring还支持工厂方法注入方式。

### 5.3.1 属性注入

属性注入指通过setXxx()方法注入Bean的属性值或依赖对象。由于属性注入方式具有可选择性和灵活性高的特点，因此属性注入是实际应用中最常采用的注入方式。

#### 1. 属性注入实例

属性注入要求Bean提供一个默认的构造函数，并为需要注入的属性提供对应的setter方法。Spring先调用Bean的默认构造函数实例化Bean对象，然后通过反射的方式调用Setter方法注入属性值。

> 提示：默认构造函数是不带参的构造函数。Java语言规定，如果类中没有定义任何构造函数，则JVM会自动为其生成一个默认的构造函数；反之，如果类中显式定义了构造函数，则JVM不会为其生成默认的构造函数。所以假设Car类中显式定义了一个带参的构造函数，如public Car(String brand)，则需要同时提供一个默认的构造函数public Car()，否则使用属性注入时将抛出异常。

需要指出的是，Spring只会检查Bean是否有对应的Setter方法，至于Bean中是否有对应的属性成员变更则不做要求。举个例子，配置文件中`<property name="brand">`的属性配置项仅要求Car类中拥有setBrand()方法，但Car类不一定要拥有brand成员变量。

虽然如此，但在一般情况下，仍然按照约定俗成的方式在Bean中提供同名的属性变量。

#### 2. JavaBean关于属性命名的特殊规范

Spring配置文件中`<property>`元素所指定的属性名和Bean实现类的Setter实现类的Setter方法满足Sun JavaBean的属性命名规范：xxx的属性对应setXxx()方法。

一般情况下，Java的属性变量名都以小写字母开头，如maxSpeed、brand等，但也存在特殊情况。考虑到一些特定意义的大写英文缩略词（如USA、XML等），JavaBean也允许以大写字母开头的属性变量名，不过必须满足“变量的前两个字母要么全部大写，要么全部小写”的要求，如brand、IDCode、IC、ICCard等属性变量名是合法的，而iC、iCcard、iDCode等属性变量名则是非法的。这个并不广为人知的JavaBean规范条款引发了让人困惑的配置问题。

为了更清楚地理解这个隐晦地问题，我们来看一个具体的实例。下面是一个“违反”了JavaBean属性命名规范的类：

~~~java
public class Foo {
    // ①非法的属性变量名，不过Java语言本身不会报错，因为它将iDCode看成普通的变量
    private String iDCode;
    
    // ②该Setter方法对应IDCode属性而非iDCode属性
    public void setIDCode(String iDcode){
        this.iDCode = iDcode;
    }
}
~~~

在Spring配置文件中，我们可能会想当然地为Foo提供以下配置：

~~~xml
<bean id="foo" class="com.smart.attr.Foo">
	<!--①这个属性变量名是非法的！！-->
    <property name="iDCode" value="070101"/>
</bean>
~~~

当我们试图启动Spring容器时，将会得到启动失败的结果，控制台输出如下错误信息：

~~~
Error setting property values; 
nested exception is org.springframework.beans.NotWritablePropertyException: Invalid property 'iDCode' of bean class [com.smart.attr.Foo]: Bean property 'iDCode' is not writable or has an invalid Setter method. Did you mean 'IDCode'?
Caused by: org.springframework.beans.NotWritablePropertyException: Invalid property 'iDCode' of bean class
~~~

虽然Spring给出了启动失败的原因，但错误信息具有很强的误导性，因为它“抱怨”Foo中没有提供对应于iDCode的Setter方法，但事实上Foo已经提供了setIDCode()方法。那真相到底是什么呢？其实真正的错误根源是我们在Spring配置文件中指定了一个非法的属性名iDcode，这个非法的属性名永远不可能有对应的Setter方法，因此错误就产生了。

纠正的办法是将配置文件中的属性名改为IDCode，如下：

~~~xml
<bean id="foo" class="com.smart.attr.Foo">
	<!--①IDCode对应setIDCode()属性设置方法-->
    <property name="IDCode" value="070101"/>
</bean>
~~~

Foo类中的iDCode属性变量名不一定要修改，因为我们说过，Spring配置文件的属性名仅对应于Bean实现类的get/setXxx()方法。但是如果进一步探讨引发这个配置错误的根源，我们就会归咎于Foo类中iDCode的变量名。原因很简单，因为我们在编写了Foo的iDCode变量名后，通过IDE的代码自动完成功能生成setIDCode()属性设置方法，然后想当然地在Spring配置文件中使用iDCode属性名进行配置，最终造成了Spring启动器的启动错误。

以大写字母开头的变量名总显得比较另类，为了避免这类诡异的错误，用户可以遵照以下的编程经验：像QQ、MSN、ID等正常情况下以大写字母出现的专业术语，在Java中一律将其调整为小写形式，如qq、msn、id等，以保证命名的统一性（变量名都以小写字母开头），减少出现错误的概率。

### 5.3.2 构造函数注入

构造函数注入是除属性注入外的另一种常用的注入方式，它保证一些必要的属性在Bean实例化时就得到设置，确保Bean在实例化后就可以使用。

#### 1. 按类型匹配入参

如果任何可用的Car对象都必须提供brand和price的值，若使用属性注入方式，则只能人为地在配置时提供保证而无法在语法级提供保证，这时通过构造函数注入就可以很好地满足这一要求。使用构造函数注入的前提是Bean必须提供带参的构造函数。下面为Car提供一个可设置brand和price属性的构造函数。

~~~java
package com.smart.ditype
public class Car {
    ...
    public Car(String brand, double price) {
        this.brand = brand;
        this.price = price;
    }
}
~~~

构造函数注入的配置方式和属性注入的配置方式有所不同，下面在Spring配置文件中使用构造函数注入的配置方式装配这个car Bean，如代码清单5-3所示：

~~~xml
<bean id="car1" class="com.smart.ditype.Car">
	<constructor-arg type="java.lang.String"> <!--①-->
    	<value>红旗CA72</value>
    </constructor-arg>
    <constructor-arg type="double"> <!--②-->
    	<value>20000</value>
    </constructor-arg>
</bean>
~~~

在`<constructor-arg>`的元素中有一个type属性，它为Spring提供了判断配置项和构造函数入参对应关系的“信息”。细心的读者可能会提出以下疑问：配置文件中`<bean>`元素的`<constructor-arg>`声明顺序难道不能用于确定构造函数入参的顺序吗？在只有一个构造函数的情况下当然是可以的，但如果在Car中定义了多个具有相同入参的构造函数，这种顺序标识方法就失效了。此外，Spring的配置文件采用和元素标签顺序无关的策略，这种策略可以在一定程度上保证配置信息的确定性，避免一些似是而非的问题。因此，①和②处的`<constructor-arg>`位置并不会对最终配置效果产生影响。

#### 2. 按索引匹配入参

如果构造函数有两个类型相同的入参，那么仅通过type就无法确定对应关系了，这时需要通过入参索引的方式进行确定。

> 提示：
>
> 我们知道，在属性注入时，Spring按JavaBean规范找到配置属性所对应的Setter方法，并使用Java反射机制调用Setter方法完成属性注入。但Java反射机制并不会记住构造函数的入参名，因此我们无法通过指定构造函数的入参名进行构造函数注入的配置，只能通过入参类型和索引信息间接确定构造函数配置项和入参的对应关系。

为了更好地演示按索引匹配入参的配置方式，我们特意对Car构造函数进行了一下调整：

~~~java
// ①该构造函数第一、第二入参都是String类型
public Car(String brand, String corp, double price) {
    this.brand = brand;
    this.corp = corp;
    this.price = price;
}
~~~

因为brand和corp的入参类型都是String，所以String无法确定type为String的`<constructor-arg>`到底对应的是brand还是corp。但是通过显式指定参数的索引能够消除这种不确定性。

~~~xml
<bean id="car2" class="com.smart.ditype.Car">
    <!-- ①注意索引从0开始 -->
    <constructor-arg index="0" value="红旗CA72"/>
    <constructor-arg index="1" value="中国一汽"/>
    <constructor-arg index="2" value="20000"/>
</bean>
~~~

构造函数的第一个参数索引为0，第二个为1，以此类推。

#### 3. 联合使用类型和索引匹配入参

~~~java
...
public Car(String brand, String corp, double price) {
    this.brand = brand;
    this.corp = corp;
    this.price = price;
}
public Car(String brand, String corp, int maxSpeed) {
    this.brand = brand;
    this.corp = corp;
    this.maxSpeed = maxSpeed;
}
...
~~~

~~~xml
<!-- ①对应Car(String brand, String corp, int maxSpeed)构造函数 -->
<bean id="car3" class="com.smart.ditype.Car">
    <constructor-arg index="0" type="java.lang.String">
        <value>红旗CA72</value>
    </constructor-arg>
    <constructor-arg index="1" type="java.lang.String">
        <value>中国一汽</value>
    </constructor-arg>
    <constructor-arg index="2" type="int">
        <value>200</value>
    </constructor-arg>
</bean>
~~~

真正引起歧义的地方是第三个入参，因此仅需要明确指定第三个入参的类型就可以取消歧义。所以在代码清单5-6中，第一、第二个`<constructor-arg>`元素的type属性可以去除。

对于因参数数目相同而类型不同引起的潜在配置歧义问题，Spring容器可以正确启动且不会给出报错信息，它将随机采用一个匹配的构造函数实例化Bean，而被选择的构造函数可能并不是用户所期望的那个。因此，必须特别谨慎，以避免潜在的错误。

#### 4. 通过自身类型反射匹配入参

当然，如果Bean构造函数入参的类型是可识别的（非基础数据类型且入参类型各异），由于Java反射机制可以获取构造函数入参的类型，即使构造函数注入的配置不提供类型和索引的信息，Spring依旧可以正确地完成构造函数的注入工作。下面Boss类构造函数的入参就是可辩别的。

~~~java
public Boss(String name, Car car, Office office){
    this.name = name;
    this.car = car;
    this.office = office;
}
~~~

~~~xml
<bean id="boss" class="com.smart.ditype.Boss">
	<!--①没有设置type和index属性，通过入参值的类型完成匹配映射-->
    <constructor-arg>
    	<value>John</value>
    </constructor-arg>
    <constructor-arg>
    	<ref bean="car"/>
    </constructor-arg>
    <constructor-arg>
    	<ref bean="office"/>
    </constructor-arg>
</bean>
<bean id="car" class="com.smart.ditype.Car"/>
<bean id="office" class="com.smart.ditype.Office"/>
~~~

但是为了避免潜在配置歧义引起的张冠李戴的情况，如果Bean存在多个构造函数，那么使用显式指定index和type属性不失为一种良好的配置习惯。

#### 5. 循环依赖问题

Spring容器能对构造函数配置的Bean进行实例化有一个前提，即Bean构造函数入参引用的对象必须已经准备就绪。由于这个机制的限制，如果两个Bean都采用构造函数注入，而且都通过构造函数入参引用对方，就会发生类似于线程死锁的循环依赖问题。来看一个发生循环依赖问题的例子：

~~~java
public class Car {
    ...
    // ①构造函数依赖于一个boss实例
    public Car(String brand, Boss boss) {
        this.brand = brand;
        this.boss = boss;
    }
    ...
}

public class Boss {
    ...
    // ②构造函数依赖于一个car实例
    public Boss(String name, Car car){
        this.name = name;
        this.car = car;
    }
    ...
}
~~~

假设在Spring配置文件中按照以下构造函数注入方式进行配置：

~~~xml
<bean id="car" class="com.smart.cons.Car">
	<constructor-arg index="0" value="红旗CA72"/>
    <!--①引用②处的boss-->
    <constructor-arg index="1" ref="boss"/>
</bean>
<bean id="boss" class="com.smart.cons.Boss">
	<constructor-arg index="0" value="John"/>
    <!--②引用①处的car-->
    <constructor-arg index="1" ref="car"/>
</bean>
~~~

当启动Spring IoC容器时，因为存在循环依赖问题，Spring容器将无法成功启动。如何解决这个问题呢？用户只需修改Bean的代码，将构造函数注入方式调整为属性注入方式就可以了。

### 5.3.3 工厂方法注入

工厂方法是在应用中被经常使用的设计模式，它也是控制反转和单实例设计思想的主要实现方法。由于Spring IoC容器以框架的方式提供工厂方法的功能，并以透明的方式开放给开发者，所以很少需要手工编写基于工厂方法的类。正是因为工厂方法已经成为底层设施的一部分，因此工厂方法对于实际编码的重要性就降低了。不过在一些遗留系统或第三方类库中，我们还会遇到工厂方法，这时可以使用Spring工厂方法注入的方式进行配置。

#### 1. 非静态工厂方法

有些工厂方法是非静态的，即必须实例化工厂类后才能调用工厂方法。下面为Car提供一个非静态的工厂类，如代码清单5-7所示。

~~~java
package com.smart.ditype;
public class CarFactory {
    // ①创建Car的工厂方法
    public Car createHongQiCar() {
        Car car = new Car();
        car.setBrand("红旗CA72");
        return car;
    }
}
~~~

工厂类负责创建一个或多个目标类实例，工厂类方法一般以接口或抽象类变量的形式返回目标类实例。工厂类对外屏蔽了目标类的实例化步骤，调用者甚至无须知道具体的目标类是什么。在代码清单5-7中，CarFactory工厂类仅负责创建Car类型的对象，下面的配置片段使用CarFactory为Car提供工厂方法的注入，如代码清单5-8所示。

~~~xml
...
<!-- ①工厂类Bean -->
<bean id="carFactory" class="com.smart.ditype.CarFactory"/>

<!-- factory-bean 指定①处的工厂类Bean；factory-method 指定工厂类Bean创建该Bean的工厂方法 -->
<bean id="car5" factory-bean="carFactory" factory-method="createHongQiCar"/>
~~~

由于CarFactory工厂类的工厂方法不是静态的，所以首先需要定义一个工厂类的Bean，然后通过factory-bean引用工厂类实例，最后通过factory-method指定对应的工厂类方法。

#### 2. 静态工厂方法

很多工厂类方法都是静态的，这意味着用户在无须创建工厂类实例的情况下就可以调用工厂类方法，因此，静态工厂方法比非静态工厂方法更易使用。下面对CarFactory进行改造，将其createHongQiCar()方法调整为静态的，如代码清单5-9所示。

~~~java
package com.smart.ditype;
public class CarFactory {
    // ①工厂类方法是静态的
    public static Car createHongQiCar(){
        ...
    }
}
~~~

当使用静态工厂类型的方法后，用户就无需在配置文件中定义工厂类的Bean，只需按以下方式进行配置即可：

~~~xml
<bean id="car6" class="com.smart.ditype.CarFactory" factory-method="createCar"/>
~~~

直接在bean中通过class属性指定工厂类，然后再通过factory-method指定对应的工厂方法。

### 5.3.4 选择注入方式的考量

Spring提供了3种可供选择的注入方式，在实际应用中，究竟应该选择哪种注入方式呢？对于这个问题，仁者见仁，智者见智，并没有统一的标准。下面是支持使用构造函数注入的理由：

- 构造函数可以保证一些重要的属性在Bena实例化时就设置好，避免因为一些重要属性没有提供而导致一个无用Bean实例的情况。
- 不需要为每个属性提供Setter方法，减少了类的方法个数。
- 可以更好地封装类变量，不需要为每个属性指定Setter方法，避免外部错误的调用。

更多的开发者可能倾向于使用属性注入方式，他们反对构造函数注入的理由如下：

- 如果一个类的属性众多，那么构造函数的签名将变成一个庞然大物，可读性很差。
- 灵活性不强，在有些属性是可选的情况下，如果通过构造函数注入，也需要为可选的参数提供一个null值。
- 如果有多个构造函数，则需要考虑配置文件和具体构造函数匹配歧义的问题，配置上相对复杂。
- 构造函数不利于类的继承和扩展，因为子类需要引用父类复杂的构造函数。
- 构造函数注入有时会造成循环依赖的问题。

其实构造函数注入和属性注入各有自己的应用场景，Spring并没有强制用户使用哪一种方式，用户完全可以根据个人偏好做出选择，在某些情况下使用构造函数注入，而在另一些情况下使用属性注入。对于一个全新开发的应用来说，我们不推荐使用工厂方法的注入方式，因为工厂方法需要额外的类和代码，这些功能和业务是没有关系的，既然Spring容器已经以一种更优雅的方式实现了传统工厂模式的所有功能，那么我们大可不必再去做这项重复性的工作。

## 5.4 注入参数详解

在Spring配置文件中，用户不但可以将String，int等字面值注入Bean中，此外还可以将集合、Map等类型的数据注入Bean中，此外还可以注入配置文件中其他定义的Bean。

### 5.4.1 字面值

所谓“字面值”一般是指可用字符串表示的值，这些值可以通过`<value>`元素标签进行注入。在默认情况下，基本数据类型及其封装类、String等类型都可以采取字面值注入的方式。Spring容器在内部为字面值提供了编辑器，它可以将以字符串表示的字面值转换为内部变量的相应类型。Spring允许用户注册自定义的编辑器，以处理其他类型属性注入时的转换工作（关于自定义编辑器的内容，请参见第6章）。

在下面的示例中，我们为Car注入了两个属性值，并在Spring配置文件中使用字面值提供配置值，如代码清单5-10所示。

~~~xml
<bean id="car" class="com.smart.attr.Car">
	<property name="maxSpeed">
    	<value>200</value>
    </property>
    <property name="brand">
    	<value><![CDATA[红旗&CA72]]></value>
    </property>
</bean>
~~~

由于①处的brand属性包含一个XML的特殊符号，因此我们特意在属性值外添加了一个XML特殊标签`<![CDTA[]]>`。`<![CDTA[]]>`的作用是让XML解析器将标签中的字符串当作普通的文本对待，以防止特殊字符串对XML格式造成破坏。

XML中共有5个特殊的字符，分别是`&`、`<`、`>`、`"`、`'`。如果配置文件中的注入值包括这些特殊字符，就需要进行特别处理。有两种解决方法：其一，采用本例中的特殊标签`<![CDTA[]]>`，将包含特殊字符的字符串封装起来；其二，使用XML转移序列表示这些特殊字符，这5个特殊字符所对应的XML转义序列在表5-2中进行了说明。

| 特殊符号 | 转义序列 |
| -------- | -------- |
| <        | `&lt;`   |
| >        | `&gt;`   |
| &        | `&amp;`  |
| "        | `&quot;` |
| '        | `&apos;` |

如果使用XML转义序列，则可以使用以下配置替换代码清单5-10中的配置。

~~~xml
<property name="brand">
	<value>红旗&amp;CA72</value>
</property>
~~~

> 提示：
>
> 一般情况下，XML解析器会忽略标签内部字符串的前后空格，但Spring却不会忽略元素标签内部字符串的前后空格。Spring会将字符串连同其前后空格一起赋给brand属性。

### 5.4.2 引用其他Bean

Spring IoC容器中定义的Bean可以相互引用，IoC容器则充当“红娘”的角色。下面创建一个新的Boss类，Boss类中拥有一个Car类型的属性。

~~~java
package com.smart.attr;
public class Boss {
    private Car car;
    // ①设置car属性
    public void setCar(Car car) {
        this.car = car;
    }
    ...
}
~~~

boss的Bean通过`<ref>`元素引用car Bean，建立起boss对car的依赖。

~~~xml
<!-- ①car Bean -->
<bean id="car" class="com.smart.attr.Car"/>
<bean id="boss" class="com.smart.attr.Boss">
	<property name="car">
    	<!-- ②引用①处定义的car Bean -->
        <ref bean="car"></ref>
    </property>
</bean>
~~~

`<ref>`元素可以通过以下3个属性引用容器中的其他Bean。

- bean：通过该属性可以引用同一容器或父容器中的Bean，这是最常见的形式。
- local：通过该属性只能引用同一配置文件中定义的Bean，它可以利用XML解析器自动检验引用的合法性，以便开发人员在编写配置时能够及时发现并纠正配置错误。
- parent：引用父容器中的Bean，如`<ref parent="car">`的配置说明car的Bean是父容器中的Bean。

下面是分别使用父、子容器加载beans1.xml和beans2.xml配置文件的代码：

~~~java
// ①父容器
ClassPathXmlApplicationContext pFactory = new ClassPathXmlApplicationContext(new String[]{"com/smart/attr/beans1.xml"});
// ②指定pFactory为该容器的父容器
ApplicationContext factory = new ClassPathXmlApplicationContext(new String[]{"com/smart/attr/beans2.xml"}, pFactory);
Boss boss = (Boss)factory.getBean("boss");
System.out.println(boss.getCar().toString());
~~~

### 5.4.3 内部Bean

如果car Bean只被boss Bean引用，而不被容器中任何其他的Bean引用，则可以将car以内部Bean的方式注入Boss中。

~~~xml
<bean id="boss" class="com.smart.attr.Boss">
	<property name="car">
    	<bean class="com.smart.attr.Car">
        	<property name="maxSpeed" value="200"/>
            <property name="price" value="2000.00"/>
        </bean>
    </property>
</bean>
~~~

内部Bean和Java的匿名内部类相似，既没有名字，也不能被其他Bean引用，只能在声明处为外部Bean提供实例注入。

内部Bean即使提供了id、name、scope属性，也会被忽略，scope默认为prototype类型。关于Bean的作用域，将在5.8节进行详细介绍。

### 5.4.4 null值

Spring会将`<value></value>`解析为空字符串。必须使用专用的`<null/>`元素标签，通过它可以为Bean的字符串或其他对象类型的属性注入null值。

~~~xml
<property name="brand"><null/></property>
~~~

上面的配置代码等同于调用car.setBrand(null)方法。

### 5.4.5 级联属性

和Struts、Hibernate等框架一样，Spring支持级联属性的配置。假设我们希望在定义Boss时直接为Car的属性提供注入值，则可以采取以下配置方式：

~~~xml
<bean id="boss3" class="com.smart.attr.Boss">
	<!-- ①以圆点(.)的方式定义级别属性 -->
    <property name="car.brand" value="吉利CT50"/>
</bean>
~~~

按照上面的配置，Spring将调用`Boss.getCar().setBrand("吉利CT50")`方法进行属性的注入操作。这时必须对Boss类进行改造，为car属性声明一个初始化对象。

~~~java
public class Boss {
    // ①声明初始化对象
    private Car car = new Car();
    public Car getCar() {
        return car;
    }
    public void setCar(Car car) {
        this.car = car;
    }
}
~~~

在①处为Boss的car属性提供了一个非空的Car实例。如果没有为car属性提供Car对象，那么Spring在设置级联属性时将抛出NullValueInNestedPathException异常。

Spring没有对级联属性的层级数进行限制，只要配置的Bean拥有对应于级联属性的类结构，就可以配置任意层级的级联属性。

### 5.4.6 集合类型属性

java.util包中的集合类型是最常用的数据结构类型，主要包括List、Set、Map、Properties，Spring为这些集合类型属性提供了专属的配置标签。

#### 1. List

~~~java
package com.smart.attr;
...
public class Boss {
    private List favorites = new ArrayList();
    public List getFavorites() {
        return favorites;
    }
    public void setFavorites(List favorites) {
        this.favorites = favorites;
    }
    ...
}
~~~

~~~xml
<bean id="boss1" class="com.smart.attr.Boss">
	<property name="favorites">
    	<list>
        	<value>看报</value>
            <value>赛车</value>
            <value>高尔夫</value>
        </list>
    </property>
</bean>
~~~

List属性即可以通过`<value>`注入字符串，也可以通过`<ref>`注入容器中其他的Bean。

#### 2. Set

如果Boss的Favorites属性是java.util.Set，则采用如下配置方式：

~~~xml
<bean id="boss1" class="com.smart.attr.Boss">
	<property name="favorites">
    	<set>
        	<value>看报</value>
            <value>赛车</value>
            <value>高尔夫</value>
        </set>
    </property>
</bean>
~~~

#### 3. Map

~~~java
public class Boss {
    ...
    private Map jobs = new HashMap();
    public Map getJobs() {
        return jobs;
    }
    public void setJobs(Map jobs) {
        this.jobs = jobs;
    }
    ...
}
~~~

~~~xml
<bean id="boss1" class="com.smart.attr.Boss">
	<property name="jobs">
    	<map>
        	<entry>
                <key><value>AM</value></key>
                <value>会见客户</value>
            </entry>
            <entry>
                <key><value>PM</value></key>
                <value>公司内部会议</value>
            </entry>
        </map>
    </property>
</bean>
~~~

假如某一Map元素的键和值都是对象，则可以采用以下配置方式：

~~~xml
<entry>
    <key><ref bean="keyBean"/></key>
    <ref bean="valueBean"/>
</entry>
~~~

#### 4. Properties

Properties类型其实可以看作Map类型的特例。Map元素的键和值可以是任何类型的对象，而Properties属性的键和值都只能是字符串。下面为Boss添加一个Properties类型的mails属性：

~~~java
public class Boss {
    ...
    private Properties mails = new Properties();
    public Properties getMails(){
        return mails;
    }
    public void setMails(Properties mails){
        this.mails = mails;
    }
    ...
}
~~~

下面的配置片段为mails提供了配置：

~~~xml
<bean id="boss1" class="com.smart.attr.Boss">
	<property name="mails">
    	<props>
        	<prop key="jobMail">john-office@smart.com</prop>
            <prop key="lifeMail">john-office@smart.com</prop>
        </props>
    </property>
</bean>
~~~

因为Properties键值对只能是字符串，因此其配置比Map的配置要简单些，注意值的配置没有`<value>`子元素标签。

#### 5. 强类型集合

Java 5.0提供了强类型集合的新功能，允许为集合元素指定类型。如下面Boss类中jobTime属性就采用了强类型的Map类型，元素的键为String类型，而值为Integer类型。

~~~java
public class Boss {
    ...
    private Map<String, Integer> jobTime = new HashMap<String, Integer>();
    public Map<String, Integer> getJobTime() {
        return jobTime;
    }
    public void setJobTime(Map<String, Integer> jobTime) {
        this.jobTime = jobTime;
    }
    ...
}
~~~

在Spring中的配置和非强类型集合相同。

但Spring容器在注入强类型集合时会判断元素的类型，将设置值转换为对应的数据类型。

#### 6. 集合合并

Spring支持集合合并的功能，允许子`<bean>`继承父`<bean>`的同名属性集合元素，并将子`<bean>`中配置的集合属性值和父`<bean>`中配置的同名属性值合并起来作为最终Bean的属性值，如代码清单5-12所示。

~~~xml
<bean id="parentBoss" abstract="true" class="com.smart.attr.Boss">
	<!--①父<bean>-->
    <property name="favorites">
    	<set>
        	<value>看报</value>
            <value>赛车</value>
            <value>高尔夫</value>
        </set>
    </property>
</bean>
<bean id="childBoss" parent="parentBoss">
	<!--②指定父<bean>-->
    <property name="favorites">
    	<set merge="true">
            <!--③和父<bean>中的同名集合属性合并-->
        	<value>爬山</value>
            <value>游泳</value>
        </set>
    </property>
</bean>
~~~

在代码清单5-12中，③处通过`merge="true"`属性指示子`<bean>`和父`<bean>`中的同名属性值进行合并，即子Bean的favorites集合最终将拥有5个元素。如果设置为`merge="false"`，则不会和父`<bean>`中的同名集合属性进行合并，即子Bean的favorites属性集合只有两个元素。

#### 7. 通过util命名空间配置集合类型的Bean

如果希望配置一个集合类型的Bean，而非一个集合类型的属性，则可以通过util命名空间进行配置。首先需要在Spring配置文件头中引入util命名空间的声明。

其次配置一个List类型的Bean，可以通过list-class显式指定List的实现类。

~~~xml
<util:list id="favoriteList1" list-class="java.util.LinkedList">
	<value>看报</value>
    <value>赛车</value>
    <value>高尔夫</value>
</util:list>
~~~

再次配置一个Set类型的Bean，可以通过set-class指定Set的实现类。

~~~xml
<util:set id="favoriteSet1">
	<value>看报</value>
    <value>赛车</value>
    <value>高尔夫</value>
</util:set>
~~~

最后配置一个Map类型的Bean，可以通过map-class指定Map的实现类。

~~~xml
<util:map id="emails1">
	<entry key="AM" value="会见客户"/>
    <entry key="PM" value="公司内部会议"/>
</util:map>
~~~

此外，`<util:list>`和`<util:set>`支持value-type属性，指定集合中的值的类型；而`<util:map>`支持key-value和value-type属性，指定Map的键和值类型。

### 5.4.7 简化配置方式

## 5.6 `<bean>`之间的关系

### 5.6.2 依赖

一般情况下，可以使用`<ref>`元素标签建立对其他Bean的依赖关系，Spring负责管理这些Bean的关系。当实例化一个Bean时，Spring保证该Bean所依赖的其他Bean已经初始化。

Spring允许用户通过depends-on属性显式指定Bean前置依赖的Bean，前置依赖的Bean会在本Bean实例化之前创建好。

如果前置依赖多个Bean，则可以通过逗号、空格或分号的方式创建Bean的名称。

## 5.8 Bean作用域

| 类型          | 说明                                                         |
| ------------- | ------------------------------------------------------------ |
| singleton     | 在Spring IoC容器中仅存在一个Bean实例，Bean以单实例的方式存在 |
| prototype     | 每次从容器中调用Bean时，都返回一个新的实例，即每次调用getBean()时，相当于执行 new XxxBean()操作 |
| request       | 每次HTTP请求都会创建一个新的Bean。该作用域仅适用于WebApplicationContext环境 |
| session       | 同一个HTTP Session 共享一个Bean，不同的HTTP Session使用不同的Bean。该作用域仅适用于WebApplicationContext环境 |
| globalSession | 同一个全局Session共享一个Bean，一般用于Portlet应用环境。该作用域仅适用于WebApplicationContext环境 |

### 5.8.4 作用域依赖问题

~~~xml
① 声明aop schema
<bean name="car" class="com.smart.scope.Car" scope="request">
	<aop:scoped-proxy/> ② 创建代理
</bean>
<bean id="boss" class="com.smart.scope.Boss">
	<property name="car" ref="car"/> ③ 引用web相关作用域的car Bean
</bean>
~~~

在代码清单5-18中，car Bean是request作用域，它被singleton作用域的boss Bean引用。为了使boss能够从适当作用域中获取car Bean的引用，需要使用Spring AOP的语法为car Bean配置一个代理类，如②所示。为了能够在配置文件中使用AOP的配置标签，需要在文档声明头中定义aop命名空间。

当boss Bean在Web环境下调用car Bean时，Spring AOP 将启用动态代理智能地判断boss Bean位于哪个HTTP请求线程中，并从对应的HTTP请求线程域中获取对应的car Bean。

boss Bean的作用域时singleton，也就是说，在Spring容器中始终只有一个实例，而car Bean的作用域为request，所以每个调用到car Bean的HTTP请求都会创建一个car Bean。Spring通过动态代理技术，能够让boss Bean引用到对应HTTP请求的car Bean。

反过来，在配置文件中添加`<aop:scoped-proxy/>`后，注入boss Bean中的car Bean已经不是原来的car Bean，而是car Bean的动态代理对象。这个动态代理是Car类的子类（或实现类，假设Car是接口），Spring在动态代理子类中加入一段逻辑，以判断当前的boss需要取得哪个HTTP请求相关的car Bean。

> **提示**：
>
> 动态代理所添加的逻辑其实也很简单，即判断当前boss位于哪个线程中，然后根据这个线程找到对应的HttpRequest，再从HttpRequest域中获取对应的car。因为Web容器的特性，一般情况下，一个HTTP请求对应一个独立的线程。

## 5.9 FactoryBean

Spring提供了一个org.springframework.beans.factory.FactoryBean工厂类接口，用户可以通过实现该工厂类接口定制实例化Bean的逻辑。

当调用getBean("car")时，Spring通过反射机制发现CarFactoryBean实现了FactoryBean的接口，这时Spring容器就调用接口方法CarFactoryBean#getObject()返回工厂类创建的对象。如果用户希望获取CarFactoryBean的实例，则需要在使用getBean(beanName)方法时显式地在beanName前加上“&”前缀，即getBean("&car")。

## 5.10 基于注解的配置

### 5.10.1 使用注解定义Bean

除@Component外，Spring还提供了3个功能基本和@Component等效的注解，分别用于对DAO、Service及Web层的Controller进行注解。

- @Repository：用于对DAO实现类进行标注。
- @Service：用于对Service实现类进行标注。
- @Controller：用于对Controller实现类进行标注。

### 5.10.2 扫描注解定义的Bean

~~~xml
<context:component-scan base-package="com.smart.anno"/>
~~~

如果仅希望扫描特定的类而非基包下的所有类，那么可以使用resource-pattern属性过滤出特定的类，如下：

~~~xml
<context:component-scan base-package="com.smart" resource-pattern="anno/*.class"/>
~~~

这里将基类包设置为com.smart：默认情况下resource-pattern属性的值为“`**/*.class`”，即基类包里的所有类，将其设置为“`anno/*.class`”，则Spring仅会扫描基类包里anno子包中的类。

~~~xml
<context:component-scan base-package="com.smart">
	<context:include-filter type="regex" expression="com\.smart\.anno.*"/>
    <context:exclude-filter type="aspectj" expression="com.smart..*Controller+"/>
</context:component-scan>
~~~

`<context:include-filter>`表示要包含的目标类，而`<context:exclude-filter>`表示要排除的目标类。一个`<context:component-scan>`下可以拥有若干个`<context:exclude-filter>`和`<context:include-filter>`元素。这两个过滤元素均支持多种类型的过滤表达式

| 类别       | 示例                      | 说明                                                         |
| ---------- | ------------------------- | ------------------------------------------------------------ |
| annotation | `com.smart.XxxAnnotation` | 所有标注了XxxAnnotation的类。该类型采用目标类是否标注了某个注解进行过滤 |
| assignable | `com.smart.XxxService`    | 所有继承或扩展XxxService的类。该类型采用目标类是否继承或扩展了某个特定类进行过滤 |
| aspectj    | `com.smart..*Service+`    | 所有类名以Service结束的类及继承或扩展它们的类（参见第7章关于AspectJ的内容）。该类型采用AspectJ表达式进行过滤 |
| regex      | `com\.smart\.anno\..*`    | 所有com.smart.anno类包下的类。该类型采用正则表达式根据目标类的类名进行过滤 |
| custom     | `com.smart.XxxTypeFilter` | 采用XxxTypeFile代码方式实现的过滤原则，该类必须实现org.springframework.core.type.TypeFilter接口 |

在所有这些过滤类型中，除custom类型外，aspectj的过滤表达能力是最强的，它可以轻易实现其他类型所能表达的过滤规则。

`<context:component-scan/>`拥有一个容易被忽视的use-default-filter属性，其默认值为true，表示默认会对标注@Component、@Controller、@Service及@Repository的Bean进行扫描。`<context:component-scan/>`先根据`<exclude-filter/>`列出需要排除的黑名单，再通过`<include-filter/>`列出需要包含的白名单。

由于use-default-filter属性默认值的作用，下面的配置片段不但会扫描@Controller的Bean，还会扫描@Component、@Service及@Repository的Bean。

~~~xml
<context:component-scan base-package="com.smart">
	<context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
</context:component-scan>
~~~

换言之，在以上配置中，加不加`<context:include-filter>`的效果都是一样的。如果想仅扫描@Controller的Bean，则必须将use-default-filter属性设置为false。

~~~xml
<context:component-scan base-package="com.smart" use-default-filter="false">
	<context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
</context:component-scan>
~~~

### 5.10.3 自动装配Bean

#### 1.使用@Autowired进行自动注入

#### 2.使用@Autowired的required属性

#### 3.使用@Qualifier指定注入Bean的名称

#### 4.对类方法进行标注

@Autowired可以对类成员变量及方法的入参进行标注

虽然Spring支持在属性和方法上标注自动注入注解@Autowired，但在实际项目开发中建议采用在方法上标注@Autowired注解，因为这样更加“面向对象”，也方便单元测试的编写。如果将注解标注在私有属性上，则在单元测试时就很难用编程的办法设置属性值。

#### 5.对集合类进行标注

如果对类中集合类的变量或方法入参进行@Autowired标注，那么Spring会将容器中类型匹配的所有Bean都自动注入进来。

在 Spring4.0 中可以通过@Order注解或实现Ordered接口来决定Bean加载的顺序，值越小，优先被加载。

#### 6.对延迟依赖注入的支持

Spring 4.0 支持延迟依赖注入，即在Spring容器启动的时候，对于在Bean上标注@Lazy及@Autowired注解的属性，不会立即注入属性值，而是延迟到调用此属性的时候才会注入属性值。

对Bean实施延迟依赖注入，要注意@Lazy注解必须同时标注在属性及目标Bean上，二者缺一，则延迟注入无效。

#### 7.对标准注解的支持

此外，Spring还支持JSR-250中定义的@Resource和JSR-330中定义的@Inject注解，这两个标准注解和@Autowired注解的功用类似，都是对类变更及方法入参提供自动注入功能。

不管是@Resource还是@Inject注解，其功能都没有@Autowired丰富，因此，除非必要，大可不必在乎在两个注解。

### 5.10.4 Bean作用范围及生命过程方法

通过注解配置的Bean和通过`<bean>`配置的Bean一样，默认的作用范围都是singleton。Spring为注解配置提供了一个@Scope注解，可以通过它显式指定Bean的作用范围。

Spring从2.5开始支持JSR-250中定义的@PostConstruct和@PreDestroy注解，在Spring中它们相当于init-method和destroy-method属性的功能，不过在使用注解时，可以在一个Bean中定义多个@PostConstruct和@PreDestroy方法。

## 5.11 基于Java类的配置

### 5.11.1 使用Java类提供Bean定义信息

普通的POJO只要标注@Configuration注解，就可以为Spring容器提供Bean定义的信息，每个标注了@Bean的类方法都相当于提供了一个Bean的定义信息。

~~~java
package com.smart.conf;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// ①将一个POJO标注为定义Bean的配置类
@Configuration
public class AppConf {
    // ②以下两个方法定义了两个Bean，并提供了Bean的实例化逻辑
    @Bean
    public UserDao userDao(){
        return new UserDao();
    }
    @Bean
    public LogDao logDao(){
        return new LogDao();
    }
    
    // ③定义了logonService的Bean
    @Bean
    public LogonService logonService(){
        LogonService logonService = new LogonService();
        // ④ 将②和③处定义的Bean注入logonService Bean中
        logonService.setLogDao(logDao());
        logonService.setUserDao(userDao());
        return logonService;
    }
}
~~~

在①处，在AppConf类的定义处标注了@Configuration注解，说明这个类可用于为Spring提供Bean的定义信息。该类的方法可标注@Bean注解，Bean的类型由方法返回值的类型决定，名称默认和方法名相同，也可以通过入参显式指定Bean名称，如@Bean(name="userDao")。@Bean所标注的方法体提供了Bean的实例化逻辑。

以上配置和以下XML配置是等效的：

~~~xml
<bean id="userDao" class="com.smart.anno.UserDao"/>
<bean id="logDao" class="com.smart.anno.LogDao"/>
<bean id="logonService" class="com.smart.conf.logonService"
      p:logDao-ref="userDao" p:userDao-ref="logDao"/>
~~~

基于Java类的配置方式和基于XML或基于注解的配置方式相比，前者通过代码编程的方式可以更加灵活地实现Bean的实例化及Bean之间的装配；后两者都是通过配置声明的方式，在灵活性上要稍逊一些，但在配置上要简单一些。



由于@Configuration注解类本身已经标注了@Component注解，所以任何标注了@Configuration的类，本身也相当于标注了@Component，即它们可以像普通的Bean一样被注入其他Bean中。

Spring会对配置类所有标注@Bean的方法进行“改造”（AOP增强），将对Bean生命周期管理的逻辑植入进来。

在@Bean处，还可以标注@Scope注解以控制Bean的作用范围。

### 5.11.2 使用基于Java类的配置信息启动Spring容器

#### 1.直接通过@Configuration类启动Spring容器

Spring提供了一个AnnotationConfigApplicationContext类，它能够直接通过标注@Configuration的Java类启动Spring容器

~~~java
package com.smart.conf;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
public class JavaConfigTest {
    public static void main(String[] args){
        // ①使用@Configuration类提供的Bean定义信息启动容器
        ApplicationContext ctx = new AnnotationConfigApplicationContext(AppConf.class);
        LogonService logonService = ctx.getBean(LogonService.class);
        logonService.printHello();
    }
}
~~~

此外，AnnotationConfigApplicationContext还支持通过编码的方式加载多个@Configuration配置类，然后通过刷新容器应用这些配置类。

~~~java
package com.smart.conf;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
public class JavaConfigTest {
    public static void main(String[] args){
        ApplicationContext ctx = new AnnotationConfigApplicationContext();
        
        // ①注册多个@Configuration配置类
        ctx.register(DaoConfig.class);
        ctx.register(ServiceConfig.class);
        
        // ②刷新容器以应用这些注册的配置类
        ctx.refresh();
        LogonService logonService = ctx.getBean(LogonService.class);
        logonService.printHello();
    }
}
~~~

可以通过代码一个一个注册配置类，也可以通过@Import将多个配置类组装到一个配置类中，这样仅需要注册这个组装好的配置类就可以启动容器。

~~~java
package com.smart.conf;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import(DaoConfig.class)
public class ServiceConfig {
    @Bean
    public LogonService logonService(){
        LogonService logonService = new LogonService();
        return logonService;
    }
}
~~~

#### 2.通过XML配置文件应用@Configuration的配置

标注了@Configuration的配置类与标注了@Component的类一样也是一个Bean，它可以被Spring的`<context:component-scan>`扫描到。因此，如果希望将配置类组装到XML配置文件启动Spring容器，则仅需在XML中通过`<context:component-scan>`扫描到相应的配置类即可。

#### 3.通过@Configuration配置类引用XML配置信息

在@Configuration配置类中可以通过@ImportResource引入XML配置文件，在LogonAppConfig配置类中即可直接通过@Autowired引用XML配置文件中定义的Bean。

~~~java
package com.smart.conf;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportResource;

// ①通过@ImportResource引入XML配置文件
@Configuration
@ImportResource("classpath:com/smart/conf/beans3.xml")
public class LogonAppConfig {
    // ②自动注入XML文件中定义的Bean
    @Bean
    @Autowired
    public LogonService logonService(UserDao userDao, LogDao logDao){
        LogonService logonService = new LogonService();
        logonService.setUserDao(userDao);
        logonService.setLogDao(logDao);
        return logonService;
    }
}
~~~

## 5.12 基于Groovy DSL 的配置

## 5.13 通过编码方式动态添加Bean

### 5.13.1 通过DefaultListableBeanFactory

## 5.14 不同配置方式比较

|                  | 基于XML配置                                                  | 基于注解配置                                                 | 基于Java类配置                                               | 基于Groovy DSL配置                                           |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Bean定义         | 在XML文件中通过`<bean>`元素定义Bean                          | 在Bean实现类处通过标注@Component或衍型类(@Repository、@Service及@Controller)定义Bean | 在标注了@Configuration的Java类中，通过在类方法上标注@Bean定义一个Bean。方法必须提供Bean的实例化逻辑 | 在Groovy文件中通过DSL定义Bean                                |
| Bean名称         | 通过`<bean>`的id或name属性定义，默认名称为com.smart.UserDao#() | 通过注解的value属性定义。默认名称为小写字母开头的类名（不带包名） | 通过@Bean的name属性定义，如@Bean("userDao")。默认名称为方法名 | 通过Groovy的DSL定义Bean的名称（Bean的类型，Bean构建函数参数），如：`logonService(LogonService,userDao)` |
| Bean注入         | 通过`<property>`子元素或通过p命名空间的动态属性              | 通过在成员变更或方法入参处标注@Autowired，按类型匹配自动注入。还可以配合使用@Qualifier按名称匹配方式注入 | 比较灵活，可以在方法处通过@Autowired使方法入参绑定Bean，然后在方法中通过代码进行注入；还可以通过调用配置类的@Bean方法进行注入 | 比较灵活，可以在方法处通过ref()方法进行注入，如ref("logDao") |
| Bean生命过程方法 | 通过`<bean>`的init-method和destroy-method属性指定Bean实现类的方法名。最多只能指定一个初始化方法和销毁方法 | 通过在目标方法上标注@PostConstruct和@PreDestroy注解指定初始化或销毁方法，可以定义任意多个 | 通过@Bean的initMethod或destroyMethod指定一个初始化或销毁方法。<br/>对于初始化方法来说，可以直接在方法内通过代码的方式灵活定义初始化逻辑 | 通过bean->bean.initMethod或bean.destroyMethod指定一个初始化或销毁方法 |
| Bean作用范围     | 通过`<bean>`的scope属性指定                                  | 通过在类定义处标注@Scope指定                                 | 通过在Bean方法定义处标注@Scope指定                           | 通过bean->bean.scope="prototype"指定                         |
| Bean延迟初始化   | 通过`<bean>`的lazy-init属性指定，默认为default，继承于`<beans>`的default-lazy-init设置，该值默认为false | 通过在类定义处标注@Lazy指定                                  | 通过在Bean方法定义处标注@Lazy指定                            | 通过bean->bean.lazyInit=true指定                             |

这4种配置文件很难说孰优孰劣，只能说它们都有自己的舞台和适用场景

|          | 基于XML配置                                                  | 基于注解配置                                                 | 基于Java类配置                                               | 基于Groovy DSL配置                                           |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 使用场景 | （1）Bean实现类来源于第三方类库，如DataSource、JdbcTemplate等，因无法在类中标注注解，所以通过XML配置方式比较好。<br/>（2）命名空间的配置，如aop、context等，只能采用基于XML的配置 | Bean的实现类使当前项目开发的，可以直接在Java类中使用基于注解的配置 | 基于Java类配置的优势在于可以通过代码方式控制Bean初始化的整体逻辑。如果实例化Bean的逻辑比较复杂，则比较适合基于Java类配置的方式 | 基于Groovy DSL配置的优势在于可以通过Groovy脚本灵活控制Bean初始化的过程。如果实例化Bean的逻辑比较复杂，则比较适合基于Groovy DSL配置的方式。 |

# 第6章 Spring容器高级主题

## 6.1 Spring容器技术内幕

### 6.1.1 内部工作机制

Spring的AbstractApplicationContext是ApplicationContext的抽象实现类，该抽象类的refresh()方法定义了Spring容器在加载配置文件后的各项处理过程，这些处理过程清晰地刻画了Spring容器启动时所执行的各项操作。下面来看一下refresh()内部定义了哪些执行逻辑

~~~java
// ①初始化BeanFactory
ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();
...
// ②调用工厂后处理器
invokeBeanFactoryPostProcessors();
// ③注册Bean后处理器
registerBeanPostProcessors();
// ④初始化消息源
initMessageSource();
// ⑤初始化应用上下文事件广播器
initApplicationEventMulticaster();
// ⑥初始化其他特殊的Bean；由具体子类实现
onRefresh();
// ⑦注册事件监听器
registerListeners();
// ⑧初始化所有单实例的Bean，使用懒加载模式的Bean除外
finishBeanFactoryInitialization(beanFactory);
// ⑨完成刷新并发布容器刷新事件
finishRefresh();
~~~

（1）初始化BeanFactory：根据配置文件实例化BeanFactory，在obtainFreshBeanFactory()方法中，首先调用refreshBeanFactory()方法刷新BeanFactory，然后调用getBeanFactory()方法获取BeanFactory，这两个方法都是由具体子类实现的。在这一步里，Spring将配置文件的信息装入容器的Bean定义注册表（BeanDefinitionRegistry）中，但此时Bean还未初始化。

（2）调用工厂后处理器：根据反射机制从BeanDefinitionRegistry中找出所有实现了BeanFactoryPostProcessor接口的Bean，并调用其postProcessBeanFactory()接口方法。

（3）注册Bean后处理器：根据反射机制从BeanDefinitionRegistry中找出所有实现了BeanPostProcessor接口的Bean，并将它们注册到容器Bean后处理器的注册表中。

（4）初始化消息源：初始化容器的国际化消息资源。

（5）初始化应用上下文事件广播器。

（6）初始化其他特殊的Bean：这是一个钩子方法，子类可以借助这个方法执行一些特殊的操作，如AbstractRefreshableWebApplicationContext就使用该方法执行初始化ThemeSource的操作。

（7）注册事件监听器。

（8）初始化所有单实例的Bean，使用懒加载模式的Bean除外：初始化Bean后，将它们放入Spring容器的缓存池中。

（9）发布上下文刷新事件：创建上下文刷新事件，事件广播器负责将这些事件广播到每个注册的事件监听器中。

~~~mermaid
graph TB
start(( ))--ResourceLoader装载配置文件-->Resource
Resource--BeanDefinitionReader解析配置信息-->BeanDefinition[BeanDefinitionRegistry加工前的BeanDefinition]
BeanDefinition--BeanFactoryPostProcessor对配置信息进行加工-->BeanDefinition2[BeanDefinitionRegistry加工后的BeanDefinition]
BeanDefinition--BeanFactoryPostProcessor对配置信息进行加工-->PropertyEditor[PropertyEditorRegistry存放着自定义的PropertyEditor]
BeanDefinition2--InstantiationStrategy实例化Bean对象-->未设置属性的Bean实例
未设置属性的Bean实例--BeanWrapper设置Bean属性-->已设置属性的Bean实例
PropertyEditor--BeanWrapper设置Bean属性-->已设置属性的Bean实例
已设置属性的Bean实例--BeanPostProcessor对Bean进行加工-->准备完毕的Bean实例
~~~

上图描述了Spring容器从加载配置文件到创建出一个完整Bean的作业流程及参与的角色。

（1）ResourceLoader从存储介质中加载Spring配置信息，并使用Resource表示这个配置文件资源。

（2）BeanDefinitionReader读取Resource所指向的配置文件资源，然后解析配置文件。配置文件中的每个`<bean>`解析成一个BeanDefinition对象，并保存到BeanDefinitionRegistry中。

（3）容器扫描BeanDefinitionRegistry中的BeanDefinition，使用Java反射机制自动识别出Bean工厂后处理器（实现BeanFactoryPostProcessor接口的Bean），然后调用这些Bean工厂后处理器对BeanDefinitionRegistry中的BeanDefinition进行加工处理。主要完成以下两项工作：

① 对使用占位符的`<bean>`元素标签进行解析，得到最终的配置值。这意味着对一些半成品式的BeanDefinition对象进行加工处理并得到成品的BeanDefinition对象。

② 对BeanDefinitionRegistry中的BeanDefinition进行扫描，通过Java反射机制找出所有属性编辑器的Bean（实现java.beans.PropertyEditor接口的Bean），并自动将它们注册到Spring容器的属性编辑器注册表中（PropertyEditorRegistry）。

（4）Spring容器从BeanDefinitionRegistry中取出加工后的BeanDefinition，并调用InstantiationStrategy着手进行Bean实例化的工作。

（5）在实例化Bean时，Spring容器使用BeanWrapper对Bean进行封装。BeanWrapper提供了很多以Java反射机制操作Bean的方法，它将结合该Bean的BeanDefinition及容器中的属性编辑器，完成Bean属性注入工作。

（6）利用容器中注册的Bean的后处理器（实现BeanPostProcessor接口的Bean）对已经完成属性设置工作的Bean进行后续加工，直接装配出一个准备就绪的Bean。



Spring组件按其所承担的角色可以划分为两类。

（1）物料组件：Resource、BeanDefinition、PropertyEditor及最终的Bean等，它们是加工流程中被加工、被消费的组件，就像流水线上被加工的物料一样。

（2）设备组件：ResourceLoader、BeanDefinitionReader、BeanFactoryPostProcessor、InstantiationStrategy及BeanWrapper等。它们就像流水线上不同环节的加工设备，对物料组件进行加工处理。

### 6.1.2 BeanDefinition

org.springframework.beans.factory.config.BeanDefinition是配置文件`<bean>`元素标签在容器中的内部表示。`<bean>`元素标签有class、scope、lazy-init等配置属性，BeanDefinition则提供了相应的beanClass、scope、lazyInit类属性，BeanDefinition就像`<bean>`的镜中人，二者是一一对应的。BeanDefinition类的继承结构如下

~~~mermaid
classDiagram
	BeanDefinition <|.. AbstractBeanDefinition
	AbstractBeanDefinition <|-- ChildBeanDefinition
	AbstractBeanDefinition <|-- RootBeanDefinition
~~~

RootBeanDefinition是最常用的实现类，它对应一般性的`<bean>`元素标签。我们知道，在配置文件中可以定义父`<bean>`和子`<bean>`，父`<bean>`用RootBeanDefinition表示，子`<bean>`用ChildBeanDefinition表示，而没有父`<bean>`的`<bean>`则用RootBeanDefinition表示。AbstractBeanDefinition对二者共同的类信息进行抽象。

Spring通过BeanDefinition将配置文件中的`<bean>`配置信息转换为容器的内部表示，并将这些BeanDefinition注册到BeanDefinitionRegistry中。Spring容器的BeanDefinitionRegistry就像Spring配置信息的内存数据库，后续操作直接从BeanDefinitionRegistry中读取配置信息。一般情况下，BeanDefinition只在容器启动时加载并解析，除非容器刷新或重启，这些信息不会发生变化。当然，如果用户有特殊的需求，也可以通过编程的方式在运行期调整BeanDefinition的定义。

创建最终的BeanDefinition主要包括两个步骤。

（1）利用BeanDefinitionReader读取承载配置信息的Resource，通过XML解析器解析配置信息的DOM对象，简单地为每个`<bean>`生成对应的BeanDefinition对象。但是这里生成的BeanDefinition可能是半成品，因为在配置文件中，可能通过占位符变量引用外部属性文件中的属性，这些占位符变量在这一步里还没有被解析出来。

（2）利用容器注册的BeanFactoryPostProcessor对半成品的BeanDefinition进行加工处理，将以占位符表示的配置解析为最终的实际值，这样半成品的BeanDefinition就成为成品的BeanDefinition。

### 6.1.3 InstantiationStrategy

org.springframework.beans.factory.support.InstantiationStrategy负责根据BeanDefinition对象创建一个Bean实例。Spring之所以将实例化Bean的工作通过一个策略接口进行描述，是为了方便地采用不同的实例化策略，以满足不同的应用需求，如通过CGLib类库为Bean动态创建子类再进行实例化。InstantiationStrategy类的继承结构如下所示：

~~~mermaid
classDiagram
	InstantiationStrategy <|.. SimpleInstantiationStrategy
	SimpleInstantiationStrategy <|-- CglibSubclassingInstantiationStrategy
~~~

SimpleInstantiationStrategy是最常用的实例化策略，该策略利用Bean实现类的默认构造函数、带参构造函数或工厂方法创建Bean的实例。

CglibSubclassingInstantiationStrategy扩展了SimpleInstantiationStrategy，为需要进行方法注入的Bean提供了支持。它利用CGLib类库为Bean动态生成子类，在子类中生成方法注入的逻辑，然后使用这个动态生成的子类创建Bean的实例。

InstantiationStrategy仅负责实例化Bean的操作，相当于执行Java语言中new的功能，它并不会参与Bean属性的设置工作。所以由InstantiationStrategy返回的Bean实例实际上是一个半成品的Bean实例，属性填充的工作留待BeanWrapper来完成。

### 6.1.4 BeanWrapper

org.springframework.beans.BeanWrapper是Spring框架中重要的组件类。BeanWrapper相当于一个代理器，Spring委托BeanWrapper完成Bean属性的填充工作。在Bean实例被InstantiationStrategy创建出来之后，容器主控程序将Bean实例通过BeanWrapper包装起来，这是通过调用BeanWrapper#setWrappedInstance(Object obj)方法完成的。BeanWrapper类的继承结构如下：

~~~mermaid
classDiagram
	PropertyAccessor <|-- ConfigurablePropertyAccessor
	PropertyEditorRegistry <|-- ConfigurablePropertyAccessor
	PropertyEditorRegistry <|.. PropertyEditorRegistrySupport
	ConfigurablePropertyAccessor <|-- BeanWrapper
	ConfigurablePropertyAccessor <|.. AbstractPropertyAccessor
	PropertyEditorRegistrySupport <|-- AbstractPropertyAccessor
	BeanWrapper <|.. BeanWrapperImpl
	AbstractPropertyAccessor <|-- BeanWrapperImpl
~~~

BeanWrapper还有两个顶级类接口，分别是PropertyAccessor和PropertyEditorRegistry。PropertyAccessor接口定义了各种访问Bean属性的方法，如setPropertyValue(String, Object)、setPropertyValues(PropertyValues pvs)等；而PropertyEditorRegistry是属性编辑器的注册表。所以BeanWrapper实现类BeanWrapperImpl具有三重身份：

- Bean包裹器
- 属性访问器
- 属性编辑器注册表

一个BeanWrapperImpl实例内部封装了两类组件：被封装的待处理的Bean，以及一套用于设置Bean属性的属性编辑器。

要顺利地填充Bean属性，除了目标Bean实例和属性编辑器外，还需要获取Bean对应地BeanDefinition，它从Spring容器的BeanDefinitionRegistry中直接获取。Spring主控程序从BeanDefinition中获取Bean属性的配置信息PropertyValue，并使用属性编辑器对PropertyValue进行转换以得到Bean的属性值。对Bean的其他属性重复这样的步骤，就可以完成Bean所有属性的注入工作。BeanWrapperImpl在内部使用Spring的BeanUtils工具类对Bean进行反射操作，设置属性。下一节将详细介绍属性编辑器的原理，并讲解如何通过配置的方式注册自定义的属性编辑器。

## 6.2 属性编辑器

BeanWrapper在填充Bean属性时如何将这个字面值正确地转换为对应地double或int等内部类型呢？这个转换器就是属性编辑器。

任何实现java.beans.PropertyEditor接口的类都是属性编辑器。属性编辑器的主要功能就是将外部的设置值转换为JVM内部的对应类型，所以属性编辑器其实就是一个类型转换器。

### 6.2.1 JavaBean的编辑器

Sun所制定的JavaBean规范很大程度上是为IDE准备的

JavaBean规范通过java.beans.PropertyEditor定义了设置JavaBean属性的方法，通过BeanInfo描述了JavaBean的哪些属性是可定制的，此外还描述了可定制属性与PropertyEditor的对应关系。

BeanInfo与JavaBean之间的对应关系通过两者之间的命名规范确立。对应JavaBean的BeanInfo采用如下的命名规范：`<Bean>BeanInfo`。如ChartBean对应的BeanInfo为ChartBeanBeanInfo；Car对应的BeanInfo为CarBeanInfo。

JavaBean规范提供了一个管理默认属性编辑器的管理器PropertyEditorManager，该管理器内保存着一些常见类型的属性编辑器。如果某个JavaBean的常见类型属性没有通过BeanInfo显式指定属性编辑器，那么IDE将自动使用PropertyEditorManager中注册的对应默认属性编辑器。

#### 1.PropertyEditor

PropertyEditor是属性编辑器的接口，它规定了将外部设置值转换为内部JavaBean属性值的转换接口方法。PropertyEditor主要的接口方法说明如下。

- Object getValue(): 返回属性的当前值，基本类型被封装成对应的封装类实例。
- void setValue(Object newValue): 设置属性的值，基本类型以封装类传入。
- String getAsText(): 将属性对象用一个字符串表示，以便外部的属性编辑器能以可视化的方式显示。默认返回null，表示该属性不能以字符串表示。
- void setAsText(String text): 用一个字符串去更新属性的内部值，这个字符串一般从外部属性编辑器传入。
- String[] getTags(): 返回表示有效属性值的字符串数组（如boolean属性对应的有效Tag为true和false），以便属性编辑器能以下拉框的方式显示出来。默认返回null，表示没有匹配的字符串有限集合。
- String getJavaInitializationString()：为属性提供一个表示初始值的字符串，属性编辑器以此值作为属性的默认值。

#### 2.BeanInfo

# 第7章 Spring AOP基础

## 7.1 AOP概述

### 7.1.1 AOP到底是什么

AOP是Aspect Oriented Programing的简称，最初被译为“面向方面编程”，这个翻译向来为人所诟病，但是由于陷入为主的效应，受众广泛，所以这个翻译依然被很多人使用。但我们更倾向于用“面向切面编程”的译法，因为它更加达意。

### 7.1.2 AOP术语

#### 1.连接点（Joinpoint）

特定点是程序执行的某个特定位置，如类开始初始化前、类初始化后、类的某个方法调用前/调用后、方法抛出异常后。一个类或一段程序代码拥有一些具有边界性质的特定点，这些代码中的特定点就被称为“连接点”。Spring仅支持方法的连接点，即仅能在方法调用前、方法调用后、方法抛出异常时及方法调用前后这些程序执行织入增强。连接点就是AOP向目标类打入楔子的候选锚点。

连接点由两个信息确定：一是用方法表示的程序执行点；二是用相对位置表示的方位。如在Test.foo()方法执行前的连接点，执行点为Test.foo()，方位为该方法执行前的位置。Spring使用切点对执行点进行定位，而方位则在增强类型中定义。

#### 2.切点（Pointcut）

每个程序类都拥有多个连续点，如一个拥有两个方法的类，这两个方法都是连接点，即连接点是程序类中客观存在的事物。但在为数众多的连接点中，如何定位某些感兴趣的连接点呢？AOP通过“切点”定位特定的连接点。借助数据库查询的概念来理解切点和连接点的关系再合适不过了：连接点相当于数据库中的记录，而切点相当于查询条件。切点和连接点不是一对一的关系，一个切点可以匹配多个连接点。

在Spring中，切点通过org.springframework.aop.Pointcut接口进行描述，它使用类和方法作为连接点的查询条件，Spring AOP的规则解析引擎负责解析切点所设定的查询条件，找到对应的连接点。确切地说，应该是执行点而非连接点，因为连接点是方法执行前、执行后等包括方位信息的具体程序执行点，而切点只定位到某个方法上，所以如果希望定位到具体的连接点上，还需要提供方位信息。

#### 3.增强（Advice）

增强是织入目标类连接点上的一段程序代码。在Spring中，增强除用于描述一段程序代码外，还拥有另一个和连接点相关的信息，这便是执行点的方位。结合执行点的方位信息和切点信息，就可以找到特定的连接。正因为增强既包含用于添加到目标连接点上的一段执行逻辑，又包含用于定位连接点的方位信息，所以Spring所提供的增强接口都是带方位名的，如BeforeAdvice、AfterReturnAdvice、ThrowsAdvice等。BeforeAdvice表示方法调用前的位置，而AfterReturningAdvice表示访问返回后的位置。所以只有结合切点和增强，才能确定特定的连接点并实施增强逻辑。

#### 4.目标对象（Target）

增强逻辑的织入目标类。如果没有AOP，那么目标业务类需要自己实现所有的逻辑。在AOP的帮助下，服务只实现哪些非横切逻辑的程序逻辑，而性能监视和事务管理这些横切逻辑则可以使用AOP动态织入特定的连接点上。

#### 5.引介（Introduction）

引介是一种特殊的增强，它为类添加一些属性和方法。这样，即使一个业务类原本没有实现某个接口，通过AOP的引介功能，也可以动态地为该业务类添加接口的实现逻辑，让业务类成为这个接口的实现类。

#### 6.织入（Weaving）

织入是将增强添加到目标类的具体连接点上的过程。AOP就像一台织布机，将目标类、增强或者引介天衣无缝地编织到一起。我们不能不说“织入”这个词太精辟了。根据不同的实现技术，AOP有3种织入方式。

（1）编译期织入，这要求使用特殊的Java编译器。

（2）类装载期织入，这要求使用特殊的类装载器。

（3）动态代理织入，在运行期为目标类添加增强生成子类的方式。

Spring采用动态代理织入，而AspectJ采用编译期织入和类装载期织入。

#### 7.代理（Proxy）

一个类被AOP织入增强后，就产生了一个结果类，它是融合了原类和增强逻辑的代理类。根据不同的代理方式，代理类既可能是和原类具有相同接口的类，也可能就是原类的子类，所以可以采用与调用原类相同的方式调用代理类。

#### 8.切面（Aspect）

切面由切点和增强（引介）组成，它既包括横切逻辑的定义，也包括连接点的定义。SpringAOP就是负责实施切面的框架，它将切面所定义的横切逻辑织入切面所指定的连接点中。

AOP的工作重心在于如何将增强应用于目标对象的连接点上。这里包括两项工作：第一，如何通过切点和增强定位到连接点上；第二，如何在增强中编写切面的代码。

### 7.1.3 AOP的实现者

#### 4.Spring AOP

Spring AOP使用纯Java实现，它不需要专门的编译过程，也不需要特殊的类装载器，它在运行期通过代理方式向目标类织入增强代码。Spring 并不尝试提供最完整的AOP实现，相反，它侧重于提供一种和Spring IoC容器整合的AOP实现，用以解决企业级开发中的常见问题。在Spring中可以无缝地将Spring AOP、IoC和AspectJ整合在一起。

## 7.2 基础知识

Spring AOP使用动态代理技术在运行期织入增强的代码，为了揭示Spring AOP底层的工作机理，有必要学习涉及的Java知识。Spring AOP使用了两种代理机制：一种是基于JDK的动态代理；另一种是基于CGLib的动态代理。之所以需要两种代理机制，很大程度上是因为JDK本身只提供接口的代理，而不支持类的代理。

### 7.2.1 带有横切逻辑的实例

下面通过具体化代码实现7.1节所介绍的例子的性能监视横切逻辑，并提供动态代理技术对此进行改造。在调用每一个目标类方法时启动方法的性能监视，在目标类方法调用完成时记录方法的花费时间，如代码清单7-2所示。

~~~java
package com.smart.proxy;
public class ForumServiceImpl implements ForumService {
    public void removeTopic(int topicId) {
        // ①-1 开始对该方法进行性能监视
        PerformanceMonitor.begin("com.smart.proxy.ForumServiceImpl.removeTopic");
        System.out.println("模拟删除Topic记录："+topicId);
        try {
            Thread.currentThread().sleep(20);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        
        // ①-2 结束对该方法的性能监视
        PerformanceMonitor.end();
    }
    
    public void removeForum(int forumId) {
        // ②-1 开始对该方法进行性能监视
        PerformanceMonitor.begin("com.smart.proxy.ForumServiceImpl.removeForum");
        System.out.println("模拟删除Forum记录："+forumId);
        try {
            Thread.currentThread().sleep(40);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        
        // ②-2 结束对该方法的性能监视
        PerformanceMonitor.end();
    }
}
~~~

在代码清单7-2中，PerformanceMonitor相关的代码就是具有横切逻辑特征的代码，每个Service类和每个业务方法体的前后都执行相同的代码逻辑：方法调用前启动PerformanceMonitor；方法调用后通知PerformanceMonitor结束性能监视并记录性能监视结果。

PerformanceMonitor是性能监视的实现类，下面给出一个非常简单的实现版本，如代码清单7-3所示。

~~~java
package com.smart.proxy;
public class PerformanceMonitor {
    // ①通过一个ThreadLocal保存与调用线程相关的性能监视信息
    private static ThreadLocal<MethodPerformance> performanceRecord = new ThreadLocal<MethodPerformancce>();
    
    // ②启动对某一目标方法的性能监视
    public static void begin(String method) {
        System.out.println("begin monitor...");
        MethodPerformance mp = new MethodPerformance(method);
        performanceRecord.set(mp);
    }
    public static void end() {
        System.out.println("end monitor...");
        MethodPerformance mp = performanceRecord.get();
        
        // ③打印出方法性能监视的结果信息
        mp.printPerformance();
    }
}
~~~

ThreadLocal是将非线程安全类改造为线程安全类的“法宝”（11.2节将详细介绍）。PerformanceMonitor提供了两个方法：通过调用begin(String method)方法开始对某个目标类方法的监视，其中method为目标类方法的全限定名；而通过调用end()方法结束对目标类方法的监视，并给出性能监视信息。这两个方法必须配套使用。

用于记录性能监视信息的MethodPerformance类的代码如代码清单7-4所示。

~~~java
package com.smart.proxy;
public class MethodPerformance {
    private long begin;
    private long end;
    private String serviceMethod;
    public MethodPerformance(String serviceMethod) {
        this.serviceMethod = serviceMethod;
        this.begin = System.currentTimeMillis(); // ①记录目标类方法开始执行点的系统时间
    }
    public void printPerformance() {
        end = System.currentTimeMillis(); // ②获取目标类方法执行完成后的系统时间，进而计算出目标类方法的执行时间
        long elapse = end - begin;
        System.out.println(serviceMethod + "花费" + elapse + "毫秒。"); // ③报告目标类方法的执行时间
    }
}
~~~

这些非业务逻辑的性能监视代码破坏了ForumServiceImpl业务逻辑的纯粹性。我们希望通过代理的方式将业务类方法中开启和结束性能监视的横切代码从业务类中完全移除，并通过JDK或CGLib动态代理技术将横切代码动态织入目标方法的相应位置。

### 7.2.2 JDK动态代理

自Java 1.3以后，Java提供了动态代理技术，运行开发者在运行期创建接口的代理实例。在Sun刚推出动态代理时，还很难想象它有多大的实际用途，现在终于发现动态代理是实现AOP的绝好底层技术。

JDK的动态代理主要涉及java.lang.reflect包中的两个类：Proxy和InvocationHandler。其中，InvocationHandler是一个接口，可以通过实现该接口定义横切逻辑，并通过反射机制调用目标类的代码，动态地将横切逻辑和业务逻辑编织在一起。

而Proxy利用Invocation动态创建一个符合某一接口的实例，生成目标类的代理对象。这样的描述一定很抽象，我们马上着手使用Proxy和InvocationHandler对7.2.1节中的性能监视代码进行革新。

首先从业务类ForumServiceImpl中移除性能监视的横切代码，使ForumServiceImpl只负责具体的业务逻辑。

原来的性能监视代码被移除了，只保留了真正的业务逻辑。

从业务类中移除性能监视横切代码后，必须为它找到一个安身之所，InvocationHandler就是横切代码的“安家乐园”。将性能监视横切代码安置在PerformanceHandler中，如代码清单7-6所示。

~~~java
package com.smart.proxy;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

public class PerformanceHandler implements InvocationHandler { // ①实现InvocationHandler
    private Object target;
    public PerformanceHandler(Object object) { // ②target为目标业务类
        this.target = target;
    }
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable { //③
        PerformanceMonitor.begin(target.getClass().getName()+"."+method.getName()); //③-1
        Object obj = method.invoke(target, args); //③-2 通过反射方法调用业务类的目标方法
        PerformanceMonitor.end(); //③-1
        return obj;
    }
}
~~~

③处invoke()方法中粗体所示部分的代码为性能监视的横切代码，我们发现，横切代码只出现一次，而不是像原来那样散落各处。③-2处的method.invoke()语句通过Java反射机制间接调用目标对象的方法，这样InvocationHandler的invoke()方法就将横切逻辑代码(③-1)和业务类方法的业务逻辑代码（③-2）编织到一起，所以，可以将InvocationHandler看成一个编织器。下面对这段代码作进一步的说明。

首先实现InvocationHandler接口，该接口定义了一个invoke(Object proxy, Method method, Object[] args)方法，其中，proxy是最终生成的代理实例，一般不会用到；method是被代理目标实例的某个具体方法，通过它可以发起目标实例方法的反射调用；args是被代理实例某个方法的入参，在方法反射调用时使用。

其次，在构造函数里通过target传入希望被代理的目标对象，如②处所示；在InvocationHandler接口方法invoke(Object proxy, Method method, Object[] args)里，将目标实例传递给method.invoke()方法，并调用目标实例的方法，如③处所示。

下面通过Proxy结合PerformanceHandler创建ForumService接口的代理实例，如代码清单7-7所示。

~~~java
package com.smart.proxy;
import java.lang.reflect.Proxy;
import org.testng.annotations.*;
public class ForumServiceTest {
    @Test
    public void proxy() {
        //①希望被代理的目标业务类
        ForumService target = new ForumServiceImpl(); 
        //②将目标业务类和横切代码编织到一起
        PerformanceHandler handler = new PerformanceHandler(target); 
        //③根据编织了目标业务类逻辑和性能监视横切逻辑的InvocationHandler实例创建代理实例
        ForumService proxy = (ForumService) Proxy.newProxyInstance(target.getClass().getClassLoader(),
                                                                  target.getClass().getInterfaces(),
                                                                  handler); 
        //④调用代理实例
        proxy.removeForum(10);
        proxy.removeTopic(1012);
    }
}
~~~

上面的代码完成了业务类代码和横切代码的编织工作并生成了代理实例。在②处，让PerformanceHandler将性能监视横切逻辑编织到ForumService实例中，然后在③处，通过Proxy的newProxyInstance()静态方法为编织了业务类逻辑和性能监视逻辑的handler创建一个符合ForumService接口的代理实例。该方法的第一个入参为类加载器；第二个入参为创建代理实例所需实现的一组接口；第三个入参是整合了业务逻辑和横切逻辑的编织器对象。

### 7.2.3 CGLib动态代理

使用JDK创建代理有一个限制，即它只能为接口创建代理实例，这一点可以从Proxy的接口方法newProxyInstance(ClassLoader loader, Class[] interfaces, InvocationHandler h)中看得很清楚：第二个入参interfaces就是需要代理实例实现的接口列表。虽然面向接口编程的思想被很多大师级人物（包括Rod Johnson）所推崇，但在实际开发中，许多开发者也对此深感困惑：难道对一个简单业务表的操作也要老老实实地创建5个类（领域对象类、DAO接口、DAO实现类、Service接口、Service实现类）吗？难道不能直接通过实现类构建程序吗？对于这个问题，很难给出一个孰优孰劣的准确判断，但仍有很多不使用接口的项目也取得了非常好的效果。

对于没有通过接口定义业务方法的类，如何动态创建代理实例呢？JDK动态代理技术显然已经黔驴技穷，CGLib作为一个替代者，填补了这项空缺。

CGLib采用底层的字节码技术，可以为一个类创建子类，在子类中采用方法拦截的技术拦截所有父类方法的调用并顺势织入横切逻辑。下面采用CGLib技术编写一个可以为任何类创建织入性能监视横切逻辑代理对象的代理创建器，如代码清单7-8所示。

~~~java
package com.smart.proxy;
import java.lang.reflect.Method;
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

public class CglibProxy implements MethodInterceptor {
    private Enhancer enhancer = new Enhancer();
    public Object getProxy(Class clazz) {
        enhancer.setSuperclass(clazz); //①设置需要创建子类的类
        enhancer.setCallback(this);
        return enhancer.create(); //②通过字节码技术动态创建子类实例
    }
    public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxy) throws Throwable { //③拦截父类所有方法的调用
        PerformanceMonitor.begin(obj.getClass().getName() + "." + method.getName()); //③-1
        Object result = proxy.invokeSuper(obj, args); //③-2 通过代理类调用父类中的方法
        PerformanceMonitor.end(); //③-1
        return result;
    }
}
~~~

在上面的代码中，用户可以通过getProxy(Class clazz)方法为一个类创建动态代理对象，该代理对象通过扩展clazz实现代理。在这个代理对象中，织入性能监视的横切逻辑。intercept(Object obj, Method method, Object[] args, MtehodProxy proxy)是CGLib定义的Interceptor接口方法，它拦截所有目标类方法的调用。其中，obj表示目标类的实例；method为目标类方法的反射对象；args为方法的动态入参；proxy为代理类实例。

值得一提的是，由于CGLib采用动态创建子类的方式生成代理对象，所以不能对目标类中的final或private方法进行代理。

### 7.2.5 代理知识小结

Spring AOP的底层就是通过使用JDK或CGLib动态代理技术为目标Bean织入横切逻辑的。这里对动态创建代理对象作一个小结。

虽然通过PerformanceHandler或CglibProxy实现了性能监视横切逻辑的动态织入，但这种实现方式存在3个明显需要改进的地方。

- （1）目标类的所有方法都添加了性能监视横切逻辑，而有时这并不是我们所期望的，我们可能只希望对业务类中的某些特定方法添加横切逻辑。 
- （2）通过硬编码的方式指定了织入横切逻辑的织入点，即在目标类业务方法的开始和结束前织入代码。
- （3）手工编写代理实例的创建过程，在为不同类创建代理时，需要分别编写相应的创建代码，无法做到通用。

以上3个问题在AOP中占用重要的地位，因为Spring AOP的主要工作就是围绕以上3点展开的：Spring AOP通过Pointcut（切点）指定在哪些类的哪些方法上织入横切逻辑，通过Advice（增强）描述横切逻辑和方法的具体织入点（方法前、方法后、方法的两端等）。此外，Spring通过Advisor（切面）将Pointcut和Advice组装起来。有了Advisor的信息，Spring就可以利用JDK或CGLib动态代理技术采用统一的方式为目标Bean创建织入切面的代理对象了。

JDK动态代理所创建的代理对象，在Java 1.3下，性能差强人意。虽然在高版本的JDK中动态代理对象的性能得到了很大的提高，但有研究表明，CGLib所创建的动态代理对象的性能依旧比JDK所创建的动态代理对象的性能高不少（大概10倍）。但CGLib在创建代理对象时所花费的时间却比JDK动态代理多（大概8倍）。对于singleton的代理对象或者具有实例池的代理，因为无需频繁地创建代理对象，所以比较适合采用CGLib动态代理技术；反之则适合采用JDK动态代理技术。

## 7.3 创建增强类

Spring使用增强类定义横切逻辑，同时由于Spring只支持方法连接点，增强还包括在方法地哪一点加入横切代码的方位信息，所以增强既包含横切逻辑，又包含部分连接点的信息。

### 7.3.1 增强类型

AOP联盟为增强定义了org.aopalliance.aop.Advice接口，Spring支持5种类型的增强，先来了解一下增强接口继承关系图

~~~mermaid
classDiagram
	class Advice {
		<<aopalliance>>
	}
	class ThrowsAdvice{
		<<spring>>
	}
	class BeforeAdvice{
		<<spring>>
	}
	class MethodBeforeAdvice {
		<<spring>>
	}
	class Interceptor {
		<<aopalliance>>
	}
	class MethodInterceptor {
		<<aopalliance>>
	}
	class IntroductionInterceptor {
		<<aopalliance>>
	}
	class AfterReturningAdvice {
		<<spring>>
	}
	class DynamicIntroductionAdvice {
		<<spring>>
	}
	Advice <|-- ThrowsAdvice
	Advice <|-- BeforeAdvice
	BeforeAdvice <|-- MethodBeforeAdvice
	Advice <|-- Interceptor
	Interceptor <|-- MethodInterceptor
	MethodInterceptor <|-- IntroductionInterceptor
	Advice <|-- AfterReturningAdvice
	Advice <|-- DynamicIntroductionAdvice
	DynamicIntroductionAdvice <|-- IntroductionInterceptor
~~~

带`<<spring>>`标识的接口是Spring所定义的扩展增强接口；带`<<aopalliance>>`标识的接口则是AOP联盟定义的接口。按照增强在目标类方法中的连接点位置，可以分为以下5类。

- 前置增强：org.springframework.aop.BeforeAdvice代表前置增强。因为Spring只支持方法级的增强，所以MethodBeforeAdvice是目前可用的前置增强，表示在目标方法执行前实施增强，而BeforeAdvice是为了将来版本扩展需要而定义的。
- 后置增强：org.springframework.aop.AfterReturningAdvice代表后置增强，表示在目标方法执行后实施增强。
- 环绕增强：org.aopalliance.intercept.MethodInterceptor代表环绕增强，表示在目标方法执行前后实施增强。
- 异常抛出增强：org.springframework.aop.ThrowsAdvice代表抛出异常增强，表示在目标方法抛出异常后实施增强。
- 引介增强：org.springframework.aop.IntroductionInterceptor代表引介增强，表示在目标类中添加一些新的方法和属性。

这些增强接口都有一些方法，通过实现这些接口方法，并在接口方法中定义横切逻辑，就可以将它们织入目标类方法的相应连接点位置。

### 7.3.2 前置增强

#### 2.解剖ProxyFactory

在BeforeAdviceTest中，使用org.springframework.aop.framework.ProxyFactory代理工厂将GreetingBeforeAdvice的增强织入目标类NaiveWaiter中。回想一下，前面介绍的JDK和CGLib动态代理技术是否有一些相似之处？不错，ProxyFactory内部就是使用JDK或CGLib动态代理技术将增强应用到目标类中的。

Spring定义了org.springframework.aop.framework.AopProxy接口，并提供了两个final类型的实现类。

~~~mermaid
classDiagram
	AopProxy <|-- Cglib2AopProxy
	AopProxy <|-- JdkDynamicAopProxy
~~~

其中，Cglib2AopProxy使用CGLib动态代理技术创建代理，而JdkDynamicAopProxy使用JDK动态代理技术创建代理。如果通过ProxyFactory的setInterfaces(Class[] interfaces)方法指定目标接口进行代理，则ProxyFactory使用JdkDynamicAopProxy；如果是针对类的代理，则使用Cglib2AopProxy。此外，还可以通过ProxyFactory的`setOptimize(true)`方法让ProxyFactory启动优化代理方式，这样，针对接口的代理也会使用Cglib2AopProxy。值得注意的一点是，在使用CGLib动态代理技术时，必须引入CGLib类库。

读者可能已经注意到，ProxyFactory通过addAdvice(Advice)方法添加一个增强，用户可以使用该方法添加多个增强。多个增强形成一个增强链，它们的调用顺序和添加顺序一致，可以通过addAdvice(int, Advice)方法将增强添加到增强链的具体位置（第一个位置为0）。

#### 3.在Spring中配置

使用ProxyFactory比直接使用CGLib或JDK动态代理技术创建代理省了很多事，如大家预想的一样，可以通过Spring的配置以“很Spring的方式”声明一个代理，如代码清单7-14所示。

~~~xml
<bean id="greetingAdvice" class="com.smart.advice.GreetingBeforeAdvice"/>
<bean id="target" class="com.smart.advice.NaiveWaiter"/>
<bean id="waiter" class="org.springframework.aop.framework.ProxyFactoryBean"
      p:proxyInterfaces="com.smart.advice.Waiter" ③指定代理的接口，如果是多个接口，请使用list元素
      p:interceptorNames="greetingAdvice"
      p:target-ref="target"/>
~~~

ProxyFactoryBean是FactoryBean接口的实现类，5.9节专门介绍了FactoryBean的功用，它负责实例化一个Bean。ProxyFactoryBean负责为其他Bean创建代理实例，它在内部使用ProxyFactory来完成这项工作。下面进一步了解一下ProxyFactoryBean的几个常用的可配置属性。

- target：代理的目标对象
- proxyInterfaces：代理所要实现的接口，可以是多个接口。该属性还有一个别名属性interfaces。
- interceptorNames：需要织入目标对象的Bean列表，采用Bean的名称指定。这些Bean必须是实现了org.aopalliance.intercept.MethodInterceptor或org.springframework.aop.Advisor的Bean，配置中的顺序对应调用的顺序。
- singleton：返回的代理是否是单实例，默认为单实例。
- optimize：当设置为true时，强制使用CGLib动态代理。对于singleton的代理，我们推荐使用CGLib；对于其他作用域类型的代理，最好使用JDK动态代理。原因是虽然CGLib创建代理时速度慢，但其创建出的代理对象运行效率较高；而使用JDK创建代理的表现正好相反。
- proxyTargetClass：是否对类进行代理（而不是对接口进行代理）。当设置为true时，使用CGLib动态代理。

将proxyTargetClass设置为true后，无须再设置proxyInterfaces属性，即使设置也会被ProxyFactoryBean忽略。

### 7.3.6 引介增强

引介增强是一种比较特殊的增强类型，它不是在目标方法周围织入增强，而是为目标类创建新的方法和属性，所以引介增强的连接点是类级别的，而非方法级别的。通过引介增强，可以为目标类添加一个接口的实现，即原来目标类未实现某个接口，通过引介增强可以为目标类创建实现某接口的代理。这种功能富有吸引力，因为它能够在横向上定义接口的实现方法，思考问题的角度发生了很大的变化。

Spring定义了引介增强接口IntroductionInterceptor，该接口没有定义任何方法，Spring为该接口提供了DelegatingIntroductionInterceptor实现类。一般情况下，通过扩展该实现类定义自己的引介增强类。

## 7.4 创建切面

Spring通过org.springframework.aop.Pointcut接口描述切点，Pointcut由ClassFilter和MathodMatcher构成，它通过ClassFilter定位到某些特定类上，通过MethodMatcher定位到某些特定方法上，这样Pointcut就拥有了描述某些类的某些特定方法的能力。可以简单地用SQL复合查询条件来理解Pointcut的功用。Pointcut类关系图如下所示

~~~mermaid
classDiagram
	class Pointcut {
		+getClassFilter()
		+getMethodMatcher()
	}
	class ClassFilter {
		+matches(Class clazz) boolean
	}
	class MethodMatcher {
		+matches(Method m, Class targetClass) boolean
		+isRuntime() boolean
		+matches(Method m, Class targetClass, Object[] args) boolean
	}
	Pointcut ..> ClassFilter
	Pointcut ..> MethodMatcher
~~~

可以看到ClassFilter只定义了一个方法matches(Class clazz)，其参数代表一个被测类，该方法判别被检测的类是否匹配过滤条件。

Spring支持两种方法匹配器：静态方法匹配器和动态方法匹配器。所谓静态方法匹配器，仅对方法名签名（包括方法名和入参类型及顺序）进行匹配；而动态方法匹配器会在运行期检查方法入参的值。静态匹配仅会判别一次，而动态匹配因为每次调用方法的入参都可能不一样，所以每次调用方法都必须判断，因此，动态匹配对性能的影响很大。一般情况下，动态匹配不常使用。方法匹配器的类型由isRuntime()方法的返回值决定，返回false表示是静态方法匹配器，返回true表示是动态方法匹配器。

此外，Spring2.0还支持注解切点和表达式切点，前者通过Java5.0的注解定义切点，而后者通过字符串表达式定义切点，二者都使用AspectJ的切点表达式语言。

### 7.4.1 切点类型

Spring提供了6种类型的切点，下面分别对它们的用途进行介绍。

- 静态方法切点：org.springframework.aop.support.StaticMethodMatcherPointcut是静态方法切点的抽象基类，默认情况下它匹配所有的类。StaticMethodMatcherPointcut包括两个主要的子类，分别是NameMatchMethodPointcut和AbstractRegexpMethodPointcut，前者提供简单字符串匹配方法签名，而后者使用正则表达式匹配方法签名。
- 动态方法切点：org.springframework.aop.support.DynamicMethodMatcherPointcut是动态方法切点的抽象基类，默认情况下它匹配所有的类。
- 注解切点：org.springframework.aop.support.annotation.AnnotationMatchingPointcut实现类表示注解切点。使用AnnotationMatchingPointcut支持在Bean中直接通过Java 5.0注解标签定义的切点。
- 表达式切点：org.springframework.aop.support.ExpressionPointcut接口主要是为了支持AspectJ切点表达式语法而定义的接口。
- 流程切点：org.springframework.aop.support.ControlFlowPointcut实现类表示控制流程切点。ControlFlowPointcut是一种特殊的切点，它根据程序执行堆栈的信息查看目标方法是否由某一个方法直接或间接发起调用，以此判断是否为匹配的连接点。
- 复合切点：org.springframework.aop.support.ComposablePointcut实现类是为创建多个切点而提供的方便操作类。它所有的方法都返回ComposablePointcut类，这样就可以使用链接表达式对切点进行操作，形如：`Pointcut pc = new ComposablePointcut().union(classFilter).intersection(methodMatcher).intersection(pointcut)`。

本章仅对其中的4类切点进行讲解，注解切点和表达式切点将在下一章讲解。

### 7.4.2 切面类型

由于增强既包含横切代码，又包含部分连接点信息（方法前、方法后主方位信息），所以可以仅通过增强类生成一个切面。但切点仅代表目标类连接点的部分信息（类和方法的定位），所以仅有切点无法制作出一个切面，必须结合增强才能制作出切面。Spring使用org.springframework.aop.Advisor接口表示切面的概念，一个切面同时包含横切代码和连接点信息。切面可以分为3类：一般切面、切点切面和引介切面，可以通过Spring所定义的切面接口清楚地了解切面的分类。

- Advisor：代表一般切面，仅包含了一个Advice。因为Advice包含了横切代码和连接点信息，所以Advice本身就是一个简单的切面，只不过它代表的横切的连接点是所有目标类的所有方法，因为这个横切面太宽泛，所以一般不会直接使用。
- PointcutAdvisor：代表具有切点的切面，包含Advice和Pointcut两个类，这样就可以通过类、方法名及方法方位等信息灵活地定义切面的连接点，提供更具适用性的切面。
- IntroductionAdvisor：代表引介切面。7.3.6节介绍了引介增强类型，引介切面是对应引介增强的特殊的切面，它应用于类层面上，所以引介切点使用ClassFilter进行定义。

~~~mermaid
classDiagram
	class Advisor {
		+getAdvice() Advice
		+isPerInstance() boolean
	}
	class PointcutAdvisor {
		+getPointcut() Pointcut
	}
	class IntroductionAdvisor {
		+getClassFilter() ClassFilter
	}
	Advice <.. Advisor
	Advisor <|-- PointcutAdvisor
	Advisor <|-- IntroductionAdvisor
	PointcutAdvisor ..> Pointcut
	IntroductionAdvisor ..> ClassFilter
~~~

下面再来看一下PointcutAdvisor的主要实现类体系

~~~mermaid
classDiagram
	PointcutAdvisor <|.. AbstractPointcutAdvisor
	AbstractPointcutAdvisor <|-- AbstractGenericPointcutAdvisor
	AbstractPointcutAdvisor <|-- AspectJPointcutAdvisor
	AbstractPointcutAdvisor <|-- StaticMethodMatcherPointcutAdvisor
	AbstractGenericPointcutAdvisor <|-- DefaultPointcutAdvisor
	AbstractGenericPointcutAdvisor <|-- NameMatchMethodPointcutAdvisor
	AbstractGenericPointcutAdvisor <|-- RegexpMethodPointcutAdvisor
	AbstractGenericPointcutAdvisor <|-- AspectJExpressionPointcutAdvisor
~~~

PointcutAdvisor主要有6个具体的实现类，分别介绍如下。

- DefaultPointcutAdvisor：最常用的切面类型，它可以通过任意Pointcut和Advice定义一个切面，唯一不支持的是引介的切面类型，一般可以通过扩展该类实现自定义的切面。
- NameMatchMethodPointcutAdvisor：通过该类可以定义按方法名定义切点的切面。
- RegexpMethodPointcutAdvisor：对于按正则表达式匹配方法名进行切点定义的切面，可以通过扩展该实现类进行操作。RegexpMethodPointcutAdvisor允许用户以正则表达式串定义方法匹配的切点，其内部通过JdkRegexpMethodPointcut构造出正则表达式方法名切点。
- StaticMethodMatcherPointcutAdvisor：静态方法匹配器切点定义的切面，默认情况下匹配所有的目标类。
- AspectJExpressionPointcutAdvisor：用于AspectJ切点表达式定义切点的切面。
- AspectJPointcutAdvisor：用于AspectJ语法定义切点的切面。

这些Advisor的实现类都可以在Pointcut中找到对应物，实际上，它们都是通过扩展对应的Pointcut实现类并实现PointcutAdvisor接口进行定义的。如StaticMethodMatcherPointcutAdvisor扩展StaticMethodMatcherPointcut类并实现PointcutAdvisor接口。此外，Advisor都实现了org.springframework.core.Ordered接口，Spring将根据Advisor定义的顺序决定织入切面的顺序。

## 7.5 自动创建代理

在前面所有的例子中，都通过ProxyFactoryBean创建织入切面的代理，每个需要被代理的Bean都需要使用一个ProxyFactoryBean进行配置，虽然可以使用父子`<bean>`进行改造，但还是很麻烦。对于小型系统，可以将就使用，但对于由拥有众多需要代理Bean的系统，原来的配置显然不尽如人意。

幸运的是，Spring提供了自动代理机制，让容器自动生成代理，把开发人员从烦琐的配置工作中解放出来。在内部，Spring使用BeanPostProcessor自动完成这项工作。

### 7.5.1 实现类介绍

这些基于BeanPostProcessor的自动代理创建器的实现类，将根据一些规则自动在容器实例化Bean时为匹配的Bean生成代理实例。这些代理创建器可以分为3类。

- 基于Bean配置名规则的自动代理创建器：允许为一组特定配置名的Bean的自动创建代理实例的代理创建器，实现类为BeanNameAutoProxyCreator。
- 基于Advisor匹配机制的自动代理创建器：它会对容器中所有的Advisor进行扫描，自动将这些切面应用到匹配的Bean中（为目标Bean创建代理实例），实现类为DefaultAdvisorAutoProxyCreator。
- 基于Bean中AspectJ注解标签的自动代理创建器：为包含AspectJ注解的Bean自动创建代理实例，实现类为AnnotationAwareAspectJAutoProxyCreator。

~~~mermaid
classDiagram
	ProxyConfig <|-- AbstractAutoProxyCreator
	BeanPostProcessor <|-- InstantiationAwareBeanPostProcessor
	InstantiationAwareBeanPostProcessor <|.. AbstractAutoProxyCreator
	AbstractAutoProxyCreator <|-- AbstractAdvisorAutoProxyCreator
	AbstractAdvisorAutoProxyCreator <|-- AspectJAwareAdvisorAutoProxyCreator
	AspectJAwareAdvisorAutoProxyCreator <|-- AnnotationAwareAspectJAutoProxyCreator
	AbstractAutoProxyCreator <|-- BeanNameAutoProxyCreator
	BeanNameAutoProxyCreator <|-- DefaultAdvisorAutoProxyCreator
~~~

可以清楚地看到所有的自动代理创建器类都实现了BeanPostProcessor，在容器实例化Bean时，BeanPostProcessor将对它进行加工处理，所以，自动代理创建器有机会对满足匹配规则的Bean自动创建代理对象。

# 第8章 基于@AspectJ和Schema的AOP

## 8.3 着手使用@AspectJ

### 8.3.3 如何通过配置使用@AspectJ切面

虽然可以通过编程的方式织入切面，但在一般情况下，都是Spring的配置完成切面织入工作的。

~~~xml
<!-- ①目标Bean -->
<bean id="waiter" class="com.smart.NaiveWaiter" />
<!-- ②使用了@AspectJ注解的切面类 -->
<bean class="com.smart.aspectj.example.PreGreetingAspect" />
<!-- ③自动代理创建器，自动将@AspectJ注解切面类织入目标Bean中 -->
<bean class="org.springframework.aop.aspectj.annotation.AnnotationAwareAspectJAutoProxyCreator"/>
~~~

7.5.1节介绍了几个自动代理创建器，其中AnnotationAwareAspectJAutoProxyCreator能够将@AspectJ注解切面类自动织入目标Bean中。在这里，PreGreetingAspect是使用@AspectJ注解描述的切面类，而NaiveWaiter是匹配切点的目标类。

如果使用基于Schema的aop命名空间进行配置，那么事情就更简单了，如下：

~~~xml
<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop" ①
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
                           http://www.springframework.org/schema/aop ②
                           http://www.springframework.org/schema/aop/spring-aop-4.0.xsd">
	<!-- ③基于@AspectJ切面的驱动器 -->
    <aop:aspectj-autoproxy/>
    <bean id="waiter" class="com.smart.NaiveWaiter"/>
    <bean class="com.smart.aspectj.example.PreGreetingAspect"/>
</beans>
~~~

首先在配置文件中引入aop命名空间，如①和②处所示；然后通过aop命名空间的`<aop:aspectj-autoproxy/>`自动为Spring容器中那些匹配@AspectJ切面的Bean创建代理，完成切面织入。当然，Spring在内部依旧采用AnnotationAwareAspectJAutoProxyCreator进行自动代理的创建工作，但具体的实现细节已经被`<aop:aspectj-autoproxy/>`隐藏起来。

`<aop:aspectj-autoproxy/>`有一个proxy-target-class属性，默认为false，表示使用JDK动态代理技术织入增强；当配置为`<aop:aspectj-autoproxy proxy-target-class="true"/>`时，表示使用CGLib动态代理技术织入增强。不过即使proxy-target-class设置为false，如果目标类没有声明接口，则Spring将自动使用CGLib动态代理。

## 8.4 @AspectJ语法基础

@AspectJ使用Java 5.0注解和正规的AspectJ的切点表达式语言描述切面 ，由于Spring只支持方法的连接点，所以Spring仅支持部分AspectJ的切点语言。本节将学习AspectJ切点表达式语言，以AspectJ5.0版本为准。

### 8.4.1 切点表达式函数

AspectJ 5.0的切点表达式由关键字和操作参数组成，如切点表达式`execution(* greetTo(..))`，execution为关键字，而`* greetTo(..)`为操作参数。在这里，execution代表目标类执行某一方法，而“`* greetTo(..)`”描述目标方法的匹配模式串，二者联合起来表示目标类greetTo()方法的连接点。为了描述方便，将execution()称为函数，而将匹配串“`* greetTo(..)`”称为函数的入参。

Spring支持9个@AspectJ切点表达式函数，它们用不同的方式描述目标类的连接点。根据描述对象的不同，可以大致分为4种类型。

- 方法切点函数：通过描述目标类方法的信息定义连接点。
- 方法入参切点函数：通过描述目标类方法入参的信息定义连接点。
- 目标类切点函数：通过描述目标类类型的信息定义连接点。
- 代理类切点函数：通过描述目标类的代理类的信息定义连接点。

| 类别             | 函数         | 入参           | 说明                                                         |
| ---------------- | ------------ | -------------- | ------------------------------------------------------------ |
| 方法切点函数     | execution()  | 方法匹配模式串 | 表示满足某一匹配模式的所有目标类方法连接点。如`execution(* greetTo(..))`表示所有目标类种的greetTo()方法 |
|                  | @execution() | 方法注解类名   | 表示标注了特定注解的目标类方法连接点。如`@annotation(com.smart.anno.NeedTest)`表示任何标注了@NeedTest注解的目标类方法 |
| 方法入参切点函数 | args()       | 类名           | 通过判别目标类方法运行时入参对象的类型定义指定连接点。如args(com.smart.Waiter)表示所有有且仅有一个按类型匹配于Waiter入参的方法 |
|                  | @args()      | 类型注解类名   | 通过判别目标类方法运行时入参对象的类是否标注特定注解来指定连接点。如@args(com.smart.Monitorable)表示任何这样的一个目标方法：它有一个入参且入参对象的类标注@Monitorable注解 |
| 目标类切点函数   | within()     | 类名匹配串     | 表示特定域下的所有连接点。如`within(com.smart.service.*)`表示com.smart.service包中的所有连接点，即包中所有类的所有方法：而`within(com.smart.service.*Service)`表示在com.smart.service包中所有以Service结尾的类的所有连接点 |
|                  | target()     | 类名           | 假如目标类按类型匹配于指定类，则目标类的所有连接点匹配这个切点。如通过target(com.smart.Waiter)定义的切点、Waiter即Waiter实现类NaiveWaiter中的所有连接点都匹配该切点 |
|                  | @within()    | 类型注解类名   | 假如目标类按类型匹配于某个类A，且类A标注了特定注解，则目标类的所有连接点匹配这个切点。如@within(com.smart.Monitorable)定义的切点，假如Waiter类标注了@Monitorable注解，则Waiter及Waiter实现类NaiveWaiter的所有连接点都匹配这个切点 |
|                  | @target()    | 类型注解类名   | 假如目标类标注了特定注解，则目标类的所有连接点都匹配该切点。如`@target(com.smart.Monitorable)`，假如NaiveWaiter标注了@Monitorable，则NaiveWaiter的所有连接点都匹配这个切点 |
| 代理类切点函数   | this()       | 类名           | 代理类按类型匹配于指定类，则被代理的目标类的所有连接点都匹配该切点。这个函数比较难以理解，这里暂不举例，留待后面详解 |

@AspectJ还有call()、initialization()、preinitialization()、staticinitialization()、get()、set()、handler()、adviceexecution()、withincode()、cflow()、cflowbelow()、if()、@this()及@withincode()等函数，这些函数在Spring中不能使用，否则会抛出IllegalArgumentException异常。在不特别声明的情况下，本书所讲的@AspectJ函数均指前表所列的9个函数。

### 8.4.2 在函数入参中使用通配符

有些函数的入参可以接收通配符，@AspectJ支持3种通配符。

- `*`：匹配任意字符，但它只能匹配上下文中的一个元素。
- `..`：匹配任意字符，可以匹配上下文中的多个元素，但在表示类时，必须和`*`联合使用，而在表示入参时则单独使用。
- `+`：表示按类型匹配指示类的所有类，必须跟在类名后面，如com.smart.Car+。继承或扩展指定类的所有类，同时还包括指定类本身。

@AspectJ函数按其是否支持通配符及支持的程度，可以为以下3类。

- 支持所有通配符：execution()和within()，如`within(com.smart.*)`、`within(com.smart.service..*.*Service+)`等。
- 仅支持“+”通配符：args()、this()和target()，如args(com.smart.Waiter+)、target(java.util.List+)等。虽然这3个函数可以支持“+”通配符，但其意义不大，因为对于这些函数来说，使用和不使用“+”都是一样的，如target(com.smart.Waiter+)和target(com.smart.aspectj.Waiter)是等价的。
- 不支持通配符：@args()、@within()、@target()和@Annotation()。

此外，args()、this()、target()、@args()、@within()、@target()和@annotation()这7个函数除了可以指定类名外，也可以指定变量名，并将目标对象中的变量绑定到增强的方法中。关于参数绑定的内容将在8.6节介绍，而函数的其他内容将在8.5节详解。

### 8.4.3 逻辑运算符

切点表达式由切点函数组成，切点函数之间还可以进行逻辑运算，组成复合切点。Spring支持以下切点运算符。

- &&：与操作符，相当于切点的交集运算。如果Spring的XML配置文件中使用切点表达式，由于&是XML特殊字符，所以使用转义字符`&amp;&amp;`表示。为了使用方便，Spring提供了一个等效的运算符“and”。如`within(com.smart..*) and args(String)`表示在com.smart包下所有类（当前包及子孙包）拥有一个String入参的方法。
- ||：或操作符，相当于切点的并集运算，or是等效的操作符。如`within(com.smart..*) || args(String)`表示在com.smart包下所有的方法，或者所有拥有一个String入参的方法。
- ！：非操作符，相当于切点的反集运算，not是等效的操作符。如`!within(com.smart..*)`表示所有不在com.smart包下的方法。

在标准的@AspectJ中并不提供and、or和not操作符，它们是Spring为了在XML配置文件中方便定义切点表达式而特意添加的等价操作符。有意思的是，和一般的语法表达不一样，在Spring中使用and、or和not操作符时，允许不在前后添加空格，如`within(com.smart..*)andnotargs(String)`和`within(com.smart..*) and not args(String)`拥有相同的效果。虽然Spring接受这种表示方式，但为了保证程序的可读性，最好还是采用传统的习惯，在操作符的前后添加空格。

> **提示**
>
> 如果not位于切点表达式的开头，则必须在开头添加一个空格，否则将产生解析错误。这应该是Spring解析的一个Bug，在表达式开头添加空格后则可以通过解析。

### 8.4.4 不同增强类型

第7章使用不同的接口描述各种增强类型，@AspectJ也为各种增强类型提供了不同的注解类，它们位于`org.aspectj.lang.annotation.*`包中。这些注解类拥有若干个成员，可以通过这些成员完成定义切点信息、绑定连接点参数等操作。此外，这些注解的存留期限都是RetentionPolicy.RUNTIME，标注目标都是ElementType.METHOD。下面逐一学习@AspectJ所提供的几个增强注解。

#### 1.@Before

前置增强，相当于BeforeAdvice。Before注解类拥有两个成员。

- value：该成员用于定义切点。
- argNames：由于无法通过Java反射机制获取方法入参名，所以如果在Java编译时未启用调试信息，或者需要在运行期解析切点，就必须通过这个成员指定注解所标注增强方法的参数名（注意二者名字必须完全相同），多个参数名用逗号分隔。

#### 2.@AfterReturning

后置增强，相当于AfterReturningAdvice。AfterReturning注解类拥有4个成员。

- value：该成员用于定义切点。
- pointcut：表示切点的信息。如果显式指定pointcut值，那么它将覆盖value的设置值，可以将pointcut成员看作value的同义词。
- returning：将目标对象方法的返回值绑定给增强的方法。
- argNames：如前所述。

#### 3.@Around

环绕增强，相当于MethodInterceptor。Around注解类拥有两个成员。

- value：该成员用于定义切点。
- argNames：如前所述。

#### 4.@AfterThrowing

抛出增强，相当于ThrowsAdvice。AfterThrowing注解类拥有4个成员。

- value：该成员用于定义切点。
- pointcut：表示切点的信息。如果显式指定pointcut值，那么它将覆盖value的设置值。可以将pointcut成员作为value的同义词。
- throwing：将抛出的异常绑定到增强方法中。
- argNames：如前所述。

#### 5.@After

Final增强，不管是抛出异常还是正常退出，该增强都会得到执行。该增强没有对应的增强接口，可以把它看成ThrowsAdvice和AfterReturningAdvice的混合物，一般用于释放资源，相当于try{}finally{}的控制流。After注解类拥有两个成员。

- value：该成员用于定义切点。
- argNames：如前所述。

#### 6.@DeclareParents

引介增强，相当于IntroductionInterceptor。DeclareParents注解类拥有两个成员。

- value：该成员用于定义切点，它表示在哪个目标类上添加引介增强。
- defaultImpl：默认的接口实现类。

## 8.5 切点函数详解

### 8.5.1 @annotation()

@annotation表示标注了某个注解的所有方法。

### 8.5.2 execution()

execution()是最常用的切点函数，其语法如下：

~~~
execution(<修饰符模式>?<返回类型模式><方法名模式>(<参数模式>)<异常模式>?)
~~~

除了返回类型模式、方法名模式和参数模式外，其他项都是可选的。与其直接讲解该方法的使用规则，还不如通过一个个具体的例子来理解。下面给出各种使用execution()函数的实例。

#### 1.通过方法签名定义切点

- `execution(public * *(..))`：匹配所有目标类的public方法，但不匹配SmartSeller和protected void showGoods()方法。第一个`*`代表返回类型；第二个`*`代表方法名；而`..`代表任意入参的方法。
- `execution(* *To(..))`：匹配目标类所有以To为后缀的方法，它匹配NaiveWaiter类和NaughtyWaiter的greetTo()和serveTo()方法。第一个`*`代表返回类型；而`*To`代表任意以To为后缀的方法。

#### 2.通过类定义切点

- `execution(* com.smart.Waiter.*(..))`：匹配Waiter接口的所有方法，它匹配NaiveWaiter和NaughtyWaiter类的greetTo()和serveTo()方法。第一个`*`代表返回任意类型：`com.smart.Waiter.*`代表Waiter接口中的所有方法。
- `execution(* com.smart.Waiter+.*(..))`：匹配Waiter接口及其所有实现类的方法，它不但匹配NaiveWaiter和NaughtyWaiter类的greetTo()和serveTo()这两个Waiter接口定义的方法，同时还匹配NaiveWaiter#smile()和NaughtyWaiter#joke()这两个不在Waiter接口中定义的方法。

#### 3.通过类包定义切点

在类名模式串中，“`.*`”表示包下的所有类，而“`..*`”表示包、子孙包下的所有类。

- `execution(* com.smart.*(..))`：匹配com.smart包下所有类的所有方法。
- `execution(* com.smart..*(..))`：匹配com.smart包、子孙包下所有类的所有方法。当“`..`”出现在类名中时，后面必须跟“`*`”，表示包、子孙包下所有类。
- `execution(* com..*.*Dao.find*(..))`：匹配包名前缀为com的任何包下类名后缀为Dao的方法，方法名必须以find为前缀。

#### 4.通过方法入参定义切点

切点表达式中的方法入参部分比较复杂，可以使用“`*`”和“`..`”通配符。其中，“`*`”表示任意类型的参数；而“`..`”表示任意类型的参数且参数个数不限。

- `execution(* joke(String,int))`：匹配joke(String, int)方法，且joke()方法的第一个入参是String，第二个入参是int。如果方法中的入参类型是java.lang包下的类，则可以直接使用类名；否则必须使用全限定类名。如joke(java.util.List, int)。
- `execution(* joke(String,*))`：匹配目标类中的joke()方法，该方法的第一个入参为String，第二个入参可以是任意类型，如joke(String s1, String s2)和joke(String s1, double d2)都匹配，但joke(String s1,double d2, String s3)不匹配。
- `execution(* joke(String,..))`：匹配目标类中的joke()方法，该方法的第一个入参为String，后面可以有任意个入参且入参类型不限。
- `execution(* joke(Object+))`：匹配目标类中的joke()方法，方法拥有一个入参，且入参是Object类型或该类的子类。如果定义的切点是`execution(* joke(Object))`，则只匹配joke(Object object)，而不匹配joke(String cc)或joke(Client c)。

### 8.5.3 args()和@args()

args()函数的入参是类名，而@args()函数的入参必须是注解类的类名。虽然args()允许在类名后使用“+”通配符，但该通配符在此处没有意义，添加和不添加效果都一样。

#### 1.args()

该函数接受一个类名，表示目标类方法入参对象是指定类（包含子类）时，切点匹配，如下面的例子：

~~~
args(com.smart.Waiter)
~~~

表示运行时入参是Waiter类型的方法，它和`execution(* *(com.smart.Waiter))`的区别在于后者是针对类方法的签名而言的，而前者则针对运行时的入参类型而言。如args(com.smart.Waiter)既匹配addWaiter(Waiter waiter)，又匹配addNaiveWaiter(NaiveWaiter naiveWaiter)；而`execution(* *(com.smart.Waiter))`只匹配addWaiter(Waiter waiter)。实际上，args(com.smart.Waiter)等价于`execution(* *(com.smart.Waiter+))`,当然也等价于`args(com.smart.Waiter+)`。

#### 2.@args()

该函数接收一个注解类的类名，当方法的运行时入参对象标注了指定的注解时，匹配切点。这个切点函数的匹配规则不太容易理解，通过下图8-4对此进行详细讲解。

~~~mermaid
graph BT
	m[标注了M注解]-->T2((T2))
	T3((T3)) --> T2
	切面-->T2
	切面-->T3
	方法签名入参类型为fun.T1_t. --> T1
	T2 --> T1((T1))
	T1 --> T0((T0))
~~~

T0、T1、T2、T3具有上图8-4所示的继承关系，假设目标类方法的签名为fun(T1 t)，它的入参为T1，而切面的切点定义为@args(M)，T2类标注了@M。当fun(T1 t)的传入对象是T2或T3时，方法匹配@args(M)声明所定义的切点。

假设方法签名是fun(T1 t)，入参为T1，而标注@M的类是T0，当funt(T1 t)传入T1、T2、T3的实例时，均不匹配切点@args(M)。

在类的继承树中，①处为方法签名中入参类型在类继承树中的位置，称之为入参类型点；而②处为标注了@M注解的类在类继承树中的位置，称之为注解点。判断方法在运行时是否匹配@args(M)切点，可以根据①和②在类继承树中的相同位置来判别。

（1）如果在类继承树中注解点②高于入参类型点①，则该目标方法不可能匹配切点@args(M)。

（2）如果在类继承树中注解点②低于入参类型点①，则注解点所在类及其子孙类作为方法入参时，该方法匹配切点@args(M)。

### 8.5.4 within()

通过类匹配模式串声明切点，within()函数定义的连接点是针对目标类而言的，而非针对运行期对象的类型而言，这一点和execution()是相同的。但和execution()函数不同的是，within()所指定的连接点最小范围只能是类，而execution()所指定的连接点可以大到包，小到方法入参。所以从某种意义上说，execution()函数的功能涵盖了within()函数的功能。within()函数的语法如下：

~~~
within(<类匹配模式>)
~~~

形如within(com.smart.NaiveWaiter)，是within()函数所能表达的最小粒度。如果试图用within()匹配方法级别的连接点，如`within(com.smart.NaiveWaiter.greet*)`，那么将会产生解析错误。

## 8.7 基于Schema配置切面

如果读者的项目不能使用Java 5.0，那么就无法使用基于@AspectJ注解的切面。但是使用AspectJ切点表达式的大门依旧向我们敞开着，因为Spring提供了基于Schema配置的方法，它完全可以替代基于@AspectJ注解声明切面的方式。

这是很容易理解的，因为基于@AspectJ注解的切面，本质上是将切点、增强类型的信息使用注解进行描述，现在把这两个信息移到Schema的XML配置文件中，只是配置信息所在的地方不一样，表达的信息可以完全相同。XML和注解，做的事同一件事，只是方法形式不同而已。

使用基于Schema的切面定义后，切点、增强类型的注解信息从切面类中剥离出来，原来的切面类也就蜕变为真正意义的POJO。

### 8.7.1 一个简单切面的配置

首先来配置一个基于Schema的切面，它使用了aop命名空间。为了更准确地了解整个配置文件的全貌，给出一个结构上完整的切面示例，如代码清单8-15所示。

~~~xml
<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
                           http://www.springframework.org/schema/aop
                           http://www.springframework.org/schema/aop/spring-beans-4.0.xsd">
	<aop:config proxy-target-class="true">
    	<aop:aspect ref="adviceMethods"> <!-- ① 引用④处的adviceMethods -->
            <aop:before pointcut="target(com.smart.NaiveWaiter) and execution(* greetTo(..))" ② 声明切点表达式
                        method="preGreeting"/> <!-- ③ 增强方法使用adviceMethods Bean中的preGreeting方法 -->
        </aop:aspect>
    </aop:config>
    
    <bean id="adviceMethods" class="com.smart.schema.AdviceMethods" /> <!-- ④增强方法所在的Bean -->
    <bean id="naiveWaiter" class="com.smart.NaiveWaiter" />
    <bean id="naughtyWaiter" class="com.smart.NaughtyWaiter" />
</beans>
~~~

使用一个`<aop:aspect>`元素标签定义切面，其内部可以定义多个增强。在`<aop:config>`元素中可以定义多个切面。在①处，切面引用了adviceMethods Bean，该Bean是增强方法所在的类。提供`<aop:before>`声明了一个前置增强，并通过pointcut属性定义切点表达式，切点表达式的语法和@AspectJ中所用的语法完全相同，由于&&在XML中使用不便，所以一般用and操作符代替之。③处通过method属性指定增强的方法，该方法应该是adviceMethods Bean中的方法。

`<aop:config>`拥有一个proxy-target-class属性，当设置为true时，表示其中声明的切面均使用CGLib动态代理技术；当设置为false时，使用Java动态代理技术。一个配置文件可以同时定义多个`<aop:config>`，不同的`<aop:config>`可以采取不同的代理技术。

AdviceMethods时增强方法所在的类，它是一个普通的Java类，没有任何特殊的地方。

通过以下代码测试这个使用Schema配置的切面：

~~~java
String configPath = "com/smart/schema/beans.xml";
ApplicationContext ctx = new ClassPathXmlApplicationContext(configPath);
Waiter naiveWaiter = (Waiter)ctx.getBean("naiveWaiter");
Waiter naughtyWaiter = (Waiter)ctx.getBean("naughtyWaiter");
naiveWaiter.greetTo("john");
naughtWaiter.greetTo("Tom");
~~~

### 8.7.2 配置命名切点

在代码清单8-15的②处通过pointcut属性声明的切点是匿名切点，不能被其他增强或其他切面引用。Spring提供了命名切点的配置方式，如代码清单8-16所示。

~~~xml
<aop:config proxy-target-class="true">
	<aop:aspect ref="adviceMethods">
    	<aop:pointcut id="greetToPointcut" ①定义切点，该切点命名为greetToPointcut
                      expression="target(com.smart.NaiveWaiter) and execution(* greetTo(..))" />
        <aop:before method="preGreeting" point-ref="greetToPointcut"/> <!-- ②引用切点 -->
    </aop:aspect>
</aop:config>
~~~

在①处，使用`<aop:pointcut>`定义了一个切点，并通过id属性进行了命名；在②处，通过pointcut-ref引用这个命名的切点。和`<aop:before>`一样，除引介增强外，其他任何增强类型的元素都拥有pointcut、pointcut-ref即method这3个属性。

`<aop:pointcut>`如果位于`<aop:aspect>`元素中，则命中切点只能被当前`<aop:aspect>`内定义的元素访问到。为了能被整个`<aop:config>`元素中定义的所有增强访问，必须在`<aop:config>`元素下定义切点。

~~~xml
<aop:config proxy-target-class="true">
    <aop:pointcut id="greetToPointcut" ①当前aop:config下的所有增强均可以访问该切点
                  expression="target(com.smart.NaiveWaiter) and execution(* greetTo(..))" />
    <aop:before method="preGreeting" point-ref="greetToPointcut"/> <!-- ②引用切点 -->
    <aop:aspect ref="adviceMethods">
        <aop:before method="preGreeting" pointcut-ref="greetToPointcut" /> ②
    </aop:aspect>
    <aop:aspect ref="adviceMethods">
        <aop:after method="postGreeting" pointcut-ref="greetToPointcut" /> ③
    </aop:aspect>
</aop:config>
~~~

在①处定义的命名切点分别被②和③处不同的切面增强所访问。如果在`<aop:config>`元素下直接定义`<aop:pointcut>`，则必须保证`<aop:pointcut>`在`<aop:aspect>`之前定义。在`<aop:config>`元素下还可以定义`<aop:advisor>`（后面介绍），三者在`<aop:config>`中的配置有先后顺序的要求：首先是`<aop:pointcut>`，然后是`<aop:advisor>`，最后是`<aop:aspect>`。而在`<aop:aspect>`中定义的`<aop:pointcut>`则没有先后顺序的要求，可以在任何位置定义。可以通过spring-aop-4.0.xsd Schema样式定义文件了解关于config元素的配置规则。

> **实战经验**
>
> Schema样式定义文件比DTD样式定义文件具有更强的文档样式定义能力。但由于Schema样式定义文件使用基于XML的文档样式描述语言定义文档格式，所以样式定义文件本身的内容比较复杂，可读性不高。为了快速理解Spring所提供的Schema样式定义文件（如spring-aop-4.0.xsd等）所描述的文档规则，可以借助一些可视化工具。Altova XMLSpy就是这样一款Schema可视化工具。

### 8.7.3 各种增强类型的配置

基于Schema定义的切面和基于@AspectJ定义的切面内容大抵一致，只是在表现形式上存在差异罢了。在上一节中介绍了前置增强，本节来学习如何通过Schema配置其余的增强类型。

#### 1.后置增强

通过`<aop:after-returning>`配置后置增强。

~~~xml
<aop:config proxy-target-class="true">
	<aop:aspect ref="adviceMethods">
    	<aop:after-returning methods="afterReturning"
                             pointcut="target(com.smart.SmartSeller)" returning="retVal"/>
    </aop:aspect>
</aop:config>
~~~

returning属性必须和增强方法的入参名一致。下面是后置增强对应的方法：

~~~java
package com.smart.schema;
public class AdviceMethods {
    public void afterReturning(int retVal) { // ①增强方法，retVal和配置文件中的returning属性值相同
        ...
    }
}
~~~

如果增强方法不希望接收返回值，将配置处的`<aop:after-returning>`的returning属性和增强方法的对应入参去除即可。

#### 2.环绕增强

通过`<aop:around>`配置环绕增强。

~~~xml
<aop:config proxy-target-class="true">
	<aop:aspect ref="adviceMathods">
    	<aop:around method="aroundMethod"
                    pointcut="execution(* serveTo(..) and within(com.smart.Waiter))"/>
    </aop:aspect>
</aop:config>
~~~

和前面介绍的一样，环绕增强对应的方法，可以将第一个入参声明为ProceedingJoinPoint。

~~~java
package com.smart.schema;
import org.aspectj.lang.ProceedingJoinPoint;
public class AdviceMethods {
    public void aroundMethod(ProceedingJoinPoint pjp) { // ①环绕增强的方法，pjp可以访问到环绕增强的连接点信息
        ...
    }
}
~~~

#### 3.抛出异常增强

通过`<aop:after-throwing>`匹配抛出异常的增强。

~~~xml
<aop:config proxy-target-class="true">
	<aop:aspectj ref="adviceMethods">
    	<aop:after-throwing method="afterThrowingMethod"
                            pointcut="target(com.smart.SmartSeller) and execution(* checkBill(..))"
                            throwing="iae"/>
        <!-- ①通过iae查找增强方法对应名字的入参，进而获取需要增强的连接点的匹配异常类型为IllegalArgumentException -->
    </aop:aspectj>
</aop:config>
~~~

通过throwing属性声明需要绑定的异常对象，指定的异常名必须和增强方法对应的入参名一致。

~~~java
package com.smart.schema;
public class AdviceMethods {
    public void afterThrowingMethod(IllegalArgumentException iae){
        ...
    }
}
~~~

#### 4.Final增强

通过`<aop:after>`配置Final增强。

~~~xml
<aop:config proxy-target-class="true">
	<aop:aspect ref="adviceMethods">
    	<aop:after method="afterMethod"
                   pointcut="execution(* com..*.Waiter.greetTo(..))"/>
    </aop:aspect>
</aop:config>
~~~

对应的Final增强方法如下：

~~~java
package com.smart.schema;
public class AdviceMethods {
    public void afterMethod() {
        ...
    }
}
~~~

#### 5.引介增强

通过`<aop:declare-parents>`配置引介增强。引介增强和其他类型的增强不同，它没有method、pointcut和pointcut-ref属性。

~~~xml
<aop:config proxy-target-class="true">
	<aop:aspect ref="adviceMethods">
    	<aop:declare-parents implement-interface="com.smart.Seller" ①要引介实现的接口
                             default-impl="com.smart.SmartSeller" ②默认的实现类
                             types-matching="com.smart.Waiter+" /> ③哪些类需要引介接口的实现
    </aop:aspect>
</aop:config>
~~~

`<aop:declare-parents>`通过implement-interface属性声明要实现的接口，通过default-impl属性指定默认的接口实现类，通过types-matching属性以AspectJ切点表达式语法指定哪些Bean需要引介Seller接口的实现。可以通过以下代码查看到NaiveWaiter已经实施了引介增强：

~~~java
ApplicationContext ctx = new ClassPathXmlApplication(configPath);
Waiter naiveWaiter = (Waiter) ctx.getBean("naiveWaiter");
((Seller)naiveWaiter).sell("Beer","John"); // ①强制类型转换成功
~~~

需要注意的是，虽然`<aop:declare-parents>`没有method属性指定增强方法所在的Bean，但`<aop:aspect ref="adviceMethods">`中的ref属性依然要指定一个增强Bean。

### 8.7.4 绑定连接点信息

基于Schema配置的增强方法绑定连接点信息和基于@AspectJ绑定连接点信息所使用的方式没有什么区别。

- 第一，所有增强类型对应的方法的第一个入参都可以声明为JoinPoint（环绕增强可以声明为ProceedingJoinPoint）访问连接点信息。
- 第二，`<aop:after-returning>`（后置增强）可以通过returning属性绑定连接点方法的返回值，`<aop:after-throwing>`（抛出异常增强）可以通过throwing属性绑定连接点方法所抛出的异常。
- 第三，所有增强类型都可以通过可绑定参数的切点函数绑定连接点方法的入参。

第一、第二种绑定参数的访问已经在上一节进行了介绍，下面通过一个实例来了解第三种绑定参数的方法，如代码清单8-17所示。

~~~xml
<aop:config proxy-target-class="true">
	<aop:aspect ref="adviceMethods">
        <aop:before method="bindParams" ①
                    pointcut="target(com.smart.NaiveWaiter) and args(name, num,..)"/> ②
    </aop:aspect>
</aop:config>
~~~

在②处，在切点表达式中通过args(name,num,..)绑定了连接点的两个参数。

### 8.7.5 Advisor配置

在第7章中学习了Advisor的知识，它是Spring中切面概念的对应物，是切点和增强的复合体，不过它仅包含一个切点和一个增强。在AspectJ中没有对应的等价物，在aop Schema配置样式中，可以通过`<aop:advisor>`配置一个Advisor。通过advice-ref属性引用基于接口定义的增强，通过pointcut定义切点表达式，或者通过pointcut-ref引用一个命名的切点。来看下面的例子：

~~~xml
<aop:config proxy-target-class="true">
	<aop:advisor advice-ref="testAdvice" ① 引用③处的增强
                 pointcut="execution(* com..*.Waiter.greetTo(..))"/> ② 切点表达式
</aop:config>
<bean id="testAdvice"
      class="com.smart.schema.TestBeforeAdvice"/> ③ 前置增强
~~~

## 8.8 混合切面类型

现在我们已经掌握了4种定义切面的方式：

（1）基于@AspectJ注解的方式。

（2）基于`<aop:aspect>`的方式。

（3）基于`<aop:advisor>`的方式。

（4）基于Advisor类的方式。

如果项目采用Java 5.0，则可以优先考虑使用@AspectJ；如果项目只能使用低版本的JDK，则可以考虑使用`<aop:aspect>`；如果正在升级一个基于低版本的JDK的项目，则可以考虑使用`<aop:advisor>`复用已经存在的Advice类；如果项目只能使用低版本的Spring，那么就只能使用Advisor了。此外，值得注意的是，一些切面只能使用基于API的Advisor方式进行构建，如基于ControlFlowPointcut的流程切面。

### 8.8.1 混合使用各种切面类型

Spring虽然提供了4种定义切面的方式，但其底层的实现技术却是一样的，那就是基于CGLib和JDK动态代理，所以在同一个Spring项目中可以混合使用Spring所提供的各种切面定义方式，如代码清单8-19所示。

~~~xml
<bean id="controlFlowAdvisor" ① 使用Advisor API方式实现的流程控制切面
      class="org.springframework.aop.support.DefaultPointcutAdvisor">
	<property name="pointcut">
    	<bean class="org.springframework.aop.support.ControlFlowPointcut">
            <constructor-arg type="java.lang.Class" value="com.smart.advisor.WaiterDelegate"/>
            <constructor-arg type="java.lang.String" value="service"/>
        </bean>
    </property>
    <property>
    	<bean class="com.smart.advisor.GreetingBeforeAdvice"/>
    </property>
</bean>

<aop:aspectj-autoproxy/> ② 使用@AspectJ方式定义的切面

<bean class="com.smart.aspectj.example.PreGreetingAspect"/>

<aop:config proxy-target-class="true"> ③ 使用基于Schema配置方式定义的切面
    <aop:advisor advice-ref="testAdvice" 
                 pointcut="execution(* com..*.Waiter.greetTo(..))"/> ④ 使用aop:advisor配置方式定义的切面
    <aop:aspect ref="adviceMethods"> ⑤ 使用aop:aspect配置方式定义的切面
        <aop:before pointcut="target(com.smart.NaiveWaiter) and execution(* greetTo(..))"
                    method="preGreeting"/>
    </aop:aspect>
</aop:config>
<bean id="adviceMethods" class="com.smart.schema.AdviceMethods"/> ⑥ POJO的增强类
<bean id="testAdvice" class="com.smart.schema.TestBeforeAdvice"/> ⑦ 基于特定增强接口的增强类
~~~

虽然Spring可以混合使用各种切面类型达到统一的效果，但在一般情况下并不会在一个项目中同时使用。毕竟项目开发不是时装表演，也不是多军种联合演习，我们应该尽量根据项目的实际需要采用单一的实现方式，以保证技术的单一性。

### 8.8.2 各种切面类型总结

|                                | @AspectJ                                                     | `<aop:aspect>`                                               | Advisor                              | `<aop:advisor>`                                      |
| ------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------ | ---------------------------------------------------- |
| 前置增强                       | @Before                                                      | `<aop:before>`                                               | MethodBeforeAdvice                   | 同Advisor                                            |
| 后置增强                       | @AfterReturning                                              | `<aop:after-returning>`                                      | AfterReturningAdvice                 | 同Advisor                                            |
| 环绕增强                       | @Around                                                      | `<aop:arounf>`                                               | MethodInterceptor                    | 同Advisor                                            |
| 抛出异常增强                   | @AfterThrowing                                               | `<aop:after-throwing>`                                       | ThrowsAdvice                         | 同Advisor                                            |
| final增强                      | @After                                                       | `<aop:after>`                                                | 无对应接口                           | 同Advisor                                            |
| 引介增强                       | @DeclareParents                                              | `<aop:declare-parents>`                                      | IntroductionInterceptor              | 同Advisor                                            |
| 切点定义                       | 支持AspectJ切点表达式语法，可以通过@Pointcut注解定义切点     | 支持AspectJ切点表达式语法，可以通过`<aop:pointcut>`定义命名切点 | 直接通过基于Pointcut的实现类定义切点 | 基本上和`<aop:aspect>`相同，不过切点函数不能绑定参数 |
| 连接点方法入参绑定             | （1）使用JoinPoint、ProceedingJoinPoint连接点对象；<br />（2）使用切点函数指定参数名绑定 | 同@AspectJ`<aop:after-returning>`                            | 通过增强接口方法入参绑定             | 同Advisor                                            |
| 连接点方法返回值或抛出异常绑定 | （1）在后置增强中，使用@AfterReturning 的 returning成员绑定方法返回值；<br />（2）在抛出异常增强中，使用@AfterThrowing 的 throwing成员绑定方法抛出的异常 | （1）在后置增强中，使用`<aop:after-returning>`的returning属性绑定方法返回值；<br />（2）在抛出异常增强中，使用`<aop:after-throwing>`的throwing属性绑定方法抛出的异常 | 通过增强接口方法入参绑定             | 同Advisor                                            |

可以看出，`<aop:advisor>`其实是`<aop:aspect>`和Advisor的“混血儿”，它的切点表示方式和`<aop:aspect>`相同，增强定义方式则和Advisor相同。连接点方法入参和绑定方式和Advisor一样，通过增强接口方法入参进行调用，所以`<aop:advisor>`在切点表达式中不能使用切点函数绑定连接点方法入参，否则会产生错误。

在内部，Spring使用AspectJExpressionPointcut为@AspectJ、`<aop:aspect>`及`<aop:advisor>`提供具体的切点实现。

# 第9章 Spring SpEL

## 9.1 JVM动态语言

Java是一门强类型的静态语言，所有代码在运行之前都必须进行严格的类型检查并编译成JVM字节码；因此虽然在安全、性能方面得到了保障，但牺牲了灵活性。这个特征就决定了Java在语言层面无法直接进行表达式语句的动态解析。而动态语言恰恰相反，其显著的特点是在程序运行时可以改变程序结构或变量类型。典型的动态语言有Ruby、Python、JavaScript、Perl等。这些动态语言能够被广泛应用于许多领域，得益于其动态、简单、灵活等特性。因为它们无须编译，即可被解释执行。它们可以在运行时动态改变表达式语句，非常适合编写复杂的动态表达式。

虽然目前在JVM中支持很多脚本语言（如JavaScript、Jruby、Jython等），但在使用的时候，还是需要对其进行相应的封装。对于仅仅需要一些简单的表达式需求的场景，使用脚本语言显得有些“笨重”，这也就是下文要重点介绍SpEL表达式的原因。

## 9.2 SpEL表达式概述

Spring动态语言（简称SpEL）是一个支持运行时查询和操作对象图的强大的动态语言。其语法类似于EL表达式，具有诸如显式方法调用和基本字符串模板函数等特性。