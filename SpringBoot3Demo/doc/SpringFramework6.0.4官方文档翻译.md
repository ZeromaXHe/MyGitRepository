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

然后可以使用 `getBean` 来检索 bean 的实例。`ApplicationContext` 接口有一些其他方法来检索 bean，但理想情况下，应用程序代码不应该使用它们。实际上，您的应用程序代码根本不应该调用 `getBean()` 方法，因此根本不依赖 Spring API。例如，Spring 与 web 框架的集成为各种 web 框架组件（如控制器和 JSF 管理的bean）提供了依赖注入，允许您通过元数据（如自动装配注解）声明对特定 bean 的依赖。

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
| 自动装配模式 | [自动装配协作者](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-autowire) |
| 懒初始化模式 | [懒初始化 Beans](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-lazy-init) |
| 初始化方法   | [初始化回调](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-lifecycle-initializingbean) |
| 销毁方法     | [销毁回调](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-lifecycle-disposablebean) |

除了包含如何创建特定 bean 的信息的 bean 定义之外，`ApplicationContext` 实现还允许注册（由用户）在容器外部创建的现有对象。这是通过 `getBeanFactory()` 方法访问 ApplicationContext 的 `BeanFactory` 实现的，该方法返回 `DefaultListableBeanFactory` 实现。`DefaultListableBeanFactory` 通过 `registerSingleton(..)` 和 `registerBeanDefinition(..)` 方法支持此注册。然而，典型的应用程序只使用通过常规 bean 定义元数据定义的 bean。

> 需要尽早注册 Bean 元数据和手动提供的单例实例，以便容器在自动装配和其他内省步骤中正确推理。虽然在某种程度上支持覆盖现有元数据和现有单例实例，但在运行时注册新 bean（与对工厂的实时访问同时进行）并不是官方支持的，这可能会导致并发访问异常、bean 容器中的状态不一致或两者兼而有之。

### 1.3.1 命名 Bean

每个 bean 都有一个或多个标识符。这些标识符在承载 bean 的容器中必须是唯一的。bean 通常只有一个标识符。但是，如果它需要多个别名，则可以将额外的别名视为别名。

在基于 XML 的配置元数据中，可以使用 `id` 属性、`name` 属性或两者来指定 bean 标识符。`id` 属性允许您只指定一个 id。按照惯例，这些名称是字母数字（'myBean'、'someService'等），但它们也可以包含特殊字符。如果要为 bean 引入其他别名，还可以在 `name` 属性中指定它们，用逗号（`,`）、分号（`;`）或空格分隔。作为历史记录，在 Spring 3.1 之前的版本中，`id` 属性被定义为 `xsd:ID` 类型，这限制了可能的字符。从 3.1 开始，它被定义为 `xsd:string` 类型。注意，bean `id` 唯一性仍然由容器强制执行，尽管不再由 XML 解析器强制执行。

不需要为 bean 提供 `name` 或 `id`。如果没有显式提供 `name` 或 `id`，那么容器将为该 bean 生成唯一的名称。但是，如果您希望通过使用 `ref` 元素或 Service Locator 样式的查找来按名称引用该 bean，则必须提供名称。不提供名称的动机与使用内部 bean 和自动装配合作者有关。

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

如前一节所述，您可以将 bean 属性和构造函数参数定义为对其他托管 bean（协作者）的引用或内联定义的值。为此，Spring 基于 XML 的配置元数据支持 `<property/>` 和 `<constructor-arg/>` 元素中的子元素类型。

#### 直接值（基础类型，字符串和其他）

`<property/>` 元素的 `value` 属性将属性或构造函数参数指定为人类可读的字符串表示形式。Spring 的转换服务用于将这些值从`String` 转换为属性或参数的实际类型。以下示例显示了正在设置的各种值：

```xml
<bean id="myDataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
    <!-- results in a setDriverClassName(String) call -->
    <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
    <property name="url" value="jdbc:mysql://localhost:3306/mydb"/>
    <property name="username" value="root"/>
    <property name="password" value="misterkaoli"/>
</bean>
```

以下示例使用 p-命名空间进行更简洁的 XML 配置：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="myDataSource" class="org.apache.commons.dbcp.BasicDataSource"
        destroy-method="close"
        p:driverClassName="com.mysql.jdbc.Driver"
        p:url="jdbc:mysql://localhost:3306/mydb"
        p:username="root"
        p:password="misterkaoli"/>

</beans>
```

前面的 XML 更加简洁。然而，错误是在运行时而不是设计时发现的，除非您使用支持在创建 bean 定义时自动完成属性的 IDE（如 IntelliJ IDEA 或 Spring Tools for Eclipse）。强烈建议提供此类 IDE 帮助。

您还可以配置 `java.util.Properties` 实例，如下所示：

```xml
<bean id="mappings"
    class="org.springframework.context.support.PropertySourcesPlaceholderConfigurer">

    <!-- typed as a java.util.Properties -->
    <property name="properties">
        <value>
            jdbc.driver.className=com.mysql.jdbc.Driver
            jdbc.url=jdbc:mysql://localhost:3306/mydb
        </value>
    </property>
</bean>
```

Spring 容器使用 JavaBeans `PropertyEditor` 机制将 `<value/>` 元素内的文本转换为 `java.util.Properties` 实例。这是一个很好的快捷方式，也是 Spring 团队支持使用嵌套的 `<value/>` 元素而不是 `value` 属性样式的几个地方之一。

##### idref 元素

`idref` 元素只是将容器中另一个 bean 的 `id`（字符串值，而不是引用）传递给 `<constructor-arg/>` 或 `<property/>` 元素的一种防错方法。以下示例显示了如何使用它：

```xml
<bean id="theTargetBean" class="..."/>

<bean id="theClientBean" class="...">
    <property name="targetName">
        <idref bean="theTargetBean"/>
    </property>
</bean>
```

前面的 bean 定义片段与以下片段完全等价（在运行时）：

```xml
<bean id="theTargetBean" class="..." />

<bean id="client" class="...">
    <property name="targetName" value="theTargetBean"/>
</bean>
```

第一种形式比第二种形式更好，因为使用 `idref` 标记可以让容器在部署时验证引用的、命名的 bean 是否确实存在。在第二个变体中，对传递给 `client` bean 的 `targetName` 属性的值不进行验证。只有当 `client` bean 实际实例化时，才会发现类型（最有可能是致命的结果）。如果 `client` bean 是一个原型 bean，那么只有在部署容器之后很长一段时间才会发现这个错误和由此产生的异常。

> 4.0 beans XSD 不再支持 `idref` 元素上的 `local` 属性，因为它不再为常规 `bean` 引用提供值。升级到 4.0 模式时，将现有的 `idref local` 引用更改为 `idref bean`。

`<idref/>` 元素带来值的一个常见位置（至少在 Spring 2.0 之前的版本中）是 `ProxyFactoryBean` bean 定义中 AOP 拦截器的配置。在指定拦截器名称时使用 `<idref/>` 元素可以防止您拼错拦截器 ID。

#### 引用其他 Bean（协作者）

`ref` 元素是 `<constructor-arg/>` 或 `<property/>` 定义元素中的最后一个元素。在这里，您将 bean 的指定属性的值设置为对容器管理的另一个 bean（协作者）的引用。被引用的 bean 是要设置其属性的 bean 的依赖项，并且在设置属性之前根据需要对其进行初始化。（如果协作者是单例 bean，它可能已经被容器初始化。）所有引用最终都是对另一个对象的引用。作用域和验证取决于是否通过 `bean` 或 `parent` 属性指定其他对象的 ID 或名称。

通过 `<ref/>` 标记的 `bean` 属性指定目标 bean 是最通用的形式，它允许创建对同一容器或父容器中任何 bean 的引用，而不管它是否在同一 XML 文件中。`bean` 属性的值可以与目标 bean 的 `id` 属性相同，或者与目标 bean `name` 属性中的值之一相同。以下示例显示了如何使用 `ref` 元素：

```xml
<ref bean="someBean"/>
```

通过 `parent` 属性指定目标 bean 将创建对当前容器的父容器中的 bean 的引用。`parent` 属性的值可以与目标 bean 的 `id` 属性或目标 bean 的 `name` 属性中的值之一相同。目标 bean 必须位于当前 bean 的父容器中。当您有一个容器层次结构，并且希望使用与父 bean 同名的代理将现有 bean 包装在父容器中时，应该主要使用这个 bean 引用变量。以下列表显示了如何使用 `parent` 属性：

```xml
<!-- in the parent context -->
<bean id="accountService" class="com.something.SimpleAccountService">
    <!-- insert dependencies as required here -->
</bean>
```

```xml
<!-- in the child (descendant) context -->
<bean id="accountService" <!-- bean name is the same as the parent bean -->
    class="org.springframework.aop.framework.ProxyFactoryBean">
    <property name="target">
        <ref parent="accountService"/> <!-- notice how we refer to the parent bean -->
    </property>
    <!-- insert other configuration and dependencies as required here -->
</bean>
```

> 4.0 bean XSD 不再支持 `ref` 元素上的 `local` 属性，因为它不再提供常规 `bean` 引用的值。升级到 4.0 模式时，将现有的 `ref local` 引用更改为 `ref bean`。

#### 内部 Bean

`<property/>` 或 `<constructor-arg/>` 元素中的 `<bean/>` 元素定义了一个内部 bean，如下例所示：

```xml
<bean id="outer" class="...">
    <!-- instead of using a reference to a target bean, simply define the target bean inline -->
    <property name="target">
        <bean class="com.example.Person"> <!-- this is the inner bean -->
            <property name="name" value="Fiona Apple"/>
            <property name="age" value="25"/>
        </bean>
    </property>
</bean>
```

内部 bean 定义不需要定义的 ID 或名称。如果指定，则容器不使用此类值作为标识符。容器还忽略了创建时的 `scope` 标志，因为内部 bean 始终是匿名的，并且始终使用外部 bean 创建。不可能独立访问内部 bean，也不可能将它们注入到协作 bean 中而不是封闭 bean中。

作为特例，可以从自定义作用域接收销毁回调——例如，对于包含在单例 bean 中的请求作用域的内部 bean。内部 bean 实例的创建与其包含的 bean 相关联，但销毁回调允许它参与请求作用域的生命周期。这不是常见的情况。内部 bean 通常只共享其包含 bean 的作用域。

#### 集合

`<list/>`, `<set/>`, `<map/>`, 和 `<props/>` 元素分别设置 Java `Collection` 类型 `List`、`Set`、`Map` 和 `Properties` 的属性和参数。以下示例显示了如何使用它们：

```xml
<bean id="moreComplexObject" class="example.ComplexObject">
    <!-- results in a setAdminEmails(java.util.Properties) call -->
    <property name="adminEmails">
        <props>
            <prop key="administrator">administrator@example.org</prop>
            <prop key="support">support@example.org</prop>
            <prop key="development">development@example.org</prop>
        </props>
    </property>
    <!-- results in a setSomeList(java.util.List) call -->
    <property name="someList">
        <list>
            <value>a list element followed by a reference</value>
            <ref bean="myDataSource" />
        </list>
    </property>
    <!-- results in a setSomeMap(java.util.Map) call -->
    <property name="someMap">
        <map>
            <entry key="an entry" value="just some string"/>
            <entry key="a ref" value-ref="myDataSource"/>
        </map>
    </property>
    <!-- results in a setSomeSet(java.util.Set) call -->
    <property name="someSet">
        <set>
            <value>just some string</value>
            <ref bean="myDataSource" />
        </set>
    </property>
</bean>
```

map 键或值的值或 set 值也可以是以下任何元素：

```xml
bean | ref | idref | list | set | map | props | value | null
```

##### 合并集合

Spring 容器还支持合并集合。应用程序开发人员可以定义父 `<list/>`、`<map/>`、`<set/>` 或 `<props/>` 元素，并让子 `<list/>`、`<map/>`、`<set/>` 或 `<props/>` 元素继承和重写父集合中的值。也就是说，子集合的值是合并父集合和子集合的元素的结果，子集合元素覆盖父集合中指定的值。

关于合并的这一节讨论了父子 bean 机制。不熟悉父 bean 和子 bean 定义的读者可能希望在继续之前阅读相关章节。

以下示例演示了集合合并：

```xml
<beans>
    <bean id="parent" abstract="true" class="example.ComplexObject">
        <property name="adminEmails">
            <props>
                <prop key="administrator">administrator@example.com</prop>
                <prop key="support">support@example.com</prop>
            </props>
        </property>
    </bean>
    <bean id="child" parent="parent">
        <property name="adminEmails">
            <!-- the merge is specified on the child collection definition -->
            <props merge="true">
                <prop key="sales">sales@example.com</prop>
                <prop key="support">support@example.co.uk</prop>
            </props>
        </property>
    </bean>
<beans>
```

请注意，在 `child` bean 定义的 `adminEmails` 属性的 `<props/>` 元素上使用了 `merge=true` 属性。当容器解析并实例化 `child` bean 时，生成的实例有一个 `adminEmails` `Properties` 集合，其中包含子 bean 的 `adminEmils` 集合与父 bean 的 `adminEmails` 集合合并的结果。以下列表显示了结果：

```properties
administrator=administrator@example.com
sales=sales@example.com
support=support@example.co.uk
```

子 `Properties` 集合的值集继承父 `<props/>` 的所有属性元素，并且子集合值中的 `support` 值覆盖父集合中的值。

这种合并行为类似于 `<list/>`、`<map/>` 和 `<set/>` 集合类型。在 `<list/>` 元素的特定情况下，与 `List` 集合类型（即值的 `ordered` 集合的概念）相关联的语义得到了维护。父列表的值位于所有子列表的值之前。对于 `Map`、`Set` 和 `Properties` 集合类型，不存在排序。因此，对于容器内部使用的关联 `Map`、`Set` 和 `Properties` 实现类型下面的集合类型，没有有效的排序语义。

##### 集合合并的限制

不能合并不同的集合类型（如 `Map` 和 `List`）。如果你真的尝试这样做，则会引发相应的 `Exception`。必须在较低的继承子定义上指定 `merge` 属性。在父集合定义上指定 `merge` 属性是多余的，不会导致所需的合并。

##### 强类型集合

由于 Java 对泛型类型的支持，您可以使用强类型集合。也就是说，可以声明 `Collection` 类型，使其只能包含（例如）`String` 元素。如果使用 Spring 将强类型的 `Collection` 依赖注入 bean，则可以利用 Spring 的类型转换支持，以便在将强类型 `Collection` 实例的元素添加到 `Collection` 之前将其转换为适当的类型。以下 Java 类和 bean 定义显示了如何做到这一点：

```java
public class SomeClass {

    private Map<String, Float> accounts;

    public void setAccounts(Map<String, Float> accounts) {
        this.accounts = accounts;
    }
}
```

```xml
<beans>
    <bean id="something" class="x.y.SomeClass">
        <property name="accounts">
            <map>
                <entry key="one" value="9.99"/>
                <entry key="two" value="2.75"/>
                <entry key="six" value="3.99"/>
            </map>
        </property>
    </bean>
</beans>
```

当 `something` bean 的 `accounts` 属性准备好进行注入时，关于强类型 `Map<String，Float>` 的元素类型的泛型信息可以通过反射获得。因此，Spring 的类型转换基础结构将各种值元素识别为 `Float` 类型，并且字符串值（`9.99`、`2.75` 和 `3.99`）被转换为实际的 `Float` 型。

#### Null 和空字符串值

Spring 将属性等的空参数视为空 `String`。以下基于 XML 的配置元数据片段将 `email` 属性设置为空 `String` 值（“”）。

```xml
<bean class="ExampleBean">
    <property name="email" value=""/>
</bean>
```

前面的示例等效于以下 Java 代码：

```java
exampleBean.setEmail("");
```

`<null/>` 元素处理 `null` 值。下面的列表显示了一个示例：

```xml
<bean class="ExampleBean">
    <property name="email">
        <null/>
    </property>
</bean>
```

上述配置相当于以下 Java 代码：

```java
exampleBean.setEmail(null);
```

#### 带有 p-命名空间的 XML 快捷方式

p-命名空间允许您使用 `bean` 元素的属性（而不是嵌套的 `<property/>` 元素）来描述协作 bean 的属性值，或者同时描述两者。

Spring 支持基于 XMLSchema 定义的具有命名空间的可扩展配置格式。本章中讨论的 `beans` 配置格式在 XMLSchema 文档中定义。然而，p-命名空间没有在 XSD 文件中定义，只存在于 Spring 的核心中。

以下示例显示了两个解析为相同结果的 XML 片段（第一个使用标准 XML 格式，第二个使用 p-命名空间）：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean name="classic" class="com.example.ExampleBean">
        <property name="email" value="someone@somewhere.com"/>
    </bean>

    <bean name="p-namespace" class="com.example.ExampleBean"
        p:email="someone@somewhere.com"/>
</beans>
```

该示例显示了 bean 定义中名为 `email` 的 p 命名空间中的一个属性。这告诉 Spring 包含属性声明。如前所述，p-命名空间没有模式定义，因此可以将属性的名称设置为属性名称。

下一个示例包括另外两个 bean 定义，它们都引用了另一个 bean：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean name="john-classic" class="com.example.Person">
        <property name="name" value="John Doe"/>
        <property name="spouse" ref="jane"/>
    </bean>

    <bean name="john-modern"
        class="com.example.Person"
        p:name="John Doe"
        p:spouse-ref="jane"/>

    <bean name="jane" class="com.example.Person">
        <property name="name" value="Jane Doe"/>
    </bean>
</beans>
```

此示例不仅包括使用 p-命名空间的属性值，还使用特殊格式声明属性引用。第一个 bean 定义使用 `<property name="spouse" ref="jane"/>` 创建从 bean `john` 到bean `jane` 的引用，而第二个 bean 定义则使用 `p:spouse-ref=“jane”` 作为属性来执行完全相同的操作。在本例中，`spouse` 是属性名，而 `-ref` 部分表示这不是一个直接值，而是对另一个 bean 的引用。

> p-命名空间不如标准 XML 格式灵活。例如，声明属性引用的格式与以 `Ref` 结尾的属性冲突，而标准 XML 格式则不冲突。我们建议您仔细选择您的方法，并将其与团队成员沟通，以避免生成同时使用这三种方法的 XML 文档。

#### 带有 c-命名空间的 XML 快捷方式

与具有 p-命名空间的 XML 快捷方式类似，Spring 3.1 中引入的 c-命名空间允许内联属性来配置构造函数参数，而不是嵌套的构造函数 arg 元素。

以下示例使用 `c:` namespace 执行与基于构造函数的依赖注入相同的操作：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:c="http://www.springframework.org/schema/c"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="beanTwo" class="x.y.ThingTwo"/>
    <bean id="beanThree" class="x.y.ThingThree"/>

    <!-- traditional declaration with optional argument names -->
    <bean id="beanOne" class="x.y.ThingOne">
        <constructor-arg name="thingTwo" ref="beanTwo"/>
        <constructor-arg name="thingThree" ref="beanThree"/>
        <constructor-arg name="email" value="something@somewhere.com"/>
    </bean>

    <!-- c-namespace declaration with argument names -->
    <bean id="beanOne" class="x.y.ThingOne" c:thingTwo-ref="beanTwo"
        c:thingThree-ref="beanThree" c:email="something@somewhere.com"/>

</beans>
```

`c:` 命名空间使用与 `p:`（bean 引用的尾随 `-ref`）相同的约定来按名称设置构造函数参数。类似地，它需要在 XML 文件中声明，即使它没有在 XSD 模式中定义（它存在于 Spring 核心中）。

对于构造函数参数名称不可用的罕见情况（通常在编译字节码时没有调试信息），可以使用回退到参数索引，如下所示：

```xml
<!-- c-namespace index declaration -->
<bean id="beanOne" class="x.y.ThingOne" c:_0-ref="beanTwo" c:_1-ref="beanThree"
    c:_2="something@somewhere.com"/>
```

> 由于 XML 语法，索引表示法需要前导 `_`，因为 XML 属性名称不能以数字开头（即使某些 IDE 允许）。相应的索引表示法也可用于 `<constructor-arg>` 元素，但不常用，因为声明的简单顺序通常就足够了。

实际上，构造函数解析机制在匹配参数方面非常有效，因此除非您真的需要，否则我们建议在整个配置中使用名称表示法。

#### 复合属性名字

设置 bean 属性时，可以使用复合或嵌套属性名，只要路径的所有组件（最终属性名除外）都不为 `null`。考虑以下 bean 定义：

```xml
<bean id="something" class="things.ThingOne">
    <property name="fred.bob.sammy" value="123" />
</bean>
```

`something` bean有一个 `fred` 属性，它有一个 `bob` 属性，它具有 `sammy` 属性，最后的 `sammy` 属性被设置为值 `123`。为了使其工作，在构造 bean 之后，`something` 的 `fred` 属性和 `fred` 的 `bob` 属性不能为空。否则，将引发`NullPointerException`。

### 1.4.3 使用 depends-on

如果一个 bean 是另一个 bean 的依赖项，这通常意味着一个 bean 被设置为另一个的属性。通常，您可以使用基于 XML 的配置元数据中的 `<ref/>` 元素来实现这一点。然而，有时 bean 之间的依赖关系不那么直接。例如，当需要触发类中的静态初始值设定项时，例如数据库驱动程序注册时。`depends-on` 属性可以显式地强制一个或多个 bean 在初始化使用此元素的 bean 之前进行初始化。以下示例使用 `depends-on` 属性来表示对单个 bean 的依赖：

```xml
<bean id="beanOne" class="ExampleBean" depends-on="manager"/>
<bean id="manager" class="ManagerBean" />
```

要表示对多个 bean 的依赖关系，请提供 bean 名称列表作为 `depends-on` 属性的值（逗号、空格和分号是有效的分隔符）：

```xml
<bean id="beanOne" class="ExampleBean" depends-on="manager,accountDao">
    <property name="manager" ref="manager" />
</bean>

<bean id="manager" class="ManagerBean" />
<bean id="accountDao" class="x.y.jdbc.JdbcAccountDao" />
```

> `depends-on` 属性既可以指定初始化期依赖项，也可以指定相应的销毁期依赖项（仅在单例 bean 的情况下）。定义与给定 bean `depends-on` 关系的依赖 bean 首先被销毁，然后再销毁给定 bean 本身。因此，`depends-on` 还可以控制停机顺序。

### 1.4.4 懒初始化 Bean

默认情况下，`ApplicationContext` 实现会立即创建和配置所有单例 bean，作为初始化过程的一部分。通常，这种预实例化是我们希望的，因为配置或周围环境中的错误会立即被发现，而不是几小时甚至几天之后。当这种行为不是我们希望的时，可以通过将 bean 定义标记为惰性初始化来防止单例 bean 的预实例化。延迟初始化的 bean 告诉 IoC 容器在第一次请求时创建 bean 实例，而不是在启动时。

在 XML 中，此行为由 `<bean/>` 元素上的 `lazy-init` 属性控制，如下例所示：

```xml
<bean id="lazy" class="com.something.ExpensiveToCreateBean" lazy-init="true"/>
<bean name="not.lazy" class="com.something.AnotherBean"/>
```

当 `ApplicationContext` 使用前面的配置时，当 `ApplicationContext` 启动时，`lazy` bean 不会被立即预实例化，而 `not.lazy` bean会被立即预先实例化。

然而，当惰性初始化 bean 是未惰性初始化的单例 bean 的依赖项时，`ApplicationContext` 会在启动时创建惰性初始化 bean，因为它必须满足单例的依赖项。惰性初始化的 bean 被注入到其他未惰性初始化的单例 bean 中。

您还可以通过在 `<beans/>` 元素上使用 `default-lazy-init` 属性在容器级别控制懒初始化，如下例所示：

```xml
<beans default-lazy-init="true">
    <!-- no beans will be pre-instantiated... -->
</beans>
```

### 1.4.5 自动装配协作者

Spring 容器可以自动装配协作 bean 之间的关系。通过检查 `ApplicationContext` 的内容，可以让 Spring 自动解析您的 bean 的协作者（其他 bean）。自动装配具有以下优点：

- 自动装配可以大大减少指定属性或构造方法参数的需要。（本章其他地方讨论的其他机制，如 bean 模板，在这方面也很有价值。）
- 自动装配可以随着对象的发展更新配置。例如，如果需要向类添加依赖项，则可以自动满足该依赖项，而无需修改配置。因此，自动装配在开发过程中尤其有用，而不会否定在代码库变得更稳定时切换到显式匹配的可能。

当使用基于 XML 的配置元数据（请参阅依赖注入）时，可以使用 `<bean/>` 元素的 `autowire` 属性为 bean 定义指定 autowire 模式。自动装配功能有四种模式。您指定每个 bean 的自动装配，因此可以选择要自动装配的 bean。下表介绍了四种自动装配模式：

| 模式          | 解释                                                         |
| ------------- | ------------------------------------------------------------ |
| `no`          | （默认）无自动装配。Bean 引用必须由 `ref` 元素定义。对于较大的部署，不建议更改默认设置，因为明确指定协作者可以提供更大的控制和清晰度。在某种程度上，它记录了系统的结构。 |
| `byName`      | 按属性名称自动装配。Spring 查找与需要自动装配的属性同名的 bean。例如，如果一个 bean 定义按名称设置为autowire，并且它包含一个 `master` 属性（即，它有一个 `setMaster(..)` 方法），Spring 会查找一个名为 `master` 的 bean 定义，并使用它来设置该属性。 |
| `byType`      | 如果容器中正好存在一个属性类型的 bean，则允许自动连接属性。如果存在多个，则会引发一个致命异常，这表明您不能对该 bean 使用 `byType` 自动装配。如果没有匹配的 bean，则不会发生任何事情（未设置属性）。 |
| `constructor` | 类似于 `byType`，但适用于构造方法参数。如果容器中没有一个构造方法参数类型的 bean，则会引发致命错误。 |

使用 `byType` 或 `constructor` 自动装配模式，可以连接数组和类型化集合。在这种情况下，将提供容器中与预期类型匹配的所有自动装配候选项以满足依赖。如果预期的键类型为 `String`，则可以自动关联强类型的 `Map` 实例。自动装配的 `Map` 实例的值由匹配预期类型的所有 bean 实例组成，`Map` 实例的键包含相应的 bean 名称。

#### 自动装配的限制和缺点

自动装配在整个项目中一致使用时效果最佳。如果通常不使用自动装配，那么开发人员使用它仅连接一个或两个 bean 定义可能会感到困惑。

考虑自动装配的局限性和缺点：

- `property` 和 `constructor-arg` 设置中的显式依赖项始终覆盖自动装配。您无法自动装配简单的属性，例如基本类型、`Strings` 和 `Classes`（以及此类简单属性的数组）。这种限制是有意的。
- 自动装配不如显式装配精确。尽管如前表所示，Spring 小心地避免猜测，以防出现可能导致意外结果的歧义。Spring 托管对象之间的关系不再明确记录。
- 装配信息可能不适用于可能从 Spring 容器生成文档的工具。
- 容器中的多个 bean 定义可能与 setter 方法或构造方法参数指定的类型匹配，以进行自动装配。对于数组、集合或 `Map` 实例，这不一定是问题。然而，对于期望单个值的依赖项，这种模糊性不会被随意解决。如果不是唯一的 bean 定义可用，则抛出异常。

在后一种情况下，您有几个选项：

- 放弃自动装配，而选择显式装配。
- 如下一节所述，通过将 bean 定义的 `autowire-candidate` 属性设置为 `false` 来避免自动装配。
- 通过将 `<bean/>` 元素的 `primary` 属性设置为 `true`，将单个 bean 定义指定为主要候选。
- 通过基于注解的配置实现更细粒度的控件，如“基于注解的容器配置”中所述。

#### 从自动装配中排除 Bean

在每个 bean 的基础上，您可以将 bean 排除在自动装配之外。在 Spring 的 XML 格式中，将 `<bean/>` 元素的 `autowire-candidate` 属性设置为 `false`。容器使特定的 bean 定义不可用于自动装配基础结构（包括注解风格的配置，如`@Autowired`）。

> `autowire-candidate` 属性设计为仅影响基于类型的自动装配。它不影响按名称的显式引用，即使指定的 bean 未标记为自动装配候选，也会解析该引用。因此，如果名称匹配，则按名称自动装配仍然会注入bean。

您还可以基于与 bean 名称的模式匹配来限制自动装配候选项。顶级 `<beans/>` 元素在其 `default-autowire-candidates` 属性中接受一个或多个模式。例如，要将自动装配候选状态限制为名称以 `Repository` 结尾的任何 bean，请提供值为 `*Repository`。要提供多个模式，请在逗号分隔的列表中定义它们。bean 定义的 `autowire-candidate` 属性的显式值 `true` 或 `false` 始终优先。对于这样的bean，模式匹配规则不适用。

这些技术对于您永远不希望通过自动装配注入到其他 bean 中的 bean 非常有用。这并不意味着排除的 bean 本身不能通过使用自动装配来配置。而是指，bean 本身不是自动装配其他 bean 的候选对象。

### 1.4.6 方法注入

在大多数应用程序场景中，容器中的大多数 bean 都是单例。当单例 bean 需要与另一个单例 bean 协作或非单例 bean 需与另一非单例 bean 协作时，通常通过将一个 bean 定义为另一个 bean 的属性来处理依赖关系。当 bean 生命周期不同时，就会出现问题。假设单例 bean A 需要使用非单例（原型）bean B，可能是在 A 上的每个方法调用中。容器只创建一次单例 bean A，因此只有一次机会设置属性。容器不能在每次需要 bean B 时都为 bean A 提供 bean B 的新实例。

解决办法是放弃一些控制反转。您可以通过实现 `ApplicationContextAware` 接口，并在 bean A 每次需要时对容器进行 `getBean("B")` 调用以请求（通常是新的）bean B 实例，从而使 bean A 了解容器。以下示例显示了这种方法：

```java
// Spring-API imports

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class CommandManager implements ApplicationContextAware {

    private ApplicationContext applicationContext;

    public Object process(Map commandState) {
        // grab a new instance of the appropriate Command
        Command command = createCommand();
        // set the state on the (hopefully brand new) Command instance
        command.setState(commandState);
        return command.execute();
    }

    protected Command createCommand() {
        // notice the Spring API dependency!
        return this.applicationContext.getBean("command", Command.class);
    }

    public void setApplicationContext(
            ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }
}
```

前面的内容是不可取的，因为业务代码知道并耦合到 Spring 框架。方法注入是 Spring IoC 容器的一个稍微高级的特性，它可以让您干净地处理这个用例。

#### 查找方法注入

查找方法注入是容器重写容器管理 bean 上的方法并返回容器中另一个命名 bean 的查找结果的能力。查找通常涉及一个原型 bean，如前一节所述的场景。Spring 框架通过使用来自 CGLIB 库的字节码生成来动态生成重写该方法的子类来实现该方法注入。

> - 要使这种动态子类化工作，Spring bean 容器子类化的类不能是 `final`，要重写的方法也不能是 `final`。
> - 单元测试具有 `abstract` 方法的类需要您自己对该类进行子类化，并提供 `abstract` 方法的存根(stub)实现。
> - 组件扫描也需要具体的方法，这需要具体的类来获取。
> - 另一个关键限制是查找方法不适用于工厂方法，特别是不适用于配置类中的 `@Bean` 方法，因为在这种情况下，容器不负责创建实例，因此无法动态创建运行时生成的子类。

对于前面代码段中的 `CommandManager` 类，Spring 容器动态重写 `createCommand()` 方法的实现。`CommandManager` 类没有任何 Spring 依赖项，如重新编写的示例所示：

```java
// no more Spring imports!

public abstract class CommandManager {

    public Object process(Object commandState) {
        // grab a new instance of the appropriate Command interface
        Command command = createCommand();
        // set the state on the (hopefully brand new) Command instance
        command.setState(commandState);
        return command.execute();
    }

    // okay... but where is the implementation of this method?
    protected abstract Command createCommand();
}
```

在包含要注入的方法的客户端类（本例中为 `CommandManager`）中，要注入的方式需要以下形式的签名：

```xml
<public|protected> [abstract] <return-type> theMethodName(no-arguments);
```

如果该方法是 `abstract`，则动态生成的子类实现该方法。否则，动态生成的子类将覆盖原始类中定义的具体方法。考虑以下示例：

```xml
<!-- a stateful bean deployed as a prototype (non-singleton) -->
<bean id="myCommand" class="fiona.apple.AsyncCommand" scope="prototype">
    <!-- inject dependencies here as required -->
</bean>

<!-- commandProcessor uses statefulCommandHelper -->
<bean id="commandManager" class="fiona.apple.CommandManager">
    <lookup-method name="createCommand" bean="myCommand"/>
</bean>
```

标识为 `commandManager` 的 bean 在需要 `myCommand` bean 的新实例时调用自己的 `createCommand()` 方法。如果实际需要的话，您必须小心地将 `myCommand` bean 部署为原型。如果它是单例的，则每次都会返回 `myCommand` bean的相同实例。

或者，在基于注解的组件模型中，可以通过 `@Lookup` 注解声明查找方法，如下例所示：

```java
public abstract class CommandManager {

    public Object process(Object commandState) {
        Command command = createCommand();
        command.setState(commandState);
        return command.execute();
    }

    @Lookup("myCommand")
    protected abstract Command createCommand();
}
```

或者，更惯用地说，您可以依赖于根据查找方法的声明返回类型解析目标 bean：

```java
public abstract class CommandManager {

    public Object process(Object commandState) {
        Command command = createCommand();
        command.setState(commandState);
        return command.execute();
    }

    @Lookup
    protected abstract Command createCommand();
}
```

请注意，您通常应该使用一个具体的存根(stub)实现来声明这种带注解的查找方法，以便它们与 Spring 的组件扫描规则兼容，默认情况下抽象类会被忽略。此限制不适用于显式注册或显式导入的 bean 类。

> 访问不同作用域的目标 bean 的另一种方法是 `ObjectFactory` / `Provider` 注入点。请参阅“作为依赖项的作用域 bean”。
>
> 您还可以发现 `ServiceLocatorFactoryBean`（在 `org.springframework.beans.factory.config` 包中）很有用。

#### 任意方法替代

与查找方法注入相比，方法注入的一种不太有用的形式是能够用另一种方法实现替换托管 bean 中的任意方法。在实际需要此功能之前，您可以安全地跳过本节的其余部分。

对于基于 XML 的配置元数据，对于已部署的 bean，可以使用替换的方法元素将现有方法实现替换为另一个。考虑下面的类，它有一个我们要重写的名为 `computeValue` 的方法：

```java
public class MyValueCalculator {

    public String computeValue(String input) {
        // some real code...
    }

    // some other methods...
}
```

实现 `org.springframework.beans.factory.support.MethodReplacer` 接口的类提供了新的方法定义，如下例所示：

```java
/**
 * meant to be used to override the existing computeValue(String)
 * implementation in MyValueCalculator
 */
public class ReplacementComputeValue implements MethodReplacer {

    public Object reimplement(Object o, Method m, Object[] args) throws Throwable {
        // get the input value, work with it, and return a computed result
        String input = (String) args[0];
        ...
        return ...;
    }
}
```

部署原始类并指定方法重写的 bean 定义类似于以下示例：

```xml
<bean id="myValueCalculator" class="x.y.z.MyValueCalculator">
    <!-- arbitrary method replacement -->
    <replaced-method name="computeValue" replacer="replacementComputeValue">
        <arg-type>String</arg-type>
    </replaced-method>
</bean>

<bean id="replacementComputeValue" class="a.b.c.ReplacementComputeValue"/>
```

您可以在 `<replaced-method/>` 元素中使用一个或多个 `<arg-type/>` 元素来指示要重写的方法的方法签名。只有当方法重载并且类中存在多个变量时，参数的签名才是必需的。为方便起见，参数的类型字符串可以是完全限定类型名称的子字符串。例如，以下各项都与 `java.lang.String` 匹配：

```java
java.lang.String
String
Str
```

由于参数的数量通常足以区分每种可能的选择，因此此快捷方式只允许键入与参数类型匹配的最短字符串，可以节省大量键入。

## 1.5 Bean 作用域

当您创建 bean 定义时，您相当于创建了一个用于创建该 bean 定义所定义的类的实例的配方。bean 定义是一个配方的想法很重要，因为这意味着，与类一样，您可以从一个配方创建许多对象实例。

您不仅可以控制要插入到从特定 bean 定义创建的对象中的各种依赖项和配置值，还可以控制从特定 bean 创建的对象的作用域。这种方法功能强大且灵活，因为您可以选择通过配置创建的对象的作用域，而不必在 Java 类级别的对象作用域内烘焙。可以将 bean 定义为部署在多个作用域之一中。Spring 框架支持六个作用域，其中四个作用域只有在使用 web 感知的 ApplicationContext 时才可用。您还可以创建自定义作用域。

下表描述了支持的作用域：

| 作用域                                                       | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [singleton](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-singleton) | （默认）将一个 bean 定义作用域设为每个 Spring IoC 容器唯一的对象实例 |
| [prototype](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-prototype) | 将一个 bean 定义作用域设为任意数量对象实例。                 |
| [request](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-request) | 将一个 bean 定义限定到单个 HTTP 请求的生命周期。也就是说，每个 HTTP 请求都有自己的 bean 实例，该实例是在单个 bean 定义的基础上创建的。仅在 web 感知 Spring `ApplicationContext` 的上下文中有效。 |
| [session](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-session) | 将单个 bean 定义限定到 HTTP `Session` 的生命周期。仅在 web 感知 Spring `ApplicationContext` 的上下文中有效。 |
| [application](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-application) | 将单个 bean 定义限定到 `ServletContext` 的生命周期。仅在 web 感知 Spring `ApplicationContext` 的上下文中有效。 |
| [websocket](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#websocket-stomp-websocket-scope) | 将单个 bean 定义限定到 `WebSocket` 的生命周期。仅在 web 感知 Spring `ApplicationContext` 的上下文中有效。 |

> 从 Spring 3.0 开始，线程作用域可用，但默认情况下未注册。有关更多信息，请参阅 `SimpleThreadScope` 的文档。有关如何注册此或任何其他自定义作用域的说明，请参阅“使用自定义作用域”。

### 1.5.1 单例作用域

只有一个单独 bean 的共享实例被管理，所有对具有与该 bean 定义匹配的一个或多个 ID 的 bean 的请求都会导致 Spring 容器返回一个特定的 bean 实例。

换言之，当您定义一个 bean 定义并且它的作用域是一个单例时，Spring IoC 容器将创建该 bean 定义定义的对象的一个实例。这个单一实例存储在这样的单例 bean 的缓存中，该命名 bean 的所有后续请求和引用都返回缓存对象。

Spring 的单例 bean 的概念不同于四人帮（GoF）模式书中定义的单例模式。GoF 单例硬编码对象的作用域，使得每个 ClassLoader 只能创建一个特定类的实例。Spring 单例的作用域最好描述为每个容器和每个 bean。这意味着，如果在单个 Spring 容器中为特定类定义一个 bean，那么 Spring 容器将创建该 bean 定义所定义的类的一个且仅一个实例。singleton 作用域是 Spring 中的默认作用域。要将 bean 定义为 XML 中的单例，可以定义一个 bean，如下例所示：

```xml
<bean id="accountService" class="com.something.DefaultAccountService"/>

<!-- the following is equivalent, though redundant (singleton scope is the default) -->
<bean id="accountService" class="com.something.DefaultAccountService" scope="singleton"/>
```

### 1.5.2 原型作用域

bean 部署的非单例原型作用域使得每次请求特定 bean 时都创建一个新的 bean 实例。也就是说，bean 被注入到另一个 bean 中，或者您通过容器上的 `getBean()` 方法调用来请求它。通常，应该为所有有状态 bean 使用原型作用域，为无状态 bean 使用单例作用域。

（数据访问对象（DAO）通常不被配置为原型，因为典型的 DAO 不持有任何会话状态。我们更容易重用单例图的核心。）

以下示例将 bean 定义为 XML 中的原型：

```xml
<bean id="accountService" class="com.something.DefaultAccountService" scope="prototype"/>
```

与其他作用域不同，Spring 不管理原型 bean 的完整生命周期。容器实例化、配置和以其他方式组装原型对象，并将其交给客户程序，而不再记录该原型实例。因此，尽管对所有对象调用初始化生命周期回调方法而不考虑范围，但在原型的情况下，不会调用配置的销毁生命周期回调。客户程序代码必须清理原型范围内的对象，并释放原型 bean 所拥有的昂贵资源。要让 Spring 容器释放原型作用域 bean 所持有的资源，请尝试使用自定义 bean 后处理器，该处理器包含对需要清理的 bean 的引用。

在某些方面，Spring 容器在原型作用域 bean 中的角色是 Java `new` 操作符的替代品。超过这一点的所有生命周期管理都必须由客户程序处理。（有关 Spring 容器中 bean 的生命周期的详细信息，请参阅“生命周期回调”。）

### 1.5.3 具有原型 bean 依赖的单例 bean

当您使用依赖于原型 bean 的单例作用域 bean 时，请注意依赖关系是在实例化时解析的。因此，如果依赖项将原型作用域 bean 注入到单例作用域 bean 中，则会实例化一个新的原型 bean，然后将依赖项注入到单例 bean 中。原型实例是唯一提供给单例作用域 bean 的实例。

然而，假设您希望单例作用域 bean 在运行时重复获取原型作用域 bean 的新实例。不能将原型范围内的 bean 依赖注入到单例 bean 中，因为当 Spring 容器实例化单例 bean 并解析和注入其依赖项时，该注入只发生一次。如果您在运行时多次需要原型 bean 的新实例，请参阅“方法注入”。

### 1.5.4 请求，会话，应用和 WebSocket 作用域

