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