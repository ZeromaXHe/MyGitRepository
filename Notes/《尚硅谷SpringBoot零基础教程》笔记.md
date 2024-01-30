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