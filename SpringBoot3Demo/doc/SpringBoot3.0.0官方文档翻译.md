# 入门

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

#### 8.3.2 排除资源

特定资源并不必须在它们被修改时触发一次重启。例如，Thymeleaf 模板可以被就地编辑。默认情况下，改变在 `/META-INF/maven`，`/META-INF/resources`，`/resources`，`/static`，`/public`，或 `/templates` 中的资源不会触发一次重启，但会触发一次实时重载。如果你想自定义这些排除项，你可以使用 `spring.devtools.restart.exclude` 属性。例如，为了仅排除 `/static` 和 `/public`，你将配置如下属性：

```properties
spring.devtools.restart.exclude=static/**,public/**
```

> 如果你想保持这些默认值并添加额外的排除项，使用 `spring.devtools.restart.additional-exclude` 属性作为替代。

#### 8.3.3 监控额外的路径

你可能想要你的应用在你修改不在 classpath 的配置文件时被重启或重载。要做到这点，使用 `spring.devtools.restart.additional-paths` 属性来配置额外的路径来查看改变。你可以使用之前描述的 `spring.devtools.restart.exclude` 属性来控制在额外路径下的改变是否触发一次完整的重启或一次实时重载。

#### 8.3.4 禁用重启

如果你不想使用重启特性，你可以使用 `spring.devtools.restart.enabled` 属性来禁用它。在大多数情况下，你可以在你的 `application.properties` 中设置这个属性（这样做仍然会初始化重启类加载器，但它不会监控文件改变）。

如果你需要完全禁用重启支持（例如，因为它和特定的库不兼容），你需要在调用 `SpringApplication.run(...)` 前将 `spring.devtools.restart.enabled` 系统属性设置为 `false`，就像下面例子中展示的那样：

```java
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) {
        System.setProperty("spring.devtools.restart.enabled", "false");
        SpringApplication.run(MyApplication.class, args);
    }
}
```

#### 8.3.5 使用触发器文件

如果你使用可以连续编译改变文件的 IDE，你可能更希望只在特定时机触发重启。为了这样，你可以使用一个“触发器文件”，即你想要真正触发一次重启检查时必须修改的一个特殊文件。

> 任何对该文件的更新都会触发一次检查，但仅仅在开发工具检测到它有事情做时才真正发生重启。

为了使用触发器文件，设置 `spring.devtools.restart.trigger-file` 属性为你触发器文件的名字（去掉任何路径）。这个触发器文件必须放在你的 classpath 中。

例如，你有一个具有下面结构的项目：

```
src
+- main
   +- resources
      +- .reloadtrigger
```

那么你的 `trigger-file` 属性将是：

```properties
spring.devtools.restart.trigger-file=.reloadtrigger
```

重启将只在 `src/main/resources/.reloadtrigger` 更新时发生。

> 你可能想把 `spring.devtools.restart.trigger-file` 设置为一个全局设置，这样所有你的项目都可以遵循一个行为方式。

一些 IDE 拥有一些特性，可以帮助你摆脱手动更新你的触发器文件的工作。Spring Tools for Eclipse 和 IntelliJ IDEA（终极版）都有这样的支持。使用 Spring Tools，你可以从控制台视角使用“reload”按钮（只要你的 `trigger-file` 名字是 `.reloadtrigger`）。对于 Intellij IDEA，你可以按照它们文档的指示操作。

#### 8.3.6 自定义重启类加载器

正如早些在“重启 vs 重载”中描述的，重启功能是通过使用两个类加载器实现的。如果这导致了问题，你可能需要自定义每个类被哪个类加载器加载。

默认情况下，所有 IDE 打开的项目被重启类加载器加载，而所有常规的 `.jar` 文件通过基础类加载器加载。同样也适用于你使用 `mvn spring-boot: run` 或 `gradle bootRun` 的情况：包含你的 `@SpringBootApplication` 的项目被重启类加载器加载，而其他的被基础类加载器加载。

你可以通过创建一个 `META-INF/spring-devtools.properties` 文件来命令 Spring Boot 使用不同的类加载器来加载你的项目组成部分。这个 `spring-devtools.properties` 文件可以包含前缀为 `restart.exclude` 和 `restart.include` 的配置项。`include` 元素是需要上提到重启类加载器中的项，`exclude` 元素是应当下推到基础类加载器的项。配置文件的值是应用到 classpath 的正则表达式，如同下面例子展示的：

```properties
restart.exclude.companycommonlibs=/mycorp-common-[\\w\\d-\\.]+\\.jar
restart.include.projectcommon=/mycorp-myproj-[\\w\\d-\\.]+\\.jar
```

> 所有的配置项键必须不一样。只要配置项是以 `restart.include.` 或 `restart.exclude.` 开始的，它就会生效。

> 所有在 classpath 下的 `META-INF/spring-devtools.properties` 都会被加载。你可以在你的项目中或者在项目使用的库中将这些文件打包。

#### 8.3.7 已知限制

重启功能不能很好地处理使用标准 `ObjectInputStream` 反序列化的对象。如果你需要反序列化数据，你可能需要组合使用 Spring 的 `ConfigurableObjectInputStream` 和 `Thread.currentThread().getContextClassLoader()`。

不幸的是，部分三方库反序列化没有考虑上下文类加载器。如果你找到了这样的问题，你需要请求原作者进行修复。

### 8.4 LiveReload

`spring-boot-devtools` 模组包括了一个嵌入式的 LiveReload 服务器，可以用来在资源改变时触发浏览器刷新。Chrome 的 LiveReload 浏览器插件可以免费获取，Firefox 和 Safari 的需要从 livereload.com 获取。

如果你不想在你的应用运行时启动 LiveReload 服务器，你可以将 `spring.devtools.livereload.enabled` 配置项设置为 `false`。

> 你只可以同时运行一个 LiveReload 服务器。在启动你的应用前，确保没有其他 LiveReload 服务器正在运行。如果你在 IDE 启动了多个应用，只有第一个拥有 LiveReload 支持。

> 为了在一个文件更改时触发 LiveReload，自动化重启必须被开启。

### 8.5 全局设置

你可以通过在 `$HOME/.config/spring-boot` 目录增加下面任意文件来配置全局开发工具：

1. `spring-boot-devtools.properties`
2. `spring-boot-devtools.yaml`
3. `spring-boot-devtools.yml`

这些文件中增加的任意配置项会应用到你机器上使用开发工具的*所有* Spring Boot 应用。例如，为了配置一直使用触发器文件来重启，你需要在你的 `spring-boot-devtools` 文件中增加如下配置：

```properties
spring.devtools.restart.trigger-file=.reloadtrigger
```

默认情况下，`$HOME` 是用户的主目录。想要自定义这个位置的话，需要配置 `SPRING_DEVTOOLS_HOME` 环境变量或 `spring.devtools.home` 系统配置。

> 如果开发工具配置文件没有在 `$HOME/.config/spring-boot` 下找到，会在 `$HOME` 目录的根目录寻找 `.spring-boot-devtools.properties` 的存在。这允许你使用不支持 `$HOME/.config/spring-boot` 的老版本 Spring Boot 分享的开发工具全局配置。

> Profiles 在开发工具 properties/yaml 文件中不支持。
>
> 任何在 `.spring-boot-devtools.properties` 中激活的 profile 将不会影响 profile 指定配置文件的加载。Profile 特定文件名（之前 `spring-boot-devtools-<profile>.properties`）和 `spring.config.activate.on-profile` 文档在 YAML 和 Properties 文件中都不支持。

#### 8.5.1 配置文件系统监视器

FileSystemWatcher 的工作方式是以一定时间间隔轮询类的更改，然后等待预定义好的静默期来确保没有更多修改。因为 Spring Boot 完全依赖于 IDE 来编译和复制文件到 Spring Boot 可以读取到的位置，你可能发现在开发工具重新启动应用程序时，有时某些更改没有反映出来。如果你经常观察到此类问题，请尝试增加 `spring.devtools.restart.poll-interval` 和 `spring.devtools.restart.quiet-period` 参数到你开发环境合适的值：

```properties
spring.devtools.restart.poll-interval=2s
spring.devtools.restart.quiet-period=1s
```

这个监视的 classpath 目录现在每 2 秒轮询一次改变，并且持续 1 秒的静默期来确保没有更多的类更改。

### 8.6 远程应用

Spring Boot 开发者工具不只限于本地开发。你可以在远程运行应用时使用一些特性。远程支持是可选的，因为启动它可能导致安全风险。它应该只在受信网络中运行或使用 SSL 保证安全时被启用。如果这两个选项都不可用，则不应该使用开发工具的远程支持。你永远不应该在生产环境里启动这个支持。

为了启用它，你需要确保 `devtools` 被包括在重新打包的 archive 里，就像下面展示的：

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <excludeDevtools>false</excludeDevtools>
            </configuration>
        </plugin>
    </plugins>
</build>
```

然后你需要设置 `spring.devtools.remote.secret` 属性。就像所有的重要密码或密钥，这个值应该是独特的而且保密性强，这样它才不会被猜中或者暴力破解。

远程开发工具支持在两个部分中提供：接受连接的服务器端终端和在你的 IDE 中运行的客户端应用。在 `spring.devtools.remote.secret` 属性被配置时，服务器组件会自动启动。客户端组件需要手动启动。

> Spring WebFlux 应用不支持远程开发工具。

#### 8.6.1 运行远程客户端应用

远程客户端应用被设计在你的 IDE 中运行。你需要在和你要连接的远程项目相同的 classpath 运行 `org.springframework.boot.devtools.RemoteSpringApplication` 。这个应用唯一需要的参数是它要连接的远程 URL。

例如，如果你在使用 Eclipse 或 Spring Tools ，并且你拥有一个已经部署在 Cloud Foundry 的叫 `my-app` 的项目，你应该按下面步骤操作：

- 选择 `Run` 目录的 `Run Configurations...`
- 创建一个新的 `Java 应用` “启动配置”
- 浏览 `my-app` 项目
- 使用 `org.springframework.boot.devtools.RemoteSpringApplication` 作为主类
- 将 `https://myapp.cfapps.io` 增加到 `程序参数`（或者任何你的远程 URL）

运行远程客户端可能和下面内容相似：

```
  .   ____          _                                              __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _          ___               _      \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` |        | _ \___ _ __  ___| |_ ___ \ \ \ \
 \\/  ___)| |_)| | | | | || (_| []::::::[]   / -_) '  \/ _ \  _/ -_) ) ) ) )
  '  |____| .__|_| |_|_| |_\__, |        |_|_\___|_|_|_\___/\__\___|/ / / /
 =========|_|==============|___/===================================/_/_/_/
 :: Spring Boot Remote ::  (v3.0.0)

2022-11-24T17:03:45.349Z  INFO 20660 --- [           main] o.s.b.devtools.RemoteSpringApplication   : Starting RemoteSpringApplication v3.0.0 using Java 17.0.5 with PID 20660 (/Users/myuser/.m2/repository/org/springframework/boot/spring-boot-devtools/3.0.0/spring-boot-devtools-3.0.0.jar started by myuser in /opt/apps/)
2022-11-24T17:03:45.353Z  INFO 20660 --- [           main] o.s.b.devtools.RemoteSpringApplication   : No active profile set, falling back to 1 default profile: "default"
2022-11-24T17:03:46.281Z  INFO 20660 --- [           main] o.s.b.d.a.OptionalLiveReloadServer       : LiveReload server is running on port 35729
2022-11-24T17:03:46.364Z  INFO 20660 --- [           main] o.s.b.devtools.RemoteSpringApplication   : Started RemoteSpringApplication in 2.675 seconds (process running for 3.514)
```

> 因为远程客户端使用和真实应用相同的 classpath，它可以直接读取应用配置。这是读取 `spring.devtools.remote.secret` 配置然后将其传递到服务端验证的方式。

> 始终建议使用 `https://` 作为连接协议，这样流量会被加密且密钥不会被拦截。

> 如果你需要使用代理来访问远程应用，请配置 `spring.devtools.remote.proxy.host` 和 `spring.devtools.remote.proxy.port` 配置项

#### 8.6.2 远程更新

远程客户端像本地重启一样监控你的应用 classpath 的更改。任何更新的资源会被推送到远程应用并（如果需要的话）触发一次重启。这有助于你使用本地没有的云服务进行迭代特性。一般地，远程更新和重启比全量重新构建和部署的循环快很多。

在更慢的开发环境，可能出现静默期不够的情况，类的改变可能被分到不同的批次中。服务器在第一批处理的类修改被上传时就重启了。下一批处理不能被发送到应用，因为服务器正在被重启。

这通常表现为关于上传一些类失败以及随后的重试的 `RemoteSpringApplication` 日志中的警告。但它可能导致应用代码的不一致并导致在第一批修改被上传时重启失败。如果你经常观察到这样的问题，试着增加 `spring.devtools.restart.poll-interval` 和 `spring.devtools.restart.quiet-period` 参数到适合你的开发环境的值。参考配置文件系统监视器一节来配置这些。

> 文件只在远程客户端运行时被监视。如果你在远程客户端启动前改变一个文件，它将不会被推送到远程服务端。

## 9. 为生产环境打包你的应用

可执行的 jar 能够被生产环境部署使用。因为它们是独立的，所以它们也适合基于云的部署。

为了额外的“生产就绪”特性，例如健康、审计和度量 REST 或 JMX 终端，考虑添加 `spring-boot-actuator`。

# 核心特性

这一部分深入到 Spring Boot 的细节中。这里你可以学习到你可能想要使用和自定义的关键特性。如果你还没有这样做，你可能需要阅读“入门”和“使用 Spring Boot 开发”部分，这样你就有了良好的基础知识储备。

## 1. SpringApplication

`SpringApplication` 类提供了一个简便的方式来从一个 `main()` 方法来启动 Spring 应用。很多情况下，你可以委托给静态的 `SpringApplication.run()` 方法，就像下面例子展示的：

```java
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }
}
```

当你的应用启动时，你应该看到类似下面的输出：

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.0.0)

2022-11-24T17:03:48.214Z  INFO 20764 --- [           main] o.s.b.d.f.s.MyApplication                : Starting MyApplication using Java 17.0.5 with PID 20764 (/opt/apps/myapp.jar started by myuser in /opt/apps/)
2022-11-24T17:03:48.219Z  INFO 20764 --- [           main] o.s.b.d.f.s.MyApplication                : No active profile set, falling back to 1 default profile: "default"
2022-11-24T17:03:50.511Z  INFO 20764 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2022-11-24T17:03:50.524Z  INFO 20764 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2022-11-24T17:03:50.524Z  INFO 20764 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.1]
2022-11-24T17:03:50.623Z  INFO 20764 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2022-11-24T17:03:50.625Z  INFO 20764 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 2269 ms
2022-11-24T17:03:51.380Z  INFO 20764 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2022-11-24T17:03:51.418Z  INFO 20764 --- [           main] o.s.b.d.f.s.MyApplication                : Started MyApplication in 3.872 seconds (process running for 5.008)
2022-11-24T17:03:51.506Z  INFO 20764 --- [ionShutdownHook] o.apache.catalina.core.StandardService   : Stopping service [Tomcat]
```

默认情况下，`INFO` 日志消息被展示，包括一些相关的启动细节，例如启动应用的用户。如果你需要 `INFO` 之外的其他日志级别，你可以设置它，在“日志级别“中描述。应用版本使用主应用类的包中的实现版本来决定的。启动信息日志可以使用 `spring.main.log-startup-info` 配置为 `false` 来关闭。这也关闭了应用激活的 profile 的日志。

> 为了在启动时添加额外的日志，你可以在 `SpringApplication` 的子类中重写 `logStartupInfo(boolean)`

### 1.1 启动失败

如果你的应用启动失败，注册的 `FailureAnalyzers` 获得了提供独立错误信息和执行修复错误的具体行为的机会。例如，如果你在端口 `8080` 上启动一个 web 应用且端口已经被使用，你可以看到类似下面的信息：

```
***************************
APPLICATION FAILED TO START
***************************

Description:

Embedded servlet container failed to start. Port 8080 was already in use.

Action:

Identify and stop the process that is listening on port 8080 or configure this application to listen on another port.
```

> Spring Boot 提供很多的 `FailureAnalyzer` 实现，并且你可以增加你自己的实现。

如果没有失败分析器可以处理这个异常，你仍然可以展示全部状态报告来更好地理解哪里出错了。要这样做，你需要为 `org.springframework.boot.autoconfigure.logging.ConfitionEvaluationReportLoggingListener` 启用 `debug` 属性或启用 `DEBUG` 日志。

例如，如果你使用 `java -jar` 来运行你的应用，你可以像下面这样启用 `debug` 配置：

```shell
$ java -jar myproject-0.0.1-SNAPSHOT.jar --debug
```

### 1.2 延迟初始化

`SpringApplication` 允许一个应用延迟初始化。当延迟初始化被启用时，bean 在它们被需要使用时被创建而不是在应用启动时。作为结果，启动延迟初始化可以降低你的应用启动的耗时。在 web 应用，启动延迟初始化会导致很多 web 相关的 bean 在收到一个 HTTP 请求前不被初始化。

延迟初始化的一个缺点是它会延迟应用问题的发现。如果一个错误配置的 bean 被延迟初始化，错误不会再在启动时出现，而问题将在 bean 初始化时才可见。还必须注意确保 JVM 拥有足够的内存来容纳全部应用 bean 而不仅仅是启动时初始化的那些。因为这些原因，延迟初始化默认是不启用的，并且建议在启用延迟初始化前对 JVM 的堆大小进行细致的调校。

延迟初始化可以使用 `SpringApplicationBuilder` 的 `lazyInitialization` 方法或 `SpringApplication` 的 `setLazyInitialization` 方法在程序中启用。此外，也可以使用如下例子的 `spring.main.lazy-initialization` 属性来启用：

```properties
spring.main.lazy-initialization=true
```

> 如果你希望在对应用的其他部分启用延迟初始化时对特定 bean 禁用延迟初始化，你可以显式地使用 `@Lazy(false)` 注解来设置它们的 lazy 属性为 false。

### 1.3 自定义横幅

启动时打印的横幅可以通过增加 `banner.txt` 文件到你的 classpath 或设置 `spring.banner.location` 属性来指定该文件的位置来改变。如果文件的编码不是 UTF-8，你可设置 `spring.banner.charset`。

在你的 `banner.txt` 文件中，你可以使用所有在 `Environment` 中可用的键，也可以使用下面所有的占位符。

| 变量                                                         | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `${application.version}`                                     | 在 `MANIFEST.MF` 中声明的你的应用版本号。例如，`Implementation-Version: 1.0` 被打印为 `1.0` |
| `${application.formatted-version}`                           | 在 `MANIFEST.MF` 中声明的且为展示而格式化好了（使用小括号包裹且增加 `v` 前缀）的你的应用版本号。例如 `(v1.0)`. |
| `${spring-boot.version}`                                     | 你使用的 Spring Boot 版本，例如 `3.0.0`.                     |
| `${spring-boot.formatted-version}`                           | 为展示而格式化好了（使用小括号包裹且增加 `v` 前缀）的你使用的 Spring Boot 版本，例如 `(v3.0.0)`. |
| `${Ansi.NAME}` (or `${AnsiColor.NAME}`, `${AnsiBackground.NAME}`, `${AnsiStyle.NAME}`) | `NAME` 是 ANSI 转义代码的名称。有关详细信息，请参见 `AnsiPropertySource`。 |
| `${application.title}`                                       | 在 `MANIFEST.MF` 中声明的你的应用标题。例如 `Implementation-Title: MyApp` 被打印为 `MyApp`. |

> 在你想要用程序生成一个横幅时，可以使用 `SpringApplication.setBanner(...)` 方法。使用 `org.springframework.boot.Banner` 接口并实现你自己的 `printBanner()` 方法。

你也可以使用 `spring.main.banner-mode` 属性来决定横幅需要打印到 `System.out`（`console`），发送到配置的日志（`log`）或者根本不需要生成（`off`）。

打印的横幅被注册为一个单例 bean，使用以下名字： `springBootBanner`。

> `${application.version}` 和 `${application.formatted-version}` 属性仅在你使用 Spring Boot 启动器时可用。如果你使用 `java -cp <classpath> <mainclass>` 启动运行一个没打包的 jar，这些值将不会被解析。
>
> 这正是我们建议你总是使用 `java org.springframework.boot.loader.JarLauncher` 启动未打包的 jar。这将在构建 classpath 前初始化 `application.*` 横幅变量并启动你的应用。

### 1.4 自定义 SpringApplication

如果 `SpringApplication` 默认值不符合你的品味，你可以创建一个本地实例并自定义它。例如，为了关闭横幅，你可以写：

```java
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(MyApplication.class);
        application.setBannerMode(Banner.Mode.OFF);
        application.run(args);
    }
}
```

> 传递给 `SpringApplication` 的构造器参数是 Spring bean 的配置来源。大多数情况下，这些是 `@Configuration` 类的引用，但它们也可以是 `@Component` 类的直接引用。

它也可能使用 `application.properties` 文件配置 `SpringApplication`。细节请参考“外部化配置”。

获取完整的配置选项列表，请参看 `SpringApplication` 的 javadoc。

### 1.5 流式建造者（Fluent Builder） API

如果你需要建造一个 `ApplicationContext` 层级结构（多个具有父子关系的上下文）或如果你更喜欢使用一个“流式”（fluent）的建造者 API，你可以使用 `SpringApplicationBuilder`。

`SpringApplicationBuilder` 让你将多个方法调用锁定在一起并包含可以让你创建一个层级结构的 `parent` 和 `child` 方法，就像下面例子展示的那样：

```java
new SpringApplicationBuilder()
        .sources(Parent.class)
        .child(Application.class)
        .bannerMode(Banner.Mode.OFF)
        .run(args);
```

> 在创建 `ApplicationContext`  层级结构时有一些限制。例如，Web 组件必须包含在子上下文中，并且父上下文和子上下文使用相同的 `Environment`。参考 `SpringApplicationBuilder` 的 Javadoc 获取完整细节。

### 1.6 应用可用性

当部署在平台上时，应用可以使用例如 Kubernetes Probes 之类的基础设施给平台提供它们的可用性信息。Spring Boot 包含对常用的“活跃”（liveness）和“就绪”（readiness）可用性状态的开箱即用支持。如果你正在使用 Spring Boot 的 “actuator” 支持，那么这些状态将作为健康端点组公开出来。

另外的，你也可以通过注入 `ApplicationAvailability` 接口到你自己的 bean 来获取可用性状态。

#### 1.6.1 活跃状态

一个应用的“活跃”状态指示它的内部状态是否让它可以正确工作，或者如果它正在失败状态中的话能否恢复它自己。一个中断（broken）的“活跃状态”意味着应用处于一个它不能恢复的状态，基础设施应该重启应用。

> 一般来说，“活跃”状态不应该基于外部的检查，例如“健康检查”。如果这样做的话，一个故障的外部系统（数据库、Web API、外部缓存）将触发大量的重启和跨平台的级联故障。

Spring Boot 应用的内部状态大多数通过 Spring `ApplicationContext` 展示。如果应用上下文成功地启动，Spring Boot 假设应用处于一个可效（valid）的状态。当上下文已经被刷新时，应用被认为是活跃的，参考 Spring Boot 应用生命周期和相关的应用事件。

#### 1.6.2 就绪状态

一个应用的“就绪”状态指示了应用是否准备好处理流量。一个失败的“就绪”状态告诉平台现在不应该将流量路由到应用。这经常发生在启动期间，即当 `CommandLineRunner` 和 `ApplicationRunner` 组件正在被处理时，或者任何应用认为它过于忙以至于无法处理更多流量的时候。

一旦应用和命令行运行程序被调用时，应用被认为就绪，参考 Spring Boot 应用生命周期和相关的应用事件。

> 需要在启动时运行的任务应该被 `CommandLineRunner` 和 `ApplicationRunner` 组件执行，而不是使用 Spring 组件的生命周期回调，例如 `@PostConstuct`

#### 1.6.3 处理应用可用性状态

应用组件可以通过注入 `ApplicationAvailability` 接口并调用其上的方法在任何时间取得当前的可用性状态。更加通常地，应用希望监听状态更新或更新应用状态。

例如，我们将应用“就绪”状态导出到文件中，这样 Kubernetes 的“执行 Probe”就可以查看这个文件：

```java
@Component
public class MyReadinessStateExporter {

    @EventListener
    public void onStateChange(AvailabilityChangeEvent<ReadinessState> event) {
        switch (event.getState()) {
            case ACCEPTING_TRAFFIC:
                // create file /tmp/healthy
                break;
            case REFUSING_TRAFFIC:
                // remove file /tmp/healthy
                break;
        }
    }

}
```

当应用崩溃且无法恢复时，我们也可以更新应用的状态：

```java
@Component
public class MyLocalCacheVerifier {

    private final ApplicationEventPublisher eventPublisher;

    public MyLocalCacheVerifier(ApplicationEventPublisher eventPublisher) {
        this.eventPublisher = eventPublisher;
    }

    public void checkLocalCache() {
        try {
            // ...
        }
        catch (CacheCompletelyBrokenException ex) {
            AvailabilityChangeEvent.publish(this.eventPublisher, ex, LivenessState.BROKEN);
        }
    }

}
```

Spring Boot 通过 Actuator Health Endpoints 提供“活跃” 和“就绪”的 Kubernetes HTTP 探针。你可以在专门部分获取更多关于在 Kubernetes 部署 Spring Boot 应用的指导。

### 1.7 应用事件和监听器

除了常用的 Spring Framework 事件，例如 `ContextRefreshedEvent`，`SpringApplication` 会发送一些额外的应用事件。

> 一些事件其实在 `ApplicationContext` 创建前就实际被触发了，所以你不能在那些 `@Bean` 上注册监听器。你可以使用 `SpringApplication.addListeners(...)` 方法或 `SpringApplicationBuilder.listeners(...)` 方法注册它们。
>
> 如果你想要那些监听器被自动注册，而不管应用是如何创建的，你可以添加一个 `META-INF/spring.factories` 文件到你的项目中，并且使用 `org.springframework.context.ApplicationListener` 键来引用你的监听器，就像下面例子中展示的：
>
> ```
> org.springframework.context.ApplicationListener=com.example.project.MyListener
> ```

当你的应用运行时，应用事件按照下面顺序发送：

1. 在一次运行开始时但在任何除了监听器和初始化器注册以外的处理前，发送一个 `ApplicationStartingEvent`
2. 当上下文中要使用的 `Environment` 已知而在上下文创建前，发送一个 `ApplicationEnvironmentPreparedEvent`
3. 当 `ApplicationContext` 准备好且 ApplicationContextInitializer 已经被调用但在任何 bean 定义被加载前，发送一个 `ApplicationContextInitializedEvent`
4. 在刷新开始前，bean 定义加载后，发送一个 `ApplicationPreparedEvent`
5. 在上下文刷新后，但任何应用和命令行启动程序还没被调用前，发送一个 `ApplicationStartedEvent`
6. 在 `LivenessState.CORRECT` 指示应用已经被认为活跃后，发送一个 `AvailabilityChangeEvent`
7. 任何应用和命令行启动程序被调用后，发送一个 `ApplicationReadyEvent`
8. 在 `ReadinessState.ACCEPTING_TRAFFIC` 指示应用准备好接受服务请求后，发送一个 `AvailabilityChangeEvent` 
9. 如果启动过程中有异常，发送一个 `ApplicationFailedEvent`

上面的列表只包含了绑定在 `SpringApplication` 上的 `SpringApplicationEvent`。除此之外，下面事件也在 `ApplicationPreparedEvent` 之后和 `ApplicationStartedEvent` 之前：

- 在 `WebServer` 准备好之后，发送一个 `WebServerInitializedEvent`。`ServletWebServerInitializedEvent` 和 `ReactiveWebServerInitializedEvent` 是 servlet 和响应式各自的变种。
- 当 `ApplicationContext` 被刷新时，发送一个 `ContextRefreshedEvent`

> 你通常不需要使用应用事件，但知道它们的存在会有所帮助。Spring Boot 在内部使用事件来处理各种任务。

> 默认情况下，事件监听器不应该运行可能耗时很长的任务，因为它们在同一个线程中执行。考虑使用应用和命令行运行程序作为替代。

应用事件使用 Spring 框架的事件发布机制来发送。这个机制的一部分确保在子上下文中发布给监听器的事件也发布给所有祖先上下文中的监听器。结果就是，如果你的应用使用 `SpringApplication` 实例的层级结构，一个监听器可能接受到多个相同实例的应用事件。

为了让你的监听器可以分辨它上下文的事件和后代上下文的事件，它应该请求注入其应用程序上下文，然后将注入的上下文与事件上下文进行比较。上下文可以通过实现 `ApplicationContextAware` 来注入，如果监听器是bean，则可以使用 `@Autowired` 来注入。

### 1.8 Web 环境

`SpringApplication` 尝试代表你来创建正确的 `ApplicationContext` 类型。用于决定 `WebApplicationType` 的算法如下：

- 如果有 Spring MVC，使用 `AnnotationConfigServletWebServerApplicationContext`
- 如果没有 Spring MVC 且出现了 Spring WebFlux，使用 `AnnotationConfigReactiveWebServerApplicationContext`
- 否则，使用 `AnnotationConfigApplicationContext`

这说明如果你正在使用 Spring MVC 且 Spring WebFlux 中新的 `WebClient` 也在同一个应用中，则默认使用 Spring MVC。你可以通过调用 `setWebApplicationType(WebApplicationType)` 轻松地覆写这个。

也可以通过调用 `setApplicationContextClass(...)` 来完全控制 `ApplicationContext` 的类型。

> 在 JUnit 测试中使用 `SpringApplication` 时通常最好调用 `setWebApplicationType(WebApplicationType.NONE)`

### 1.9 访问应用参数

如果你需要访问传递到 `SpringApplication.run(...)` 的应用参数，你可以注入一个 `org.springframework.boot.ApplicationArguments` bean。`ApplicationArguments` 接口提供了访问原始 `String[]` 参数和解析好的 `option` 和 `non-option` 参数，就像下面例子展示的：

```java
@Component
public class MyBean {

    public MyBean(ApplicationArguments args) {
        boolean debug = args.containsOption("debug");
        List<String> files = args.getNonOptionArgs();
        if (debug) {
            System.out.println(files);
        }
        // if run with "--debug logfile.txt" prints ["logfile.txt"]
    }

}
```

> Spring Boot 也会注册一个拥有 Spring `Environment` 的 `CommandLinePropertySource`。这使得你也可以通过 `@Value` 注解来注入单个应用参数。

### 1.10 使用 ApplicationRunner 或 CommandLineRunner

如果你需要在 `SpringApplication` 启动时运行一些特定的代码，你可以实现 `ApplicationRunner` 或 `CommandLineRunner` 接口。两个接口都按同样的方式运行，提供一个独立的 `run` 方法，它会在 `SpringApplication.run(...)` 完成前被调用。

> 这个合约非常适合在应用程序启动之后但在开始接受流量之前运行的任务

`CommandLineRunner` 接口以字符串数组的形式提供应用参数的访问，而 `ApplicationRunner` 使用前面讨论的 `ApplicationArguments` 接口。下面例子展示了一个具有 `run` 方法的 `CommandLineRunner`：

```java
@Component
public class MyCommandLineRunner implements CommandLineRunner {

    @Override
    public void run(String... args) {
        // Do something...
    }

}
```

如果多个需要按指定顺序调用的 `CommandLineRunner` 或 `ApplicationRunner` bean 被定义，你可以额外实现 `org.springframework.core.Ordered` 接口或使用 `org.springframework.core.annotation.Order` 注解。

### 1.11 应用退出

每个 `SpringApplication` 都会向 JVM 注册一个关闭钩子来确保 `ApplicationContext` 在退出时优雅地关闭。所有标准 Spring 生命周期回调（例如 `DisposableBean` 接口或 `@PreDestroy` 注解）可以被使用。

此外，bean 如果想要在调用 `SpringApplication.exit()` 时返回一个特定的退出码可以实现 `org.springframework.boot.ExitCodeGenerator` 接口。这个退出码能够传递给 `System.exit()` 来作为一个状态码返回，就像下面例子展示的：

```java
@SpringBootApplication
public class MyApplication {

    @Bean
    public ExitCodeGenerator exitCodeGenerator() {
        return () -> 42;
    }

    public static void main(String[] args) {
        System.exit(SpringApplication.exit(SpringApplication.run(MyApplication.class, args)));
    }

}
```

同样地，`ExitCodeGenerator` 接口可以被异常实现。当遇到这样的异常时，Spring Boot 返回实现的 `getExitCode()` 方法中提供的退出码。

如果有多个 `ExitCodeGenerator`，生成的第一个非零的退出码将被使用。为了控制生成器调用的顺序，可以额外实现 `org.springframework.core.Ordered` 接口或使用 `org.springframework.core.annotation.Order` 注解。

### 1.12 管理员特性

通过指定 `spring.application.admin.enabled` 配置可以为应用启用管理员相关特性。这将在 `MBeanServer` 平台上公开 `SpringApplicationAdminMXBean`。你可以使用这个特性来远程管理你的 Spring Boot 应用。这个特性对于任何服务包装器实现都很有用。

> 如果你想要知道正在运行的应用使用哪个 HTTP 端口，通过 `local.server.port` 键获取配置项

### 1.13 应用启动跟踪

在应用启动时，`SpringApplication` 和 `ApplicationContext` 展示了许多和应用生命周期、bean 生命周期或甚至运行中应用事件等相关的任务。通过 `ApplicationStartup`，Spring 框架允许你通过 `StartupStep` 对象追踪应用启动序列。收集这些数据可以用于分析目的，或者只是为了更好地了解应用程序启动过程。

你可以在设置 `SpringApplication` 实例时选择一个 `ApplicationStartup` 实现。例如，要使用 `BufferingApplicationStartup`，你可以写下：

```java
@SpringBootApplication
public class MyApplication {

    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(MyApplication.class);
        application.setApplicationStartup(new BufferingApplicationStartup(2048));
        application.run(args);
    }

}
```

第一个可用的实现，`FlightRecorderApplicationStartup` 由 Spring 框架提供。它将 Spring 特定的启动事件添加到 Java 飞行记录仪（Flight Recorder）会话中，用于分析应用程序并将其 Spring 上下文生命周期与 JVM 事件相关联（如分配、GC、类加载……）。一旦被配置，你可以通过运行启用了飞行记录仪的应用来记录数据：

```shell
$ java -XX:StartFlightRecording:filename=recording.jfr,duration=10s -jar demo.jar
```

Spring Boot 装载 `BufferingApplicationStartup` 变体，这个实现类用于缓存启动步骤并将它们输出到外部统计系统。应用可以在任何的组件中请求 `BufferingApplicationStartup` 类型的 bean。

Spring Boot 也可以被配置为公开一个 `startup` 端点来提供 JSON 文档格式的信息。

## 2. 外部化配置

Spring Boot 允许你外部化你的配置，这样你可以在不同的环境使用同一套应用代码。你可以使用各种外部配置资源，包括 Java 属性文件，YAML 文件，环境变量和命令行参数。

属性值可以使用 `@Value` 注解直接注入到你的 bean 中，通过 Spring 的 `Environment` 抽象来访问，或通过 `@ConfigurationProperties` 来绑定到结构化对象上。

Spring Boot 使用一个非常特别的 `PropertySource` 顺序，设计的目的是允许合理地覆写值。后面的属性源可以覆写前面定义的值。源被按照下面的顺序排列：

1. 默认配置文件（被设置的 `SpringApplication.setDefaultProperties` 指定）。
2. 在你 `@Configuration` 类上的 `@PropertySource` 注解。请注意这属性源直到应用上下文被刷新时并不会添加到 `Environment` 中。配置特定的属性会为时已晚，例如在刷新开始前读取的 `logging.*` 和 `spring.main.*`。
3. 配置数据（例如 `application.properties` 文件）
4. 只在 `random.*` 中拥有属性的 `RandomValuePropertySource`
5. 操作系统环境变量
6. Java 系统属性（`System.getProperties()`）
7. `java:comp/env` 中的 JNDI 属性
8. `ServletContext` 初始化参数
9. `ServletConfig` 初始化参数
10. `SPRING_APPLICATION_JSON` 中的属性（内嵌在一个环境变量或者系统属性中的内联 JSON）
11. 命令行参数
12. 你的测试的 `properties` 属性。在 `@SpringBootTest` 和为了测试你应用的特定切片的测试注解中可用。
13. 你测试中的 `@TestPropertySource` 注解
14. 开发工具启用时在 `$HOME/.config/spring-boot` 文件夹中的开发工具全局设置属性

配置数据文件按照如下顺序排列：

1. 打包在你的 jar 包内的应用属性（`application.properties` 和 YAML 变体）
2. 打包在你的 jar 包内的特定 profile 的应用属性（`application-{profile}.properties` 和 YAML 变体）
3. 在你的 jar 包外的应用属性（`application.properties` 和 YAML 变体）
4. 在你的 jar 包外的特定 profile 的应用属性（`application-{profile}.properties` 和 YAML 变体）。

> 建议在你的整个应用中坚持一个格式。如果你在同一个位置既有 `.properties` 又有 `.yml` 格式的配置文件，`.properties` 优先

提供一个具体的例子，假设你开发了一个使用 `name` 属性的 `@Component`，就像下面例子展示的：

```java
@Component
public class MyBean {

    @Value("${name}")
    private String name;

    // ...

}
```

在你的应用 classpath（例如，在你的 jar 中）你可以设置一个为 `name` 提供合理默认属性值的 `application.properties` 文件。当在一个新环境中运行时，可以在你的 jar 包外提供一个 `application.properties` 文件来覆写 `name`。对于一次性测试，可以使用特定的命令行开关启动（例如，`java -jar app.jar --name="Spring"`）。

> `env` 和 `configprops` 端点可以用于确定属性具有特定值的原因。可以使用这两个端点来诊断意外的属性值。参考“生产环境就绪特性”一节来获取细节。

### 2.1 访问命令行属性

默认情况下，`SpringApplication` 转换所有的命令行可选参数（即，`--` 开始的参数，例如 `--server.port=9000`）到一个 `property` 中，并将它们添加到 Spring `Environment`。像前面提到的，命令行属性总是优先于基于文件的属性源。

如果你不想希望命令行被添加到 `Environment`，你可以使用 `SpringApplication.setAddCommandLineProperties(false)` 禁用它们。

### 2.2 JSON 应用属性

环境变量和系统变量经常有限制，这意味着不能使用部分属性名。为了帮助改变这点，Spring Boot 允许你将一个属性块编码为一个 JSON 结构。

当你的应用启动时，任何 `spring.application.json` 或 `SPRING_APPLICATION_JSON` 属性将被编译和添加到 `Environment`。

例如，`SRPING_APPLICATION_JSON` 属性可以作为环境变量在 UN*X shell 的命令行中提供：

```shell
$ SPRING_APPLICATION_JSON='{"my":{"name":"test"}}' java -jar myapp.jar
```

在前面的例子中，你最后在 Spring `Environment` 中添加了 `my.name=test`

一样的 JSON 可以作为系统属性提供：

```shell
$ java -Dspring.application.json='{"my":{"name":"test"}}' -jar myapp.jar
```

或者你可以使用一个命令行参数来提供 JSON：

```shell
$ java -jar myapp.jar --spring.application.json='{"my":{"name":"test"}}'
```

如果你正在部署一个经典的应用服务器，你也可以使用命名为 `java:comp/env/spring.application.json` 的 JNDI 变量。

> 虽然 JSON 的 `null` 值被添加到生成的属性源中，但 `PropertySourcesPropertyResolver` 将 `null` 属性视为缺失值。这意味着 JSON 不能使用 `null` 值覆盖更低顺序的属性源。

### 2.3 外部应用属性

Spring Boot 将在你的应用启动时从下面位置自动找到并加载 `application.properties` 和 `application.yaml` 文件：

1. 从 classpath
   1. classpath 根目录
   2. classpath `/config` 包
2. 从当前的目录
   1. 当前目录
   2. 当前目录的 `config/` 子目录
   3. `config/` 子目录的直接子目录

列表按优先级排序（较低项目的值优先于较早项目的值）。加载文件中的文档将作为 `PropertySources` 添加到 Spring `Environment`。

如果你不喜欢 `application` 作为配置文件名字，你可以指定 `spring.config.name` 环境属性来切换到其他文件名。例如，为了寻找 `myproject.properties` 和 `myproject.yaml` 文件，你可以按下面运行你的应用：

```shell
$ java -jar myproject.jar --spring.config.name=myproject
```

你也可以使用 `spring.config.location` 环境属性来引用显式位置。这个属性接受用逗号分隔的一个或多个要检查的位置的列表。

下面例子展示了怎么指定两个不同的文件：

```shell
$ java -jar myproject.jar --spring.config.location=\
    optional:classpath:/default.properties,\
    optional:classpath:/override.properties
```

> 如果位置是可选的且你不介意它们不存在时，使用 `optional:` 前缀。

> `spring.config.name`，`spring.config.location`，和 `spring.config.additional-location` 很早就决定必须加载哪些文件。它们必须定义为环境属性（通常是操作系统环境变量、系统属性或命令行参数）。

如果 `spring.config.location` 包含目录（而不是文件），它们应该以 `/` 结尾。运行时它们会在加载前拼接上 `spring.config.name` 生成的名字。在 `spring.config.location` 中指定的文件则直接被导入。

> 目录和文件位置值也都会扩展到检查指定 profile 的文件。例如，如果你有一个为 `classpath:myconfig.properties` 的 `spring.config.location`，你将会发现合适的 `classpath:myconfig-<profile>.properties` 文件也被加载了。

大多数场景下，你添加的每个 `spring.config.location` 项目会引用一个独立的文件或目录。位置是按它们定义的顺序处理的，所以后面的可以覆写前面的值。

如果你有复杂的位置设置，且你需要 profile 特定的配置文件，你可能需要提供更多提示来让 Spring Boot 知道它们应该如何分组。一个位置组是指一个被认为处于同一层级的位置的集合。例如，你可能想要把全部 classpath 位置分组，然后把所有外部位置分组。在位置组中的项目应该使用 `;` 分隔。参考“指定 profile 的文件”一节获取更多细节。

使用 `spring.config.location` 配置的位置会替代默认位置。例如，如果 `spring.config.location` 被配置为 `optional:classpath:/custom-config/,optional:file:./custom-config/`，完整的位置集是如下：

1. `optional:classpath:/;optional:classpath:/config/`
2. `optional:file:./;optional:file:./config/;optional:file:./config/*/`
3. `optional:classpath:custom-config/`
4. `optional:file:./custom-config/`

这个搜索顺序可以让你在一个配置文件中指定默认值，然后有选择性的覆写其他文件里的值。你可以在 `application.properties`（或者其他你用 `spring.config.name` 选择的基础名字）在默认位置中的一个中给你的应用提供默认值。这些默认值可以在运行时被其他在自定义位置之一中的不同的文件所覆写。

> 如果你使用环境变量而不是系统属性，大多数的操作系统不允许使用句号分隔的键名，但可以使用下划线（例如，`SPRING_CONFIG_NAME` 而不是 `spring.config.name`）。参考“从环境变量绑定”来获取细节。

> 如果你的应用运行在 servlet 容器或者应用服务器里，则可以使用 JNDI 属性（在 `java:comp/env`）或 servlet 上下文初始化参数来替代环境变量或系统属性。

#### 2.3.1 可选位置

默认情况下，当指定的配置数据位置不存在时，Spring Boot 将抛出 `ConfigDataLocationNotFoundException` 且你的应用不会启动。

如果你希望指定一个位置，但你并不介意它是否存在，你可以使用 `optional:` 前缀。你可以通过 `spring.config.location` 和 `spring.config.additional-location` 属性和 `spring.config.import` 声明使用这个前缀。

例如，一个值为 `optional:file:./myconfig.properties` 的 `spring.config.import` 允许即使在没有 `myconfig.properties` 文件的情况下你的应用仍可以启动。

如果你希望忽略所有 `ConfigDataLocationNotFoundExceptions` 且总是继续启动你的应用，你可以使用 `spring.config.on-not-found` 属性。使用 `SpringApplication.setDefaultProperties(...)` 或使用系统/环境变量设置值为 `ignore`。

#### 2.3.2 通配符位置

如果一个配置文件位置包括最后路径部分的 `*` 字符，它被视为一个通配符位置。通配符是在配置被加载时被扩展，这样直接子目录也被检查。通配符位置在有多个配置属性来源的例如 Kubernetes 的环境特别有用。

例如，如果你有一些 Redis 配置和一些 MySQL 配置，你可能想让那两部分配置保持分离，同时要求 `application.properties` 文件中出现这两者。这可能导致两个分离的 `application.properties` 文件装载在不同位置例如 `/config/redis/application.properties` 和 `/config/mysql/application.properties`。在这种情况下，拥有一个 `config/*/` 通配符位置，可以使两个文件都被处理。

默认情况下，Spring Boot 在默认的搜索位置中包括了 `config/*/`。它意味着将搜索所有你的 jar 外的 `/config` 目录的子目录。

你可以用 `spring.config.location` 和 `spring.config.additional-location` 属性使用通配符位置。

> 一个通配符位置必须只包括一个 `*` 和以 `*/` 结束来搜索那些文件夹或 `*/<filename>` 来搜索文件位置。通配符位置会根据文件名的绝对路径字母表顺序排序

> 通配符位置仅可在外部目录使用。你不能在 `classpath:` 位置使用通配符

#### 2.3.3 指定 profile 的文件

和 `application` 属性文件一样，Spring Boot 将尝试使用 `application-{profile}` 命名规范加载指定 profile 的文件。例如，如果你的应用激活了一个叫 `prod` 的 profile 且使用 YAML 文件，那么 `application.yml` 和 `application-prod.yml` 将被考虑。

profile 指定属性从和标准的 `application.properties` 同样的位置加载，且指定 profile 的文件总会覆写不指定的。如果指定了几个 profile，采用后来者胜策略。例如，如果 profile `prod,live` 被 `spring.profiles.active` 属性指定，则 `application-prod.properties` 中的值可以被 `application-live.properties` 覆写。

> 后来者胜策略在位置组维度应用。一个 `classpath:/cfg/,classpath:/ext/` 的 `spring.config.location` 的覆写规则将和 `classpath:/cfg/;classpath:/ext/` 不同。
>
> 例如，继续我们前面的 `prod,live` 例子，我们可能拥有下面的文件：
>
> ```
> /cfg
> 	application-live.properties
> /ext
> 	application-live.properties
> 	application-prod.properties
> ```
>
> 当我们拥有 `classpath:/cfg/,classpath:/ext/` 的 `spring.config.location` 时，我们将在所有 `/ext` 文件前处理所有 `/cfg` 文件：
>
> 1. `/cfg/application-live.properties`
> 2. `/ext/application-prod.properties`
> 3. `/ext/application-live.properties`
>
> 当我们拥有 `classpath:/cfg/;classpath:/ext/` 作为替换时（使用 `;` 分隔符），我们在同样的层级处理 `/cfg` 和 `/ext`：
>
> 1. `/ext/application-prod.properties`
> 2. `/cfg/application-live.properties`
> 3. `/ext/application-live.properties`

`Environment` 具有一组默认的 profile（默认情况下，`[default]`）会在没有激活的 profile 被设置时使用。换句话说，如果没有 profile 被显式的激活的话，使用 `application-default` 的属性 。

> 属性文件只被加载一次。如果你已经直接导入一个指定 profile 的文件，那么它将不会被第二次导入。

#### 2.3.4 导入额外的数据

应用属性可能使用 `spring.config.import` 属性从其他位置导入更多配置数据。导入在被发现时被处理，且被视为插入声明导入的文档下面的附加文档。

例如，你可能在你的 classpath 中有如下 `application.properties` 文件：

```properties
spring.application.name=myapp
spring.config.import=optional:file:./dev.properties
```

这将在当前文件夹触发 `dev.properties` 文件的导入（如果这样的文件存在）。导入的 `dev.properties` 的值将优先于触发导入的文件。在上面的例子中，`dev.properties` 可以重新定义 `spring.application.name` 为一个不同的值。

无论被声明多少次，一个导入只会被导入一次。导入在一个 properties 或 yaml 文件中被定义的顺序并无影响。例如，下面两个例子产生相同的结果：

```properties
spring.config.import=my.properties
my.property=value
```

```properties
my.property=value
spring.config.import=my.properties
```

在上面两个例子中，`my.properties` 文件的值将优先于触发导入的文件。

一个 `spring.config.import` 可以指定几个位置。位置会按它们被定义的顺序处理，后导入的优先。

> 适当的时候，还会考虑指定 profile 的变体来导入。上面例子将导入 `my.properties` 和 `my-<profile>.properties` 变体。

> Spring Boot 包含允许支持不同的位置地址的可插拔 API。默认情况下，你可以导入 Java Properties，YAML 和 “配置树”。
>
> 三方 jar 可以提供额外的技术支持（并不需要文件在本地）。例如，你可以想象从外部存储，例如 Consul，Apache ZooKeeper 或 Netflix Archaius，来的配置数据。
>
> 如果你希望支持你自己的位置，参考 `org.springframework.boot.context.config` 包的 `ConfigDataLocationResolver` 和 `ConfigDataLoader` 类。

#### 2.3.5 导入无扩展名文件

一些云平台不能向卷加载的文件添加文件扩展名。要导入这些无扩展名文件，你需要给 Spring Boot 一个提示，以便它知道如何加载它们。你可以通过在方括号中放置扩展提示来完成此操作。

例如，假设你有一个你想作为 yaml 导入的 `/etc/config/myconfig` 文件。你可以使用下面语句从你的 `application.properties` 中导入它：

```properties
spring.config.import=file:/etc/config/myconfig[.yaml]
```

#### 2.3.6 使用配置树

当在云平台（例如 Kubernetes）运行应用时，你经常需要读取平台提供的配置值。这种目的下使用环境变量并不罕见，但这可能会有缺点，特别是如果值应该保密的话。

作为环境变量的替代品，许多云平台现在允许你将配置映射到装载的数据卷中。例如，Kubernetes 可以卷装载 `ConfigMaps` 和 `Secrets`。

可以使用两种常见的卷装载模式：

1. 单个文件包含一组完整的属性（通常写成 YAML）
2. 多个文件被写入目录树，文件名变为“key”，内容变为“value”。

对于第一种情况，可以像上面所述直接使用 `spring.config.import` 直接导入 YAML 或 Properties 文件。对于第二种情况，你需要使用 `configtree:` 前缀，这样 Spring Boot 才知道它需要将所有文件作为属性公开。

例如，让我们假设 Kubernetes 加载了以下卷：

```
etc/
  config/
    myapp/
      username
      password
```

`username` 文件的内容将作为一个配置值，且 `password` 的内容将作为密钥。

为了导入这些属性，你可以添加下面的内容到你的 `application.properties` 或 `application.yaml` 文件：

```properties
spring.config.import=optional:configtree:/etc/config/
```

你可以按通常的方式从 `Environment` 访问或注入 `myapp.username` 和 `myapp.password` 属性。

> 配置树下的文件夹构成属性名称。在上面的示例中，要访问作为 `username` 和 `password` 的属性，可以设置 `spring.config.import` 为 `optional:configtree:/etc/config/myapp`

> 点符号的文件名也会正确映射。例如，在上面的示例中，一个名叫 `myapp.username` 的文件在 `/etc/config` 中的话，将在 `Environment` 中生成 `myapp.username` 属性。

> 配置树值可以根据期待的内容绑定到 `String` 和 `byte[]` 类型。

如果你有多个配置树要从一个父文件夹导入的话，你可以使用通配符快捷方式。任何以 `/*/` 结尾的  `configtree:` 位置将所有直接子级作为配置树导入。

例如，有下面卷：

```
etc/
  config/
    dbconfig/
      db/
        username
        password
    mqconfig/
      mq/
        username
        password
```

你可以使用 `configtree:/etc/config/*/` 作为导入位置：

```properties
spring.config.import=optional:configtree:/etc/config/*/
```

这将增加 `db.username`，`db.password`，`mq.username` 和 `mq.password` 属性。

> 使用通配符加载的目录按照字母表顺序排序。如果你需要不同的顺序，那么你应该将每个位置单独导入。

配置树也可以用作 Docker 密钥。当 Docker swarm 服务被授权访问一个密钥，密钥被装载到容器。例如，如果一个叫作 `db.password` 的密钥被装载到 `/run/secrets/` 位置，你可以使用以下内容让 `db.password`  在 Spring 环境可用：

```properties
spring.config.import=optional:configtree:/run/secrets/
```

#### 2.3.7 属性占位符

在 `application.properties` 和 `application.yml` 中的值在它们被使用时会使用已存在的 `Environment` 过滤，所以你可以引用前面定义的值（例如，从系统属性或环境变量）。标准的 `${name}` 属性占位符语法可以在任何值中使用。属性占位符可以使用分隔默认值和属性名的 `:` 来指定一个默认值，例如 `${name:default}`。

使用有默认值和没有默认值的占位符都在下面的例子中展示：

```properties
app.name=MyApp
app.description=${app.name} is a Spring Boot application written by ${username:Unknown}
```

假设 `username` 属性没有在其他地方被定义，`app.description` 将具有值 `MyApp is a Spring Boot application written by Unknown`。

> 你应该总是使用规范形式（只使用小写字符的中划线格式，即 kebab-case）使用占位符的属性名。这将使得 Spring Boot 可以使用和宽松绑定 `@ConfigurationProperties` 相同的逻辑。
>
> 例如，`${demo.item-prive}` 会将 `demo.item-price` 和 `demo.itemPrice` 格式都从 `application.properties` 文件中匹配起来，以及系统环境中的 `DEMO_ITEMPRICE`。如果你使用 `${demo.itemPrice}` 的话，`demo.item-price` 和 `DEMO_ITEMPRICE` 将不会被认为是。

> 你也可以使用这个技术来创建现有 Spring Boot 属性的“短”变体。

#### 2.3.8 使用多文档文件

Spring Boot 允许你将一个物理文件分割成多个各自独立添加的逻辑文档。文档按顺序处理，从上至下。后面的文档可以覆写前面定义的属性。

对于 `application.yml` 文档，使用标准 YAML 多文档语法。三个连续的连字符表示一个文档的结尾和下一个文档的开始。

例如，下面文件有两个逻辑文档：

```yaml
spring:
  application:
    name: "MyApp"
---
spring:
  application:
    name: "MyCloudApp"
  config:
    activate:
      on-cloud-platform: "kubernetes"
```

对于 `application.properties` 文件，特殊的 `#---` 或 `!---` 注释被用来标记文档分隔：

```properties
spring.application.name=MyApp
#---
spring.application.name=MyCloudApp
spring.config.activate.on-cloud-platform=kubernetes
```

> 属性文件分隔符不可以有先导空格，且必须是刚好三个连字符字符。分隔符前后的行不能是相同的注释前缀。

> 多文档属性文件经常与 `spring.config.activate.on-profile` 属性一同使用。参考下一节来获取细节。

> 多文档属性文件不能使用 `@PropertySource` 或 `@TestPropertySource` 注解加载。

#### 2.3.9 激活属性

在某些时候，特定的条件下，只激活给定的一组属性会很有用。例如，你可能有一些当特定 profile 被激活时才相关的属性。

你可以使用 `spring.config.activate.*` 条件性地激活一个属性文档。

下面激活属性是可用的：

| 属性                | 备注                                         |
| ------------------- | -------------------------------------------- |
| `on-profile`        | 要使文档被激活而必须匹配的 profile 表达式    |
| `on-cloud-platform` | 要使文档被激活而必须被检测的 `CloudPlatform` |

例如，下面指定了第二个文件只在运行于 Kubernetes 时且只当“prod”或“staging” profile 被激活时激活：

```properties
myprop=always-set
#---
spring.config.activate.on-cloud-platform=kubernetes
spring.config.activate.on-profile=prod | staging
myotherprop=sometimes-set
```

### 2.4 加密属性

Spring Boot 并没有提供任何内建的加密属性值的支持，但是，它提供了必要的钩点来修改 Spring `Environment` 中装载的值。`EnvironmentPostProcessor` 接口允许你在应用启动前操作 `Environment`。

如果你需要一种安全的存储证书和密码的方式，Spring Cloud Vault 项目提供了存储在 HashiCorp Vault 中的外部化配置的支持。

### 2.5 使用 YAML

YAML 是 JSON 的超集，因此是指定分层配置数据的方便格式。只要类路径(classpath)上有 SnakeYAML 库，`SpringApplication` 类就会自动支持 YAML 作为属性的替代。

> 如果你使用“Starter”，SnakeYAML 在 `spring-boot-starter` 中自动提供。

#### 2.5.1 映射 YAML 到 Properties

YAML 文档需要从它们的分层格式转换为可用于 Spring 环境的平面结构。例如，考虑如下 YAML 文件：

```yaml
environments:
	dev:
		url: "https://dev.example.com"
		name: "Develop Setup"
	prod:
		url: "https://another.example.com"
		name: "My Cool App"
```

为了从 `Environment` 中访问这些属性，他们将按如下方式展开：

```properties
environments.dev.url=https://dev.example.com
environments.dev.name=Developer Setup
environments.prod.url=https://another.example.com
environments.prod.name=My Cool App
```

类似的，YAML list 也需要被展开。它们表示为有 `[index]` 解引用器的属性键。例如，考虑以下 YAML：

```yaml
my:
 servers:
 - "dev.example.com"
 - "another.example.com"
```

前面的例子将被转为这些属性：

```properties
my.servers[0]=dev.example.com
my.servers[1]=another.example.com
```

> 使用 `[index]` 符号的属性可以使用 Spring Boot 的 `Binder` 类绑定到 Java `List` 或 `Set` 对象。有关详细信息，请参阅下面的“类型安全配置属性”部分。

> YAML 文件不能使用 `@PropertySource` 或 `@TestPropertySource` 注解加载。所以如果你需要通过那些方式加载值的话，你需要使用属性文件。

#### 2.5.2 直接加载 YAML

Spring 框架提供两个方便的可以用来加载 YAML 文档的类。`YamlPropertiesFactoryBean` 将 YAML 加载为 `Properties` 以及 `YamlMapFactoryBean` 将 YAML 加载为 `Map`。

你也可以使用 `YamlPropertySourceLoader` 类如果你想将 YAML 加载为 Spring 的 `PropertySource`。

### 2.6 配置随机值

`RandomValuePropertySource` 在注入随机值（例如，作为密钥或测试用例）时很有用。它可以提供 integer、long、uuid 或字符串，例子如下：

```properties
my.secret=${random.value}
my.number=${random.int}
my.bignumber=${random.long}
my.uuid=${random.uuid}
my.number-less-than-ten=${random.int(10)}
my.number-in-range=${random.int[1024,65536]}
```

`random.int*` 语法是 `OPEN value (,max) CLOSE`，其中 `OPEN,CLOSE` 是任意字符而 `value,max` 是 integer。如果 `max` 被提供，那么 `value` 就是最小值而 `max` 是最大值（不包含）。

### 2.7 配置系统环境属性

Spring Boot 支持设置一个环境属性的前缀。这在系统环境被多个需要不同配置的 Spring Boot 应用分享时很有用。系统环境属性前缀可以直接在 `SpringApplication` 上被设置。

例如，如果你想将前缀设置为 `input`，一个类似 `remote.timeout` 的属性也将在系统环境中被解析为 `input.remote.timeout`。

### 2.8 类型安全的配置属性

使用 `@Value("${property}")` 注解来注入配置属性有时会显得笨重，尤其是你在处理多个属性或你的数据本质上具有层级结构时。Spring Boot 提供了一种使用属性的替代方法，该方法允许强类型 Bean 管理和验证应用程序的配置。

> 参考“`@Value` 和类型安全的配置属性的差别”

#### 2.8.1 JavaBean 属性绑定

可以绑定一个声明了标准 JavaBean 属性的 bean，就像下面例子中展示的：

```java
@ConfigurationProperties("my.service")
public class MyProperties {
    private boolean enabled;
    private InetAddress remoteAddress;
    private final Security security = new Security();

    // getters / setters...

    public static class Security {
        private String username;
        private String password;
        private List<String> roles = new ArrayList<>(Collections.singleton("USER"));

        // getters / setters...
    }
}
```

前面的 POJO 定义了下面的属性：

- `my.service.enabled`，默认值为 `false`
- `my.service.remote-address`，具有一个可以从 `String` 强转的类型
- `my.service.security.username`，带有一个名字被该属性决定的嵌套的 “security” 对象。特别的，该类型根本没有被使用时，可能是 `SecurityProperties`。
- `my.service.security.password`
- `my.service.security.roles`，一个 `String` 的集合默认为 `USER`。

> 通过属性文件、YAML文件、环境变量和其他机制进行配置的，映射到 Spring Boot 中可用的 `@ConfigurationProperties` 类的属性是公共API，但类本身的访问器（getter/setter）并不能直接使用。

> 这种安排依赖于默认的空构造函数，getter 和 setter 通常是强制性的，因为绑定是通过标准的JavaBeans属性描述符进行的，就像在SpringMVC中一样。在下列情况下，可以省略 setter：
>
> - 只要映射被初始化，就需要 getter，但不一定需要 setter，因为它们可以被绑定器改变。
> - 可以通过索引（通常使用 YAML）或使用单个逗号分隔的值（属性）访问集合和数组。在后一种情况下，setter 是必需的。我们建议始终为此类类型添加 setter。如果初始化集合，请确保它不是不可变的（如前一个示例所示）。
> - 如果初始化了嵌套的 POJO 属性（如前面示例中的 `Security` 字段），则不需要 setter。如果希望绑定器使用其默认构造函数动态创建实例，则需要 setter。
>
> 有些人使用 Project Lombok 自动添加 getter 和 setter。确保 Lombok 不会为此类类型生成任何特定的构造函数，因为容器会自动使用它来实例化对象。
>
> 最后，只考虑标准 JavaBean 属性，不支持对静态属性的绑定。

#### 2.8.2 构造器绑定

之前一节的例子可以使用不可变的方式重写，如下所示：

```java
@ConfigurationProperties("my.service")
public class MyProperties {
    // fields...

    public MyProperties(boolean enabled, InetAddress remoteAddress, Security security) {
        this.enabled = enabled;
        this.remoteAddress = remoteAddress;
        this.security = security;
    }

    // getters...

    public static class Security {
        // fields...

        public Security(String username, String password, @DefaultValue("USER") List<String> roles) {
            this.username = username;
            this.password = password;
            this.roles = roles;
        }

        // getters...
    }

}
```

在这个设置中，单独的参数化的构造器的出现说明应该使用构造器绑定。这说明绑定将找到一个包含你希望绑定参数的构造函数。如果类有多个构造函数，则 `@ConstructorBinding` 注解可用于指定要用于构造器绑定的构造函数。若要选择不使用带有单个参数化构造函数的类的构造器绑定，必须使用 `@Autowired` 对构造函数进行绑定。如果您使用的是 Java 16 或更高版本，则可以对记录（record）使用构造器绑定。除非你的记录有多个构造函数，否则不需要使用 `@ConstructorBinding`。

构造函数绑定类（如上面示例中的 `Security`）的嵌套成员也将通过其构造函数绑定。

可以在构造函数参数和记录组件上使用 `@DefaultValue` 指定默认值。转换服务将应用于将注释的 `String` 值强制转换为缺少属性的目标类型。

参考上一个示例，如果没有属性绑定到 `Security`，则 `MyProperties` 实例将包含一个 `null` 的 `security` 值。要使其包含非空的 `Security` 实例，即使没有属性绑定到它（使用 Kotlin 时，这将要求 `Security` 的 `username` 和 `password` 参数声明为可空，因为它们没有默认值），请使用空的 `@DefaultValue` 注释：

```java
public MyProperties(boolean enabled, InetAddress remoteAddress, @DefaultValue Security security) {
    this.enabled = enabled;
    this.remoteAddress = remoteAddress;
    this.security = security;
}
```

> 若要使用构造器绑定，必须使用 `@EnableConfigurationProperties` 或配置属性扫描来启用类。不能将构造函数绑定用于由常规 Spring 机制创建的 Bean（例如 `@Component` Bean、使用 `@Bean` 方法创建的 Bean 或使用 `@Import` 加载的 Bean）

>要在本地镜像中使用构造器绑定，必须使用 `-parameters` 编译该类。如果您使用 Spring Boot 的 Gradle 插件或使用 Maven 和 `spring-boot-starter-parent`，这将自动发生。

> 不建议将 `java.util.Optional` 与 `@ConfigurationProperties` 一起使用，因为它主要用作返回类型。因此，它不太适合配置属性注入。为了与其他类型的属性保持一致，如果您声明了一个 `Optional` 属性并且它没有值，那么将绑定 `null` 而不是空的 `Optional`。

#### 2.8.3 启用 @ConfigurationProperties 注解的类型

Spring Boot 提供了绑定 `@ConfigurationProperties` 类型的基础设施，且将它们注册为 bean。你可以逐个类地启用配置属性，也可以启用配置属性扫描，其工作方式与组件扫描类似。

有时，注解 `@ConfigurationProperties` 的类可能不适合扫描，例如，如果你正在开发你自己的自动配置或者你希望条件性地启用它们。在这些情况下，使用 `@EnableConfigurationProperties` 注解指明要处理的类型列表。这可以在任何 `@Configuration` 类上完成，如下例所示：

```java
@Configuration(proxyBeanMethods = false)
@EnableConfigurationProperties(SomeProperties.class)
public class MyConfiguration {

}
```

要使用配置属性扫描，请将 `@ConfigurationPropertiesScan` 注解添加到应用程序中。通常，它被添加到用 `@SpringBootApplication` 注解的主应用程序类中，但它也可以添加到任何 `@Configuration` 类中。默认情况下，扫描将从声明注解的类的包中进行。如果你希望定义要扫描的特定包，可以按以下示例所示进行操作：

```java
@SpringBootApplication
@ConfigurationPropertiesScan({ "com.example.app", "com.example.another" })
public class MyApplication {

}
```

> 当使用配置属性扫描或通过 `@EnableConfigurationProperties` 注册 `@ConfigurationProperties` bean 时，bean 具有常规名称：`<prefix>-<fqn>`，其中 `<prefix>` 是 `@ConfigurationProperties` 注解中指定的环境键前缀，`<fqn>` 是 bean 的完全限定名称。如果注解不提供任何前缀，则只使用 bean 的完全限定名称。
>
> 上面示例中的 bean 名称是 `com.example.app-com.example.app.SomeProperties`。

我们建议 `@ConfigurationProperties` 只处理环境，特别是不从上下文注入其他 bean。对于边界情况，可以使用 setter 注入或框架提供的任何 `*Aware` 接口（如需要访问环境时使用 `EnvironmentAware`）。如果您仍然希望使用构造函数注入其他 bean，则必须使用 `@Component` 注解配置属性 bean，并使用基于 JavaBean 的属性绑定。

#### 2.8.4 使用 @ConfigurationProperties 注解的类型

这种配置在 `SpringApplication` 外部的 YAML 配置中尤其适用，如下例所示：

```yaml
my:
  service:
    remote-address: 192.168.1.1
    security:
      username: "admin"
      roles:
      - "USER"
      - "ADMIN"
```

为了和 `@ConfigurationProperties` bean 一同工作，你可以用和其他 bean 相同的方式注入它们，如下例所示：

```java
@Service
public class MyService {

    private final MyProperties properties;

    public MyService(MyProperties properties) {
        this.properties = properties;
    }

    public void openConnection() {
        Server server = new Server(this.properties.getRemoteAddress());
        server.start();
        // ...
    }

    // ...

}
```

> 使用 `@ConfigurationProperties` 也让你可以生成用于 IDE 给你的自定义键提供自动补全的元数据文件。参考附录来获取细节。

#### 2.8.5 三方配置

就和使用 `@ConfigurationProperties` 来注解类一样，你也可以在公共的 `@Bean` 方法上使用它。当您希望将属性绑定到不受您控制的第三方组件时，这样做特别有用。

为了配置来自 `Environment` 属性的 bean，给它的 bean 注册添加 `@ConfigurationProperties`，如下例所示：

```java
@Configuration(proxyBeanMethods = false)
public class ThirdPartyConfiguration {
    @Bean
    @ConfigurationProperties(prefix = "another")
    public AnotherComponent anotherComponent() {
        return new AnotherComponent();
    }
}
```

使用 `another` 前缀定义的任何 JavaBean 属性会被映射到 `AnotherComponent` bean，使用和前面 `SomeProperties` 例子类似的方式。

#### 2.8.6 宽松绑定

Spring Boot 使用一些宽松的规则将 `Environment` 属性绑定到 `@ConfigurationProperties` bean，因此 `Environment` 属性名称和 bean 属性名称之间不需要完全匹配。这很有用的常见示例包括用破折号分隔的环境属性（例如，`context-path` 绑定到 `contextPath`）和大写环境属性（如，`PORT` 绑定到 `port`）。

例如，考虑以下 `@ConfigurationProperties` 类：

```java
@ConfigurationProperties(prefix = "my.main-project.person")
public class MyPersonProperties {

    private String firstName;

    public String getFirstName() {
        return this.firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

}
```

对于前面的代码，可以使用以下属性名称：

| 属性                                | 备注                                                        |
| ----------------------------------- | ----------------------------------------------------------- |
| `my.main-project.person.first-name` | 中划线方式，建议在 `.properties` 和 `.yml` 文件中使用       |
| `my.main-project.person.firstName`  | 标准驼峰式语法                                              |
| `my.main-project.person.first_name` | 下划线表示法，使用 `.properties` 和 `.yml` 文件时的可选格式 |
| `MY_MAINPROJECT_PERSON_FIRSTNAME`   | 大写格式，推荐在系统环境变量时使用                          |

> 注解的 `prefix` 值必须是中划线方式的（小写且使用 `-` 分隔，例如 `my.main-project.person`）

| 属性源          | 简单值                                         | List                                           |
| --------------- | ---------------------------------------------- | ---------------------------------------------- |
| Properties 文件 | 驼峰式，中划线式，或者下划线表示法             | 使用 `[]` 的标准 list 语法或逗号分隔的值       |
| YAML 文件       | 驼峰式，中划线式，或者下划线表示法             | 标准 YAML 队列语法或者逗号分隔的值             |
| 环境变量        | 使用下划线分隔的大写格式（参考环境变量的绑定） | 使用下划线包裹的数字型值（参考环境变量的绑定） |
| 系统属性        | 驼峰式，中划线式，或者下划线表示法             | 使用 `[]` 的标准 list 语法或逗号分隔的值       |

> 我们建议，在可能的情况下，属性使用小写中划线格式存储，例如 `my.person.first-name=Rod`

##### 绑定 Map

当绑定 `Map` 属性时你可能需要使用特定的括号表示法来保留原始的 `key` 值。如果键没有被 `[]` 包裹，则任何非字母的字符 `-` 或 `.` 会被移除。

例如，考虑绑定下面的属性到 `Map<String, String>`：

```properties
my.map.[/key1]=value1
my.map.[/key2]=value2
my.map./key3=value3
```

> 对于 YAML 文件，括号需要用引号括起来，以便正确解析键。

上面的属性将绑定一个具有 `/key1`，`/key2` 和 `key3` 的 `Map` 作为映射中的键。斜线已从 `key3` 中移除，因为它没有被方括号包围。

当绑定到标量值时，有 `.` 的键就不需要被 `[]` 包围了。标量值包括枚举和除了 `Object` 以外所有 `java.lang` 包的类型。绑定 `a.b=c` 到 `Map<String, String>` 将在键中保留 `.` 且返回一个具有 `{"a.b"="c"}` 条目的 Map。对于任何其他类型，如果你的 `key` 包括 `.`，你需要使用括号表达式。例如，绑定 `a.b=c` 到 `Map<String, Object>` 将返回一个具有 `{"a"={"b"="c"}}` 条目的 Map，而 `[a.b]=c` 将返回一个具有 `{"a.b"="c"}` 条目的 Map。

##### 绑定环境变量

大多数操作系统对可用于环境变量的名称施加严格的规则。例如 Linux shell 变量只能包含字母（`a` 到 `z` 或 `A` 到 `Z`），数字（`0` 到 `9`）或下划线字符（`_`）。通常，Unix shell 变量也将使用大写的名字。

Spring Boot 的宽松绑定规则尽可能地设计为和这些命名限制兼容。

要将规范形式的属性名称转换为环境变量名称，可以遵循以下规则：

- 使用下划线（`_`）替换点（`.`）
- 移除任何中划线（`-`）
- 转为大写

例如，配置属性 `spring.main.log-startup-info` 将转为一个名为 `SPRING_MAIN_LOGSTARTUPINFO` 的环境变量。

环境变量也可以在绑定到对象列表时使用。为了绑定到一个 `List`，元素编号应在变量名称中用下划线包围。

例如，配置属性 `my.service[0].other` 将使用名为 `MY_SERVICE_0_OTHER` 的环境变量。

#### 2.8.7 合并复杂类型

当队列在多于一处地方配置时，通过替换整个队列来覆写。

例如，假设一个有默认值为 `null` 的 `name` 和 `description` 属性的 `MyPojo` 对象。下面例子展示一个 `MyProperties` 中的 `MyPojo` 对象队列：

```java
@ConfigurationProperties("my")
public class MyProperties {
    private final List<MyPojo> list = new ArrayList<>();

    public List<MyPojo> getList() {
        return this.list;
    }
}
```

考虑下面配置：

```properties
my.list[0].name=my name
my.list[0].description=my description
#---
spring.config.activate.on-profile=dev
my.list[0].name=my another name
```

如果 `dev` profile 没有激活，`MyProperties.list` 包括一个 `MyPojo` 条目，就像前面定义的那样。如果 `dev` profile 被激活，然而，`list` 仍然仅包含一个条目（名字为 `my another name` 且描述为 `null`）。这个配置并不给队列添加第二个 `MyPojo` 实例，且它并不合并这些条目。

当在多个 profile 中指定 `List`，具有最高优先级的（且只有那个）会被使用。考虑如下例子：

```properties
my.list[0].name=my name
my.list[0].description=my description
my.list[1].name=another name
my.list[1].description=another description
#---
spring.config.activate.on-profile=dev
my.list[0].name=my another name
```

在前面的例子中，如果 `dev` profile 被激活，`MyProperties.list` 包含一个 `MyPojo` 条目（具有 `my another name`  的名字和一个 `null` 的描述）。对于 YAML，逗号分隔的队列和 YAML 队列可以用于完全覆写队列的内容。

对于 `Map` 属性，你可以绑定从多个源中获取的属性值。然而，对于多个源中同一个属性，高优先级的那个会被使用。下面例子展示了 `MyProperties` 中的 `Map<String, MyPojo>`：

```java
@ConfigurationProperties("my")
public class MyProperties {
    private final Map<String, MyPojo> map = new LinkedHashMap<>();

    public Map<String, MyPojo> getMap() {
        return this.map;
    }
}
```

考虑下面的配置：

```properties
my.map.key1.name=my name 1
my.map.key1.description=my description 1
#---
spring.config.activate.on-profile=dev
my.map.key1.name=dev name 1
my.map.key2.name=dev name 2
my.map.key2.description=dev description 2
```

如果 `dev` profile 没有激活，`MyProperties.map` 包含一个具有键 `key1` 的条目（名字为 `my name 1` 且描述为 `my description 1`）。如果 `dev` profile 被激活，则 `map` 包含两个条目，键 `key1`（名字为 `dev name 1` 且描述为 `my description 1`）和 `key2`（名字为 `dev name 2` 和描述为 `dev description 2`）。

> 前面合并的规则适用于所有属性源的属性，而不只是文件。

#### 2.8.8 属性转换

Spring Boot 在绑定到 `@ConfigurationProperties` bean 时，尝试强制转换外部应用属性到合适的类型。如果你需要自定义类型转换，你可以提供一个 `ConversionService` bean（具有一个名叫 `conversionService` 的 bean）或自定义属性编辑器（通过一个 `CustomEditorConfigurer` bean）或自定义 `Converters`（具有注解了 `@ConfigurationPropertiesBinding` 的 bean 定义）

> 当 bean 在应用生命周期的非常早期被请求时，请确保限制你 `ConversionService` 使用的依赖。通常，任何你需要的依赖可能在创建时并没有完全初始化。在它不需要配置键强转且只依赖于 `@ConfigurationPropertiesBinding` 限定的自定义转换器时，你可能需要重命名你的自定义 `ConversionService`。

##### 转换 Duration

Spring Boot 致力于支持表示持续时间。如果你使用了一个 `java.time.Duration` 属性，应用属性中的下面格式可用：

- 普通的 `long` 表示（在没有使用 `@DurationUnit` 指定时，默认使用毫秒单位）
- `java.time.Duration` 使用的标准 ISO-8601 格式
- 值和单位组合（`10s` 表示 10 秒）的更可读的格式

考虑如下例子：

```java
@ConfigurationProperties("my")
public class MyProperties {
    @DurationUnit(ChronoUnit.SECONDS)
    private Duration sessionTimeout = Duration.ofSeconds(30);

    private Duration readTimeout = Duration.ofMillis(1000);

    // getters / setters...
}
```

为了指定 30 秒的会话超时时间，`30`，`PT30S` 和 `30s` 都起到同样效果。读取超时时间可以通过下面格式：`500`，`PT0.5S` 和 `500ms` 来指定。

你也可以使用任意支持的单位，它们是：

- `ns` 纳秒
- `us` 微秒
- `ms` 毫秒
- `s` 秒
- `m` 分钟
- `h` 小时
- `d` 天

默认单位是毫秒，且可以使用 `@DurationUnit` 按上面的示例阐释的那样覆写。

如果你希望使用构造器绑定，相同属性可以被公开，像下面例子展示的：

```java
@ConfigurationProperties("my")
public class MyProperties {
    // fields...

    public MyProperties(@DurationUnit(ChronoUnit.SECONDS) @DefaultValue("30s") Duration sessionTimeout,
            @DefaultValue("1000ms") Duration readTimeout) {
        this.sessionTimeout = sessionTimeout;
        this.readTimeout = readTimeout;
    }

    // getters...
}
```

> 如果你正在升级一个 `Long` 属性，如果单位不是毫秒的话，请确保定义了单位（使用 `@DurationUnit`）。这样使你可以透明的升级而同时支持富格式。

##### 转换 Period

除了持续时间，Spring Boot 可以使用 `java.time.Period` 类型。下面格式可以在应用属性中使用：

- 一个普通的 `int` 表示法（除非使用 `@PeriodUnit` 指定，否则使用天作为默认单位）
- `java.time.Period` 使用的标准的 ISO-8601 格式
- 值和单位对组合的更简单的格式（`1y3d` 表示 1 年 3 天）

下面单位支持更简单的格式：

- `y` 年
- `m` 月
- `w` 周
- `d` 天

> `java.time.Period` 类型从不实际保存周数的数量，这是表示“7 天”的简便方式。

##### 转换 DataSize

Spring 框架具有一个 `DataSize` 值类型来表达字节单位的大小。如果你公开一个 `DataSize` 属性，下面应用属性中的格式可用：

- 普通 `long` 表达式（除非使用 `@DataSizeUnit` 指定，否则使用字节作为默认单位）
- 值和单位组合的更可读的格式（`10MB` 表示 10 兆字节）

考虑下面例子：

```java
@ConfigurationProperties("my")
public class MyProperties {
    @DataSizeUnit(DataUnit.MEGABYTES)
    private DataSize bufferSize = DataSize.ofMegabytes(2);

    private DataSize sizeThreshold = DataSize.ofBytes(512);

    // getters/setters...
}
```

为了指定一个 10 兆字节的缓存大小，`10` 和 `10MB` 等效。256 字节的大小阈值可以通过 `256` 或 `256B` 指定。

你也可以使用任何支持的单位。它们是：

- `B` 字节
- `KB` 千字节
- `MB` 兆字节
- `GB` 吉字节
- `TB` 太字节

默认单位是字节，且可以像上面示例中阐释的那样使用 `@DataSizeUnit` 覆写。

如果你更希望使用构造器绑定，相同的属性可以按下面的例子展示那样被公开：

```java
@ConfigurationProperties("my")
public class MyProperties {
    // fields...

    public MyProperties(@DataSizeUnit(DataUnit.MEGABYTES) @DefaultValue("2MB") DataSize bufferSize,
            @DefaultValue("512B") DataSize sizeThreshold) {
        this.bufferSize = bufferSize;
        this.sizeThreshold = sizeThreshold;
    }

    // getters...
}
```

> 如果你升级一个 `Long` 属性，如果单位不是字节的话，请确保定义了单位（使用 `@DataSizeUnit`）。这样使你可以透明的升级，同时支持富格式。

#### 2.8.9 @ConfigurationProperties 验证

Spring Boot 会尝试验证 `@ConfigurationProperties` 类，当它们被 Spring 的 `@Validated` 注解时。你可以直接在配置类上使用 JSR-303 `javax.validation` 约束注解。为了做到这点，确保兼容的 JSR-303 实现在你的 classpath 上，然后添加约束注解到你的字段上，像下面例子展示：

```java
@ConfigurationProperties("my.service")
@Validated
public class MyProperties {
    @NotNull
    private InetAddress remoteAddress;

    // getters/setters...
}
```

> 你也可以通过使用 `@Validated` 注解创建配置属性的 `@Bean` 方法触发验证。

为了确保验证在嵌套属性总是被触发，即使没有属性被发现时，相关联的字段必须使用 `@Valid` 注解。下面例子基于前面 `MyProperties` 例子构建：

```java
@ConfigurationProperties("my.service")
@Validated
public class MyProperties {
    @NotNull
    private InetAddress remoteAddress;

    @Valid
    private final Security security = new Security();

    // getters/setters...

    public static class Security {
        @NotEmpty
        private String username;

        // getters/setters...
    }
}
```

你也可以通过创建一个叫作 `configurationPropertiesValidator` 的 bean 定义添加一个自定义 Spring `Validator`。`@Bean` 方法应该被声明为 `static`。配置属性验证器在应用声明周期的很早就被创建，且声明 `@Bean` 方法作为静态方法使得 bean 可以无须初始化 `@Configuration` 就被创建。这样避免了可能因为过早初始化导致的问题。

> `spring-boot-actuator` 模块包括一个公开所有 `@ConfigurationProperties` bean 的端点。指定你的 web 浏览器到 `/actuator/configprops` 或使用等效的 JMX 端点。参考“生产就绪特性”一节以获取细节。

#### 2.8.10 @ConfigurationProperties vs @Value

`@Value` 注解是一个核心容器特性，且它不提供和类型安全的配置属性相同的特性。下面的表总结了 `@ConfigurationProperties` 和 `@Value` 支持的特性：

| 特性        | `@ConfigurationProperties` | `@Value`                 |
| ----------- | -------------------------- | ------------------------ |
| 宽松绑定    | 是                         | 受限的（参考下面的备注） |
| 支持元数据  | 是                         | 否                       |
| `SpEL` 求值 | 否                         | 是                       |

> 如果你希望使用 `@Value`，我们建议你使用规范形式引用属性名称（仅使用小写字母的中划线格式）。这将允许 Spring Boot 使用和 `@ConfigurationProperties` 宽松绑定相同的逻辑。
>
> 例如，`@Value("${demo.item-price}")` 将从 `application.properties` 文件中匹配 `demo.item-price` 和 `demo.itemPrice` 格式，还从系统环境中匹配 `DEMO_ITEMPRICE`。如果你使用 `@Value("${demo.itemPrice}")`，`demo.item-price` 和 `DEMO_ITEMPRICE` 将不被考虑。

如果你为你自己的组件定义了一组配置键，我们建议你使用 `@ConfigurationProperties` 注解的 POJO 将它们组合起来。这样将提供给你可以注入到你自己 bean 中的结构化的类型安全的对象。

应用属性文件中的 `SpEL` 表达式并不在解析这些文件和填充环境时处理。然而，可以在 `@Value` 中写一个 `SpEL` 表达式。如果一个应用属性文件中的属性值是 `SpEL` 表达式，它将在被 `@Value` 消费时求值。

## 3. Profile

Spring Profile 提供了一种隔离应用程序配置部分的方式，使其仅在特定环境可用。任何 `@Component`，`@Configuration` 或 `@ConfigurationProperties` 可以被 `@Profile` 标记来限制它何时被加载，就像下面例子展示那样：

```java
@Configuration(proxyBeanMethods = false)
@Profile("production")
public class ProductionConfiguration {
    // ...
}
```

> 如果 `@ConfigurationProperties` bean 通过 `@EnableConfigurationProperties` 注册而不是自动扫描，`@Profile` 注解需要在拥有 `@EnableConfigurationProperties` 注解的 `@Configuration` 类上指定。在 `@ConfigurationProperties` 被扫描的情况中，`@Profile` 可以在 `@ConfigurationProperties` 类上指定。

你可以使用 `spring.profiles.active` `Environment` 属性来指定激活哪个 profile。你可以通过这一章早些时候描述的方法来指定属性。例如，你可以在你的 `application.properties` 中包括它，就像下面例子中展示的那样：

```properties
spring.profiles.active=dev,hsqldb
```

你也可以通过下面开关：`--spring.profiles.active=dev.hsqldb` 在命令行中指定。

如果没有 profile 被激活，默认的 profile 将被启用。默认 profile 的名字是 `default` 且它可以使用 `spring.profiles.default` `Environment` 属性来修改，就像下面例子展示的：

```properties
spring.profiles.default=none
```

`spring.profiles.active` 和 `spring.profiles.default` 仅可以在非 profile 指定的文档中使用。这意味着它们不能被包含在 profile 特定文件或通过 `spring.config.activate.on-profile` 激活的文件中。

例如，第二个文档配置是无效的：

```properties
# this document is valid
spring.profiles.active=prod
#---
# this document is invalid
spring.config.activate.on-profile=prod
spring.profiles.active=metrics
```

### 3.1 添加激活的 Profile

`spring.profiles.active` 属性遵循和其他属性相同的排序规则：最高的 `PropertySource` 胜选。这意味着你可以指定在 `application.properties` 中激活的 profile 然后使用命令行开关来替换它们。

有时，有一个添加激活 profile 的属性比替换它们有用。`spring.profiles.include` 属性可以被用来在 `spring.profiles.active` 属性前添加激活 profile。`SpringApplication` 入口点也有设置额外 profile 的 Java API。参考 SpringApplication 中的 `setAdditionalProfiles()` 方法。

例如，当具有下面属性的应用运行时，common 和 local profile 将被激活，即使在使用 --spring.profiles.active 开关运行时：

```properties
spring.profiles.include[0]=common
spring.profiles.include[1]=local
```

> 和 `spring.profiles.active` 相似的，`spring.profiles.include` 只能在非 profile 指定的文档中使用。这意味着它不能包含在 profile 特定文件或 `spring.config.activate.on-profile` 激活的文档中。

下一节中描述的 Profile 组可以用来在给定 profile 激活时添加激活 profile。

### 3.2 Profile 组

有时，你在应用程序中定义和使用的配置文件过于细粒度，使用起来很麻烦。例如，你可以使用 `proddb` 和 `prodmq` profile 来分别独立启用数据库和消息传递特性。

为了帮助实现这一点，Spring Boot 允许你定义 profile 组。一个 profile 组允许你为一组相关的 profile 定义一个逻辑名称。

例如，我们可以创建一个包括我们 `proddb` 和 `prodmq` profile 的 `production` 组。

```properties
spring.profiles.group.production[0]=proddb
spring.profiles.group.production[1]=prodmq
```

我们的应用现在可以使用 `--spring.profiles.active=production` 来激活 `production`，一次启动 `proddb` 和 `prodmq` profile。

### 3.3 程序化设置 Profile

你可以通过在你的应用运行前调用 `SpringApplication.setAdditionalProfiles(...)` 程序化地设置激活的 profile。也可以使用 Spring 的 `ConfigurableEnvironment` 接口来激活 profile。

### 3.4 指定 Profile 的配置文件

`application.properties` （或 `application.yml`）和通过 `@ConfigurationProperties` 引入的文件的指定 Profile 的变体被视为文件而加载。有关细节请参考“指定 Profile 的文件”。

## 4. 日志

Spring Boot 对所有内部的日志使用 Commons Logging，但让底层日志实现开放。默认配置提供了 Java Util Logging，Log4j2，和 Logback。在每个情况下，日志将先配置为使用控制台输出，而可选的文件输出也是可用的。

默认情况下，如果你使用“Starter”的话，Logback 将被用于日志。合适的 Logback 路由将被包含，来保证使用 Java Util Logging，Commons Logging，Log4J，或 SLF4J 的依赖库运行正常。

> Java 有很多可用的日志框架。如果上述的列表看上去很迷惑，不要担心。通常来说，你不需要改变你的日志依赖，Spring Boot 默认就能工作得很好。

> 当你将你的应用部署到 servlet 容器或者应用服务器时，Java Util Logging API 执行的日志不会路由到你的应用日志。这防止了容器或其他已经部署的应用运行的日志出现在你的应用日志中。

### 4.1 日志格式

Spring Boot 中默认的日志输出和下面例子相似：

```
2022-11-24T17:02:47.423Z  INFO 18487 --- [           main] o.s.b.d.f.s.MyApplication                : Starting MyApplication using Java 17.0.5 with PID 18487 (/opt/apps/myapp.jar started by myuser in /opt/apps/)
2022-11-24T17:02:47.428Z  INFO 18487 --- [           main] o.s.b.d.f.s.MyApplication                : No active profile set, falling back to 1 default profile: "default"
2022-11-24T17:02:49.682Z  INFO 18487 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2022-11-24T17:02:49.709Z  INFO 18487 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2022-11-24T17:02:49.710Z  INFO 18487 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.1]
2022-11-24T17:02:49.877Z  INFO 18487 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2022-11-24T17:02:49.880Z  INFO 18487 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 2384 ms
2022-11-24T17:02:50.499Z  INFO 18487 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2022-11-24T17:02:50.524Z  INFO 18487 --- [           main] o.s.b.d.f.s.MyApplication                : Started MyApplication in 4.578 seconds (process running for 5.179)
```

下面项会被输出：

- 日期和时间：毫秒级别且可以轻松排序。
- 日志级别：`ERROR`，`WARN`，`INFO`，`DEBUG`，或 `TRACE`。
- 进程 ID。
- 一个 `---` 分隔符，用来区分真正日志信息的开始。
- 线程名称：包裹在方括号中（可能在控制台输出时被删减）。
- 日志名称：这通常是源类的名字（经常被简写）。
- 日志信息。

> Logback 并不具有 `FATAL` 级别，它将被映射到 `ERROR`。

### 4.2 控制台输出

默认日志配置在信息被写下时，将其回显到控制台。默认情况下，`ERROR`-级别，`WARN`-级别，以及 `INFO`-级别的信息被记入日志。你可以通过使用 `--debug` 标记启动你的应用来启用“debug”模式。

```shell
$ java -jar myapp.jar --debug
```

> 你也可以在你的 `application.properties` 中指定 `debug=true`

当 debug 模式被启用时，选定的核心日志（内嵌容器，Hibernate，和 Spring Boot）被配置为输出更多信息。启用 debug 模式不会将你的应用配置为记录全部 `DEBUG` 级别的日志。

可选的，你可以通过使用 `--trace` 标记（或在你的 `application.properties` 中配置 `trace=true`）来启动你的应用来启用“trace”模式。这样将启用选定的核心日志（内嵌容器，Hibernate schema 生成，以及整个 Spring portfolio） 的 trace 日志。

#### 4.2.1 有颜色的输出

如果你的终端支持 ANSI，颜色输出将被使用来提高可读性。你可以设置 `spring.output.ansi.enabled` 为一个支持的值来覆盖自动检测。

颜色代码使用 `%clr` 转换词来配置。在它最简单的形式，转换器根据日志级别给输出赋颜色，就像下面的例子展示的：

```
%clr(%5p)
```

下面表格描述了日志级别和颜色的映射：

| 级别    | 颜色 |
| ------- | ---- |
| `FATAL` | 红色 |
| `ERROR` | 红色 |
| `WARN`  | 黄色 |
| `INFO`  | 绿色 |
| `DEBUG` | 绿色 |
| `TRACE` | 绿色 |

或者，您可以通过将其作为转换选项来指定应使用的颜色或样式。例如，要使文本变为黄色，请使用以下设置：

```
%clr(%d{yyyy-MM-dd'T'HH:mm:ss.SSSXXX}){yellow}
```

支持下列颜色和样式：

- `blue`
- `cyan`
- `faint`
- `green`
- `magenta`
- `red`
- `yellow`

### 4.3 文件输出

默认情况，Spring Boot 日志仅输出到控制台且并不写日志文件。如果你希望在控制台输出外也写日志文件，你需要设置 `logging.file.name` 或 `logging.file.path` 属性（例如，在你的 `application.properties`）。

下面的表格展示 `logging.*` 属性怎么一起使用的：

| `logging.file.name` | `logging.file.path` | 例子       | 描述                                                         |
| ------------------- | ------------------- | ---------- | ------------------------------------------------------------ |
| （无）              | （无）              |            | 仅在控制台记录日志                                           |
| 特定文件            | （无）              | `my.log`   | 写到特定日志文件。名字可以是一个精确位置或是和当前目录的相对位置 |
| （无）              | 特定目录            | `/var/log` | 写 `spring.log` 到特定目录。名字可以是精确位置或和当前目录的相对位置 |

日志文件在大小达到 10 MB 时会轮替，和控制台输出一样，默认情况下 `ERROR`-级别，`WARN`-级别，和 `INFO`-级别信息会被记录日志。

> 日志属性和实际日志基础设施独立。作为结果，特定配置键（例如 Logback 的 `logback.configurationFile`）不会被 Spring Boot 管理。

### 4.4 文件轮替

如果你使用 Logback，可以使用 `application.properties` 或 `application.yaml` 文件微调日志循环设置。对于所有其他日志记录系统，你需要自己直接配置轮替设置（例如，如果使用 Log4j2，则可以添加 `log4j2.xml` 或 `log4j2-spring.xml` 文件）。

支持以下轮换策略属性：

| 名字                                                   | 描述                                   |
| ------------------------------------------------------ | -------------------------------------- |
| `logging.logback.rollingpolicy.file-name-pattern`      | 用于创建日志归档的文件名模式           |
| `logging.logback.rollingpolicy.clean-history-on-start` | 在应用程序启动时，是否需要清理日志归档 |
| `logging.logback.rollingpolicy.max-file-size`          | 日志文件在归档前的最大大小             |
| `logging.logback.rollingpolicy.total-size-cap`         | 归档日志在删除前可以保有的最大大小     |
| `logging.logback.rollingpolicy.max-history`            | 保留的归档日志文件最大数量（默认为 7） |

### 4.5 日志级别

所有支持的日志系统可以在 Spring `Environment` 中（例如，在 `application.properties` 中）使用 `logging.level.<logger-name>=<level>` 来设置日志级别，这里的 `level` 是 TRACE, DEBUG, INFO, WARN, ERROR, FATAL 或 OFF 中的一个。`root` 日志可以通过 `logging.level.root` 配置。

下面例子展示了在 `application.properties` 中可能的日志设置：

```properties
logging.level.root=warn
logging.level.org.springframework.web=debug
logging.level.org.hibernate=error
```

可能使用环境变量来设置日志级别。例如，`LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_WEB=DEBUG` 将设置 `org.springframework.web` 为 `DEBUG`。

> 上面的方法将仅在包级别日志生效。因为宽松绑定经常将环境变量转为小写，它不能以这种方式给一个独立的类配置日志。如果你需要给一个类配置日志，你可以使用 `SPRING_APPLICAION_JSON` 变量。

### 4.6 日志组

将相关的日志组在一起来让它们可以同时被配置，这经常会很有用。例如，你可能通常会更改所有 Tomcat 相关日志的日志级别，但你不容易记住顶级包。

为了帮助做到这点，Spring Boot 允许你在你的 Spring `Environment` 中定义日志组。例如，这是你如何通过增加到你的 `application.properties` 定义一个“tomcat”组：

```properties
logging.group.tomcat=org.apache.catalina,org.apache.coyote,org.apache.tomcat
```

一旦被定义，你可以在一行内改变所有组内日志的级别：

```properties
logging.level.tomcat=trace
```

Spring Boot 包含了下面预定义的日志组，可以开箱即用：

| 名字 | 日志                                                         |
| ---- | ------------------------------------------------------------ |
| web  | `org.springframework.core.codec`, `org.springframework.http`, `org.springframework.web`, `org.springframework.boot.actuate.endpoint.web`, `org.springframework.boot.web.servlet.ServletContextInitializerBeans` |
| sql  | `org.springframework.jdbc.core`, `org.hibernate.SQL`, `org.jooq.tools.LoggerListener` |

### 4.7 使用日志关闭钩子

为了在你的应用终止时释放日志资源，提供了一个在 JVM 退出时触发日志系统清理的关闭钩子。除非你的应用被部署为一个 war 文件，关闭钩子将自动被注册。如果你的应用拥有复杂的上下文层级结构，关闭钩子可能不能满足你的需要。如果它不能，则请停用关闭钩子且调查底层日志系统直接提供的选项。例如，Logback 将提供允许每个日志在其上下文中创建的上下文选择器。你可以使用 `logging.register-shutdown-hook` 属性来停用关闭钩子。将其设置为 `false` 将停用注册。你可以在你的 `application.properties` 或 `application.yaml` 文件中设置该属性：

```properties
logging.register-shutdown-hook=false
```

### 4.8 自定义日志配置

不同的日志系统可以通过在 classpath 中包含合适的库来激活，且可以通过在 classpath 根目录或 Spring `Environment` 属性 `logging.config` 指定的位置下提供合适的配置文件来进一步自定义。

你可以通过用 `org.springframework.boot.logging.LoggingSystem` 系统属性来强制 Spring Boot 使用特定的日志系统。该值应该是一个 `LoggingSystem` 实现的完全限定类名。你可以通过使用 `none` 值来完全停用 Spring Boot 的日志配置。

> 因为日志在 `ApplicationContext` 创建前初始化，不可能在 Spring`@Configuration` 文件中从 `@PropertySource` 控制日志。唯一的办法是改变日志系统或通过系统属性完全停用它

取决于你的日志系统，下面文件被加载：

| 日志系统                 | 自定义                                                       |
| ------------------------ | ------------------------------------------------------------ |
| Logback                  | `logback-spring.xml`, `logback-spring.groovy`, `logback.xml`, 或 `logback.groovy` |
| Log4j2                   | `log4j2-spring.xml` 或 `log4j2.xml`                          |
| JDK（Java Util Logging） | `logging.properties`                                         |

> 可能的话，我们建议你为你的日志配置使用 `-spring` 变体（例如，使用 `logback-spring.xml` 而不是 `logback.xml`）。如果你使用标准的配置位置，Spring 不能完全控制日志初始化。

> Java Util Logging 已知的类加载问题会导致从“可执行 jar”运行时出问题。在一切可能的情况下，我们建议你避免从一个“可执行 jar”运行。

为了帮助自定义，一些其他属性从 Spring `Environment` 中转移到系统属性，如下表中描述的那样：

| Spring Environment                  | 系统属性                        | 解释                                                         |
| ----------------------------------- | ------------------------------- | ------------------------------------------------------------ |
| `logging.exception-conversion-word` | `LOG_EXCEPTION_CONVERSION_WORD` | 日志记录异常时使用的转换词                                   |
| `logging.file.name`                 | `LOG_FILE`                      | 如果定义了，将在默认日志配置中使用                           |
| `logging.file.path`                 | `LOG_PATH`                      | 如果定义了，将在默认日志配置中使用                           |
| `logging.pattern.console`           | `CONSOLE_LOG_PATTERN`           | 控制台（stdout）上使用的日志模式                             |
| `logging.pattern.dateformat`        | `LOG_DATEFORMAT_PATTERN`        | 日志日期格式的拼接器模式                                     |
| `logging.charset.console`           | `CONSOLE_LOG_CHARSET`           | 控制台日志使用的字符集                                       |
| `logging.pattern.file`              | `FILE_LOG_PATTERN`              | 在文件中使用的日志模式（如果 `LOG_FILE` 启用了）             |
| `logging.charset.file`              | `FILE_LOG_CHARSET`              | 在文件中字符集（如果 `LOG_FILE` 启用了）                     |
| `logging.pattern.level`             | `LOG_LEVEL_PATTERN`             | 渲染日志级别时使用的格式（默认为 `%5p`）                     |
| `PID`                               | `PID`                           | 当前进程 ID （在可能时并且尚未定义为操作系统环境变量时被发现） |

如果你使用 Logback，下面属性也会被转移：

| Spring Environment                                     | 系统属性                                       | 解释                                                         |
| ------------------------------------------------------ | ---------------------------------------------- | ------------------------------------------------------------ |
| `logging.logback.rollingpolicy.file-name-pattern`      | `LOGBACK_ROLLINGPOLICY_FILE_NAME_PATTERN`      | 轮换日志文件名字模式（默认 `${LOG_FILE}.%d{yyyy-MM-dd}.%i.gz`） |
| `logging.logback.rollingpolicy.clean-history-on-start` | `LOGBACK_ROLLINGPOLICY_CLEAN_HISTORY_ON_START` | 是否需要在启动时清理归档日志文件                             |
| `logging.logback.rollingpolicy.max-file-size`          | `LOGBACK_ROLLINGPOLICY_MAX_FILE_SIZE`          | 日志文件大小最大值                                           |
| `logging.logback.rollingpolicy.total-size-cap`         | `LOGBACK_ROLLINGPOLICY_TOTAL_SIZE_CAP`         | 保留日志备份的总大小                                         |
| `logging.logback.rollingpolicy.max-history`            | `LOGBACK_ROLLINGPOLICY_MAX_HISTORY`            | 保留归档日志文件的最大数量                                   |

所有支持的日志系统在解析其配置文件时都可以查询系统属性。有关示例，请参见 `spring-boot.jar` 中的默认配置：

- Logback
- Log4j 2
- Java Util logging

> 如果你想在日志属性中使用一个占位符，你应该使用 Spring Boot 的语法而不是底层框架的语法。值得注意的是，如果你使用 Logback，你应该使用 `:` 作为属性名和它默认值之间的分隔符，而不是 `:-`。

> 你可以通过仅覆盖 `LOG_LEVEL_PATTERN`（或 Logback 中的 `logging.pattern.level`）添加 MDC 和其他点对点的内容到日志行中。例如，如果你使用 `logging.pattern.level=user:%X{user} %5p`，则默认日志格式包含一个给 “user” 的 MDC 条目，如果它存在的话，就如同下面例子展示那样：
>
> ```
> 2019-08-30 12:30:04.031 user:someone INFO 22174 --- [  nio-8080-exec-0] demo.Controller
> Handling authenticated request
> ```

### 4.9 Logback 扩展

Spring Boot 包括了一些可以帮助进行进阶配置的 Logback 扩展。你可以在你的 `logback-spring.xml` 配置文件中使用这些扩展。

> 因为标准 `logback.xml` 配置文件被太早加载，你在它里面使用扩展。你需要要么使用 `logback-spring.xml` 或定义一个 `logging.config` 属性。

> 扩展不能通过 Logback 的配置扫描被使用。如果你想要这样做，修改配置文件将导致一个类似于下面日志的错误：
>
> ```
> ERROR in ch.qos.logback.core.joran.spi.Interpreter@4:71 - no applicable action for [springProperty], current ElementPath is [[configuration][springProperty]]
> ERROR in ch.qos.logback.core.joran.spi.Interpreter@4:71 - no applicable action for [springProfile], current ElementPath is [[configuration][springProfile]]
> ```

#### 4.9.1 指定 Profile 的配置

`<springProfile>` 标签使你可以根据激活的 Spring profile 来包括或者不包括配置的部分。Profile 部分在 `<configuration>` 元素内部的任何位置都支持。使用 `name` 属性来指定哪个 profile 使用该配置。`<springProfile>` 标签可以包含一个 profile 名（例如 `staging`）或一个 profile 表达式。一个 profile 表达式允许表达更复杂的 profile 逻辑，例如 `production & (eu-central | eu-west)`。参阅 Spring 框架参考指南获取更多细节。下面列举了三个范例 profile：

```xml
<springProfile name="staging">
    <!-- configuration to be enabled when the "staging" profile is active -->
</springProfile>

<springProfile name="dev | staging">
    <!-- configuration to be enabled when the "dev" or "staging" profiles are active -->
</springProfile>

<springProfile name="!production">
    <!-- configuration to be enabled when the "production" profile is not active -->
</springProfile>
```

#### 4.9.2 环境属性

`<springProperty>` 标签允许你从 Spring `Environment` 中公开属性来在 Logback 中使用。在你希望在你的 Logback 配置中访问你 `application.properties` 中的值时，这样做很有用。这个标签和 Logback 的标准 `<property>` 标签以相似方式工作。然而，你需要指定（从 `Environment` 中的）属性的 `source`，而不是指定一个直接的 `value`。如果你需要在 `local` 作用域以外的任意地方存储属性，你可以使用 `scope` 属性。如果你需要一个回退值（防止属性在 `Environment` 中没被设置），你可以使用 `defaultValue` 属性。下面例子展示了怎么公开属性以在 Logback 使用：

```xml
<springProperty scope="context" name="fluentHost" source="myapp.fluentd.host" defaultValue="localhost"/>
<appender name="FLUENT" class="ch.qos.logback.more.appenders.DataFluentAppender">
    <remoteHost>${fluentHost}</remoteHost>
    ...
</appender>
```

> `source` 必须用中划线式指定（例如，`my.property-name`）。然而，属性可以使用宽松规则被加入到 `Environment` 中。

### 4.10 Log4j2 扩展

Spring Boot 包括一些 Log4j2 的扩展，可以帮助其进行进阶配置。你可以在任何 `log4j2-spring.xml` 配置文件中使用这些扩展。

> 因为标准 `log4j2.xml` 配置加载得非常早，你不能在其中使用扩展。你需要要么使用 `log4j2-spring.xml` 或定义一个 `logging.config` 属性。

> 这些扩展取代了 Log4J 提供的 Spring Boot 支持。你应该确保在你的构建中不要包含 `org.apache.logging.log4j:log4j-spring-boot` 模组。

#### 4.10.1 指定 Profile 配置

`<SpringProfile>` 标签让你基于激活的 Spring profile 可选包括或不包括配置的部分。Profile 部分在 `<Configuration>` 元素内部任意位置都支持。使用 `name` 属性来指定哪个 profile 使用该配置。`<SpringProfile>` 标签可以包含一个 profile 名字（例如 `staging`）或一个 profile 表达式。一个 profile 表达式允许表达更加复杂的 profile 逻辑，例如 `production & (eu-central | eu-west)`。参阅 Spring 框架参考指南获取更多细节。下面列举了三个范例 profile：

```xml
<SpringProfile name="staging">
    <!-- configuration to be enabled when the "staging" profile is active -->
</SpringProfile>

<SpringProfile name="dev | staging">
    <!-- configuration to be enabled when the "dev" or "staging" profiles are active -->
</SpringProfile>

<SpringProfile name="!production">
    <!-- configuration to be enabled when the "production" profile is not active -->
</SpringProfile>
```

#### 4.10.2 环境属性查找

如果你希望在你的 Log4j2 配置中引用你的 Spring `Environment` 中的属性，你可以使用 `spring:` 前缀查找。如果你希望在你的 Log4j2 配置中访问你 `application.properties` 文件中的值，这么做会很有帮助。

下面例子展示了怎么设置一个 Log4j2 的名叫 `applicationName` 的属性，它从 Spring `Environment` 中读取 `spring.application.name`：

```xml
<Properties>
    <Property name="applicationName">${spring:spring.application.name}</property>
</Properties>
```

> 查找键必须使用中划线式（例如 `my.property-name`）指定。

#### 4.10.3 Log4j2 系统属性

Log4j2 支持一些可用于配置多种项目的系统属性。例如，`log4j2.skipJansi` 系统属性可用于配置 `ConsoleAppender` 是否尝试在 Windowns 使用 Jansi 输出流。

所有在 Log4j2 初始化后加载的系统属性可以从 Spring `Environment` 中获取。例如，你可以添加 `log4j2.skipJansi=false` 到你的 `application.properties` 文件来让 `ConsoleAppender` 在 Windows 使用 Jansi。

> Spring `Environment` 仅仅在系统属性和操作系统环境变量都没有包含该值时被考虑。

> 在 Log4j2 早期初始化加载的系统属性不能引用 Spring `Environment`。例如，Log4j2 用来允许默认 Log4j2 实现被选择的属性就是在 Spring Environment 可用前被使用的。

## 5. 国际化

Spring Boot 支持本地化信息，这样你的应用可以迎合不同语言偏好的用户。默认情况下，Spring Boot 会在 classpath 的根位置查找 `message` 资源包的存在。

> 当配置资源包的默认配置文件（默认为 `messages.properties`）可用时，自动配置会应用。如果你的资源包仅包含特定语言的属性文件，你需要添加默认的。如果没有任何匹配配置基础名字的配置文件被找到，则将不会有自动配置的 `MessageSource`。

可是使用 `spring.messages` 命名空间配置资源包的基础名字和几个其他属性，如下例所示：

```properties
spring.messages.basename=messages,config.i18n.messages
spring.messages.fallback-to-system-locale=false
```

> `spring.message.basename` 支持逗号分隔的位置列表，可以是包限定符，也可以是从 classpath 根路径解析的资源。

参考 `MessageSourceProperties` 获取更多支持的选项。

## 6. JSON

Spring Boot 提供三个 JSON 映射库的整合：

- Gson
- Jackson
- JSON-B

Jackson 是首选和默认的库。

### 6.1 Jackson

Jackson 的自动配置是被提供的，且 Jackson 是 `spring-boot-starter-json` 的一部分。当 Jackson 在 classpath 时，一个 `ObjectMapper` bean 就被自动配置了。提供一些配置属性来自定义 `ObjectMapper` 配置。

#### 6.1.1 自定义序列化器和反序列化器

如果你使用 Jackson 来序列化和反序列化 JSON 数据，你可能想要写你自己的 `JsonSerializer` 和 `JsonDeserializer` 类。自定义序列化器经常和 Jackson 一起通过模组被注册，但 Spring Boot 提供了另一种 `@JsonComponent` 注解，可以帮助更方便地直接注册 Spring Bean。

你可以直接在 `JsonSerializer`，`JsonDeserializer` 或 `KeyDeserializer` 实现上使用 `@JsonComponent` 注解。你也可以在包含序列化器/反序列化器作为内部类的类上使用它，如下所示：

```java
@JsonComponent
public class MyJsonComponent {

    public static class Serializer extends JsonSerializer<MyObject> {

        @Override
        public void serialize(MyObject value, JsonGenerator jgen, SerializerProvider serializers) throws IOException {
            jgen.writeStartObject();
            jgen.writeStringField("name", value.getName());
            jgen.writeNumberField("age", value.getAge());
            jgen.writeEndObject();
        }

    }

    public static class Deserializer extends JsonDeserializer<MyObject> {

        @Override
        public MyObject deserialize(JsonParser jsonParser, DeserializationContext ctxt) throws IOException {
            ObjectCodec codec = jsonParser.getCodec();
            JsonNode tree = codec.readTree(jsonParser);
            String name = tree.get("name").textValue();
            int age = tree.get("age").intValue();
            return new MyObject(name, age);
        }

    }

}
```

所有在 `ApplicationContext` 中的 `@JsonComponent` bean 都会和 Jackson 一起被自动注册。因为 `@JsonComponent` 是用了 `@Component` 元注解，所以适用于常规的组件扫描规则。

Spring Boot 也提供了 `JsonObjectSerializer` 和 `JsonObjectDeserializer` 基本类，可以提供标准 Jackson 版本外的有用的序列化对象的其他选项。参考 javadoc 中的 `JsonObjectSerializer` 和 `JsonObjectDeserializer` 获取细节。

上面例子可以使用 `JsonObjectSerializer`/`JsonObjectDeserializer` 重写如下：

```java
@JsonComponent
public class MyJsonComponent {

    public static class Serializer extends JsonObjectSerializer<MyObject> {

        @Override
        protected void serializeObject(MyObject value, JsonGenerator jgen, SerializerProvider provider)
                throws IOException {
            jgen.writeStringField("name", value.getName());
            jgen.writeNumberField("age", value.getAge());
        }

    }

    public static class Deserializer extends JsonObjectDeserializer<MyObject> {

        @Override
        protected MyObject deserializeObject(JsonParser jsonParser, DeserializationContext context, ObjectCodec codec,
                JsonNode tree) throws IOException {
            String name = nullSafeValue(tree.get("name"), String.class);
            int age = nullSafeValue(tree.get("age"), Integer.class);
            return new MyObject(name, age);
        }

    }

}
```

#### 6.1.2 混入

Jackson 支持可以用于将附加注解混合到目标类上已经声明的注解中的混入。Spring Boot 的 Jackson 自动配置将扫描应用程序的包，查找用 `@JsonMixin` 注解的类，并将它们注册到自动配置的 `ObjectMapper` 中。注册由 Spring Boot 的 `JsonMixinModule` 执行。

### 6.2 Gson

Gson 自动配置被提供。当 Gson 在 classpath 下时，`Gson` bean 将自动配置。几个用于自定义配置的 `spring.gson.*` 配置属性被提供。为了获得更多控制，一个或更多 `GsonBuilderCustomizer` bean 可以被使用。

### 6.3 JSON-B

提供了 JSON-B 的自动配置。当 JSON-B API 和实现位于 classpath 上时，将自动配置 `Jsonb` bean。首选的 JSON-B 实现是 Eclipse Yasson，它提供了依赖管理。

## 7. 任务执行和调度

在上下文中没有 `Executor` bean 的情况下，Spring Boot 会自动配置 `ThreadPoolTaskExecutor`，并使用可自动关联到异步任务执行（`@EnableAsync`）和 Spring MVC 异步请求处理的合理默认值。

> 如果你在上下文定义一个自定义的 `Executor`，常规任务执行（即 `@EnableAsync`）将透明地使用它，但 Spring MVC 支持将不会被配置，因为它需要一个 `AsyncTaskExecutor` 实现（命名为 `applicationTaskExecutor`）。取决于你的目标安排，你可以改变你的 `Executor` 为 `ThreadPoolTaskExecutor` 或定义一个 `ThreadPoolTaskExecutor` 和一个包裹你的自定义 `Executor` 的 `AsyncConfigurer` 。
>
> 自动配置的 `TaskExecutorBuilder` 允许你简单地创建复制默认自动配置的实例。

线程池使用可以根据负载增加和减少的 8 个核心线程。默认设置可以使用 `spring.task.execution` 命名空间进行微调，如下例所示：

```properties
spring.task.execution.pool.max-size=16
spring.task.execution.pool.queue-capacity=100
spring.task.execution.pool.keep-alive=10s
```

这将线程池改变为使用一个有界队列，这样当队列满时（100 个任务），线程池增加到最大 16 个线程。池的缩小变得更为激进，因为线程在闲置 10 秒钟后就会被回收（而不是默认的 60 秒）。

当一个 `ThreadPoolTaskScheduler` 需要被关联到定时任务执行（例如使用 `@EnableScheduling`）时，它也可以被自动配置。该线程池默认使用一个线程，且它的设置可以使用 `spring.task.scheduling` 命名空间来微调，如下例所示：

```properties
spring.task.scheduling.thread-name-prefix=scheduling-
spring.task.scheduling.pool.size=2
```

在需要创建一个自定义执行器或调度器时，可以在上下文中使用 `TaskExecutorBuilder` bean 和 `TaskSchedulerBuilder` bean。

## 8. 测试

Spring Boot 提供了许多工具类和注解，以帮助测试应用程序。测试支持由两个模块提供：`spring-boot-test` 包含核心内容，和 `spring-boot-test-autoconfigure` 支持测试自动配置。

大多数开发者使用 `spring-boot-starter-test` Starter，它将导入 Spring Boot 测试模组和 JUnit Jupiter，AssertJ，Hamcrest 和一些其他有用的库。

> 如果你有使用 JUnit 4 的测试，可以使用 JUnit 5 的 vintage 引擎来运行它们。要使用 vintage 引擎，需要增加一个 `junit-vintage-engine` 的依赖，如下例所示：
>
> ```xml
> <dependency>
>     <groupId>org.junit.vintage</groupId>
>     <artifactId>junit-vintage-engine</artifactId>
>     <scope>test</scope>
>     <exclusions>
>         <exclusion>
>             <groupId>org.hamcrest</groupId>
>             <artifactId>hamcrest-core</artifactId>
>         </exclusion>
>     </exclusions>
> </dependency>
> ```

`hamcrest-core` 被排除了，因为 `org.hamcrest:hamcrest` 是 `spring-boot-starter-test` 的一部分。

### 8.1 测试作用域依赖项

`spring-boot-starter-test` Starter（在 `test` 作用域下）包含下面提供的库：

- JUnit 5：Java 应用的单元测试的事实标准。
- Spring Test 和 Spring Boot Test：工具类和 Spring Boot 应用的集成测试支持。
- AssertJ：一个流式断言库。
- Hamcrest：一个匹配器对象（也称为约束或谓词）库。
- Mockito：一个 Java 模拟框架。
- JSONassert：一个 JSON 的断言库。
- JsonPath：JSON 的 XPath。

我们通常认为这些公用库对于写测试非常有用。如果这些库不符合你的需要，你可以添加自己额外的测试依赖。

### 8.2 测试 Spring 应用

依赖注入的一个主要优点就是它可以使你的代码更容易单元测试。你可以在不涉及 Spring 的情况下使用 `new` 操作符实例化对象。你也可以使用 *mock* 对象而不是真正的依赖。

经常地，你需要超越单元测试并开始集成测试（使用 Spring `ApplicationContext`）。能够在不需要部署应用程序或连接到其他基础设施的情况下执行集成测试是非常有用的。

Spring 框架包含了一个用于此类集成测试的专用测试模块。您可以直接向 `org.springframework:spring-test` 声明一个依赖项，或者使用 `spring-boot-starter-test` “Starter” 以传递的方式将其引入。

如果你之前还没有使用过 `spring-test` 模块，你应该通过阅读 Spring 框架参考文档的相关章节来开始。

### 8.3 测试 Spring Boot 应用

一个 Spring Boot 应用是一个 Spring `ApplicationContext`，所以测试不需要做任何超过你通常对普通 Spring 上下文的操作的特别操作。

> 只要你使用 `SpringApplication` 来创建，外部属性，日志，和其他 Spring Boot 的特性默认被安装在上下文中。

Spring Boot 提供了 `@SpringBootTest` 注解，可以在你需要 Spring Boot 特性时用来替代标准 `spring-test` `@ContextConfiguration` 注解。这个注解通过 `SpringApplication` 创建你测试中需要的 `ApplicationContext`。`@SpringBootTest` 外，还提供了一些其他用于测试应用更具体切面的注解。

> 如果你正在使用 JUnit 4，不要忘记给你的测试添加 `@RunWith(SpringRunner.class)`，否则注解将被忽视。如果你正在使用 JUnit 5，就不需要添加等效的 `@ExtendWith(SpringExtension.class)`，因为 `@SpringBootTest` 和其他 `@...Test` 注解已经注解了它。

默认情况下，`@SpringBootTest` 将不会启动一个服务器。你可以使用 `@SpringBootTest` 的 `webEnvironment` 属性来进一步改善你测试的运行：

- `MOCK`（默认）：加载一个 web `ApplicationContext` 和提供一个 mock web 环境。使用该注解时，嵌入服务器将不会启动。如果一个 web 环境在你的 classpath 下不可用，这个模式会透明地降级为创建一个常规非 web `ApplicationContext`。它可以和 `@AutoConfigureMockMvc` 或 `@AutoConfigureWebTestClient` 结合使用，用于对 web 应用进行基于 mock 的测试
- `RANDOM_PORT`：加载一个 `WebServerApplicationContext` 且提供一个真正的 web 环境。嵌入服务器将被启动且监听一个随机接口。
- `DEFINED_PORT`：加载一个 `WebServerApplicationContext` 且提供一个真正 web 环境。嵌入服务器被启动且监听一个指定的端口（从你的 `application.properties` 中指定）或默认端口 `8080`。
- `NONE`：通过使用 `SpringApplication` 加载一个 `ApplicationContext`，但不提供任何 web 环境（mock 或其他）。

> 如果你的测试是 `@Transactional` 注解的，它将在每个测试方法执行结束时默认回滚事务。然而，由于将这种安排与 `RANDOM_PORT` 或 `DEFINED_PORT` 一起使用会隐式地提供一个真正的 servlet 环境，HTTP 客户端和服务器在单独的线程中运行，因此在单独的事务中运行。在这种情况下，在服务器上启动的任何事务都不会回滚。

> 如果应用程序为管理服务器使用不同的端口，具有 `webEnvironment = WebEnvironment.RANDOM_PORT` 的 `@SpringBootTest` 将在一个独立的随机端口启动管理服务器。

#### 8.3.1 检测 Web 应用类型

如果 Spring MVC 可用，一个常规基于 MVC 的应用上下文被配置。如果你只有 Spring WebFlux，我们将检测到这一点，且配置一个基于 WebFlux 的应用上下文作为替代。

如果两者都出现，Spring MVC 优先。如果你想在这种情况下测试一个响应式 web 应用，你必须设置 `spring.main.web-application-type` 属性：

```java
@SpringBootTest(properties = "spring.main.web-application-type=reactive")
class MyWebFluxTests {
    // ...
}
```

#### 8.3.2 检测测试配置

如果你熟悉 Spring Test 框架，你可能习惯使用 `@ContextConfiguration(class=...)` 来指定加载的 Spring `@Configuration`。或者，你可能经常在测试中使用嵌套的 `@Configuration` 类。

当测试 Spring Boot 应用的时候，这往往不是必须的。Spring Boot 的 `@*Test` 注解将在你没有特意指定一个时自动搜索你的主配置。

搜索的算法从包含测试的包开始，直到它找到一个注解了 `@SpringBootApplication` 或 `@SpringBootConfiguration` 的类。只要你用合理方式组织你的代码，你的主配置一般都可以被找到。

> 如果你使用测试注解来测试你应用的一个更特定的切片，你应该避免添加特定于主方法应用程序类上特定区域的配置设置。
>
> `@SpringBootApplication` 的底层组件扫描配置定义了用于确保切片按预期工作的排除过滤器。如果在你的 `@SpringBootApplication` 注解的类上使用显式 `@ComponentScan` 指令，请注意这些过滤器将被禁用。如果使用切片，则应再次定义它们。

如果你想要自定义主配置，你可以使用嵌套的 `@TestConfiguration` 类。不像会替代你应用主配置使用的嵌套的 `@Configuration` 类，一个嵌套的 `@TestConfiguration` 类是在你应用主配置之外使用的。

> Spring 测试框架会在测试之间缓存应用上下文。因此，只要你的测试分享相同配置（无论它怎么被发现的），潜在的加载上下文的耗时进程将只发生一次。

#### 8.3.3 使用测试配置主方法



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