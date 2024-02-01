《尚硅谷SpringBoot零基础教程，面试&加薪必会springboot3》2023-05-30

https://www.bilibili.com/video/BV1Es4y1q7Bf

# P1 SpringBoot3 教程简介



# P2 快速入门-特性介绍

SpringBoot 帮我们简单、快速地创建一个独立的、生产级别的 Spring 应用

大多数 SpringBoot 应用只需要编写少量配置即可快速整合 Spring 平台以及第三方技术。

**特性：**

- 快速创建独立 Spring 应用
  - SSM：导包、写配置、启动运行
- 直接嵌入 Tomcat、Jetty 或 Undertow（无需部署 war 包）【Servlet 容器】
  - Linux Java tomcat mysql：war 放到 tomcat 的 webapps 下
  - jar：java 环境，java -jar
- 提供可选的 starter，简化应用整合
  - 场景启动器（starter）：web、json、邮件、oss（对象存储）、异步、定时任务、缓存……
  - 导包一堆，控制好版本
  - 为每一种场景准备了一个依赖：web-starter
- 按需自动配置 Spring 以及第三方库
  - 如果这些场景要使用（生效），这个场景的所有配置都会自动配置好
  - 约定大于配置：每个场景都有很多默认配置
  - 自定义：配置文件中修改几项就可以
- 提供生产级特性：如监控指标、健康检查、外部化配置等
- 无代码生成、无 xml

总结：简化开发，简化配置，简化整合，简化部署，简化监控，简化运维。

# P3 快速入门-示例 Demo

SpringBoot 应用打包插件

```xml
<plugin>
	<groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
</plugin>
```

# P4 快速入门-Demo 小结

## 1、开发流程

1. 创建项目

   ```xml
   <parent>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-parent</artifactId>
       <version>3.0.5</version>
   </parent>
   ```

2. 导入场景

   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-web</artifactId>
   </dependency>
   ```

3. 主程序

   ```java
   @SpringBootApplication
   public class MainApplication {
       public static void main(String[] args) {
           SpringApplication.run(MainApplication.class, args);
       }
   }
   ```

4. 业务

   ```java
   @RestController
   public class HelloController {
       @GetMapping("/hello")
       public String hello() {
           return "Hello, Spring Boot 3!";
   	}
   }
   ```

5. 测试：默认启动访问 localhost:8080

6. 打包

   ```xml
   <plugin>
   	<groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-maven-plugin</artifactId>
   </plugin>
   ```

   `mvn clean package` 把项目打成可执行的 jar 包

   `java -jar demo.jar` 启动项目

## 2、特性小结

1. 简化整合

   导入相关的场景，拥有相关的功能。场景启动器

   - 官方提供的场景
   - 第三方提供场景

2. 简化开发

   无需编写任何配置，直接开发业务

3. 简化配置

   `application.properties`：

   - 集中式管理配置，只需要修改这个文件就可以了
   - 配置基本都有默认值
   - 能写的所有配置都在 https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html

4. 简化部署

   打包为可执行的 jar 包

   Linux 服务器上有 Java 环境

5. 简化运维

   修改配置（外部放一个 application.properties 文件）、监控、健康检查。

# P5 快速入门-Spring Initializer

# P6 细节分析-依赖管理机制

为什么导入 `starter-web` 所有相关依赖都导入进来？

- 开发什么场景，导入什么场景启动器
- maven 依赖传递规则，A-B-C: A 就拥有 B 和 C
- 导入场景启动器。场景启动器自动把所有核心依赖全部导入进来。

为什么版本号都不用写？

- 每个 boot 项目，都有一个父项目 `spring-boot-starter-parent`
- parent 的父项目是 `spring-boot-dependencies`
- 父项目 版本仲裁中心，把所有常见的 jar 的依赖版本都声明好了。

自定义版本号

- 利用 maven 的就近原则
  - 直接在当前项目 properties 标签中声明父项目用的版本属性的 key
  - 直接在导入依赖的时候声明版本 version

第三方 jar 包

- boot 父项目没有管理的需要自行声明

# P7 细节分析-自动配置机制

## 1、初步理解

- 自动配置的 Tomcat、SpringMVC 等

  - 导入场景，容器中就会自动配置好这个场景的核心组件

  - 以前：DispatchServlet、ViewResolver、CharacterEncodingFilter……

  - 现在：自动配置好这些组件

  - 验证：容器中有了什么组件，就具有什么功能

    ```java
    var ioc = SpringApplication.run(MainApplication.class, args);
    String[] names = ioc.getBeanDefinitionNames();
    for (String name: names) {
        System.out.println(name);
    }
    ```

- 默认的包扫描规则

  - @SpringBootApplication 标注的类就是主程序类
  - SpringBoot 只会扫描主程序所在的包及其下面的子包，自动的 component-scan 功能
  - 自定义扫描路径
    - @SpringBootApplication 的 scanBasePackages 属性
    - @ComponentScan 注解直接指定扫描的路径

- 配置默认值

  - 配置文件的所有配置项是和某个类的对象值进行一一绑定的
  - 绑定了配置文件中每一项值的类：配置属性类
  - 比如：
    - ServerProperties 绑定了所有 Tomcat 服务器有关配置
    - MultipartProperties 绑定了所有文件上传相关的配置
    - …… （参照官方文档，或者参照绑定的属性类）

- 按需加载自动配置

  - 导入场景 `spring-boot-starter-web`
  - 场景启动器除了导入相关功能依赖，导入一个 `spring-boot-starter`，是所有 `starter` 的 `starter`，基础核心 starter
  - `spring-boot-starter` 导入了一个包 `spring-boot-autoconfigure`，包里面都是各种场景的 `AutoConfiguration` 自动配置类
  - 虽然全场景的自动配置都在 `spring-boot-autoconfigure` 这个包，但是不是全都开启的。
    - 导入哪个场景就开启哪个自动配置

总结：导入场景启动器、触发 `spring-boot-autoconfigure` 这个包的自动配置生效、容器中就会具有相关的功能

# P8 常用注解-组件注册

@Configuration 这是一个配置类，替代以前的配置文件。配置类本身也是容器中的组件

@SpringBootConfiguration 和前者没区别，为了可读性。

@Import 给容器中放指定的类型的组件，组件的名字默认是全类名。

@Bean 替代以前的 Bean 标签。组件在容器中的名字默认是方法名，可以直接修改注解的值

@Scope 单例、多例

步骤：

1. @Configuration 编写一个配置类
2. 在配置类中，自定义方法给容器中注册，配合 @Bean
3. 或者使用 @Import 导入第三方组件

# P9 常用注解-条件注解

如果注解指定的条件成立，则触发指定行为

@ConditionalOnXxx



@ConditionalOnClass：如果类路径中存在这个类，则触发指定行为

@ConditionalOnMissingClass：如果类路径中不存在这个类，则触发指定行为

@ConditionalOnBean：如果类路径中存在这个 Bean（组件），则触发指定行为

@ConditionalOnMissingBean：如果类路径中不存在这个 Bean（组件），则触发指定行为



放在类级别，如果注解判断生效，则整个配置类才生效

放在方法级别，单独对这个方法进行注解判断

# P10 常用注解-属性绑定

@ConfigurationProperties：声明组件的属性和配置文件哪些前缀开始项进行绑定

@EnableConfigurationProperties：快速注册注解，可以导入第三方写好的组件进行属性绑定

将容器任意组件（Bean）的属性值和配置文件的配置项的值进行绑定

1. 给容器中注册组件（@Component、@Bean）
2. 使用 @ConfigurationProperties 声明组件和配置文件的哪些配置项进行绑定

# P11 自动配置-深入理解自动配置原理

流程：

1. 导入 `starter-web`：导入了 web 开发场景

   1. 场景启动器导入了相关场景的所有依赖：`starter-json`、`starter-tomcat`、`springmvc`
   2. 每个场景启动器都引入了一个 `spring-boot-starter`，核心场景启动器。
   3. 核心场景启动器引入了 `spring-boot-autoconfigure` 包。
   4. `spring-boot-autoconfigure` 里面囊括了所有场景的所有配置。
   5. 只要这个包下的所有类都能生效，那么相当于 SpringBoot 官方写好的整合功能就生效了。
   6. SpringBoot 默认却扫描不到 `spring-boot-autoconfigure` 下写好的所有配置类。（这些配置类给我们做了整合操作）默认只扫描主程序所在的包。

2. 主程序：`@SpringBootApplication`

   1. `@SpringBootApplication` 由三个注解组成 `@SpringBootConfiguration`、`@EnableAutoConfiguration`、`@ComponentScan`

   2. SpringBoot 默认只能扫描自己主程序所在的包及其下面的子包，扫描不到 `spring-boot-autoconfigure` 包中官方写好的配置类

   3. `@EnableAutoConfiguration`：SpringBoot 开启自动配置的核心。

      1. 是由 `@Import(AutoConfigurationImportSelector.class)` 提供功能的：批量给容器中导入组件
      2. SpringBoot 启动会默认加载 124 个配置类
      3. 这 142 个配置类来自于 `spring-boot-autoconfigure` 下 `META-INF/spring/org.springframework.boot.configure.AutoConfiguration.imports` 文件指定的

      项目启动的时候利用 @Import 批量导入组件机制把 `autoconfigure` 包下的 142 个 `xxxAutoConfiguration` 类导入进来（自动配置类）

   4. 按需生效：

      并不是这 142 个自动配置类都能生效

      每个自动配置类，都有条件注解 `@ConditionalOnXxx`，只有条件成立，才能生效

3. `xxxAutoConfiguration` 自动配置类

   1. 给容器中使用 @Bean 放一堆组件
   2. 每个自动配置类都可能有这个注解 `@EnableConfigurationProperties(ServerProperties.class)`，用来把配置文件中配的指定前缀的属性值封装到 `xxxProperties` 属性类中
   3. 以 Tomcat 为例：把服务器的所有配置都是以 `server` 开头的。配置都封装到属性类中
   4. 给容器中放的所有组件的一些核心参数，都来自于 `xxxProperties`。`xxxProperties` 都是和配置文件绑定。

   只需要改配置文件的值，核心组件的底层参数都能修改

4. 写业务，全程无需关系各种整合（底层这些整合好了，而且也生效了）



核心流程：

1. 导入 `starter`，就会导入 `autoconfigure` 包
2. `autoconfigure` 包里面有一个文件 `META-INF/spring/org.springframework.boot.configure.AutoConfiguration.imports`, 里面指定了所有启动要加载的自动配置类
3. @EnableAutoConfiguration 会自动地把上面文件里面写的所有**自动配置类都导入进来**。**xxxAutoConfiguration 是有条件注解进行按需加载**
4. `xxxAutoConfiguration` 给容器中导入一堆组件，组件都是从 `xxxProperties` 中提取属性值
5. `xxxProperties` 又是和**配置文件**进行了绑定

效果：导入 `starter`、修改配置文件，就能修改底层行为。

# P12 整合 Redis 为例-理解如何学好 SpringBoot

1. 理解自动配置原理
   1. 导入 starter -> 生效 xxxAutoConfiguration --> 组件 --> xxxProperties --> 配置文件
2. 理解其他框架底层
3. 可以随时定制化任何组件
   1. 配置文件
   2. 自定义组件



核心：

- 这个场景自动配置导入了哪些组件，我们能不能 Autowired 进来使用
- 能不能通过修改配置改变组件的一些默认参数
- 需不需要自己完全定义这个组件
- **场景定制化**



最佳实战：

- 选场景，导入到项目
  - 官方：starter
  - 第三方：去仓库搜
- 写配置，改配置文件关键项
  - 数据库参数（连接地址、账号密码...）
- 分析这个场景给我们导入了哪些能用的组件
  - 自动装配这些组件进行后续使用
  - 不满意 boot 提供的自动配好的默认组件
    - 定制化
      - 该配置
      - 自定义组件



整合 Redis：

- 选场景： `spring-boot-starter-data-redis`
  - 场景 AutoConfiguration 就是这个场景的自动配置类
- 写配置：
  - 分析到这个场景的自动配置类开启了哪些属性绑定关系
  - `@EnableConfigurationProperties(RedisProperties.class)`
  - 修改 redis 相关的配置
- 分析组件：
  - 分析到 `RedisAutoConfiguration` 给容器放了 `StringRedisTemplate`
  - 给业务代码中自动装配 `StringRedisTemplate`
- 定制化
  - 修改配置文件
  - 自定义组件，自己给容器中放一个 `StringRedisTemplate`

# P13 Yaml配置文件-基本用法

# P14 复杂对象表示-使用 Properties 文件

```properties
person.name=张三
person.age=18
person.birthDay=2010/10/12 12:12:12
person.like=true
person.child.name=李四
person.child.age=12
person.child.birthDay=2018/10/12
person.child.text[0]=abc
person.child.text[1]=def
person.dogs[0].name=小黑
person.dogs[0].age=3
person.dogs[1].name=小白
person.dogs[1].age=2
person.cats.c1.name=小蓝
person.cats.c1.age=3
person.cats.c2.name=小灰
person.cats.c2.age=2
```

# P15 复杂对象表示-使用 yaml 文件

```yaml
person:
	name: 张三
	age: 18
	birth-day: 2010/10/12 12:12:12
	like: true
	child:
		name: 李四
		age: 20
		birth-day: 2018/10/12
		text: ["abc", "def"]
	dogs:
		- name: 小黑
		  age: 3
		- name: 小白
		  age: 2
	cats:
		c1:
			name: 小蓝
			age: 3
		c2: {name: 小灰, age: 2} # 对象也可以用 {} 表示
```

# P16 复杂对象表示-yaml语法细节

- birthDay 推荐写为 birth-day
- 文本
  - 单引号不会转义【\n 则为普通字符串显示】
  - 双引号会转义【\n 会显示为换行符】
- 大文本
  - `|` 开头，大文本写在下层，保留文本格式，换行符正确显示
  - `>` 开头，大文本写在下层，没有缩进则折叠换行符，有缩进就保留原格式
- 多文档合并
  - 使用 `---` 可以把多个 yaml 文档合并在一个文档中。每个文档区依然认为内容独立

# P17 日志-整合原理

日志门面

- JCL (Jakarta Commons Logging)
- **SLF4j (Simple Logging Facade for Java)**
- jboss-logging

日志实现

- Log4j
- JUL (java.util.logging)
- Log4j2
- **Logback**

## 1、简介

1. Spring 使用 `commons-logging` 作为内部日志，但底层日志实现是开放的。可对接其他日志框架
   1. Spring 5 及以后 commons-logging 被 Spring 直接自己写了
2. 支持 `jul`、`log4j2`、`logback`。SpringBoot 提供了默认的控制台输出配置，也可以配置输出为文件。
3. `logback` 是默认使用的。
4. 虽然日志框架很多，但是我们不用担心，使用 SpringBoot 的默认配置就能工作的很好。



SpringBoot 怎么把日志默认配置好的

1. 每个 starter 场景，都会导入一个核心场景 `spring-boot-starter`
2. 核心场景引入了日志的所有功能 `spring-boot-starter-logging`
3. 默认使用了 logback + slf4j 组合作为默认底层日志
4. 日志是系统一启动就要用，`xxxAutoConfiguration` 是系统启动好了以后放好的组件，后来用的。
5. 日志是利用监听器机制配置好的。`ApplicationListener`
6. 日志所有的配置都可以通过修改配置文件实现，以 `logging` 开始的所有配置

# P18 日志-日志格式

## 2、日志格式

默认输出格式：

- 时间和日期：毫秒级精度
- 日志级别：`ERROR`、`WARN`、`INFO`、`DEBUG`、`TRACE`
- 进程 ID
- `---`：消息分隔符
- 线程名：使用[]包含
- Logger 名：通常是产生日志的类名
- 消息：日志记录的内容

注意：Logback 没有 `FATAL` 级别，对应的是 `ERROR`



默认值：参照 `spring-boot` 包 `additional-spring-configuration-metadata.json` 文件

可修改为：`%d[yyyy-MM-dd HH:mm:ss.SSS] %-5level [%thread] %logger{15} ===> %msg%n`

# P19 日志-日志级别

- 由低到高：`ALL, TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF`
  - 只会打印指定级别及以上级别的日志
  - ALL：打印所有日志
  - TRACE：追踪框架详细流程日志，一般不使用
  - DEBUG：开发调试细节日志
  - INFO：关键、感兴趣信息日志
  - WARN：警告但不是错误的信息日志。比如：版本过时
  - ERROR：业务错误日志，比如出现各种异常
  - FATAL：致命错误日志，比如 JVM 系统崩溃
  - OFF：关闭所有日志记录
- 不指定级别的所有类，都使用 root 指定的级别作为默认级别
- SpringBoot 日志默认级别是 INFO



1. 在 `application.properties/yaml` 中配置 `logging.level.<logger-name>=<level>` 指定日志级别
2. `level` 可取值范围：`TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF` 定义在 `LogLevel` 类中
3. root 的 `logger-name` 叫 `root`，可以配置 `logging.level.root=warn`，代表所有未指定日志级别都使用 root 的 warn 级别

# P20 日志-日志分组

```properties
logging.group.xxx=com.aaa,com.bbb,com.ccc
logging.level.xxx=trace
```

SpringBoot 预定义了两个组：

- web
- sql

# P21 日志-文件输出

```properties
# 指定日志文件的路径，日志文件默认名叫 spring.log
logging.file.path=D:\\
# 指定日志文件的名：file.name 和 path 的配置同时存在，只看 file.name
# 1. 只写名字，就生成到当前项目同位置的 demo.log
# 2. 写名字+路径：生成到指定位置的指定文件
logging.file.name=demo.log
```

# P22 日志-归档与切割

> 归档：每天的日志单独存到一个文档中
>
> 切割：每个文件 10 MB，超过大小切割成另外一个文件

1. 每天的日志应该独立分割出来存档。如果使用 `logback`（SpringBoot 默认整合），可以通过 `application.properties/yaml` 文件指定日志滚动规则。
2. 如果是其他日志系统，需要自行配置（添加 `log4j2.xml` 或 `log4j2-spring.xml`）
3. 支持的滚动规则设置如下：

| 配置项                                                 | 描述                                                         |
| ------------------------------------------------------ | ------------------------------------------------------------ |
| `logging.logback.rollingpolicy.file-name-pattern`      | 日志存档的文件名格式（默认值：`${LOG_FILE}.%d{yyyy-MM-dd}.%i.gz`） |
| `logging.logback.rollingpolicy.clean-history-on-start` | 应用启动时是否清除以前存档（默认值：`false`）                |
| `logging.logback.rollingpolicy.max-file-size`          | 存档前，每个日志文件的最大大小（默认值：`10MB`）             |
| `logging.logback.rollingpolicy.total-size-cap`         | 日志文件被删除之前，可以容纳的最大大小（默认值：`0B`）。设置 `1GB` 则磁盘存储超过 1GB 日志后就会删除旧日志文件 |
| `logging.logback.rollingpolicy.max-history`            | 日志文件保存的最大天数（默认值：7）                          |

# P23 日志-自定义日志系统

# P24 Web 开发-自动配置原理

1. 整合 web 场景
2. 引入了 `autoconfigure` 功能
3. `@EnableAutoConfiguration` 注解使用 `@Import(AutoConfigurationImportSelector.class)` 批量导入组件
4. 加载 `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports` 文件中配置的所有组件
5. 绑定了配置文件的一堆配置项
   1. SpringMVC 的所有配置 `spring.mvc`
   2. Web 场景通用配置 `spring.web`
   3. 文件上传配置 `spring.servlet.multipart`
   4. 服务器的配置 `server` 比如：编码方式

# P25 Web 开发-默认效果

默认效果：

1. 包含了 `ContentNegotiatingViewResolver` 和 `BeanNameViewResolver` 组件，方便视图解析
2. 默认的静态资源处理机制：静态资源放在 `static` 文件夹下即可直接访问
3. 自动注册了 `Converter`、`GenericConverter`、`Formatter` 组件，适配常见数据类型转换和格式化需求
4. 支持 `HttpMessageConverters`，可以方便返回 json 等数据类型
5. 注册 `MessageCodesResolver`，方便国际化及错误消息处理
6. 支持静态 `index.html`
7. 自动使用 `ConfigurableWebBindingInitializer`，实现消息处理、数据绑定、类型转化等功能

> 重要：
>
> - 如果要保持 boot mvc 的默认配置，并且自定义更多的 mvc 配置，如：interceptors，formatters，view controller 等。可以使用 `@Configuration` 注解添加一个 `WebMvcConfigurer` 类型的配置类，并不要标注 `@EnableWebMvc`。
> - 如果想保持 boot mvc 的默认配置，但要自定义核心组件实例，比如：`RequestMappingHandlerMapping`、`RequestMappingHandlerAdapter` 或 `ExceptionHandlerExceptionResolver`，给容器中放一个 `WebMvcRegistration` 组件即可
> - 如果想全面接管 Spring MVC，`@Configuration` 标注一个配置类，并加上 `@EnableWebMvc` 注解，实现 `WebMvcConfigurer` 接口

最佳实践：

三种方式

|          |                                                              |                          |                                                         |
| -------- | ------------------------------------------------------------ | ------------------------ | ------------------------------------------------------- |
| 全自动   | 直接编写控制器逻辑                                           |                          | 全部使用自动配置默认效果                                |
| 手自一体 | `@Configuration` + 配置 `WebMvcConfigurer` + 配置 `WebMvcRegistrations` | 不要标注 `@EnableWebMvc` | 自动配置效果<br />手动设置部分功能<br />定义MVC底层组件 |
| 全手动   | `@Configuration` + 配置 `WebMvcConfigurer`                   | 标注 `@EnableWebMvc`     | 禁用自动配置效果<br />全手动配置                        |

两种模式

1. 前后分离模式：@RestController 响应 JSON 数据
2. 前后不分离模式：@Controller + Thymeleaf 模板引擎

# P26 Web 开发 - WebMvcAutoConfiguration 原理

## 1、生效条件

```java
@AutoConfiguration(after = { DispatcherServletAutoConfiguration.class, TaskExecutionAutoConfiguration.class, ValidationAutoConfiguration.class}) // 在这些自动配置之后
@ConditionalOnWebApplication(type = Type.SERVLET) // 如果是 web 应用就生效，类型 SERVLET、REACTIVE 响应式
@ConditionalOnClass({ Servlet.class, DispatcherServlet.class, WebMvcConfigurer.class})
@ConditionalOnMissingBean(WebMvcConfigurationSupport.class) // 容器中没有这个 Bean，才生效。默认就是没有
@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE + 10) // 优先级
@ImportRuntimeHints(WebResourcesRuntimeHints.class)
public class WebMvcAutoConfiguration {
    ...
}
```

## 2、效果

1. 放了两个 Filter：

   1. `HiddenHttpMethodFilter`：页面表单提交 Rest 请求（GET、POST、PUT、DELETE）
   2. `FormContentFilter`：表单内容 Filter，GET（数据放 URL 后面）、POST（数据放请求体）请求可以携带数据，PUT、DELETE 的请求体数据会被忽略

2. 给容器中放了 `WebMvcConfigurer` 组件，给 SpringMVC 添加各种定制功能

   1. 所有的功能最终会和配置文件进行绑定
      1. WebMvcProperties：`spring.mvc` 配置文件
      2. WebProperties：`spring.web` 配置文件

   ```java
   @Configuration(proxyBeanMethods=false)
   @Import(EnableWebMvcConfiguration.class) // 额外导入了其他配置
   @EnableConfigurationProperties({ WebMvcProperties.class, WebProperties.class })
   @Order(0)
   public static class WebMvcAutoConfigurationAdapter implements WebMvcConfigurer, ServletContextAware {
       ...
   }
   ```

   

## 3、WebMvcConfigurer 接口

提供了配置 SpringMvc 底层的所有组件入口

1. 参数解析器 HandlerMethodArgumentResolver
2. 跨域 CorsRegistry
3. 格式化器 FormatterRegistry
4. 拦截器 InterrceptorRegistry
5. 资源处理器：处理静态资源规则 ResourceHandlerRegistry
6. 返回值处理器 HandlerMethodReturnValueHandler
7. 视图控制器 ViewControllerRegistry
8. 异步支持 AsyncSupportConfigurer
9. 内容协商 ContentNegotiationConfigurer
10. 默认处理 默认接受: / DefaultServletHandlerConfigurer
11. 配置异常解析器 HandlerExceptionResolver
12. 消息转化器 HttpMessageConverter
13. 路径匹配 PathMatchConfigurer
14. 视图解析 ViewResolverRegistry
15. 扩展异常解析器
16. 扩展消息转换器

# P27 Web 开发-静态资源规则【源码分析】

```java
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
    if (!this.resourceProperties.isAddMappings()) {
        logger.debug("Default resource handling disabled");
        return;
    }
    // 1.
    addResourceHandler(registry, this.mvcProperties.getWebjarsPathPattern(),
                       "classpath:/META-INF/resources/webjars/");
    addResourceHandler(registry, this.mvcProperties.getStaticPathPattern(), (registration) -> {
        registration.addResourceLocations(this.resourceProperties.getStaticLocations());
        if (this.servletContext != null) {
            ServletContextResource resource = new ServletContextResource(this.servletContext, SERVLET_LO);
            registration.addResourceLocations(resource);
        }
    });
}
```

1. 规则一：访问 `/webjars/**` 路径就去 `classpath:/META-INF/resources/webjars/` 下找资源
2. 规则二：访问 `/**` 路径就去静态资源默认的四个资源位置找资源
   1. `classpath:/META-INF/resources/`
   2. `classpath:/resources/`
   3. `classpath:/static/`
   4. `classpath:/public/`
3. 规则三：静态资源默认都有缓存规则配置
   1. 所有缓存的设置，直接通过配置文件：`spring.web`
   2. cachePeriod：缓存周期；多久不用找服务器要新的。默认没有，以秒为单位
   3. cacheControl：HTTP 缓存控制
   4. useLastModified：是否使用最后一次修改。

# P29 Web 开发-欢迎页规则【源码分析】

## 5、EnableWebMvcConfiguration 源码

```java
@Configuration(proxyBeanMethods = false)
@EnableConfigurationProperties(WebProperties.class)
public static class EnableWebMvcConfiguration extends DelegatingWebMvcConfiguration implements ResourceLoaderAware {
    ...
}
```

SpringBoot 给容器中放 WebMvcConfigurationSupport 组件。我们如果自己放了 WebMvcConfigurationSupport 组件，Boot 的 WebMvcAutoConfiguration 都会失效

1. `HandlerMapping`：根据请求路径找到哪个 Handler 能处理请求
   1. `WelcomePageHandlerMapping`
      1. 访问 `/**` 路径下的所有请求，都在以上四个静态资源路径下找，欢迎页也一样。
      2. 找 `index.html`：只要静态资源的位置有一个 `index.html` 页面，项目启动默认访问

# P29 Web 开发-Favicon 规则

# P30 Web 开发-HTTP 缓存机制测试

1. `spring.web`：
   1. 配置国际化的区域信息
   2. 静态资源策略（开启、处理链、缓存）

```properties
# 开启静态资源映射规则
spring.web.resources.add-mappings=true
# 设置缓存
spring.web.resources.cache.period=3600
# 缓存详细合并项控制，覆盖 period 配置: 
# 浏览器第一次请求服务器，服务器告诉浏览器此资源缓存 7200 秒，7200 秒以内的所有此资源访问不用发给服务器请求，7200 秒以后发请求给服务器
spring.web.resources.cache.cachecontrol.max-age=7200
# 使用资源 last-modified 时间，来对比服务器和浏览器的资源是否相同没有变化。相同返回 304
spring.web.resources.cache.use-last-modified=true
```

# P31 Web开发-【配置式】自定义静态资源

```properties
spring.web.static-locations=classpath:/a/,classpath:/b/

# 2. `spring.mvc`：
# 自定义 webjars 路径前缀
spring.mvc.webjars-path-pattern=/wj/**
# 静态资源访问路径前缀
spring.mvc.static-path-pattern=/static/**
```

# P32 Web开发-【代码式】WebMvcConfigurer使用

```java
@Configuration
public class MyConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 自动保留以前规则
        // 自己写新的规则
        registry.addResourceHandler("/static/**")
            .addResourceLocations("classpath:/a/", "classpath:/b/")
            .setCacheControl(CacheControl.maxAge(1180, TimeUnit.SECONDS));
    }
}
```



```java
//@EnableWebMvc // 禁用 boot 的默认配置
@Configuration // 这是一个配置类，给容器中放一个 WebMvcConfigurer 组件，就能自定义底层
public class MyConfig {
    @Bean
    public WebMvcConfigurer webMvcConfigurer() {
        @Override
        public void addResourceHandlers(ResourceHandlerRegistry registry) {
            // 自己写
            registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/a/", "classpath:/b/")
                .setCacheControl(CacheControl.maxAge(1180, TimeUnit.SECONDS));
	    }
    }
}
```

## 为什么容器中放一个 WebMvcConfigurer 就能配置底层行为？

1. WebMvcAutoConfiguration 是一个自动配置类，它里面有一个 `EnableWebMvcConfiguration`
2. `EnableWebMvcConfiguration` 继承于 `DelegatingWebMvcConfiguration`，这两个都生效
3. `DelegatingWebMvcConfiguration` 利用 DI 把容器中所有 `WebMvcConfigurer` 注入进来
4. 别人调用 `DelegatingWebMvcConfiguration` 的方法配置底层规则，而它调用所有 `WebMvcConfigurer` 的配置底层方法

# P33 路径匹配

> Spring 5.3 之后加入了更多的请求路径匹配的实现策略；
>
> 以前只支持 `AntPathMatcher` 策略，现在提供了 `PathPatternParser` 策略。并且可以让我们指定到底使用哪种策略。

## 1、Ant 风格路径用法

Ant 风格的路径模式语法具有以下规则：

- `*`：表示任意数量的字符
- `?`：表示任意一个字符。
- `**`：表示任意数量的目录。
- `{}`：表示一个命名的模式占位符
- `[]`：表示字符集合，例如 `[a-z]` 表示小写字母。

注意：Ant 风格的路径模式语法中的特殊字符需要转义，如：

- 要匹配文件路径中的星号，则需要转义为`\\*`
- 要匹配文件路径中的问号，则需要转义为`\\?`

## 2、模式切换

> AntPathMatcher 和 PathPatternParser
>
> - `PathPatternParser` 在 JMH 基准测试下，有 6~8 倍吞吐量提升，降低 30% ~ 40% 空间分配率
> - `PathPatternParser` 兼容 `AntPathMatcher` 语法，并支持更多类型的路径模式
> - `PathPatternParser` “`**`” 多段匹配的支持仅允许在模式末尾使用

```java
@GetMapping("/a*/b?/{p1:[a-f]+}/**")
public String hello(HttpServletRequest request, @PathVariable("p1") String path) {
    log.info("路径变量p1: {}", path);
    // 获取请求路径
    String uri = request.getRequestURI();
    return uri;
}
```

总结:

1. 使用默认的路径匹配规则，是由 `PathPatternParser` 提供的

2. 如果路径中间需要有 `**`，替换成 ant 风格路径

   ```properties
   # 改变路径配置策略：
   # ant_path_matcher 老板策略；
   # path_pattern_parser 新版策略；默认
   spring.mvc.pathmatch.matching-strategy=ant_path_matcher
   ```

# P34 Web开发-内容协商演示

内容协商：一套系统适配多端数据返回

多端内容适配

- JSON
- XML
- 自定义协议数据

## 1、默认规则

SpringBoot 多端内容适配

1. 基于请求头内容协商（默认开启）

   ​	客户端向服务端发送请求，携带 HTTP 标准的 Accept 请求头。

   1. Accept: `application/json`，`text/xml`，`text/yaml`
   2. 服务器根据客户端请求头期望的数据类型进行动态返回

2. 基于请求参数内容协商（需要开启）

   1. 发送请求 `GET /projects/spring-boot?format=json`
   2. 匹配到 `@GetMapping("/projects/spring-boot")`
   3. 根据参数协商，优先返回 json 类型数据【需要开启参数匹配设置】
   4. 发送请求 `GET /projects/spring-boot?format=xml` 优先返回 xml 类型数据

## 2、效果展示

> 请求同一个接口，可以返回 json 和 xml 不同格式数据

1. 引入支持写出 xml 内容依赖

   ```xml
   <dependency>
   	<groupId>com.fastxml.jackson.dataformat</groupId>
       <artifactId>jackson-dataformat-xml</artifactId>
   </dependency>
   ```

2. 标注注解

   ```java
   @JacksonXmlRootElement
   ```

   

## 3、配置协商规则与支持类型

1. 修改内容协商方式

   ```properties
   # 使用参数进行内容协商
   spring.mvc.contentnegotiating.favor-parameter=true
   #自定义参数名，默认为 format
   spring.mvc.contentnegotiating.parameter-name=myparam
   ```

2. 大多数 MediaType 都是开箱即用的。也可以自定义内容类型，如：

   ```properties
   spring.mvc.contentnegotiating.media-types.yaml=text/yaml
   ```

## 4、自定义内容返回

> 增加 yaml 返回支持

```xml
<dependency>
	<groupId>com.fasterxml.jackson.dataformat</groupId>
    <artifactId>jackson-dataformat-yaml</artifactId>
</dependency>
```



# P35 Web 开发-HttpMessageConverter原理

内容协商原理 - HttpMessageConverter

- `HttpMessageConverter` 怎么工作？何时工作？
- 定制 `HttpMessageConverter` 来实现多端内容协商
- 编写 `WebMvcConfigurer` 提供的 `configureMessageConverters` 底层，修改底层的 MessageConverter

## 1、@ResponseBody 由 HttpMessageConverter 处理

> 标注了 @ResponseBody 的返回值 将会由支持它的 HttpMessageConverter 写给浏览器

1. 如果 Controller 方法的返回值标注了 `@ResponseBody` 注解（`@ResponseBody` 由 `HttpMessageConverter` 处理）
   1. 请求进来先到 `DispatchServlet` 的 `doDispatch()` 进行处理
   2. 找到一个 `HandlerAdapter` 适配器。利用适配器执行目标方法
   3. `RequestMappingHandlerAdapter` 来执行，调用 `invokeHandlerMethod()` 来执行目标方法
   4. 目标方法执行之前，准备好两个东西
      1. `HandlerMethodArgumentResolver`：参数解析器，确定目标方法每个参数值
      2. `HandlerMethodReturnValueHandler`：返回值处理器，确定目标方法的返回值该怎么处理
   5. `RequestMappingHandlerAdapter` 里面的 `invokeAndHandle(webRequest, mavContainer)` 真正执行目标方法
   6. 目标方法执行完成，会返回返回值对象
   7. 找到一个合适的返回值处理器 `HandlerMethodReturnValueHandler`
   8. 最终找到 `RequestResponseBodyMethodProcessor` 能处理标注了 `@ResponseBody` 注解的方法
   9. `RequestResponseBodyMethodProcessor` 调用 `writeWithMessageConverters()`，利用 `MessageConverter` 把返回值写出去
2. `HttpMessageConverter` 会先进行内容协商
   1. 遍历所有的 `MessageConverter` 看谁支持这种内容类型的数据
   2. 默认 `MessageConverter` 有如下：
   3. 最终因为要 `json` 所以 `MappingJackson2HttpMessageConverter` 支持写出 json
   4. jackson 用 `ObjectMapper` 把对象写出去

# P36 Web开发-默认HttpMessageConverters配置

## 2、WebMvcAutoConfiguration 提供几种默认 HttpMessageConverters

- `EnableWebMvcConfiguration` 通过 `addDefaultHttpMessageConverters` 添加了默认的 `MessageConverter`，如下：
  - `ByteArrayHttpMessageConverter`：支持字节数据读写
  - `StringHttpMessageConverter`：支持字符串读写
  - `ResourceHttpMessageConverter`：支持资源读写
  - `ResourceRegionHttpMessageConverter`：支持分区资源写出
  - `AllEncompassingFormHttpMessageConverter`：支持表单 xml/json 读写
  - `MappingJackson2HttpMessageConverter`：支持请求响应体 Json 读写

# P37 Web开发-增加 Yaml 内容协商

## WebMvcConfigurationSupport

提供了很多的默认设置

判断系统中是否有相应的类：`ClassUtils.isPresent()`，如果有，就加入相应的 `HttpMessageConverter`



## 1、增加 yaml 返回支持

导入依赖

```xml
<dependency>
	<groupId>com.fasterxml.jackson.dataformat</groupId>
    <artifactId>jackson-dataformat-yaml</artifactId>
</dependency>
```

编写配置

```properties
# 新增一种媒体类型
spring.mvc.contentnegotiation.media-types.yaml=text/yaml
```

增加 `HttpMessageConverter` 组件，专门负责把响应写出为 yaml

```java
@Override // 配置一个能把对象转为 yaml 的 messageConverter
public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
    converters.add(new MyYamlHttpMessageConverter());
}
```

```java
public class MyYamlHttpMessageConverter extends AbstractHttpMessageConverter<Object> {
    private ObjectMapper objectMapper = null;
    
    public MyYamlHttpMessageConverter() {
        // 告诉 SpringBoot 这个 MessageConverter 支持哪种媒体类型
        super(new MediaType("text", "yaml", Charset.forName("UTF-8")));
        YAMLFactory factory = new YAMLFactory()
            .disable(YAMLGenerator.Feature.WRITE_DOC_START_MARKER);
        objectMapper = new ObjectMapper(factory);
    }
    
    @Override
    protected boolean supports(Class<?> clazz) {
        // 只要是对象类型，不是基本类型
        return true;
    }
    
    @Override // @RequestBody
    protected Object readInternal(Class<?> clazz, HttpInputMessage inputMessage) throws IOException, HttpMessageNotReadableException {
        return null;
    }
    
    @Override // @ResponseBody
    protected void writeInternal(Object o, HttpOutputMessage outputMessage) throws IOException, HttpMessageNotWritableException {
        try(OutputStream body = outputMessage.getBody()) {
	        this.objectMapper.writeValue(body, o);
        }
    }
}
```

## 2、思考：如何增加其他

- 配置媒体类型支持
  - `spring.mvc.contentnegotiation.media-types.yaml=text/yaml`
- 编写对应的 `HttpMessageConverter`
- 把 `MessageConverter` 组件加入到底层

# P38 Web开发-Thymeleaf整合

模板引擎页面默认放在 `src/main/resources/templates`

SpringBoot 包含以下模板引擎的自动配置

- FreeMarker
- Groovy
- Thymeleaf
- Mustache

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">

</html>
```



## 1、Thymeleaf 整合

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

自动配置原理

1. 开启了 `org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration` 自动配置
2. 属性绑定在 `ThymeleafProperties` 中，对应配置文件 `spring.thymeleaf` 内容
3. 所有的模板页面默认在 `classpath:/templates` 文件夹下

# P39 Web开发-Thymeleaf 核心语法

## 1、核心语法

`th:xxx`：动态渲染指定的 html 标签属性值、或者 th 指令（遍历、判断等）

- `th:text`：标签体内文本值渲染；会转义

- `th:utext`：标签体内文本值渲染；不会转义 html 标签，真正显示成 html 该有的样子

- `th:属性`：标签指定属性渲染；动态替换任意 html 属性的值

- `th:attr`：标签任意属性渲染

- `th:if`、`th:each`、...：其他 th 指令

- 例如：

  ```html
  <p th:text="${content}">原内容</p>
  <a th:href="${url}">登录</a>
  <img src="../../images/gtvglogo.png" 
       th:attr="src=@{/images/gtvglogo.png},title=#{logo},alt=#{logo}"/>
  ```

表达式：用来动态取值

- `${}`：变量取值；使用 Model 共享给页面的值都可以直接用 $ 取出来
- `@{}`：url 路径
- `#{}`：国际化消息
- `~{}`：片段引用
- `*{}`：变量选择：需要配合 `th:object` 绑定对象

系统工具 & 内置对象：

- `param`：请求参数对象
- `session`：session 对象
- `application`：application 对象
- `#execInfo`：模板执行信息
- `#message`：国际化消息
- `#uris`：uri/url 工具
- `#conversions`：类型转换工具
- `#dates`：日期工具，是 `java.util.Date` 对象的工具类
- `#calendars`：类似 #dates，只不过是 `java.util.Calendar` 对象的工具类
- `#temporals`：JDK 8+ `java.time` API 工具类
- `#numbers`：数字操作工具
- `#strings`：字符串操作
- `#objects`：对象操作
- `#bools`：bool 操作
- `#arrays`：array 工具
- `#lists`：list 工具
- `#sets`：set 工具
- `#maps`：map 工具
- `#aggregates`：集合聚合工具（sum、avg）
- `#ids`：id 生成工具

## 2、语法示例

`||` 拼字符串