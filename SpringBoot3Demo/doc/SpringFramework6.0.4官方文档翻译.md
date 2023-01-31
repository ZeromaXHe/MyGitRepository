# Spring Framework 概览

Spring 使创建 Java 企业应用程序变得容易。它提供了在企业环境中使用 Java 语言所需的一切，支持 Groovy 和 Kotlin 作为 JVM 上的替代语言，并具有根据应用程序需求创建多种体系结构的灵活性。从 Spring Framework 6.0 开始，Spring 需要 Java 17+。

Spring 支持广泛的应用场景。在大型企业中，应用程序通常存在很长时间，并且必须在 JDK 和应用程序服务器上运行，其升级周期超出开发人员的控制。其他人可能会作为一个内置服务器的 jar 运行，可能是在云环境中。还有一些可能是不需要服务器的独立应用程序（例如批处理或集成工作负载）。

Spring 是开源的。它有一个庞大而活跃的社区，可以根据各种各样的真实世界用例提供持续的反馈。这帮助 Spring 在很长一段时间内成功发展。

# 1 我们说 “Spring” 时指的是什么

“Spring” 一词在不同的语境中意味着不同的事物。它可以用来代指 Spring Framework 项目本身，这是它的起点。随着时间的推移，其他 Spring 项目已经建立在 Spring Framework 之上。大多数时候，当人们说“Spring”时，他们指的是整个项目家族。本参考文档着重于基础：Spring Framework 本身。

Spring Framework 分为多个模块。应用程序可以选择所需的模块。核心是核心容器的模块，包括配置模型和依赖注入机制。除此之外，Spring 框架为不同的应用程序架构提供了基础支持，包括消息传递、事务数据和持久性以及 web。它还包括基于 Servlet 的 Spring MVC web 框架，同时还包括 Spring WebFlux 反应式 web 框架。

关于模块的注意事项：Spring 的框架 jar 允许部署到 JDK 9 的模块路径（“Jigsaw”）。为了在支持 Jigsaw 的应用程序中使用，Spring Framework 5 jar 附带了“自动模块名称”（Automatic-Module-Name）清单条目，这些条目定义了独立于 jar 工件名称的稳定语言级别模块名称（“Spring.core”、“Spring.context” 等）（jar 遵循相同的命名模式，使用“-”而不是“.”，例如 “spring-core” 和 “spring-context”）。当然，Spring 的框架 jar 在 JDK 8 和 9+ 上的类路径上都能正常工作。

# 2 Spring 的历史和 Spring Framework

Spring 于 2003 年诞生，是对早期 J2EE 规范复杂性的回应。虽然有些人认为 Java EE 及其现代继任者 Jakarta EE 与 Spring 竞争，但事实上它们是互补的。Spring 编程模型不包含 Jakarta EE 平台规范；相反，它集成了从传统 EE 伞中精心选择的单个规范：

- Servlet API（JSR 340）
- WebSocket API（JSR 356）
- 并发实用程序（JSR 236）
- JSON 绑定 API（JSR 367）
- Bean 验证（JSR 303）
- JPA（JSR 338）
- JMS（JSR 914）
- 以及用于事务协调的 JTA/JCA 设置，如果必须的话。

Spring Framework 还支持依赖注入（JSR 330）和通用注解（JSR 250）规范，应用程序开发人员可以选择使用这些规范来代替 Spring Framework 提供的 Spring 特定机制。最初，它们基于常见的 `javax` 包。

从 Spring Framework 6.0 开始，Spring 已经升级到 Jakarta EE 9 级别（例如 Servlet 5.0+、JPA 3.0+），基于 `jakarta` 命名空间而不是传统的 `javax` 包。由于 EE 9 是最低的，EE 10 已经得到支持，Spring 准备为 Jarkata EE API 的进一步发展提供开箱即用的支持。Spring Framework 6.0 与 Tomcat 10.1、Jetty 11 和 Undertow 2.3 作为 web 服务器完全兼容，也与 Hibernate ORM 6.1 完全兼容。

随着时间的推移，Java/Jartarta EE 在应用程序开发中的作用不断演变。在 J2EE 和 Spring 的早期，创建应用程序以部署到应用程序服务器。今天，在 Spring Boot 的帮助下，应用程序以 devops 和云友好的方式创建，并嵌入了 Servlet 容器，更改很简单。从 Spring Framework 5 开始，WebFlux 应用程序甚至不直接使用 Servlet API，可以在非 Servlet 容器的服务器（如 Netty）上运行。

Spring 继续创新和发展。除了 Spring Framework，还有其他项目，如 Spring Boot、Spring Security、Spring Data、Spring Cloud、Spring Batch 等。重要的是要记住，每个项目都有自己的源代码库、问题跟踪程序和发布节奏。有关 Spring 项目的完整列表，请参见 spring.io/projects。

# 3 设计哲学

当你学习一个框架时，重要的是不仅要知道它做什么，还要知道它遵循什么原则。以下是 Spring 框架的指导原则：

- 在每个级别提供选择。Spring 允许您尽可能推迟设计决策。例如，您可以通过配置切换持久性提供程序，而无需更改代码。许多其他基础设施问题以及与第三方 API 的集成也是如此。
- 适应不同的观点。Spring 具有灵活性，对事情应该如何做并不固执己见。它支持具有不同视角的广泛应用需求。
- 保持强大的向后兼容性。Spring 的进化经过精心管理，在不同版本之间几乎没有突破性的变化。Spring 支持精心选择的一系列 JDK 版本和第三方库，以便于维护依赖于 Spring 的应用程序和库。
- 关注 API 设计。Spring 团队花了大量的心思和时间来制作直观的 API，这些 API在许多版本和许多年中都是有效的。
- 为代码质量设置高标准。Spring 框架非常强调有意义、当前和准确的 javadoc。它是少数几个可以声称在包之间没有循环依赖关系的干净代码结构的项目之一。

# 4 反馈和贡献

对于如何解决问题或诊断或调试问题，我们建议使用 Stack Overflow。单击此处查看要在 Stack Overflow 中使用的建议标记列表。如果您非常确定 Spring Framework 中存在问题，或者想建议一个功能，请使用 GitHub Issues。

如果您有一个解决方案或建议的修复方案，您可以在 Github 上提交拉取请求。但是，请记住，对于除了最琐碎的问题之外的所有问题，我们希望在问题跟踪中提交一个单据，在那里进行讨论，并留下记录以供将来参考。

有关更多详细信息，请参阅顶级项目页面上的贡献指南。

# 5 入门

如果您刚刚开始使用 Spring，您可能希望通过创建一个基于 Spring Boot 的应用程序来开始使用 Spring 框架。Spring Boot 提供了一种快速（且有主见）的方法来创建一个基于 Spring 的生产应用程序。它基于 Spring 框架，支持约定而不是配置，旨在让您尽快启动和运行。

您可以使用 start.spring.io 来生成一个基本项目，或者遵循“入门”指南之一，例如“开始构建 RESTful Web 服务”。这些指南不仅易于理解，而且非常专注于任务，而且大多数都基于 Spring Boot。它们还涵盖了 Spring 系列产品中您在解决特定问题时可能需要考虑的其他项目。

# 核心技术

参考文档的这一部分涵盖了 Spring 框架绝对不可或缺的所有技术。

其中最重要的是 Spring 框架的控制反转（IoC）容器。在对 Spring 框架的 IoC 容器进行彻底介绍之后，将对 Spring 的面向方面编程（AOP）技术进行全面覆盖。Spring 框架有自己的 AOP 框架，它在概念上很容易理解，并且成功地解决了 Java 企业编程中 AOP 需求的 80%。

Spring 与 AspectJ（目前最富有的 — 在功能方面 — 当然也是 Java 企业空间中最成熟的 AOP 实现）。

AOT 处理可用于提前优化应用程序。它通常用于使用 GraalVM 的本地映像部署。

# 1 IoC 容器

本章介绍 Spring 的控制反转（IoC）容器。

## 1.1 Spring IoC 容器和 Beans 简介

本章介绍控制反转（IoC）原理的 Spring 框架实现。IoC 也称为依赖注入（DI）。这是一个过程，在此过程中，对象仅通过构造函数参数、工厂方法的参数或财产来定义其依赖项（即，与它们一起工作的其他对象），这些参数在构造或从工厂方法返回对象实例后设置在对象实例上。然后，容器在创建 bean 时注入这些依赖项。这个过程基本上是 bean 本身的逆过程（因此称为控制反转），它通过使用类的直接构造或诸如服务定位器模式之类的机制来控制其依赖项的实例化或位置。

`org.springframework.bean` 和 `org.springfframework.context` 包是 Spring Framework IoC 容器的基础。`BeanFactory` 接口提供了一种高级配置机制，能够管理任何类型的对象。`ApplicationContext` 是 `BeanFactory` 的子接口。它补充道：

- 更容易与 Spring 的 AOP 特性集成
- 消息资源处理（用于国际化）
- 事件发布
- 应用程序层特定的上下文，如 web 应用程序中使用的 `WebApplicationContext`。

简而言之，`BeanFactory` 提供了配置框架和基本功能，`ApplicationContext` 添加了更多企业特定的功能。`ApplicationContext` 是 `BeanFactory` 的一个完整超集，在本章中专门用于描述 Spring 的 IoC 容器。有关使用 `BeanFactory` 而不是 `ApplicationContext` 的更多信息，请参阅涉及 `BeanFactory` API的部分。

在 Spring 中，构成应用程序主干并由 Spring IoC 容器管理的对象称为 bean。bean 是由 Spring IoC 容器实例化、组装和管理的对象。否则，bean 只是应用程序中许多对象中的一个。bean 以及它们之间的依赖关系反映在容器使用的配置元数据中。

## 1.2 容器概览

`org.springframework.context.ApplicationContext` 接口表示 Spring IoC 容器，负责实例化、配置和组装 bean。容器通过读取配置元数据获取关于实例化、配置和组装哪些对象的指令。配置元数据以 XML、Java 注解或 Java 代码表示。它允许您表达组成应用程序的对象以及这些对象之间丰富的相互依赖关系。

`ApplicationContext` 接口的几个实现随 Spring 一起提供。在独立应用程序中，通常创建 `ClassPathXmlApplicationContext` 或 `FileSystemXmlApplicationContext` 的实例。虽然 XML 一直是定义配置元数据的传统格式，但您可以通过提供少量 XML 配置以声明方式启用对这些附加元数据格式的支持，指示容器使用 Java 注解或代码作为元数据格式。

在大多数应用程序场景中，不需要显式用户代码来实例化 Spring IoC 容器的一个或多个实例。例如，在 web 应用程序场景中，应用程序的 `web.xml` 文件中的简单八行（大约八行）样板 web 描述符 XML 通常就足够了（请参阅"方便的 web 应用程序上下文实例化"）。如果您使用 Spring Tools for Eclipse（一个 Eclipse 驱动的开发环境），只需单击几下鼠标或击键即可轻松创建此样板配置。

下图显示了 Spring 如何工作的高级视图。应用程序类与配置元数据相结合，这样，在创建和初始化 `ApplicationContext` 之后，您就拥有了一个完全配置且可执行的系统或应用程序。

### 1.2.1 配置元数据

如上图所示，Spring IoC 容器使用一种形式的配置元数据。此配置元数据表示作为应用程序开发人员，您如何告诉 Spring 容器实例化、配置和组装应用程序中的对象。

配置元数据通常以简单直观的 XML 格式提供，这是本章的大部分内容用来传达 Spring IoC 容器的关键概念和特性的内容。

> 基于 XML 的元数据不是唯一允许的配置元数据形式。Spring IoC 容器本身与实际编写配置元数据的格式完全分离。如今，许多开发人员为其 Spring 应用程序选择基于 Java 的配置。

有关在 Spring 容器中使用其他形式的元数据的信息，请参阅：

- 基于注解的配置：使用基于注解的元数据定义 bean。
- 基于 Java 的配置：通过使用 Java 而不是 XML 文件来定义应用程序类外部的bean。要使用这些功能，请参阅 `@Configuration`、`@Bean`、`@Import` 和 `@DependsOn` 注解。

Spring 配置由容器必须管理的至少一个（通常不止一个）bean 定义组成。基于 XML 的配置元数据将这些 bean 配置为顶级 `<beans/>` 元素中的 `<bean/>` 元素。Java 配置通常在 `@Configuration` 类中使用 `@Bean` 注解方法。

这些 bean 定义对应于组成应用程序的实际对象。通常，您定义服务层对象、持久层对象（如存储库或数据访问对象（DAO））、表示对象（如 Web 控制器）、基础结构对象（如 JPA `EntityManagerFactory`）、JMS 队列等。通常，不会在容器中配置细粒度域对象，因为通常由存储库和业务逻辑负责创建和加载域对象。

以下示例显示了基于 XML 的配置元数据的基本结构：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="..." class="..."> (1) (2)
        <!-- collaborators and configuration for this bean go here -->
    </bean>

    <bean id="..." class="...">
        <!-- collaborators and configuration for this bean go here -->
    </bean>

    <!-- more bean definitions go here -->

</beans>

<!-- (1) id 属性是标识单个 bean 定义的字符串。 -->
<!-- (2) class 属性定义 bean 的类型并使用完全限定的类名。 -->
```

`id` 属性的值可用于引用协作对象。此示例中未显示用于引用协作对象的 XML。有关详细信息，请参见“依赖”。

### 1.2.2 初始化容器

提供给 `ApplicationContext` 构造函数的位置路径是资源字符串，允许容器从各种外部资源（如本地文件系统、Java `CLASSPATH`等）加载配置元数据。

```java
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");
```

> 在了解了 Spring 的 IoC 容器之后，您可能想了解更多关于 Spring 的 `Resource` 抽象（如参考资料中所述），它提供了一种方便的机制，用于从 URI 语法中定义的位置读取 InputStream。特别是，`Resource` 路径用于构建应用程序上下文，如应用程序上下文和资源路径中所述。

以下示例显示了服务层对象（`services.xml`）配置文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- services -->

    <bean id="petStore" class="org.springframework.samples.jpetstore.services.PetStoreServiceImpl">
        <property name="accountDao" ref="accountDao"/>
        <property name="itemDao" ref="itemDao"/>
        <!-- additional collaborators and configuration for this bean go here -->
    </bean>

    <!-- more bean definitions for services go here -->

</beans>
```

以下示例显示了数据访问对象 `daos.xml` 文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="accountDao"
        class="org.springframework.samples.jpetstore.dao.jpa.JpaAccountDao">
        <!-- additional collaborators and configuration for this bean go here -->
    </bean>

    <bean id="itemDao" class="org.springframework.samples.jpetstore.dao.jpa.JpaItemDao">
        <!-- additional collaborators and configuration for this bean go here -->
    </bean>

    <!-- more bean definitions for data access objects go here -->

</beans>
```

在前面的示例中，服务层由 `PetStoreServiceImpl` 类和 `JpaAccountDao` 和 `JpaItemDao` 类型的两个数据访问对象组成（基于 JPA 对象关系映射标准）。`property name` 元素引用 JavaBean 属性的名称，`ref` 元素引用另一个 bean 定义的名称。`id` 和 `ref` 元素之间的这种联系表达了协作对象之间的依赖关系。有关配置对象依赖项的详细信息，请参阅依赖项。

#### 合成基于 XML 的配置元数据

让 bean 定义跨越多个 XML 文件可能很有用。通常，每个单独的 XML 配置文件都表示体系结构中的逻辑层或模块。

您可以使用应用程序上下文构造函数从所有这些 XML 片段加载 bean 定义。此构造函数接受多个 `Resource` 位置，如前一节所示。或者，使用一个或多个 `<import/>` 元素从另一个文件加载 bean 定义。以下示例显示了如何执行此操作：

```xml
<beans>
    <import resource="services.xml"/>
    <import resource="resources/messageSource.xml"/>
    <import resource="/resources/themeSource.xml"/>

    <bean id="bean1" class="..."/>
    <bean id="bean2" class="..."/>
</beans>
```

在前面的示例中，外部 bean 定义是从三个文件加载的：`services.xml`、`messageSource.xml` 和 `themeSource.xml`。所有位置路径都与执行导入的定义文件相关，因此 `services.xml` 必须位于执行导入的文件所在的同一目录或类路径位置，而 `messageSource.xml` 和 `themeSource.xml` 必须位于导入文件位置下方的 `resources` 位置。如您所见，前导斜杠被忽略。然而，鉴于这些路径是相对的，最好不要使用斜线。根据 Spring Schema，要导入的文件的内容（包括顶级 `<beans/>` 元素）必须是有效的 XML bean 定义。

> 可以（但不建议）使用相对 “../” 路径引用父目录中的文件。这样做会创建对当前应用程序之外的文件的依赖关系。特别是，对于 `classpath:` URL（例如 `classpath：../services.xml`），不建议使用此引用，因为运行时解析过程选择“最近”的类路径根，然后查看其父目录。类路径配置更改可能会导致选择不同的、不正确的目录。
>
> 您可以始终使用完全限定的资源位置，而不是相对路径：例如，`file:C:/config/services.xml` 或 `classpath：/config/services.xml`。但是，请注意，您正在将应用程序的配置耦合到特定的绝对位置。一般来说，最好对这样的绝对位置保持间接——例如，通过“${…}“在运行时根据JVM系统属性解析的占位符。

命名空间本身提供导入指令功能。Spring 提供的一系列 XML 名称空间提供了除普通 bean 定义之外的其他配置特性——例如 `context` 和 `util` 命名空间。

#### Groovy Bean 定义 DSL

作为外部化配置元数据的另一个示例，bean 定义也可以用 Spring 的 GroovyBeanDefinitionDSL 表示，正如 Grails 框架所知。通常，此类配置位于“.groovy”文件中，其结构如以下示例所示：

```groovy
beans {
    dataSource(BasicDataSource) {
        driverClassName = "org.hsqldb.jdbcDriver"
        url = "jdbc:hsqldb:mem:grailsDB"
        username = "sa"
        password = ""
        settings = [mynew:"setting"]
    }
    sessionFactory(SessionFactory) {
        dataSource = dataSource
    }
    myService(MyService) {
        nestedBean = { AnotherBean bean ->
            dataSource = dataSource
        }
    }
}
```

这种配置风格在很大程度上等同于 XML bean 定义，甚至支持 Spring 的 XML 配置命名空间。它还允许通过 `importBeans` 指令导入 XML bean 定义文件。

### 1.2.3 使用容器

`ApplicationContext` 是高级工厂的接口，能够维护不同bean及其依赖项的注册表。通过使用方法 `T getBean(String name, Class<T> requiredType)`，您可以检索 bean 的实例。

`ApplicationContext` 允许您读取 bean 定义并访问它们，如下例所示：

```java
// create and configure beans
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");

// retrieve configured instance
PetStoreService service = context.getBean("petStore", PetStoreService.class);

// use configured instance
List<String> userList = service.getUsernameList();
```

对于 Groovy 配置，引导看起来非常相似。它有一个不同的上下文实现类，它支持Groovy（但也理解 XML bean 定义）。以下示例显示 Groovy 配置：

```java
ApplicationContext context = new GenericGroovyApplicationContext("services.groovy", "daos.groovy");
```

最灵活的变体是 `GenericApplicationContext` 与读者委托相结合 — 例如，使用 XML 文件的 `XmlBeanDefinitionReader`，如下例所示：

```java
GenericApplicationContext context = new GenericApplicationContext();
new XmlBeanDefinitionReader(context).loadBeanDefinitions("services.xml", "daos.xml");
context.refresh();
```

您可以在同一 `ApplicationContext` 上混合和匹配这样的读取器委托，从不同的配置源读取 bean 定义。

然后可以使用 `getBean` 来检索 bean 的实例。`ApplicationContext` 接口有一些其他方法来检索 bean，但理想情况下，应用程序代码不应该使用它们。实际上，您的应用程序代码根本不应该调用 `getBean()` 方法，因此根本不依赖 Spring API。例如，Spring 与 web 框架的集成为各种 web 框架组件（如控制器和 JSF 管理的bean）提供了依赖注入，允许您通过元数据（如自动连接注解）声明对特定 bean 的依赖。

## 1.3 Bean 概览

Spring IoC 容器管理一个或多个 bean。这些 bean 是使用您提供给容器的配置元数据创建的（例如，以 XML `<bean/>` 定义的形式）。

在容器本身中，这些 bean 定义表示为 `BeanDefinition` 对象，其中包含（以及其他信息）以下元数据：

- 包限定类名：通常是所定义的 bean 的实际实现类。
- Bean 行为配置元素，它说明 Bean 在容器中的行为（范围、生命周期回调等）。
- 对 bean 工作所需的其他 bean 的引用。这些引用也称为合作者或依赖关系。
- 要在新创建的对象中设置的其他配置设置——例如，池的大小限制或在管理连接池的 bean 中使用的连接数。

此元数据转换为组成每个 bean 定义的一组属性。下表描述了这些属性：

| 属性         | 在哪一节解释                                                 |
| ------------ | ------------------------------------------------------------ |
| 类           | [实例化 Beans](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-class) |
| 名字         | [命名 Beans](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-beanname) |
| 作用域       | [Bean 作用域](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes) |
| 构造方法参数 | [依赖注入](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-collaborators) |
| 属性         | [依赖注入](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-collaborators) |
| 自动匹配模式 | [自动匹配协作者](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-autowire) |
| 懒初始化模式 | [懒初始化 Beans](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-lazy-init) |
| 初始化方法   | [初始化回调](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-lifecycle-initializingbean) |
| 销毁方法     | [销毁回调](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-lifecycle-disposablebean) |

除了包含如何创建特定 bean 的信息的 bean 定义之外，`ApplicationContext` 实现还允许注册（由用户）在容器外部创建的现有对象。这是通过 `getBeanFactory()` 方法访问 ApplicationContext 的 `BeanFactory` 实现的，该方法返回 `DefaultListableBeanFactory` 实现。`DefaultListableBeanFactory` 通过 `registerSingleton(..)` 和 `registerBeanDefinition(..)` 方法支持此注册。然而，典型的应用程序只使用通过常规 bean 定义元数据定义的 bean。

> 需要尽早注册 Bean 元数据和手动提供的单例实例，以便容器在自动匹配和其他内省步骤中正确推理。虽然在某种程度上支持覆盖现有元数据和现有单例实例，但在运行时注册新 bean（与对工厂的实时访问同时进行）并不是官方支持的，这可能会导致并发访问异常、bean 容器中的状态不一致或两者兼而有之。

### 1.3.1 命名 Bean

每个 bean 都有一个或多个标识符。这些标识符在承载 bean 的容器中必须是唯一的。bean 通常只有一个标识符。但是，如果它需要多个别名，则可以将额外的别名视为别名。

在基于 XML 的配置元数据中，可以使用 `id` 属性、`name` 属性或两者来指定 bean 标识符。`id` 属性允许您只指定一个 id。按照惯例，这些名称是字母数字（'myBean'、'someService'等），但它们也可以包含特殊字符。如果要为 bean 引入其他别名，还可以在 `name` 属性中指定它们，用逗号（`,`）、分号（`;`）或空格分隔。作为历史记录，在 Spring 3.1 之前的版本中，`id` 属性被定义为 `xsd:ID` 类型，这限制了可能的字符。从 3.1 开始，它被定义为 `xsd:string` 类型。注意，bean `id` 唯一性仍然由容器强制执行，尽管不再由 XML 解析器强制执行。

不需要为 bean 提供 `name` 或 `id`。如果没有显式提供 `name` 或 `id`，那么容器将为该 bean 生成唯一的名称。但是，如果您希望通过使用 `ref` 元素或 Service Locator 样式的查找来按名称引用该 bean，则必须提供名称。不提供名称的动机与使用内部 bean 和自动匹配合作者有关。

> **Bean 命名约定**
>
> 约定是在命名 bean 时使用标准 Java 约定作为实例字段名。也就是说，bean 名称以小写字母开头，并使用驼峰式大小写。此类名称的示例包括 `accountManager`、`accountService`、`userDao`、`loginController` 等。
>
> 命名 bean 始终使您的配置更易于阅读和理解。此外，如果您使用 SpringAOP，那么在将建议应用于一组按名称相关的 bean 时，它会有很大帮助。

> 通过类路径中的组件扫描，Spring 按照前面描述的规则为未命名的组件生成 bean 名称：本质上，采用简单的类名并将其初始字符改为小写。然而，在（不寻常的）特殊情况下，当有多个字符且第一个和第二个字符都是大写时，原始大小写将被保留。这些规则与 `java.beans.Introspector.decapital` 定义的规则相同（Spring 在此使用）。

#### 在 Bean 定义之外别名 Bean

在 bean 定义本身中，可以通过使用 `id` 属性指定的最多一个名称和 `name` 属性中任意数量的其他名称的组合，为 bean 提供多个名称。这些名称可以是同一个 bean 的等效别名，在某些情况下非常有用，例如，通过使用特定于该组件本身的 bean 名称，让应用程序中的每个组件引用公共依赖项。

然而，在实际定义 bean 的地方指定所有别名并不总是足够的。有时需要为其他地方定义的 bean 引入别名。在大型系统中，配置在每个子系统中被分割，每个子系统都有自己的一组对象定义。在基于 XML 的配置元数据中，可以使用 `<alias/>` 元素来实现这一点。以下示例显示了如何执行此操作：

```xml
<alias name="fromName" alias="toName"/>
```

在这种情况下，名为 `fromName` 的 bean（在同一容器中）也可以在使用此别名定义后被称为 `toName`。

例如，子系统 A 的配置元数据可以通过 `subsystemA-dataSource` 的名称引用DataSource。子系统 B 的配置元数据可以通过 `subsystemB-dataSource` 的名称引用 DataSource。当组成使用这两个子系统的主应用程序时，主应用程序以 `myApp -dataSource` 的名称引用 DataSource。要使所有三个名称都引用同一对象，可以将以下别名定义添加到配置元数据中：

```xml
<alias name="myApp-dataSource" alias="subsystemA-dataSource"/>
<alias name="myApp-dataSource" alias="subsystemB-dataSource"/>
```

现在，每个组件和主应用程序都可以通过一个唯一的名称引用 dataSource，并且保证不会与任何其他定义冲突（有效地创建了一个命名空间），但它们引用的是同一个 bean。

> **Java 配置**
>
> 如果使用 Java 配置，`@Bean` 注解可以用于提供别名。有关详细信息，请参阅使用 `@Bean` 注解。

### 1.3.2 初始化 bean

bean 定义本质上是创建一个或多个对象的方法。当被询问时，容器查看命名 bean的配方，并使用该 bean 定义封装的配置元数据来创建（或获取）实际对象。

如果使用基于 XML 的配置元数据，则在 `<bean/>` 元素的 `class` 属性中指定要实例化的对象的类型（或类）。该 `class` 属性（在内部是 `BeanDefinition` 实例上的 `Class` 属性）通常是必需的。（有关异常，请参阅使用实例工厂方法实例化和 Bean 定义继承。）可以通过以下两种方式之一使用 `Class` 属性：

- 通常，在容器本身通过反射式调用其构造函数直接创建 bean 的情况下，指定要构建的 bean 类，这在某种程度上与使用 `new` 运算符的 Java 代码等效。
- 指定包含被调用以创建对象的 `static` 工厂方法的实际类，在不太常见的情况下，容器在类上调用 `static` 工厂方法以创建 bean。从 `static` 工厂方法调用返回的对象类型可以是同一个类，也可以完全是另一个类。

> **嵌套类名**
>
> 如果要为嵌套类配置 bean 定义，可以使用嵌套类的二进制名称或源名称。
>
> 例如，如果在 `com.example` 包中有一个名为 `SomeThing` 的类，而这个 `SomeThing` 类有一个 `static` 嵌套类 `OtherThing`，它们可以用美元符号（`$`）或点（`.`）分隔。因此 bean 定义中 `class` 属性的值将是 `com.example.SomeThing$OtherThing` 或 `com.example.SomeThing.OtherThing`。

#### 使用构造方法初始化

当您通过构造函数方法创建 bean 时，所有普通类都可由 Spring 使用并与 Spring 兼容。也就是说，正在开发的类不需要实现任何特定的接口或以特定的方式进行编码。只需指定 bean 类就足够了。然而，根据您为特定 bean 使用的 IoC 类型，您可能需要一个默认（空）构造函数。

Spring IoC 容器实际上可以管理您希望它管理的任何类。它不限于管理真正的 JavaBeans。大多数 Spring 用户更喜欢实际的 JavaBean，它只有一个默认的（无参数）构造函数，以及根据容器中的属性建模的适当的 setter 和 getter。您还可以在容器中包含更多奇特的非 bean 样式类。例如，如果您需要使用绝对不遵守 JavaBean 规范的遗留连接池，Spring 也可以管理它。

使用基于XML的配置元数据，可以如下指定bean类：

```xml
<bean id="exampleBean" class="examples.ExampleBean"/>

<bean name="anotherExample" class="examples.ExampleBeanTwo"/>
```

有关向构造方法提供参数（如果需要）和在构造对象后设置对象实例属性的机制的详细信息，请参阅“注入依赖项”。

#### 使用静态工厂方法初始化

在定义使用静态工厂方法创建的 bean 时，使用 `class` 属性指定包含 `static` 工厂方法的类，并使用名为 `factory-method` 的属性指定工厂方法本身的名称。您应该能够调用此方法（如后面所述，使用可选参数）并返回一个活动对象，该对象随后被视为是通过构造函数创建的。这种 bean 定义的一个用途是在遗留代码中调用 `static` 工厂。

下面的 bean 定义指定将通过调用工厂方法来创建 bean。定义没有指定返回对象的类型（类），而是指定包含工厂方法的类。在此示例中，`createInstance()` 方法必须是 `static` 方法。以下示例显示了如何指定工厂方法：

```xml
<bean id="clientService"
    class="examples.ClientService"
    factory-method="createInstance"/>
```

下面的

示例显示了一个可以使用前面的 bean 定义的类：

```java
public class ClientService {
    private static ClientService clientService = new ClientService();
    private ClientService() {}

    public static ClientService createInstance() {
        return clientService;
    }
}
```

有关在对象从工厂返回后为工厂方法提供（可选）参数和设置对象实例属性的机制的详细信息，请参阅“详细介绍依赖和配置”。

#### 使用实例工厂方法初始化

与通过静态工厂方法进行实例化类似，使用实例工厂方法的实例化从容器调用现有 bean 的非静态方法来创建新 bean。要使用此机制，请将 `class` 属性留空，并在 `factory-bean` 属性中指定当前（或父或祖先）容器中的 bean 名称，该容器包含要调用以创建对象的实例方法。使用 `factory-method` 属性设置工厂方法本身的名称。以下示例显示了如何配置这样的 bean：

```xml
<!-- the factory bean, which contains a method called createInstance() -->
<bean id="serviceLocator" class="examples.DefaultServiceLocator">
    <!-- inject any dependencies required by this locator bean -->
</bean>

<!-- the bean to be created via the factory bean -->
<bean id="clientService"
    factory-bean="serviceLocator"
    factory-method="createClientServiceInstance"/>
```

以下示例显示了相应的类：

```java
public class DefaultServiceLocator {

    private static ClientService clientService = new ClientServiceImpl();

    public ClientService createClientServiceInstance() {
        return clientService;
    }
}
```

一个工厂类也可以包含多个工厂方法，如下例所示：

```xml
<bean id="serviceLocator" class="examples.DefaultServiceLocator">
    <!-- inject any dependencies required by this locator bean -->
</bean>

<bean id="clientService"
    factory-bean="serviceLocator"
    factory-method="createClientServiceInstance"/>

<bean id="accountService"
    factory-bean="serviceLocator"
    factory-method="createAccountServiceInstance"/>
```

以下示例显示了相应的类：

```java
public class DefaultServiceLocator {

    private static ClientService clientService = new ClientServiceImpl();

    private static AccountService accountService = new AccountServiceImpl();

    public ClientService createClientServiceInstance() {
        return clientService;
    }

    public AccountService createAccountServiceInstance() {
        return accountService;
    }
}
```

这种方法表明，工厂 bean 本身可以通过依赖注入（DI）进行管理和配置。请参阅详细的依赖关系和配置。

> 在 Spring 文档中，“工厂 bean”是指在 Spring 容器中配置的 bean，它通过实例或静态工厂方法创建对象。相比之下，`FactoryBean`（注意大小写）是指特定于 Spring 的 `FactoryBean` 实现类。

#### 确定 Bean 的运行时类型

特定 bean 的运行时类型很难确定。bean 元数据定义中的指定类只是一个初始类引用，可能与声明的工厂方法组合在一起，或者是一个 `FactoryBean` 类，这可能导致 bean 的运行时类型不同，或者在实例级工厂方法（而是通过指定的 `factory-bean` 名称解析）的情况下根本不设置。此外，AOP 代理可以用基于接口的代理来包装 bean 实例，并有限地暴露目标 bean 的实际类型（仅其实现的接口）。

了解特定 bean 的实际运行时类型的推荐方法是对指定 bean 名称的 `BeanFactory.getType` 调用。这将考虑所有上述情况，并返回 `BeanFactory.getBean` 调用将为相同的 bean 名称返回的对象类型。

## 1.4 依赖

典型的企业应用程序不包含单个对象（或 Spring 中的 bean）。即使是最简单的应用程序也有几个对象，它们一起工作，以呈现最终用户认为一致的应用程序。下一节将解释如何从定义独立的多个 bean 定义到完全实现的应用程序，在该应用程序中，对象协作以实现目标。

### 1.4.1 依赖注入

依赖注入（DI）是一个过程，在此过程中，对象仅通过构造函数参数、工厂方法的参数或财产来定义其依赖项（即，与它们一起工作的其他对象），这些参数在对象实例被构造或从工厂方法返回后设置在对象实例上。然后，容器在创建 bean 时注入这些依赖项。这个过程基本上是 bean 本身的逆过程（因此称为控制反转），它通过使用类的直接构造或服务定位器模式来自己控制依赖项的实例化或位置。

使用 DI 原则，代码更清晰，当为对象提供依赖项时，解耦更有效。对象不查找其依赖项，也不知道依赖项的位置或类别。因此，您的类变得更容易测试，特别是当依赖项依赖于接口或抽象基类时，这允许在单元测试中使用存根（stub）或模拟（mock）实现。

DI 有两种主要变体：基于构造方法的依赖注入和基于 Setter 的依赖注入。

#### 基于构造方法的依赖注入

基于构造函数的 DI 是通过容器调用带有多个参数的构造函数来实现的，每个参数表示一个依赖项。调用带有特定参数的静态工厂方法来构造 bean 几乎是等效的，本文将类似地处理构造函数和静态工厂方法的参数。以下示例显示了一个只能通过构造函数注入进行依赖注入的类：

```java
public class SimpleMovieLister {

    // the SimpleMovieLister has a dependency on a MovieFinder
    private final MovieFinder movieFinder;

    // a constructor so that the Spring container can inject a MovieFinder
    public SimpleMovieLister(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // business logic that actually uses the injected MovieFinder is omitted...
}
```

注意，这个类没有什么特别之处。它是一个 POJO，不依赖于容器特定的接口、基类或注解。

##### 构造函数参数解析

通过使用参数的类型进行构造函数参数解析匹配。如果 bean 定义的构造函数参数中不存在潜在的歧义，那么在 bean 定义中定义构造函数参数的顺序就是在实例化 bean 时将这些参数提供给相应构造函数的顺序。考虑以下类：

```java
public class ThingOne {

    public ThingOne(ThingTwo thingTwo, ThingThree thingThree) {
        // ...
    }
}
```

假设 `ThingTwo` 和 `ThingThree` 类没有继承关系，则不存在潜在的歧义。因此，以下配置工作正常，不需要在 `<constructor-arg/>` 元素中显式指定构造函数参数索引或类型。

```xml
<beans>
    <bean id="beanOne" class="x.y.ThingOne">
        <constructor-arg ref="beanTwo"/>
        <constructor-arg ref="beanThree"/>
    </bean>

    <bean id="beanTwo" class="x.y.ThingTwo"/>

    <bean id="beanThree" class="x.y.ThingThree"/>
</beans>
```

当引用另一个 bean 时，该类型是已知的，并且可以进行匹配（前面的示例就是这样）。当使用简单类型（例如 `<value>true</value>`）时，Spring无法确定值的类型，因此在没有帮助的情况下无法按类型进行匹配。考虑以下类：

```java
public class ExampleBean {

    // Number of years to calculate the Ultimate Answer
    private final int years;

    // The Answer to Life, the Universe, and Everything
    private final String ultimateAnswer;

    public ExampleBean(int years, String ultimateAnswer) {
        this.years = years;
        this.ultimateAnswer = ultimateAnswer;
    }
}
```

在前面的场景中，如果通过使用 type 属性显式指定构造函数参数的类型，则容器可以使用与简单类型匹配的类型，如下例所示：

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg type="int" value="7500000"/>
    <constructor-arg type="java.lang.String" value="42"/>
</bean>
```

可以使用 `index` 属性显式指定构造函数参数的索引，如下例所示：

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg index="0" value="7500000"/>
    <constructor-arg index="1" value="42"/>
</bean>
```

除了解决多个简单值的歧义外，指定索引还解决了构造函数具有两个相同类型参数的歧义。

> 索引从 0 开始

还可以使用构造函数参数名称来消除值歧义，如下例所示：

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <constructor-arg name="years" value="7500000"/>
    <constructor-arg name="ultimateAnswer" value="42"/>
</bean>
```

请记住，要使这项工作开箱即用，必须在启用调试标志的情况下编译代码，以便 Spring 可以从构造函数中查找参数名。如果不能或不想用调试标志编译代码，可以使用 @ConstructorProperties JDK 注解显式命名构造函数参数。示例类必须如下所示：

```java
public class ExampleBean {

    // Fields omitted

    @ConstructorProperties({"years", "ultimateAnswer"})
    public ExampleBean(int years, String ultimateAnswer) {
        this.years = years;
        this.ultimateAnswer = ultimateAnswer;
    }
}
```

#### 基于 Setter 的依赖注入

基于 Setter 的 DI 是在调用无参数构造函数或无参数 `static` 工厂方法来实例化 bean 之后，通过容器调用 bean 上的 Setter 方法来实现的。

以下示例显示了一个只能通过使用纯 setter 注入进行依赖注入的类。这个类是传统 Java 的。它是一个 POJO，不依赖于容器特定的接口、基类或注解。

```java
public class SimpleMovieLister {

    // the SimpleMovieLister has a dependency on the MovieFinder
    private MovieFinder movieFinder;

    // a setter method so that the Spring container can inject a MovieFinder
    public void setMovieFinder(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // business logic that actually uses the injected MovieFinder is omitted...
}
```

`ApplicationContext` 为其管理的 bean 支持基于构造函数和基于 setter 的 DI。在已经通过构造函数方法注入了一些依赖项之后，它还支持基于 setter 的 DI。您可以以 `BeanDefinition` 的形式配置依赖项，该定义与 `PropertyEditor` 实例一起用于将财产从一种格式转换为另一种格式。然而，大多数 Spring 用户不直接使用这些类（即，编程），而是使用 XML `bean` 定义、带注解的组件（即，用 `@Component`、`@Controller` 等注解的类）或基于 Java 的 `@Configuration` 类中的 `@Bean` 方法。然后，这些源在内部转换为 `BeanDefinition` 的实例，并用于加载整个 Spring IoC 容器实例。

> **基于构造函数还是基于 setter 的 DI？**
>
> 由于可以混合使用基于构造函数的 DI 和基于 setter 的 DI，因此对于强制依赖项使用构造函数，对于可选依赖项使用 setter 方法或配置方法是一个很好的经验法则。注意，在 setter 方法上使用 @Autowired 注解可以使属性成为必需的依赖项；然而，带有参数编程验证的构造函数注入是可取的。
>
> Spring 团队通常提倡构造函数注入，因为它允许您将应用程序组件实现为不可变对象，并确保所需的依赖项不为 `null`。此外，构造函数注入的组件总是以完全初始化的状态返回给客户端（调用）代码。顺便说一句，大量的构造函数参数是一种糟糕的代码气味，这意味着类可能有太多的责任，应该进行重构以更好地解决适当的关注点分离问题。
>
> Setter 注入应该主要用于可选依赖项，这些依赖项可以在类中分配合理的默认值。否则，在代码使用依赖项的任何地方都必须执行非空检查。setter 注入的一个好处是 setter 方法使该类的对象可以稍后重新配置或重新注入。因此，通过 JMX MBean 进行管理是 setter 注入的一个引人注目的用例。
>
> 使用对特定类最有意义的 DI 样式。有时，在处理您没有源代码的第三方类时，您可以自行选择。例如，如果第三方类不公开任何 setter 方法，那么构造函数注入可能是 DI 的唯一可用形式。

#### 依赖关系解决过程

容器执行 bean 依赖解析，如下所示：

- `ApplicationContext` 是用描述所有 bean 的配置元数据创建和初始化的。配置元数据可以由 XML、Java 代码或注解指定。
- 对于每个 bean，它的依赖关系都以属性、构造方法参数或 static-factory 方法的参数的形式表示（如果使用该方法而不是普通构造方法）。当实际创建 bean 时，这些依赖项被提供给 bean。
- 每个属性或构造函数参数都是要设置的值的实际定义，或者是对容器中另一个 bean 的引用。
- 作为值的每个属性或构造方法参数都从其指定格式转换为该属性或构造方法的实际类型。默认情况下，Spring 可以将以字符串格式提供的值转换为所有内置类型，例如 `int`、`long`、`String`、`boolean` 等。

Spring 容器在创建容器时验证每个 bean 的配置。然而，在实际创建 bean 之前，不会设置 bean 属性本身。当创建容器时，将创建单例作用域并设置为预实例化（默认）的 bean。作用域在 Bean 作用域中定义。否则，bean 仅在请求时创建。创建bean 可能会导致创建 bean 图，因为创建和分配了 bean 的依赖项及其依赖项的依赖项（等等）。请注意，这些依赖项之间的解析不匹配可能会很晚出现——也就是说，在第一次创建受影响的 bean 时。

> **循环依赖关系**
>
> 如果主要使用构造函数注入，则有可能创建一个无法解决的循环依赖场景。
>
> 例如：类 A 通过构造函数注入需要类 B 的实例，而类 B 通过构造函数注入要求类 A 的实例。如果将类 A 和 B 的 bean 配置为相互注入，Spring IoC 容器将在运行时检测到该循环引用，并抛出 `BeanCurrentlyInCreationException`。
>
> 一种可能的解决方案是编辑某些类的源代码，以便由 setter 而不是构造函数进行配置。或者，避免构造函数注入，只使用 setter 注入。换句话说，虽然不建议使用 setter 注入，但您可以配置循环依赖关系。
>
> 与典型的情况（没有循环依赖关系）不同，bean A 和 bean B 之间的循环依赖关系迫使其中一个 bean 在完全初始化之前注入另一个 bean（典型的鸡和蛋场景）。

您通常可以相信 Spring 会做正确的事情。它在容器加载时检测配置问题，例如对不存在的 bean 的引用和循环依赖关系。Spring 设置属性并在实际创建 bean 时尽可能晚地解析依赖项。这意味着，如果在创建对象或其依赖项时出现问题，则正确加载的 Spring 容器稍后可以在请求对象时生成异常——例如，bean 由于缺少或无效属性而抛出异常。这可能会延迟某些配置问题的可见性，这就是 `ApplicationContext` 实现默认情况下预实例化单例 bean 的原因。在实际需要这些 bean 之前，您需要花费一些前期时间和内存来创建这些 bean，但在创建 `ApplicationContext` 时，而不是稍后，您会发现配置问题。您仍然可以重写此默认行为，以便单例 bean 延迟初始化，而不是急切地预实例化。

如果不存在循环依赖关系，那么当一个或多个协作 bean 被注入到依赖 bean 中时，每个协作 bean 在被注入到该依赖 bean 之前都是完全配置好的。这意味着，如果 bean A 对 bean B 具有依赖性，则 Spring IoC 容器在调用 bean A 上的 setter 方法之前完全配置 bean B。换句话说，bean 被实例化（如果它不是预实例化的单例），其依赖性被设置，并且相关的生命周期方法（如配置的 init 方法或 InitializingBean 回调方法）被调用。

#### 依赖注入示例

以下示例将基于 XML 的配置元数据用于基于 setter 的 DI。Spring XML 配置文件的一小部分指定了一些 bean 定义，如下所示：

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <!-- setter injection using the nested ref element -->
    <property name="beanOne">
        <ref bean="anotherExampleBean"/>
    </property>

    <!-- setter injection using the neater ref attribute -->
    <property name="beanTwo" ref="yetAnotherBean"/>
    <property name="integerProperty" value="1"/>
</bean>

<bean id="anotherExampleBean" class="examples.AnotherBean"/>
<bean id="yetAnotherBean" class="examples.YetAnotherBean"/>
```

以下示例显示了相应的 `ExampleBean` 类：

```java
public class ExampleBean {

    private AnotherBean beanOne;

    private YetAnotherBean beanTwo;

    private int i;

    public void setBeanOne(AnotherBean beanOne) {
        this.beanOne = beanOne;
    }

    public void setBeanTwo(YetAnotherBean beanTwo) {
        this.beanTwo = beanTwo;
    }

    public void setIntegerProperty(int i) {
        this.i = i;
    }
}
```

在前面的示例中，setter 被声明为与 XML 文件中指定的属性相匹配。以下示例使用基于构造函数的 DI：

```xml
<bean id="exampleBean" class="examples.ExampleBean">
    <!-- constructor injection using the nested ref element -->
    <constructor-arg>
        <ref bean="anotherExampleBean"/>
    </constructor-arg>

    <!-- constructor injection using the neater ref attribute -->
    <constructor-arg ref="yetAnotherBean"/>

    <constructor-arg type="int" value="1"/>
</bean>

<bean id="anotherExampleBean" class="examples.AnotherBean"/>
<bean id="yetAnotherBean" class="examples.YetAnotherBean"/>
```

以下示例显示了相应的 `ExampleBean` 类：

```java
public class ExampleBean {

    private AnotherBean beanOne;

    private YetAnotherBean beanTwo;

    private int i;

    public ExampleBean(
        AnotherBean anotherBean, YetAnotherBean yetAnotherBean, int i) {
        this.beanOne = anotherBean;
        this.beanTwo = yetAnotherBean;
        this.i = i;
    }
}
```

bean 定义中指定的构造函数参数用作 `ExampleBean` 的构造函数的参数。

现在考虑这个示例的一个变体，其中告诉 Spring 调用 `static` 工厂方法以返回对象的实例，而不是使用构造函数：

```xml
<bean id="exampleBean" class="examples.ExampleBean" factory-method="createInstance">
    <constructor-arg ref="anotherExampleBean"/>
    <constructor-arg ref="yetAnotherBean"/>
    <constructor-arg value="1"/>
</bean>

<bean id="anotherExampleBean" class="examples.AnotherBean"/>
<bean id="yetAnotherBean" class="examples.YetAnotherBean"/>
```

以下示例显示了相应的 `ExampleBean` 类：

```java
public class ExampleBean {

    // a private constructor
    private ExampleBean(...) {
        ...
    }

    // a static factory method; the arguments to this method can be
    // considered the dependencies of the bean that is returned,
    // regardless of how those arguments are actually used.
    public static ExampleBean createInstance (
        AnotherBean anotherBean, YetAnotherBean yetAnotherBean, int i) {

        ExampleBean eb = new ExampleBean (...);
        // some other operations...
        return eb;
    }
}
```

`static` 工厂方法的参数由 `<constructor-arg/>` 元素提供，与实际使用的构造函数完全相同。由工厂方法返回的类的类型不必与包含 `static` 工厂方法的类具有相同的类型（尽管在本例中是）。实例（非静态）工厂方法可以以基本相同的方式使用（除了使用 `factory-bean` 属性而不是 `class` 属性），因此我们在这里不讨论这些细节。

### 1.4.2 详细介绍依赖和配置
