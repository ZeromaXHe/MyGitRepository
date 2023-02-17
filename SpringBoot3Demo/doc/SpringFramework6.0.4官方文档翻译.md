https://spring.io/projects/spring-framework#learn

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

`request`、`session`、`application` 和 `websocket` 作用域仅在使用 web-aware 的 Spring `ApplicationContext` 实现（如 `XmlWebApplicationContext`）时可用。如果将这些作用域与常规 Spring IoC 容器（如 `ClassPathXmlApplicationContext`）一起使用，则会引发一个 `IllegalStateException`，该异常会报未知的 bean 作用域。

#### 初始化 Web 配置

为了在 `request`, `session`, `application` 和 `websocket` 级别支持 bean 的作用域（web 作用域 bean），在定义 bean 之前需要进行一些小的初始配置。（对于标准范围：`singleton` 和 `prototype`，不需要此初始设置。）

如何完成初始设置取决于特定的 Servlet 环境。

如果在 Spring Web MVC 中访问作用域 bean，实际上，在由 Spring `DispatcherServlet` 处理的请求中，则无需进行特殊设置。`DispatcherServlet` 已公开所有相关状态。

如果使用 Servlet web 容器，请求在 Spring 的 `DispatcherServlet` 之外处理（例如，使用 JSF 时），则需要注册 `org.springframework.web.context.request.RequestContextListener` `ServletRequestListener`。这可以通过使用 `WebApplicationInitializer` 接口以编程方式完成。或者，将以下声明添加到 web 应用程序的 `web.xml` 文件中：

```xml
<web-app>
    ...
    <listener>
        <listener-class>
            org.springframework.web.context.request.RequestContextListener
        </listener-class>
    </listener>
    ...
</web-app>
```

或者，如果侦听器设置有问题，请考虑使用 Spring 的 `RequestContextFilter`。过滤器映射取决于周围的 web 应用程序配置，因此必须根据需要进行更改。以下列表显示了 web 应用程序的过滤器部分：

```xml
<web-app>
    ...
    <filter>
        <filter-name>requestContextFilter</filter-name>
        <filter-class>org.springframework.web.filter.RequestContextFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>requestContextFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
    ...
</web-app>
```

`DispatcherServlet`、`RequestContextListener` 和 `RequestContextFilter` 都执行完全相同的操作，即将 HTTP 请求对象绑定到为该请求提供服务的线程。这使得请求和会话作用域的 bean 可以在调用链的更下游使用。

#### 请求作用域

考虑 bean 定义的以下 XML 配置：

```xml
<bean id="loginAction" class="com.something.LoginAction" scope="request"/>
```

Spring 容器通过为每个 HTTP 请求使用 `loginAction` bean 定义来创建 `LoginAction` bean 的新实例。也就是说，`loginAction` bean 的作用域在 HTTP 请求级别。您可以根据需要更改创建的实例的内部状态，因为从同一 `loginAction` bean 定义创建的其他实例不会看到这些状态更改。它们是针对个人请求的。当请求完成处理时，将丢弃作用于请求的 bean。

当使用注解驱动的组件或 Java 配置时，`@RequestScope` 注解可用于将组件分配给请求作用域。以下示例显示了如何执行此操作：

```java
@RequestScope
@Component
public class LoginAction {
    // ...
}
```

#### 会话作用域

考虑 bean 定义的以下 XML 配置：

```xml
<bean id="userPreferences" class="com.something.UserPreferences" scope="session"/>
```

Spring 容器通过在单个 HTTP 会话的生命周期内使用 `userPreferences` bean 定义来创建 `UserPreferences` bean 的新实例。换句话说，`userPreferences` bean 在 HTTP `Session` 级别有效地起作用。与请求作用域 bean 一样，您可以根据需要更改创建的实例的内部状态，因为其他 HTTP `Session` 实例也在使用从同一 `userPreferences` bean 定义创建的实例，因此不会看到这些状态更改，因为它们是特定于单个 HTTP `Session` 的。当 HTTP `Session` 最终被丢弃时，作用域为该特定 HTTP `Session` 的 bean 也被丢弃。

使用注解驱动组件或 Java 配置时，可以使用 `@SessionScope` 注解将组件分配给 `session` 范围。

```java
@SessionScope
@Component
public class UserPreferences {
    // ...
}
```

#### 应用作用域

考虑 bean 定义的以下 XML 配置：

```xml
<bean id="appPreferences" class="com.something.AppPreferences" scope="application"/>
```

Spring 容器通过对整个 web 应用程序使用一次 `appPreferences` bean 定义来创建 `AppPreferences` bean 的新实例。也就是说，`appPreferences` bean 的作用域在 `ServletContext` 级别，并存储为常规 `ServletContext` 属性。这有点类似于 Spring 单例 bean，但在两个重要方面有所不同：它是每个 `ServletContext` 的单例，而不是每个Spring `ApplicationContext`（在任何给定的 web 应用程序中都可能有多个），它实际上是公开的，因此作为 `ServletContext` 属性可见。

使用注解驱动组件或 Java 配置时，可以使用 `@ApplicationScope` 注解将组件分配给 `application` 作用域。以下示例显示了如何执行此操作：

```java
@ApplicationScope
@Component
public class AppPreferences {
    // ...
}
```

#### WebSocket 作用域

WebSocket 作用域与 WebSocket 会话的生命周期相关联，并适用于 WebSocket 应用程序上的 STOMP，有关详细信息，请参阅 WebSocket 作用域。

#### 作为依赖项的作用域 bean

Spring IoC 容器不仅管理对象（bean）的实例化，还管理协作者（或依赖关系）的连接。如果您想将（例如）HTTP 请求作用域 bean 注入到另一个作用域较长的 bean 中，您可以选择注入 AOP 代理来代替作用域 bean。也就是说，您需要注入一个代理对象，该对象公开与作用域对象相同的公共接口，但也可以从相关作用域检索实际目标对象（例如 HTTP 请求），并将方法调用委托给实际对象。

> 您还可以在作用域为 `singleton` 的 bean 之间使用 `<aop:scoped-proxy/>`，然后引用经过一个可序列化的中间代理，因此可以在反序列化时重新获取目标单例 bean。
>
> 当针对 `prototype` 作用域 bean 声明 `<aop:scoped-proxy/>` 时，共享代理上的每个方法调用都会导致创建一个新的目标实例，然后将调用转发到该实例。
>
> 此外，作用域代理并不是以生命周期安全的方式从较短作用域访问 bean 的唯一方法。您还可以将注入点（即构造函数或 setter 参数或自动连线字段）声明为 `ObjectFactory<MyTargetBean>`，允许每次需要时调用 `getObject()` 来检索当前实例 — 而无需保存实例或单独存储它。
>
> 作为一个扩展变量，您可以声明 `ObjectProvider<MyTargetBean>`，它提供了几个附加的访问变量，包括 `getIfAvailable` 和 `getIfUnique`。
>
> JSR-330 变体称为 `Provider`，它与 `Provider<MyTargetBean>` 声明一起使用，每次检索尝试都会调用相应的 `get()`。有关 JSR-330 整体的更多详细信息，请参阅此处。

以下示例中的配置仅为一行，但了解其背后的“原因”和“方式”很重要：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:aop="http://www.springframework.org/schema/aop"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd">

    <!-- an HTTP Session-scoped bean exposed as a proxy -->
    <bean id="userPreferences" class="com.something.UserPreferences" scope="session">
        <!-- instructs the container to proxy the surrounding bean -->
        <aop:scoped-proxy/> (1) 这一行定义了代理
    </bean>

    <!-- a singleton-scoped bean injected with a proxy to the above bean -->
    <bean id="userService" class="com.something.SimpleUserService">
        <!-- a reference to the proxied userPreferences bean -->
        <property name="userPreferences" ref="userPreferences"/>
    </bean>
</beans>
```

要创建这样的代理，需要在作用域 bean 定义中插入一个子 `<aop:scoped-proxy/>` 元素（请参阅“选择要创建的代理类型”和“基于XMLSchema的配置”）。为什么在 `request`、`session` 和自定义作用域级别上的 bean 定义需要 `<aop:scoped-proxy/>` 元素？考虑以下单例 bean 定义，并将其与您需要为上述范围定义的内容进行对比（请注意，以下 `userPreferences` bean 定义是不完整的）：

```xml
<bean id="userPreferences" class="com.something.UserPreferences" scope="session"/>

<bean id="userManager" class="com.something.UserManager">
    <property name="userPreferences" ref="userPreferences"/>
</bean>
```

在前面的示例中，单例 bean（`userManager`）被注入了对 HTTP `Session` 作用域 bean（`userPreferences`）的引用。这里突出的一点是 `userManager` bean 是一个单例：每个容器只实例化一次，其依赖项（在本例中只有一个，`userPreferences` bean）也只注入一次。这意味着 `userManager` bean 只对完全相同的 `userPreferences` 对象（即最初注入的对象）进行操作。

当将较短生存期的作用域 bean 注入较长生存期的作用域 bean 时（例如，将 HTTP `Session` 作用域的协作 bean 作为依赖项注入单例 bean），这不是您想要的行为。相反，您需要一个 `userManager` 对象，并且对于 HTTP `Session` 的生存期，您需要特定于 HTTP `Session` 的 `userPreferences` 对象。因此，容器创建一个对象，该对象公开与 `UserPreferences` 类完全相同的公共接口（理想情况下是一个 `UserPreferences` 实例的对象），该对象可以从作用域机制（HTTP 请求、`Session` 等）获取真正的 `UserPreferences` 对象。容器将这个代理对象注入到 `userManager` bean 中，它不知道这个 `UserPreferences` 引用是一个代理。在本例中，当 `UserManager` 实例调用依赖注入的 `UserPreferences` 对象上的方法时，它实际上是在调用代理上的方法。然后，代理（在本例中）从 HTTP `Session` 获取真实的 `UserPreferences` 对象，并将方法调用委托给检索到的真实 `UserPreferences`。

因此，在将 `request` 和 `session` 作用域的 bean 注入到协作对象中时，需要以下（正确和完整的）配置，如下例所示：

```xml
<bean id="userPreferences" class="com.something.UserPreferences" scope="session">
    <aop:scoped-proxy/>
</bean>

<bean id="userManager" class="com.something.UserManager">
    <property name="userPreferences" ref="userPreferences"/>
</bean>
```

##### 选择创建的代理类型

默认情况下，当 Spring 容器为用 `<aop:scoped-proxy/>` 元素标记的 bean 创建代理时，将创建基于 CGLIB 的类代理。

> CGLIB 代理只拦截公共方法调用！不要在这样的代理上调用非公共方法。它们不会委托给实际的作用域目标对象。

或者，您可以配置 Spring 容器为此类作用域 bean 创建基于 JDK 接口的标准代理，方法是为 `<aop:scoped-proxy/>` 元素的 `proxy-target-class` 属性的值指定 `false`。使用基于 JDK 接口的代理意味着在应用程序类路径中不需要额外的库来影响此类代理。然而，这也意味着作用域 bean 的类必须实现至少一个接口，并且作用域 bean 被注入的所有协作者必须通过其接口之一引用 bean。以下示例显示了基于接口的代理：

```xml
<!-- DefaultUserPreferences implements the UserPreferences interface -->
<bean id="userPreferences" class="com.stuff.DefaultUserPreferences" scope="session">
    <aop:scoped-proxy proxy-target-class="false"/>
</bean>

<bean id="userManager" class="com.stuff.UserManager">
    <property name="userPreferences" ref="userPreferences"/>
</bean>
```

有关选择基于类或基于接口的代理的更多详细信息，请参阅代理机制。

### 1.5.5 自定义作用域

bean 作用域机制是可扩展的。您可以定义自己的作用域，甚至重新定义现有作用域，尽管后者被认为是不好的做法，您不能覆盖内置的 `singleton` 和 `prototype` 作用域。

#### 创建自定义作用域

要将自定义范围集成到 Spring 容器中，需要实现 `org.springframework.beans.factory.config.Scope` 接口，这将在本节中描述。要了解如何实现自己的作用域，请参阅 Spring Framework 本身提供的 `Scope` 实现和 `Scope` javadoc，其中更详细地解释了需要实现的方法。

`Scope` 接口有四种方法可以从作用域中获取对象，从作用域中将其删除，然后销毁它们。

例如，会话作用域实现返回会话作用域 bean（如果它不存在，则该方法在将其绑定到会话以供将来参考后返回 bean 的新实例）。以下方法从基础作用域返回对象：

```java
Object get(String name, ObjectFactory<?> objectFactory)
```

例如，会话作用域实现从基础会话中删除会话作用域 bean。应该返回该对象，但如果找不到具有指定名称的对象，则可以返回 `null`。以下方法从基础作用域中删除对象：

```java
Object remove(String name)
```

以下方法注册一个回调，当作用域被销毁或作用域中的指定对象被销毁时，作用域应调用该回调：

```java
void registerDestructionCallback(String name, Runnable destructionCallback)
```

有关销毁回调的更多信息，请参阅 javadoc 或 Spring 作用域实现。

以下方法获取基础作用域的会话标识符：

```java
String getConversationId()
```

每个作用域的标识符都不同。对于会话作用域的实现，此标识符可以是会话标识符。

#### 使用自定义作用域

编写并测试一个或多个自定义 `Scope` 实现后，需要让 Spring 容器知道新的作用域。以下方法是向 Spring 容器注册新 `Scope` 的中心方法：

```java
void registerScope(String scopeName, Scope scope);
```

此方法在 `ConfigurationBeanFactory` 接口上声明，该接口可通过 Spring 附带的大多数具体 `ApplicationContext` 实现上的 `BeanFactory` 属性获得。

`registerScope(..)` 方法的第一个参数是与作用域关联的唯一名称。Spring 容器本身中此类名称的示例是 `singleton` 和 `prototype`。`registerScope(..)` 方法的第二个参数是要注册和使用的自定义 `Scope` 实现的实际实例。

假设您编写了自定义 `Scope` 实现，然后按照下一个示例所示注册它。

> 下一个示例使用 `SimpleThreadScope`，它包含在 Spring 中，但默认情况下未注册。对于您自己的自定义 `Scope` 实现，说明将是相同的。

```java
Scope threadScope = new SimpleThreadScope();
beanFactory.registerScope("thread", threadScope);
```

然后，您可以创建符合自定义 `Scope` 的作用域规则的 bean 定义，如下所示：

```xml
<bean id="..." class="..." scope="thread">
```

使用自定义 `Scope` 实现，您不限于作用域的编程式注册。您还可以使用 `CustomScopeConfigurer` 类以声明方式进行 `Scope` 注册，如下例所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:aop="http://www.springframework.org/schema/aop"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd">

    <bean class="org.springframework.beans.factory.config.CustomScopeConfigurer">
        <property name="scopes">
            <map>
                <entry key="thread">
                    <bean class="org.springframework.context.support.SimpleThreadScope"/>
                </entry>
            </map>
        </property>
    </bean>

    <bean id="thing2" class="x.y.Thing2" scope="thread">
        <property name="name" value="Rick"/>
        <aop:scoped-proxy/>
    </bean>

    <bean id="thing1" class="x.y.Thing1">
        <property name="thing2" ref="thing2"/>
    </bean>

</beans>
```

> 当您在 `FactoryBean` 实现的 `<bean>` 声明中放置 `<aop:scoped-proxy/>` 时，作用域是工厂 bean 本身，而不是从 `getObject()` 返回的对象。

## 1.6 自定义 Bean 的性质

Spring 框架提供了许多接口，您可以使用它们来定制 bean 的性质。本节将它们分组如下：

- 生命周期回调
- `ApplicationContextAware` 和 `BeanNameAware`
- 其他 `Aware` 接口

### 1.6.1 生命周期回调

为了与容器的 bean 生命周期管理交互，可以实现 Spring `InitializingBean` 和 `DisposableBean` 接口。容器为前者调用 `afterPropertiesSet()`，为后者调用 `destroy()`，让 bean 在初始化和销毁 bean 时执行某些操作。

> JSR-250 `@PostConstruct` 和 `@PreDestroy` 注解通常被认为是在现代 Spring 应用程序中接收生命周期回调的最佳实践。使用这些注解意味着您的 bean 没有耦合到 Spring 特定的接口。有关详细信息，请参阅使用 `@PostConstruct` 和 `@PreDestroy`。
>
> 如果您不想使用 JSR-250 注解，但仍然希望消除耦合，请考虑 `init-method` 和 `destroy-method` bean 定义元数据。

在内部，Spring 框架使用 `BeanPostProcessor` 实现来处理它可以找到的任何回调接口，并调用适当的方法。如果您需要自定义特性或 Spring 默认不提供的其他生命周期行为，您可以自己实现 `BeanPostProcessor`。有关详细信息，请参见容器扩展点。

除了初始化和销毁回调之外，Spring 管理的对象还可以实现 `Lifecycle` 接口，以便这些对象可以参与容器自身生命周期驱动的启动和关闭过程。

本节介绍了生命周期回调接口。

#### 初始化回调

`org.springframework.beans.factory.InitializingBean` 接口允许 bean 在容器对 bean 设置了所有必要的属性之后执行初始化工作。`InitializingBean` 接口指定一个方法：

```java
void afterPropertiesSet() throws Exception;
```

我们建议您不要使用 `InitializingBean` 接口，因为它不必要地将代码耦合到 Spring。或者，我们建议使用 `@PostConstruct` 注解或指定 POJO 初始化方法。对于基于 XML 的配置元数据，可以使用 `init-method` 属性指定具有 void 无参数签名的方法的名称。通过 Java 配置，可以使用 `@Bean` 的 `initMethod` 属性。请参阅接收生命周期回调。考虑以下示例：

```xml
<bean id="exampleInitBean" class="examples.ExampleBean" init-method="init"/>
```

```java
public class ExampleBean {

    public void init() {
        // do some initialization work
    }
}
```

前面的示例与下面的示例（由两个列表组成）具有几乎完全相同的效果：

```xml
<bean id="exampleInitBean" class="examples.AnotherExampleBean"/>
```

```java
public class AnotherExampleBean implements InitializingBean {

    @Override
    public void afterPropertiesSet() {
        // do some initialization work
    }
}
```

然而，前面两个示例中的第一个没有将代码耦合到 Spring。

#### 销毁回调

通过实现 `org.springframework.beans.factory.DisposableBean` 接口，当包含 bean 的容器被破坏时，bean 可以获得回调。`DisposableBean` 接口指定一个方法：

```java
void destroy() throws Exception;
```

我们建议您不要使用 `DisposableBean` 回调接口，因为它不必要地将代码耦合到 Spring。或者，我们建议使用 `@PreDestroy` 注解或指定 bean 定义支持的通用方法。使用基于 XML 的配置元数据，可以在 `<bean/>` 上使用 `destroy-method` 属性。通过 Java 配置，可以使用 `@Bean` 的 `destroyMethod` 属性。请参阅接收生命周期回调。考虑以下定义：

```xml
<bean id="exampleInitBean" class="examples.ExampleBean" destroy-method="cleanup"/>
```

```java
public class ExampleBean {

    public void cleanup() {
        // do some destruction work (like releasing pooled connections)
    }
}
```

上述定义与以下定义具有几乎完全相同的效果：

```xml
<bean id="exampleInitBean" class="examples.AnotherExampleBean"/>
```

```java
public class AnotherExampleBean implements DisposableBean {

    @Override
    public void destroy() {
        // do some destruction work (like releasing pooled connections)
    }
}
```

然而，前面两个定义中的第一个没有将代码耦合到 Spring。

> 您可以为 `<bean>` 元素的 `destroy-method` 属性分配一个特殊（推断）值，该值指示 Spring 自动检测特定 bean 类上的公共 `close` 或 `shutdown` 方法。（因此，实现 `java.lang.AutoCloseable` 或 `java.io.Closable` 的任何类都会匹配。）您还可以在 `<beans>` 元素的默认 `destroy` 方法属性上设置此特殊（推断）值，以将此行为应用于整个 bean 集（请参阅默认初始化和销毁方法）。注意，这是 Java 配置的默认行为。

#### 默认初始化和销毁方法

当您编写不使用 Spring 特定 `InitializingBean` 和 `DisposableBean` 回调接口的初始化和销毁方法回调时，通常会使用 `init()`、`initialize()`、`dispose()` 等名称编写方法，此类生命周期回调方法的名称在整个项目中都是标准化的，因此所有开发人员都使用相同的方法名称并确保一致性。

您可以将 Spring 容器配置为“查找”每个 bean 上的命名初始化和销毁回调方法名称。这意味着，作为应用程序开发人员，您可以编写应用程序类并使用名为 `init()` 的初始化回调，而无需为每个 bean 定义配置 `init-method="init"` 属性。Spring IoC 容器在创建 bean 时调用该方法（并根据前面描述的标准生命周期回调契约）。该特性还为初始化和销毁方法回调强制执行一致的命名约定。

假设您的初始化回调方法名为 `init()`，而销毁回调方法名名为 `destroy()`。然后，您的类类似于以下示例中的类：

```java
public class DefaultBlogService implements BlogService {

    private BlogDao blogDao;

    public void setBlogDao(BlogDao blogDao) {
        this.blogDao = blogDao;
    }

    // this is (unsurprisingly) the initialization callback method
    public void init() {
        if (this.blogDao == null) {
            throw new IllegalStateException("The [blogDao] property must be set.");
        }
    }
}
```

然后可以在 bean 中使用该类，如下所示：

```xml
<beans default-init-method="init">

    <bean id="blogService" class="com.something.DefaultBlogService">
        <property name="blogDao" ref="blogDao" />
    </bean>

</beans>
```

顶级 `<beans/>` 元素属性上存在 `default-init-method` 属性，导致 Spring IoC 容器将 bean 类上名为 `init` 的方法识别为初始化方法回调。当创建和组装 bean 时，如果 bean 类有这样的方法，则会在适当的时候调用它。

通过使用顶级 `<beans/>` 元素上的 `default-destroy-method` 属性，可以类似地（即在 XML 中）配置销毁方法回调。

如果现有的 bean 类已经具有与约定不同的回调方法，则可以通过使用 `<bean/>` 本身的 `init-method` 和 `destroy-method` 属性来指定（在 XML 中）方法名，从而覆盖默认值。

Spring 容器保证在为 bean 提供所有依赖项后立即调用配置的初始化回调。因此，对原始 bean 引用调用初始化回调，这意味着 AOP 拦截器等尚未应用于 bean。首先完全创建目标 bean，然后应用 AOP 代理（例如）及其拦截器链。如果目标 bean 和代理是单独定义的，那么代码甚至可以绕过代理与原始目标 bean 交互。因此，将拦截器应用于 `init` 方法是不一致的，因为这样做会将目标 bean 的生命周期耦合到其代理或拦截器，并在代码直接与原始目标 bean 交互时留下奇怪的语义。

#### 组合生命周期机制

对于 Spring 2.5，你有三种控制 bean 生命周期行为的选择：

- `InitializingBean` 和 `DisposableBean` 回调接口
- 自定义 `init()` 和 `destroy()` 方法
- `@PostConstruct` 和 `@PreDestroy` 注解。你可以组合这些机制来控制一个指定 bean。

> 如果为一个 bean 配置了多个生命周期机制，并且每个机制都配置了不同的方法名，那么每个配置的方法都会按照本说明后面列出的顺序运行。但是，如果配置了相同的方法名——例如，`init()` 用于初始化方法——对于这些生命周期机制中的多个，该方法运行一次，如前一节所述。

为同一个bean配置的多个生命周期机制，使用不同的初始化方法，调用如下：

- 用 `@PostConstruct` 注解的方法
- `InitializingBean` 回调接口定义的 `afterPropertiesSet()`
- 自定义配置的 `init()` 方法

销毁方法的调用顺序相同：

- 用 `@PreDestroy` 注解的方法
- `destroy()`，由 `DisposableBean` 回调接口定义
- 自定义配置的 `destroy()` 方法

#### 启动和关闭调用

`Lifecycle` 接口定义了具有自己生命周期要求的任何对象的基本方法（例如启动和停止某些后台进程）：

```java
public interface Lifecycle {

    void start();

    void stop();

    boolean isRunning();
}
```

任何 Spring 管理的对象都可以实现 `Lifecycle` 接口。然后，当 `ApplicationContext` 本身接收到启动和停止信号（例如，对于运行时的停止/重启场景）时，它将这些调用级联到该上下文中定义的所有 `Lifecycle` 实现。它通过委托给 `LifecycleProcessor` 来实现这一点，如以下列表所示：

```java
public interface LifecycleProcessor extends Lifecycle {

    void onRefresh();

    void onClose();
}
```

请注意，`LifecycleProcessor` 本身是 `Lifecycle` 接口的扩展。它还添加了两种其他方法，用于对正在刷新和关闭的上下文做出反应。

> 请注意，常规 `org.springframework.context.Lifecycle` 接口是用于显式启动和停止通知的普通约定，并不意味着在上下文刷新时自动启动。要对特定 bean 的自动启动进行细粒度控制（包括启动阶段），请考虑实现 `org.springframework.context.SmartLifecycle`。
>
> 此外，请注意，不保证在销毁之前发出停止通知。在常规关闭时，所有 `Lifecycle` bean 在传播常规销毁回调之前首先收到停止通知。但是，在上下文生存期内的热刷新或停止刷新尝试时，只调用销毁方法。

启动和关闭调用的顺序可能很重要。如果任何两个对象之间存在“依赖于”关系，则依赖方在其依赖关系之后开始，而在其依赖之前停止。然而，有时，直接依赖关系是未知的。您可能只知道某种类型的对象应该先于另一种类型的对象开始。在这些情况下，`SmartLifecycle` 接口定义了另一个选项，即在其超接口 `Phased` 上定义的 `getPhase()` 方法。以下列表显示了 `Phased` 接口的定义：

```java
public interface Phased {

    int getPhase();
}
```

以下列表显示了 `SmartLifecycle` 界面的定义：

```java
public interface SmartLifecycle extends Lifecycle, Phased {

    boolean isAutoStartup();

    void stop(Runnable callback);
}
```

启动时，具有最低相位的对象首先启动。停止时，遵循相反的顺序。因此，实现 `SmartLifecycle` 并且其 `getPhase()` 方法返回 `Integer.MIN_VALUE` 的对象将是第一个启动和最后一个停止的对象。在频谱的另一端，`Integer.MAX_VALUE` 的相位值将指示对象应该最后启动，然后首先停止（可能是因为它取决于要运行的其他进程）。在考虑阶段值时，还必须知道任何未实现 `SmartLifecycle` 的“正常” `Lifecycle` 对象的默认阶段为 `0`。因此，任何负相位值都表示对象应该在这些标准组件之前开始（并在它们之后停止）。任何正相位值都是相反的。

`SmartLifecycle` 定义的停止方法接受回调。任何实现都必须在该实现的关闭过程完成后调用该回调的 `run()` 方法。这将在必要时启用异步关闭，因为 `LifecycleProcessor` 接口的默认实现 `DefaultLifecyclePprocessor` 将等待每个阶段中的一组对象调用该回调，直到其超时值。每个阶段的默认超时为 30 秒。您可以通过在上下文中定义名为 `lifecycleProcessor` 的 bean 来覆盖默认的生命周期处理器实例。如果只想修改超时，定义以下内容就足够了：

```xml
<bean id="lifecycleProcessor" class="org.springframework.context.support.DefaultLifecycleProcessor">
    <!-- timeout value in milliseconds -->
    <property name="timeoutPerShutdownPhase" value="10000"/>
</bean>
```

如前所述，`LifecycleProcessor` 接口还定义了用于刷新和关闭上下文的回调方法。后者驱动关机进程，就像显式调用了 `stop()` 一样，但它在上下文关闭时发生。另一方面，“刷新”回调启用了 `SmartLifecycle` bean 的另一个功能。当上下文被刷新时（在所有对象被实例化和初始化之后），回调被调用。此时，默认生命周期处理器检查每个 `SmartLifecycle` 对象的 `isAutoStartup()` 方法返回的布尔值。如果为 `true`，则该对象在此时启动，而不是等待上下文或其自身的 `start()` 方法的显式调用（与上下文刷新不同，对于标准上下文实现，上下文启动不会自动发生）。`phase` 值和任何“取决于”关系决定了前面所述的启动顺序。

#### 在非 Web 应用中优雅地关闭 Spring IoC 容器

> 本节仅适用于非 web 应用程序。Spring 的基于 web 的 ApplicationContext 实现已经有代码，可以在相关 web 应用程序关闭时优雅地关闭 Spring IoC 容器。

如果在非 web 应用程序环境中使用 Spring 的 IoC 容器（例如，在富客户端桌面环境中），请向 JVM 注册一个关闭挂钩。这样做可以确保正常关闭，并调用单例 bean 上的相关销毁方法，从而释放所有资源。您仍然必须正确配置和实现这些销毁回调。

要注册关机钩子，请调用在 `ConfigurationApplicationContext` 接口上声明的 `registerShutdownHook()` 方法，如下例所示：

```java
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public final class Boot {

    public static void main(final String[] args) throws Exception {
        ConfigurableApplicationContext ctx = new ClassPathXmlApplicationContext("beans.xml");

        // add a shutdown hook for the above context...
        ctx.registerShutdownHook();

        // app runs here...

        // main method exits, hook is called prior to the app shutting down...
    }
}
```

### 1.6.2 ApplicationContextAware 和 BeanNameAware

当 `ApplicationContext` 创建一个实现 `org.springframework.context.ApplicationContextAware` 接口的对象实例时，将为该实例提供对该 `ApplicationContext` 的引用。以下列表显示 `ApplicationContextAware` 接口的定义：

```java
public interface ApplicationContextAware {

    void setApplicationContext(ApplicationContext applicationContext) throws BeansException;
}
```

因此，bean 可以通过 `ApplicationContext` 接口或通过将引用强制转换为该接口的已知子类（例如可配置的 `ApplicationContext`，它公开了附加功能），以编程方式操作创建它们的 `ApplicationContext`。一种用途是对其他 bean 进行编程检索。有时这种能力很有用。然而，一般来说，您应该避免使用它，因为它将代码耦合到 Spring，并且不遵循控制反转样式，即协作者作为属性提供给 bean。`ApplicationContext` 的其他方法提供对文件资源的访问、应用程序事件的发布和 `MessageSource` 的访问。`ApplicationContext` 的附加功能中描述了这些附加功能。

自动装配是获取 `ApplicationContext` 引用的另一种选择。传统的 `constructor` 和 `byType` 自动装配模式（如自动装配协助者中所述）可以分别为构造函数参数或 setter 方法参数提供 `ApplicationContext` 类型的依赖关系。要获得更大的灵活性，包括自动装配字段和多参数方法的能力，请使用基于注解的自动装配功能。如果这样做，`ApplicationContext` 将自动装配到需要 `ApplicationContext` 类型的字段、构造函数参数或方法参数中，如果所讨论的字段、构造器或方法带有 `@Autowired` 注解。有关详细信息，请参阅使用 `@Autowired`。

当 `ApplicationContext` 创建一个实现 `org.springframework.beans.factory.BeanNameAware` 接口的类时，将为该类提供对其关联对象定义中定义的名称的引用。以下列表显示了 BeanNameAware 接口的定义：

```java
public interface BeanNameAware {

    void setBeanName(String name) throws BeansException;
}
```

回调的调用在填充普通 bean 属性之后，但在初始化回调（如 `InitializingBean.afterPropertiesSet()` 或自定义 init-method）之前。

### 1.6.3 其他 Aware 接口

除了 `ApplicationContextAware` 和 `BeanNameAware`（前面讨论过）之外，Spring 还提供了一系列 `Aware` 回调接口，让 bean 向容器指示它们需要某种基础结构依赖性。通常，名称表示依赖关系类型。下表总结了最重要的 `Aware` 接口：

| 名字                             | 注入依赖                                                     | 在哪一节解释                                                 |
| :------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `ApplicationContextAware`        | 声明 `ApplicationContext`.                                   | [`ApplicationContextAware` 和`BeanNameAware`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-aware) |
| `ApplicationEventPublisherAware` | 包裹 `ApplicationContext` 的事件发布器                       | [`ApplicationContext` 的附加功能](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#context-introduction) |
| `BeanClassLoaderAware`           | 用于加载 bean 类的类加载器                                   | [实例化 Beans](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-class) |
| `BeanFactoryAware`               | 声明 `BeanFactory`.                                          | [`BeanFactory` API](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-beanfactory) |
| `BeanNameAware`                  | 声明 bean 的名字                                             | [`ApplicationContextAware` 和 `BeanNameAware`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-aware) |
| `LoadTimeWeaverAware`            | 为载入期运行类定义而定义的织入器                             | [在 Spring 框架中使用 AspectJ 进行载入时织入](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-aj-ltw) |
| `MessageSourceAware`             | 解析信息的配置策略（支持参数化和国际化）                     | [`ApplicationContext` 的附加功能](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#context-introduction) |
| `NotificationPublisherAware`     | Spring JMX 通知发布器                                        | [通知](https://docs.spring.io/spring-framework/docs/current/reference/html/integration.html#jmx-notifications) |
| `ResourceLoaderAware`            | 为低级别访问资源配置了加载器                                 | [资源](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#resources) |
| `ServletConfigAware`             | 当前运行容器的 `ServletConfig`。仅在支持 web 的Spring `ApplicationContext` 中有效。 | [Spring MVC](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc) |
| `ServletContextAware`            | 容器运行的当前 `ServletContext`。仅在支持 web 的 Spring `ApplicationContext` 中有效。 | [Spring MVC](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc) |

再次注意，使用这些接口将代码绑定到 Spring API，并且不遵循控制反转样式。因此，我们建议将它们用于需要对容器进行编程访问的基础结构 bean。

## 1.7 Bean 定义继承

bean 定义可以包含大量配置信息，包括构造函数参数、属性值和容器特定信息，例如初始化方法、静态工厂方法名称等。子 bean 定义从父定义继承配置数据。子定义可以根据需要覆盖某些值或添加其他值。使用父 bean 和子 bean 定义可以节省很多类型。实际上，这是一种模板形式。

如果以编程方式使用 `ApplicationContext` 接口，则 `ChildBeanDefinition` 类表示子 bean 定义。大多数用户不在这个级别上与他们合作。相反，它们在类（如 `ClassPathXmlApplicationContext`）中以声明方式配置 bean 定义。当您使用基于 XML 的配置元数据时，可以通过使用 `parent` 属性来指示子 bean 定义，并将父 bean 指定为该属性的值。以下示例显示了如何执行此操作：

```xml
<bean id="inheritedTestBean" abstract="true"
        class="org.springframework.beans.TestBean">
    <property name="name" value="parent"/>
    <property name="age" value="1"/>
</bean>

<bean id="inheritsWithDifferentClass"
        class="org.springframework.beans.DerivedTestBean"
        parent="inheritedTestBean" init-method="initialize">  (1)
    <property name="name" value="override"/>
    <!-- the age property value of 1 will be inherited from parent -->
</bean>
```

如果未指定，则子 bean 定义使用父定义中的 bean 类，但也可以重写它。在后一种情况下，子 bean 类必须与父类兼容（即，它必须接受父类的属性值）。

子 bean 定义从父 bean 继承范围、构造函数参数值、属性值和方法重写，并具有添加新值的选项。指定的任何范围、初始化方法、销毁方法或 `static` 工厂方法设置都将覆盖相应的父设置。

其余的设置始终取自子定义：依赖于、自动装配模式、依赖项检查、单例和懒加载。

前面的示例通过使用 `abstract` 属性显式地将父 bean 定义标记为抽象。如果父定义未指定类，则需要将父 bean 定义显式标记为 `abstract`，如下例所示：

```xml
<bean id="inheritedTestBeanWithoutClass" abstract="true">
    <property name="name" value="parent"/>
    <property name="age" value="1"/>
</bean>

<bean id="inheritsWithClass" class="org.springframework.beans.DerivedTestBean"
        parent="inheritedTestBeanWithoutClass" init-method="initialize">
    <property name="name" value="override"/>
    <!-- age will inherit the value of 1 from the parent bean definition-->
</bean>
```

父 bean 不能单独实例化，因为它是不完整的，而且它也被显式标记为 `abstract`。当一个定义是 `abstract` 的时，它只能作为一个纯模板 bean 定义使用，作为子定义的父定义。尝试单独使用这样一个 `abstract` 的父 bean，通过将其引用为另一个 bean 的 ref 属性或使用父 bean ID 执行显式 `getBean()` 调用，会返回错误。类似地，容器的内部 `preInstantiateSingletons()` 方法忽略定义为抽象的 bean 定义。

> 默认情况下，`ApplicationContext` 预实例化所有单例。因此，重要的是（至少对于单例 bean 来说），如果您有一个（父）bean 定义，您打算将其仅用作模板，并且该定义指定了一个类，则必须确保将 abstract 属性设置为 true，否则应用程序上下文将实际（尝试）预实例化 `abstract` bean。

## 1.8 容器扩展点

通常，应用程序开发人员不需要对 `ApplicationContext` 实现类进行子类化。相反，Spring IoC 容器可以通过插入特殊集成接口的实现来扩展。接下来的几节将描述这些集成接口。

### 1.8.1 通过使用 BeanPostProcessor 来自定义 Bean

`BeanPostProcessor` 接口定义了回调方法，您可以实现这些方法来提供自己的（或覆盖容器的默认）实例化逻辑、依赖关系解析逻辑等。如果您想在 Spring 容器完成实例化、配置和初始化 bean 之后实现一些自定义逻辑，可以插入一个或多个自定义 `BeanPostProcessor` 实现。

您可以配置多个 `BeanPostProcessor` 实例，并且可以通过设置 `order` 属性来控制这些 `BeanPostProcessor` 实例的运行顺序。只有当 `BeanPostProcessor` 实现 `Ordered` 接口时，才能设置此属性。如果您编写自己的 `BeanPostProcessor`，也应该考虑实现 `Ordered` 接口。有关详细信息，请参阅 `BeanPostProcessor` 和 `Ordered` 接口的 javadoc。另请参阅有关 `BeanPostProcessor` 实例的编程注册的说明。

> `BeanPostProcessor` 实例在 bean（或对象）实例上运行。也就是说，Spring IoC 容器实例化一个 bean 实例，然后 `BeanPostProcessor` 实例完成它们的工作。
>
> `BeanPostProcessor` 实例的作用域是每个容器。这仅在使用容器层次结构时才相关。如果您在一个容器中定义了 `BeanPostProcessor`，它将只对该容器中的 bean 进行后期处理。换句话说，在一个容器中定义的 bean 不会被另一个容器定义的 `BeanPostProcessor` 进行后处理，即使两个容器都是同一层次结构的一部分。
>
> 要更改实际的 bean 定义（即定义 bean 的蓝图），您需要使用 `BeanFactoryPostProcessor`，如使用 `BeanFactoryPostProcessor` 自定义配置元数据中所述。

`org.springframework.beans.factory.config.BeanPostProcessor` 接口正好由两个回调方法组成。当这样的类在容器中注册为后处理器时，对于容器创建的每个 bean 实例，后处理器在调用容器初始化方法（例如 `InitializingBean.afterPropertiesSet()` 或任何声明的 `init` 方法）之前和任何 bean 初始化回调之后都会从容器获得回调。后处理器可以对 bean 实例执行任何操作，包括完全忽略回调。bean 后处理器通常检查回调接口，或者它可以用代理包装 bean。为了提供代理包装逻辑，一些 Spring AOP 基础设施类被实现为 bean 后处理器。

`ApplicationContext` 自动检测在实现 `BeanPostProcessor` 接口的配置元数据中定义的任何 bean。`ApplicationContext` 将这些 bean 注册为后处理器，以便稍后在创建 bean 时调用它们。Bean 后处理器可以以与任何其他 Bean 相同的方式部署在容器中。

注意，当在配置类上使用 `@Bean` 工厂方法声明 `BeanPostProcessor` 时，工厂方法的返回类型应该是实现类本身，或者至少是 `org.springframework.beans.factory.config.BeanPostProcessor` 接口，清楚地指示该 Bean 的后处理器性质。否则，`ApplicationContext` 在完全创建之前无法按类型自动检测它。由于 `BeanPostProcessor` 需要尽早实例化，以便应用于上下文中其他 bean 的初始化，因此这种早期类型检测至关重要。

>**以编程方式注册 BeanPostProcessor 实例**
>
>虽然推荐的 `BeanPostProcessor` 注册方法是通过 `ApplicationContext` 自动检测（如前所述），但您可以使用 `addBeanPostProcessor` 方法以编程方式将它们注册到 `ConfigurableBeanFactory` 中。当您需要在注册之前评估条件逻辑，甚至需要在层次结构中跨上下文复制 bean 后处理器时，这可能非常有用。然而，请注意，以编程方式添加的 `BeanPostProcessor` 实例不遵循 `Ordered` 接口。这里，登记的顺序决定了执行的顺序。还要注意，以编程方式注册的 `BeanPostProcessor` 实例总是在通过自动检测注册的实例之前进行处理，而不考虑任何显式排序。

> **BeanPostProcessor 实例和 AOP 自动代理**
>
> 实现 `BeanPostProcessor` 接口的类是特殊的，容器对它们的处理不同。所有 `BeanPostProcessor` 实例和它们直接引用的 bean 都在启动时实例化，作为 `ApplicationContext` 的特殊启动阶段的一部分。接下来，所有 `BeanPostProcessor` 实例都以排序方式注册，并应用于容器中的所有其他 bean。因为 AOP 自动代理是作为 `BeanPostProcessor` 本身实现的，所以无论是 `BeanPostProcessor` 实例还是它们直接引用的 bean 都不符合自动代理的条件，因此，它们中没有切面。
>
> 对于任何这样的 bean，您都应该看到一条信息日志消息：`Bean someBean is not eligible for getting processed by all BeanPostProcessor interfaces (for example: not eligible for auto-proxying)`。
>
> 如果您使用自动装配或 `@Resource` 将 bean 装配到 `BeanPostProcessor` 中（这可能会返回到自动装配），Spring 可能会在搜索类型匹配依赖候选项时访问意外的 bean，因此，使它们不适合自动代理或其他类型的 bean 后处理。例如，如果您有一个用 `@Resource` 注解的依赖项，其中字段或 setter 名称与 bean 的声明名称不直接对应，并且没有使用 name 属性，则 Spring 会访问其他 bean 以按类型匹配它们。

下面例子展示了怎么在 `ApplicationContext` 中写，注册和使用 `BeanPostProcessor` 实例。

#### 例子：BeanPostProcessor 式的 Hello World

第一个示例说明了基本用法。该示例显示了一个自定义 `BeanPostProcessor` 实现，它在容器创建每个 bean 时调用该 bean 的 `toString()` 方法，并将生成的字符串打印到系统控制台。

以下列表显示了自定义 `BeanPostProcessor` 实现类定义：

```java
import org.springframework.beans.factory.config.BeanPostProcessor;

public class InstantiationTracingBeanPostProcessor implements BeanPostProcessor {

    // simply return the instantiated bean as-is
    public Object postProcessBeforeInitialization(Object bean, String beanName) {
        return bean; // we could potentially return any object reference here...
    }

    public Object postProcessAfterInitialization(Object bean, String beanName) {
        System.out.println("Bean '" + beanName + "' created : " + bean.toString());
        return bean;
    }
}
```

下面的 `beans` 元素使用 `InstantiationTracingBeanPostProcessor`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:lang="http://www.springframework.org/schema/lang"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/lang
        https://www.springframework.org/schema/lang/spring-lang.xsd">

    <lang:groovy id="messenger"
            script-source="classpath:org/springframework/scripting/groovy/Messenger.groovy">
        <lang:property name="message" value="Fiona Apple Is Just So Dreamy."/>
    </lang:groovy>

    <!--
    when the above bean (messenger) is instantiated, this custom
    BeanPostProcessor implementation will output the fact to the system console
    -->
    <bean class="scripting.InstantiationTracingBeanPostProcessor"/>

</beans>
```

注意 `InstantiationTracingBeanPostProcessor` 是如何定义的。它甚至没有名字，因为它是一个 bean，所以可以像其他 bean 一样进行依赖注入。（前面的配置还定义了一个由 Groovy 脚本支持的 bean。Spring 动态语言支持在标题为“动态语言支持”的章节中详细介绍。）

以下 Java 应用程序运行上述代码和配置：

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.scripting.Messenger;

public final class Boot {

    public static void main(final String[] args) throws Exception {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("scripting/beans.xml");
        Messenger messenger = ctx.getBean("messenger", Messenger.class);
        System.out.println(messenger);
    }

}
```

前面应用案例的输出如下：

```
Bean 'messenger' created : org.springframework.scripting.groovy.GroovyMessenger@272961
org.springframework.scripting.groovy.GroovyMessenger@272961
```

#### 例子：AutowiredAnnotationBeanPostProcessor

结合自定义 `BeanPostProcessor` 实现使用回调接口或注解是扩展 Spring IoC 容器的常用方法。一个例子是 Spring 的 `AutowiredAnnotationBeanPostProcessor`——一个附带 Spring 发行版和 autowire 注解字段、setter 方法和任意配置方法的 `BeanPostProcessor` 实现。

### 1.8.2 使用 BeanFactoryPostProcessor 自定义配置元数据

我们看到的下一个扩展点是 `org.springframework.beans.factory.config.BeanFactoryPostProcessor`。此接口的语义与 `BeanPostProcessor` 的语义相似，但有一个主要区别：`BeanFactoryPostProcesser` 对 bean 配置元数据进行操作。也就是说，Spring IoC 容器允许 `BeanFactoryPostProcessor` 读取配置元数据，并可能在容器实例化 `BeanFactoryPostProcessor` 实例之外的任何 bean 之前对其进行更改。

您可以配置多个 `BeanFactoryPostProcessor` 实例，并且可以通过设置 `order` 属性来控制这些 `BeanFactoryPost Processor` 实例的运行顺序。但是，只有当 `BeanFactoryPostProcessor` 实现 `Ordered` 接口时，才能设置此属性。如果您编写自己的 `BeanFactoryPostProcessor`，也应该考虑实现 `Ordered` 接口。有关详细信息，请参阅 `BeanFactoryPostProcessor` 和 `Ordered` 接口的 javadoc。

> 如果您想更改实际的 bean 实例（即，从配置元数据创建的对象），那么您需要使用 `BeanPostProcessor`（前面在使用 `BeanPostProcesser` 自定义 bean 中描述）。虽然在技术上可以在 `BeanFactoryPostProcessor` 中使用 bean 实例（例如，通过使用 `BeanFactory.getBean()`），但这样做会导致过早的 bean 实例化，违反标准容器生命周期。这可能会导致负面的副作用，例如绕过 bean 后处理。
>
> 此外，`BeanFactoryPostProcessor` 实例的作用域是每个容器。这仅在使用容器层次结构时相关。如果在一个容器中定义了 `BeanFactoryPostProcessor`，那么它只应用于该容器中的 bean 定义。一个容器中的 Bean 定义不会由另一个容器的 `BeanFactoryPostProcessor` 实例进行后处理，即使两个容器都是同一层次结构的一部分。

当在 `ApplicationContext` 中声明 bean 工厂后处理器时，它会自动运行，以便将更改应用于定义容器的配置元数据。Spring 包括许多预定义的 bean 工厂后处理器，如 `PropertyOverrideConfigurer` 和 `PropertySourcesPlaceholderConfigurator`。您还可以使用自定义 `BeanFactoryPostProcessor`——例如注册自定义属性编辑器。

`ApplicationContext` 自动检测部署到其中的实现 `BeanFactoryPostProcessor` 接口的任何 bean。它在适当的时候使用这些 bean 作为 bean 工厂后处理器。您可以像部署任何其他 bean 一样部署这些后处理器 bean。

> 与 `BeanPostProcessors` 一样，您通常不希望为延迟初始化配置 `BeanFactoryPostProcessor` 们。如果没有其他 bean 引用 `Bean(Factory)PostProcessor`，则该后处理器根本不会被实例化。因此，将其标记为惰性初始化将被忽略，并且即使在 `<beans/>` 元素的声明中将 `default-lazy-init` 属性设置为 `true`，`Bean(Factory)PostProcessor` 也会被急切地实例化。

#### 例子：类名替换 PropertySourcePlaceholderConfigurer

您可以使用 `PropertySourcesPlaceholderConfigurer`，通过使用标准的 Java `Properties` 格式，将 bean 定义中的属性值外部化到单独的文件中。这样做可以让部署应用程序的人员自定义特定于环境的属性，如数据库 URL 和密码，而不会复杂或有修改容器的主 XML 定义文件的风险。

考虑以下基于 XML 的配置元数据片段，其中定义了具有占位符值的 `DataSource`：

```xml
<bean class="org.springframework.context.support.PropertySourcesPlaceholderConfigurer">
    <property name="locations" value="classpath:com/something/jdbc.properties"/>
</bean>

<bean id="dataSource" destroy-method="close"
        class="org.apache.commons.dbcp.BasicDataSource">
    <property name="driverClassName" value="${jdbc.driverClassName}"/>
    <property name="url" value="${jdbc.url}"/>
    <property name="username" value="${jdbc.username}"/>
    <property name="password" value="${jdbc.password}"/>
</bean>
```

该示例显示了从外部 `Properties` 文件配置的属性。在运行时，将 `PropertySourcesPlaceholderConfigurer` 应用于元数据，以替换 DataSource 的某些属性。要替换的值被指定为 `${property-name}` 形式的占位符，它遵循Ant、log4j 和 JSP EL 样式。

实际值来自另一个标准 Java `Properties` 格式的文件：

```properties
jdbc.driverClassName=org.hsqldb.jdbcDriver
jdbc.url=jdbc:hsqldb:hsql://production:9002
jdbc.username=sa
jdbc.password=root
```

因此，`${jdbc.username}` 字符串在运行时被替换为值“sa”，这同样适用于与财产文件中的键匹配的其他占位符值。`PropertySourcesPlaceholderConfigurer` 检查 bean 定义的大多数属性和属性中的占位符。此外，您还可以自定义占位符前缀和后缀。

使用 Spring 2.5 中引入的 `context` 命名空间，您可以使用专用的配置元素配置属性占位符。您可以在 `location` 属性中以逗号分隔的列表形式提供一个或多个位置，如下例所示：

```xml
<context:property-placeholder location="classpath:com/something/jdbc.properties"/>
```

`PropertySourcesPlaceholderConfigurer` 不仅在指定的 `Properties` 文件中查找属性。默认情况下，如果在指定的属性文件中找不到属性，则会检查 Spring `Environment` 属性和常规 Java `System` 属性。

> 您可以使用 `PropertySourcesPlaceholderConfigurer` 替换类名，这在运行时必须选择特定的实现类时有时很有用。以下示例显示了如何执行此操作：
>
> ```xml
> <bean class="org.springframework.beans.factory.config.PropertySourcesPlaceholderConfigurer">
>     <property name="locations">
>         <value>classpath:com/something/strategy.properties</value>
>     </property>
>     <property name="properties">
>         <value>custom.strategy.class=com.something.DefaultStrategy</value>
>     </property>
> </bean>
> 
> <bean id="serviceStrategy" class="${custom.strategy.class}"/>
> ```
>
> 如果无法在运行时将类解析为有效类，则在将要创建 bean 时，即在非惰性初始化 bean 的 `ApplicationContext` 的 `preInstantiateSingletons()` 阶段，bean 的解析将失败。

#### 例子：PropertyOverrideConfigurer

另一个 bean 工厂后处理器 `PropertyOverrideConfigurer` 类似于 `PropertySourcesPlaceholderConfigurer`，但与后者不同的是，原始定义可以具有 bean 属性的默认值，也可以根本没有值。如果覆盖的 `Properties` 文件没有特定 bean 属性的条目，则使用默认上下文定义。

请注意，bean 定义不知道被覆盖，因此从 XML 定义文件中无法立即看出正在使用覆盖配置器。如果多个 `PropertyOverrideConfigurer` 实例为同一 bean 属性定义了不同的值，则由于重写机制，最后一个实例获胜。

属性文件配置行采用以下格式：

```properties
beanName.property=value
```

下列展示了格式的示例：

```properties
dataSource.driverClassName=com.mysql.jdbc.Driver
dataSource.url=jdbc:mysql:mydb
```

这个示例文件可以与包含名为 `dataSource` 的 bean 的容器定义一起使用，该 bean 具有 `driver` 和 `url` 属性。

也支持复合属性名，只要路径的每个组件（除了要重写的最终属性）都已非空（可能由构造函数初始化）。在以下示例中，`tom` bean的 `fred` 属性的 `bob` 属性的 `sammy` 属性设置为标量值 `123`：

```properties
tom.fred.bob.sammy=123
```

> 指定的重写值始终是文字值。它们不会转换为 bean 引用。当 XML bean 定义中的原始值指定 bean 引用时，该约定也适用。

使用 Spring 2.5 中引入的上下文命名空间，可以使用专用配置元素配置属性重写，如下例所示：

```xml
<context:property-override location="classpath:override.properties"/>
```

### 1.8.3 使用 FactoryBean 自定义初始化逻辑

您可以为本身为工厂的对象实现 `org.springframework.beans.factory.FactoryBean` 接口。

`FactoryBean` 接口是 Spring IoC 容器实例化逻辑的一个可插入点。如果您有复杂的初始化代码，而不是（潜在的）冗长的 XML，那么您可以创建自己的 `FactoryBean`，在该类中编写复杂的初始化，然后将自定义 `FactoryBean` 插入到容器中。

`FactoryBean<T>` 接口提供三种方法：

- `T getObject()`：返回此工厂创建的对象的实例。该实例可能是共享的，这取决于该工厂返回的是单件还是原型。
- `boolean isSingleton()`：如果此 `FactoryBean` 返回单例，则返回`true`，否则返回 `false`。此方法的默认实现返回 `true`。
- `Class<?> getObjectType()`：返回 `getObject()` 方法返回的对象类型，如果事先不知道类型，则返回 `null`。

`FactoryBean` 概念和接口在 Spring 框架中的许多地方使用。`FactoryBean` 接口的 50 多个实现与 Spring 本身一起提供。

当您需要向容器请求实际的 `FactoryBean` 实例本身而不是它生成的 bean 时，在调用 `ApplicationContext` 的 `getBean()` 方法时，在 bean 的 `id` 前面加上 `&` 符号。因此，对于 `id` 为 `myBean` 的给定 `FactoryBean`，在容器上调用 `getBean("myBean")` 将返回 `FactoryBean` 的产品，而调用 `getBean("&myBean")` 将返回 `FactoryBean` 实例本身。

## 1.9 基于注解的容器配置

> **对于配置 Spring 来说，注解是否比 XML 好？**
>
> 基于注解的配置的引入提出了一个问题，即这种方法是否比 XML “更好”。简短的回答是“看情况”。长期的回答是，每种方法都有其利弊，通常由开发人员决定哪种策略更适合他们。由于它们的定义方式，注解在其声明中提供了大量上下文，从而导致了更短、更简洁的配置。然而，XML擅长在不接触源代码或重新编译组件的情况下连接组件。一些开发人员倾向于靠近源代码进行装配，而另一些开发人员则认为带注解的类不再是POJO，而且配置变得分散，更难控制。
>
> 无论是哪种选择，Spring 都可以容纳这两种风格，甚至可以将它们混合在一起。值得指出的是，通过其 JavaConfig 选项，Spring 允许以非侵入性的方式使用注解，而不接触目标组件源代码，而且在工具方面，Spring Tools for Eclipse 支持所有配置样式。

XML 设置的另一种选择是基于注解的配置，它依赖字节码元数据来连接组件，而不是使用尖括号声明。开发人员不使用 XML 来描述 bean 装配，而是通过在相关类、方法或字段声明上使用注解将配置移动到组件类本身中。如“示例：AutowiredAnnotationBeanPostProcessor” 中所述，将 `BeanPostProcessor` 与注解结合使用是扩展 Spring IoC 容器的常用方法。例如，Spring 2.5 引入了一种基于注解的方法来驱动 Spring 的依赖注入。本质上，`@Autowired` 注解提供了与“自动装配协作者”中描述的功能相同的功能，但具有更细粒度的控制和更广泛的适用性。Spring 2.5 还添加了对 JSR-250 注解的支持，例如 `@PostConstruct` 和 `@PreDestroy`。Spring 3.0 添加了对 `jakarta.inject` 包中包含的 JSR-330（Java 依赖注入）注释的支持，如 `@Inject` 和 `@Named`。有关这些注解的详细信息，请参阅相关章节。

> 注解注入在 XML 注入之前执行。因此，XML 配置会覆盖通过这两种方法装配的属性的注解。

一如既往，您可以将后处理器注册为单独的 bean 定义，但也可以通过在基于 XML 的 Spring 配置中包含以下标记来隐式注册它们（请注意包含上下文名称空间）：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>

</beans>
```

`<context:annotation-config/>` 元素隐式地注册了以下后处理器：

- [`ConfigurationClassPostProcessor`](https://docs.spring.io/spring-framework/docs/6.0.4/javadoc-api/org/springframework/context/annotation/ConfigurationClassPostProcessor.html)
- [`AutowiredAnnotationBeanPostProcessor`](https://docs.spring.io/spring-framework/docs/6.0.4/javadoc-api/org/springframework/beans/factory/annotation/AutowiredAnnotationBeanPostProcessor.html)
- [`CommonAnnotationBeanPostProcessor`](https://docs.spring.io/spring-framework/docs/6.0.4/javadoc-api/org/springframework/context/annotation/CommonAnnotationBeanPostProcessor.html)
- [`PersistenceAnnotationBeanPostProcessor`](https://docs.spring.io/spring-framework/docs/6.0.4/javadoc-api/org/springframework/orm/jpa/support/PersistenceAnnotationBeanPostProcessor.html)
- [`EventListenerMethodProcessor`](https://docs.spring.io/spring-framework/docs/6.0.4/javadoc-api/org/springframework/context/event/EventListenerMethodProcessor.html)

> `<context:annotation-config/>` 只在定义 bean 的同一应用程序上下文中查找 bean 上的注解。这意味着，如果在 `DispatcherServlet` 的 `WebApplicationContext` 中放置 `<context:annotation-config/>`，它只检查控制器中的 `@Autowired` bean，而不检查服务。有关详细信息，请参阅DispatcherServlet。

### 1.9.1 使用 @Autowired

> JSR 330 的 `@Inject` 注解可以在本节中的示例中代替 Spring 的 `@Autowired` 注解。请参阅此处（1.11.1）了解更多详细信息。

您可以将 `@Autowired` 注解应用于构造函数，如下例所示：

```java
public class MovieRecommender {

    private final CustomerPreferenceDao customerPreferenceDao;

    @Autowired
    public MovieRecommender(CustomerPreferenceDao customerPreferenceDao) {
        this.customerPreferenceDao = customerPreferenceDao;
    }

    // ...
}
```

> 从 Spring Framework 4.3 开始，如果目标 bean 只定义了一个构造函数开始，则不再需要在这样的构造函数上添加 `@Autowired` 注解。但是，如果有多个构造函数可用，并且没有主/默认构造函数，则必须用 `@Autowired` 注解至少一个构造函数，以便指示容器使用哪个构造函数。有关详细信息，请参阅构造函数解析的讨论。

您还可以将 `@Autowired` 注解应用于传统的 setter 方法，如下例所示：

```java
public class SimpleMovieLister {

    private MovieFinder movieFinder;

    @Autowired
    public void setMovieFinder(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // ...
}
```

还可以将注解应用于具有任意名称和多个参数的方法，如下例所示：

```java
public class MovieRecommender {

    private MovieCatalog movieCatalog;

    private CustomerPreferenceDao customerPreferenceDao;

    @Autowired
    public void prepare(MovieCatalog movieCatalog,
            CustomerPreferenceDao customerPreferenceDao) {
        this.movieCatalog = movieCatalog;
        this.customerPreferenceDao = customerPreferenceDao;
    }

    // ...
}
```

您也可以将 `@Autowired` 应用于字段，甚至将其与构造函数混合使用，如下例所示：

```java
public class MovieRecommender {

    private final CustomerPreferenceDao customerPreferenceDao;

    @Autowired
    private MovieCatalog movieCatalog;

    @Autowired
    public MovieRecommender(CustomerPreferenceDao customerPreferenceDao) {
        this.customerPreferenceDao = customerPreferenceDao;
    }

    // ...
}
```

> 确保目标组件（例如 `MovieCatalog` 或 `CustomerPreferenceDao`）由用于 `@Autowired` 注解注入点的类型一致声明。否则，注入可能会由于运行时出现“找不到类型匹配”错误而失败。
>
> 对于通过类路径扫描找到的 XML 定义的 bean 或组件类，容器通常预先知道具体类型。然而，对于 `@Bean` 工厂方法，您需要确保声明的返回类型具有足够的表达能力。对于实现多个接口的组件或可能由其实现类型引用的组件，请考虑在工厂方法上声明最特定的返回类型（至少具体到与引用 bean 的注入点所要求的程度）。

您还可以通过向需要该类型数组的字段或方法添加 `@Autowired` 注解，指示 Spring 从 `ApplicationContext` 中提供特定类型的所有 bean，如下例所示：

```java
public class MovieRecommender {

    @Autowired
    private MovieCatalog[] movieCatalogs;

    // ...
}
```

这同样适用于类型化集合，如下例所示：

```java
public class MovieRecommender {

    private Set<MovieCatalog> movieCatalogs;

    @Autowired
    public void setMovieCatalogs(Set<MovieCatalog> movieCatalogs) {
        this.movieCatalogs = movieCatalogs;
    }

    // ...
}
```

> 目标 bean 可以实现 `org.springframework.core.Ordered` 接口，或者如果希望数组或列表中的项目按特定顺序排序，可以使用 `@Order` 或标准 `@Priority` 注解。否则，它们的顺序遵循容器中相应目标 bean 定义的注册顺序。
>
> 您可以在目标类级别和 `@Bean` 方法上声明 `@Order` 注解，可能用于单个 Bean 定义（在多个定义使用同一 Bean 类的情况下）`@Order` 值可能会影响注入点的优先级，但请注意，它们不会影响单例启动顺序，这是一个由依赖关系和 `@DependsOn` 声明决定的正交问题。
>
> 注意，标准的 `jakarta.annotation.Priority` 注解在 `@Bean` 级别不可用，因为它不能在方法上声明。它的语义可以通过每种类型的单个 bean 上的 `@Order` 值与 `@Primary` 结合来建模。

即使是类型化的 `Map` 实例也可以自动连接，只要预期的键类型是 `String`。映射值包含预期类型的所有 bean，键包含相应的 bean 名称，如下例所示：

```java
public class MovieRecommender {

    private Map<String, MovieCatalog> movieCatalogs;

    @Autowired
    public void setMovieCatalogs(Map<String, MovieCatalog> movieCatalogs) {
        this.movieCatalogs = movieCatalogs;
    }

    // ...
}
```

默认情况下，当给定的注入点没有匹配的候选 bean 时，自动装配会失败。对于声明的数组、集合或映射，至少需要一个匹配元素。

默认行为是将带注解的方法和字段视为指示所需的依赖项。您可以如以下示例所示更改此行为，通过将不可满足的注入点标记为非必需（即，通过将 `@Autowired` 中的 `required` 属性设置为 `false`），使框架能够跳过该注入点：

```java
public class SimpleMovieLister {

    private MovieFinder movieFinder;

    @Autowired(required = false)
    public void setMovieFinder(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // ...
}
```

> 如果非必需方法的依赖项（或多个参数的依赖项之一）不可用，则根本不会调用该方法。在这种情况下，完全不会填充非必填字段，保留其默认值。
>
> 换句话说，将 `required` 属性设置为 `false` 表示相应的属性对于自动连线是可选的，如果无法自动连线，则将忽略该属性。这允许为财产分配默认值，可以通过依赖注入选择性地覆盖这些默认值。

注入的构造函数和工厂方法参数是一种特殊情况，因为 `@Autowired` 中的 `required` 属性具有某种不同的含义，因为 Spring 的构造函数解析算法可能会处理多个构造函数。默认情况下，构造函数和工厂方法参数实际上是必需的，但在单个构造函数场景中有一些特殊规则，如多元素注入点（数组、集合、映射），如果没有匹配的 bean 可用，则解析为空实例。这允许一个通用的实现模式，其中所有依赖项都可以在一个唯一的多参数构造函数中声明，例如，声明为一个没有 `@Autowired` 注解的公共构造函数。

> 任何给定 bean 类中只有一个构造函数可以声明 `@Autowired`，并将 `required` 属性设置为 `true`，这表明该构造函数在用作 Spring bean 时自动装配。因此，如果所需属性保留为其默认值 `true`，则只能使用 `@Autowired` 注解单个构造函数。如果多个构造函数声明注解，那么它们都必须声明 `required=false`，才能被视为自动装配的候选对象（类似于 XML 中的 `autowire=constructor`）。将选择具有最多依赖项的构造函数，该依赖项可以通过匹配 Spring 容器中的 bean 来满足。如果不能满足任何候选项，则将使用主/默认构造函数（如果存在）。类似地，如果一个类声明了多个构造函数，但没有一个用 `@Autowired` 注解，那么将使用主/默认构造函数（如果存在）。如果一个类只声明一个构造函数开始，那么它将始终被使用，即使没有注解。请注意，带注解的构造函数不必是公共的。

或者，您可以通过 Java 8 的 `Java.util.Optional` 来表达特定依赖项的非必需性质，如下例所示：

```java
public class SimpleMovieLister {

    @Autowired
    public void setMovieFinder(Optional<MovieFinder> movieFinder) {
        ...
    }
}
```

从 Spring Framework 5.0 开始，您还可以使用 `@Nullable` 注解（任何包中的任何类型——例如，JSR-305 中的 `javax.annotation.Nullable`）或仅利用 Kotlin 内置的 null 安全支持：

```java
public class SimpleMovieLister {

    @Autowired
    public void setMovieFinder(@Nullable MovieFinder movieFinder) {
        ...
    }
}
```

您还可以将 `@Autowired` 用于众所周知的可解析依赖关系的接口：`BeanFactory`、`ApplicationContext`、`Environment`、`ResourceLoader`、`ApplicationEventPublisher` 和 `MessageSource`。这些接口及其扩展接口（如 `ConfigurationApplicationContext` 或 `ResourcePatternResolver`）将自动解析，无需特殊设置。以下示例自动关联 `ApplicationContext` 对象：

```java
public class MovieRecommender {

    @Autowired
    private ApplicationContext context;

    public MovieRecommender() {
    }

    // ...
}
```

> `@Autowired`、`@Inject`、`@Value` 和 `@Resource` 注解由Spring `BeanPostProcessor` 实现处理。这意味着您不能在自己的 `BeanPostProcessor` 或 `BeanFactoryPostProcessor` 类型（如果有的话）中应用这些注解。这些类型必须使用 XML 或 Spring `@Bean` 方法显式“装配”。

### 1.9.2 使用 @Primary 微调基于注解的自动装配

由于按类型自动装配可能会导致多个候选项，因此通常需要对选择过程进行更多控制。实现这一点的一种方法是使用 Spring 的 `@Primary` 注解。`@Primary` 表示当多个 bean 作为自动装配到单个值依赖项的候选时，应优先选择特定 bean。如果候选对象中正好存在一个主 bean，则它将成为自动装配的值。

考虑将 `firstMovieCatalog` 定义为主要 `MovieCatalog` 的以下配置：

```java
@Configuration
public class MovieConfiguration {

    @Bean
    @Primary
    public MovieCatalog firstMovieCatalog() { ... }

    @Bean
    public MovieCatalog secondMovieCatalog() { ... }

    // ...
}
```

使用上述配置，以下 `MovieRecommender` 与 `firstMovieCatalog` 自动连接：

```java
public class MovieRecommender {

    @Autowired
    private MovieCatalog movieCatalog;

    // ...
}
```

相应的 bean 定义如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>

    <bean class="example.SimpleMovieCatalog" primary="true">
        <!-- inject any dependencies required by this bean -->
    </bean>

    <bean class="example.SimpleMovieCatalog">
        <!-- inject any dependencies required by this bean -->
    </bean>

    <bean id="movieRecommender" class="example.MovieRecommender"/>

</beans>
```

### 1.9.3 使用限定符微调基于注解的自动装配

当可以确定一个主要候选对象时，`@Primary` 是在多个实例中使用按类型自动装配的有效方法。当您需要对选择过程进行更多控制时，可以使用 Spring 的 `@Qualifier` 注解。您可以将限定符值与特定参数相关联，缩小类型匹配集，以便为每个参数选择特定的 bean。在最简单的情况下，这可以是一个简单的描述性值，如以下示例所示：

```java
public class MovieRecommender {

    @Autowired
    @Qualifier("main")
    private MovieCatalog movieCatalog;

    // ...
}
```

还可以在单个构造函数参数或方法参数上指定 `@Qualifier` 注解，如下例所示：

```java
public class MovieRecommender {

    private final MovieCatalog movieCatalog;

    private final CustomerPreferenceDao customerPreferenceDao;

    @Autowired
    public void prepare(@Qualifier("main") MovieCatalog movieCatalog,
            CustomerPreferenceDao customerPreferenceDao) {
        this.movieCatalog = movieCatalog;
        this.customerPreferenceDao = customerPreferenceDao;
    }

    // ...
}
```

下面的示例显示了相应的 bean 定义。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>

    <bean class="example.SimpleMovieCatalog">
        <qualifier value="main"/> (1) 具有主限定符值的 bean 与用相同值限定的构造函数参数关联。

        <!-- inject any dependencies required by this bean -->
    </bean>

    <bean class="example.SimpleMovieCatalog">
        <qualifier value="action"/> (2) 具有操作限定符值的 bean 与用相同值限定的构造函数参数关联。

        <!-- inject any dependencies required by this bean -->
    </bean>

    <bean id="movieRecommender" class="example.MovieRecommender"/>

</beans>
```

对于回退匹配，bean 名称被视为默认限定符值。因此，您可以使用 `id` 为 `main` 而不是嵌套限定符元素来定义 bean，从而得到相同的匹配结果。然而，尽管您可以使用此约定按名称引用特定的 bean，`@Autowired` 基本上是关于带有可选语义限定符的类型驱动注入。这意味着，即使使用 bean 名称回退，限定符值在类型匹配集中也始终具有收缩语义。它们不会在语义上表示对唯一 bean `id` 的引用。良好的限定符值是 `main`、`EMEA` 或 `persistent`，表示独立于 bean `id` 的特定组件的特性，在匿名 bean 定义（如前一示例中的定义）的情况下，可以自动生成这些特性。

限定符也适用于类型化集合，如前所述——例如，`Set<MovieCatalog>`。在这种情况下，根据声明的限定符，所有匹配的 bean 都作为集合注入。这意味着限定符不必是唯一的。相反，它们构成了过滤标准。例如，您可以使用相同的限定符值“action”定义多个 `MovieCatalog` bean，所有这些 bean 都被注入到一个用`@Qualifier("action")` 注解的 `Set<MovieCatalog>` 中。

> 让限定符值在类型匹配候选项中针对目标 bean 名称进行选择，不需要在注入点使用 `@Qualifier` 注解。如果没有其他解析指示符（例如限定符或主标记），对于非唯一依赖性情况，Spring 将注入点名称（即字段名称或参数名称）与目标 bean 名称进行匹配，并选择相同的命名候选（如果有）。

也就是说，如果您打算通过名称来表示注解驱动的注入，请不要主要使用 `@Autowired`，即使它能够通过 bean 名称在类型匹配候选中进行选择。相反，使用 JSR-250 `@Resource` 注解，该注释在语义上定义为通过其唯一名称标识特定的目标组件，声明的类型与匹配过程无关 `@Autowired` 具有截然不同的语义：在按类型选择候选 bean 之后，指定的 `String` 限定符值仅在那些类型选择的候选 bean 中被考虑（例如，将 `account` 限定符与标记有相同限定符标签的 bean 匹配）。

对于本身定义为集合、`Map` 或数组类型的 bean，`@Resource` 是一个很好的解决方案，通过唯一的名称引用特定的集合或数组 bean。也就是说，从 4.3 开始，只要元素类型信息保存在 `@Bean` 返回类型签名或集合继承层次结构中，就可以通过 Spring 的 `@Autowired` 类型匹配算法匹配集合、`Map` 和数组类型。在这种情况下，可以使用限定符值在相同类型的集合中进行选择，如前一段所述。

从 4.3 开始，`@Autowired` 还考虑了注入的自引用（即，对当前注入的 bean 的引用）。注意，自注入是一种回退。对其他组件的常规依赖始终具有优先级。从这个意义上说，自我引用不参与常规的候选人选择，因此特别是从不主要。相反，它们总是以最低优先级结束。在实践中，您应该使用自引用作为最后的手段（例如，通过 bean 的事务代理调用同一实例上的其他方法）。在这样的场景中，考虑将受影响的方法分解为单独的委托 bean。或者，您可以使用 `@Resource`，它可以通过其唯一名称获取返回到当前 bean 的代理。

> 尝试在同一个配置类上注入 `@Bean` 方法的结果实际上也是一种自引用场景。要么在实际需要的方法签名中惰性地解析此类引用（而不是配置类中的自动连接字段），要么将受影响的 `@Bean` 方法声明为 `static`，将其与包含的配置类实例及其生命周期分离。否则，这种 bean 只在回退阶段被考虑，其他配置类上的匹配 bean 被选为主要候选（如果可用）。

`@Autowired` 应用于字段、构造函数和多参数方法，允许在参数级别通过限定符注释进行缩小。相反，`@Resource` 仅支持具有单个参数的字段和 bean 属性 setter 方法。因此，如果注入目标是构造函数或多参数方法，则应使用限定符。

您可以创建自己的自定义限定符注解。为此，请定义一个注解并在定义中提供 `@Qualifier` 注解，如下例所示：

```java
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface Genre {

    String value();
}
```

然后，您可以在自动装配字段和参数上提供自定义限定符，如下例所示：

```java
public class MovieRecommender {

    @Autowired
    @Genre("Action")
    private MovieCatalog actionCatalog;

    private MovieCatalog comedyCatalog;

    @Autowired
    public void setComedyCatalog(@Genre("Comedy") MovieCatalog comedyCatalog) {
        this.comedyCatalog = comedyCatalog;
    }

    // ...
}
```

接下来，您可以提供候选 bean 定义的信息。您可以添加 `<qualifier/>` 标记作为 `<bean/>` 标记的子元素，然后指定 `type` 和 `value` 以匹配自定义限定符注解。该类型与批注的完全限定类名匹配。或者，为了方便起见，如果不存在名称冲突的风险，可以使用短类名。以下示例演示了两种方法：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>

    <bean class="example.SimpleMovieCatalog">
        <qualifier type="Genre" value="Action"/>
        <!-- inject any dependencies required by this bean -->
    </bean>

    <bean class="example.SimpleMovieCatalog">
        <qualifier type="example.Genre" value="Comedy"/>
        <!-- inject any dependencies required by this bean -->
    </bean>

    <bean id="movieRecommender" class="example.MovieRecommender"/>

</beans>
```

在 “Classpath 扫描和托管组件”中，您可以看到一种基于注解的替代方法来提供 XML 中的限定符元数据。具体而言，请参阅“用注解提供限定符元数据”。

在某些情况下，使用没有值的注解就足够了。当注解用于更一般的用途并且可以应用于多种不同类型的依赖项时，这可能很有用。例如，您可以提供一个脱机目录，当没有可用的 Internet 连接时可以搜索该目录。首先，定义简单注解，如下例所示：

```java
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface Offline {
}
```

然后将注解添加到要自动关联的字段或属性，如以下示例所示：

```java
public class MovieRecommender {

    @Autowired
    @Offline // (1) 这一行添加了 @Offline 注解
    private MovieCatalog offlineCatalog;

    // ...
}
```

现在，bean 定义只需要限定符 `type`，如下例所示：

```xml
<bean class="example.SimpleMovieCatalog">
    <qualifier type="Offline"/> (1) 该元素指定了限定符
    <!-- inject any dependencies required by this bean -->
</bean>
```

您还可以定义自定义限定符注解，这些注解接受除简单 `value` 属性之外的命名属性。如果在要自动装配的字段或参数上指定多个属性值，则 bean 定义必须匹配所有此类属性值，才能被视为自动装配候选。例如，考虑以下注解定义：

```java
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface MovieQualifier {

    String genre();

    Format format();
}
```

在此情况下 `Format` 是一个枚举，在下面定义：

```java
public enum Format {
    VHS, DVD, BLURAY
}
```

要自动装配的字段使用自定义限定符进行注解，并包含两个属性的值：`genre` 和 `format`，如下例所示：

```java
public class MovieRecommender {

    @Autowired
    @MovieQualifier(format=Format.VHS, genre="Action")
    private MovieCatalog actionVhsCatalog;

    @Autowired
    @MovieQualifier(format=Format.VHS, genre="Comedy")
    private MovieCatalog comedyVhsCatalog;

    @Autowired
    @MovieQualifier(format=Format.DVD, genre="Action")
    private MovieCatalog actionDvdCatalog;

    @Autowired
    @MovieQualifier(format=Format.BLURAY, genre="Comedy")
    private MovieCatalog comedyBluRayCatalog;

    // ...
}
```

最后，bean 定义应该包含匹配的限定符值。这个示例还演示了您可以使用 bean 元属性而不是 `<qualifier/>` 元素。如果可用，`<qualifier/>` 元素及其属性具有优先权，但如果不存在此类限定符，则自动装配机制将依赖于 `<meta/>` 标记中提供的值，如以下示例中的最后两个 bean 定义：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>

    <bean class="example.SimpleMovieCatalog">
        <qualifier type="MovieQualifier">
            <attribute key="format" value="VHS"/>
            <attribute key="genre" value="Action"/>
        </qualifier>
        <!-- inject any dependencies required by this bean -->
    </bean>

    <bean class="example.SimpleMovieCatalog">
        <qualifier type="MovieQualifier">
            <attribute key="format" value="VHS"/>
            <attribute key="genre" value="Comedy"/>
        </qualifier>
        <!-- inject any dependencies required by this bean -->
    </bean>

    <bean class="example.SimpleMovieCatalog">
        <meta key="format" value="DVD"/>
        <meta key="genre" value="Action"/>
        <!-- inject any dependencies required by this bean -->
    </bean>

    <bean class="example.SimpleMovieCatalog">
        <meta key="format" value="BLURAY"/>
        <meta key="genre" value="Comedy"/>
        <!-- inject any dependencies required by this bean -->
    </bean>

</beans>
```

### 1.9.4 使用泛型作为自动装配限定符

除了 `@Qualifier` 注解之外，还可以使用 Java 泛型类型作为隐式的限定形式。例如，假设您具有以下配置：

```java
@Configuration
public class MyConfiguration {

    @Bean
    public StringStore stringStore() {
        return new StringStore();
    }

    @Bean
    public IntegerStore integerStore() {
        return new IntegerStore();
    }
}
```

假设前面的 bean 实现了一个泛型接口（即 `Store<String>` 和 `Store<Integer>`），您可以 `@Autowire` `Store` 接口，泛型用作限定符，如下例所示：

```java
@Autowired
private Store<String> s1; // <String> qualifier, injects the stringStore bean

@Autowired
private Store<Integer> s2; // <Integer> qualifier, injects the integerStore bean
```

当自动装配列表、`Map` 实例和数组时，泛型限定符也适用。以下示例自动装配一个泛型 `List`：

```java
// Inject all Store beans as long as they have an <Integer> generic
// Store<String> beans will not appear in this list
@Autowired
private List<Store<Integer>> s;
```

### 1.9.5 使用 CustomAutowireConfigurer

`CustomAutowireConfigurer` 是一个 `BeanFactoryPostProcessor`，它允许您注册自己的自定义限定符注解类型，即使它们没有使用 Spring 的 `@Qualifier` 注解进行注解。以下示例显示如何使用 `CustomAutowireConfigurer`：

```xml
<bean id="customAutowireConfigurer"
        class="org.springframework.beans.factory.annotation.CustomAutowireConfigurer">
    <property name="customQualifierTypes">
        <set>
            <value>example.CustomQualifier</value>
        </set>
    </property>
</bean>
```

`AutowireCandidateResolver` 通过以下方式确定自动装配候选项：

- 每个 bean 定义的 `autowire-candidate` 值
- `<beans/>` 元素上可用的任何 `default-autowire-candidates` 模式
- `@Qualifier` 注解和在 `CustomAutowireConfigurer` 中注册的任何自定义注解的存在

当多个 bean 符合自动装配候选时，“primary” 的确定如下：如果候选中只有一个 bean 定义的 `primary` 属性设置为 `true`，则选择它。

### 1.9.6 使用 @Resource 注入

Spring 还支持对字段或 bean 属性设置器方法使用 JSR-250 `@Resource` 注解（`jakarta.annotation.Resource`）进行注入。这是 Jakarta EE 中常见的模式：例如，在 JSF 管理的 bean 和 JAX-WS 端点中。Spring 也支持 Spring 托管对象的这种模式。

`@Resource` 具有名称属性。默认情况下，Spring 将该值解释为要注入的 bean 名称。换句话说，它遵循名称语义，如下例所示：

```java
public class SimpleMovieLister {

    private MovieFinder movieFinder;

    @Resource(name="myMovieFinder") // (1) 这一行注入 @Resource
    public void setMovieFinder(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }
}
```

如果未显式指定名称，则默认名称从字段名或 setter 方法派生。如果是字段，则采用字段名。对于 setter 方法，它采用 bean 属性名称。以下示例将名为 `movieFinder` 的 bean 注入其 setter 方法：

```java
public class SimpleMovieLister {

    private MovieFinder movieFinder;

    @Resource
    public void setMovieFinder(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }
}
```

> 注解提供的名称由 `CommonAnnotationBeanPostProcessor` 知道的 `ApplicationContext` 解析为 bean 名称。如果显式配置 Spring 的 `SimpleJndiBeanFactory`，则可以通过 JNDI 解析名称。但是，我们建议您依赖默认行为并使用 Spring 的 JNDI 查找功能来保持间接级别。

在没有指定显式名称的 `@Resource` 用法的独占情况下，与 `@Autowired` 类似，`@Resource` 查找主类型匹配而不是特定的命名 bean，并解析众所周知的可解析依赖项：`BeanFactory`、`ApplicationContext`、`ResourceLoader`、`ApplicationEventPublisher` 和 `MessageSource` 接口。

因此，在以下示例中，`customerPreferenceDao` 字段首先查找名为 “customerPreferencesDao” 的 bean，然后返回到 `CustomerPreferenceDao` 类型的主类型匹配：

```java
public class MovieRecommender {

    @Resource
    private CustomerPreferenceDao customerPreferenceDao;

    @Resource
    private ApplicationContext context; // (1) 这个 `context` 字段是基于已知的可解析依赖类型 `ApplicationContext` 注入的。

    public MovieRecommender() {
    }

    // ...
}
```

### 1.9.7 使用 @Value

`@Value` 通常用于注入外部化的属性：

```java
@Component
public class MovieRecommender {

    private final String catalog;

    public MovieRecommender(@Value("${catalog.name}") String catalog) {
        this.catalog = catalog;
    }
}
```

具有以下配置：

```java
@Configuration
@PropertySource("classpath:application.properties")
public class AppConfig { }
```

以及以下 `application.properties` 文件：

```properties
catalog.name=MovieCatalog
```

在这种情况下，`catalog` 参数和字段将等于 `MovieCatalog` 值。

Spring 提供了默认的宽松嵌入式值解析器。它将尝试解析属性值，如果无法解析，则会将属性名称（例如 `${catalog.name}`）作为值注入。如果要对不存在的值保持严格控制，应声明 `PropertySourcesPlaceholderConfigurer` bean，如下例所示：

```java
@Configuration
public class AppConfig {

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertyPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }
}
```

> 使用 JavaConfig 配置 `PropertySourcesPlaceholderConfigurator` 时，`@Bean` 方法必须是 `static`。

如果无法解析任何 `${}` 占位符，使用上述配置可确保 Spring 初始化失败。也可以使用 `setPlaceholderPrefix`、`setPlaceholdersSuffix` 或 `setValueSeparator` 等方法自定义占位符。

> Spring Boot 默认配置一个 `PropertySourcesPlaceholderConfigurer` bean，该 bean 将从 `application.properties` 和 `application.yml` 文件中获取属性。

Spring 提供的内置转换器支持允许自动处理简单的类型转换（例如，到 `Integer` 或 `int`）。多个逗号分隔的值可以自动转换为字符串数组，而无需额外的工作。

可以提供如下默认值：

```java
@Component
public class MovieRecommender {

    private final String catalog;

    public MovieRecommender(@Value("${catalog.name:defaultCatalog}") String catalog) {
        this.catalog = catalog;
    }
}
```

Spring `BeanPostProcessor` 在幕后使用 `ConversionService` 来处理将 `@Value` 中的 String 值转换为目标类型的过程。如果您想为自己的自定义类型提供转换支持，可以提供自己的 `ConversionService` bean实例，如下例所示：

```java
@Configuration
public class AppConfig {

    @Bean
    public ConversionService conversionService() {
        DefaultFormattingConversionService conversionService = new DefaultFormattingConversionService();
        conversionService.addConverter(new MyCustomConverter());
        return conversionService;
    }
}
```

当 `@Value` 包含 SpEL 表达式时，将在运行时动态计算该值，如下例所示：

```java
@Component
public class MovieRecommender {

    private final String catalog;

    public MovieRecommender(@Value("#{systemProperties['user.catalog'] + 'Catalog' }") String catalog) {
        this.catalog = catalog;
    }
}
```

SpEL 还支持使用更复杂的数据结构：

```java
@Component
public class MovieRecommender {

    private final Map<String, Integer> countOfMoviesPerCatalog;

    public MovieRecommender(
            @Value("#{{'Thriller': 100, 'Comedy': 300}}") Map<String, Integer> countOfMoviesPerCatalog) {
        this.countOfMoviesPerCatalog = countOfMoviesPerCatalog;
    }
}
```

### 1.9.8 使用 @PostConstruct 和 @PreDestroy

`CommonAnnotationBeanPostProcessor` 不仅识别 `@Resource` 注解，还识别 JSR-250 生命周期注释：`jakara.annotation.PostConstruct` 和 `jakara.annotation.PreDestroy`。在 Spring 2.5 中引入了对这些注解的支持，为初始化回调和销毁回调中描述的生命周期回调机制提供了一种替代方案。如果 `CommonAnnotationBeanPostProcessor` 在 Spring `ApplicationContext` 中注册，则在生命周期的同一点调用携带这些注解之一的方法，该方法与相应的 Spring 生命周期接口方法或显式声明的回调方法相同。在以下示例中，缓存在初始化时预填充，并在销毁时清除：

```java
public class CachingMovieLister {

    @PostConstruct
    public void populateMovieCache() {
        // populates the movie cache upon initialization...
    }

    @PreDestroy
    public void clearMovieCache() {
        // clears the movie cache upon destruction...
    }
}
```

有关组合各种生命周期机制的效果的详细信息，请参阅组合生命周期机制。

> 与 `@Resource` 一样，`@PostConstruct` 和 `@PreDestroy` 注解类型是 JDK 6 到 8 标准 Java 库的一部分。然而，整个 `javax.annotation` 包与 JDK 9 中的核心 Java 模块分离，最终在 JDK 11 中删除。从 Jakarta EE 9 开始，该包现在位于 `jakarta.annotation` 中。如果需要，`jakarta.annotation-api` 工件现在需要通过 Maven Central 获得，只需像任何其他库一样添加到应用程序的类路径。

## 1.10 类路径扫描和托管组件

本章中的大多数示例使用 XML 指定在 Spring 容器中生成每个 `BeanDefinition` 的配置元数据。上一节（基于注释的容器配置）演示了如何通过源级别注释提供大量配置元数据。然而，即使在这些示例中，“基本” bean 定义也在 XML 文件中明确定义，而注解仅驱动依赖注入。本节介绍通过扫描类路径隐式检测候选组件的选项。候选组件是与筛选条件匹配的类，并在容器中注册了相应的 bean 定义。这消除了使用 XML 执行 bean 注册的需要。相反，您可以使用注解（例如，`@Component`）、AspectJ 类型表达式或您自己的自定义筛选条件来选择哪些类具有向容器注册的 bean 定义。

> 从 Spring 3.0 开始，Spring JavaConfig 项目提供的许多特性都是核心 Spring 框架的一部分。这允许您使用 Java 而不是使用传统的 XML 文件来定义 bean。查看 `@Configuration`、`@Bean`、`@Import` 和 `@DependsOn` 注解，了解如何使用这些新功能的示例。

### 1.10.1 @Component 和更多传统模式注解

`@Repository` 注解是实现存储库（也称为数据访问对象或 DAO）角色或传统模式的任何类的标记。此标记的用途之一是异常的自动转换，如“异常转换”中所述。

Spring 提供了更多的传统模式注解：`@Component`、`@Service` 和 `@Controller`。`@Component` 是任何 Spring 管理组件的泛型传统模式。`@Repository`、`@Service` 和 `@Controller` 是 `@Component` 的专门化，用于更具体的用例（分别在持久性、服务和表示层）。因此，您可以使用 `@Component` 来注解组件类，但是，通过改用 `@Repository`、`@Service` 或 `@Controller` 来注解它们，您的类更适合由工具处理或与切面关联。例如，这些传统模式注解是切入点的理想目标。`@Repository`、`@Service` 和 `@Controller` 也可以在未来的 Spring Framework 版本中携带额外的语义。因此，如果您在服务层使用 `@Component` 或 `@Service` 之间进行选择，`@Service` 显然是更好的选择。类似地，如前所述，`@Repository` 已经被支持作为持久层中自动异常转换的标记。

### 1.10.2 使用元注解和组合注解

Spring 提供的许多注解可以在您自己的代码中用作元注解。元注解是可以应用于另一个注解的注解。例如，前面提到的 `@Service` 注解是用 `@Component` 元注解的，如下例所示：

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component (1)
public @interface Service {

    // ...
}

// (1) `@Component` 使得 `@Service` 可以像 `@Component` 一样被处理
```

您还可以组合元注解来创建“组合注解”。例如，Spring MVC 中的 `@RestController` 注解由 `@Controller` 和 `@ResponseBody` 组成。

此外，组合注解可以选择性地从元注解中重新声明属性，以允许自定义。当您只想公开元注解属性的子集时，这可能特别有用。例如，Spring 的 `@SessionScope` 注解将作用域名称硬编码为 `session`，但仍然允许定制 `proxyMode`。以下列表显示 `SessionScope` 注解的定义：

```java
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Scope(WebApplicationContext.SCOPE_SESSION)
public @interface SessionScope {

    /**
     * Alias for {@link Scope#proxyMode}.
     * <p>Defaults to {@link ScopedProxyMode#TARGET_CLASS}.
     */
    @AliasFor(annotation = Scope.class)
    ScopedProxyMode proxyMode() default ScopedProxyMode.TARGET_CLASS;

}
```

然后，可以使用 `@SessionScope` 而不声明 `proxyMode`，如下所示：

```java
@Service
@SessionScope
public class SessionScopedService {
    // ...
}
```

您还可以重写 `proxyMode` 的值，如下例所示：

```java
@Service
@SessionScope(proxyMode = ScopedProxyMode.INTERFACES)
public class SessionScopedUserService implements UserService {
    // ...
}
```

有关更多详细信息，请参阅 Spring Annotation Programming Model wiki页面。

### 1.10.3 自动检测类和注册 Bean 定义

Spring 可以自动检测定型类，并向 `ApplicationContext` 注册相应的 `BeanDefinition` 实例。例如，以下两个类可用于此类自动检测：

```java
@Service
public class SimpleMovieLister {

    private MovieFinder movieFinder;

    public SimpleMovieLister(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }
}
```

```java
@Repository
public class JpaMovieFinder implements MovieFinder {
    // implementation elided for clarity
}
```

要自动检测这些类并注册相应的 bean，需要将 `@ComponentScan` 添加到 `@Configuration` 类中，其中 `basePackages` 属性是两个类的公共父包。（或者，可以指定逗号、分号或空格分隔的列表，其中包含每个类的父包。）

```java
@Configuration
@ComponentScan(basePackages = "org.example")
public class AppConfig  {
    // ...
}
```

为了简洁起见，前面的示例可能使用了注解的 `value` 属性（即 `@ComponentScan("org.example")`）。

以下替代方案使用 XML：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:component-scan base-package="org.example"/>

</beans>
```

> `<context:component-scan>` 的使用隐式地启用了 `<context:annotation-config>` 的功能。在使用 `<context:component-scan>` 时，通常不需要包含 `<context:annotation-config>` 元素。

> 扫描类路径包需要在类路径中存在相应的目录条目。当您使用 Ant 构建 JAR 时，请确保您没有激活 JAR 任务的仅文件开关。此外，在某些环境中，基于安全策略，类路径目录可能不会公开——例如，JDK 1.7.0_45 和更高版本上的独立应用程序（需要在清单中设置“Trusted-Library” — 参考 https://stackoverflow.com/questions/19394570/java-jre-7u45-breaks-classloader-getresources).
>
> 在 JDK 9 的模块路径（Jigsaw）上，Spring 的类路径扫描通常按预期工作。但是，请确保在 `module-info` 描述符中导出了组件类。如果您希望 Spring 调用类的非公共成员，请确保它们是“打开的”（即，它们在模块信息描述符中使用 `opens` 声明而不是 `exports` 声明）。

此外，当您使用组件扫描元素时，`AutowiredAnnotationBeanPostProcessor` 和 `CommonAnnotationBeamPostProcessor` 都是隐式包含的。这意味着这两个组件是自动检测并连接在一起的——所有这些都没有 XML 中提供的任何 bean 配置元数据。

> 通过包含值为 `false` 的 `annotation-config` 属性，可以禁用 `AutowiredAnnotationBeanPostProcessor` 和 `CommonAnnotationBeamPostProcessor` 的注册。

### 1.10.4 使用过滤器来自定义扫描

默认情况下，用 `@Component`、`@Repository`、`@Service`、`@Controller`、`@Configuration` 注解的类，或用 `@Component` 注解的自定义注解，是唯一检测到的候选组件。但是，您可以通过应用自定义过滤器来修改和扩展此行为。将它们添加为 `@ComponentScan` 注解的 `includeFilters` 或 `excludeFilters` 属性（或添加为 XML 配置中 `<context:component-scan>` 元素的 `<context:include-filter/>` 或 `<context:exclude-filter/>` 子元素）。每个筛选器元素都需要 `type` 和 `expression` 属性。下表介绍了过滤选项：

| 过滤器类型   | 示例表达式                   | Description                                                  |
| :----------- | :--------------------------- | :----------------------------------------------------------- |
| 注解（默认） | `org.example.SomeAnnotation` | 在目标组件的类型级别上出现或间接出现的注解                   |
| 可归类       | `org.example.SomeClass`      | 目标组件可归于（扩展或实现）的类（或接口）。                 |
| aspectj      | `org.example..*Service+`     | 要由目标组件匹配的 AspectJ 类型表达式。                      |
| 正则表达式   | `org\.example\.Default.*`    | 要与目标组件的类名匹配的正则表达式。                         |
| 自定义       | `org.example.MyTypeFilter`   | `org.springframework.core.type.TypeFilter` 接口的自定义实现。 |

以下示例显示了忽略所有 `@Repository` 注解并使用“存根（stub）”存储库的配置：

```java
@Configuration
@ComponentScan(basePackages = "org.example",
        includeFilters = @Filter(type = FilterType.REGEX, pattern = ".*Stub.*Repository"),
        excludeFilters = @Filter(Repository.class))
public class AppConfig {
    // ...
}
```

以下列表显示了等效的 XML：

```xml
<beans>
    <context:component-scan base-package="org.example">
        <context:include-filter type="regex"
                expression=".*Stub.*Repository"/>
        <context:exclude-filter type="annotation"
                expression="org.springframework.stereotype.Repository"/>
    </context:component-scan>
</beans>
```

> 您还可以通过在注释上设置 `useDefaultFilters=false` 或通过将 `useDefaultFilters="false"` 作为 `<component-scan/>` 元素的属性来禁用默认过滤器。这有效地禁用了对用 `@Component`、`@Repository`、`@Service`、`@Controller`、`@RestController` 或 `@Configuration` 注解的类或元注解的自动检测。

### 1.10.5 在组件中定义 Bean 元数据

Spring 组件还可以向容器提供 bean 定义元数据。您可以使用用于在 `@Configuration` 注解类中定义 Bean 元数据的 `@Bean` 注解来实现这一点。以下示例显示了如何执行此操作：

```java
@Component
public class FactoryMethodComponent {

    @Bean
    @Qualifier("public")
    public TestBean publicInstance() {
        return new TestBean("publicInstance");
    }

    public void doWork() {
        // Component method implementation omitted
    }
}
```

前面的类是一个 Spring 组件，其 `doWork()` 方法中包含特定于应用程序的代码。然而，它还提供了一个 bean 定义，该定义具有引用方法 `publicInstance()` 的工厂方法。`@Bean` 注解标识工厂方法和其他 Bean 定义属性，例如通过 `@Qualifier` 注解的限定符值。可以指定的其他方法级注解包括 `@Scope`、`@Lazy` 和自定义限定符注解。

> 除了它在组件初始化中的作用外，您还可以将 `@Lazy` 注解放置在标记为 `@Autowired` 或 `@Inject` 的注入点上。在这种情况下，它会导致延迟解析代理的注入。然而，这种代理方法相当有限。对于复杂的惰性交互，特别是与可选依赖项的组合，我们建议改用 `ObjectProvider<MyTargetBean>`。

如前所述，支持自动装配字段和方法，同时还支持 `@Bean` 方法的自动装配。以下示例显示了如何执行此操作：

```java
@Component
public class FactoryMethodComponent {

    private static int i;

    @Bean
    @Qualifier("public")
    public TestBean publicInstance() {
        return new TestBean("publicInstance");
    }

    // use of a custom qualifier and autowiring of method parameters
    @Bean
    protected TestBean protectedInstance(
            @Qualifier("public") TestBean spouse,
            @Value("#{privateInstance.age}") String country) {
        TestBean tb = new TestBean("protectedInstance", 1);
        tb.setSpouse(spouse);
        tb.setCountry(country);
        return tb;
    }

    @Bean
    private TestBean privateInstance() {
        return new TestBean("privateInstance", i++);
    }

    @Bean
    @RequestScope
    public TestBean requestScopedInstance() {
        return new TestBean("requestScopedInstance", 3);
    }
}
```

该示例将 `String` 方法参数 `country` 自动装配到另一个名为 `privateInstance` 的 bean 上 `age` 属性的值。Spring Expression Language 元素通过符号 `#{<Expression>}` 定义属性的值。对于 `@Value` 注解，表达式解析器被预先配置为在解析表达式文本时查找 bean 名称。

从 Spring Framework 4.3 开始，您还可以声明 `InjectionPoint`（或其更具体的子类：`DependencyDescriptor`）类型的工厂方法参数，以访问触发当前 bean 创建的请求注入点。注意，这只适用于 bean 实例的实际创建，而不适用于现有实例的注入。因此，这个特性对于原型作用域的 bean 来说最有意义。对于其他作用域，工厂方法只会看到在给定作用域中触发创建新 bean 实例的注入点（例如，触发创建惰性单例 bean 的依赖项）。在这样的场景中，您可以使用所提供的注入点元数据，并注意语义。以下示例显示了如何使用 `InjectionPoint`：

```java
@Component
public class FactoryMethodComponent {

    @Bean @Scope("prototype")
    public TestBean prototypeInstance(InjectionPoint injectionPoint) {
        return new TestBean("prototypeInstance for " + injectionPoint.getMember());
    }
}
```

常规 Spring 组件中的 `@Bean` 方法的处理方式不同于 Spring `@Configuration` 类中的对应方法。不同之处在于，`@Component` 类并没有通过 CGLIB 增强以拦截方法和字段的调用。CGLIB 代理是调用 `@Configuration` 类中 `@Bean` 方法中的方法或字段创建对协作对象的 Bean 元数据引用的方法。这样的方法不是用正常的 Java 语义调用的，而是通过容器来提供 Spring Bean 的通常生命周期管理和代理，即使在通过对 `@Bean` 方法的编程调用来引用其他 Bean 时也是如此。相反，在纯 `@Component` 类中调用 `@Bean` 方法中的方法或字段具有标准的 Java 语义，没有特殊的 CGLIB 处理或其他约束。

> 您可以将 `@Bean` 方法声明为 `static`，允许在不将其包含的配置类创建为实例的情况下调用它们。这在定义后处理器 bean（例如，类型为 `BeanFactoryPostProcessor` 或 `BeanPostProcessor`）时特别有意义，因为这样的 bean 在容器生命周期的早期就被初始化，应该避免在此时触发配置的其他部分。
>
> 由于技术限制，对静态 `@Bean` 方法的调用永远不会被容器拦截，即使在 `@Configuration` 类中也不会被拦截（如本节前面所述）：CGLIB 子类化只能覆盖非静态方法。因此，对另一个 `@Bean` 方法的直接调用具有标准 Java 语义，从而直接从工厂方法本身返回一个独立实例。
>
> `@Bean` 方法的 Java 语言可见性不会对 Spring 容器中生成的 Bean 定义产生直接影响。您可以根据需要自由声明非 `@Configuration` 类的工厂方法以及任何地方的静态方法。然而，`@Configuration` 类中的常规 `@Bean` 方法需要是可重写的——也就是说，它们不能被宣布为 `private` 或 `final`。
>
> `@Bean` 在给定组件或配置类的基类上可以被发现，以及在组件或配置类实现的接口中声明的 Java 8 默认方法上也可以被发现。这在组合复杂的配置安排方面提供了很大的灵活性，从 Spring 4.2 开始，甚至可以通过 Java 8 默认方法进行多重继承。
>
> 最后，一个类可以为同一个 Bean 保存多个 `@Bean` 方法，这是根据运行时可用的依赖关系使用的多个工厂方法的排列。这与在其他配置场景中选择“贪婪”构造函数或工厂方法的算法相同：在构建时选择具有最多可满足依赖项的变量，类似于容器如何在多个 `@Autowired` 构造函数之间进行选择。

### 1.10.6 命名自动检测组件

当组件作为扫描过程的一部分被自动检测时，其 bean 名称由该扫描器已知的 `BeanNameGenerator` 策略生成。默认情况下，任何包含名称值的 Spring 传统模式注解（`@Component`、`@Repository`、`@Service` 和 `@Controller`）都会将该名称提供给相应的 bean 定义。

如果这样的注解不包含名称值或任何其他检测到的组件（例如自定义过滤器发现的组件），则默认 bean 名称生成器将返回未大写的非限定类名。例如，如果检测到以下组件类，则名称将为 `myMovieLister` 和 `movieFinderImpl`：

```java
@Service("myMovieLister")
public class SimpleMovieLister {
    // ...
}
```

```java
@Repository
public class MovieFinderImpl implements MovieFinder {
    // ...
}
```

如果不想依赖默认的 bean 命名策略，可以提供自定义 bean 命名策略。首先，实现 `BeanNameGenerator` 接口，并确保包含默认的无参数构造函数。然后，在配置扫描器时提供完全限定的类名，如下例注解和 bean 定义所示。

> 如果由于多个自动检测到的组件具有相同的非限定类名（即，具有相同名称但驻留在不同包中的类）而导致命名冲突，则可能需要配置默认为生成的 bean 名称的完全限定类名的 `BeanNameGenerator`。从 Spring Framework 5.2.3 开始，位于 `org.springframework.context.annotation` 包中的 `FullyQualifiedAnnotationBeanGenerator` 可用于此类目的。

```java
@Configuration
@ComponentScan(basePackages = "org.example", nameGenerator = MyNameGenerator.class)
public class AppConfig {
    // ...
}
```

```xml
<beans>
    <context:component-scan base-package="org.example"
        name-generator="org.example.MyNameGenerator" />
</beans>
```

作为一般规则，考虑在其他组件可能对其进行显式引用时使用注解指定名称。另一方面，只要容器负责装配，自动生成的名称就足够了。

### 1.10.7 为自动检测的组件提供作用域

与一般的 Spring 管理组件一样，自动检测组件的默认和最常见范围是 `singleton`。但是，有时您需要一个可以由 `@Scope` 注解指定的不同作用域。可以在注解中提供作用域的名称，如下例所示：

```java
@Scope("prototype")
@Repository
public class MovieFinderImpl implements MovieFinder {
    // ...
}
```

> `@Scope` 注解仅在具体的 bean 类（对于带注解的组件）或工厂方法（对于 `@Bean` 方法）上进行内省。与 XML bean 定义相反，没有 bean 定义继承的概念，类级别的继承层次结构与元数据目的无关。

有关特定于 web 的作用域（如 Spring 上下文中的“请求”或“会话”）的详细信息，请参阅“请求、会话、应用和 WebSocket 作用域”。与这些作用域的预构建注解一样，您也可以使用 Spring 的元注解方法来编写自己的作用域注解：例如，使用 `@Scope("prototype")` 元注解的自定义注解，也可能声明自定义作用域代理模式。

> 要为作用域解析提供自定义策略而不是依赖基于注解的方法，可以实现 `ScopeMetadataResolver` 接口。确保包含默认的无参数构造函数。然后，您可以在配置扫描器时提供完全限定的类名，如下面的注解和 bean 定义示例所示：
>
> ```java
> @Configuration
> @ComponentScan(basePackages = "org.example", scopeResolver = MyScopeResolver.class)
> public class AppConfig {
>     // ...
> }
> ```
>
> ```xml
> <beans>
>     <context:component-scan base-package="org.example" scope-resolver="org.example.MyScopeResolver"/>
> </beans>
> ```

当使用某些非单例作用域时，可能需要为作用域对象生成代理。推理在“作为依赖的作用域 Bean”中描述。为此，组件扫描元素上提供了作用域代理属性。三个可能的值是：`no`、`interfaces` 和 `targetClass`。例如，以下配置生成标准 JDK 动态代理：

```java
@Configuration
@ComponentScan(basePackages = "org.example", scopedProxy = ScopedProxyMode.INTERFACES)
public class AppConfig {
    // ...
}
```

```xml
<beans>
    <context:component-scan base-package="org.example" scoped-proxy="interfaces"/>
</beans>
```

### 1.10.8 通过注解提供限定符元数据

`@Qualifier` 注解在“使用限定符微调基于注解的自动装配”中讨论。该节中的示例演示了 `@Qualifier` 注解和自定义限定符注解的使用，以在解析自动装配候选项时提供细粒度控制。因为这些示例基于 XML bean 定义，所以通过使用 XML 中 `bean` 元素的 `qualifier` 或 `meta` 子元素，在候选 bean 定义上提供了限定符元数据。当依赖类路径扫描来自动检测组件时，可以为候选类提供带有类级别注解的限定符元数据。以下三个示例演示了该技术：

```java
@Component
@Qualifier("Action")
public class ActionMovieCatalog implements MovieCatalog {
    // ...
}
```

```java
@Component
@Genre("Action")
public class ActionMovieCatalog implements MovieCatalog {
    // ...
}
```

```java
@Component
@Offline
public class CachingMovieCatalog implements MovieCatalog {
    // ...
}
```

> 与大多数基于注解的替代方案一样，请记住，注解元数据绑定到类定义本身，而 XML 的使用允许同一类型的多个 bean 在其限定符元数据中提供变化，因为该元数据是按实例而不是按类提供的。

### 1.10.9 生成候选组件的索引

虽然类路径扫描非常快，但通过在编译时创建候选的静态列表，可以提高大型应用程序的启动性能。在此模式下，作为组件扫描目标的所有模块都必须使用此机制。

> 您现有的 `@ComponentScan` 或 `<context:component-scan/>` 指令必须保持不变，才能请求上下文扫描某些包中的候选项。当 `ApplicationContext` 检测到这样的索引时，它会自动使用它，而不是扫描类路径。

要生成索引，请向包含组件扫描指令目标的组件的每个模块添加一个附加依赖项。以下示例显示了如何使用 Maven 执行此操作：

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context-indexer</artifactId>
        <version>6.0.4</version>
        <optional>true</optional>
    </dependency>
</dependencies>
```

对于 Gradle 4.5 及更低版本，应在 `compileOnly` 配置中声明依赖项，如下例所示：

```groovy
dependencies {
    compileOnly "org.springframework:spring-context-indexer:6.0.4"
}
```

对于 Gradle 4.6 及更高版本，应在 `annotationProcessor` 配置中声明依赖关系，如下例所示：

```groovy
dependencies {
    annotationProcessor "org.springframework:spring-context-indexer:6.0.4"
}
```

`spring-context-indexer` 工件生成包含在 jar 文件中的 `META-INF/spring.components` 文件。

> 在 IDE 中使用此模式时，必须将 `spring-context-indexer` 注册为注解处理器，以确保在更新候选组件时索引是最新的。

> 当在类路径上找到 `META-INF/spring.components` 文件时，索引将自动启用。如果索引部分可用于某些库（或用例），但无法为整个应用程序构建，则可以通过将 `spring.index.ignore` 设置为 `true`（作为 JVM 系统属性或通过 `SpringProperties` 机制），返回到常规的类路径排列（就好像根本不存在索引一样）。

## 1.11 使用 JSR 330 标准注解

从 Spring 3.0 开始，Spring 支持 JSR-330 标准注解（依赖注入）。这些注解的扫描方式与 Spring 注解相同。要使用它们，您需要在类路径中有相关的 jar。

> 如果您使用 Maven，`jakarta.inject` 工件在标准 Maven 存储库（https://repo1.maven.org/maven2/jakarta/inject/jakarta.inject-api/2.0.0/). 您可以将以下依赖项添加到文件 pom.xml中：
>
> ```xml
> <dependency>
>     <groupId>jakarta.inject</groupId>
>     <artifactId>jakarta.inject-api</artifactId>
>     <version>1</version>
> </dependency>
> ```

### 1.11.1 使用 @Inject 和 @Named 依赖注入

您可以使用 `@jakarta.inject.Inject` 代替 `@Autowired`，如下所示：

```java
import jakarta.inject.Inject;

public class SimpleMovieLister {

    private MovieFinder movieFinder;

    @Inject
    public void setMovieFinder(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    public void listMovies() {
        this.movieFinder.findMovies(...);
        // ...
    }
}
```

与 `@Autowired` 一样，您可以在字段级、方法级和构造函数参数级使用 `@Inject`。此外，您可以将注入点声明为 `Provider`，允许按需访问较短范围的 bean，或者通过 `Provider.get()` 调用延迟访问其他 bean。以下示例提供了上一示例的变体：

```java
import jakarta.inject.Inject;
import jakarta.inject.Provider;

public class SimpleMovieLister {

    private Provider<MovieFinder> movieFinder;

    @Inject
    public void setMovieFinder(Provider<MovieFinder> movieFinder) {
        this.movieFinder = movieFinder;
    }

    public void listMovies() {
        this.movieFinder.get().findMovies(...);
        // ...
    }
}
```

如果要为应该注入的依赖项使用限定名，则应使用 `@Named` 注解，如下例所示：

```java
import jakarta.inject.Inject;
import jakarta.inject.Named;

public class SimpleMovieLister {

    private MovieFinder movieFinder;

    @Inject
    public void setMovieFinder(@Named("main") MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // ...
}
```

与 `@Autowired` 一样，`@Inject` 也可以与 `java.util.Optional` 或 `@Nullable` 一起使用。这在这里更适用，因为 `@Inject` 没有必需的属性。以下两个示例显示了如何使用 `@Inject` 和 `@Nullable`：

```java
public class SimpleMovieLister {

    @Inject
    public void setMovieFinder(Optional<MovieFinder> movieFinder) {
        // ...
    }
}
```

```java
public class SimpleMovieLister {

    @Inject
    public void setMovieFinder(@Nullable MovieFinder movieFinder) {
        // ...
    }
}
```

### 1.11.2 @Named 和 @ManagedBean：@Component 注解的标准等价物

您可以使用 `@jakarta.inject.Name` 或 `jakarta.notation.ManagedBean` 代替 `@Component`，如下例所示：

```java
import jakarta.inject.Inject;
import jakarta.inject.Named;

@Named("movieListener")  // @ManagedBean("movieListener") could be used as well
public class SimpleMovieLister {

    private MovieFinder movieFinder;

    @Inject
    public void setMovieFinder(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // ...
}
```

在不指定组件名称的情况下使用 `@Component` 是非常常见的。`@Named` 可以以类似的方式使用，如下例所示：

```java
import jakarta.inject.Inject;
import jakarta.inject.Named;

@Named
public class SimpleMovieLister {

    private MovieFinder movieFinder;

    @Inject
    public void setMovieFinder(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // ...
}
```

使用 `@Named` 或 `@ManagedBean` 时，可以使用与使用 Spring 注解时完全相同的方式使用组件扫描，如下例所示：

```java
@Configuration
@ComponentScan(basePackages = "org.example")
public class AppConfig  {
    // ...
}
```

> 与 `@Component` 不同，JSR-330 `@Named` 和 JSR-250 `@ManagedBean` 注解是不可组合的。您应该使用 Spring 的传统模式模型来构建自定义组件注解。

### 1.11.3 JSR-330 标准注解的限制

使用标准注解时，应该知道一些重要功能不可用，如下表所示：

| Spring              | jakarta.inject.*      | jakarta.inject 限制 / 解释                                   |
| :------------------ | :-------------------- | :----------------------------------------------------------- |
| @Autowired          | @Inject               | `@Inject` 没有 'required' 属性。作为替代，可以和 Java 8 的 `Optional` 一起使用. |
| @Component          | @Named / @ManagedBean | JSR-330 并不提供可组合模型，只是确认命名组件的方式。         |
| @Scope("singleton") | @Singleton            | JSR-330 默认作用域类似于 Spring 的 `prototype`。然而，为了使其与 Spring 的一般默认值保持一致，Spring 容器中声明的 JSR-330 bean 默认为 `singleton` 。为了使用 `singleton` 以外的作用域，应该使用 Spring 的 `@Scope` 注解。`jakarta.inject` 还提供了一个 `jakarta.iject.Scope` 注解：然而，这个注解仅用于创建自定义注解。 |
| @Qualifier          | @Qualifier / @Named   | `jakarta.inject.Qualifier` 只是用于构建自定义限定符的元注解。具体的 `String` 限定符（如 Spring 的带值的 `@Qualifier`）可以通过 `jakarta.inject.Named` 关联。 |
| @Value              | -                     | 没有等价物                                                   |
| @Lazy               | -                     | 没有等价物                                                   |
| ObjectFactory       | Provider              | `jakarta.inject.Provider` 是 Spring 的 `ObjectFactory` 的直接替代品，只是使用了更短的 `get()` 方法名。它还可以与 Spring 的 `@Autowired` 或非注解构造函数和 setter 方法结合使用。 |

## 1.12 基于 Java 的容器配置

本节介绍如何在 Java 代码中使用注解来配置 Spring 容器。它包括以下主题：

- 基本概念：`@Bean` 和 `@Configuration`
- 使用 `AnnotationConfigApplicationContext` 实例化 Spring 容器
- 使用 `@Bean` 注解
- 使用 `@Configuration` 注解
- 合成基于 Java 的配置
- Bean 定义配置文件
- `PropertySource` 摘要
- 使用 `@PropertySource`
- 语句中的占位符解析

### 1.12.1 基本概念：@Bean 和 @Configuration

Spring 的 Java 配置支持中的核心工件是 `@Configuration` 注解类和 `@Bean` 注解方法。

`@Bean` 注解用于指示方法实例化、配置和初始化要由 Spring IoC 容器管理的新对象。对于熟悉 Spring 的 `<beans/>` XML 配置的人来说，`@Bean` 注解扮演着与 `<Bean/>` 元素相同的角色。您可以在任何 Spring `@Component` 中使用 `@Bean` 注解方法。然而，它们最常用于 `@Configuration` bean。

用 `@Configuration` 注解类表明它的主要目的是作为 bean 定义的源。此外，`@Configuration` 类允许通过调用同一类中的其他 `@Bean` 方法来定义 bean 之间的依赖关系。最简单的 `@Configuration` 类如下：

```java
@Configuration
public class AppConfig {

    @Bean
    public MyService myService() {
        return new MyServiceImpl();
    }
}
```

前面的 `AppConfig` 类等效于下面的 Spring `<beans/>` XML：

```xml
<beans>
    <bean id="myService" class="com.acme.services.MyServiceImpl"/>
</beans>
```

> **完整 @Configuration vs “lite” @Bean 模式？**
>
> 当 `@Bean` 方法在没有 `@Configuration` 注解的类中声明时，它们被称为以“lite”模式处理。在 `@Component` 中或者甚至在普通的旧类中声明的 Bean 方法被认为是“lite”，其中包含类的主要目的不同，`@Bean` 方法是一种好处。例如，服务组件可以通过每个适用组件类上的附加 `@Bean` 方法向容器公开管理视图。在这种情况下，`@Bean` 方法是一种通用的工厂方法机制。
>
> 与完整的 `@Configuration` 不同，lite `@Bean` 方法不能声明 Bean 间依赖关系。相反，它们对其包含组件的内部状态进行操作，也可以对它们可能声明的参数进行操作。因此，此类 `@Bean` 方法不应调用其他 `@Bean` 方法。每个这样的方法实际上只是特定 bean 引用的工厂方法，没有任何特殊的运行时语义。这里的积极副作用是，在运行时不必应用 CGLIB 子类化，因此在类设计方面没有任何限制（即，包含类可能是 `final` 等等）。
>
> 在常见的场景中，`@Bean` 方法将在 `@Configuration` 类中声明，确保始终使用“完全”模式，因此跨方法引用将被重定向到容器的生命周期管理。这可以防止通过常规 Java 调用意外调用同一 `@Bean` 方法，这有助于减少在“lite”模式下操作时难以跟踪的细微错误。

`@Bean` 和 `@Configuration` 注解将在以下章节中深入讨论。然而，首先，我们将介绍通过使用基于 Java 的配置创建 Spring 容器的各种方法。

### 1.12.2 使用 AnnotationConfigApplicationContext 实例化 Spring 容器

以下部分记录了 Spring 3.0 中引入的 Spring 的 `AnnotationConfigApplicationContext`。这个通用的 `ApplicationContext` 实现不仅能够接受 `@Configuration` 类作为输入，还能够接受普通的 `@Component` 类和用 JSR-330 元数据注解的类。

当 `@Configuration` 类作为输入提供时，`@Configuration` 类本身被注册为 bean 定义，并且类中所有声明的 `@Bean` 方法也被注册为 bean 定义。

当提供 `@Component` 和 JSR-330 类时，它们被注册为 bean 定义，并且假设在这些类中使用了 DI 元数据，如 `@Autowired` 或 `@Inject`。

#### 简单构造

与 Spring XML 文件在实例化 `ClassPathXmlApplicationContext` 时用作输入的方式大致相同，您可以在实例化 `AnnotationConfigApplicationContext` 时使用 `@Configuration` 类作为输入。这允许完全无 XML 地使用 Spring 容器，如下例所示：

```java
public static void main(String[] args) {
    ApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);
    MyService myService = ctx.getBean(MyService.class);
    myService.doStuff();
}
```

如前所述，`AnnotationConfigApplicationContext` 不限于仅使用 `@Configuration` 类。任何 `@Component` 或 JSR-330 注解类都可以作为构造函数的输入提供，如下例所示：

```java
public static void main(String[] args) {
    ApplicationContext ctx = new AnnotationConfigApplicationContext(MyServiceImpl.class, Dependency1.class, Dependency2.class);
    MyService myService = ctx.getBean(MyService.class);
    myService.doStuff();
}
```

前面的示例假设 `MyServiceImpl`、`Dependency1` 和 `Dependency2` 使用 Spring 依赖注入注解，例如 `@Autowired`。

#### 使用 register(Class<?> ...) 编程式构建容器

可以使用无参数构造函数实例化 `AnnotationConfigApplicationContext`，然后使用 `register()` 方法对其进行配置。当以编程方式构建 `AnnotationConfigApplicationContext` 时，这种方法特别有用。以下示例显示了如何执行此操作：

```java
public static void main(String[] args) {
    AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
    ctx.register(AppConfig.class, OtherConfig.class);
    ctx.register(AdditionalConfig.class);
    ctx.refresh();
    MyService myService = ctx.getBean(MyService.class);
    myService.doStuff();
}
```

#### 使用 scan(String ...) 启动组件扫描

要启用组件扫描，可以按如下方式注解 `@Configuration` 类：

```java
@Configuration
@ComponentScan(basePackages = "com.acme") (1)
public class AppConfig  {
    // ...
}
```

> 有经验的 Spring 用户可能熟悉 Spring 的 `context:` 命名空间中的 XML 声明，如下例所示：
>
> ```xml
> <beans>
>     <context:component-scan base-package="com.acme"/>
> </beans>
> ```

在前面的示例中，扫描 `com.acme` 包以查找任何 `@Component` 注解类，这些类在容器中注册为 Spring bean 定义。`AnnotationConfigApplicationContext` 公开 `scan(String ...)` 方法来实现相同的组件扫描功能，如下例所示：

```java
public static void main(String[] args) {
    AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
    ctx.scan("com.acme");
    ctx.refresh();
    MyService myService = ctx.getBean(MyService.class);
}
```

> 请记住，`@Configuration` 类是用 `@Component` 进行元注解的，因此它们是组件扫描的候选对象。在前面的示例中，假设 `AppConfig` 是在 `com.acme` 包（或其下的任何包）中声明的，它在调用 `scan()` 时被获取。在 `refresh()` 之后，它的所有 `@Bean` 方法都被处理并注册为容器中的 Bean 定义。

#### 使用 AnnotationConfigWebApplicationContext 支持 Web 应用

`AnnotationConfigApplicationContext` 的 `WebApplicationContext` 变体可与 `AnnotationConfigWebApplicationContext` 一起使用。配置 Spring `ContextLoaderListener` servlet 监听器、Spring MVC `DispatcherServlet` 等时，可以使用此实现。以下 `web.xml` 片段配置了一个典型的 Spring MVC web 应用程序（注意使用 `contextClass` context-param 和 init-param）：

```xml
<web-app>
    <!-- Configure ContextLoaderListener to use AnnotationConfigWebApplicationContext
        instead of the default XmlWebApplicationContext -->
    <context-param>
        <param-name>contextClass</param-name>
        <param-value>
            org.springframework.web.context.support.AnnotationConfigWebApplicationContext
        </param-value>
    </context-param>

    <!-- Configuration locations must consist of one or more comma- or space-delimited
        fully-qualified @Configuration classes. Fully-qualified packages may also be
        specified for component-scanning -->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>com.acme.AppConfig</param-value>
    </context-param>

    <!-- Bootstrap the root application context as usual using ContextLoaderListener -->
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <!-- Declare a Spring MVC DispatcherServlet as usual -->
    <servlet>
        <servlet-name>dispatcher</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <!-- Configure DispatcherServlet to use AnnotationConfigWebApplicationContext
            instead of the default XmlWebApplicationContext -->
        <init-param>
            <param-name>contextClass</param-name>
            <param-value>
                org.springframework.web.context.support.AnnotationConfigWebApplicationContext
            </param-value>
        </init-param>
        <!-- Again, config locations must consist of one or more comma- or space-delimited
            and fully-qualified @Configuration classes -->
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>com.acme.web.MvcConfig</param-value>
        </init-param>
    </servlet>

    <!-- map all requests for /app/* to the dispatcher servlet -->
    <servlet-mapping>
        <servlet-name>dispatcher</servlet-name>
        <url-pattern>/app/*</url-pattern>
    </servlet-mapping>
</web-app>
```

> 对于编程用例，可以使用 `GenericWebApplicationContext` 作为 `AnnotationConfigWebApplicationContext` 的替代方案。有关详细信息，请参阅 `GenericWebApplicationContext` Javadoc。

### 1.12.3 使用 @Bean 注解

`@Bean` 是一个方法级注解，是 XML `<Bean/>` 元素的直接模拟。注解支持 `<bean/>` 提供的一些属性，例如：

- 初始化方法
- 销毁方法
- 自动装配
- `name`

您可以在 `@Configuration` 注解类或 `@Component` 注解类中使用 `@Bean` 注解。

#### 声明 Bean

要声明 bean，可以使用 @Bean 注解注解方法。使用此方法在 `ApplicationContext` 中注册 bean 定义，该定义的类型指定为方法的返回值。默认情况下，bean 名称与方法名称相同。以下示例显示了 `@Bean` 方法声明：

```java
@Configuration
public class AppConfig {

    @Bean
    public TransferServiceImpl transferService() {
        return new TransferServiceImpl();
    }
}
```

前面的配置完全等同于以下 Spring XML：

```xml
<beans>
    <bean id="transferService" class="com.acme.TransferServiceImpl"/>
</beans>
```

这两个声明都使 `ApplicationContext` 中名为 `transferService` 的 bean 可用，并绑定到 `TransferServiceImpl` 类型的对象实例，如下图所示：

```
transferService -> com.acme.TransferServiceImpl
```

您还可以使用默认方法来定义 bean。这允许通过在默认方法上实现带有 bean 定义的接口来组合 bean 配置。

```java
public interface BaseConfig {

    @Bean
    default TransferServiceImpl transferService() {
        return new TransferServiceImpl();
    }
}

@Configuration
public class AppConfig implements BaseConfig {

}
```

您还可以使用接口（或基类）返回类型声明 `@Bean` 方法，如下例所示：

```java
@Configuration
public class AppConfig {

    @Bean
    public TransferService transferService() {
        return new TransferServiceImpl();
    }
}
```

然而，这将高级类型预测的可见性限制为指定的接口类型（`TransferService`）。然后，只有在实例化了受影响的单例 bean 之后，容器才知道完整类型（`TransferServiceImpl`）。非惰性单例 bean 根据其声明顺序进行实例化，因此您可能会看到不同的类型匹配结果，这取决于另一个组件何时尝试通过非声明类型进行匹配（例如 `@Autowired TransferServiceImpl`，它仅在 `transferService` bean 实例化后才解析）。

> 如果您始终通过声明的服务接口引用您的类型，那么 `@Bean` 返回类型可以安全地加入该设计决策。然而，对于实现多个接口的组件或可能由其实现类型引用的组件，更安全的做法是尽可能声明最具体的返回类型（至少与引用 bean 的注入点所要求的一样具体）。

#### Bean 依赖

`@Bean` 注解方法可以具有任意数量的参数，这些参数描述构建该 Bean 所需的依赖关系。例如，如果 `TransferService` 需要 `AccountRepository`，我们可以使用方法参数实现该依赖关系，如下例所示：

```java
@Configuration
public class AppConfig {

    @Bean
    public TransferService transferService(AccountRepository accountRepository) {
        return new TransferServiceImpl(accountRepository);
    }
}
```

解析机制与基于构造函数的依赖注入几乎相同。有关详细信息，请参阅相关章节。

#### 接受生命周期回调

使用 `@Bean` 注解定义的任何类都支持常规的生命周期回调，并且可以使用 JSR-250 中的 `@PostConstruct` 和 `@PreDestroy` 注解。有关详细信息，请参阅 JSR-250 注解。

也完全支持常规的 Spring 生命周期回调。如果 bean 实现 `InitializingBean`、`DisposableBean` 或 `Lifecycle`，则容器将调用它们各自的方法。

还完全支持标准的 `*Aware` 接口集（如 BeanFactoryAware、BeanNameAware、MessageSourceAware、ApplicationContextAware 等）。

`@Bean` 注解支持指定任意初始化和销毁回调方法，就像 Spring XML 在 `bean` 元素上的 `init-method` 和 `destroy-method` 属性一样，如下例所示：

```java
public class BeanOne {

    public void init() {
        // initialization logic
    }
}

public class BeanTwo {

    public void cleanup() {
        // destruction logic
    }
}

@Configuration
public class AppConfig {

    @Bean(initMethod = "init")
    public BeanOne beanOne() {
        return new BeanOne();
    }

    @Bean(destroyMethod = "cleanup")
    public BeanTwo beanTwo() {
        return new BeanTwo();
    }
}
```

> 默认情况下，使用 Java 配置定义的具有公共 `close` 或 `shutdown` 方法的 bean 将自动与销毁回调一起登记。如果您有一个公共 `close` 或 `shutdown` 方法，并且不希望在容器关闭时调用它，那么可以将 `@Bean(destroyMethod = "")` 添加到 Bean 定义中，以禁用默认`(inferred)`模式。
>
> 默认情况下，您可能希望对使用 JNDI 获取的资源执行此操作，因为它的生命周期在应用程序之外进行管理。特别是，确保始终为 `DataSource` 执行此操作，因为众所周知，Jakarta EE 应用程序服务器上存在问题。
>
> 以下示例显示如何防止 `DataSource` 的自动销毁回调：
>
> ```java
> @Bean(destroyMethod = "")
> public DataSource dataSource() throws NamingException {
>     return (DataSource) jndiTemplate.lookup("MyDS");
> }
> ```
>
> 此外，对于 `@Bean` 方法，通常使用编程 JNDI 查找，通过使用 Spring 的 `JndiTemplate` 或 `JndiLocatorDelegate` 助手或直接使用 JNDI `InitialContext`，而不是 `JndiObjectFactoryBean` 变量（这将迫使您将返回类型声明为 `FactoryBean` 类型，而不是实际的目标类型，从而使其更难用于其他 `@Bean` 方法中的交叉引用调用，这些方法打算引用此处提供的资源）。

对于前面注解中示例中的 `BeanOne`，在构建过程中直接调用 `init()` 方法同样有效，如下例所示：

```java
@Configuration
public class AppConfig {

    @Bean
    public BeanOne beanOne() {
        BeanOne beanOne = new BeanOne();
        beanOne.init();
        return beanOne;
    }

    // ...
}
```

> 当您直接在 Java 中工作时，您可以对对象执行任何您喜欢的操作，而不必总是依赖容器生命周期。

#### 指定 Bean 作用域

Spring 包含 `@Scope` 注解，因此您可以指定 bean 的作用域。

##### 使用 @Scope 注解

您可以指定用 `@Bean` 注解定义的 Bean 应该具有特定的范围。您可以使用“Bean 作用域”部分中指定的任何标准作用域。

默认范围是 `singleton`，但您可以使用 `@Scope` 注解覆盖它，如下例所示：

```java
@Configuration
public class MyConfiguration {

    @Bean
    @Scope("prototype")
    public Encryptor encryptor() {
        // ...
    }
}
```

##### @Scope 和 scoped-proxy

Spring 提供了一种通过作用域代理处理作用域依赖关系的便捷方式。在使用 XML 配置时创建此类代理的最简单方法是 `<aop:scoped-proxy/>` 元素。使用 `@Scope` 注释在 Java 中配置 bean 可以提供与 `proxyMode` 属性等效的支持。默认值为 `ScopedProxyMode.DEFAULT`，这通常表示不应创建作用域代理，除非在组件扫描指令级别配置了不同的默认值。可以指定 `ScopedProxyMode.TARGET_CLASS`、`ScopedProxyMode.INTERFACES` 或 `ScopedProxyMode.NO`。

如果您使用 Java 将 XML 参考文档中的作用域代理示例（请参见作用域代理）移植到 `@Bean`，它类似于以下内容：

```java
// an HTTP Session-scoped bean exposed as a proxy
@Bean
@SessionScope
public UserPreferences userPreferences() {
    return new UserPreferences();
}

@Bean
public Service userService() {
    UserService service = new SimpleUserService();
    // a reference to the proxied userPreferences bean
    service.setUserPreferences(userPreferences());
    return service;
}
```

#### 自定义 Bean 命名

默认情况下，配置类使用 `@Bean` 方法的名称作为结果 Bean 的名称。但是，可以使用 `name` 属性覆盖此功能，如下例所示：

```java
@Configuration
public class AppConfig {

    @Bean("myThing")
    public Thing thing() {
        return new Thing();
    }
}
```

#### Bean 别名

正如在命名 bean 中所讨论的，有时需要为单个 bean 提供多个名称，也称为 bean 别名。`@Bean` 注解的 `name` 属性为此目的接受 String 数组。以下示例显示如何为 bean 设置多个别名：

```java
@Configuration
public class AppConfig {

    @Bean({"dataSource", "subsystemA-dataSource", "subsystemB-dataSource"})
    public DataSource dataSource() {
        // instantiate, configure and return DataSource bean...
    }
}
```

#### Bean 描述

有时，为 bean 提供更详细的文本描述是有帮助的。当出于监控目的公开 bean（可能通过 JMX）时，这尤其有用。

要向 `@Bean` 添加描述，可以使用 `@Description` 注解，如下例所示：

```java
@Configuration
public class AppConfig {

    @Bean
    @Description("Provides a basic example of a bean")
    public Thing thing() {
        return new Thing();
    }
}
```

### 1.12.4 使用 @Configuration 注解

`@Configuration` 是一个类级注解，指示对象是 bean 定义的源。`@Configuration` 类通过 `@Bean` 注解方法声明 Bean。对 `@Configuration` 类上的 `@Bean` 方法的调用也可用于定义 Bean 间依赖关系。请参阅“基本概念：@Bean和@Configuration”了解一般介绍。

#### 注入跨 bean 依赖

当 bean 之间存在依赖关系时，表达这种依赖关系就像让一个 bean 方法调用另一个一样简单，如下例所示：

```java
@Configuration
public class AppConfig {

    @Bean
    public BeanOne beanOne() {
        return new BeanOne(beanTwo());
    }

    @Bean
    public BeanTwo beanTwo() {
        return new BeanTwo();
    }
}
```

在前面的示例中，`beanOne` 通过构造函数注入接收对 `beanTwo` 的引用。

> 只有在 `@Configuration` 类中声明 `@Bean` 方法时，这种声明 bean 间依赖关系的方法才有效。不能使用普通的 `@Component` 类声明 bean 间依赖关系。

#### 查找方法注入

如前所述，查找方法注入是一种高级功能，您应该很少使用。它在单例作用域 bean 依赖于原型作用域 bean 的情况下非常有用。将 Java 用于这种类型的配置为实现这种模式提供了一种自然的方法。以下示例显示了如何使用查找方法注入：

```java
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

通过使用 Java 配置，您可以创建 `CommandManager` 的子类，其中抽象的 `createCommand()` 方法被重写，从而查找新的（原型）命令对象。以下示例显示了如何执行此操作：

```java
@Bean
@Scope("prototype")
public AsyncCommand asyncCommand() {
    AsyncCommand command = new AsyncCommand();
    // inject dependencies here as required
    return command;
}

@Bean
public CommandManager commandManager() {
    // return new anonymous implementation of CommandManager with createCommand()
    // overridden to return a new prototype Command object
    return new CommandManager() {
        protected Command createCommand() {
            return asyncCommand();
        }
    }
}
```

#### 关于基于 Java 的配置内部如何运作的更多信息

考虑以下示例，其中显示了两次调用 `@Bean` 注解方法：

```java
@Configuration
public class AppConfig {

    @Bean
    public ClientService clientService1() {
        ClientServiceImpl clientService = new ClientServiceImpl();
        clientService.setClientDao(clientDao());
        return clientService;
    }

    @Bean
    public ClientService clientService2() {
        ClientServiceImpl clientService = new ClientServiceImpl();
        clientService.setClientDao(clientDao());
        return clientService;
    }

    @Bean
    public ClientDao clientDao() {
        return new ClientDaoImpl();
    }
}
```

`clientDao()` 在 `clientService1()` 和 `clientService2()` 中分别调用了一次。由于此方法创建了 `ClientDaoImpl` 的新实例并将其返回，因此通常需要两个实例（每个服务一个）。这肯定是有问题的：在 Spring 中，实例化的 bean 默认具有 `singleton` 作用域。这就是神奇之处：所有 `@Configuration` 类在启动时都使用 `CGLIB` 进行子类化。在子类中，子方法在调用父方法并创建新实例之前，首先检查容器中是否有任何缓存（作用域）bean。

> 根据 bean 的作用域，行为可能有所不同。我们在这里谈论的是单例。

> 从 Spring 3.2 开始，不再需要将 CGLIB 添加到类路径中，因为 CGLIB 类已在 `org.springframework.CGLIB` 下重新打包，并直接包含在 Spring 核心 JAR中。

> 由于 CGLIB 在启动时动态添加特性，因此存在一些限制。特别是，配置类不能是 final 的。但是，从 4.3 开始，配置类上允许使用任何构造函数，包括使用 `@Autowired` 或单个非默认构造函数声明进行默认注入。
>
> 如果您希望避免任何 CGLIB 强加的限制，请考虑在非 `@Configuration` 类（例如，在普通的 `@Component` 类上）。`@Bean` 方法之间的跨方法调用不会被拦截，因此您必须在构造函数或方法级别专门依赖依赖注入。

### 1.12.5 组合基于 Java 配置

Spring 基于 Java 的配置特性允许您编写注解，这可以降低配置的复杂性。

#### 使用 @Import 注解

正如 `<import/>` 元素在 Spring XML 文件中用于帮助模块化配置一样，`@Import` 注解允许从另一个配置类加载 `@Bean` 定义，如下例所示：

```java
@Configuration
public class ConfigA {

    @Bean
    public A a() {
        return new A();
    }
}

@Configuration
@Import(ConfigA.class)
public class ConfigB {

    @Bean
    public B b() {
        return new B();
    }
}
```

现在，实例化上下文时不需要同时指定 `ConfigA.class` 和 `ConfigB.class`，只需要显式提供 `ConfigB`，如下例所示：

```java
public static void main(String[] args) {
    ApplicationContext ctx = new AnnotationConfigApplicationContext(ConfigB.class);

    // now both beans A and B will be available...
    A a = ctx.getBean(A.class);
    B b = ctx.getBean(B.class);
}
```

这种方法简化了容器实例化，因为只需要处理一个类，而不需要在构造过程中记住大量的 `@Configuration` 类。

> 从 Spring Framework 4.2 开始，`@Import` 还支持对常规组件类的引用，类似于 `AnnotationConfigApplicationContext.register` 方法。如果您想避免组件扫描，这是非常有用的，通过使用一些配置类作为入口点来显式定义所有组件。

##### 在导入 @Bean 定义中注入依赖

前面的示例有效，但过于简单。在大多数实际场景中，bean 在配置类之间相互依赖。当使用 XML 时，这不是一个问题，因为不涉及编译器，您可以声明 `ref="someBean"` 并信任 Spring 在容器初始化期间解决它。当使用 `@Configuration` 类时，Java 编译器对配置模型施加约束，因为对其他 bean 的引用必须是有效的 Java 语法。

幸运的是，解决这个问题很简单。正如我们已经讨论过的，`@Bean` 方法可以有任意数量的参数来描述 Bean 依赖关系。考虑以下具有多个 `@Configuration` 类的更真实的场景，每个类都取决于其他类中声明的 bean：

```java
@Configuration
public class ServiceConfig {

    @Bean
    public TransferService transferService(AccountRepository accountRepository) {
        return new TransferServiceImpl(accountRepository);
    }
}

@Configuration
public class RepositoryConfig {

    @Bean
    public AccountRepository accountRepository(DataSource dataSource) {
        return new JdbcAccountRepository(dataSource);
    }
}

@Configuration
@Import({ServiceConfig.class, RepositoryConfig.class})
public class SystemTestConfig {

    @Bean
    public DataSource dataSource() {
        // return new DataSource
    }
}

public static void main(String[] args) {
    ApplicationContext ctx = new AnnotationConfigApplicationContext(SystemTestConfig.class);
    // everything wires up across configuration classes...
    TransferService transferService = ctx.getBean(TransferService.class);
    transferService.transfer(100.00, "A123", "C456");
}
```

还有另一种方法可以达到同样的结果。请记住，`@Configuration` 类最终只是容器中的另一个 bean：这意味着它们可以利用 `@Autowired` 和 `@Value` 注入以及与任何其他 bean 相同的其他特性。

> 确保以这种方式注入的依赖关系仅是最简单的类型。`@Configuration` 类在上下文初始化期间很早就被处理，强制以这种方式注入依赖项可能会导致意外的早期初始化。如前所述，尽可能采用基于参数的注入。
>
> 此外，通过 `@Bean` 对 `BeanPostProcessor` 和 `BeanFactoryPostProcessor` 的定义要特别小心。这些方法通常应声明为 `static @Bean` 方法，而不会触发其包含的配置类的实例化。否则，`@Autowired` 和 `@Value` 可能无法在配置类本身上工作，因为可以将其创建为早于 `AutowiredAnnotationBeanPostProcessor` 的 bean 实例。

以下示例显示了如何将一个 bean 自动装配到另一个 bean：

```java
@Configuration
public class ServiceConfig {

    @Autowired
    private AccountRepository accountRepository;

    @Bean
    public TransferService transferService() {
        return new TransferServiceImpl(accountRepository);
    }
}

@Configuration
public class RepositoryConfig {

    private final DataSource dataSource;

    public RepositoryConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Bean
    public AccountRepository accountRepository() {
        return new JdbcAccountRepository(dataSource);
    }
}

@Configuration
@Import({ServiceConfig.class, RepositoryConfig.class})
public class SystemTestConfig {

    @Bean
    public DataSource dataSource() {
        // return new DataSource
    }
}

public static void main(String[] args) {
    ApplicationContext ctx = new AnnotationConfigApplicationContext(SystemTestConfig.class);
    // everything wires up across configuration classes...
    TransferService transferService = ctx.getBean(TransferService.class);
    transferService.transfer(100.00, "A123", "C456");
}
```

> `@Configuration` 类中的构造函数注入仅从 Spring Framework 4.3 开始受支持。还要注意，如果目标 bean 只定义了一个构造函数，则不需要指定 `@Autowired`。

在前面的场景中，使用 `@Autowired` 可以很好地工作，并提供所需的模块化，但确定自动装配 bean 定义的确切声明位置仍然有些模糊。例如，作为一名查看 `ServiceConfig` 的开发人员，您如何确切地知道 `@Autowired AccountRepository` bean 的声明位置？它在代码中并不明确，这可能很好。请记住，Spring Tools for Eclipse 提供了一种工具，可以渲染显示所有内容如何装配的图形，这可能就是您所需要的。此外，Java IDE 可以轻松找到 `AccountRepository` 类的所有声明和用法，并快速显示返回该类型的 `@Bean` 方法的位置。

如果这种模糊性是不可接受的，并且您希望在 IDE 中从一个 `@Configuration` 类直接导航到另一个，请考虑自动装配配置类本身。以下示例显示了如何执行此操作：

```java
@Configuration
public class ServiceConfig {

    @Autowired
    private RepositoryConfig repositoryConfig;

    @Bean
    public TransferService transferService() {
        // navigate 'through' the config class to the @Bean method!
        return new TransferServiceImpl(repositoryConfig.accountRepository());
    }
}
```

在前面的情况中，`AccountRepository` 的定义是完全明确的。但是，`ServiceConfig` 现在与 `RepositoryConfig` 紧密耦合。这就是权衡。通过使用基于接口或基于抽象类的 `@Configuration` 类，可以稍微减轻这种紧密耦合。考虑以下示例：

```java
@Configuration
public class ServiceConfig {

    @Autowired
    private RepositoryConfig repositoryConfig;

    @Bean
    public TransferService transferService() {
        return new TransferServiceImpl(repositoryConfig.accountRepository());
    }
}

@Configuration
public interface RepositoryConfig {

    @Bean
    AccountRepository accountRepository();
}

@Configuration
public class DefaultRepositoryConfig implements RepositoryConfig {

    @Bean
    public AccountRepository accountRepository() {
        return new JdbcAccountRepository(...);
    }
}

@Configuration
@Import({ServiceConfig.class, DefaultRepositoryConfig.class})  // import the concrete config!
public class SystemTestConfig {

    @Bean
    public DataSource dataSource() {
        // return DataSource
    }

}

public static void main(String[] args) {
    ApplicationContext ctx = new AnnotationConfigApplicationContext(SystemTestConfig.class);
    TransferService transferService = ctx.getBean(TransferService.class);
    transferService.transfer(100.00, "A123", "C456");
}
```

现在，`ServiceConfig` 与具体的 `DefaultRepositoryConfig` 松散耦合，内置的 IDE 工具仍然很有用：您可以轻松获得 `RepositoryConfig` 实现的类型层次结构。通过这种方式，导航 `@Configuration` 类及其依赖项与导航基于接口的代码的通常过程没有什么不同。

> 如果您想影响某些 bean 的启动创建顺序，请考虑将其中一些 bean 声明为 `@Lazy`（用于在首次访问时创建，而不是在启动时创建）或 `@DependsOn` 某些其他 bean（确保在当前 bean 之前创建特定的其他 bean，而不是后者的直接依赖关系）。

#### 有条件的引入 @Configuration 类或 @Bean 方法

根据某些任意的系统状态，有条件地启用或禁用完整的 `@Configuration` 类或甚至单个 `@Bean` 方法通常很有用。一个常见的例子是，只有在 Spring 环境中启用了特定 profile 时，才使用 `@Profile` 注解来激活 Bean（有关详细信息，请参阅 “Bean 定义 Profiles”）。

`@Profile` 注解实际上是通过使用一个更加灵活的注解 `@Conditional` 实现的。`@Conditional` 注解指示在注册 `@Bean` 之前应咨询的特定 `org.springframework.context.annotation.Condition` 实现。

`Condition` 接口的实现提供了 `matches(...)` 返回 `true` 或 `false` 的方法。例如，以下列表显示了 `@Profile` 使用的实际 `Condition` 实现：

```java
@Override
public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
    // Read the @Profile annotation attributes
    MultiValueMap<String, Object> attrs = metadata.getAllAnnotationAttributes(Profile.class.getName());
    if (attrs != null) {
        for (Object value : attrs.get("value")) {
            if (context.getEnvironment().acceptsProfiles(((String[]) value))) {
                return true;
            }
        }
        return false;
    }
    return true;
}
```

参考 `@Conditional` javadoc 来获取细节

#### 组合 Java 和 XML 配置

Spring 的 `@Configuration` 类支持并不旨在 100% 完全替代 Spring XML。一些设施（如 Spring XML 命名空间）仍然是配置容器的理想方式。在 XML 方便或必要的情况下，您可以选择：要么使用 `ClassPathXmlApplicationContext` 以“以 XML 为中心”的方式实例化容器，要么使用 `AnnotationConfigApplicationContext` 和 `@ImportResource` 注解以“以 Java 为中心”方式实例化容器以根据需要导入 XML。

##### 以 XML 为中心使用 @Configuration 类

最好从 XML 中引导 Spring 容器，并以特殊方式包含 `@Configuration` 类。例如，在使用 Spring XML 的大型现有代码库中，根据需要创建 `@Configuration` 类并从现有的 XML 文件中包含这些类更容易。在本节后面，我们将介绍在这种“以 XML 为中心”的情况下使用 `@Configuration` 类的选项。

**将 `@Configuration` 类声明为纯 Spring `<bean/>` 元素**

请记住，`@Configuration` 类最终是容器中的 bean 定义。在本系列示例中，我们创建了一个名为 `AppConfig` 的 `@Configuration` 类，并将其作为 `<bean/>` 定义包含在 `system-test-config.xml` 中。由于 `<context:annotation-config/>` 已打开，容器识别 `@Configuration` 注解并正确处理 `AppConfig` 中声明的 `@Bean` 方法。

以下示例显示了 Java 中的一个普通配置类：

```java
@Configuration
public class AppConfig {

    @Autowired
    private DataSource dataSource;

    @Bean
    public AccountRepository accountRepository() {
        return new JdbcAccountRepository(dataSource);
    }

    @Bean
    public TransferService transferService() {
        return new TransferService(accountRepository());
    }
}
```

以下示例显示了示例 `system-test-config.xml` 文件的一部分：

```xml
<beans>
    <!-- enable processing of annotations such as @Autowired and @Configuration -->
    <context:annotation-config/>
    <context:property-placeholder location="classpath:/com/acme/jdbc.properties"/>

    <bean class="com.acme.AppConfig"/>

    <bean class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
    </bean>
</beans>
```

以下示例显示了可能的 `jdbc.properties` 文件：

```properties
jdbc.url=jdbc:hsqldb:hsql://localhost/xdb
jdbc.username=sa
jdbc.password=
```

```java
public static void main(String[] args) {
    ApplicationContext ctx = new ClassPathXmlApplicationContext("classpath:/com/acme/system-test-config.xml");
    TransferService transferService = ctx.getBean(TransferService.class);
    // ...
}
```

> 在 `system-test-config.xml` 文件中，`AppConfig` `<bean/>` 没有声明 id 元素。虽然这样做是可以接受的，但这是不必要的，因为没有其他 bean 引用过它，而且它不太可能通过名称从容器中显式获取。类似地，`DataSource` bean 只按类型自动装配，因此不严格要求显式 bean `id`。

**使用 `<context:component-scan/>` 获取 `@Configuration` 类**

因为 `@Configuration` 是用 `@Component` 元注解的，`@Configuration` 注解的类自动成为组件扫描的候选类。使用与前面示例中描述的相同场景，我们可以重新定义 `system-test-config.xml` 以利用组件扫描。注意，在这种情况下，我们不需要显式声明 `<context:annotation-config/>`，因为 `<context:component-scan/>` 支持相同的功能。

以下示例显示了修改后的 `system-test-config.xml` 文件：

```xml
<beans>
    <!-- picks up and registers AppConfig as a bean definition -->
    <context:component-scan base-package="com.acme"/>
    <context:property-placeholder location="classpath:/com/acme/jdbc.properties"/>

    <bean class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
    </bean>
</beans>
```

##### 以 @Configuration 类为中心通过 @ImportResource 使用 XML

在 `@Configuration` 类是配置容器的主要机制的应用程序中，仍然可能需要至少使用一些 XML。在这些场景中，您可以使用 `@ImportResource`，只定义所需的 XML。这样做实现了“以 Java 为中心”的容器配置方法，并将 XML 保持在最低限度。以下示例（包括配置类、定义 bean 的 XML 文件、财产文件和 `main` 类）显示了如何使用 `@ImportResource` 注解实现“以 Java 为中心”的配置，该配置根据需要使用 XML：

```java
@Configuration
@ImportResource("classpath:/com/acme/properties-config.xml")
public class AppConfig {

    @Value("${jdbc.url}")
    private String url;

    @Value("${jdbc.username}")
    private String username;

    @Value("${jdbc.password}")
    private String password;

    @Bean
    public DataSource dataSource() {
        return new DriverManagerDataSource(url, username, password);
    }
}
```

```xml
properties-config.xml
<beans>
    <context:property-placeholder location="classpath:/com/acme/jdbc.properties"/>
</beans>
```

```properties
jdbc.properties
jdbc.url=jdbc:hsqldb:hsql://localhost/xdb
jdbc.username=sa
jdbc.password=
```

```java
public static void main(String[] args) {
    ApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);
    TransferService transferService = ctx.getBean(TransferService.class);
    // ...
}
```

## 1.13 环境抽象

`Environment` 接口是集成在容器中的抽象，它对应用程序环境的两个关键方面进行建模：profiles 和 properties。

Profile 是一个命名的、逻辑的 bean 定义组，只有当给定的 profile 处于活动状态时才能向容器注册。bean 可以分配给一个 profile，无论是用 XML 定义的还是用注解定义的。`Environment` 对象相对于配置文件的作用是确定哪些配置文件（如果有）当前处于活动状态，以及默认情况下哪些配置文件应处于活动状态。

Properties 在几乎所有应用程序中都扮演着重要角色，它可能来自多种来源：属性文件、JVM 系统属性、系统环境变量、JNDI、servlet 上下文参数、点对点（ad-hoc） `Properties` 对象、`Map` 对象等等。与属性相关的 `Environment` 对象的作用是为用户提供一个方便的服务接口，用于配置属性源并从中解析属性。

### 1.13.1 Bean 定义 Profile

Bean 定义 profile 在核心容器中提供了一种机制，允许在不同环境中注册不同的 Bean。“环境”这个词对不同的用户来说可能意味着不同的东西，这个特性可以帮助处理许多用例，包括：

- 在开发中使用内存中的数据源，而不是在 QA 或生产中从 JNDI 中查找相同的数据源。
- 仅在将应用程序部署到性能环境中时注册监视基础结构。
- 为客户 A 和客户 B 部署注册 bean 的定制实现。

考虑需要 `DataSource` 的实际应用程序中的第一个用例。在测试环境中，配置可能类似于以下内容：

```java
@Bean
public DataSource dataSource() {
    return new EmbeddedDatabaseBuilder()
        .setType(EmbeddedDatabaseType.HSQL)
        .addScript("my-schema.sql")
        .addScript("my-test-data.sql")
        .build();
}
```

现在考虑如何将此应用程序部署到 QA 或生产环境中，假设应用程序的数据源已注册到生产应用程序服务器的 JNDI 目录中。我们的 `dataSource` bean 现在看起来如下所示：

```java
@Bean(destroyMethod = "")
public DataSource dataSource() throws Exception {
    Context ctx = new InitialContext();
    return (DataSource) ctx.lookup("java:comp/env/jdbc/datasource");
}
```

问题是如何根据当前环境在使用这两种变体之间进行切换。随着时间的推移，Spring 用户设计了许多方法来实现这一点，通常依赖于系统环境变量和包含 `${placeholder}` 标记的XML `<import/>` 语句的组合，这些标记根据环境变量的值解析为正确的配置文件路径。Bean定义概要文件是一个核心容器特性，它为这个问题提供了解决方案。

如果我们概括前面特定于环境的 bean 定义示例中所示的用例，那么我们最终需要在某些上下文中注册某些 bean 定义，而不是在其他上下文中注册。您可以说，您希望在情况 A 中注册 bean 定义的特定 profile，在情况 B 中注册不同的概要文件。我们首先更新配置以反映这一需要。

#### 使用 @Profile

`@Profile` 注解允许您在一个或多个指定的配置文件处于活动状态时指示组件符合注册条件。使用前面的示例，我们可以如下重写 `dataSource` 配置：

```java
@Configuration
@Profile("development")
public class StandaloneDataConfig {

    @Bean
    public DataSource dataSource() {
        return new EmbeddedDatabaseBuilder()
            .setType(EmbeddedDatabaseType.HSQL)
            .addScript("classpath:com/bank/config/sql/schema.sql")
            .addScript("classpath:com/bank/config/sql/test-data.sql")
            .build();
    }
}
```

```java
@Configuration
@Profile("production")
public class JndiDataConfig {

    @Bean(destroyMethod = "") (1)
    public DataSource dataSource() throws Exception {
        Context ctx = new InitialContext();
        return (DataSource) ctx.lookup("java:comp/env/jdbc/datasource");
    }
}

// (1) `@Bean(destroyMethod = "")` 取消了默认销毁方法推断
```

> 如前所述，对于 `@Bean` 方法，您通常选择使用编程 JNDI 查找，方法是使用 Spring 的 `JndiTemplate`/`JndiLocatorDelegate` 助手或前面显示的直接 JNDI `InitialContext` 用法，而不是 `JndiObjectFactoryBean` 变量，这将迫使您将返回类型声明为 `FactoryBean` 类型。

配置文件字符串可以包含简单的配置文件名称（例如，`production`）或配置文件表达式。配置文件表达式允许表达更复杂的配置文件逻辑（例如 `production & us-east`）。配置文件表达式中支持以下运算符：

- `!`：一个 profile 的逻辑 `NOT`
- `&`：一个 profile 的逻辑 `AND`
- `|`：一个 profile 的逻辑 `OR`

> 如果不使用括号，则不能混合使用 `&` 和 `|` 运算符。例如，`production & us-east | eu-central`不是有效的表达式。它必须表示为 `production & (us-east | eu-central)`。

您可以使用 `@Profile` 作为元注解来创建自定义组合注解。以下示例定义了一个自定义的 `@Production` 注解，您可以将其用作 `@Profile("production")` 的插入替换：

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Profile("production")
public @interface Production {
}
```

> 如果 `@Configuration` 类标记为 `@Profile`，则所有与该类关联的 `@Bean` 方法和 `@Import` 注解都将被忽略，除非一个或多个指定的配置文件处于活动状态。如果 `@Component` 或 `@Configuration` 类标记为 `@Profile({"p1", "p2"})`，则除非配置文件“p1”或“p2”已激活，否则不会注册或处理该类。如果给定的配置文件前缀为 NOT 运算符（`!`），则仅当该配置文件处于非活动状态时，才会注册带注解的元素。例如，给定 `@Profile({"p1", "!p2"})`，如果配置文件“p1”处于活动状态或配置文件“p2”未处于活动状态，则会发生注册。

`@Profile` 也可以在方法级别声明为只包含配置类的一个特定 bean（例如，对于特定 bean 的替代变体），如下例所示：

```java
@Configuration
public class AppConfig {

    @Bean("dataSource")
    @Profile("development") (1)
    public DataSource standaloneDataSource() {
        return new EmbeddedDatabaseBuilder()
            .setType(EmbeddedDatabaseType.HSQL)
            .addScript("classpath:com/bank/config/sql/schema.sql")
            .addScript("classpath:com/bank/config/sql/test-data.sql")
            .build();
    }

    @Bean("dataSource")
    @Profile("production") (2)
    public DataSource jndiDataSource() throws Exception {
        Context ctx = new InitialContext();
        return (DataSource) ctx.lookup("java:comp/env/jdbc/datasource");
    }
}

// (1) `standaloneDataSource` 方法仅在 `development` profile 可用
// (2) `jndiDataSource` 方法仅在 `production` profile 可用
```

> 在 `@Bean` 方法上使用 `@Profile` 时，可能会出现一种特殊情况：在重载具有相同 Java 方法名称的 `@Bean` 方法的情况下（类似于构造函数重载），需要在所有重载方法上一致声明 `@Profile` 条件。如果条件不一致，只有重载方法中第一个声明的条件才重要。因此，`@Profile` 不能用于选择具有特定参数签名的重载方法。同一 bean 的所有工厂方法之间的解析在创建时遵循 Spring 的构造函数解析算法。
>
> 如果要定义具有不同 profile 条件的替代 bean，请使用 `@Bean` 名称属性，使用指向相同 bean 名称的不同 Java 方法名称，如前一个示例所示。如果参数签名都相同（例如，所有变体都没有 arg 工厂方法），这是首先在有效 Java 类中表示这种排列的唯一方法（因为只能有一个具有特定名称和参数签名的方法）。

#### XML Bean 定义 Profile

XML 对应项是 `<beans>` 元素的 `profile` 属性。我们前面的示例配置可以在两个 XML 文件中重写，如下所示：

```xml
<beans profile="development"
    xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:jdbc="http://www.springframework.org/schema/jdbc"
    xsi:schemaLocation="...">

    <jdbc:embedded-database id="dataSource">
        <jdbc:script location="classpath:com/bank/config/sql/schema.sql"/>
        <jdbc:script location="classpath:com/bank/config/sql/test-data.sql"/>
    </jdbc:embedded-database>
</beans>
```

```xml
<beans profile="production"
    xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:jee="http://www.springframework.org/schema/jee"
    xsi:schemaLocation="...">

    <jee:jndi-lookup id="dataSource" jndi-name="java:comp/env/jdbc/datasource"/>
</beans>
```

也可以避免在同一文件中拆分和嵌套 `<beans/>` 元素，如下例所示：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:jdbc="http://www.springframework.org/schema/jdbc"
    xmlns:jee="http://www.springframework.org/schema/jee"
    xsi:schemaLocation="...">

    <!-- other bean definitions -->

    <beans profile="development">
        <jdbc:embedded-database id="dataSource">
            <jdbc:script location="classpath:com/bank/config/sql/schema.sql"/>
            <jdbc:script location="classpath:com/bank/config/sql/test-data.sql"/>
        </jdbc:embedded-database>
    </beans>

    <beans profile="production">
        <jee:jndi-lookup id="dataSource" jndi-name="java:comp/env/jdbc/datasource"/>
    </beans>
</beans>
```

`spring-ben.xsd` 被限制为只允许文件中最后一个元素。这将有助于提供灵活性，而不会导致 XML 文件混乱。

> XML 对应项不支持前面描述的配置文件表达式。但是，可以使用 `!` 操作人员也可以通过嵌套配置文件来应用逻辑“and”，如下例所示：
>
> ```xml
> <beans xmlns="http://www.springframework.org/schema/beans"
>     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
>     xmlns:jdbc="http://www.springframework.org/schema/jdbc"
>     xmlns:jee="http://www.springframework.org/schema/jee"
>     xsi:schemaLocation="...">
> 
>     <!-- other bean definitions -->
> 
>     <beans profile="production">
>         <beans profile="us-east">
>             <jee:jndi-lookup id="dataSource" jndi-name="java:comp/env/jdbc/datasource"/>
>         </beans>
>     </beans>
> </beans>
> ```
>
> 在前面的例子中，`dataSource` bean 在 `production` 和 `us-east` profile 都启用的情况下被公开。

#### 启用 Profile

现在我们已经更新了配置，我们仍然需要指示 Spring 哪个 profile 是活动的。如果我们现在启动示例应用程序，我们将看到抛出 `NoSuchBeanDefinitionException`，因为容器找不到名为 `dataSource` 的Spring bean。

激活 profile 可以通过多种方式完成，但最直接的方法是通过 `ApplicationContext` 使用 Environment API 以编程方式完成。以下示例显示了如何执行此操作：

```java
AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
ctx.getEnvironment().setActiveProfiles("development");
ctx.register(SomeConfig.class, StandaloneDataConfig.class, JndiDataConfig.class);
ctx.refresh();
```

此外，您还可以通过 `spring.profiles.active` 属性声明性地激活 profile，该属性可以通过系统环境变量、JVM 系统属性、`web.xml` 中的 servlet 上下文参数指定，甚至可以作为 JNDI 中的条目指定（请参阅 `PropertySource` 抽象）。在集成测试中，可以使用 spring-test 模块中的 `@ActiveProfiles` 注解来声明活动概要文件（请参阅环境 profile 的上下文配置）。

请注意，配置文件不是“非此即彼”的命题。您可以同时激活多个配置文件。通过编程，您可以为 `setActiveProfiles()` 方法提供多个配置文件名称，该方法接受`String…` varargs。以下示例激活多个配置文件：

```java
ctx.getEnvironment().setActiveProfiles("profile1", "profile2");
```

声明性地，`spring.profiles.active` 可以接受以逗号分隔的配置文件名称列表，如下例所示：

```
-Dspring.profiles.active="profile1,profile2"
```

#### 默认 Profile

默认配置文件表示默认情况下启用的配置文件。考虑以下示例：

```java
@Configuration
@Profile("default")
public class DefaultDataConfig {

    @Bean
    public DataSource dataSource() {
        return new EmbeddedDatabaseBuilder()
            .setType(EmbeddedDatabaseType.HSQL)
            .addScript("classpath:com/bank/config/sql/schema.sql")
            .build();
    }
}
```

如果没有配置文件处于活动状态，则会创建 `dataSource`。您可以将此视为为一个或多个 bean 提供默认定义的方法。如果启用了任何配置文件，则不应用默认配置文件。

您可以通过在 `Environment` 上使用 `setDefaultProfiles()` 或使用 `spring.profiles.default` 属性以声明方式更改默认配置文件的名称。

### 1.13.2 PropertySource 抽象
