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