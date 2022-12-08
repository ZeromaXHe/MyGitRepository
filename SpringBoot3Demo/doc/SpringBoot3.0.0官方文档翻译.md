# 开始

## 1. 介绍 Spring Boot

Spring Boot 帮助你建立可运行的独立的生产级别的基于 Spring 的应用。我们对 Spring 平台和三方库按照自己的约定组合，这样你可以在最少困扰情况下开始开发。大多数 Spring Boot 应用需要非常少的 Spring 配置。

你可以使用 Spring Boot 创建能够直接使用 `java -jar` 启动或更传统的 war 部署的 Java 应用。我们也提供一个运行“Spring 脚本”的命令行工具。

我们主要的目的是：

- 提供一个更快的且广泛适用所有 Spring 开发项目的初始化体验
- 执着于开箱即用但可以在需求开始偏离默认时进行快速调整
- 提供一系列普遍在大量项目（例如内嵌服务器，安全，度量标准，健康监控，和外部化配置）中使用的非功能性特征
- 完全无代码生成且无须 XML 配置

## 2. 系统要求

Spring Boot 3.0.0 要求使用 Java 17 且最高兼容至包括 Java 19。需要 Spring Framework 版本为 6.0.2 及以上。

| 构建工具 | 版本             |
| -------- | ---------------- |
| Maven    | 3.5+             |
| Gradle   | 7.x (7.5 或更高) |

### 2.1 Servlet 容器

Spring Boot 支持下面内嵌 Servlet 容器：

| 名称                                | Servlet 版本 |
| ----------------------------------- | ------------ |
| Tomcat 10.0                         | 5.0          |
| Jetty 11.0                          | 5.1          |
| Undertow 2.2 (Jakarta EE 9 variant) | 5.0          |

你也可以将 Spring Boot 应用部署到任何兼容 Servlet 5.0+ 的容器。

### 2.2 GraalVM Native Images

Spring Boot 应用可以使用 GraalVM 22.3 或更高版本转换为 Native Image。

## 3. 安装 Spring Boot

Spring Boot 可以通过“经典的” Java 开发工具使用或作为命令行工具被安装。无论是哪一种，你需要 Java SDK v17 或更高。

### 3.1 Java 开发的安装指南

你可以像标准 Java 库那样使用 Spring Boot。

# 使用 Spring Boot 开发

这一章介绍更多你应该如何使用 Spring Boot 的细节，包含构建系统、自动配置和如何运行你的应用。我们也会介绍一些 Spring Boot 的最佳实践。虽然 Spring Boot 没有什么特别的（它只是又一个你可以使用的库），但如果遵守一些建议的话，你的开发过程可以更轻松一点。

## 1. 构建系统

强烈建议你选择一个支持依赖管理且可以使用发布到 Maven 中心仓库的制品的构造系统。我们建议你选择 Maven 或 Gradle。用其他的构建系统（例如 Ant）也可以把 Spring Boot 运行起来，但它们不是支持得特别好。

### 1.1 依赖管理

每一个 Spring Boot 的发布版本都提供一个精心选择的它支持的依赖列表。在使用过程中，你不需要在你的构建配置提供这些依赖的版本，因为 Spring Boot 替你管理了。当你升级 Spring Boot 时，这些依赖也一致地被升级。

> 如果你想要的话，也可以指明一个版本覆盖 Spring Boot 的建议。

## 2. 结构化你的代码

Spring Boot 并不需要任何特别的代码结构来运行，但是有一些有助于你的最佳实践。

### 2.1 使用“默认”包

当一个类不包含一个 `package` 声明时，它被认为是在“默认包”中。使用“默认包”普遍不被鼓励且应该避免。它会导致使用 `@ComponentScan`、`@ConfigurationPropertiesScan`、`@EntityScan` 或 `@SpringBootApplication` 注解的 Spring Boot 应用出现特定的问题，因为每个 jar 包中每个类都被读取。

> 我们建议你遵循 Java 建议的包命名规范，并使用倒序的域名（例如 `com.example.project`）

### 2.2 定位主应用类

我们一般建议你将你的主应用类放在一个比其他类层级高的根目录中。`@SpringBootApplication` 注解经常放在你的主类上，并且它隐式地为特定条目定义了一个基础的“搜索包”。例如，如果你在写一个 JPA 应用，`@SpringBootApplication` 注解的类所在的包被用于搜索 `@Entity` 对象。使用一个根包也允许组件扫描只应用于你的项目。

> 如果你不想使用 `@SpringBootApplication`，那么它导入的`@EnableAutoConfiguration` 和 `@ComponentScan` 注解可以定义那个行为，你可以使用它们代替。

## 3. 配置类

Spring Boot 更倾向于使用基于 Java 的配置。虽然可以用 XML 代码使用 `SpringApplication`，但我们普遍建议你首选 `@Configuration` 类。经常地，定义 `main` 方法的类是作为首个 `@Configuration` 的候选者。

> 很多在互联网上发布的 Spring 配置示例使用的是 XML 配置。如果可能的话，请始终尝试使用对应的基于 Java 的配置。搜索 `Enable*` 开头的注解会是一个好的切入点。

### 3.1 导入额外的配置类

你不需要将你的所有 `@Configuration` 放入同一个类。`@Import` 注解能够被导入额外的配置类。另外地，你可以使用 `@ComponentScan` 来自动找到所有 Spring 组件，包括 `@Configuration` 类。

### 3.2 导入 XML 配置

如果你决意必须使用基于 XML 的配置，我们建议你仍然从一个 `@Configuration` 类开始。你可以接着使用 `@ImportResource` 注解来加载 XML 配置文件。

## 4. 自动配置

Spring Boot 自动配置会根据你添加的 jar 依赖来尝试自动配置你的 Spring 应用。例如，如果 `HSQLDB` 在你的 classpath 上，并且你没有手动配置任何数据库连接 bean，那么 Spring Boot 会自动配置一个内存数据库。

你需要通过给你的 `@Configuration` 类添加 `@EnableAutoConfiguration` 或 `@SpringBootApplication` 注解来选择性加入自动配置功能。

> 你应该只加入一个 `@SpringBootApplication` 或 `@EnableAutoConfiguration` 注解。我们通常建议你只给你的主 `@Configuration` 类添加一个。

### 4.1 逐步替换自动配置

自动配置是非侵入式的。在任何时刻，你可以开始定义你自己的配置来替换自动配置的特定部分。例如如果你添加你的 `DataSource` bean，那么默认的嵌入式数据库支持就会失效。

如果你需要查明当前被应用的自动配置是哪个以及为什么，可以使用 `--debug` 开关启动你的应用。这样启用了一些选定的核心日志的 debug 日志，并且记录条件日志到控制台。

### 4.2 禁用特定自动配置类

如果你发现特定的不想生效的自动配置类，可以使用 `@SpringBootApplication` 的 exclude 属性来禁用它们，就像下面例子中展示的这样：

```java
@SpringBootApplication(exclude={DataSourceAutoConfiguration.class})
public class MyApplication {
    
}
```

如果类不在 classpath 上，你可以使用该注解的 `excludeName` 属性，并指明完整的限定名称作为替代。如果你更喜欢使用 `@EnableAutoConfiguration` 而不是 `@SpringBootApplication`，则 `exclude` 和 `excludeName` 也可使用。最后，您还可以使用 `spring.autoconfig.exclude` 属性来控制要排除的自动配置类的列表。

> 你可以在注解级别和使用属性定义排除项。

> 即使自动注解类是 `public` 的，但该类唯一被认为是公共 API 的切面是类的名称，可用于禁用自动配置。这些类的实际内容（如嵌套配置类或 bean 方法）仅供内部使用，我们不建议直接使用。

## 5. Spring Beans 和依赖注入

你可以自由使用任何标准 Spring Framework 技术定义你的 bean 以及它们的注入依赖。我们通常建议使用构造器注入来组织依赖以及使用 `@ComponentScan` 来找到 bean。

如果你按照上面建议的方式构造你的代码（将你的应用类放在层级最高的包），你可以添加没有任何参数的 `@ComponentScan` ，或使用隐式地包含它的 `@SpringBootApplication` 注解。所有你应用的组件（`@Component`、`@Service`、`@Repository`、`@Controller` 以及其他）将自动注册为 Spring Bean。

下面例子展示了一个使用构造器注入来获取一个所需 `RiskAssessor` bean 的 `@Service` Bean：

```java
@Service
public class MyAccountService implements AccountService {
    private final RiskAssessor riskAssessor;
    public MyAccountService(RiskAssessor riskAssessor) {
        this.riskAssessor = riskAssessor;
    }
    // ...
}
```

如果一个 bean 有多于一个构造器，你将需要给你希望 Spring 使用的那个标记 `@Autowired`：

```java
@Service
public class MyAccountService implements AccountService {
    private final RiskAssessor riskAssessor;
    private final PrintStream out;
    @Autowired
    public MyAccountService(RiskAssessor riskAssessor) {
        this.riskAssessor = riskAssessor;
        this.out = System.out;
    }
    public MyAccountService(RiskAssessor riskAssessor, PrintStream out) {
        this.riskAssessor = riskAssessor;
        this.out = out;
    }
}
```

> 注意使用构造器注入是如何让 `riskAssessor` 字段被标记为 `final` 的，说明它在之后不能被修改。

## 6. 使用 @SpringBootApplication

许多 Spring Boot 开发者喜欢他们的应用使用自动配置，组件扫描，以及可以在他们的“应用类”定义额外的配置。可以使用 `@SpringBootApplication` 一个注解来完成那三个特点：

- `@EnableAutoConfiguration`：启用 Spring Boot 的自动配置机制
- `@ComponentScan`：在应用所在的包内启用 `@Component` 扫描
- `@SpringBootConfiguration`：启动额外 bean 在上下文的注册或额外配置类的导入。这是一个帮助你在集成测试中检测配置的 Spring 标准 `@Configuration` 的替代方案

```java
// 相等于 @SpringBootConfiguration @EnableAutoConfiguration @ComponentScan
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }
}
```

> `@SpringBootApplication` 也提供了别名来自定义 `@EnableAutoConfiguration` 和 `@ComponentScan` 的属性。

> 这些特征都并非强制的，你可以选择用任何它启用的特征来替换这个注解。例如，你可能在你的应用中不想使用组件扫描或配置属性扫描：
>
> ```java
> @SpringBootConfiguration(proxyBeanMethods = false)
> @EnableAutoConfiguration
> @Import({SomeConfiguration.class, AnotherConfiguration.class})
> public class MyApplication {
>     public static void main(String[] args) {
>         SpringApplication.run(MyApplication.class, args);
>     }
> }
> ```
>
> 示例中，`MyApplication` 除了 `@Component` 注解的类和 `@ConfigurationProperties` 注解的类不会自动被自动检测到并且用户定义的 bean 需要显式地导入（参见 `@Import`）

## 7. 运行你的应用

将你的应用打包成 jar 且使用内嵌的 HTTP 服务器的一大好处是你可以像运行其他应用程序一样运行你的应用。这同样适用于调试 Spring Boot 应用。你不需要任何特别的 IDE 插件或扩展。

> 这一节只包含基于 jar 包的内容。如果你选择将你的应用打包为 war 文件，请参考你的服务器和 IDE 文档。

### 7.1 从 IDE 运行

你可以从你的 IDE 运行 Spring Boot 应用，将其作为一个 Java 应用。然而，你必须先导入你的项目。导入步骤因你的 IDE 和构建系统而异。大多数 IDE 可以直接导入 Maven 项目。例如，Eclipse 用户可以在 `File` 目录选择 `Import...` -> `Existing Maven Projects`。

如果你不能将你的项目直接导入你的 IDE，你可能可以使用构建插件来生成 IDE 元数据。Maven 包含了 Eclipse 和 IDEA 的插件。Gradle 也为各个 IDE 提供了插件。

> 如果你意外运行了一个 web 应用两次，你会看到一个“端口已经被使用”错误。Spring 工具能使用 `Relauch` 按键而不是 `Run` 按键来确保任何已存在的实例都被关闭。

### 7.5 热交换

因为 Spring Boot 应用就是普通的 Java 应用，所以 JVM 热交换应该是直接适用的。JVM 热交换在某种程度上受限于它可以替换的字节码。需要更完整的解决方案的话，可以使用 JRebel。

`spring-boot-devtools` 模组也包含了快速应用重启的支持。

## 8. 开发者工具

Spring Boot 包含一组额外的工具，可以使应用开发过程更加愉快一点。`spring-boot-devtools` 模组可以被包含在任何项目中，以提供额外的开发时特性。为了包含开发工具支持，需要在你的构建中添加模组依赖，下面展示了 Maven 和 Gradle 的方式：

Maven

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <optional>true</optional>
    </dependency>
</dependencies>
```

Gradle

```groovy
dependencies {
    developmentOnly("org.springframework.boot:spring-boot-devtools")
}
```

> 开发工具可能导致类加载问题，特别是多模组项目。“诊断类加载问题”一章解释了怎么诊断以及修复它们。

> 开发者工具在运行已经完全打包的应用时自动失效。如果你的应用是通过 `java -jar` 启动的或者它通过一个特殊的类加载器启动，那么它被认为是一个“生产环境应用”。你可以使用 `spring.devtools.retart.enabled` 系统属性来控制这个行为。为了在无论启动应用的类加载器是什么的情况下都激活开发工具，需要设置 `-Dspring.devtools.restart.enabled=true` 系统属性。这一定不能在生产环境使用，因为运行开发工具是安全风险。要停用开发工具的话，直接移除依赖或者设置 `-Dspring.devtools.restart.enabled=false` 系统属性。

> 在 Maven 中将依赖标记为 optional，或者在 Gradle 中使用 `developmentOnly` 配置（如上所示）可以防止开发工具被传递应用到你项目的其他模块。

> 默认情况下，重新打包的 archive 文件不包含 devtools。如果你希望使用特定远程开发工具特性，你需要包含它。使用 Maven 插件时，将 `excludeDevtools` 属性设置为 `false`。使用 Gradle 插件时，将任务的类路径配置为包含 `developmentOnly` 配置。

### 8.1 诊断类加载问题

如同“重启 vs 重载”一节中描述的一样，重启功能是通过两个类加载类实现的。对于大部分应用，这个方法效果很好。然而，它有时会导致类加载问题，特别是多模块项目。

为了诊断类加载问题是否确实因为开发工具以及它的两个类加载器导致的，可以尝试停用重启。如果这解决了你的问题，自定义重启类加载器来包含你的整个项目。

### 8.2 属性默认值

一些 Spring Boot 支持的库使用缓存来提高性能。例如模板引擎缓存编译好的模板来避免重复解析模板文件。Spring MVC 也能增加 HTTP 缓存 header 来在服务静态资源的响应。

虽然缓存在生产环境非常有益处，它却在开发时降低了生产效率，让你无法看到你在应用中做出的修改。因此，spring-boot-devtools 默认取消缓存选项。

缓存选项经常通过你的 `application.properties` 文件配置。例如 Thymeleaf 提供 `spring.thymeleaf.cache` 属性。并不需要手动配置这些属性，`spring-boot-devtools` 模块自动应用合理的开发时配置。

下表列举了所有应用的属性：

| 名字                                             | 默认值   |
| ------------------------------------------------ | -------- |
| `server.error.include-binding-errors`            | `always` |
| `server.error.include-message`                   | `always` |
| `server.error.include-stacktrace`                | `always` |
| `server.servlet.jsp.init-parameters.development` | `true`   |
| `server.servlet.session.persistent`              | `true`   |
| `spring.freemarker.cache`                        | `false`  |
| `spring.graphql.graphiql.enabled`                | `true`   |
| `spring.groovy.template.cache`                   | `false`  |
| `spring.h2.console.enabled`                      | `true`   |
| `spring.mustache.servlet.cache`                  | `false`  |
| `spring.mvc.log-resolved-exception`              | `true`   |
| `spring.reactor.debug`                           | `true`   |
| `spring.template.provider.cache`                 | `false`  |
| `spring.thymeleaf.cache`                         | `false`  |
| `spring.web.resources.cache.period`              | `0`      |
| `spring.web.resources.chain.cache`               | `false`  |

> 如果你不希望默认值生效，你可以在你的 `application.properties` 设置 `spring.devtools.add-properties` 为 `false`

因为你在开发 Spring MVC 和 Spring WebFlux 应用时需要更多关于 web 请求的信息，开发者工具建议你为 `web` 日志组启用 `DEBUG` 日志。这将给你提供来访请求的信息：哪个处理器在处理它、响应结果以及其他细节。如果你希望记录所有请求细节（包括潜在的敏感信息），你可以打开 `spring.mvc.log-request-details` 或 `spring.codec.log-request-details` 配置属性。

### 8.3 自动重启

使用 `spring-boot-devtools` 的应用在 classpath 下的文件修改时自动重启。这是一个在 IDE 下工作时的有用特性，因为它为代码修改提供了一个非常快的反馈循环。默认情况下，将监视指向目录的 classpath 上的任何条目的更改。请注意，某些资源（如静态资产和视图模板）不需要重新启动应用程序。

> **触发重启**
>
> 因为 DevTools 监视的是 classpath 资源，所以唯一触发重启的办法是更新 classpath。无论你在使用 IDE 还是构建插件之一，修改的文件必须被重新编译来触发重启。你让 classpath 更新的方式取决于你使用的工具：
>
> - 在 Eclipse 中，保存一个修改过的文件使 classpath 被更新并触发一次重启。
> - 在 IntelliJ IDEA 中，构建项目（`Build` -> `Build Project`）具有一样的效果。
> - 如果使用构建插件，运行 Maven 的 `mvn compile` 或 Gradle 的 `gradle build` 将触发重启。

> 如果你使用构建插件用 Maven 或 Gradle 重启，必须将 `forking` 设置为 `enabled`。如果你禁用分支（forking），被开发工具使用独立应用类加载器将不会被创建且重启不会正常工作。

> 自动重启在和 LiveReload 一起使用时运行得很好。细节参见 LiveReload 一节。如果你使用 JRebel，自动重启将被禁用，以支持动态类重新加载。其他开发工具特性（例如 LiveReload 和属性覆盖）可以被使用。

> 开发工具依赖于应用上下文的关闭钩子来在重启时关闭。如果你停用关闭钩子，它将不能正常运行（`SpringApplication.setRegisterShutdownHook(false)`）。

> 开发工具需要自定义 `ApplicationContext` 使用的 `ResourceLoader`。如果你的应用已经提供了一个，它将被包装。不支持直接重写 `ApplicationContext` 上的 `getResource` 方法。

> 自动重启在使用 AspectJ 织入时无法使用

> **重启 vs 重载**
>
> Spring Boot 提供的重启技术使用两个类加载器运行。不改变的类（例如，那些来自三方 jar 的）被加载到基础类加载器。你主动开发的类被加载到重启类加载器。当应用被重启，重启类加载器将被丢弃并新建一个。这种方式意味着应用重启一般比“冷启动”快，因为基本类加载器已经是可用的以及数据准备好了。
>
> 如果你发现重启对于你的应用或你遇到类加载问题并不够快，你可以考虑类似 ZeroTurnaround 的 JRebel 的重载技术。这些方法通过在类加载时重写类，使它们更易于重新加载。

#### 8.3.1 记录条件评估中的改变

默认情况，每次你的应用重启，将记录一个展示条件评估增量的报告。当你进行更改（如添加或删除 bean 以及设置配置属性）时，这个报告展示你的应用的自动配置的改变。

为了取消记入该报告，可以设置下面的属性：

```properties
spring.devtools.restart.log-condition-evaluation-delta=false
```



# 数据

## 2. 和 NoSQL 技术一同工作

Spring Data 提供了帮助你访问一系列 NoSQL 技术的额外的项目，包括：

- MongoDB
- Neo4J
- Elasticsearch
- Redis
- GemFire 或 Geode
- Cassandra
- Couchbase
- LDAP

Spring Boot 提供了 Redis，MongoDB，Neo4j，Elasticsearch，Cassandra，Couchbase，LDAP 和 InfluxDB 的自动配置。额外地，Spring Boot for Apache Geode 提供了 Apache Geode 的自动配置。你可以使用其他项目，但你必须自己配置它们。

### 2.1 Redis

Redis 是一个缓存，消息代理和功能丰富的键值存储库。Spring Boot 为 Lettuce 和 Jedis 客户端库提供基本的自动配置，以及 Spring Data Redis 提供的在它们之上的抽象。

有一个 `spring-boot-starter-data-redis` “Starter”来方便地聚合这些依赖。默认情况下，它使用 Lettuce。这个 starter 可以处理传统和响应式的应用。

> 我们也提供 `spring-boot-starter-data-redis-reactive` “Starter” 来和其他有响应式支持的存储保持一致。

#### 2.1.1 连接到 Redis

你可以像注入任何其他 Spring Bean 一样，注入一个自动配置的 `RedisConnectionFactory`，`StringRedisTemplate`，或普通的 `RedisTemplate` 实例。默认情况下，实例会尝试连接 `localhost:6379` 的 Redis 服务器。下面展示了一个这样的 bean：

```java
@Component
public class MyBean {
    private final StringRedisTemplate template;
    
    public MyBean(StringRedisTemplate template) {
        this.template = template;
    }
    
    // ...
}
```

> 你也可以注册任意数量的实现了 `LettuceClientConfigurationBuilderCustomizer` 的 bean 来实现更多自定义。`ClientResources` 也可以使用 `ClientResourcesBuilderCustomizer` 来自定义。如果你使用 Jedis，也是可以使用 `JedisClientConfigurationBuilderCustomizer`。
>
> 另外，你可以注册一个 `RedisStandaloneConfiguration`，`RedisSentinelConfiguration` 或 `RedisClusterConfiguration` 类的 bean 来获得对配置的完全控制。

如果你添加了你自己的任何自动配置类的 `@Bean`，它会替换默认的（除了 `RedisTemplate`，它的排除是基于 bean 名称 `redisTemplate` 而不是它的类型）。

默认情况下，当 classpath 有 `common-pool2` 时，会自动配置一个池化的连接工厂。