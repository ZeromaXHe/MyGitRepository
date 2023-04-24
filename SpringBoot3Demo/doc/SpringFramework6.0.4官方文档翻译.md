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

以下列表显示了 `SmartLifecycle` 接口的定义：

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

Spring 的 `Environment` 抽象在可配置的属性源层次结构上提供搜索操作。考虑以下列表：

```java
ApplicationContext ctx = new GenericApplicationContext();
Environment env = ctx.getEnvironment();
boolean containsMyProperty = env.containsProperty("my-property");
System.out.println("Does my environment contain the 'my-property' property? " + containsMyProperty);
```

在前面的代码段中，我们看到了一种高级方式，询问 Spring 是否为当前环境定义了 `my-property` 属性。为了回答这个问题，`Environment` 对象对一组 `PropertySource` 对象执行搜索。`PropertySource` 是对任何键值对源的简单抽象，Spring 的 `StandardEnvironment` 配置有两个 PropertySource 对象 —— 一个表示 JVM 系统财产集（`System.getProperties()`），另一个表示系统环境变量集（`System.getenv()`）。

> 这些默认属性源适用于 `StandardEnvironment`，用于独立应用程序。`StandardServletEnvironment` 填充了其他默认属性源，包括 servlet 配置、servlet 上下文参数和 `JndiPropertySource`（如果 JNDI 可用）。

具体地说，当您使用 `StandardEnvironment` 时，如果运行时存在 `my-property` 系统属性或 `my-property` 环境变量，则对 `env.contentsProperty("my-property")` 的调用将返回 true。

> 执行的搜索是分层的。默认情况下，系统属性优先于环境变量。因此，如果在调用 `env.getProperty("my-property")` 的过程中，`my-property` 属性恰好在两个位置都被设置，则系统属性值“获胜”并将被返回。请注意，属性值不会被合并，而是被前面的条目完全覆盖。
> 对于常见的 `StandardServletEnvironment`，完整层次结构如下，最高优先级条目位于顶部：
>
> 1. ServletConfig 参数（如果适用 —— 例如，在 `DispatcherServlet` 上下文的情况下）
> 2. ServletContext 参数（web.xml 上下文参数条目）
> 3. JNDI 环境变量（`java:comp/env/` 条目）
> 4. JVM 系统属性（`-D` 命令行参数）
> 5. JVM 系统环境（操作系统环境变量）

最重要的是，整个机制是可配置的。也许您有一个要集成到该搜索中的自定义财产源。为此，请实现并实例化自己的 `PropertySource`，并将其添加到当前环境的 `PropertySource` 集合中。以下示例显示了如何执行此操作：

```java
ConfigurableApplicationContext ctx = new GenericApplicationContext();
MutablePropertySources sources = ctx.getEnvironment().getPropertySources();
sources.addFirst(new MyPropertySource());
```

在前面的代码中，`MyPropertySource` 已在搜索中以最高优先级添加。如果它包含 `my-property` 属性，则会检测并返回该属性，这有利于任何其他 `PropertySource` 中的任何 `my-property`。`MutablePropertySources` API 公开了许多方法，这些方法允许对属性源集进行精确操作。

### 1.13.3 使用 @PropertySource

`@PropertySource` 注解为向 Spring 的 `Environment` 添加 `PropertySource` 提供了一种方便的声明性机制。

给定一个名为 `app.properties` 的文件，其中包含键值对 `testbean.name=myTestBean`，以下 `@Configuration` 类使用 `@PropertySource` 的方式是调用 `testbean.getName()` 返回 `myTestBean`:

```java
@Configuration
@PropertySource("classpath:/com/myco/app.properties")
public class AppConfig {

    @Autowired
    Environment env;

    @Bean
    public TestBean testBean() {
        TestBean testBean = new TestBean();
        testBean.setName(env.getProperty("testbean.name"));
        return testBean;
    }
}
```

任何 `@PropertySource` 资源位置中存在的 `${…}` 占位符将根据已在环境中注册的一组属性源进行解析，如下例所示：

```java
@Configuration
@PropertySource("classpath:/com/${my.placeholder:default/path}/app.properties")
public class AppConfig {

    @Autowired
    Environment env;

    @Bean
    public TestBean testBean() {
        TestBean testBean = new TestBean();
        testBean.setName(env.getProperty("testbean.name"));
        return testBean;
    }
}
```

假设 `my.placeholder` 存在于已注册的属性源之一（例如，系统属性或环境变量）中，则占位符被解析为相应的值。如果没有，则默认使用 `default/path`。如果未指定默认值并且无法解析属性，则会引发 `IllegalArgumentException`。

> 根据 Java 8 约定，`@PropertySource` 注解是可重复的。然而，所有此类`@PropertySource` 注解都需要在同一级别声明，要么直接在配置类上声明，要么作为同一自定义注解中的元注解声明。不建议混合使用直接注解和元注解，因为直接注解有效地覆盖了元注解。

### 1.13.4 语句中的占位符解析

过去，元素中占位符的值只能根据 JVM 系统属性或环境变量进行解析。现在已经不是这样了。因为 `Environment` 抽象是在整个容器中集成的，所以很容易通过它来路由占位符的解析。这意味着您可以以任何方式配置解析过程。您可以更改搜索系统属性和环境变量的优先级，也可以完全删除它们。您还可以根据需要将自己的属性源添加到组合中。

具体而言，无论 `customer` 属性在何处定义，只要它在 `Environment` 中可用，以下语句都有效：

```xml
<beans>
    <import resource="com/bank/service/${customer}-config.xml"/>
</beans>
```

## 1.14 注册一个 LoadTimeWeaver

Spring 使用 `LoadTimeWeaver` 在类加载到 Java 虚拟机（JVM）时动态转换它们。

要启用加载时编织，可以将 `@EnableLoadTimeWeaving` 添加到 `@Configuration` 类之一，如下例所示：

```java
@Configuration
@EnableLoadTimeWeaving
public class AppConfig {
}
```

或者，对于 XML 配置，可以使用 `context:load-timeweaver` 元素：

```xml
<beans>
    <context:load-time-weaver/>
</beans>
```

一旦为 `ApplicationContext` 配置，该 `ApplicationContext` 中的任何 bean 都可以实现 `LoadTimeWeaverware`，从而接收对加载时 weaver 实例的引用。这与 Spring 的 JPA 支持相结合特别有用，因为 JPA 类转换可能需要加载时编织。有关详细信息，请参阅 `LocalContainerEntityManagerFactoryBean` javadoc。有关 AspectJ 加载时编织的更多信息，请参阅 Spring Framework 中的使用 AspectJ 进行加载时编织。

## 1.15 ApplicationContext 的额外功能

正如在章节介绍中所讨论的，`org.springframework.beans.factory` 包提供了管理和操作 bean 的基本功能，包括以编程方式。`org.springframework.context` 包添加了 `ApplicationContext` 接口，该接口扩展了 `BeanFactory` 接口，此外还扩展了其他接口，以更面向应用程序框架的方式提供附加功能。许多人以完全声明的方式使用 `ApplicationContext`，甚至没有以编程方式创建它，而是依赖于 `ContextLoader` 等支持类来自动实例化 `ApplicationContext`，作为 Jakarta EE web 应用程序正常启动过程的一部分。

为了以更面向框架的方式增强 `BeanFactory` 功能，上下文包还提供以下功能：

- 通过 `MessageSource` 接口访问 i18n 样式的消息。
- 通过 `ResourceLoader` 接口访问资源，如 URL 和文件。
- 事件发布，即通过使用 `ApplicationEventPublisher` 接口向实现 `ApplicationListener` 接口的 bean 发布。
- 加载多个（分层）上下文，通过 `HierarchicalBeanFactory` 接口将每个上下文集中在一个特定的层上，例如应用程序的 web 层。

### 1.15.1 使用 MessageSource 的国际化

`ApplicationContext` 接口扩展了一个名为 `MessageSource` 的接口，因此提供了国际化（“i18n”）功能。Spring 还提供了 `HierarchicalMessageSource` 接口，它可以分层解析消息。这些接口共同提供了 Spring 实现消息解析的基础。这些接口上定义的方法包括：

- `String getMessage(String code, Object[] args, String default, Locale loc)`：用于从 `MessageSource` 检索消息的基本方法。如果未找到指定区域设置的消息，则使用默认消息。使用标准库提供的 `MessageFormat` 功能，传入的任何参数都将成为替换值。
- `String getMessage(String code, Object[] args, Locale loc)`：基本上与前面的方法相同，但有一个区别：无法指定默认消息。如果找不到消息，将引发 `NoSuchMessageException`。
- `String getMessage(MessageSourceResolvable resolvable, Locale Locale)`：上述方法中使用的所有属性都封装在名为 `MessageSourceResovable` 的类中，您可以将其与此方法一起使用。

当加载 `ApplicationContext` 时，它会自动搜索上下文中定义的 `MessageSource` bean。bean 必须具有名称 `messageSource`。如果找到这样一个 bean，则对前面方法的所有调用都将委托给消息源。如果找不到消息源，`ApplicationContext` 将尝试查找包含同名 bean 的父级。如果是，则使用该 bean 作为 `MessageSource`。如果 `ApplicationContext` 找不到任何消息源，则实例化空 `DelegatingMessageSource`，以便能够接受对上面定义的方法的调用。

Spring 提供了三种 `MessageSource` 实现，`ResourceBundleMessageSource`、`ReloadableResourceBundleMessageSource` 和 `StaticMessageSource`。它们都实现了 `HierarchicalMessageSource`，以便进行嵌套消息传递。`StaticMessageSource` 很少使用，但提供了向源添加消息的编程方式。以下示例显示 `ResourceBundleMessageSource`：

```xml
<beans>
    <bean id="messageSource"
            class="org.springframework.context.support.ResourceBundleMessageSource">
        <property name="basenames">
            <list>
                <value>format</value>
                <value>exceptions</value>
                <value>windows</value>
            </list>
        </property>
    </bean>
</beans>
```

该示例假设您在类路径中定义了三个资源包，称为 `format`、`exceptions` 和 `windows`。任何解析消息的请求都是通过 `ResourceBundle` 对象解析消息的 JDK 标准方式处理的。出于示例的目的，假设上述两个资源包文件的内容如下：

```properties
# in format.properties
message=Alligators rock!
```

```properties
# in exceptions.properties
argument.required=The {0} argument is required.
```

下一个示例显示了运行 `MessageSource` 功能的程序。请记住，所有 `ApplicationContext` 实现也是 `MessageSource` 实现，因此可以强制转换为 `MessageSource` 接口。

```java
public static void main(String[] args) {
    MessageSource resources = new ClassPathXmlApplicationContext("beans.xml");
    String message = resources.getMessage("message", null, "Default", Locale.ENGLISH);
    System.out.println(message);
}
```

上述程序的结果如下：

```
Alligators rock!
```

总之，`MessageSource` 在一个名为 `beans.xml` 的文件中定义，该文件位于类路径的根目录中。`messageSource` bean 定义通过其 `basenames` 属性引用了许多资源包。列表中传递给 `basenames` 属性的三个文件作为文件存在于类路径的根目录中，分别称为 `format.properties`、`exceptions.properties` 和 `windows.properties`。

下一个示例显示传递给消息查找的参数。这些参数被转换为 `String` 对象，并插入到查找消息中的占位符中。

```xml
<beans>

    <!-- this MessageSource is being used in a web application -->
    <bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
        <property name="basename" value="exceptions"/>
    </bean>

    <!-- lets inject the above MessageSource into this POJO -->
    <bean id="example" class="com.something.Example">
        <property name="messages" ref="messageSource"/>
    </bean>

</beans>
```

```java
public class Example {

    private MessageSource messages;

    public void setMessages(MessageSource messages) {
        this.messages = messages;
    }

    public void execute() {
        String message = this.messages.getMessage("argument.required",
            new Object [] {"userDao"}, "Required", Locale.ENGLISH);
        System.out.println(message);
    }
}
```

调用 `execute()` 方法的结果输出如下：

```
The userDao argument is required.
```

关于国际化（“i18n”），Spring 的各种 `MessageSource` 实现遵循与标准 JDK `ResourceBundle` 相同的区域设置解析和回退规则。简言之，继续前面定义的示例 `messageSource`，如果您想根据英国（`en-GB`）语言环境解析消息，您将分别创建名为 `format_en_GB.properties`、`exceptions_en_GB.properties` 和 `windows_en_GB.properties` 的文件。

通常，区域设置解析由应用程序的周围环境管理。在以下示例中，解析（英国）消息所依据的区域设置是手动指定的：

```properties
# in exceptions_en_GB.properties
argument.required=Ebagum lad, the ''{0}'' argument is required, I say, required.
```

```java
public static void main(final String[] args) {
    MessageSource resources = new ClassPathXmlApplicationContext("beans.xml");
    String message = resources.getMessage("argument.required",
        new Object [] {"userDao"}, "Required", Locale.UK);
    System.out.println(message);
}
```

运行上述程序的结果如下：

```
Ebagum lad, the 'userDao' argument is required, I say, required.
```

您还可以使用 `MessageSourceAware` 接口获取对已定义的任何 `MessageSource` 的引用。在创建和配置 bean 时，在实现 `MessageSourceAware` 接口的 `ApplicationContext` 中定义的任何 bean 都会被注入应用程序上下文的 `MessageSource`。

> 因为 Spring 的 `MessageSource` 基于 Java 的 `ResourceBundle`，所以它不会合并具有相同基本名称的捆绑包，而是只使用找到的第一个捆绑包。具有相同基名称的后续消息束将被忽略。

> 作为 `ResourceBundleMessageSource` 的替代，Spring 提供了 `ReloadableResourceBundleMessage` 类。此变体支持相同的捆绑文件格式，但比基于标准 JDK 的 `ResourceBundleMessageSource` 实现更灵活。特别是，它允许从任何 Spring 资源位置（不仅仅是从类路径）读取文件，并支持热重载捆绑包属性文件（同时有效地缓存它们）。有关详细信息，请参阅`ReloadableResourceBundleMessageSource` javadoc。

### 1.15.2 标准和自定义事件

`ApplicationContext` 中的事件处理是通过 `ApplicationEvent` 类和 `ApplicationListener` 接口提供的。如果将实现 `ApplicationListener` 接口的 bean 部署到上下文中，则每次将 `ApplicationEvent` 发布到 `ApplicationContext` 时，都会通知该 bean。本质上，这是标准的 Observer 设计模式。

> 从 Spring 4.2 开始，事件基础结构得到了显著改进，提供了基于注解的模型，以及发布任意事件（即，不一定从 `ApplicationEvent` 扩展的对象）的能力。当发布这样的对象时，我们会将其包装在事件中。

下表描述了 Spring 提供的标准事件：

| 事件                         | 解释                                                         |
| :--------------------------- | :----------------------------------------------------------- |
| `ContextRefreshedEvent`      | 在初始化或刷新 `ApplicationContext` 时发布（例如，通过在 `ConfigurationApplicationContext` 接口上使用 `refresh()` 方法）。这里，“initialized” 意味着加载所有 bean，检测并激活后处理器 bean，预实例化单体，并准备好使用 `ApplicationContext` 对象。只要上下文尚未关闭，就可以多次触发刷新，前提是所选的 `ApplicationContext` 实际上支持此类“热”刷新。例如，`XmlWebApplicationContext` 支持热刷新，但 `GenericApplicationContext` 不支持。 |
| `ContextStartedEvent`        | 在 `ConfigurationApplicationContext` 接口上使用 `start()` 方法启动 `ApplicationContext` 时发布。这里，“已启动”意味着所有 `lifecycle` bean 都会收到一个明确的启动信号。通常，此信号用于在显式停止后重新启动 bean，但也可以用于启动尚未配置为自动启动的组件（例如，尚未在初始化时启动的组件）。 |
| `ContextStoppedEvent`        | 在 `ConfigurationApplicationContext` 接口上使用 `stop()` 方法停止 `ApplicationContext` 时发布。这里，“stopped” 表示所有 `Lifecycle` bean都收到一个明确的停止信号。可以通过 `start()` 调用重新启动已停止的上下文。 |
| `ContextClosedEvent`         | 通过在 `ConfigurationApplicationContext` 接口上使用 `close()` 方法或通过 JVM 关闭挂钩关闭 `ApplicationContext` 时发布。这里，“closed” 表示所有单例 bean 都将被销毁。一旦上下文关闭，它将到达生命的终点，无法刷新或重新启动。 |
| `RequestHandledEvent`        | 一个特定于 web 的事件，告诉所有 bean HTTP 请求已得到服务。此事件在请求完成后发布。此事件仅适用于使用 Spring 的 `DispatcherServlet` 的 web 应用程序。 |
| `ServletRequestHandledEvent` | 添加 Servlet 特定上下文信息的 `RequestHandledEvent` 的子类。 |

您还可以创建和发布自己的自定义事件。以下示例显示了一个扩展 Spring 的 `ApplicationEvent` 基类的简单类：

```java
public class BlockedListEvent extends ApplicationEvent {

    private final String address;
    private final String content;

    public BlockedListEvent(Object source, String address, String content) {
        super(source);
        this.address = address;
        this.content = content;
    }

    // accessor and other methods...
}
```

要发布自定义 `ApplicationEvent`，请在 `ApplicationEventPublisher` 上调用 `publishEvent()` 方法。通常，这是通过创建一个实现 `ApplicationEventPublisherAware` 的类并将其注册为 Spring bean 来完成的。以下示例显示了这样的类：

```java
public class EmailService implements ApplicationEventPublisherAware {

    private List<String> blockedList;
    private ApplicationEventPublisher publisher;

    public void setBlockedList(List<String> blockedList) {
        this.blockedList = blockedList;
    }

    public void setApplicationEventPublisher(ApplicationEventPublisher publisher) {
        this.publisher = publisher;
    }

    public void sendEmail(String address, String content) {
        if (blockedList.contains(address)) {
            publisher.publishEvent(new BlockedListEvent(this, address, content));
            return;
        }
        // send email...
    }
}
```

在配置时，Spring 容器检测到 `EmailService` 实现了 `ApplicationEventPublisherAware` 并自动调用 `setApplicationEventPublisher()`。实际上，传入的参数是 Spring 容器本身。您正在通过其 `ApplicationEventPublisher` 接口与应用程序上下文交互。

要接收自定义 `ApplicationEvent`，可以创建一个实现 `ApplicationListener` 的类，并将其注册为 Spring bean。以下示例显示了这样的类：

```java
public class BlockedListNotifier implements ApplicationListener<BlockedListEvent> {

    private String notificationAddress;

    public void setNotificationAddress(String notificationAddress) {
        this.notificationAddress = notificationAddress;
    }

    public void onApplicationEvent(BlockedListEvent event) {
        // notify appropriate parties via notificationAddress...
    }
}
```

请注意，`ApplicationListener` 是用自定义事件的类型（在前面的示例中为 `BlockedListEvent`）进行参数化的。这意味着 `onApplicationEvent()` 方法可以保持类型安全，避免任何向下转换的需要。您可以注册任意数量的事件侦听器，但请注意，默认情况下，事件侦听器同步接收事件。这意味着 `publishEvent()` 方法将阻塞，直到所有侦听器完成对事件的处理。这种同步和单线程方法的一个优点是，当侦听器接收到事件时，如果事务上下文可用，它将在发布器的事务上下文中进行操作。如果需要另一种事件发布策略，请参阅 javadoc for Spring 的 `ApplicationEventMulticaster` 接口和 `SimpleApplicationEventMultiaster` 实现以获取配置选项。

以下示例显示了用于注册和配置上述每个类的 bean 定义：

```xml
<bean id="emailService" class="example.EmailService">
    <property name="blockedList">
        <list>
            <value>known.spammer@example.org</value>
            <value>known.hacker@example.org</value>
            <value>john.doe@example.org</value>
        </list>
    </property>
</bean>

<bean id="blockedListNotifier" class="example.BlockedListNotifier">
    <property name="notificationAddress" value="blockedlist@example.org"/>
</bean>
```

总之，当调用 `emailService` bean 的 `sendEmail()` 方法时，如果有任何电子邮件消息应该被阻止，则会发布 `BlockedListEvent` 类型的自定义事件。`blockedListNotifier` bean 注册为 `ApplicationListener` 并接收 `BlockedListEvent`，此时它可以通知适当的各方。

> Spring 的事件机制设计用于同一应用程序上下文中 Spring bean 之间的简单通信。然而，对于更复杂的企业集成需求，单独维护的 Spring integration 项目为构建基于众所周知的 Spring 编程模型的轻量级、面向模式、事件驱动架构提供了完整的支持。

#### 基于注解的事件监听器

您可以使用 `@EventListener` 注解在托管 bean 的任何方法上注册事件侦听器。`BlockedListNotifier` 可以重写如下：

```java
public class BlockedListNotifier {

    private String notificationAddress;

    public void setNotificationAddress(String notificationAddress) {
        this.notificationAddress = notificationAddress;
    }

    @EventListener
    public void processBlockedListEvent(BlockedListEvent event) {
        // notify appropriate parties via notificationAddress...
    }
}
```

方法签名再次声明了它侦听的事件类型，但这次使用了一个灵活的名称，并且没有实现特定的侦听器接口。只要实际事件类型解析其实现层次结构中的泛型参数，也可以通过泛型缩小事件类型。

如果您的方法应该侦听多个事件，或者如果您想在没有参数的情况下定义它，那么也可以在注解本身上指定事件类型。以下示例显示了如何执行此操作：

```java
@EventListener({ContextStartedEvent.class, ContextRefreshedEvent.class})
public void handleContextStart() {
    // ...
}
```

还可以通过使用定义 `SpEL` 表达式的注解的 `condition` 属性添加额外的运行时过滤，该表达式应与实际调用特定事件的方法相匹配。

以下示例显示了如何重写通知程序，以便仅在事件的 `content` 属性等于 `my-event` 时调用：

```java
@EventListener(condition = "#blEvent.content == 'my-event'")
public void processBlockedListEvent(BlockedListEvent blEvent) {
    // notify appropriate parties via notificationAddress...
}
```

每个 `SpEL` 表达式都根据专用上下文进行计算。下表列出了可用于上下文的项目，以便您可以将它们用于条件事件处理：

| 名字     | 位置       | 描述                                                         | 例子                                                         |
| :------- | :--------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| 事件     | 根对象     | 真正的 `ApplicationEvent`.                                   | `#root.event` 或 `event`                                     |
| 参数数组 | 根对象     | 用来调用方法的参数（作为对象数组）                           | `#root.args` 或 `args`; `args[0]` 来访问第一个参数，等等     |
| 参数名字 | 求值上下文 | 任何方法参数的名称。如果由于某些原因，名称不可用（例如，因为编译的字节代码中没有调试信息），则使用 `#a<#arg>` 语法也可以使用单个参数，其中 `<#arg>` 代表参数索引（从 0 开始）。 | `#blEvent` 或 `#a0` (你也可以使用 `#p0` 或 `#p<#arg>` 参数符号作为别名) |

请注意，`#root.event` 允许您访问基础事件，即使您的方法签名实际上引用了已发布的任意对象。

如果您需要发布一个事件作为处理另一个事件的结果，则可以更改方法签名以返回应该发布的事件，如下例所示：

```java
@EventListener
public ListUpdateEvent handleBlockedListEvent(BlockedListEvent event) {
    // notify appropriate parties via notificationAddress and
    // then publish a ListUpdateEvent...
}
```

> 该特性不支持异步监听器

`handleBlockedListEvent()` 方法为其处理的每个 `BlockedListEvent` 发布一个新的 `ListUpdateEvent`。如果需要发布多个事件，则可以返回集合或事件数组。

#### 异步监听器

如果希望特定侦听器异步处理事件，可以重用常规的 `@Async` 支持。以下示例显示了如何执行此操作：

```java
@EventListener
@Async
public void processBlockedListEvent(BlockedListEvent event) {
    // BlockedListEvent is processed in a separate thread
}
```

使用异步事件时，请注意以下限制：

- 如果异步事件侦听器抛出 `Exception`，则不会将其传播给调用者。有关详细信息，请参阅 `AsyncUnaughtExceptionHandler`。
- 异步事件侦听器方法无法通过返回值来发布后续事件。如果您需要作为处理结果发布另一个事件，请注入 `ApplicationEventPublisher` 以手动发布事件。

#### 监听器排序

如果需要在调用另一个监听器之前调用一个监听器，可以将 `@Order` 注解添加到方法声明中，如下例所示：

```java
@EventListener
@Order(42)
public void processBlockedListEvent(BlockedListEvent event) {
    // notify appropriate parties via notificationAddress...
}
```

#### 泛型事件

您还可以使用泛型来进一步定义事件的结构。考虑使用 `EntityCreatedEvent<T>`，其中 `T` 是创建的实际实体的类型。例如，可以创建以下侦听器定义以仅接收 `Person` 的 `EntityCreatedEvent`：

```java
@EventListener
public void onPersonCreated(EntityCreatedEvent<Person> event) {
    // ...
}
```

由于类型擦除，只有在激发的事件解析了事件侦听器筛选的通用参数（即 `class PersonCreatedEvent extends EntityCreatedEvent<Person>{…}`).

在某些情况下，如果所有事件都遵循相同的结构，这可能会变得非常乏味（上一个示例中的事件就是如此）。在这种情况下，您可以实现 `ResolutibleTypeProvider` 来指导框架超出运行时环境所提供的范围。以下事件显示了如何执行此操作：

```java
public class EntityCreatedEvent<T> extends ApplicationEvent implements ResolvableTypeProvider {

    public EntityCreatedEvent(T entity) {
        super(entity);
    }

    @Override
    public ResolvableType getResolvableType() {
        return ResolvableType.forClassWithGenerics(getClass(), ResolvableType.forInstance(getSource()));
    }
}
```

> 这不仅适用于 `ApplicationEvent`，也适用于作为事件发送的任意对象。

### 1.15.3 便捷访问低级资源

为了优化应用程序上下文的使用和理解，您应该熟悉 Spring 的 `Resource` 抽象，如参考资料中所述。

应用程序上下文是 `ResourceLoader`，可用于加载 `Resource` 对象。`Resource` 本质上是 JDK `java.net.URL` 类的一个功能更丰富的版本。事实上，`Resource` 的实现在适当的情况下包装 `java.net.URL` 的实例。`Resource` 可以以透明的方式从几乎任何位置获取低级资源，包括从类路径、文件系统位置、使用标准 URL 可描述的任何位置以及一些其他变体。如果资源位置字符串是一个没有任何特殊前缀的简单路径，那么这些资源的来源是特定的，并且适合于实际的应用程序上下文类型。

您可以将部署到应用程序上下文中的 bean 配置为实现特殊的回调接口 `ResourceLoaderAware`，以便在初始化时自动调用，并将应用程序上下文本身作为 `ResourceLoader` 传入。您还可以公开 `Resource` 类型的财产，用于访问静态资源。它们像其他财产一样被注入其中。您可以将这些 `Resource` 财产指定为简单的 `String` 路径，并依赖于在部署 bean 时从这些文本字符串到实际 `Resource` 对象的自动转换。

提供给 `ApplicationContext` 构造函数的一个或多个位置路径实际上是资源字符串，以简单的形式，根据特定的上下文实现进行适当处理。例如，`ClassPathXmlApplicationContext` 将简单的位置路径视为类路径位置。您还可以使用带有特殊前缀的位置路径（资源字符串）来强制从类路径或 URL 加载定义，而不考虑实际的上下文类型。

### 1.15.4 应用启动跟踪

`ApplicationContext` 管理 Spring 应用程序的生命周期，并围绕组件提供丰富的编程模型。因此，复杂的应用程序可能具有同样复杂的组件图和启动阶段。

使用特定指标跟踪应用程序启动步骤有助于了解启动阶段所花费的时间，但也可以作为更好地了解整个上下文生命周期的一种方式。

`AbstractApplicationContext`（及其子类）装有 `ApplicationStartup`，它收集有关各种启动阶段的 `StartupStep` 数据：

- 应用程序上下文生命周期（基本包扫描、配置类管理）
- bean 生命周期（实例化、智能初始化、后处理）
- 应用程序事件处理

以下是 `AnnotationConfigApplicationContext` 中的插入示例：

```java
// create a startup step and start recording
StartupStep scanPackages = this.getApplicationStartup().start("spring.context.base-packages.scan");
// add tagging information to the current step
scanPackages.tag("packages", () -> Arrays.toString(basePackages));
// perform the actual phase we're instrumenting
this.scanner.scan(basePackages);
// end the current step
scanPackages.end();
```

应用程序上下文已检测到多个步骤。一旦记录下来，就可以使用特定的工具收集、显示和分析这些启动步骤。有关现有启动步骤的完整列表，您可以查看专用的附录部分。

默认的 `ApplicationStartup` 实现是一个无操作变量，开销最小。这意味着默认情况下，在应用程序启动期间不会收集任何度量。Spring Framework 附带了一个使用Java FlightRecorder：`FlightRecorderApplicationStartup` 跟踪启动步骤的实现。要使用此变体，必须在创建该变体后立即将其实例配置到 `ApplicationContext`。

如果开发人员提供自己的 `AbstractApplicationContext` 子类，或者希望收集更精确的数据，那么他们也可以使用 `ApplicationStartup` 基础设施。

> `ApplicationStartup` 仅用于应用程序启动期间和核心容器；这绝不是 Java profiler 或 Micrometer 等度量库的替代品。

要开始收集自定义 `StartupStep`，组件可以直接从应用程序上下文中获取 `ApplicationStartup` 实例，使其组件实现 `ApplicationStartupAware`，或在任何注入点上请求 `ApplicationStartup` 类型。

> 开发人员在创建自定义启动步骤时不应使用 `spring.*` 命名空间。此名称空间是为内部 Spring 使用而保留的，并且可能会更改。

### 1.15.5 Web 应用的便利 ApplicationContext 实例化

例如，可以使用 `ContextLoader` 以声明方式创建 `ApplicationContext` 实例。当然，您也可以通过使用 `ApplicationContext` 实现之一以编程方式创建 `ApplicationContext` 实例。

您可以使用 `ContextLoaderListener` 注册 `ApplicationContext`，如下例所示：

```xml
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>/WEB-INF/daoContext.xml /WEB-INF/applicationContext.xml</param-value>
</context-param>

<listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
```

侦听器检查 `contextConfigLocation` 参数。如果该参数不存在，则侦听器使用 `/WEB-INF/applicationContext.xml` 作为默认值。当参数确实存在时，侦听器使用预定义的分隔符（逗号、分号和空格）分隔字符串，并将这些值用作搜索应用程序上下文的位置。还支持 Ant 样式的路径模式。示例有 `/WEB-INF/*Context.xml`（适用于名称以 `Context.xml` 结尾且位于 `WEB-INF` 目录中的所有文件）和 `/WEB-IINF/**/*Context.xml`（适用于 `WEB-INF` 任何子目录中的此类文件）。

### 1.15.6 作为 Jarkarta EE RAR 文件部署 Spring ApplicationContext

可以将 Spring `ApplicationContext` 部署为 RAR 文件，将上下文及其所有必需的 bean 类和库 JAR 封装在 Jakarta EE RAR 部署单元中。这相当于引导一个独立的 `ApplicationContext`（仅在 Jakarta EE 环境中托管）能够访问 Jakarta 的 EE 服务器设施。RAR 部署是部署无头 WAR 文件场景的更自然的替代方案 —— 实际上，这是一个没有任何 HTTP 入口点的 WAR 文件，仅用于在 Jakarta EE 环境中引导 Spring `ApplicationContext`。

RAR 部署非常适合不需要 HTTP 入口点，而只包含消息端点和调度作业的应用程序上下文。这种上下文中的 bean 可以使用应用程序服务器资源，例如 JTA 事务管理器和 JNDI 绑定的 JDBC `DataSource` 实例和 JMS `ConnectionFactory` 实例，还可以向平台的 JMX 服务器注册 — 所有这些都通过 Spring 的标准事务管理和 JNDI 和 JMX 支持设施实现。应用程序组件还可以通过 Spring 的 `TaskExecutor` 抽象与应用程序服务器的 JCA `WorkManager` 交互。

有关 RAR 部署中涉及的配置详细信息，请参阅 `SpringContextResourceAdapter` 类的 javadoc。

对于 Spring ApplicationContext 作为 Jakarta EE RAR 文件的简单部署：

1. 将所有应用程序类打包到一个 RAR 文件中（这是一个具有不同文件扩展名的标准 JAR 文件）。
2. 将所有必需的库 JAR 添加到 RAR 归档的根目录中。
3. 添加 `META-INF/ra.xml` 部署描述符（如 `SpringContextResourceAdapter` 的 javadoc 中所示）和相应的 Spring XML bean 定义文件（通常为 `META-INF/applicationContext.xml`）。
4. 将生成的 RAR 文件放到应用程序服务器的部署目录中。

> 这种 RAR 部署单元通常是独立的。它们不向外部世界公开组件，甚至不向同一应用程序的其他模块公开组件。与基于 RAR 的 `ApplicationContext` 的交互通常通过与其他模块共享的 JMS 目标发生。例如，基于 RAR 的 `ApplicationContext` 还可以调度一些作业或对文件系统中的新文件做出反应（等等）。如果它需要允许从外部进行同步访问，它可以（例如）导出 RMI 端点，该端点可以由同一机器上的其他应用程序模块使用。

## 1.16 BeanFactory API

`BeanFactory` API 为 Spring 的 IoC 功能提供了基础。它的特定契约主要用于与 Spring 的其他部分和相关的第三方框架集成，其 `DefaultListableBeanFactory` 实现是更高级别 `GenericApplicationContext` 容器中的关键委托。

`BeanFactory` 和相关接口（如 `BeanFactoryAware`、`InitializingBean`、`DisposableBean`）是其他框架组件的重要集成点。通过不需要任何注解甚至反射，它们允许容器及其组件之间进行非常有效的交互。应用程序级 bean 可以使用相同的回调接口，但通常更喜欢通过注解或编程配置进行声明性依赖注入。

请注意，核心 `BeanFactory` API 级别及其 `DefaultListableBeanFactory` 实现没有对要使用的配置格式或任何组件注解进行假设。所有这些风格都是通过扩展（如 `XmlBeanDefinitionReader` 和 `AutowiredAnnotationBeanPostProcessor`）引入的，并作为核心元数据表示在共享 `BeanDefinition` 对象上运行。这就是 Spring 容器如此灵活和可扩展的本质。

### 1.16.1 BeanFactory 或 ApplicationContext

本节解释 `BeanFactory` 和 `ApplicationContext` 容器级别之间的差异以及对引导的影响。

除非有充分的理由不使用 `ApplicationContext`，否则应该使用 `ApplicationContext`。`GenericApplicationContext` 及其子类 `AnnotationConfigApplicationContext` 是自定义引导的常见实现。这些是 Spring 核心容器的主要入口点，用于所有常见目的：加载配置文件、触发类路径扫描、以编程方式注册 bean 定义和注解类，以及（从 5.0 开始）注册函数 bean 定义。

由于 `ApplicationContext` 包含 `BeanFactory` 的所有功能，因此通常建议使用它而不是普通的 `BeanFactory`，除非需要对 bean 处理进行完全控制。在 `ApplicationContext`（例如 `GenericApplicationContext` 实现）中，按约定（即，按 bean 名称或 bean 类型）检测几种 bean —— 特别是后处理器），而普通的 `DefaultListableBeanFactory` 对任何特殊 bean 都是不可知的。

对于许多扩展的容器特性，如注释处理和 AOP 代理，`BeanPostProcessor` 扩展点是必不可少的。如果只使用普通的 `DefaultListableBeanFactory`，则默认情况下不会检测到并激活此类后处理器。这种情况可能令人困惑，因为您的 bean 配置实际上没有任何问题。相反，在这种情况下，需要通过额外的设置来完全引导容器。

下表列出了 `BeanFactory` 和 `ApplicationContext` 接口和实现提供的功能。

| 特性                                 | `BeanFactory` | `ApplicationContext` |
| :----------------------------------- | :------------ | :------------------- |
| Bean 初始化/装配                     | 是            | 是                   |
| 整合的生命周期管理                   | 否            | 是                   |
| 自动 `BeanPostProcessor` 注册        | 否            | 是                   |
| 自动 `BeanFactoryPostProcessor` 注册 | 否            | 是                   |
| 便利的 `MessageSource` 访问（国际化) | 否            | 是                   |
| 内建的 `ApplicationEvent` 发布机制   | 否            | 是                   |

要向 `DefaultListableBeanFactory` 显式注册 bean 后处理器，需要以编程方式调用 `addBeanPostProcessor`，如下例所示：

```java
DefaultListableBeanFactory factory = new DefaultListableBeanFactory();
// populate the factory with bean definitions

// now register any needed BeanPostProcessor instances
factory.addBeanPostProcessor(new AutowiredAnnotationBeanPostProcessor());
factory.addBeanPostProcessor(new MyBeanPostProcessor());

// now start using the factory
```

要将 `BeanFactoryPostProcessor` 应用于纯 `DefaultListableBeanFactory`，需要调用其 `postProcessBeanFactory` 方法，如下例所示：

```java
DefaultListableBeanFactory factory = new DefaultListableBeanFactory();
XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(factory);
reader.loadBeanDefinitions(new FileSystemResource("beans.xml"));

// bring in some property values from a Properties file
PropertySourcesPlaceholderConfigurer cfg = new PropertySourcesPlaceholderConfigurer();
cfg.setLocation(new FileSystemResource("jdbc.properties"));

// now actually do the replacement
cfg.postProcessBeanFactory(factory);
```

在这两种情况下，显式注册步骤都是不方便的，这就是为什么在 Spring 支持的应用程序中，各种 `ApplicationContext` 变体比纯 `DefaultListableBeanFactory` 更受欢迎，尤其是在典型的企业设置中，依赖 `BeanFactoryPostProcessor` 和 `BeanPostProcessor` 实例实现扩展容器功能时。

> `AnnotationConfigApplicationContext` 注册了所有常见的注解后处理器，并可能通过配置注解（如 `@EnableTransactionManagement`）在封面下引入其他处理器。在 Spring 基于注解的配置模型的抽象级别，bean 后处理器的概念仅仅是一个内部容器细节。

# 2. 资源

本章介绍 Spring 如何处理资源以及如何在 Spring 中使用资源。它包括以下主题：

- 介绍
- `Resource` 接口
- 内置 `Resource` 实现
- `ResourceLoader` 接口
- `ResourcePatternResolver` 接口
- `ResourceLoaderAware` 接口
- 作为依赖项的资源
- 应用程序上下文和资源路径

## 2.1 介绍

不幸的是，Java 的标准 `java.net.URL` 类和各种 URL 前缀的标准处理程序对于所有低级资源的访问都不够。例如，没有标准化的 `URL` 实现可用于访问需要从类路径或相对于 `ServletContext` 获得的资源。虽然可以为专门的 `URL` 前缀注册新的处理程序（类似于现有的前缀处理程序，例如 `http:`），但这通常非常复杂，并且 `URL` 接口仍然缺少一些理想的功能，例如检查所指向资源是否存在的方法。

## 2.2 Resource 接口

Spring 位于 `org.springframework.core.io.package` 中的 `Resource` 接口旨在成为一个更强大的接口，用于抽象对低级资源的访问。下面的列表提供了 `Resource` 接口的概述。有关详细信息，请参阅 `Resource` javadoc。

```java
public interface Resource extends InputStreamSource {

    boolean exists();

    boolean isReadable();

    boolean isOpen();

    boolean isFile();

    URL getURL() throws IOException;

    URI getURI() throws IOException;

    File getFile() throws IOException;

    ReadableByteChannel readableChannel() throws IOException;

    long contentLength() throws IOException;

    long lastModified() throws IOException;

    Resource createRelative(String relativePath) throws IOException;

    String getFilename();

    String getDescription();
}
```

如 `Resource` 接口的定义所示，它扩展了 `InputStreamSource` 接口。以下列表显示 `InputStreamSource` 接口的定义：

```java
public interface InputStreamSource {

    InputStream getInputStream() throws IOException;
}
```

`Resource` 接口中一些最重要的方法是：

- `getInputStream()`：定位并打开资源，返回一个 `InputStream` 以读取资源。预期每次调用都会返回一个新的 `InputStream`。调用者负责关闭流。
- `exists()`：返回一个 `boolean`，指示该资源是否以物理形式存在。
- `isOpen()`：返回一个 `boolean`，指示此资源是否表示具有开放流的句柄。如果为 `true`，则不能多次读取 `InputStream`，必须仅读取一次，然后关闭以避免资源泄漏。对于所有常见的资源实现，返回 `false`，`InputStreamResource` 除外。
- `getDescription()`：返回此资源的描述，用于处理资源时的错误输出。这通常是完全限定的文件名或资源的实际 URL。

其他方法允许您获得表示资源的实际 `URL` 或 `File` 对象（如果底层实现兼容并支持该功能）。

`Resource` 接口的一些实现还为支持写入的资源实现了扩展的 `WritableResource` 接口。

当需要资源时，Spring 本身广泛使用 `Resource` 抽象，作为许多方法签名中的参数类型。某些 Spring API 中的其他方法（例如各种 `ApplicationContext` 实现的构造函数）采用一个 `Spring`，该字符串以未修饰或简单的形式用于创建适合该上下文实现的 `Resource`，或者通过 `String` 路径上的特殊前缀，让调用者指定必须创建和使用特定的 `Resource` 实现。
虽然 Spring 经常使用 `Resource` 接口，但实际上在您自己的代码中单独用作通用工具类非常方便，即使您的代码不知道或不关心 Spring 的任何其他部分，也可以访问资源。虽然这将您的代码耦合到 Spring，但它实际上只将它耦合到这一小组实用程序类，这是 URL 的一个更强大的替代品，可以被视为等同于用于此目的的任何其他库。

> `Resource` 抽象并不取代功能。它尽可能将其包裹起来。例如，`UrlResource` 包装 URL 并使用包装的 `URL` 来完成其工作。

## 2.3 内建 Resource 实现

Spring包括几个内置的 `Resource` 实现：

- [`UrlResource`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#resources-implementations-urlresource)
- [`ClassPathResource`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#resources-implementations-classpathresource)
- [`FileSystemResource`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#resources-implementations-filesystemresource)
- [`PathResource`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#resources-implementations-pathresource)
- [`ServletContextResource`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#resources-implementations-servletcontextresource)
- [`InputStreamResource`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#resources-implementations-inputstreamresource)
- [`ByteArrayResource`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#resources-implementations-bytearrayresource)

有关 Spring 中可用的 `Resource` 实现的完整列表，请参阅 `Resource` javadoc 的“所有已知实现类”部分。

### 2.3.1 UrlResource

`UrlResource` 包装 `java.net.URL`，可用于访问通常可通过 URL 访问的任何对象，例如文件、HTTPS 目标、FTP 目标等。所有 URL 都有一个标准化的 `String` 表示，因此使用适当的标准化前缀来指示一种 URL 类型与另一种 URL。这包括 `file:` 用于访问文件系统路径，`https:` 用于通过 https 协议访问资源，`ftp:` 用于通过 ftp 访问资源，以及其他。

`UrlResource` 是由 Java 代码通过显式使用 `UrlResource` 构造函数创建的，但通常在调用使用 `String` 参数表示路径的 API 方法时隐式创建。对于后一种情况，JavaBeans `PropertyEditor` 最终决定要创建哪种类型的 `Resource`。如果路径字符串包含一个众所周知的（到属性编辑器，即）前缀（例如 `classpath:`），它将为该前缀创建一个适当的专用 `Resource`。但是，如果它不识别前缀，则假定该字符串是标准 URL 字符串，并创建 `UrlResource`。

### 2.3.2 ClassPathResource

此类表示应从类路径中获取的资源。它使用线程上下文类加载器、给定类加载器或给定类来加载资源。

如果类路径资源驻留在文件系统中，但对于驻留在 jar 中且尚未（通过 servlet 引擎或其他环境）扩展到文件系统的类路径资源，则此 `Resource` 实现支持将其解析为 `java.io.File`。为了解决这个问题，各种 `Resource` 实现始终支持 `java.net.URL` 的解析。

`ClassPathResource` 是由 Java 代码通过显式使用 `ClassPathResource` 构造函数创建的，但通常在调用使用 `String` 参数表示路径的 API 方法时隐式创建。对于后一种情况，JavaBeans `PropertyEditor` 识别字符串路径上的特殊前缀 `classpath:`，并在这种情况下创建 `ClassPathResource`。

### 2.3.3 FileSystemResource

这是 `java.io.File` 句柄的 `Resource` 实现。它还支持 `java.nio.file.Path` 句柄，应用 Spring 的标准基于字符串的路径转换，但通过 `java.nio.file.Files` API 执行所有操作。对于纯 `java.nio.path.Path` 支持，请改用 `PathResource`。`FileSystemResource` 支持作为 `File` 和 `URL` 进行解析。

### 2.3.4 PathResource

这是 `java.nio.file.Path` 句柄的 `Resource` 实现，通过 `Path` API 执行所有操作和转换。它支持作为 `File` 和 `URL` 的解析，还实现了扩展的 `WritableResource` 接口。`PathResource` 实际上是 `FileSystemResource` 的纯 `java.nio.path.Path` 替代品，具有不同的 `createRelative` 行为。

### 2.3.5 ServletContextResource

这是 `ServletContext` 资源的 `Resource` 实现，用于解释相关 web 应用程序根目录中的相对路径。

它始终支持流访问和 URL 访问，但仅当 web 应用程序存档被扩展并且资源物理上位于文件系统上时，才允许 `java.io.File` 访问。无论它是在文件系统上扩展还是直接从 JAR 或其他地方访问（这是可以想象的），实际上都取决于 Servlet 容器。

### 2.3.6 InputStreamResource

`InputStreamResource` 是给定 `InputStream` 的 `Resource` 实现。只有在没有适用的特定资源实施时，才应使用它。特别是，在可能的情况下，首选 `ByteArrayResource` 或任何基于文件的 `Resource` 实现。

与其他 `Resource` 实现不同，这是一个已打开资源的描述符。因此，它从 `isOpen()` 返回 `true`。如果需要将资源描述符保存在某处，或者需要多次读取流，请不要使用它。

### 2.3.7 ByteArrayResource

这是给定字节数组的 `Resource` 实现。它为给定的字节数组创建 `ByteArrayInputStream`。

它对于从任何给定字节数组加载内容都非常有用，而无需使用一次性 `InputStreamResource`。

## 2.4 ResourceLoader 接口

`ResourceLoader` 接口由可以返回（即加载）`Resource` 实例的对象实现。以下列表显示 `ResourceLoader` 接口定义：

```java
public interface ResourceLoader {

    Resource getResource(String location);

    ClassLoader getClassLoader();
}
```

所有应用程序上下文都实现 `ResourceLoader` 接口。因此，可以使用所有应用上下文来获得资源实例。

当您在特定的应用程序上下文上调用 `getResource()`，并且指定的位置路径没有特定的前缀时，您将返回适合于该特定应用程序上下文的 Resource 类型。例如，假设对 `ClassPathXmlApplicationContext` 实例运行了以下代码片段：

```java
Resource template = ctx.getResource("some/resource/path/myTemplate.txt");
```

针对 `ClassPathXmlApplicationContext`，该代码返回 `ClassPathResource`。如果对 `FileSystemXmlApplicationContext` 实例运行相同的方法，它将返回 `FileSystemResource`。对于 `WebApplicationContext`，它将返回 `ServletContextResource`。它同样会为每个上下文返回适当的对象。

因此，您可以以适合特定应用程序上下文的方式加载资源。

另一方面，您也可以通过指定特殊的 `classpath:` 前缀来强制使用 `ClassPathResource`，无论应用程序上下文类型如何，如下例所示：

```java
Resource template = ctx.getResource("classpath:some/resource/path/myTemplate.txt");
```

类似地，您可以通过指定任何标准 `java.net.URL` 前缀来强制使用 `UrlResource`。以下示例使用 `file` 和 `https` 前缀：

```java
Resource template = ctx.getResource("file:///some/resource/path/myTemplate.txt");
```

```java
Resource template = ctx.getResource("https://myhost.com/resource/path/myTemplate.txt");
```

下表总结了将 `String` 对象转换为 `Resource` 对象的策略：

| 前缀       | 例子                             | 解释                                                         |
| :--------- | :------------------------------- | :----------------------------------------------------------- |
| classpath: | `classpath:com/myapp/config.xml` | 从类路径加载                                                 |
| file:      | `file:///data/config.xml`        | 作为 `URL` 从文件系统中加载。 参考 [`FileSystemResource` 警告](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#resources-filesystemresource-caveats). |
| https:     | `https://myserver/logo.png`      | 作为 `URL` 加载                                              |
| (无)       | `/data/config.xml`               | 取决于底层的 `ApplicationContext`.                           |

## 2.5 ResourcePatternResolver 接口

`ResourcePatternResolver` 接口是 `ResourceLoader` 接口的扩展，它定义了将位置模式（例如，Ant 样式的路径模式）解析为 `Resource` 对象的策略。

```java
public interface ResourcePatternResolver extends ResourceLoader {

    String CLASSPATH_ALL_URL_PREFIX = "classpath*:";

    Resource[] getResources(String locationPattern) throws IOException;
}
```

如上所述，该接口还为类路径中的所有匹配资源定义了一个特殊的 `classpath*:` 资源前缀。注意，在这种情况下，资源位置应该是没有占位符的路径 —— 例如，`classpath*:/config/beans.xml`。JAR 文件或类路径中的不同目录可以包含具有相同路径和相同名称的多个文件。请参阅应用上下文构造方法资源路径及其子部分中的通配符，以了解有关 `classpath*:` 资源前缀的通配符支持的更多详细信息。

可以检查传入的 `ResourceLoader`（例如，通过 `ResourceLoaderAware` 语义提供的一个）是否也实现了这个扩展接口。

`PathMatchingResourcePatternResolver` 是一个独立的实现，可在 `ApplicationContext` 外部使用，`ResourceArrayPropertyEditor` 也使用它来填充 `Resource[]` bean 属性。`PathMatchingResourcePatternResolver` 能够将指定的资源位置路径解析为一个或多个匹配的 `Resource` 对象。源路径可以是一个简单的路径，它具有到目标资源的一对一映射，或者可以包含特殊的 `classpath*:` 前缀和/或内部 Ant 样式的正则表达式（使用 Spring 的 `org.springframework.util.AntPathMatcher` 实用程序进行匹配）。后者两者都是有效的通配符。

> 任何标准 `ApplicationContext` 中的默认 `ResourceLoader` 实际上是实现 `ResourcePatternResolver` 接口的 `PathMatchingResourcePatternSolver` 的实例。`ApplicationContext` 实例本身也是如此，它也实现 `ResourcePatternResolver` 接口并委托给默认的 `PathMatchingResourcePatternSolver`。

## 2.6 ResourceLoaderAware 接口

`ResourceLoaderAware` 接口是一个特殊的回调接口，用于标识希望提供 `ResourceLoader` 引用的组件。以下列表显示了 `ResourceLoaderAware` 接口的定义：

```java
public interface ResourceLoaderAware {

    void setResourceLoader(ResourceLoader resourceLoader);
}
```

当类实现 `ResourceLoaderAware` 并部署到应用程序上下文中（作为 Spring 托管 bean）时，应用程序上下文将其识别为 `ResourceLoaderAware`。然后，应用程序上下文调用 `setResourceLoader(ResourceLoader)`，将自身作为参数提供（记住，Spring 中的所有应用程序上下文都实现 `ResourceLoader` 接口）。

由于 `ApplicationContext` 是 `ResourceLoader`，bean 还可以实现 `ApplicationContextAware` 接口，并直接使用提供的应用程序上下文来加载资源。然而，一般来说，如果您只需要使用专门的 `ResourceLoader` 接口，那么最好使用它。代码将仅耦合到资源加载接口（可以被视为实用程序接口），而不耦合到整个Spring `ApplicationContext` 接口。

在应用程序组件中，您还可以依赖 `ResourceLoader` 的自动装配来实现 `ResourceLoaderAware` 接口。传统的 `constructor` 和 `byType` 自动装配模式（如“自动装配协作者”中所述）能够分别为构造函数参数或 setter 方法参数提供 `ResourceLoader`。要获得更大的灵活性（包括自动装配字段和多参数方法的能力），请考虑使用基于注解的自动关联功能。在这种情况下，`ResourceLoader` 会自动装配到需要 `ResourceLoader` 类型的字段、构造函数参数或方法参数中，只要该字段、构造函数或方法带有 `@Autowired` 注解。有关详细信息，请参阅“使用`@Autowired`”。

> 要为包含通配符或使用特殊 `classpath*:` 资源前缀的资源路径加载一个或多个 `Resource` 对象，请考虑将 `ResourcePatternResolver` 的实例自动装配到应用程序组件中，而不是 `ResourceLoader`。

## 2.7 作为依赖的资源

如果 bean 本身将通过某种动态过程确定并提供资源路径，那么 bean 使用 `ResourceLoader` 或 `ResourcePatternResolver` 接口加载资源可能是有意义的。例如，考虑加载某种类型的模板，其中所需的特定资源取决于用户的角色。如果资源是静态的，那么完全消除 `ResourceLoader` 接口（或 `ResourcePatternResolver` 接口）的使用是有意义的，让 bean 公开它需要的 `Resource` 属性，并期望它们被注入其中。

然后注入这些属性很简单，因为所有应用程序上下文都注册并使用一个特殊的 JavaBeans `PropertyEditor`，它可以将 `String` 路径转换为 `Resource` 对象。例如，以下 `MyBean` 类具有 `Resource` 类型的模板属性。

```java
public class MyBean {

    private Resource template;

    public setTemplate(Resource template) {
        this.template = template;
    }

    // ...
}
```

在 XML 配置文件中，可以使用该资源的简单字符串配置 `template` 属性，如下例所示：

```xml
<bean id="myBean" class="example.MyBean">
    <property name="template" value="some/resource/path/myTemplate.txt"/>
</bean>
```

请注意，资源路径没有前缀。因此，由于应用程序上下文本身将用作 `ResourceLoader`，因此资源将通过 `ClassPathResource`、`FileSystemResource` 或 `ServletContextResource` 加载，具体取决于应用程序上下文的确切类型。

如果需要强制使用特定的资源类型，可以使用前缀。以下两个示例显示了如何强制 `ClassPathResource` 和 `UrlResource`（后者用于访问文件系统中的文件）：

```xml
<property name="template" value="classpath:some/resource/path/myTemplate.txt">
```

```xml
<property name="template" value="file:///some/resource/path/myTemplate.txt"/>
```

如果 `MyBean` 类被重构以用于注解驱动的配置，则 `myTemplate.txt` 的路径可以存储在名为 `template.path` 的键下 — 例如，在 Spring 环境可用的属性文件中（请参阅环境抽象）。然后可以使用属性占位符通过 `@Value` 注解引用模板路径（请参见使用 `@Value`）。Spring 将以字符串的形式检索模板路径的值，一个特殊的 `PropertyEditor` 将把字符串转换为要注入 `MyBean` 构造函数的 `Resource` 对象。下面的示例演示了如何实现这一点。

```java
@Component
public class MyBean {

    private final Resource template;

    public MyBean(@Value("${template.path}") Resource template) {
        this.template = template;
    }

    // ...
}
```

如果我们希望支持在类路径中的多个位置的同一路径下发现的多个模板 —— 例如，在类路径中的多个 jar 中 —— 我们可以使用特殊的 `classpath*:` 前缀和通配符将 `template.path` 键定义为 `classpath*:/config/templates/*.txt`。如果我们按如下方式重新定义 `MyBean` 类，Spring 会将模板路径模式转换为可以注入 `MyBean` 构造函数的 `Resource` 对象数组。

```java
@Component
public class MyBean {

    private final Resource[] templates;

    public MyBean(@Value("${templates.path}") Resource[] templates) {
        this.templates = templates;
    }

    // ...
}
```

## 2.8 应用上下文和资源路径

本节介绍如何使用资源创建应用程序上下文，包括使用 XML 的快捷方式、如何使用通配符以及其他详细信息。

### 2.8.1 构造应用上下文

应用程序上下文构造函数（针对特定的应用程序上下文类型）通常将字符串或字符串数组作为资源的位置路径，例如构成上下文定义的 XML 文件。

当这样的位置路径没有前缀时，从该路径构建并用于加载 bean 定义的特定 `Resource` 类型取决于并适合于特定的应用程序上下文。例如，考虑创建 `ClassPathXmlApplicationContext` 的以下示例：

```java
ApplicationContext ctx = new ClassPathXmlApplicationContext("conf/appContext.xml");
```

bean 定义是从类路径加载的，因为使用了 `ClassPathResource`。但是，请考虑以下示例，该示例创建 `FileSystemXmlApplicationContext`：

```java
ApplicationContext ctx =
    new FileSystemXmlApplicationContext("conf/appContext.xml");
```

现在，bean 定义从文件系统位置加载（在本例中，相对于当前工作目录）。

注意，在位置路径上使用特殊的 `classpath` 前缀或标准 URL 前缀会覆盖为加载 bean 定义而创建的默认类型的 `Resource`。考虑以下示例：

```java
ApplicationContext ctx =
    new FileSystemXmlApplicationContext("classpath:conf/appContext.xml");
```

使用 `FileSystemXmlApplicationContext` 从类路径加载 bean 定义。但是，它仍然是 `FileSystemXmlApplicationContext`。如果它随后被用作 `ResourceLoader`，则任何未固定的路径仍被视为文件系统路径。

#### 构造 ClassPathXmlApplicationContext 实例 —— 快捷方式

`ClassPathXmlApplicationContext` 公开了许多构造函数以实现方便的实例化。基本思想是，您可以只提供一个字符串数组，该数组只包含XML文件本身的文件名（不包含前导路径信息），还可以提供一个 `Class`。然后 `ClassPathXmlApplicationContext` 从提供的类中派生路径信息。

考虑以下目录布局：

```
com/
  example/
    services.xml
    repositories.xml
    MessengerService.class
```

以下示例显示了如何实例化 `ClassPathXmlApplicationContext` 实例，该实例由名为 `services.xml` 和 `repositories.xml`（位于类路径上）的文件中定义的 bean 组成：

```java
ApplicationContext ctx = new ClassPathXmlApplicationContext(
    new String[] {"services.xml", "repositories.xml"}, MessengerService.class);
```

有关各种构造函数的详细信息，请参阅 `ClassPathXmlApplicationContext` javadoc。

### 2.8.2 应用上下文构造方法资源路径中的通配符

应用程序上下文构造函数值中的资源路径可以是简单的路径（如前所示），每个路径都有到目标 `Resource` 的一对一映射，或者可以包含特殊的 `classpath*:` 前缀或内部 Ant 样式模式（通过使用 Spring 的 `PathMatcher` 工具类进行匹配）。后两者都是有效的通配符。

该机制的一个用途是当您需要进行组件样式的应用程序组装时。所有组件都可以将上下文定义片段发布到一个已知的位置路径，当使用前缀为 `classpath*:` 的相同路径创建最终的应用程序上下文时，所有组件片段都会自动匹配。

请注意，此通配符特定于应用程序上下文构造函数中资源路径的使用（或者当您直接使用 `PathMatcher` 工具类类层次结构时），并在构建时解析。它与 `Resource` 类型本身无关。您不能使用 `classpath*:` 前缀来构造实际的 `Resource`，因为资源一次只能指向一个资源。

#### Ant 样式模式

路径位置可以包含 Ant 样式模式，如下例所示：

```
/WEB-INF/*-context.xml
com/mycompany/**/applicationContext.xml
file:C:/some/path/*-context.xml
classpath:com/mycompany/**/applicationContext.xml
```

当路径位置包含 Ant 样式模式时，解析器将遵循更复杂的过程来尝试解析通配符。它为到最后一个非通配符段的路径生成一个 `Resource`，并从中获取一个 URL。如果该 URL 不是 `jar:` URL 或容器特定的变量（例如 WebLogic 中的 `zip:`、WebSphere 中的 `wsjar` 等），则从中获取 `java.io.File`，并通过遍历文件系统来解析通配符。对于 jar URL，解析器要么从中获取 `java.net.JarURLConnection`，要么手动解析 jar URL，然后遍历 jar 文件的内容以解析通配符。

##### 对可移植性的影响

如果指定的路径已经是 `file` URL（隐式地，因为基本 `ResourceLoader` 是文件系统 URL，或者显式地），则保证通配符以完全可移植的方式工作。

如果指定的路径是类路径位置，则解析器必须通过调用 `Classloader.getResource()` 获取最后一个非通配符路径段 URL。由于这只是路径的一个节点（而不是末尾的文件），因此实际上（在 `ClassLoader` javadoc中）没有定义在这种情况下返回的 URL 的类型。实际上，它始终是一个 `java.io.File`，表示目录（类路径资源解析到文件系统位置）或某种类型的 jar URL（类路径路径资源解析为 jar 位置）。尽管如此，这项操作仍存在可移植性问题。

如果为最后一个非通配符段获取了 jar URL，解析器必须能够从中获取 `java.net.JarURLConnection` 或手动解析 jar URL，以便能够遍历 jar 的内容并解析通配符。这在大多数环境中都有效，但在其他环境中却失败了，我们强烈建议在依赖之前，在您的特定环境中彻底测试来自 jar 的资源的通配符解析。

#### `classpath*:` 前缀

在构建基于 XML 的应用程序上下文时，位置字符串可以使用特殊的 `classpath*:` 前缀，如下例所示：

```java
ApplicationContext ctx =
    new ClassPathXmlApplicationContext("classpath*:conf/appContext.xml");
```

这个特殊前缀指定必须获得与给定名称匹配的所有类路径资源（在内部，这基本上是通过调用 `ClassLoader.getResources(…)`）然后合并以形成最终的应用上下文定义。

> 通配符类路径依赖于底层 `ClassLoader` 的 `getResources()` 方法。由于现在大多数应用程序服务器都提供自己的 `ClassLoader` 实现，因此行为可能有所不同，尤其是在处理 jar 文件时。检查 `classpath*` 是否有效的一个简单测试是使用 `ClassLoader` 从 classpath 的 jar 中加载文件：`getClass().getClassLoader().getResources("<someFileInsideTheJar>")`。使用具有相同名称但位于两个不同位置的文件尝试此测试 — 例如，具有相同名称和路径但位于类路径上不同jar中的文件。如果返回不正确的结果，请检查应用程序服务器文档中可能影响 `ClassLoader` 行为的设置。

您还可以在位置路径的其余部分（例如，`classpath*:META-INF/*-beans.xml`）中将 `classpath*:` 前缀与 `PathMatcher` 模式组合。在这种情况下，解析策略相当简单：在最后一个非通配符路径段上使用 `ClassLoader.getResources()` 调用以获取类加载器层次结构中的所有匹配资源，前面描述的相同 `PathMatcher` 解析策略用于通配符子路径。

#### 与通配符相关的其他注解

注意，`classpath*:` 当与 Ant 样式模式结合时，只有在模式启动之前至少一个根目录才能可靠地工作，除非实际的目标文件位于文件系统中。这意味着 `classpath*：*.xml` 之类的模式可能无法从 jar 文件的根目录检索文件，而只能从扩展目录的根目录中检索文件。

Spring 检索类路径条目的能力源自 JDK 的 `ClassLoader.getResources()` 方法，该方法只返回空字符串的文件系统位置（指示要搜索的潜在根）。Spring 还评估了 jar 文件中的 `URLClassLoader` 运行时配置和 `java.class.path` 清单，但这不能保证会导致可移植行为。

> 扫描类路径包需要在类路径中存在相应的目录条目。当您使用 Ant 构建 JAR 时，不要激活 JAR 任务的 `files-only` 开关。此外，在某些环境中，基于安全策略，类路径目录可能不会公开 —— 例如，JDK 1.7.0_45 和更高版本上的独立应用程序（这需要在清单中设置“Trusted Library”。请参阅https://stackoverflow.com/questions/19394570/java-jre-7u45-breaks-classloader-getresources).
>
> 在 JDK 9 的模块路径（Jigsaw）上，Spring 的类路径扫描通常按预期工作。在这里，将资源放入专用目录也是非常推荐的，避免了在 jar 文件根级别搜索时出现的上述可移植性问题。

如果要搜索的根包在多个类路径位置可用，带有 `classpath:` 的 Ant 样式模式资源不保证能够找到匹配的资源。考虑以下资源位置示例：

```
com/mycompany/package1/service-context.xml
```

现在考虑一个 Ant 风格的路径，有人可能会使用它来查找该文件：

```
classpath:com/mycompany/**/service-context.xml
```

这样的资源可能只存在于类路径中的一个位置，但是当使用前面示例中的路径来尝试解析它时，解析器会使用 `getResource("com/mycompany");` 返回的（第一个）URL。如果此基本包节点存在于多个 `ClassLoader` 位置，则所需资源可能不存在于找到的第一个位置。因此，在这种情况下，您应该更喜欢使用 `classpath*:`，使用相同的 Ant 样式模式，该模式搜索包含 `com.mycompany` 基本包的所有类路径位置：`classpath*:com/mycompany/**/service-context.xml`。

### 2.8.3 FileSystemResource 警告

未附加到 `FileSystemApplicationContext` 的 `FileSystemResource`（即，当 `FileSystemApplicationContext` 不是实际的 `ResourceLoader` 时）将按照您的预期处理绝对路径和相对路径。相对路径相对于当前工作目录，而绝对路径相对于文件系统的根。

然而，出于向后兼容性（历史）的原因，当 `FileSystemApplicationContext` 是 `ResourceLoader` 时，这会发生变化。`FileSystemApplicationContext` 强制所有附加的 `FileSystemResource` 实例将所有位置路径视为相对路径，无论它们是否以前导斜杠开头。实际上，这意味着以下示例是等效的：

```java
ApplicationContext ctx =
    new FileSystemXmlApplicationContext("conf/context.xml");
```

```java
ApplicationContext ctx =
    new FileSystemXmlApplicationContext("/conf/context.xml");
```

以下示例也是等效的（尽管它们不同是有意义的，因为一种情况是相对的，另一种情况则是绝对的）：

```java
FileSystemXmlApplicationContext ctx = ...;
ctx.getResource("some/resource/path/myTemplate.txt");
```

```java
FileSystemXmlApplicationContext ctx = ...;
ctx.getResource("/some/resource/path/myTemplate.txt");
```

实际上，如果需要真正的绝对文件系统路径，则应避免将绝对路径与 `FileSystemResource` 或 `FileSystemXmlApplicationContext` 一起使用，并通过使用 `file:` URL 前缀强制使用 `UrlResource`。以下示例显示了如何执行此操作：

```java
// actual context type doesn't matter, the Resource will always be UrlResource
ctx.getResource("file:///some/resource/path/myTemplate.txt");
```

```java
// force this FileSystemXmlApplicationContext to load its definition via a UrlResource
ApplicationContext ctx =
    new FileSystemXmlApplicationContext("file:///conf/context.xml");
```

# 3. 验证，数据绑定，和类型转换

将验证视为业务逻辑有利弊，Spring 提供了一种验证和数据绑定的设计，不排除其中任何一种。具体来说，验证不应与 web 层绑定，并且应易于本地化，并且应可以插入任何可用的验证器。考虑到这些问题，Spring 提供了一个 `Validator` 协议，它在应用程序的每一层中都是基本的且非常有用的。

数据绑定对于将用户输入动态绑定到应用程序的域模型（或用于处理用户输入的任何对象）非常有用。Spring 提供了恰当命名的 `DataBinder` 来实现这一点。`Validator` 和 `DataBinder` 组成验证包，主要用于但不限于 web 层。

`BeanWrapper` 是 Spring 框架中的一个基本概念，在很多地方都有使用。然而，您可能不需要直接使用 `BeanWrapper`。然而，由于这是参考文档，我们觉得可能需要一些解释。我们在本章中解释 `BeanWrapper`，因为如果您打算使用它，那么在尝试将数据绑定到对象时很可能会这样做。

Spring 的 `DataBinder` 和较低级别的 `BeanWrapper` 都使用 `PropertyEditorSupport` 实现来解析和格式化属性值。`PropertyEditor` 和 `PropertyEditorSupport` 类型是 JavaBeans 规范的一部分，本章也将对此进行解释。Spring 的 `core.convert` 包提供了一个泛型转换工具，以及一个用于格式化 UI 字段值的高级 `format` 包。您可以将这些包用作 `PropertyEditorSupport` 实现的更简单的替代方案。本章还将讨论这些问题。

Spring 通过设置基础设施和 Spring 自己的 `Validator` 协议的适配器支持 JavaBean 验证。应用程序可以全局启用一次 Bean Validation，如 Java Bean Validation 中所述，并将其专门用于所有验证需求。在 web 层中，应用程序可以进一步为每个 `DataBinder` 注册控制器本地 Spring `Validator` 实例，如配置 `DataBinder` 中所述，这对于插入自定义验证逻辑非常有用。

## 3.1 通过使用 Spring 的 Validator 接口验证

Spring 有一个 `Validator` 接口，您可以使用它来验证对象。`Validator` 接口通过使用 `Errors` 对象工作，以便在验证时，验证器可以向 `Errors` 对象报告验证失败。

考虑以下小数据对象的示例：

```java
public class Person {

    private String name;
    private int age;

    // the usual getters and setters...
}
```

下一个示例通过实现 `org.springframework.validation.Validator` 接口的以下两个方法为 `Person` 类提供验证行为：

- `supports(Class)`：此 `Validator` 是否可以验证提供的 `Class` 的实例？
- `validate(Object, org.springframework.validation.Errors)`：验证给定的对象，如果出现验证错误，则将这些对象注册到给定的 `Errors` 对象。

实现 `Validator` 相当简单，特别是当您知道 Spring Framework 也提供 `ValidationUtils` 帮助类时。以下示例实现了 `Person` 实例的 `Validator`：

```java
public class PersonValidator implements Validator {

    /**
     * This Validator validates only Person instances
     */
    public boolean supports(Class clazz) {
        return Person.class.equals(clazz);
    }

    public void validate(Object obj, Errors e) {
        ValidationUtils.rejectIfEmpty(e, "name", "name.empty");
        Person p = (Person) obj;
        if (p.getAge() < 0) {
            e.rejectValue("age", "negativevalue");
        } else if (p.getAge() > 110) {
            e.rejectValue("age", "too.darn.old");
        }
    }
}
```

`ValidationUtils` 类上的静态 `rejectIfEmpty(..)` 方法用于拒绝 `name` 属性（如果该属性为 `null` 或空字符串）。看看 `ValidationUtils` javadoc，看看除了前面所示的示例之外，它还提供了哪些功能。

虽然可以实现一个 `Validator` 类来验证富对象中的每个嵌套对象，但最好将每个嵌套对象类的验证逻辑封装在自己的 `Validator` 实现中。“rich”对象的一个简单示例是 `Customer`，它由两个 `String` 属性（第一个和第二个名称）和一个复杂的 `Address` 对象组成。`Address` 对象可以独立于 `Customer` 对象使用，因此实现了一个不同的 `AddressValidator`。如果您希望 `CustomerValidator` 重用 `AddressValidator` 类中包含的逻辑而不使用复制和粘贴，则可以依赖注入或在 `CustomerValidator` 中实例化 `AddressValidator`，如下例所示：

```java
public class CustomerValidator implements Validator {

    private final Validator addressValidator;

    public CustomerValidator(Validator addressValidator) {
        if (addressValidator == null) {
            throw new IllegalArgumentException("The supplied [Validator] is " +
                "required and must not be null.");
        }
        if (!addressValidator.supports(Address.class)) {
            throw new IllegalArgumentException("The supplied [Validator] must " +
                "support the validation of [Address] instances.");
        }
        this.addressValidator = addressValidator;
    }

    /**
     * This Validator validates Customer instances, and any subclasses of Customer too
     */
    public boolean supports(Class clazz) {
        return Customer.class.isAssignableFrom(clazz);
    }

    public void validate(Object target, Errors errors) {
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "firstName", "field.required");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "surname", "field.required");
        Customer customer = (Customer) target;
        try {
            errors.pushNestedPath("address");
            ValidationUtils.invokeValidator(this.addressValidator, customer.getAddress(), errors);
        } finally {
            errors.popNestedPath();
        }
    }
}
```

验证错误报告给传递给验证器的 `Errors` 对象。在 Spring Web MVC 的情况下，您可以使用 `<spring:bind/>` 标记来检查错误消息，但也可以自己检查 `Errors` 对象。有关它提供的方法的更多信息可以在 java doc 中找到。

## 3.2 将代码解析为错误消息

我们讨论了数据绑定和验证。本节介绍输出与验证错误相对应的消息。在上一节所示的示例中，我们拒绝了 `name` 和 `age` 字段。如果我们想使用 `MessageSource` 输出错误消息，可以使用我们在拒绝字段时提供的错误代码（在本例中为“name”和“age”）。当您从 `Errors` 接口调用（直接或间接，例如，通过使用 `ValidationUtils` 类）`rejectValue` 或其他 `reject` 方法之一时，基础实现不仅会注册传入的代码，还会注册许多其他错误代码。`MessageCodesResolver` 确定 `Errors` 接口注册的错误代码。默认情况下，使用 `DefaultMessageCodesResolver`，它（例如）不仅用您给出的代码注册消息，还注册包含传递给拒绝方法的字段名的消息。因此，如果您通过使用 `rejectValue("age", "too.darn.old")` 拒绝字段，除了 `too.darn.old` 代码之外，Spring 还注册 `too.darn.old.age` 和 `too.darn.old.age.int`（第一个包含字段名，第二个包含字段类型）。这样做是为了方便开发人员查找错误消息。

有关 `MessageCodesResolver` 和默认策略的更多信息可以分别在 `MessageCodesResolver` 和 `DefaultMessageCodesResolver` 的 javadoc 中找到。

## 3.3 Bean 操纵和 BeanWrapper

# Servlet 技术栈的 Web

本部分文档介绍了对基于 Servlet API 构建并部署到 Servlet 容器的 Servlet 技术栈 web 应用程序的支持。各个章节包括 Spring MVC、View 技术、CORS 支持和 WebSocket 支持。有关反应式技术栈 web 应用程序，请参阅反应式技术栈的 Web。

# 1. Spring Web MVC

Spring Web MVC 是基于 Servlet API 构建的原始 Web 框架，从一开始就包含在 Spring 框架中。正式名称“Spring Web MVC”来自其源模块（`spring-webmvc`）的名称，但更常见的是“Spring MVC”。

与 Spring Web MVC 并行，Spring Framework 5.0 引入了一个反应式技术栈 Web 框架，其名称“Spring WebFlux”也是基于其源模块（`spring-webflux`）。本章介绍 Spring Web MVC。下一章将介绍 Spring WebFlux。

有关基线信息以及与 Servlet 容器和 Jakarta EE 版本范围的兼容性，请参阅 Spring Framework Wiki。

## 1.1 DispatcherServlet

与许多其他 web 框架一样，Spring MVC 是围绕前端控制器模式设计的，其中的中央 `Servlet`，`DispatcherServlet`，为请求处理提供了共享算法，而实际工作则由可配置的委托组件执行。该模型非常灵活，支持多种工作流。

与任何 `Servlet` 一样，`DispatcherServlet` 需要使用 Java 配置或 `web.xml` 根据 Servlet 规范声明和映射。反过来，`DispatcherServlet` 使用 Spring 配置来发现请求映射、视图解析、异常处理等所需的委托组件。

以下 Java 配置示例注册并初始化 `DispatcherServlet`，它由 Servlet 容器自动检测（请参阅 Servlet 配置）：

```java
public class MyWebApplicationInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext servletContext) {

        // Load Spring web application configuration
        AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
        context.register(AppConfig.class);

        // Create and register the DispatcherServlet
        DispatcherServlet servlet = new DispatcherServlet(context);
        ServletRegistration.Dynamic registration = servletContext.addServlet("app", servlet);
        registration.setLoadOnStartup(1);
        registration.addMapping("/app/*");
    }
}
```

> 除了直接使用 ServletContext API 之外，还可以扩展 `AbstractAnnotationConfigDispatcherServletInitializer` 并重写特定方法（请参阅上下文层次结构下的示例）。

> 对于编程用例，可以使用 `GenericWebApplicationContext` 作为 `AnnotationConfigWebApplicationContext` 的替代方案。有关详细信息，请参阅 `GenericWebApplicationContext` Javadoc。

以下 `web.xml` 配置示例注册并初始化 `DispatcherServlet`：

```xml
<web-app>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/app-context.xml</param-value>
    </context-param>

    <servlet>
        <servlet-name>app</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value></param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>app</servlet-name>
        <url-pattern>/app/*</url-pattern>
    </servlet-mapping>

</web-app>
```

> Spring Boot 遵循不同的初始化顺序。Spring Boot 使用 Spring 配置来引导自身和嵌入式 Servlet 容器，而不是与 Servlet 容器的生命周期挂钩。在 Spring 配置中检测到过滤器和 Servlet 声明，并向 Servlet 容器注册。有关更多详细信息，请参阅 Spring Boot 文档。

### 1.1.1 上下文层次结构

`DispatcherServlet` 期望 `WebApplicationContext`（普通 `ApplicationContext` 的扩展）用于其自身的配置。`WebApplicationContext` 链接到 `ServletContext` 及其关联的 `Servlet`。它还绑定到 `ServletContext`，因此如果应用程序需要访问它，它们可以对 `RequestContextUtils` 使用静态方法来查找 `WebApplicationContext`。

对于许多应用程序，拥有单个 `WebApplicationContext` 既简单又足够。还可以具有上下文层次结构，其中根 `WebApplicationContext` 跨多个 `DispatcherServlet`（或其他 `Servlet`）实例共享，每个实例都具有自己的子 `WebApplicationContext` 配置。有关上下文层次结构功能的更多信息，请参阅应用程序上下文的其他功能。

根 `WebApplicationContext` 通常包含基础架构 bean，例如需要跨多个 `Servlet` 实例共享的数据存储库和业务服务。这些 bean 是有效继承的，并且可以在 servlet 特定的子 `WebApplicationContext` 中覆盖（即，重新声明），该上下文通常包含给定 `Servlet` 本地的 bean。

以下示例配置 `WebApplicationContext` 层次结构：

```java
public class MyWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class<?>[] { RootConfig.class };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[] { App1Config.class };
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/app1/*" };
    }
}
```

> 如果不需要应用程序上下文层次结构，则应用程序可以通过 `getRootConfigClasses()` 返回所有配置，并从 `getServletConfigClasses()` 返回 `null`。

以下示例显示了与 `web.xml` 等效的文件：

```xml
<web-app>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/root-context.xml</param-value>
    </context-param>

    <servlet>
        <servlet-name>app1</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>/WEB-INF/app1-context.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>app1</servlet-name>
        <url-pattern>/app1/*</url-pattern>
    </servlet-mapping>

</web-app>
```

> 如果不需要应用程序上下文层次结构，则应用程序可以仅配置“根”上下文，并将 `contextConfigLocation` Servlet 参数留空。

### 1.1.2 特殊 Bean 类型

`DispatcherServlet` 委托特殊 bean 处理请求并呈现适当的响应。我们所说的“特殊 bean”是指实现框架协议的 Spring 托管 `Object` 实例。这些通常带有内置协议，但您可以自定义它们的属性并扩展或替换它们。

下表列出了 `DispatcherServlet` 检测到的特殊 bean：

| Bean 类型                                                    | 说明                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `HandlerMapping`                                             | 将请求与[拦截器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-handlermapping-interceptor)列表一起映射到处理程序进行预处理和后处理。该映射基于一些标准，其细节因 `HandlerMapping` 实现而异。两个主要的 `HandlerMaping` 实现是 `RequestMappingHandlerMapping`（支持 `@RequestMapping` 注解方法）和 `SimpleUrlHandlerMapping`（维护 URI 路径模式到处理程序的显式注册）。 |
| `HandlerAdapter`                                             | 帮助 `DispatcherServlet` 调用映射到请求的处理程序，而不管实际如何调用该处理程序。例如，调用带注解的控制器需要解析注解。`HandlerAdapter` 的主要目的是保护 `DispatcherServlet` 不受此类细节的影响。 |
| [`HandlerExceptionResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-exceptionhandlers) | 解决异常的策略，可能将异常映射到处理程序、HTML 错误视图或其他目标。参见[异常](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-exceptionhandlers)。 |
| [`ViewResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-viewresolver) | 将处理程序返回的逻辑上基于 `string` 的视图名称解析为实际的 `View`，并用其呈现到响应。参见[视图解析](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-viewresolver)和[视图技术](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-view)。 |
| [`LocaleResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-localeresolver), [LocaleContextResolver](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-timezone) | 解析客户端正在使用的 `Locale` 以及可能的时区，以便能够提供国际化视图。参见[区域设置](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-localeresolver)。 |
| [`ThemeResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-themeresolver) | 解析 web 应用程序可以使用的主题——例如提供个性化布局。参见[主题](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-themeresolver)。 |
| [`MultipartResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-multipart) | 借助某些 multi-part 解析库解析 multipart 请求（例如，浏览器表单文件上载）的抽象。参见 [Multipart 解析器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-multipart)。 |
| [`FlashMapManager`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-flash-attributes) | 存储和检索可用于将属性从一个请求传递到另一个请求（通常通过重定向）的“输入”和“输出” `FlashMap`。参见 [Flash 属性](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-flash-attributes)。 |

### 1.1.3 Web MVC 配置

应用程序可以声明特殊 Bean 类型中列出的处理请求所需的基础结构 Bean。`DispatcherServlet` 检查每个特殊 bean 的 `WebApplicationContext`。如果没有匹配的 bean 类型，则返回 `DispatcherServlet.properties` 中列出的默认类型。

在大多数情况下，MVC 配置是最好的起点。它用 Java 或 XML 声明所需的 bean，并提供更高级别的配置回调 API 来定制它。

> Spring Boot 依赖于 MVC Java 配置来配置 Spring MVC，并提供了许多额外方便的选项。

### 1.1.4 Servlet 配置

在 Servlet 环境中，您可以选择以编程方式配置 Servlet 容器作为替代方案或与 `web.xml` 文件结合使用。以下示例注册 `DispatcherServlet`：

```java
import org.springframework.web.WebApplicationInitializer;

public class MyWebApplicationInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext container) {
        XmlWebApplicationContext appContext = new XmlWebApplicationContext();
        appContext.setConfigLocation("/WEB-INF/spring/dispatcher-config.xml");

        ServletRegistration.Dynamic registration = container.addServlet("dispatcher", new DispatcherServlet(appContext));
        registration.setLoadOnStartup(1);
        registration.addMapping("/");
    }
}
```

`WebApplicationInitializer` 是 Spring MVC 提供的一个接口，可确保检测到您的实现并自动用于初始化任何 Servlet 3 容器。名为 `AbstractDispatcherServletInitializer` 的 `WebApplicationInitializer` 抽象基类实现通过重写方法来指定 servlet 映射和 `DispatcherServlet` 配置的位置，从而更容易注册 `DispatcherServlet`。

对于使用基于 Java 的 Spring 配置的应用程序，建议这样做，如下例所示：

```java
public class MyWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return null;
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[] { MyWebConfig.class };
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" };
    }
}
```

如果使用基于 XML 的 Spring 配置，则应直接从 `AbstractDispatcherServletInitializer` 进行扩展，如下例所示：

```java
public class MyWebAppInitializer extends AbstractDispatcherServletInitializer {

    @Override
    protected WebApplicationContext createRootApplicationContext() {
        return null;
    }

    @Override
    protected WebApplicationContext createServletApplicationContext() {
        XmlWebApplicationContext cxt = new XmlWebApplicationContext();
        cxt.setConfigLocation("/WEB-INF/spring/dispatcher-config.xml");
        return cxt;
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" };
    }
}
```

`AbstractDispatcherServletInitializer` 还提供了一种方便的方法来添加 `Filter` 实例，并将它们自动映射到 `DispatcherServlet`，如下例所示：

```java
public class MyWebAppInitializer extends AbstractDispatcherServletInitializer {

    // ...

    @Override
    protected Filter[] getServletFilters() {
        return new Filter[] {
            new HiddenHttpMethodFilter(), new CharacterEncodingFilter() };
    }
}
```

每个过滤器都会根据其具体类型添加一个默认名称，并自动映射到 `DispatcherServlet`。

`AbstractDispatcherServletInitializer` 的 `isAsyncSupported` 受保护方法提供了一个地方，可以在 `DispatcherServlet` 和映射到它的所有筛选器上启用异步支持。默认情况下，此标志设置为 `true`。

最后，如果需要进一步自定义 `DispatcherServlet` 本身，可以重写 `createDispatcherServlet` 方法。

### 1.1.5 处理

DispatcherServlet处理请求如下：

- `WebApplicationContext` 在请求中作为控制器和流程中的其他元素可以使用的属性进行搜索和绑定。默认情况下，它绑定在 `DispatcherServlet.WEB_APPLICATION_CONTEXT_ATTRIBUTE` 键下。
- 区域设置解析器（locale resolver）绑定到请求，以让流程中的元素解析处理请求时使用的区域设置（呈现视图、准备数据等）。如果不需要区域设置解析，则不需要区域配置解析器。
- 主题解析器绑定到请求，以让视图等元素确定要使用的主题。如果不使用主题，可以忽略它。
- 如果指定 multipart 文件解析器，将检查请求的 multiparts。如果找到 multiparts，则将请求包装在 `MultipartHttpServletRequest` 中，以供流程中的其他元素进一步处理。有关 multipart 处理的更多信息，请参阅 Multipart 解析器。
- 搜索适当的处理程序。如果找到了处理程序，则运行与处理程序（预处理器、后处理器和控制器）关联的执行链，以准备渲染模型。或者，对于带注解的控制器，可以（在 `HandlerAdapter` 中）呈现响应，而不是返回视图。
- 如果返回模型，则会渲染视图。如果没有返回模型（可能是由于预处理器或后处理器拦截了请求，可能是出于安全原因），则不会呈现视图，因为请求可能已经完成。

`WebApplicationContext` 中声明的 `HandlerExceptionResolver` bean 用于解决请求处理过程中引发的异常。这些异常解析器允许定制逻辑以解决异常。有关详细信息，请参阅异常。

对于 HTTP 缓存支持，处理程序可以使用 `WebRequest` 的 `checkNotModified` 方法，以及注解控制器的其他选项，如“控制器的 HTTP 缓存”中所述。

通过将 Servlet 初始化参数（`init-param` 元素）添加到 `web.xml` 文件中的 Servlet 声明中，可以自定义各个 `DispatcherServlet` 实例。下表列出了支持的参数：

| 参数                             | 说明                                                         |
| :------------------------------- | :----------------------------------------------------------- |
| `contextClass`                   | 实现 `ConfigurationWebApplicationContext` 的类，该类将由此 Servlet 实例化和本地配置。默认情况下，使用 `XmlWebApplicationContext`。 |
| `contextConfigLocation`          | 传递给上下文实例（由 `contextClass` 指定）的字符串，以指示可以在何处找到上下文。该字符串可能由多个字符串（使用逗号作为分隔符）组成，以支持多个上下文。如果多个上下文位置包含定义了两次的 bean，则最新位置优先。 |
| `namespace`                      | `WebApplicationContext` 的命名空间。默认为 `[servlet-name]-servlet`。 |
| `throwExceptionIfNoHandlerFound` | 当未找到请求的处理程序时，是否引发 `NoHandlerFoundException`。然后，可以使用 `HandlerExceptionResolver`（例如，使用 `@ExceptionHandler` 控制器方法）捕获异常，并将其作为其他任何方法进行处理。默认情况下，此设置为 `false`，在这种情况下，`DispatcherServlet` 将响应状态设置为404（NOT_FOUND），而不会引发异常。注意，如果[默认 servlet 处理](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-default-servlet-handler)被配置，未解决的请求总是被转发到默认 servlet，并且永远不会引发404。 |

### 1.1.6 路径匹配

Servlet API 将完整的请求路径公开为 `requestURI`，并将其进一步细分为 `contextPath`、`servletPath` 和 `pathInfo`，它们的值取决于 Servlet 的映射方式。从这些输入中，Spring MVC 需要确定用于映射处理程序的查找路径，如果适用，应排除 `contextPath` 和任何 `servletMapping` 前缀。

`servletPath` 和 `pathInfo` 被解码，这使得它们不可能直接与完整的 `requestURI` 进行比较，从而导出 lookupPath，这使得有必要对 `requestURI` 进行解码。然而，这会带来自身的问题，因为路径可能包含编码的保留字符，例如 `"/"` 或 `";"`，这些字符在解码后会改变路径的结构，这也会导致安全问题。此外，Servlet 容器可能会在不同程度上规范化 `servletPath`，这使得进一步无法对 `requestURI` 执行 `startsWith` 比较。

这就是为什么最好避免依赖基于前缀的 `servletPath` 映射类型附带的 `servletPath`。如果 `DispatcherServlet` 被映射为带有 `"/"` 的默认 Servlet，或者没有带有 `"/*"` 的前缀，并且 Servlet 容器是 4.0+，那么 Spring MVC 能够检测 Servlet 映射类型，并完全避免使用 `servletPath` 和 `pathInfo`。在 3.1 Servlet 容器上，假设相同的 Servlet 映射类型，可以通过 MVC 配置中的路径匹配提供 `alwaysUseFullPath=true` 的 `UrlPathHelper` 来实现等效。

幸运的是，默认的 Servlet 映射 `"/"` 是一个不错的选择。然而，仍然存在一个问题，即需要对 `requestURI` 进行解码，以便能够与控制器映射进行比较。这也是不希望的，因为可能会解码改变路径结构的保留字符。如果不需要这样的字符，则可以拒绝它们（如 Spring Security HTTP 防火墙），或者可以使用 `urlDecode=false` 配置 `UrlPathHelper`，但控制器映射需要与编码路径匹配，而编码路径可能并不总是正常工作。此外，有时 `DispatcherServlet` 需要与另一个 Servlet 共享 URL 空间，并且可能需要通过前缀进行映射。

当使用 `PathPatternParser` 和已解析模式作为字符串路径匹配与 `AntPathMatcher` 的替代时，可以解决上述问题。`PathPatternParser` 从 5.3 版开始可在 Spring MVC 中使用，默认情况下从 6.0 版开始启用。与需要解码查找路径或编码控制器映射的 `AntPathMatcher` 不同，解析后的 `PathPattern` 与名为 `RequestPath` 的路径解析表示相匹配，一次只能匹配一个路径段。这允许单独解码和净化路径段值，而不存在改变路径结构的风险。解析的 `PathPattern` 还支持使用 `servletPath` 前缀映射，只要使用了 Servlet 路径映射并且前缀保持简单，即没有编码字符。有关模式语法的详细信息和比较，请参阅模式比较。

### 1.1.7 拦截

所有 `HandlerMapping` 实现都支持处理程序拦截器，当您希望将特定功能应用于特定请求时，这些拦截器非常有用——例如，检查委托人。拦截器必须使用三种方法实现 `org.springframework.web.servlet` 包中的 `HandlerInterceptor`，这三种方法应提供足够的灵活性来执行各种预处理和后处理：

- `preHandle(..)`：在实际处理程序运行之前
- `postHandle(..)`：运行处理程序后
- `afterCompletion(..)`：完成请求后

`preHandle(..)` 方法返回布尔值。您可以使用此方法中断或继续执行链的处理。当此方法返回 `true` 时，处理程序执行链将继续。当它返回 false 时，`DispatcherServlet` 假定拦截器本身已经处理了请求（例如，呈现了一个适当的视图），并且不会继续执行其他拦截器和执行链中的实际处理程序。

有关如何配置拦截器的示例，请参阅 MVC 配置部分中的拦截器。您还可以通过在各个 `HandlerMapping` 实现上使用 setter 来直接注册它们。

`postHandle` 方法在 `@ResponseBody` 和 `ResponseEntity` 方法中不太有用，这些方法的响应是在 `HandlerAdapter` 中和 `postHandle` 之前编写和提交的。这意味着对响应进行任何更改（如添加额外的标头）都为时已晚。对于这种情况，您可以实现 `ResponseBodyAdvice`，并将其声明为控制器切面 bean，或者直接在 `RequestMappingHandlerAdapter` 上配置它。

### 1.1.8 异常

如果在请求映射过程中发生异常或从请求处理程序（如 `@Controller`）抛出异常，`DispatcherServlet` 将委托给 `HandlerExceptionResolver` bean 链，以解决异常并提供替代处理，这通常是错误响应。

下表列出了可用的 `HandlerExceptionResolver` 实现：

| `HandlerExceptionResolver`                                   | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `SimpleMappingExceptionResolver`                             | 异常类名称和错误视图名称之间的映射。用于在浏览器应用程序中呈现错误页面。 |
| [`DefaultHandlerExceptionResolver`](https://docs.spring.io/spring-framework/docs/6.0.6/javadoc-api/org/springframework/web/servlet/mvc/support/DefaultHandlerExceptionResolver.html) | 解析 Spring MVC 引发的异常并将其映射到 HTTP 状态代码。另请参阅可选的 `ResponseEntityExceptionHandler` 和[错误响应](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-rest-exceptions)。 |
| `ResponseStatusExceptionResolver`                            | 使用 `@ResponseStatus` 注解解析异常，并根据注解中的值将其映射到 HTTP 状态代码。 |
| `ExceptionHandlerExceptionResolver`                          | 通过调用 `@Controller` 或 `@ControllerAdvice` 类中的 `@ExceptionHandler` 方法来解决异常。请参见 [@ExceptionHandler 方法](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-exceptionhandler)。 |

#### 解析器链

通过在 Spring 配置中声明多个 `HandlerExceptionResolver` bean 并根据需要设置其 `order` 属性，可以形成异常解析器链。`order` 属性越高，异常解析程序定位得越晚。

`HandlerExceptionResolver` 的约定指定它可以返回：

- 指向错误视图的 `ModelAndView`。
- 如果在冲突解决程序中处理了异常，则返回空 `ModelAndView`。
- 如果异常仍然未解决，则为 `null`，供后续解析器尝试；如果异常仍然在末尾，则允许冒泡到 Servlet 容器。

MVC 配置自动为默认的 Spring MVC 异常、`@ResponseStatus` 注解的异常以及 `@ExceptionHandler` 方法的支持声明内置解析器。您可以自定义或替换该列表。

#### 容器错误页面

如果任何 `HandlerExceptionResolver` 都无法解析异常，因此需要传播，或者如果响应状态设置为错误状态（即 4xx、5xx），Servlet 容器可以以 HTML 格式呈现默认错误页面。要自定义容器的默认错误页，可以在 `web.xml` 中声明错误页映射。以下示例显示了如何做到这一点：

```xml
<error-page>
    <location>/error</location>
</error-page>
```

给定前面的示例，当出现异常或响应处于错误状态时，Servlet 容器会在容器中向配置的 URL（例如 `/error`）发出 ERROR 调度。然后由 `DispatcherServlet` 处理，可能将其映射到 `@Controller`，该 `@Controller` 可以实现为返回带有模型的错误视图名称或呈现 JSON 响应，如下例所示：

```java
@RestController
public class ErrorController {

    @RequestMapping(path = "/error")
    public Map<String, Object> handle(HttpServletRequest request) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("status", request.getAttribute("jakarta.servlet.error.status_code"));
        map.put("reason", request.getAttribute("jakarta.servlet.error.message"));
        return map;
    }
}
```

> Servlet API 不提供在 Java 中创建错误页映射的方法。但是，您可以同时使用`WebApplicationInitializer` 和最小的 `web.xml`。

### 1.1.9 视图解析

Spring MVC 定义了 `ViewResolver` 和 `View` 接口，这些接口允许您在浏览器中渲染模型，而无需将您绑定到特定的视图技术。`ViewResolver` 提供了视图名称和实际视图之间的映射。视图解决了在移交给特定视图技术之前准备数据的问题。
下表提供了 `ViewResolver` 层次结构的详细信息：

| ViewResolver                     | 描述                                                         |
| :------------------------------- | :----------------------------------------------------------- |
| `AbstractCachingViewResolver`    | `AbstractCachingViewResolver` 的子类缓存它们解析的视图实例。缓存提高了某些视图技术的性能。您可以通过将 `cache` 属性设置为 `false` 来关闭缓存。此外，如果必须在运行时刷新某个视图（例如，修改 FreeMarker 模板时），则可以使用 `removeFromCache(String viewName，Locale loc)` 方法。 |
| `UrlBasedViewResolver`           | `ViewResolver` 接口的简单实现，无需显式映射定义即可将逻辑视图名称直接解析为 URL。如果逻辑名称以直接的方式与视图资源的名称匹配，而不需要任意映射，则这是合适的。 |
| `InternalResourceViewResolver`   | 方便的 `UrlBasedViewResolver` 子类，支持 `InternalResourceView`（实际上是 Servlet 和 JSP）和 `JstlView` 等子类。您可以使用 `setViewClass(..)` 为该解析器生成的所有视图指定视图类。请参见 [`UrlBasedViewResolver`](https://docs.spring.io/spring-framework/docs/6.0.6/javadoc-api/org/springframework/web/reactive/result/view/UrlBasedViewResolver.html) javadoc 获取详细信息。 |
| `FreeMarkerViewResolver`         | 方便的 `UrlBasedViewResolver` 子类，支持 `FreeMarkerView` 及其自定义子类。 |
| `ContentNegotiatingViewResolver` | 实现 `ViewResolver` 接口，该接口根据请求文件名或 `Accept` 标头解析视图。参见[内容协商](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-multiple-representations)。 |
| `BeanNameViewResolver`           | 实现 `ViewResolver` 接口，该接口将视图名称解释为当前应用程序上下文中的 bean 名称。这是一个非常灵活的变体，允许基于不同的视图名称混合和匹配不同的视图类型。每个这样的 `View` 都可以定义为 bean，例如在 XML 或配置类中。 |

#### 处理

您可以通过声明多个解析器 bean，并在必要时设置 `order` 属性以指定排序，来链接视图解析器。请记住，`order` 属性越高，视图解析器在链中的位置就越晚。

`ViewResolver` 的约定指定它可以返回 null 以指示找不到视图。然而，对于 JSP 和 `InternalResourceViewResolver`，确定 JSP 是否存在的唯一方法是通过 `RequestDispatcher` 执行分派。因此，必须始终将 `InternalResourceViewResolver` 配置为视图解析器整体顺序中的最后一个。

配置视图解析与将 `ViewResolver` bean 添加到 Spring 配置一样简单。MVC 配置为视图解析器和添加无逻辑视图控制器提供了一个专用的配置 API，这对于无控制器逻辑的 HTML 模板渲染非常有用。

#### 重定向

视图名称中的特殊 `redirect:` 前缀允许您执行重定向。`UrlBasedViewResolver`（及其子类）将此识别为需要重定向的指令。视图名称的其余部分是重定向 URL。

净效果与控制器返回 `RedirectView` 相同，但现在控制器本身可以根据逻辑视图名称进行操作。逻辑视图名称（如 `redirect://myapp/some/resources`）相对于当前 Servlet 上下文进行重定向，而名称如 `redirect:https://myhost.com/some/arbitrary/path` 重定向到绝对 URL。

注意，如果使用 `@ResponseStatus` 注解控制器方法，则注解值优先于 `RedirectView` 设置的响应状态。

#### 转发

还可以为最终由 `UrlBasedViewResolver` 和子类解析的视图名称使用特殊的 `forward:` 前缀。这将创建一个 `InternalResourceView`，该视图执行 `RequestDispatcher.forward()`。因此，此前缀对于 `InternalResourceViewResolver` 和 `InternalResourceView`（对于 JSP）不太有用，但如果您使用另一种视图技术，但仍希望强制由 Servlet/JSP 引擎处理资源的转发，则会有所帮助。请注意，您也可以链接多个视图解析器。

#### 内容协商

`ContentNegotiatingViewResolver` 不解析视图本身，而是委托给其他视图解析器，并选择与客户端请求的表示类似的视图。可以从 `Accept` 标头或查询参数（例如，`"/path?format=pdf"`）确定表示形式。

`ContentNegotiatingViewResolver` 通过将请求媒体类型与其每个 `ViewResolver` 关联的视图支持的媒体类型（也称为内容类型）进行比较，选择适当的 `View` 来处理请求。列表中第一个具有兼容内容类型的视图将表示形式返回给客户端。如果 `ViewResolver` 链无法提供兼容的视图，则会查阅通过 `DefaultViews` 属性指定的视图列表。后一个选项适用于可以呈现当前资源的适当表示的单例 `View`，而不管逻辑视图名称如何。`Accept` 标头可以包含通配符（例如 `text/*`），在这种情况下，内容类型为 `text/xml` 的视图是兼容的匹配项。

有关配置详细信息，请参阅 MVC 配置下的视图解析器。

### 1.1.10 区域

Spring 架构的大多数部分都支持国际化，就像 Spring web MVC 框架一样。`DispatcherServlet` 允许您使用客户端的区域（locale）设置自动解析消息。这是通过 `LocaleResolver` 对象完成的。

当请求传入时，`DispatcherServlet` 会查找区域设置解析器，如果找到了，它会尝试使用它来设置区域设置。通过使用 `RequestContext.getLocale()` 方法，您可以始终检索由区域设置解析器解析的区域设置。

除了自动区域设置解析之外，还可以将拦截器附加到处理程序映射（有关处理程序映射拦截器的更多信息，请参阅拦截器），以在特定情况下（例如，基于请求中的参数）更改区域设置。

区域设置解析器和拦截器在 `org.springframework.web.servlet.i18n` 包中定义，并以正常方式在应用程序上下文中配置。Spring 中包含以下语言环境解析器选择。

- [时区](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-timezone)
- [头解析器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-localeresolver-acceptheader)
- [Cookie 解析器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-localeresolver-cookie)
- [会话解析器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-localeresolver-session)
- [区域拦截器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-localeresolver-interceptor)

#### 时区

除了获取客户端的区域设置外，了解其时区通常也是有用的。`LocaleContextResolver` 接口提供了 `LocaleResolver` 的扩展，使解析器能够提供更丰富的 `LocaleContext`，其中可能包含时区信息。

如果可用，可以使用 `RequestContext.getTimeZone()` 方法获取用户的 `TimeZone`。在 Spring 的 `ConversionService` 中注册的任何 Date/Time `Converter` 和 `Formatter` 对象都会自动使用时区信息。

#### 头解析器

此区域设置解析器检查客户端（例如，web 浏览器）发送的请求中的 `accept-language` 标头。通常，此标头字段包含客户端操作系统的区域设置。请注意，此解析器不支持时区信息。

#### Cookie 解析器

此区域设置解析器检查客户端上可能存在的 `Cookie`，以查看是否指定了 `Locale` 或 `TimeZone`。如果是，则使用指定的详细信息。通过使用此区域设置解析器的财产，您可以指定 cookie 的名称以及最长期限。以下示例定义了 `CookieLocaleResolver`：

```xml
<bean id="localeResolver" class="org.springframework.web.servlet.i18n.CookieLocaleResolver">

    <property name="cookieName" value="clientlanguage"/>

    <!-- in seconds. If set to -1, the cookie is not persisted (deleted when browser shuts down) -->
    <property name="cookieMaxAge" value="100000"/>

</bean>
```

下表介绍了 CookieLocaleResolver 的属性：

| 属性           | 默认值               | 描述                                                         |
| :------------- | :------------------- | :----------------------------------------------------------- |
| `cookieName`   | 类名 + LOCALE        | cookie 的名字                                                |
| `cookieMaxAge` | Servlet 容器的默认值 | cookie 在客户端上保留的最长时间。如果指定了 `-1`，则不会持久化 cookie。只有在客户端关闭浏览器之前，它才可用。 |
| `cookiePath`   | /                    | 将 cookie 的可见性限制在网站的特定部分。当指定 `cookiePath` 时，cookie 仅对该路径及其下的路径可见。 |

#### 会话解析器

`SessionLocaleResolver` 允许您从可能与用户请求关联的会话中检索 `Locale` 和 `TimeZone`。与 `CookieLocaleResolver` 不同，此策略将本地选择的区域设置存储在 Servlet 容器的 `HttpSession` 中。因此，这些设置对于每个会话都是临时的，因此在每个会话结束时都会丢失。

注意，与外部会话管理机制（如 Spring Session 项目）没有直接关系。此 `SessionLocaleResolver` 根据当前 `HttpServletRequest` 评估并修改相应的 `HttpSession` 属性。

#### 区域拦截器

您可以通过将 `LocaleChangeInterceptor` 添加到 `HandlerMapping` 定义之一来启用区域设置的更改。它检测请求中的一个参数，并相应地更改区域设置，在调度程序的应用程序上下文中调用 `LocaleResolver` 上的 `setLocale` 方法。下一个示例显示，对包含名为 `siteLanguage` 的参数的所有 `*.view` 资源的调用现在会更改区域设置。例如，对 URL 的请求，`https://www.sf.net/home.view?siteLanguage=nl`，将站点语言更改为荷兰语。以下示例显示了如何截取区域设置：

```xml
<bean id="localeChangeInterceptor"
        class="org.springframework.web.servlet.i18n.LocaleChangeInterceptor">
    <property name="paramName" value="siteLanguage"/>
</bean>

<bean id="localeResolver"
        class="org.springframework.web.servlet.i18n.CookieLocaleResolver"/>

<bean id="urlMapping"
        class="org.springframework.web.servlet.handler.SimpleUrlHandlerMapping">
    <property name="interceptors">
        <list>
            <ref bean="localeChangeInterceptor"/>
        </list>
    </property>
    <property name="mappings">
        <value>/**/*.view=someController</value>
    </property>
</bean>
```

### 1.1.11 主题

您可以应用 Spring Web MVC 框架主题来设置应用程序的整体外观，从而增强用户体验。主题是影响应用程序视觉样式的静态资源的集合，通常是样式表和图像。

> 从 6.0 开始，主题的支持已经被弃用，转而使用 CSS，并且在服务器端没有任何特殊支持。

#### 定义主题

要在 web 应用程序中使用主题，必须设置 `org.springframework.ui.context.ThemeSource` 接口的实现。`WebApplicationContext` 接口扩展了 `ThemeSource`，但将其职责委托给专用实现。默认情况下，委托是 `org.springframework.ui.context.support.ResourceBundleThemeSource` 实现，它从类路径的根目录加载属性文件。要使用自定义 `ThemeSource` 实现或配置 `ResourceBundleThemeSource` 的基本名称前缀，可以使用保留名称 `ThemeSource` 在应用程序上下文中注册 bean。web 应用程序上下文自动检测具有该名称的 bean 并使用它。

使用 `ResourceBundleThemeSource` 时，主题是在简单的属性文件中定义的。属性文件列出了构成主题的资源，如下例所示：

```properties
styleSheet=/themes/cool/style.css
background=/themes/cool/img/coolBg.jpg
```

属性的键是引用视图代码中主题元素的名称。对于 JSP，通常使用 `spring:theme` 自定义标记来完成此操作，该标记与 `spring:message` 标记非常相似。以下 JSP 片段使用上一个示例中定义的主题自定义外观：

```jsp
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<html>
    <head>
        <link rel="stylesheet" href="<spring:theme code='styleSheet'/>" type="text/css"/>
    </head>
    <body style="background=<spring:theme code='background'/>">
        ...
    </body>
</html>
```

默认情况下，`ResourceBundleThemeSource` 使用空的基名称前缀。因此，属性文件从类路径的根目录加载。因此，您可以将 `cool.properties` 主题定义放在类路径根目录中（例如，在 `/WEB-INF/classes` 中）。`ResourceBundleThemeSource` 使用标准的 Java 资源包加载机制，允许主题的完全国际化。例如，我们可以有一个 `/WEB-INF/classes/cool_nl.properties`，它引用一个特殊的背景图像，上面有荷兰语文本。

#### 解析主题

定义主题后，如前一节所述，您可以决定使用哪个主题。`DispatcherServlet` 查找名为 `themeResolver` 的 bean，以找出要使用的 `themeResolver` 实现。主题解析器的工作方式与 `LocaleResolver` 大致相同。它检测用于特定请求的主题，也可以更改请求的主题。下表描述了 Spring 提供的主题解析器：

| 类                     | 描述                                                         |
| :--------------------- | :----------------------------------------------------------- |
| `FixedThemeResolver`   | 选择使用 `defaultThemeName` 属性设置的固定主题。             |
| `SessionThemeResolver` | 主题在用户的 HTTP 会话中维护。它只需要为每个会话设置一次，但不会在会话之间持久化。 |
| `CookieThemeResolver`  | 所选主题存储在客户端的 cookie 中。                           |

Spring 还提供了一个 `ThemeChangeInterceptor`，它允许使用一个简单的请求参数对每个请求进行主题更改。

### 1.1.12 Multipart 解析器

来自 `org.springframework.web.multipart` 包的 `MultipartResolver` 是一种用于解析包括文件上载在内的多部分请求的策略。有一个基于容器的 `StandardServletMultipartResolver` 实现用于 Servlet 多部分请求解析。请注意，基于 Apache Commons FileUpload 的过时 `CommonsMultipartResolver` 在 Spring Framework 6.0 及其新的 Servlet 5.0+ 基线中不再可用。

要启用 multipart 处理，您需要在 `DispatcherServlet` Spring 配置中声明一个名为 `multipartResolver` 的 `MultipartResolver` bean。`DispatcherServlet` 检测到它并将其应用于传入请求。当接收到内容类型为 `multipart/form-data` 的 POST 时，解析器解析内容，将当前 `HttpServletRequest` 包装为 `MultipartHttpServletRequest`，以提供对解析文件的访问，并将部分作为请求参数公开。

#### Servlet Multipart 解析

需要通过 Servlet 容器配置启用 Servlet multipart 解析。为此：

- 在 Java 中，在 Servlet 注册上设置 `MultipartConfigElement`。
- 在 `web.xml` 中，在 servlet 声明中添加 `<multipart-config>` 部分。

以下示例显示如何在 Servlet 注册上设置 `MultipartConfigElement`：

```java
public class AppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    // ...

    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {

        // Optionally also set maxFileSize, maxRequestSize, fileSizeThreshold
        registration.setMultipartConfig(new MultipartConfigElement("/tmp"));
    }

}
```

一旦 Servlet multipart 配置到位，就可以添加名称为 `multipartResolver` 的 `StandardServletMultipartResolver` 类型的 bean。

> 此解析器变体按原样使用 Servlet 容器的 multipart 解析器，可能会使应用程序暴露于容器实现的差异。默认情况下，它将尝试使用任何 HTTP 方法解析任何 `multipart/` 内容类型，但这可能不是所有 Servlet 容器都支持的。有关详细信息和配置选项，请参阅 `StandardServletMultipartResolver` javadoc。

### 1.1.13 日志

Spring MVC 中的 DEBUG 级日志被设计为紧凑、最小和人性化。它关注的是一次又一次有用的高价值信息，而不是只有在调试特定问题时才有用的其他信息。

TRACE 级日志通常遵循与 DEBUG 相同的原则（例如，也不应该是消防水带），但可以用于调试任何问题。此外，一些日志消息可能在 TRACE 和 DEBUG 中显示不同级别的详细信息。

良好的日志记录来自使用日志的经验。如果您发现任何不符合规定目标的情况，请告知我们。

#### 敏感数据

DEBUG 和 TRACE 日志记录可能记录敏感信息。这就是为什么默认情况下会屏蔽请求参数和标头，并且必须通过 `DispatcherServlet` 上的 `enableLoggingRequestDetails` 属性显式启用它们的完整日志记录。

下面的示例显示了如何使用 Java 配置来执行此操作：

```java
public class MyInitializer
        extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return ... ;
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return ... ;
    }

    @Override
    protected String[] getServletMappings() {
        return ... ;
    }

    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
        registration.setInitParameter("enableLoggingRequestDetails", "true");
    }

}
```

## 1.2 过滤器

`spring-web` 模块提供了一些有用的过滤器：

- [表格数据](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#filters-http-put)
- [转发头](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#filters-forwarded-headers)
- [浅 ETag](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#filters-shallow-etag)
- [CORS](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#filters-cors)

### 1.2.1 表格数据

浏览器只能通过HTTP GET或HTTP POST提交表单数据，但非浏览器客户端也可以使用HTTP PUT、PATCH和DELETE。Servlet API 要求 `ServletRequest.getParameter*()` 方法仅支持 HTTP POST 的表单字段访问。

`spring-web` 模块提供 `FormContentFilter`，以拦截内容类型为 `application/x-www-form-urlencoded` 的 HTTP PUT、PATCH 和 DELETE 请求，从请求主体读取表单数据，并包装 `ServletRequest`，使表单数据通过 `ServletRequest.getParameter*()` 系列方法可用。

### 1.2.2 转发头

当请求通过代理（如负载平衡器）时，主机、端口和方案可能会发生变化，这使得从客户端角度创建指向正确主机、端口或方案的链接成为一项挑战。

RFC 7239 定义了 `Forwarded` HTTP 头，代理可以使用它来提供有关原始请求的信息。还有其他非标准标头，包括 `X-Forwarded-Host`、`X-Forwardd-Port`、`X-Forward-Proto`、`X-Forced-Ssl` 和 `X-Forwarded-Prefix`。

`ForwardedHeaderFilter` 是一个 Servlet 筛选器，用于修改请求，以便 a）根据`Forwarded` 标头更改主机、端口和方案，b）删除这些标头以消除进一步的影响。过滤器依赖于包装请求，因此必须在其他过滤器（如 `RequestContextFilter`）之前对其进行排序，这些过滤器应处理修改后的请求，而不是原始请求。

由于应用程序无法知道标头是由代理按预期添加的，还是由恶意客户端添加的，因此转发的标头存在安全问题。这就是为什么应该将信任边界处的代理配置为删除来自外部的不受信任的 `Forwarded` 标头。您还可以将 `ForwardedHeaderFilter` 配置为 `removeOnly=true`，在这种情况下，它会删除但不使用标头。

为了支持异步请求和错误分派，此筛选器应与 `DispatcherType.ASYNC` 以及 `DispatcherType.ERROR` 进行映射。如果使用 Spring Framework 的 `AbstractAnnotationConfigDispatcherServletInitializer`（请参阅Servlet Config），则会自动为所有分派类型注册所有筛选器。但是，如果通过 `web.xml` 或通过 `FilterRegistrationBean` 在 Spring Boot 中注册过滤器，请确保除了 `DispatcherType.REQUEST` 之外，还包括 `DispatcherType.ASYNC` 和 `Dispatcherype.ERROR`。

### 1.2.3 浅 ETag

`ShallowEtagHeaderFilter` 过滤器通过缓存写入响应的内容并从中计算 MD5 哈希值来创建一个“浅” ETag。下次客户端发送时，它会执行同样的操作，但它还会将计算值与 `If-None-Match` 请求头进行比较，如果两者相等，则返回 304（NOT_MODIFIED）。

此策略节省网络带宽，但不节省 CPU，因为必须为每个请求计算完整响应。前面描述的控制器级别的其他策略可以避免计算。请参阅 HTTP 缓存。

此筛选器具有 `writeWeakETag` 参数，该参数将筛选器配置为写入弱 ETag，如下所示：`W/"02a2d595e6ed9a0b24f027f2b63b134d6"`（如 RFC 7232 第 2.3 节所定义）。

为了支持异步请求，此筛选器必须与 `DispatcherType.ASYNC` 映射，以便筛选器可以延迟并成功生成 ETag，直到最后一次异步分派结束。如果使用 Spring Framework 的 `AbstractAnnotationConfigDispatcherServletInitializer`（请参阅 Servlet 配置），则会自动为所有分派类型注册所有筛选器。但是，如果通过 `web.xml` 或通过 `FilterRegistrationBean` 在 Spring Boot 中注册过滤器，请确保包含 `DispatcherType.ASYNC`。

### 1.2.4 CORS

Spring MVC 通过控制器上的注释为 CORS 配置提供细粒度支持。然而，当与 Spring Security 一起使用时，我们建议依赖内置的 `CorsFilter`，该过滤器必须在 Spring Security 的过滤器链之前订购。

有关更多详细信息，请参阅 CORS 和 CORS 过滤器部分。

## 1.3 被注解的控制器

Spring MVC 提供了一个基于注解的编程模型，其中 `@Controller` 和 `@RestController` 组件使用注解来表示请求映射、请求输入、异常处理等。带注解的控制器具有灵活的方法签名，不必扩展基类或实现特定接口。以下示例显示了由注释定义的控制器：

```java
@Controller
public class HelloController {

    @GetMapping("/hello")
    public String handle(Model model) {
        model.addAttribute("message", "Hello World!");
        return "index";
    }
}
```

在前面的示例中，该方法接受一个 `Model` 并返回一个作为 `String` 的视图名称，但还有许多其他选项，将在本章稍后解释。

> [spring.io](https://spring.io/guides) 上的指南和教程使用本节中描述的基于注解的编程模型。

### 1.3.1 声明

您可以通过在 Servlet 的 `WebApplicationContext` 中使用标准的 Spring bean 定义来定义控制器 bean。`@Controller` 原型允许自动检测，与 Spring 在类路径中检测 `@Component` 类并自动注册 bean 定义的一般支持保持一致。它还充当注解类的原型，指示其作为 web 组件的角色。

要启用此类 `@Controller` bean 的自动检测，可以将组件扫描添加到 Java 配置中，如下例所示：

```java
@Configuration
@ComponentScan("org.example.web")
public class WebConfig {

    // ...
}
```

以下示例显示了与前面示例等效的 XML 配置：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:component-scan base-package="org.example.web"/>

    <!-- ... -->

</beans>
```

`@RestController` 是一个复合注解，它本身用 `@Controller` 和 `@ResponseBody` 进行元注解，以指示其每个方法都继承类型级别 `@ResponsBody` 注解的控制器，因此，与视图解析和 HTML 模板渲染相比，它直接写入响应体。

#### AOP 代理

在某些情况下，您可能需要在运行时用 AOP 代理来修饰控制器。例如，如果您选择在控制器上直接使用 `@Transactional` 注解。在这种情况下，特别是对于控制器，我们建议使用基于类的代理。这是直接在控制器上进行此类注解的自动情况。

如果控制器实现了一个接口，并且需要 AOP 代理，那么您可能需要显式地配置基于类的代理。例如，使用 `@EnableTransactionManagement` 可以更改为 `@EnableTransactionManagement(proxyTargetClass=true)`，使用 `<tx:annotation-driven/>` 可以更改为 `<tx:annotation-driven-proxy-target-class="true"/>`。

> 请记住，从 6.0 开始，通过接口代理，Spring MVC 不再仅基于接口上的类型级别 `@RequestMapping` 注解来检测控制器。请启用基于类的代理，否则接口还必须具有 `@Controller` 注解。

### 1.3.2 请求映射

您可以使用 `@RequestMapping` 注解将请求映射到控制器方法。它具有各种属性，可通过 URL、HTTP 方法、请求参数、标头和媒体类型进行匹配。您可以在类级别使用它来表示共享映射，或者在方法级别使用它缩小到特定的端点映射。

`@RequestMapping` 还有特定于 HTTP 方法的快捷方式变体：

- `@GetMapping`
- `@PostMapping`
- `@PutMapping`
- `@DeleteMapping`
- `@PatchMapping`

提供快捷方式是自定义注解，因为可以说，大多数控制器方法应该映射到特定的 HTTP 方法，而不是使用 `@RequestMapping`，默认情况下，`@RequestMapping` 与所有 HTTP 方法匹配。在类级别仍然需要 `@RequestMapping` 来表示共享映射。

以下示例具有类型和方法级别映射：

```java
@RestController
@RequestMapping("/persons")
class PersonController {

    @GetMapping("/{id}")
    public Person getPerson(@PathVariable Long id) {
        // ...
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public void add(@RequestBody Person person) {
        // ...
    }
}
```

#### URI 模式

`@RequestMapping` 方法可以使用 URL 模式映射。有两种选择：

- `PathPattern` —— 与 URL 路径匹配的预解析模式也预解析为 `PathContainer`。此解决方案专为 web 使用而设计，可有效处理编码和路径参数，并有效匹配。
- `AntPathMatcher` —— 根据字符串路径匹配字符串模式。这是 Spring 配置中用于选择类路径、文件系统和其他位置上的资源的原始解决方案。它的效率较低，字符串路径输入对于有效处理 URL 的编码和其他问题是一个挑战。

`PathPattern` 是 web 应用程序的推荐解决方案，也是 Spring WebFlux 中的唯一选择。它从 5.3 版开始在 Spring MVC 中启用，从 6.0 版开始默认情况下启用。有关路径匹配选项的自定义，请参阅 MVC 配置。

`PathPattern` 支持与 `AntPathMatcher` 相同的模式语法。此外，它还支持捕获模式，例如 `{*spring}`，用于匹配路径末端的 0 个或多个路径段。`PathPattern` 还限制使用 `**` 来匹配多个路径段，以便只允许在模式末尾使用。这消除了为给定请求选择最佳匹配模式时的许多不确定性。有关完整模式语法，请参阅 PathPattern 和 AntPathMatcher。

一些示例模式：

- `"/resources/ima?e.png"` - 匹配路径段中的一个字符
- `"/resources/*.png"` - 匹配路径段中的零个或多个字符
- `"/resources/**"` - 匹配多个路径段
- `"/projects/{project}/versions"` - 匹配路径段并将其捕获为变量
- `"/projects/{project:[a-z]+}/versions"` - 使用正则表达式匹配并捕获变量

可以使用 `@PathVariable` 访问捕获的 URI 变量。例如：

```java
@GetMapping("/owners/{ownerId}/pets/{petId}")
public Pet findPet(@PathVariable Long ownerId, @PathVariable Long petId) {
    // ...
}
```

您可以在类和方法级别声明 URI 变量，如下例所示：

```java
@Controller
@RequestMapping("/owners/{ownerId}")
public class OwnerController {

    @GetMapping("/pets/{petId}")
    public Pet findPet(@PathVariable Long ownerId, @PathVariable Long petId) {
        // ...
    }
}
```

URI 变量会自动转换为适当的类型，或引发 `TypeMismatchException`。默认情况下支持简单类型（`int`、`long`、`Date` 等），您可以注册对任何其他数据类型的支持。请参阅类型转换和 `DataBinder`。

您可以显式地命名 URI 变量（例如，`@PathVariable("customId")`），但如果名称相同且代码使用 `-parameters` 编译器标志编译，则可以省略该细节。

语法 `{varName:regex}` 使用语法为 `{varName:regex}` 的正则表达式声明 URI 变量。例如，给定 URL `"/spring-web-3.0.5.jar"`，以下方法提取名称、版本和文件扩展名：

```java
@GetMapping("/{name:[a-z-]+}-{version:\\d\\.\\d\\.\\d}{ext:\\.[a-z]+}")
public void handle(@PathVariable String name, @PathVariable String version, @PathVariable String ext) {
    // ...
}
```

URI 路径模式还可以嵌入 `${…}` 通过对本地、系统、环境和其他属性源使用 `PropertySourcesPlaceholderConfigurator` 在启动时解析的占位符。例如，您可以使用它根据某些外部配置参数化基本 URL。

#### 模式对比

当多个模式与 URL 匹配时，必须选择最佳匹配。这取决于是否启用了解析的 `PathPattern` 的使用，可以使用以下方法之一完成：

- `PathPattern.SPECIFICITY_COMPARATOR`
- `AntPathMatcher.getPatternComparator(String path)`

这两种方法都有助于对模式进行排序，并将更具体的模式放在顶部。如果模式的 URI 变量数较少（计为 1）、单通配符（计为 1）和双通配符（计为 2），则模式就不那么具体。如果得分相等，则选择较长的模式。给定相同的分数和长度，将选择 URI 变量多于通配符的模式。

默认映射模式（`/**`）从评分中排除，并始终排序在最后。此外，前缀模式（如 `/public/**`）被认为比其他没有双通配符的模式更不特定。

有关详细信息，请按照上面的链接访问模式比较器。

#### 后缀匹配

从 5.3 开始，默认情况下 Spring MVC 不再执行 `.*` 后缀模式匹配，其中映射到 `/person` 的控制器也隐式映射到 `/person.*`。因此，不再使用路径扩展来解释请求的响应内容类型 —— 例如，`/person.pdf`、`/person.xml` 等。

当浏览器用来发送难以一致解释的 `Accept` 标头时，以这种方式使用文件扩展名是必要的。目前，这不再是必要的，使用 `Accept` 标头应该是首选。

随着时间的推移，文件扩展名的使用在许多方面都被证明是有问题的。当与 URI 变量、路径参数和 URI 编码的使用重叠时，可能会导致歧义。关于基于 URL 的授权和安全性的推理（有关更多详细信息，请参阅下一节）也变得更加困难。

要在 5.3 之前的版本中完全禁用路径扩展，请设置以下内容：

- `useSuffixPatternMatch(false)`，请参见 PathMatchConfigurer
- `favorPathExtension(false)`，请参阅 ContentNegotiationConfigurer

通过 `"Accept"` 标头以外的方式请求内容类型仍然很有用，例如在浏览器中键入 URL 时。路径扩展的安全替代方案是使用查询参数策略。如果必须使用文件扩展名，请考虑通过 ContentNegotiationConfigurer 的 `mediaTypes` 属性将其限制为显式注册的扩展名列表。

#### 后缀匹配和 RFD

反射文件下载（RFD）攻击与 XSS 相似，因为它依赖于响应中反映的请求输入（例如，查询参数和 URI 变量）。然而，RFD 攻击不是将 JavaScript 插入 HTML，而是依靠浏览器切换来执行下载，并在稍后双击时将响应视为可执行脚本。

在 Spring MVC 中，`@ResponseBody` 和 `ResponseEntity` 方法存在风险，因为它们可以呈现不同的内容类型，客户端可以通过 URL 路径扩展请求这些内容类型。禁用后缀模式匹配和使用路径扩展进行内容协商可以降低风险，但不足以防止 RFD 攻击。

为了防止 RFD 攻击，在呈现响应体之前，Spring MVC 添加了 `Content-Disposition:inline;filename=f.txt` 标头，以建议一个固定且安全的下载文件。只有当 URL 路径包含既不允许安全也不明确注册内容协商的文件扩展名时，才能执行此操作。然而，当 URL 直接输入到浏览器中时，它可能会产生副作用。

默认情况下，许多公共路径扩展都是安全的。具有自定义 `HttpMessageConverter` 实现的应用程序可以显式注册用于内容协商的文件扩展名，以避免为这些扩展名添加 `Content-Disposition` 头。请参见内容类型。

有关 RFD 的其他建议，请参见 CVE-2015-5211。

#### 可消费的媒介类型

您可以根据请求的内容类型缩小请求映射，如下例所示：

```java
@PostMapping(path = "/pets", consumes = "application/json") (1)
public void addPet(@RequestBody Pet pet) {
    // ...
}

// (1) 使用 `consumes` 属性按内容类型缩小映射。
```

`consumers` 属性还支持否定表达式 —— 例如 `!text/plain` 是指除 `text/plain` 之外的任何内容类型。

您可以在类级别声明共享 `consumes` 属性。然而，与大多数其他请求映射属性不同，当在类级别使用时，方法级别使用 `consumes` 属性重写而不是扩展类级别声明。

> `MediaType` 为常用的媒体类型提供常量，如 `APPLICATION_JSON_VALUE` 和 `APPLICATIION_XML_VALUE`。

#### 可生成的媒介类型

您可以根据 `Accept` 请求标头和控制器方法生成的内容类型列表缩小请求映射，如下例所示：

```java
@GetMapping(path = "/pets/{petId}", produces = "application/json") (1)
@ResponseBody
public Pet getPet(@PathVariable String petId) {
    // ...
}

// (1) 使用 products 属性按内容类型缩小映射。
```

媒体类型可以指定字符集。支持否定表达式 —— 例如 `!text/plain` 是指除 “text/plain” 以外的任何内容类型。

您可以在类级别声明共享的 `produces` 属性。然而，与大多数其他请求映射属性不同，当在类级别使用时，方法级别 `produces` 属性重写而不是扩展类级别声明。

> `MediaType` 为常用的媒体类型提供常量，如 `APPLICATION_JSON_VALUE` 和 `APPLICATIION_XML_VALUE`。

#### 参数，标头

您可以根据请求参数条件缩小请求映射。您可以测试是否存在请求参数（`myParam`）、是否缺少请求参数（`!myParam`）或是否存在特定值（`myParam=myValue`）。以下示例显示了如何测试特定值：

```java
@GetMapping(path = "/pets/{petId}", params = "myParam=myValue") (1)
public void findPet(@PathVariable String petId) {
    // ...
}

// (1) 测试 `myParam` 是否等于 `myValue`。
```

也可以对请求头条件使用相同的方法，如下例所示：

```java
@GetMapping(path = "/pets", headers = "myHeader=myValue") (1)
public void findPet(@PathVariable String petId) {
    // ...
}

// (1) 测试 `myHeader` 是否等于 `myValue`。
```

> 您可以将 `Content-Type` 和 `Accept` 与 headers 条件匹配，但最好使用 consumes 和 products。

#### HTTP HEAD, OPTIONS

`@GetMapping`（和 `@RequestMapping(method=HttpMethod.GET)`）对请求映射透明地支持 HTTP HEAD。控制器方法无需更改。`jakarta.servlet.http.HttpServlet` 中应用的响应包装器确保 `Content-Length` 标头设置为写入的字节数（而不实际写入响应）。

`@GetMapping`（和 `@RequestMapping(method=HttpMethod.GET)`）隐式映射到并支持 HTTP HEAD。处理 HTTP HEAD 请求时，就像处理 HTTP GET 一样，只是不写入正文，而是计算字节数并设置 `Content-Length` 标头。

默认情况下，HTTP OPTIONS 是通过将 `Allow` 响应头设置为所有 `@RequestMapping` 方法中列出的具有匹配 URL 模式的 HTTP 方法列表来处理的。

对于没有 HTTP 方法声明的 `@RequestMapping`，`Allow` 标头设置为 `GET,HEAD,POST,PUT,PATCH,DELETE,OPTIONS`。控制器方法应始终声明支持的 HTTP 方法（例如，通过使用 HTTP 方法特定的变量：`@GetMapping`、`@PostMapping` 和其他）。

您可以显式地将 `@RequestMapping` 方法映射到 HTTP HEAD 和 HTTP OPTIONS，但在常见情况下这不是必需的。

#### 自定义注解

Spring MVC 支持使用组合注解进行请求映射。这些注释本身是用 `@RequestMapping` 进行元注解的，组成这些注解的目的是重新声明 `@RequestMapping` 属性的子集（或全部），以实现更窄、更具体的用途。

`@GetMapping`、`@PostMapping`、`@PutMapping`、`@DeleteMapping` 和 `@PatchMapping` 是组合注解的示例。提供它们是因为，可以说，大多数控制器方法应该映射到特定的 HTTP 方法，而不是使用 `@RequestMapping`，默认情况下，`@RequestMapping` 与所有 HTTP 方法匹配。如果需要组合注解的示例，请查看这些注解是如何声明的。

Spring MVC 还支持带有自定义请求匹配逻辑的自定义请求映射属性。这是一个更高级的选项，需要子类化 `RequestMappingHandlerMapping` 并重写 `getCustomMethodCondition` 方法，在这里您可以检查自定义属性并返回自己的 `RequestCondition`。

#### 显式注册

您可以以编程方式注册处理程序方法，这些方法可以用于动态注册或高级情况，例如不同 URL 下的同一处理程序的不同实例。以下示例注册处理程序方法：

```java
@Configuration
public class MyConfig {

    @Autowired
    public void setHandlerMapping(RequestMappingHandlerMapping mapping, UserHandler handler) (1)
            throws NoSuchMethodException {

        RequestMappingInfo info = RequestMappingInfo
                .paths("/user/{id}").methods(RequestMethod.GET).build(); (2)

        Method method = UserHandler.class.getMethod("getUser", Long.class); (3)

        mapping.registerMapping(info, handler, method); (4)
    }
}

// (1) 为控制器注入目标处理程序和处理程序映射。
// (2) 准备请求映射元数据。
// (3) 获取处理程序方法。
// (4) 添加注册。
```

### 1.3.3 处理器方法

`@RequestMapping` 处理程序方法具有灵活的签名，可以从一系列受支持的控制器方法参数和返回值中进行选择。

#### 方法参数

下表描述了支持的控制器方法参数。任何参数都不支持反应类型。

JDK 8 的 `java.util.Optional` 作为方法参数与具有 `required` 属性（例如 `@RequestParam`、`@RequestHeader` 等）的注解结合使用，并且等效于 `required=false`。

| 控制器方法参数                                               | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `WebRequest`, `NativeWebRequest`                             | 对请求参数、请求和会话属性的通用访问，无需直接使用 Servlet API。 |
| `jakarta.servlet.ServletRequest`, `jakarta.servlet.ServletResponse` | 选择任何特定的请求或响应类型 —— 例如，`ServletRequest`、`HttpServletRequest` 或 Spring 的 `MultipartRequest `、`MultipartHttpServletRequest `。 |
| `jakarta.servlet.http.HttpSession`                           | 强制会话的存在。因此，这样的参数永远不是 `null`。请注意，会话访问不是线程安全的。如果允许多个请求同时访问会话，请考虑将 `RequestMappingHandlerAdapter` 实例的 `synchronizedOnSession` 标志设置为 `true`。 |
| `jakarta.servlet.http.PushBuilder`                           | 用于编程 HTTP/2 资源推送的 Servlet 4.0 推送生成器 API。注意，根据 Servlet 规范，如果客户端不支持 HTTP/2 功能，则注入的 `PushBuilder` 实例可以为空。 |
| `java.security.Principal`                                    | 当前已验证的用户 — 如果已知，则可能是特定的 `Principal` 实现类。请注意，如果对该参数进行了注解，以便允许自定义解析器在通过 `HttpServletRequest#getUserPrincipal` 返回默认解析之前解析该参数，则不会立即解析该参数。例如，Spring Security `Authentication` 实现了 `Principal`，并将通过 `HttpServletRequest#getUserPrincipal` 进行注入，除非它也用 `@AuthenticationPrincipal` 进行注解，在这种情况下，它由自定义 Spring Security 解析器通过 `Authentication#getPrincipal` 进行解析。 |
| `HttpMethod`                                                 | 请求的 HTTP 方法。                                           |
| `java.util.Locale`                                           | 当前请求区域设置，由可用的最具体的 `LocaleResolver`（实际上是配置的 `LocaleVesolver` 或 `LocaleContextResolver`）确定。 |
| `java.util.TimeZone` + `java.time.ZoneId`                    | 与当前请求关联的时区，由 `LocaleContextResolver` 确定。      |
| `java.io.InputStream`, `java.io.Reader`                      | 用于访问 Servlet API 公开的原始请求体。                      |
| `java.io.OutputStream`, `java.io.Writer`                     | 用于访问 Servlet API 公开的原始响应体。                      |
| `@PathVariable`                                              | 用于访问 URI 模板变量。参见 [URI 模式](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestmapping-uri-templates)。 |
| `@MatrixVariable`                                            | 用于访问 URI 路径段中的名称值对。参见[矩阵变量](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-matrix-variables)。 |
| `@RequestParam`                                              | 用于访问 Servlet 请求参数，包括多部分文件。参数值被转换为声明的方法参数类型。请参见 [`@RequestParam`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestparam) 以及 [Multipart](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-multipart-forms)。请注意，对于简单参数值，`@RequestParam` 的使用是可选的。请参阅本表末尾的“任何其他参数”。 |
| `@RequestHeader`                                             | 用于访问请求标头。标头值被转换为声明的方法参数类型。请参见 [`@RequestHeader`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestheader)。 |
| `@CookieValue`                                               | 访问 cookie。Cookie 值被转换为声明的方法参数类型。请参见 [`@CookieValue`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-cookievalue)。 |
| `@RequestBody`                                               | 用于访问 HTTP 请求主体。使用 `HttpMessageConverter` 实现将正文内容转换为声明的方法参数类型。请参见 [`@RequestBody `](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestbody)。 |
| `HttpEntity<B>`                                              | 用于访问请求标头和正文。使用 `HttpMessageConverter` 转换正文。参见[HttpEntity](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-httpentity)。 |
| `@RequestPart`                                               | 要访问 `multipart/form-data` 请求中的部分，请使用 `HttpMessageConverter` 转换该部分的主体。参见 [Multipart](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-multipart-forms)。 |
| `java.util.Map`, `org.springframework.ui.Model`, `org.springframework.ui.ModelMap` | 用于访问 HTML 控制器中使用的模型，并作为视图渲染的一部分公开给模板。 |
| `RedirectAttributes`                                         | 指定重定向时要使用的属性（即，要附加到查询字符串），以及在重定向后请求之前临时存储的 flash 属性。请参阅[重定向属性](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-redirecting-passing-data)和 [Flash 属性](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-flash-attributes)。 |
| `@ModelAttribute`                                            | 用于访问应用了数据绑定和验证的模型中的现有属性（如果不存在则实例化）。请参见 [`@ModelAttribute`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-modelattrib-method-args) 以及 [Model](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-modelattrib-methods) 和 [`DataBinder`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-initbinder)。请注意，`@ModelAttribute` 的使用是可选的（例如，设置其属性）。请参阅本表末尾的“任何其他参数”。 |
| `Errors`, `BindingResult`                                    | 用于访问来自命令对象（即 `@ModelAttribute` 参数）验证和数据绑定的错误，或来自 `@RequestBody` 或 `@RequestPart` 参数验证的错误。必须在经过验证的方法参数之后立即声明 `Errors` 或 `BindingResult` 参数。 |
| `SessionStatus` + 类级别的 `@SessionAttributes`              | 用于标记表单处理完成，这将触发清理通过类级别 `@SessionAttributes` 注解声明的会话属性。请参见 [`@SessionAttributes`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-sessionattributes) 获取更多详细信息。 |
| `UriComponentsBuilder`                                       | 用于准备与当前请求的主机、端口、方案、上下文路径和 servlet 映射的文本部分相关的 URL。参见 [URI 链接](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-uri-building)。 |
| `@SessionAttribute`                                          | 对于任何会话属性的访问，与作为类级别 `@SessionAttributes` 声明的结果存储在会话中的模型属性不同。请参见 [`@SessionAttribute`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-sessionattribute) 了解更多详情。 |
| `@RequestAttribute`                                          | 用于访问请求属性。请参见 [`@RequestAttribute`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestattrib) 获取更多详细信息。 |
| 任何其他参数                                                 | 如果方法参数与此表中的任何早期值不匹配，并且它是简单类型（由 [BeanTils#isSimpleProperty](https://docs.spring.io/spring-framework/docs/6.0.6/javadoc-api/org/springframework/beans/BeanUtils.html#isSimpleProperty-java.lang.Class-) 确定），它被解析为 `@RequestParam`。否则，它将被解析为 `@ModelAttribute`。 |

#### 返回值

下表描述了支持的控制器方法返回值。所有返回值都支持反应类型。

| 控制器方法返回值                                             | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `@ResponseBody`                                              | 返回值通过 `HttpMessageConverter` 实现转换并写入响应。参见 [`@ResponseBody `](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-responsebody)。 |
| `HttpEntity<B>`, `ResponseEntity<B>`                         | 指定完整响应（包括 HTTP 头和正文）的返回值将通过 `HttpMessageConverter` 实现转换并写入响应。参见 [ResponseEntity](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-responseentity)。 |
| `HttpHeaders`                                                | 用于返回带有标头而没有正文的响应。                           |
| `ErrorResponse`                                              | 要呈现 RFC 7807 错误响应并在正文中提供详细信息，请参阅[错误响应](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-rest-exceptions) |
| `ProblemDetail`                                              | 要呈现 RFC 7807 错误响应并在正文中提供详细信息，请参阅[错误响应](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-rest-exceptions) |
| `String`                                                     | 要使用 `ViewResolver` 实现解析并与隐式模型一起使用的视图名称 —— 通过命令对象和 `@ModelAttribute` 方法确定。处理程序方法还可以通过声明 `Model` 参数以编程方式丰富模型（请参见[显式注册](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestmapping-registration)）。 |
| `View`                                                       | 用于与隐式模型一起呈现的 `View` 实例 —— 通过命令对象和 `@ModelAttribute` 方法确定。处理程序方法还可以通过声明 `Model` 参数以编程方式丰富模型（请参见[显式注册](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestmapping-registration)）。 |
| `java.util.Map`, `org.springframework.ui.Model`              | 要添加到隐式模型的属性，视图名称通过 `RequestToViewNameTranslator` 隐式确定。 |
| `@ModelAttribute`                                            | 要添加到模型中的属性，视图名称通过 `RequestToViewNameTranslator` 隐式确定。请注意，`@ModelAttribute` 是可选的。请参阅本表末尾的“任何其他返回值”。 |
| `ModelAndView` 对象                                          | 要使用的视图和模型属性，以及响应状态（可选）。               |
| `void`                                                       | 如果具有 `void` 返回类型（或 `null` 返回值）的方法还具有 `ServletResponse`、`OutputStream` 参数或 `@ResponseStatus` 注解，则认为该方法已完全处理了响应。如果控制器进行了肯定的 `ETag` 或 `lastModified` 时间戳检查（参见[控制器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-caching-etag-lastmodified)以获取详细信息）。如果以上任何一项都不为真，则 `void` 返回类型也可以指示 REST 控制器的“无响应主体”或 HTML 控制器的默认视图名称选择。 |
| `DeferredResult<V>`                                          | 从任何线程异步生成前面的任何返回值 —— 例如作为某个事件或回调的结果。参见[异步请求](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async)和 [`DeferredResult`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async-deferredresult)。 |
| `Callable<V>`                                                | 在 Spring MVC 托管线程中异步生成上述任何返回值。参见[异步请求](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async)和 [`Callable`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async-callable)。 |
| `ListenableFuture<V>`, `java.util.concurrent.CompletionStage<V>`, `java.util.concurrent.CompletableFuture<V>` | 作为 `DeferredResult` 的替代选项，为方便起见（例如，当基础服务返回其中一个时）。 |
| `ResponseBodyEmitter`, `SseEmitter`                          | 使用 `HttpMessageConverter` 实现异步发出对象流以写入响应。也支持作为 `ResponseEntity` 的主体。参见[异步请求](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async)和 [HTTP 流](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async-http-streaming)。 |
| `StreamingResponseBody`                                      | 异步写入响应 `OutputStream`。也支持作为 `ResponseEntity` 的主体。参见[异步请求](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async)和 [HTTP 流](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async-http-streaming)。 |
| 通过 `ReactiveAdapterRegistry` 注册的 Reactor 和其他反应式类型 | 单个值类型（例如 `Mono`）相当于返回 `DeferredResult`。根据请求的媒体类型，多值类型（例如 `Flux`）可被视为流，例如 "text/event-stream", "application/json+stream"，或以其他方式收集到列表中并呈现为单个值。参见[异步请求](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async)和[反应式类型](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-async-reactive-types)。 |
| 其他返回值                                                   | 如果返回值以任何其他方式未解析，则将其视为模型属性，除非它是由 [BeanTils#isSimpleProperty](https://docs.spring.io/spring-framework/docs/6.0.6/javadoc-api/org/springframework/beans/BeanUtils.html#isSimpleProperty-java.lang.Class-) 确定的简单类型，在这种情况下，它仍然无法解析。 |

#### 类型转换

如果参数声明为非字符串，则表示基于字符串的请求输入的某些带注解的控制器方法参数（例如 `@RequestParam`、`@RequestHeader`、`@PathVariable`、`@MatrixVariable` 和 `@CookieValue`）可能需要类型转换。

对于这种情况，根据配置的转换器自动应用类型转换。默认情况下，支持简单类型（`int`、`long`、`Date` 等）。您可以通过 `WebDataBinder`（请参阅 `DataBinder`）或通过向 `FormattingConversionService` 注册 `Formatters` 来自定义类型转换。请参见 Spring 字段格式化。

类型转换中的一个实际问题是处理空字符串源值。如果由于类型转换而变为空，则此类值将被视为缺失。`Long`、`UUID` 和其他目标类型可能是这种情况。如果要允许注入 `null`，请在参数注释上使用 `required` 的标志，或将参数声明为 `@Nullable`。

> 从 5.3 开始，即使在类型转换之后，也将强制使用非空参数。如果处理程序方法也打算接受空值，请将参数声明为 `@Nullable`，或在相应的`@RequestParam` 等注释中将其标记为 `required=false`。这是最佳实践，也是 5.3 升级中遇到的回归问题的建议解决方案。
>
> 或者，在需要 `@PathVariable` 的情况下，您可以专门处理例如生成的 `MissingPathVariableException`。转换后的空值将被视为空的原始值，因此相应的 `Missing…Exception` 变体将被抛出。

#### 矩阵变量

RFC 3986 讨论了路径段中的名称值对。在 Spring MVC 中，我们根据 Tim Berners Lee 的“旧帖子”将这些变量称为“矩阵变量”，但它们也可以称为 URI 路径参数。
矩阵变量可以出现在任何路径段中，每个变量用分号分隔，多个值用逗号分隔（例如，`/cars;color=red,green;year=2012`）。也可以通过重复的变量名称指定多个值（例如，`color=red;color=green;color=blue`）。

如果 URL 预期包含矩阵变量，则控制器方法的请求映射必须使用 URI 变量来掩盖（mask）该变量内容，并确保可以独立于矩阵变量顺序和存在性成功匹配请求。以下示例使用矩阵变量：

```java
// GET /pets/42;q=11;r=22

@GetMapping("/pets/{petId}")
public void findPet(@PathVariable String petId, @MatrixVariable int q) {

    // petId == 42
    // q == 11
}
```

考虑到所有路径段都可能包含矩阵变量，有时可能需要消除矩阵变量应位于哪个路径变量中的歧义。以下示例显示了如何做到这一点：

```java
// GET /owners/42;q=11/pets/21;q=22

@GetMapping("/owners/{ownerId}/pets/{petId}")
public void findPet(
        @MatrixVariable(name="q", pathVar="ownerId") int q1,
        @MatrixVariable(name="q", pathVar="petId") int q2) {

    // q1 == 11
    // q2 == 22
}
```

可以将矩阵变量定义为可选变量，并指定默认值，如下例所示：

```java
// GET /pets/42

@GetMapping("/pets/{petId}")
public void findPet(@MatrixVariable(required=false, defaultValue="1") int q) {

    // q == 1
}
```

要获取所有矩阵变量，可以使用 `MultiValueMap`，如下例所示：

```java
// GET /owners/42;q=11;r=12/pets/21;q=22;s=23

@GetMapping("/owners/{ownerId}/pets/{petId}")
public void findPet(
        @MatrixVariable MultiValueMap<String, String> matrixVars,
        @MatrixVariable(pathVar="petId") MultiValueMap<String, String> petMatrixVars) {

    // matrixVars: ["q" : [11,22], "r" : 12, "s" : 23]
    // petMatrixVars: ["q" : 22, "s" : 23]
}
```

请注意，您需要启用矩阵变量的使用。在 MVC Java 配置中，需要通过路径匹配将 `UrlPathHelper` 设置为 `removeSemicolonContent=false`。在 MVC XML 命名空间中，可以设置 `<mvc:annotation driven enable matrix variables="true"/>`。

#### @RequestParam

您可以使用 `@RequestParam` 注解将 Servlet 请求参数（即查询参数或表单数据）绑定到控制器中的方法参数。

以下示例显示了如何执行此操作：

```java
@Controller
@RequestMapping("/pets")
public class EditPetForm {

    // ...

    @GetMapping
    public String setupForm(@RequestParam("petId") int petId, Model model) { (1)
        Pet pet = this.clinic.loadPet(petId);
        model.addAttribute("pet", pet);
        return "petForm";
    }

    // ...

}

// (1) 使用 `@RequestParam` 来绑定 `petId`
```

默认情况下，使用此注解的方法参数是必需的，但可以通过将 `@RequestParam` 注解的 `required` 标志设置为 `false` 或使用 `java.util.Optional` 包装器声明参数来指定方法参数是可选的。

如果目标方法参数类型不是 `String`，则自动应用类型转换。请参见类型转换。

将参数类型声明为数组或列表允许解析同一参数名称的多个参数值。

如果 `@RequestParam` 注解声明为 `Map<String, String>` 或 `MultiValueMap<String, String>`，而没有在注解中指定参数名称，则会使用每个给定参数名称的请求参数值填充映射。

注意，`@RequestParam` 的使用是可选的（例如，设置其属性）。默认情况下，任何简单值类型（由 BeanUtils#isSimpleProperty 确定）且未由任何其他参数解析器解析的参数都将被视为使用 `@RequestParam` 进行了注解。

#### @RequestHeader

可以使用 `@RequestHeader` 注解将请求头绑定到控制器中的方法参数。

考虑以下带有标题的请求：

```
Host                    localhost:8080
Accept                  text/html,application/xhtml+xml,application/xml;q=0.9
Accept-Language         fr,en-gb;q=0.7,en;q=0.3
Accept-Encoding         gzip,deflate
Accept-Charset          ISO-8859-1,utf-8;q=0.7,*;q=0.7
Keep-Alive              300
```

以下示例获取 `Accept-Encoding` 和 `Keep-Alive` 标头的值：

```java
@GetMapping("/demo")
public void handle(
        @RequestHeader("Accept-Encoding") String encoding, (1)
        @RequestHeader("Keep-Alive") long keepAlive) { (2)
    //...
}

// (1) 获得 `Accept-Encoding` 标头的值
// (2) 获得 `Keep-Alive` 标头的值
```

如果目标方法参数类型不是 `String`，则自动应用类型转换。请参见类型转换。

当 `@RequestHeader` 注解用于 `Map<String, String>`、`MultiValueMap<String, String>` 或 `HttpHeaders` 参数时，映射将填充所有标头值。

> 内置支持可用于将逗号分隔的字符串转换为字符串数组或字符串集合或类型转换系统已知的其他类型。例如，用 `@RequestHeader("Accept")` 注解的方法参数可以是 `String` 类型，也可以是 `String[]` 或 `List<String>` 类型。

#### @CookieValue

您可以使用 `@CookieValue` 注解将 HTTP cookie 的值绑定到控制器中的方法参数。

考虑使用以下 cookie 的请求：

```
JSESSIONID=415A4AC178C59DACE0B2C9CA727CDD84
```

以下示例显示如何获取 cookie 值：

```java
@GetMapping("/demo")
public void handle(@CookieValue("JSESSIONID") String cookie) { (1)
    //...
}

// (1) 获取 `JSESSIONID` cookie 的值
```

如果目标方法参数类型不是 `String`，则自动应用类型转换。请参见类型转换。

#### @ModelAttribute

您可以在方法参数上使用 `@ModelAttribute` 注解来访问模型中的属性，或者在不存在的情况下将其实例化。model 属性还覆盖了名称与字段名称匹配的 HTTPServlet 请求参数的值。这被称为数据绑定，它使您不必处理解析和转换单个查询参数和表单字段。以下示例显示了如何执行此操作：

```java
@PostMapping("/owners/{ownerId}/pets/{petId}/edit")
public String processSubmit(@ModelAttribute Pet pet) { (1)
    // method logic...
}

// (1) 绑定 `Pet` 实例
```

上述 `Pet` 实例的来源如下：

- 从可能已通过 @ModelAttribute 方法添加的模型中检索。
- 如果 model 属性列在类级别的 `@SessionAttributes` 注解中，则从 HTTP 会话中检索。
- 通过 `Converter` 获得，其中模型属性名称与请求值（如路径变量或请求参数）的名称匹配（请参见下一个示例）。
- 使用其默认构造函数实例化。
- 通过具有与 Servlet 请求参数匹配的参数的“主构造函数”实例化。参数名称通过 JavaBeans `@ConstructorProperties` 或字节码中运行时保留的参数名称确定。

使用 @ModelAttribute 方法来提供它或依赖框架来创建模型属性的另一种选择是使用 `Converter<String, T>` 来提供实例。当模型属性名称与请求值（如路径变量或请求参数）的名称匹配，并且存在从字符串到模型属性类型的转换器时，将应用此选项。在以下示例中，模型属性名称是与 URI 路径变量 `account` 匹配的 `account`，并且有一个注册的 `Converter<String, Account>`，它可以从数据存储中加载 `Account`：

```java
@PutMapping("/accounts/{account}")
public String save(@ModelAttribute("account") Account account) { (1)
    // ...
}

// (1) 使用特定属性名字绑定一个 `Account` 实例
```

获得模型属性实例后，应用数据绑定。`WebDataBinder` 类将 Servlet 请求参数名称（查询参数和表单字段）与目标 `Object` 上的字段名称相匹配。必要时，在应用类型转换后填充匹配字段。有关数据绑定（和验证）的详细信息，请参阅验证。有关自定义数据绑定的详细信息，请参阅 `DataBinder`。

数据绑定可能会导致错误。默认情况下，引发 `BindException`。但是，要检查控制器方法中的此类错误，可以在 `@ModelAttribute` 旁边立即添加 `BindingResult` 参数，如下例所示：

```java
@PostMapping("/owners/{ownerId}/pets/{petId}/edit")
public String processSubmit(@ModelAttribute("pet") Pet pet, BindingResult result) { (1)
    if (result.hasErrors()) {
        return "petForm";
    }
    // ...
}

// (1) 在 `@ModelAttribute` 之后添加 BindingResult
```

在某些情况下，您可能希望在没有数据绑定的情况下访问模型属性。对于这种情况，您可以将 `Model` 注入控制器并直接访问它，或者设置 `@ModelAttribute(binding=false)`，如下例所示：

```java
@ModelAttribute
public AccountForm setUpForm() {
    return new AccountForm();
}

@ModelAttribute
public Account findAccount(@PathVariable String accountId) {
    return accountRepository.findOne(accountId);
}

@PostMapping("update")
public String update(@Valid AccountForm form, BindingResult result,
        @ModelAttribute(binding=false) Account account) { (1)
    // ...
}

// (1) 设置 `@ModelAttribute(binding=false)`
```

通过添加 `jakarta.validation.Valid` 注解或 Spring 的 `@Validated` 注解（Bean 验证和 Spring 验证），可以在数据绑定后自动应用验证。以下示例显示了如何执行此操作：

```java
@PostMapping("/owners/{ownerId}/pets/{petId}/edit")
public String processSubmit(@Valid @ModelAttribute("pet") Pet pet, BindingResult result) { (1)
    if (result.hasErrors()) {
        return "petForm";
    }
    // ...
}

// (1) 验证 `Pet` 实例
```

注意，使用 `@ModelAttribute` 是可选的（例如，设置其属性）。默认情况下，任何不是简单值类型（由 BeanTils#isSimpleProperty 确定）且未被任何其他参数解析器解析的参数都将被视为使用 `@ModelAttribute` 进行了注解。

#### @SessionAttributes

`@SessionAttributes` 用于在请求之间的 HTTPServlet 会话中存储模型属性。它是一个类型级注解，用于声明特定控制器使用的会话属性。这通常会列出模型属性的名称或模型属性的类型，这些属性应透明地存储在会话中，以供后续访问请求使用。

以下示例使用 `@SessionAttributes` 注解：

```java
@Controller
@SessionAttributes("pet") (1)
public class EditPetForm {
    // ...
}

// (1) 使用 @SessionAttributes 注解
```

在第一个请求中，当名称为 `pet` 的模型属性被添加到模型中时，它会自动升级并保存在 HTTP Servlet 会话中。在另一个控制器方法使用 `SessionStatus` 方法参数清除存储之前，它将一直保持不变，如下例所示：

```java
@Controller
@SessionAttributes("pet") (1)
public class EditPetForm {

    // ...

    @PostMapping("/pets/{id}")
    public String handle(Pet pet, BindingResult errors, SessionStatus status) {
        if (errors.hasErrors) {
            // ...
        }
        status.setComplete(); (2)
        // ...
    }
}

// (1) 在 Servlet 会话中存储 `Pet` 值
// (2) 从 Servlet 会话中清除 `Pet` 值
```

#### @SessionAttribute

如果您需要访问全局管理的预先存在的会话属性（即，在控制器外部） —— 例如，通过过滤器），并且可能存在也可能不存在，可以在方法参数上使用 `@SessionAttribute` 注解，如下例所示：

```java
@RequestMapping("/")
public String handle(@SessionAttribute User user) { (1)
    // ...
}

// (1) 使用一个 `@SessionAttribute` 注解
```

对于需要添加或删除会话属性的用例，请考虑将 `org.springframework.web.context.request.WebRequest` 或 `jakarta.servlet.http.HttpSession` 注入控制器方法。

对于作为控制器工作流的一部分在会话中临时存储模型属性，请考虑使用 `@SessionAttributes`，如 `@SessionAttributes` 中所述。

#### @RequestAttribute

与 `@SessionAttribute` 类似，您可以使用 `@RequestAttribute` 注解访问先前创建的预先存在的请求属性（例如，通过 `Servlet` 筛选器或 `HandlerInterceptor`）：

```java
@GetMapping("/")
public String handle(@RequestAttribute Client client) { (1)
    // ...
}

// (1) 使用 `@RequestAttribute` 注解
```

#### 重定向属性

默认情况下，所有模型属性都被视为在重定向 URL 中公开为 URI 模板变量。在剩下的属性中，作为基本类型或基本类型的集合或数组的属性将自动附加为查询参数。

如果模型实例是专门为重定向准备的，则将基本类型属性附加为查询参数可能是所需的结果。但是，在带注解的控制器中，模型可以包含为渲染目的而添加的其他属性（例如，下拉字段值）。为了避免此类属性出现在 URL 中，`@RequestMapping` 方法可以声明 `RedirectAttributes` 类型的参数，并使用它指定 `RedirectView` 可用的确切属性。如果该方法确实重定向，则使用 `RedirectAttributes` 的内容。否则，将使用模型的内容。

`RequestMappingHandlerAdapter` 提供了一个名为 `ignoreDefaultModelOnRedirect` 的标志，您可以使用它来指示如果控制器方法重定向，则不应使用默认模型的内容。相反，控制器方法应该声明 `RedirectAttributes` 类型的属性，如果不这样做，则不应将任何属性传递给`RedirectView`。MVC 命名空间和 MVC Java 配置都将此标志设置为 `false`，以保持向后兼容性。但是，对于新应用程序，我们建议将其设置为 `true`。

请注意，当前请求中的 URI 模板变量在扩展重定向 URL 时自动可用，您不需要通过 `Model` 或 `RedirectAttributes` 显式添加它们。以下示例显示了如何定义重定向：

```java
@PostMapping("/files/{path}")
public String upload(...) {
    // ...
    return "redirect:files/{path}";
}
```

将数据传递到重定向目标的另一种方法是使用 flash 属性。与其他重定向属性不同，flash 属性保存在 HTTP 会话中（因此不会显示在 URL 中）。有关详细信息，请参见 Flash 属性。

#### Flash 属性

Flash 属性为一个请求提供了一种方式来存储要在另一个请求中使用的属性。这是重定向时最常需要的 —— 例如后重定向获取模式。Flash 属性在重定向之前（通常在会话中）临时保存，以便在重定向后对请求可用，并立即删除。

Spring MVC 有两个主要的抽象来支持 flash 属性。`FlashMap` 用于保存 flash 属性，而 `FlashMapManager` 用于存储、检索和管理 `FlashMap` 实例。

Flash 属性支持始终处于“开启”状态，不需要显式启用。但是，如果不使用，它将不会导致 HTTP 会话创建。在每个请求上，都有一个“输入” `FlashMap` 和一个“输出” `FlashMap`，其中包含从上一个请求（如果有）传递的属性，以及一个要为后续请求保存的属性。这两个 `FlashMap` 实例都可以通过 `RequestContextUtils` 中的静态方法从 Spring MVC 中的任何位置访问。

带注解的控制器通常不需要直接使用 `FlashMap`。相反，`@RequestMapping` 方法可以接受 `RedirectAttributes` 类型的参数，并使用它为重定向场景添加 flash 属性。通过 `RedirectAttributes` 添加的 Flash 属性会自动传播到“输出” `FlashMap`。类似地，在重定向之后，来自“输入” `FlashMap` 的属性会自动添加到为目标 URL 提供服务的控制器的模型中。

> **将请求与 flash 属性匹配**
>
> flash 属性的概念存在于许多其他 web 框架中，并被证明有时会遇到并发问题。这是因为，根据定义，flash 属性要存储到下一个请求。然而，“下一个”请求可能不是预期的接收方，而是另一个异步请求（例如，轮询或资源请求），在这种情况下，闪存属性被过早删除。
>
> 为了减少出现此类问题的可能性，`RedirectView` 会自动用目标重定向 URL 的路径和查询参数“标记” `FlashMap` 实例。反过来，默认 `FlashMapManager` 在查找“输入” `FlashMap` 时将该信息与传入请求相匹配。
>
> 这并不能完全消除并发问题的可能性，但通过重定向 URL 中已有的信息，可以大大减少并发问题。因此，我们建议您将 flash 属性主要用于重定向场景。

#### Multipart

启用 `MultipartResolver` 后，将解析包含 `multipart/form-data` 数据的 POST 请求的内容，并将其作为常规请求参数进行访问。以下示例访问一个常规表单字段和一个上载的文件：

```java
@Controller
public class FileUploadController {

    @PostMapping("/form")
    public String handleFormUpload(@RequestParam("name") String name,
            @RequestParam("file") MultipartFile file) {

        if (!file.isEmpty()) {
            byte[] bytes = file.getBytes();
            // store the bytes somewhere
            return "redirect:uploadSuccess";
        }
        return "redirect:uploadFailure";
    }
}
```

将参数类型声明为 `List<MultipartFile>` 允许解析同一参数名称的多个文件。

当 `@RequestParam` 注解声明为 `Map<String, MultipartFile>` 或 `MultiValueMap<String, MultipartFile>` 时，没有在注解中指定参数名，则映射将填充每个给定参数名的 multipart 文件。

> 通过 Servlet multipart 解析，您还可以将 `jakarta.Servlet.http.Part` 声明为方法参数或集合值类型，而不是 Spring 的 `MultipartFile`。

您还可以将 multipart 内容用作到命令对象的数据绑定的一部分。例如，上一示例中的表单字段和文件可以是表单对象上的字段，如下例所示：

```java
class MyForm {

    private String name;

    private MultipartFile file;

    // ...
}

@Controller
public class FileUploadController {

    @PostMapping("/form")
    public String handleFormUpload(MyForm form, BindingResult errors) {
        if (!form.getFile().isEmpty()) {
            byte[] bytes = form.getFile().getBytes();
            // store the bytes somewhere
            return "redirect:uploadSuccess";
        }
        return "redirect:uploadFailure";
    }
}
```

在 RESTful 服务场景中，也可以从非浏览器客户端提交 Multipart 请求。以下示例显示了一个 JSON 文件：

```
POST /someUrl
Content-Type: multipart/mixed

--edt7Tfrdusa7r3lNQc79vXuhIIMlatb7PQg7Vp
Content-Disposition: form-data; name="meta-data"
Content-Type: application/json; charset=UTF-8
Content-Transfer-Encoding: 8bit

{
    "name": "value"
}
--edt7Tfrdusa7r3lNQc79vXuhIIMlatb7PQg7Vp
Content-Disposition: form-data; name="file-data"; filename="file.properties"
Content-Type: text/xml
Content-Transfer-Encoding: 8bit
... File Data ...
```

您可以使用 `@RequestParam` 作为 `String` 访问“元数据”部分，但您可能希望它从 JSON 反序列化（类似于 `@RequestBody`）。使用 HttpMessageConverter 转换后，使用 `@RequestPart` 注解访问 multipart：

```java
@PostMapping("/")
public String handle(@RequestPart("meta-data") MetaData metadata,
        @RequestPart("file-data") MultipartFile file) {
    // ...
}
```

您可以将 `@RequestPart` 与 `jakarta.validation.Valid` 结合使用，也可以使用 Spring 的 `@Validated` 注解，这两者都会导致应用标准 Bean 验证。默认情况下，验证错误会导致 `MethodArgumentNotValidException`，该异常将转换为 400（BAD_REQUEST）响应。或者，可以通过 `Errors` 或 `BindingResult` 参数在控制器内本地处理验证错误，如下例所示：

```java
@PostMapping("/")
public String handle(@Valid @RequestPart("meta-data") MetaData metadata,
        BindingResult result) {
    // ...
}
```

#### @RequestBody

您可以使用 `@RequestBody` 注解通过 `HttpMessageConverter` 将请求体读取并反序列化为 `Object`。以下示例使用 `@RequestBody` 参数：

```java
@PostMapping("/accounts")
public void handle(@RequestBody Account account) {
    // ...
}
```

您可以使用 MVC 配置的消息转换器选项来配置或自定义消息转换。

您可以将 `@RequestBody` 与 `jakarta.validation.Valid` 或 Spring 的 `@Validated` 注解结合使用，这两者都会导致应用标准 Bean 验证。默认情况下，验证错误会导致 `MethodArgumentNotValidException`，该异常将转换为 400（BAD_REQUEST）响应。或者，可以通过 `Errors` 或 `BindingResult` 参数在控制器内本地处理验证错误，如下例所示：

```java
@PostMapping("/accounts")
public void handle(@Valid @RequestBody Account account, BindingResult result) {
    // ...
}
```

#### HttpEntity

`HttpEntity` 或多或少与使用 `@RequestBody` 相同，但它基于一个公开请求头和主体的容器对象。下面的列表显示了一个示例：

```java
@PostMapping("/accounts")
public void handle(HttpEntity<Account> entity) {
    // ...
}
```

#### @ResponseBody

可以在方法上使用 `@ResponseBody` 注解，通过 `HttpMessageConverter` 将返回序列化到响应体。下面的列表显示了一个示例：

```java
@GetMapping("/accounts/{id}")
@ResponseBody
public Account handle() {
    // ...
}
```

`@ResponseBody` 在类级别也受支持，在这种情况下，它由所有控制器方法继承。这是 `@RestController` 的效果，它只是一个标记有 `@Controller` 和 `@ResponseBody` 的元注解。

您可以将 `@ResponseBody` 与反应类型一起使用。有关详细信息，请参阅异步请求和响应类型。

您可以使用 MVC 配置的消息转换器选项来配置或自定义消息转换。

您可以将 `@ResponseBody` 方法与 JSON 序列化视图相结合。有关详细信息，请参见 Jackson JSON。

#### ResponseEntity

`ResponseEntity` 类似于 `@ResponseBody`，但具有状态和标头。例如：

```java
@GetMapping("/something")
public ResponseEntity<String> handle() {
    String body = ... ;
    String etag = ... ;
    return ResponseEntity.ok().eTag(etag).body(body);
}
```

Spring MVC 支持使用单值反应式类型异步生成 `ResponseEntity`，和/或为主体使用单值和多值反应式类型。这允许以下类型的异步响应：

- `ResponseEntity<Mono<T>>` 或 `ResponseElement<Flux<T>>` 使响应状态和标头立即已知，而稍后将异步提供主体。如果主体由 0..1 个值组成，则使用 `Mono`；如果主体可以生成多个值，则使用 `Flux`。
- `Mono<ResponseEntity<T>>` 提供所有三个 —— 响应状态、标头和正文，稍后异步进行。这允许响应状态和标头根据异步请求处理的结果而变化。

#### Jackson JSON

Spring 提供了 Jackson JSON 库的支持。

##### JSON Views

Spring MVC 为 Jackson 的序列化视图提供了内置支持，它只允许呈现 `Object` 中所有字段的子集。要将其与 `@ResponseBody` 或 `ResponseEntity` 控制器方法一起使用，可以使用 Jackson 的 `@JsonView` 注解来激活序列化视图类，如下例所示：

```java
@RestController
public class UserController {

    @GetMapping("/user")
    @JsonView(User.WithoutPasswordView.class)
    public User getUser() {
        return new User("eric", "7!jd#h23");
    }
}

public class User {

    public interface WithoutPasswordView {};
    public interface WithPasswordView extends WithoutPasswordView {};

    private String username;
    private String password;

    public User() {
    }

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    @JsonView(WithoutPasswordView.class)
    public String getUsername() {
        return this.username;
    }

    @JsonView(WithPasswordView.class)
    public String getPassword() {
        return this.password;
    }
}
```

> `@JsonView` 允许视图类数组，但每个控制器方法只能指定一个。如果需要激活多个视图，可以使用复合接口。

如果您希望以编程方式执行上述操作，而不是声明 `@JsonView` 注解，请使用 `MappingJacksonValue` 包装返回值，并使用它提供序列化视图：

```java
@RestController
public class UserController {

    @GetMapping("/user")
    public MappingJacksonValue getUser() {
        User user = new User("eric", "7!jd#h23");
        MappingJacksonValue value = new MappingJacksonValue(user);
        value.setSerializationView(User.WithoutPasswordView.class);
        return value;
    }
}
```

对于依赖视图解析的控制器，可以将序列化视图类添加到模型中，如下例所示：

```java
@Controller
public class UserController extends AbstractController {

    @GetMapping("/user")
    public String getUser(Model model) {
        model.addAttribute("user", new User("eric", "7!jd#h23"));
        model.addAttribute(JsonView.class.getName(), User.WithoutPasswordView.class);
        return "userView";
    }
}
```

### 1.3.4 Model

您可以使用 `@ModelAttribute` 注解：

- 在 `@RequestMapping` 方法中的方法参数上，从模型创建或访问 `Object`，并通过 `WebDataBinder` 将其绑定到请求。
- 作为 `@Controller` 或 `@ControllerAdvice` 类中的方法级注解，帮助在调用任何 `@RequestMapping` 方法之前初始化模型。
- 在 `@RequestMapping` 方法上，标记其返回值的是 model 属性。

本节讨论 `@ModelAttribute` 方法 —— 前一列表中的第二项。控制器可以有任意数量的 `@ModelAttribute` 方法。所有这样的方法都在同一控制器中的 `@RequestMapping` 方法之前调用。`@ModelAttribute` 方法也可以通过 `@ControllerAdvice` 在控制器之间共享。有关详细信息，请参阅控制器切面部分。

`@ModelAttribute` 方法具有灵活的方法签名。它们支持许多与 `@RequestMapping` 方法相同的参数，除了 `@ModelAttribute` 本身或与请求主体相关的任何参数。

以下示例显示了 `@ModelAttribute` 方法：

```java
@ModelAttribute
public void populateModel(@RequestParam String number, Model model) {
    model.addAttribute(accountRepository.findAccount(number));
    // add more ...
}
```

以下示例仅添加一个属性：

```java
@ModelAttribute
public Account addAccount(@RequestParam String number) {
    return accountRepository.findAccount(number);
}
```

> 如果未显式指定名称，则根据 `Object` 类型选择默认名称，如 `Conventions` 的 javadoc 中所述。始终可以使用重载的 `addAttribute` 方法或通过 `@ModelAttribute` 上的 `name` 属性（返回值）指定显式名称。

您还可以使用 `@ModelAttribute` 作为 `@RequestMapping` 方法的方法级注解，在这种情况下，`@RequestMapping` 方法的返回值被解释为模型属性。这通常不是必需的，因为这是 HTML 控制器中的默认行为，除非返回值是一个 `String`，否则将被解释为视图名称 `@ModelAttribute` 还可以自定义模型属性名称，如下例所示：

```java
@GetMapping("/accounts/{id}")
@ModelAttribute("myAccount")
public Account handle() {
    // ...
    return account;
}
```

### 1.3.5 DataBinder

`@Controller` 或 `@ControllerAdvice` 类可以具有初始化 `WebDataBinder` 实例的 `@InitBinder` 方法，这些方法反过来可以：

- 将请求参数（即表单或查询数据）绑定到模型对象。
- 将基于字符串的请求值（如请求参数、路径变量、标头、cookie 等）转换为控制器方法参数的目标类型。
- 渲染 HTML 表单时，将模型对象值设置为 `String` 值。

`@InitBinder` 方法可以注册控制器特定的 `java.beans.PropertyEditor` 或 Spring `Converter` 和 `Formatter` 组件。此外，您可以使用 MVC 配置在全局共享的 `FormattingConversionService` 中注册 `Converter` 和 `Formatter` 类型。

`@InitBinder` 方法支持许多与 `@RequestMapping` 方法相同的参数，但 `@ModelAttribute`（命令对象）参数除外。通常，它们使用 `WebDataBinder` 参数（用于注册）和 `void` 返回值声明。下面的列表显示了一个示例：

```java
@Controller
public class FormController {

    @InitBinder (1)
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, false));
    }

    // ...
}

// (1) 定义一个 `@InitBinder` 方法
```

或者，当您通过共享 `FormattingConversionService` 使用基于 `Formatter` 的设置时，可以重复使用相同的方法并注册控制器特定的 `Formatter` 实现，如下例所示：

```java
@Controller
public class FormController {

    @InitBinder (1)
    protected void initBinder(WebDataBinder binder) {
        binder.addCustomFormatter(new DateFormatter("yyyy-MM-dd"));
    }

    // ...
}

// (1) 在自定义 formatter 上定义 @InitBinder 方法
```

#### Model 设计

在 web 应用程序的上下文中，数据绑定涉及将 HTTP 请求参数（即表单数据或查询参数）绑定到模型对象及其嵌套对象中的属性。

只有遵循 JavaBeans 命名约定的 `public` 属性才能用于数据绑定，例如，`firstName` 属性的 `public String getFirstName()` 和 `public void setFirstName(String)` 方法。

> 模型对象及其嵌套对象图有时也称为命令对象、表单支持对象或 POJO（Plain Old Java Object）。

默认情况下，Spring 允许绑定到模型对象图中的所有公共属性。这意味着您需要仔细考虑模型具有哪些公共属性，因为客户端可以将任何公共属性路径作为目标，甚至可以将一些预期不适用于给定用例的公共属性路径也作为目标。

例如，给定 HTTP 表单数据端点，恶意客户端可能会为模型对象图中存在但不是浏览器中显示的 HTML 表单的一部分的属性提供值。这可能会导致在模型对象及其任何嵌套对象上设置数据，而这些数据并不期待被更新。

推荐的方法是使用专用模型对象，该对象只公开与表单提交相关的财产。例如，在用于更改用户电子邮件地址的表单上，模型对象应该声明一组最小的属性，例如在下面的 `ChangeEmailForm` 中。

```java
public class ChangeEmailForm {

    private String oldEmailAddress;
    private String newEmailAddress;

    public void setOldEmailAddress(String oldEmailAddress) {
        this.oldEmailAddress = oldEmailAddress;
    }

    public String getOldEmailAddress() {
        return this.oldEmailAddress;
    }

    public void setNewEmailAddress(String newEmailAddress) {
        this.newEmailAddress = newEmailAddress;
    }

    public String getNewEmailAddress() {
        return this.newEmailAddress;
    }

}
```

如果您不能或不想为每个数据绑定用例使用专用模型对象，则必须限制数据绑定所允许的财产。理想情况下，可以通过 `WebDataBinder` 上的 `setAllowedFields()` 方法注册允许的字段模式来实现这一点。

例如，要在应用程序中注册允许的字段模式，可以在 `@Controller` 或 `@ControllerAdvice` 组件中实现 `@InitBinder` 方法，如下所示：

```java
@Controller
public class ChangeEmailController {

    @InitBinder
    void initBinder(WebDataBinder binder) {
        binder.setAllowedFields("oldEmailAddress", "newEmailAddress");
    }

    // @RequestMapping methods, etc.

}
```

除了注册允许的模式外，还可以通过 `DataBinder` 及其子类中的 `setDisabledFields()` 方法注册不允许的字段模式。然而，请注意，“允许列表”比“拒绝列表”更安全。因此，`setAllowedFields()` 应该比 `setDisabledFields()` 更受青睐。

注意，与允许的字段模式匹配是区分大小写的；然而，与不允许的字段模式匹配是不区分大小写的。此外，匹配不允许模式的字段将不会被接受，即使它恰好与允许列表中的模式匹配。

> 为数据绑定目的直接公开域模型时，正确配置允许和不允许的字段模式非常重要。否则，这是一个巨大的安全风险。
>
> 此外，强烈建议您不要使用域模型中的类型（如 JPA 或 Hibernate 实体）作为数据绑定场景中的模型对象。

### 1.3.6 异常

`@Controller` 和 `@ControllerAdvice` 类可以使用 `@ExceptionHandler` 方法来处理控制器方法的异常，如下例所示：

```java
@Controller
public class SimpleController {

    // ...

    @ExceptionHandler
    public ResponseEntity<String> handle(IOException ex) {
        // ...
    }
}
```

异常可能与正在传播的顶级异常（例如，抛出直接的 `IOException`）或包装器异常中的嵌套原因（例如，包装在 `IllegalStateException` 中的 `IOException`）匹配。从 5.3 开始，这可以在任意原因级别匹配，而以前只考虑直接原因。

对于匹配的异常类型，最好将目标异常声明为方法参数，如前面的示例所示。当多个异常方法匹配时，根异常匹配通常优先于原因异常匹配。更具体地说，`ExceptionDepthComparator` 用于根据抛出的异常类型的深度对异常进行排序。

或者，注解声明可以缩小异常类型以匹配，如下例所示：

```java
@ExceptionHandler({FileSystemException.class, RemoteException.class})
public ResponseEntity<String> handle(IOException ex) {
    // ...
}
```

您甚至可以使用具有非常通用的参数签名的特定异常类型列表，如下例所示：

```java
@ExceptionHandler({FileSystemException.class, RemoteException.class})
public ResponseEntity<String> handle(Exception ex) {
    // ...
}
```

> 根异常匹配和原因异常匹配之间的区别可能令人惊讶。
>
> 在前面显示的 `IOException` 变体中，通常以实际的 `FileSystemException` 或 `RemoteException` 实例作为参数调用该方法，因为这两个实例都是从 `IOException` 扩展的。但是，如果任何此类匹配异常在包装器异常中传播，而包装器异常本身就是 `IOException`，则传入的异常实例就是该包装器异常。
>
> 在 `handle(Exception)` 变量中，行为甚至更简单。在包装场景中，这总是使用包装器异常来调用，在这种情况下，通过 `ex.getCause()` 可以找到实际匹配的异常。传入的异常是实际的 `FileSystemException` 或 `RemoteException` 实例，仅当它们作为顶级异常抛出时。

我们通常建议您在参数签名中尽可能具体，以减少根异常类型和原因异常类型之间不匹配的可能性。考虑将多匹配方法拆分为单独的 `@ExceptionHandler` 方法，每个方法通过其签名匹配一个特定的异常类型。

在一个多 `@ControllerAdvice` 排列中，我们建议在 `@ControllerAdvice` 上声明您的主根异常映射，并按相应顺序排列优先级。虽然根异常匹配优先于原因，但这是在给定控制器或 `@ControllerAdvice` 类的方法中定义的。这意味着优先级较高的 `@ControllerAdvice` bean上的原因匹配优先于优先级较低的 `@ControllerAdvice` bean 的任何匹配（例如，根）。

最后但并非最不重要的是，`@ExceptionHandler` 方法实现可以选择放弃处理给定的异常实例，方法是以其原始形式重新考虑它。这在您只对根级匹配或无法静态确定的特定上下文中的匹配感兴趣的情况下非常有用。重新抛出的异常会通过剩余的解析链传播，就像给定的 `@ExceptionHandler` 方法一开始就不匹配一样。

Spring MVC 中对 `@ExceptionHandler` 方法的支持基于 `DispatcherServlet` 级别的 HandlerExceptionResolver 机制。

#### 方法参数

`@ExceptionHandler` 方法支持下面参数：

| 方法参数                                                     | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| 异常类型                                                     | 用于访问引发的异常。                                         |
| `HandlerMethod`                                              | 用于访问引发异常的控制器方法。                               |
| `WebRequest`, `NativeWebRequest`                             | 对请求参数、请求和会话属性的通用访问，无需直接使用 Servlet API。 |
| `jakarta.servlet.ServletRequest`, `jakarta.servlet.ServletResponse` | 选择任何特定的请求或响应类型（例如，`ServletRequest `或`HttpServletRequest` 或 Spring 的`MultipartRequest `或` MultipartHttpServletRequest`）。 |
| `jakarta.servlet.http.HttpSession`                           | 强制会话的存在。因此，这样的参数永远不是 `null`。请注意，会话访问不是线程安全的。如果允许多个请求同时访问会话，请考虑将 `RequestMappingHandlerAdapter` 实例的 `synchronizedOnSession` 标志设置为 `true`。 |
| `java.security.Principal`                                    | 当前已验证的用户 —— 如果已知，可能是特定的 `Principal` 实现类。 |
| `HttpMethod`                                                 | 请求的 HTTP 方法。                                           |
| `java.util.Locale`                                           | 当前请求区域设置，由可用的最具体的 `LocaleResolver` 确定 —— 实际上是配置的 `LocaleResolver` 或 `LocaleContextResolver`。 |
| `java.util.TimeZone`, `java.time.ZoneId`                     | 与当前请求关联的时区，由 `LocaleContextResolver` 确定。      |
| `java.io.OutputStream`, `java.io.Writer`                     | 用于访问原始响应主体，如 Servlet API 所公开的。              |
| `java.util.Map`, `org.springframework.ui.Model`, `org.springframework.ui.ModelMap` | 用于访问错误响应的模型。始终为空。                           |
| `RedirectAttributes`                                         | 指定重定向时要使用的属性——（即要附加到查询字符串）和 flash 属性，以在重定向后的请求之前临时存储。请参阅[重定向属性](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-redirecting-passing-data)和[Flash 属性](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-flash-attributes)。 |
| `@SessionAttribute`                                          | 对于任何会话属性的访问，与作为类级别 `@SessionAttributes` 声明的结果存储在会话中的模型属性不同。请参见 [`@SessionAttribute`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-sessionattribute) 了解更多详情。 |
| `@RequestAttribute`                                          | 用于访问请求属性。请参见 [`@RequestAttribute`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestattrib) 获取更多详细信息。 |

#### 返回值

`@ExceptionHandler` 方法支持下面的返回值：

| Return value                                    | Description                                                  |
| :---------------------------------------------- | :----------------------------------------------------------- |
| `@ResponseBody`                                 | 返回值通过 `HttpMessageConverter` 实例转换并写入响应。参见 [`@ResponseBody `](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-responsebody)。 |
| `HttpEntity<B>`, `ResponseEntity<B>`            | 返回值指定通过 `HttpMessageConverter` 实例转换完整响应（包括 HTTP 标头和正文）并将其写入响应。参见 [ResponseEntity](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-responseentity)。 |
| `ErrorResponse`                                 | 要呈现 RFC 7807 错误响应并在正文中提供详细信息，请参阅[错误响应](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-rest-exceptions) |
| `ProblemDetail`                                 | 要呈现 RFC 7807 错误响应并在正文中提供详细信息，请参阅[错误响应](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-rest-exceptions) |
| `String`                                        | 要使用 `ViewResolver` 实现解析并与隐式模型一起使用的视图名称 — 通过命令对象和 `@ModelAttribute` 方法确定。处理程序方法还可以通过声明一个 `Model` 参数（如前所述）以编程方式丰富模型。 |
| `View`                                          | 用于与隐式模型一起呈现的 `View` 实例 —— 通过命令对象和 `@ModelAttribute` 方法确定。处理程序方法还可以通过声明 `Model` 参数（前面已描述）以编程方式丰富模型。 |
| `java.util.Map`, `org.springframework.ui.Model` | 要添加到隐式模型的属性，其视图名称通过 `RequestToViewNameTranslator` 隐式确定。 |
| `@ModelAttribute`                               | 要添加到模型的属性，其视图名称通过 `RequestToViewNameTranslator` 隐式确定。请注意，`@ModelAttribute` 是可选的。请参阅本表末尾的“任何其他返回值”。 |
| `ModelAndView` 对象                             | 要使用的视图和模型属性，以及响应状态（可选）。               |
| `void`                                          | 如果具有 `void` 返回类型（或 `null` 返回值）的方法还具有 `ServletResponse`、`OutputStream` 参数或 `@ResponseStatus` 注释，则认为该方法已完全处理了响应。如果控制器进行了肯定的 `ETag` 或 `lastModified` 时间戳检查（参见[控制器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-caching-etag-lastmodified)以获取详细信息）。如果以上任何一项都不为真，则 `void` 返回类型还可以指示 REST 控制器的“无响应主体”或 HTML 控制器的默认视图名称选择。 |
| Any other return value                          | 如果返回值与上述任何值都不匹配，并且不是简单类型（由 [BeanTils#isSimpleProperty](https://docs.spring.io/spring-framework/docs/6.0.6/javadoc-api/org/springframework/beans/BeanUtils.html#isSimpleProperty-java.lang.Class-) 确定），默认情况下，它被视为要添加到模型中的模型属性。如果它是一个简单类型，它将保持未解析状态。 |

### 1.3.7 控制器切面

`@ExceptionHandler`、`@InitBinder` 和 `@ModelAttribute` 方法仅适用于声明它们的 `@Controller` 类或类层次结构。相反，如果它们在 `@ControllerAdvice` 或 `@RestControllerAdvise` 类中声明，那么它们将应用于任何控制器。此外，从 5.3 开始，`@ControllerAdvice` 中的 `@ExceptionHandler` 方法可用于处理来自任何 `@Controller` 或任何其他处理程序的异常。

`@ControllerAdvice` 使用 `@Component` 进行元注解，因此可以通过组件扫描注册为 Spring bean。`@RestControllerAdvice` 是用 `@ControllerAdvise` 和 `@ResponseBody` 进行元注解的，这意味着 `@ExceptionHandler` 方法将通过响应体消息转换而不是通过 HTML 视图呈现其返回值。

启动时，`RequestMappingHandlerMapping` 和 `ExceptionHandlerExceptionResolver` 检测控制器切面 bean 并在运行时应用它们。`@ControllerAdvice` 中的全局 `@ExceptionHandler` 方法应用于 `@Controller` 中的本地方法之后。相比之下，全局 `@ModelAttribute` 和 `@InitBinder` 方法应用于本地方法之前。

`@ControllerAdvice` 注解具有一些属性，可用于缩小它们所应用的控制器和处理程序集。例如：

```java
// Target all Controllers annotated with @RestController
@ControllerAdvice(annotations = RestController.class)
public class ExampleAdvice1 {}

// Target all Controllers within specific packages
@ControllerAdvice("org.example.controllers")
public class ExampleAdvice2 {}

// Target all Controllers assignable to specific classes
@ControllerAdvice(assignableTypes = {ControllerInterface.class, AbstractController.class})
public class ExampleAdvice3 {}
```

前面示例中的选择器是在运行时评估的，如果广泛使用，可能会对性能产生负面影响。有关详细信息，请参阅 `@ControllerAdvice` javadoc。

## 1.4 函数式端点

Spring Web MVC 包括 WebMvc.fn，这是一个轻量级的函数式编程模型，其中函数用于路由和处理请求，而协约是为不变性而设计的。它是替代基于注解的编程模型的方案，但在其他情况下运行在同一 DispatcherServlet 上。

### 1.4.1 总览

在 WebMvc.fn 中，HTTP 请求由 `HandlerFunction` 处理：一个接受 `ServerRequest` 并返回 `ServerResponse` 的函数。请求和响应对象都有不可变的协约，提供对 HTTP 请求和响应的 JDK 8 友好访问。`HandlerFunction` 相当于基于注解的编程模型中 `@RequestMapping` 方法的主体。

传入请求被路由到具有 `RouterFunction` 的处理程序函数：该函数接受 `ServerRequest` 并返回可选的 `HandlerFunction`（即 `Optional<HandlerFunction>`）。当路由器函数匹配时，返回处理程序函数；否则为空可选。`RouterFunction` 相当于 `@RequestMapping` 注解，但主要区别在于路由器函数不仅提供数据，还提供行为。

`RouterFunctions.route()` 提供了一个路由器生成器，可帮助创建路由器，如下例所示：

```java
import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.web.servlet.function.RequestPredicates.*;
import static org.springframework.web.servlet.function.RouterFunctions.route;

PersonRepository repository = ...
PersonHandler handler = new PersonHandler(repository);

RouterFunction<ServerResponse> route = route() (1)
    .GET("/person/{id}", accept(APPLICATION_JSON), handler::getPerson)
    .GET("/person", accept(APPLICATION_JSON), handler::listPeople)
    .POST("/person", handler::createPerson)
    .build();


public class PersonHandler {

    // ...

    public ServerResponse listPeople(ServerRequest request) {
        // ...
    }

    public ServerResponse createPerson(ServerRequest request) {
        // ...
    }

    public ServerResponse getPerson(ServerRequest request) {
        // ...
    }
}

// (1) 通过 `route()` 创建路由
```

如果您将 `RouterFunction` 注册为 bean，例如通过在 `@Configuration` 类中公开它，servlet 将自动检测到它，如“运行服务器”中所述。

### 1.4.2 HandlerFunction

`ServerRequest` 和 `ServerResponse` 是不可变的接口，提供对 HTTP 请求和响应的 JDK 8 友好的访问，包括头、体、方法和状态代码。

#### ServerRequest

`ServerRequest` 提供对 HTTP 方法、URI、请求头和查询参数的访问，而对请求体的访问是通过 `body` 方法提供的。

以下示例将请求体提取为字符串：

```java
String string = request.body(String.class);
```

以下示例将请求体提取到 `List<Person>`，其中 `Person` 对象从序列化形式（如 JSON 或 XML）解码：

```java
List<Person> people = request.body(new ParameterizedTypeReference<List<Person>>() {});
```

以下示例显示了如何访问参数：

```java
MultiValueMap<String, String> params = request.params();
```

#### ServerResponse

`ServerResponse` 提供对 HTTP 响应的访问，因为它是不可变的，所以可以使用构建方法来创建它。您可以使用构建器来设置响应状态、添加响应头或提供响应体。以下示例使用 JSON 内容创建 200（OK）响应：

```java
Person person = ...
ServerResponse.ok().contentType(MediaType.APPLICATION_JSON).body(person);
```

下面的示例显示了如何构建一个 201（CREATED）响应，该响应带有 `Location` 标头而没有正文：

```java
URI location = ...
ServerResponse.created(location).build();
```

您还可以使用异步结果作为正文，形式为 `CompletableFuture`、`Publisher` 或 `ReactiveAdapterRegistry` 支持的任何其他类型。例如：

```java
Mono<Person> person = webClient.get().retrieve().bodyToMono(Person.class);
ServerResponse.ok().contentType(MediaType.APPLICATION_JSON).body(person);
```

如果不仅正文，而且状态或标头都基于异步类型，则可以在 `ServerResponse` 上使用静态 `async` 方法，该方法接受 `CompletableFuture<ServerResponse>`、`Publisher<ServerResponse>` 或 `ReactiveAdapterRegistry` 支持的任何其他异步类型。例如：

```java
Mono<ServerResponse> asyncResponse = webClient.get().retrieve().bodyToMono(Person.class)
  .map(p -> ServerResponse.ok().header("Name", p.name()).body(p));
ServerResponse.async(asyncResponse);
```

服务器发送事件可以通过 `ServerResponse` 上的静态 `sse` 方法提供。该方法提供的生成器允许您将字符串或其他对象作为 JSON 发送。例如：

```java
public RouterFunction<ServerResponse> sse() {
    return route(GET("/sse"), request -> ServerResponse.sse(sseBuilder -> {
                // Save the sseBuilder object somewhere..
            }));
}

// In some other thread, sending a String
sseBuilder.send("Hello world");

// Or an object, which will be transformed into JSON
Person person = ...
sseBuilder.send(person);

// Customize the event by using the other methods
sseBuilder.id("42")
        .event("sse event")
        .data(person);

// and done at some point
sseBuilder.complete();
```

#### Handler 类

我们可以将处理函数写成 lambda，如下例所示：

```java
HandlerFunction<ServerResponse> helloWorld =
  request -> ServerResponse.ok().body("Hello World");
```

这很方便，但在一个应用程序中，我们需要多个函数，多个内联 lambda 可能会变得混乱。因此，将相关的处理程序函数分组到一个处理程序类中是很有用的，该类的作用与基于注解的应用程序中的 `@Controller` 类似。例如，下面的类公开了一个被动的 `Person` 存储库：

```java
import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.web.reactive.function.server.ServerResponse.ok;

public class PersonHandler {

    private final PersonRepository repository;

    public PersonHandler(PersonRepository repository) {
        this.repository = repository;
    }

    public ServerResponse listPeople(ServerRequest request) { (1)
        List<Person> people = repository.allPeople();
        return ok().contentType(APPLICATION_JSON).body(people);
    }

    public ServerResponse createPerson(ServerRequest request) throws Exception { (2)
        Person person = request.body(Person.class);
        repository.savePerson(person);
        return ok().build();
    }

    public ServerResponse getPerson(ServerRequest request) { (3)
        int personId = Integer.parseInt(request.pathVariable("id"));
        Person person = repository.getPerson(personId);
        if (person != null) {
            return ok().contentType(APPLICATION_JSON).body(person);
        }
        else {
            return ServerResponse.notFound().build();
        }
    }

}

// (1) `listPeople` 是一个处理程序函数，它将存储库中找到的所有 `Person` 对象作为JSON返回。
// (2) `createPerson` 是一个处理程序函数，用于存储请求主体中包含的新 `Person`。
// (3) `getPerson` 是一个处理程序函数，它返回由 `id` 路径变量标识的单个人员。我们从存储库中检索该 `Person` 并创建 JSON 响应（如果找到）。如果找不到，则返回 404 not found 响应。
```

#### 验证

函数式端点可以使用 Spring 的验证工具对请求主体应用验证。例如，给定 Person 的自定义 Spring Validator 实现：

```java
public class PersonHandler {

    private final Validator validator = new PersonValidator(); (1)

    // ...

    public ServerResponse createPerson(ServerRequest request) {
        Person person = request.body(Person.class);
        validate(person); (2)
        repository.savePerson(person);
        return ok().build();
    }

    private void validate(Person person) {
        Errors errors = new BeanPropertyBindingResult(person, "person");
        validator.validate(person, errors);
        if (errors.hasErrors()) {
            throw new ServerWebInputException(errors.toString()); (3)
        }
    }
}

// (1) 创建 `Validator` 实例
// (2) 应用验证
// (3) 为 400 响应扔出一个异常
```

处理程序还可以通过创建和注入基于 `LocalValidatorFactoryBean` 的全局 `Validator` 实例来使用标准 bean 验证 API（JSR-303）。参见 Spring 验证。

### 1.4.3 RouterFunction

路由器函数用于将请求路由到相应的 `HandlerFunction`。通常，您不自己编写路由器函数，而是使用 `RouterFunctions` 实用程序类上的方法来创建路由器函数。`RouterFunctions.route()`（无参数）为创建路由器函数提供了一个流畅的生成器，而 `RouterFunctions.route(RequestPredicate，HandlerFunction)` 提供了创建路由器的直接方法。

通常，建议使用 `route()` 生成器，因为它为典型的映射场景提供了方便的快捷方式，而不需要很难发现静态导入。例如，路由器函数生成器提供了 `GET(String, HandlerFunction)` 方法来创建 GET 请求的映射；以及给 POST 的 `POST(String, HandlerFunction)`。

除了基于 HTTP 方法的映射之外，路由生成器还提供了一种在映射到请求时引入附加谓词的方法。对于每个 HTTP 方法，都有一个重载变量，它将 `RequestPredicate` 作为参数，通过它可以表达额外的约束。

#### 谓词

您可以编写自己的 `RequestPredicate`，但 `RequestPredicates` 实用程序类提供了基于请求路径、HTTP 方法、内容类型等的常用实现。以下示例使用请求谓词基于 `Accept` 标头创建约束：

```java
RouterFunction<ServerResponse> route = RouterFunctions.route()
    .GET("/hello-world", accept(MediaType.TEXT_PLAIN),
        request -> ServerResponse.ok().body("Hello World")).build();
```

您可以使用以下方法组合多个请求谓词：

- `RequestPredicate.and(RequestPredicate)` — 必须匹配两者.
- `RequestPredicate.or(RequestPredicate)` — 任意一个可以匹配.

`RequestPredicates` 中的许多谓词都是组合的。例如，`RequestPredicates.GET(String)` 由 `RequestPredicites.method(HttpMethod) ` 和 `RequestPredicates.path(String)` 组成。上面显示的示例还使用了两个请求谓词，因为构建器在内部使用 `RequestPredictes.GET`，并将其与 `accept` 谓词组合。

#### 路由

路由器函数按顺序求值：如果第一条路由不匹配，则考虑第二条路由，依此类推。因此，在一般路由之前声明更具体的路由是有意义的。这在将路由器功能注册为 Spring bean 时也很重要，稍后将对此进行描述。请注意，这种行为与基于注解的编程模型不同，其中“最特定”的控制器方法是自动选择的。

当使用 router 函数生成器时，所有定义的路由都被组成一个 `RouterFunction`，该 `RouterFunction` 从 `build()` 返回。还有其他方法可以将多个路由器功能组合在一起：

- `add(RouterFunction)` 在 `RouterFunctions.route()` builder 上
- `RouterFunction.and(RouterFunction)`
- `RouterFunction.andRoute(RequestPredicate, HandlerFunction)` —— 创建具有嵌套的 `RouterFunctions.route()` 的 `RouterFunction.and()` 的快捷方式。

以下示例显示了四条路由的组建：

```java
import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.web.servlet.function.RequestPredicates.*;

PersonRepository repository = ...
PersonHandler handler = new PersonHandler(repository);

RouterFunction<ServerResponse> otherRoute = ...

RouterFunction<ServerResponse> route = route()
    .GET("/person/{id}", accept(APPLICATION_JSON), handler::getPerson) (1)
    .GET("/person", accept(APPLICATION_JSON), handler::listPeople) (2)
    .POST("/person", handler::createPerson) (3)
    .add(otherRoute) (4)
    .build();

// (1) 具有与 JSON 匹配的 `Accept` 标头的 `GET /person/{id}` 被路由到 `PersonHandler.getPerson`
// (2) 具有与 JSON 匹配的 `Accept` 标头的 `GET /person` 被路由到 `PersonHandler.listPeople`
// (3) 没有附加谓词的 `POST /person` 映射到 `PersonHandler.createPerson`，并且
// (4) `otherRoute` 是在其他地方创建的路由器函数，并添加到构建的路由中。
```

#### 嵌套路由

一组路由器函数通常具有共享谓词，例如共享路径。在上面的示例中，共享谓词将是一个匹配 `/person` 的路径谓词，由三个路由使用。使用注解时，可以使用映射到 `/person` 的类型级别 `@RequestMapping` 注解来删除此重复。在 WebMvc.fn 中，路径谓词可以通过路由器函数生成器上的路径方法共享。例如，上面示例的最后几行可以通过使用嵌套路由以以下方式进行改进：

```java
RouterFunction<ServerResponse> route = route()
    .path("/person", builder -> builder (1)
        .GET("/{id}", accept(APPLICATION_JSON), handler::getPerson)
        .GET(accept(APPLICATION_JSON), handler::listPeople)
        .POST(handler::createPerson))
    .build();

// (1) 注意，路径的第二个参数是采用路由器生成器的使用者。
```

虽然基于路径的嵌套是最常见的，但您可以通过在生成器上使用 `nest` 方法来嵌套任何类型的谓词。上面仍然以共享 `Accept` 头谓词的形式包含一些重复。我们可以通过使用 `nest` 方法和 `accept` 来进一步改进：

```java
RouterFunction<ServerResponse> route = route()
    .path("/person", b1 -> b1
        .nest(accept(APPLICATION_JSON), b2 -> b2
            .GET("/{id}", handler::getPerson)
            .GET(handler::listPeople))
        .POST(handler::createPerson))
    .build();
```

### 1.4.4 运行服务器

您通常通过 MVC 配置在基于 `DispatcherHandler` 的设置中运行路由器函数，MVC 配置使用 Spring 配置来声明处理请求所需的组件。MVC Java 配置声明了以下基础架构组件以支持函数式端点：

- `RouterFunctionMapping`：检测一个或多个 `RouterFunction<?>` Spring 配置中的 bean，对它们进行排序，通过 `RouterFunction.andOther` 组合它们，并将请求路由到合成的 `RouterFunction`。
- `HandlerFunctionAdapter`：允许 `DispatcherHandler` 调用映射到请求的 `HandlerFunction` 的简单适配器。

前面的组件使函数式端点适合 `DispatcherServlet` 请求处理生命周期，并且（可能）与带注释的控制器（如果声明了任何控制器）并行运行。这也是 Spring Boot Web 启动器如何启用函数式端点。

以下示例显示 WebFlux Java 配置：

```java
@Configuration
@EnableMvc
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public RouterFunction<?> routerFunctionA() {
        // ...
    }

    @Bean
    public RouterFunction<?> routerFunctionB() {
        // ...
    }

    // ...

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        // configure message conversion...
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // configure CORS...
    }

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        // configure view resolution for HTML rendering...
    }
}
```

### 1.4.5 过滤处理器函数

您可以使用路由函数生成器上的 `before`、`after` 或 `filter` 方法来筛选处理程序函数。通过注解，您可以通过使用 `@ControllerAdvice`、`ServletFilter` 或两者实现类似的功能。过滤器将应用于由生成器生成的所有管线。这意味着嵌套路由中定义的筛选器不适用于“顶级”路由。例如，考虑以下示例：

```java
RouterFunction<ServerResponse> route = route()
    .path("/person", b1 -> b1
        .nest(accept(APPLICATION_JSON), b2 -> b2
            .GET("/{id}", handler::getPerson)
            .GET(handler::listPeople)
            .before(request -> ServerRequest.from(request) (1)
                .header("X-RequestHeader", "Value")
                .build()))
        .POST(handler::createPerson))
    .after((request, response) -> logResponse(response)) (2)
    .build();

// (1) 添加自定义请求头的 `before` 筛选器仅应用于两个 GET 路由。
// (2) 记录响应的 `after` 筛选器应用于所有路由，包括嵌套路由。
```

路由器生成器上的 `filter` 方法采用 `HandlerFilterFunction`：一个采用 `ServerRequest` 和 `HandlerFunction` 并返回 `ServerResponse` 的函数。处理程序函数参数表示链中的下一个元素。这通常是路由到的处理程序，但如果应用了多个，它也可以是另一个过滤器。

现在，我们可以向路由添加一个简单的安全筛选器，假设我们有一个 `SecurityManager`，它可以确定是否允许特定路径。以下示例显示了如何执行此操作：

```java
SecurityManager securityManager = ...

RouterFunction<ServerResponse> route = route()
    .path("/person", b1 -> b1
        .nest(accept(APPLICATION_JSON), b2 -> b2
            .GET("/{id}", handler::getPerson)
            .GET(handler::listPeople))
        .POST(handler::createPerson))
    .filter((request, next) -> {
        if (securityManager.allowAccessTo(request.path())) {
            return next.handle(request);
        }
        else {
            return ServerResponse.status(UNAUTHORIZED).build();
        }
    })
    .build();
```

前面的示例演示了调用 `next.handle(ServerRequest)` 是可选的。我们只允许在允许访问时运行处理程序函数。

除了在路由器函数生成器上使用筛选器方法之外，还可以通过 `RouterFunction.filter(HandlerFilterFunction)` 将筛选器应用于现有的路由器函数。

> CORS 对函数式端点的支持是通过专用的 `CorsFilter` 提供的。

## 1.5 URI 链接

本节描述了 Spring 框架中使用 URI 的各种选项。

### 1.5.1 UriComponents

Spring MVC 和Spring WebFlux

`UriComponentsBuilder` 帮助使用变量从 URI 模板构建 URI，如下例所示：

```java
UriComponents uriComponents = UriComponentsBuilder
        .fromUriString("https://example.com/hotels/{hotel}") (1)
        .queryParam("q", "{q}") (2)
        .encode() (3)
        .build(); (4)

URI uri = uriComponents.expand("Westin", "123").toUri(); (5)

// (1) 具有 URI 模板的静态工厂方法。
// (2) 添加或替换 URI 组件。
// (3) 请求对 URI 模板和 URI 变量进行编码。
// (4) 构建 UriComponents。
// (5) 展开变量并获取 URI。
```

前面的示例可以合并为一个链，并使用 `buildAndExpand` 缩短，如下例所示：

```java
URI uri = UriComponentsBuilder
        .fromUriString("https://example.com/hotels/{hotel}")
        .queryParam("q", "{q}")
        .encode()
        .buildAndExpand("Westin", "123")
        .toUri();
```

您可以通过直接使用 URI（这意味着编码）来进一步缩短它，如下例所示：

```java
URI uri = UriComponentsBuilder
        .fromUriString("https://example.com/hotels/{hotel}")
        .queryParam("q", "{q}")
        .build("Westin", "123");
```

您可以使用完整的 URI 模板进一步缩短它，如下例所示：

```java
URI uri = UriComponentsBuilder
        .fromUriString("https://example.com/hotels/{hotel}?q={q}")
        .build("Westin", "123");
```

### 1.5.2 UriBuilder

Spring MVC 和Spring WebFlux

`UriComponentsBuilder` 实现 `UriBuilder`。您可以依次使用 `UriBuilderFactory` 创建 `UriBuilder`。`UriBuilderFactory` 和 `UriBuilder` 一起提供了一种可插入的机制，可以根据共享配置（如基本 URL、编码首选项和其他详细信息）从 URI 模板构建 URI。

您可以使用 `UriBuilderFactory` 配置 `RestTemplate` 和 `WebClient`，以自定义 URI 的准备。`DefaultUriBuilderFactory` 是 `UriBuilderFactory` 的默认实现，它在内部使用 `UriComponentsBuilder` 并公开共享配置选项。

以下示例显示如何配置 `RestTemplate`：

```java
// import org.springframework.web.util.DefaultUriBuilderFactory.EncodingMode;

String baseUrl = "https://example.org";
DefaultUriBuilderFactory factory = new DefaultUriBuilderFactory(baseUrl);
factory.setEncodingMode(EncodingMode.TEMPLATE_AND_VALUES);

RestTemplate restTemplate = new RestTemplate();
restTemplate.setUriTemplateHandler(factory);
```

下面例子配置了一个 `WebClient`：

```java
// import org.springframework.web.util.DefaultUriBuilderFactory.EncodingMode;

String baseUrl = "https://example.org";
DefaultUriBuilderFactory factory = new DefaultUriBuilderFactory(baseUrl);
factory.setEncodingMode(EncodingMode.TEMPLATE_AND_VALUES);

WebClient client = WebClient.builder().uriBuilderFactory(factory).build();
```

此外，还可以直接使用 `DefaultUriBuilderFactory`。它类似于使用 `UriComponentsBuilder`，但它不是静态工厂方法，而是保存配置和首选项的实际实例，如下例所示：

```java
String baseUrl = "https://example.com";
DefaultUriBuilderFactory uriBuilderFactory = new DefaultUriBuilderFactory(baseUrl);

URI uri = uriBuilderFactory.uriString("/hotels/{hotel}")
        .queryParam("q", "{q}")
        .build("Westin", "123");
```

### 1.5.3 URI 编码

Spring MVC 和Spring WebFlux

`UriComponentsBuilder` 在两个级别公开编码选项：

- UriComponentsBuilder#encodes()：首先对 URI 模板进行预编码，然后在展开（expand）时对 URI 变量进行严格编码。
- UriComponents#encode()：在 URI 变量展开后对 URI 组件进行编码。

这两个选项都用转义的八位字节替换非 ASCII 和非法字符。但是，第一个选项还将替换 URI 变量中出现的具有保留含义的字符。

> 考虑一下“;”，它在路径上是合法的，但有保留的含义。第一个选项将URI变量中的“;”替换为“%3B”，但不在 URI 模板中。相比之下，第二个选项从不替换“;”，因为它是路径中的合法字符。

在大多数情况下，第一个选项可能会给出预期的结果，因为它将 URI 变量视为要完全编码的不透明数据，而如果 URI 变量故意包含保留字符，则第二个选项很有用。当根本不扩展 URI 变量时，第二个选项也很有用，因为这也会对任何偶然看起来像 URI 变量的内容进行编码。

以下示例使用第一个选项：

```java
URI uri = UriComponentsBuilder.fromPath("/hotel list/{city}")
        .queryParam("q", "{q}")
        .encode()
        .buildAndExpand("New York", "foo+bar")
        .toUri();

// Result is "/hotel%20list/New%20York?q=foo%2Bbar"
```

您可以通过直接转到 URI（这意味着编码）来缩短前面的示例，如下例所示：

```java
URI uri = UriComponentsBuilder.fromPath("/hotel list/{city}")
        .queryParam("q", "{q}")
        .build("New York", "foo+bar");
```

您可以使用完整的 URI 模板进一步缩短它，如下例所示：

```java
URI uri = UriComponentsBuilder.fromUriString("/hotel list/{city}?q={q}")
        .build("New York", "foo+bar");
```

`WebClient` 和 `RestTemplate` 通过 `UriBuilderFactory` 策略在内部扩展和编码 URI 模板。两者都可以使用自定义策略进行配置，如下例所示：

```java
String baseUrl = "https://example.com";
DefaultUriBuilderFactory factory = new DefaultUriBuilderFactory(baseUrl)
factory.setEncodingMode(EncodingMode.TEMPLATE_AND_VALUES);

// Customize the RestTemplate..
RestTemplate restTemplate = new RestTemplate();
restTemplate.setUriTemplateHandler(factory);

// Customize the WebClient..
WebClient client = WebClient.builder().uriBuilderFactory(factory).build();
```

`DefaultUriBuilderFactory` 实现在内部使用 `UriComponentsBuilder` 来扩展和编码 URI 模板。作为一个工厂，它提供了一个单独的地方来根据以下编码模式之一配置编码方法：

- `TEMPLATE_AND_VALUES`：使用 `UriComponentsBuilder#encodes()`（对应于前面列表中的第一个选项）对 URI 模板进行预编码，并在展开时对 URI 变量进行严格编码。
- `VALUES_ONLY`：不编码 URI 模板，而是在将 URI 变量扩展到模板之前，通过 `UriUtils#encodeUriVariables` 对其应用严格编码。
- `URI_COMPONENT`：在 URI 变量展开后，使用 `UriComponents#encode()`（对应于前面列表中的第二个选项）对 URI 组件值进行编码。
- `NONE`：未应用编码。

出于历史原因和向后兼容性，`RestTemplate` 设置为 `EncodingMode.URI_COMPONENT`。 `WebClient` 依赖于 `DefaultUriBuilderFactory` 中的默认值，该值从 5.0.x 中的 `EncodingMode.URI_COMPONENT` 更改为 5.1 中的 `EncodengMode.TEMPLATE_AND_VALUES`。

### 1.5.4 相关的 Servlet 请求

您可以使用 `ServletUriComponentsBuilder` 创建与当前请求相关的 URI，如下例所示：

```java
HttpServletRequest request = ...

// Re-uses scheme, host, port, path, and query string...

URI uri = ServletUriComponentsBuilder.fromRequest(request)
        .replaceQueryParam("accountId", "{id}")
        .build("123");
```

您可以创建与上下文路径相关的 URI，如下例所示：

```java
HttpServletRequest request = ...

// Re-uses scheme, host, port, and context path...

URI uri = ServletUriComponentsBuilder.fromContextPath(request)
        .path("/accounts")
        .build()
        .toUri();
```

您可以创建与 Servlet 相关的 URI（例如 `/main/*`），如下例所示：

```java
HttpServletRequest request = ...

// Re-uses scheme, host, port, context path, and Servlet mapping prefix...

URI uri = ServletUriComponentsBuilder.fromServletMapping(request)
        .path("/accounts")
        .build()
        .toUri();
```

> 从 5.1 开始，`ServletUriComponentsBuilder` 忽略 `Forwarded` 和 `X-Forwarded-*` 标头中的信息，这些标头指定了客户端发起的地址。考虑使用 `ForwardedHeaderFilter` 来提取和使用或丢弃此类标头。

### 1.5.5 连接到控制器

Spring MVC 提供了一种机制来准备到控制器方法的链接。例如，以下 MVC 控制器允许创建链接：

```java
@Controller
@RequestMapping("/hotels/{hotel}")
public class BookingController {

    @GetMapping("/bookings/{booking}")
    public ModelAndView getBooking(@PathVariable Long booking) {
        // ...
    }
}
```

您可以通过按名称引用方法来准备链接，如下例所示：

```java
UriComponents uriComponents = MvcUriComponentsBuilder
    .fromMethodName(BookingController.class, "getBooking", 21).buildAndExpand(42);

URI uri = uriComponents.encode().toUri();
```

在前面的示例中，我们提供了实际的方法参数值（在本例中为 long 值：`21`），用作路径变量并插入到 URL 中。此外，我们提供值 `42` 来填充任何剩余的 URI 变量，例如从类型级请求映射继承的酒店变量。如果该方法有更多的参数，我们可以为 URL 不需要的参数提供 null。通常，只有 `@PathVariable` 和 `@RequestParam` 参数与构造 URL 相关。

还有其他方法可以使用 `MvcUriComponentsBuilder`。例如，您可以使用类似于通过代理进行模拟测试的技术，以避免按名称引用控制器方法，如下例所示（该示例假定 `MvcUriComponentsBuilder.on` 的静态导入）：

```java
UriComponents uriComponents = MvcUriComponentsBuilder
    .fromMethodCall(on(BookingController.class).getBooking(21)).buildAndExpand(42);

URI uri = uriComponents.encode().toUri();
```

> 当控制器方法签名被认为可用于使用 `fromMethodCall` 创建链接时，它们的设计受到限制。除了需要正确的参数签名之外，返回类型（即为链接生成器调用生成运行时代理）也有技术限制，因此返回类型不能是 `final` 的。特别是，视图名称的常见 `String` 返回类型在这里不起作用。您应该使用 `ModelAndView` 或甚至纯 `Object`（带有 `String` 返回值）。

前面的示例在 `MvcUriComponentsBuilder` 中使用静态方法。在内部，它们依赖 `ServletUriComponentsBuilder` 从当前请求的方案、主机、端口、上下文路径和 servlet 路径准备一个基本 URL。这在大多数情况下都很有效。然而，有时，这可能是不够的。例如，您可能在请求的上下文之外（例如准备链接的批处理过程），或者可能需要插入路径前缀（例如从请求路径中删除并需要重新插入到链接中的区域设置前缀）。

对于这种情况，可以使用静态 `fromXxx` 重载方法，这些方法接受 `UriComponentsBuilder` 以使用基 URL。或者，您可以使用基 URL 创建 `MvcUriComponentsBuilder` 的实例，然后使用基于实例的 `withXxx` 方法。例如，以下列表使用 `withMethodCall`：

```java
UriComponentsBuilder base = ServletUriComponentsBuilder.fromCurrentContextPath().path("/en");
MvcUriComponentsBuilder builder = MvcUriComponentsBuilder.relativeTo(base);
builder.withMethodCall(on(BookingController.class).getBooking(21)).buildAndExpand(42);

URI uri = uriComponents.encode().toUri();
```

> 从 5.1 开始，`MvcUriComponentsBuilder` 忽略 `Forwarded` 和 `X-Forwarded-*` 标头中的信息，这些标头指定了客户端发起的地址。考虑使用 ForwardedHeaderFilter 来提取和使用或丢弃此类标头。

### 1.5.6 视图中的连接

在 Thymelaf、FreeMarker 或 JSP 等视图中，可以通过引用每个请求映射的隐式或显式分配的名称来构建到带注解控制器的链接。

考虑以下示例：

```java
@RequestMapping("/people/{id}/addresses")
public class PersonAddressController {

    @RequestMapping("/{country}")
    public HttpEntity<PersonAddress> getAddress(@PathVariable String country) { ... }
}
```

给定前面的控制器，您可以从 JSP 准备一个链接，如下所示：

```jsp
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
...
<a href="${s:mvcUrl('PAC#getAddress').arg(0,'US').buildAndExpand('123')}">Get Address</a>
```

前面的示例依赖于 Spring 标记库（即 META-INF/Spring.tld）中声明的 `mvcUrl` 函数，但很容易定义自己的函数或为其他模板技术准备一个类似的函数。

这是如何工作的。启动时，通过 `HandlerMethodMappingNamingStrategy` 为每个 `@RequestMapping` 分配一个默认名称，其默认实现使用类的大写字母和方法名称（例如，`ThingController` 中的 `getThing` 方法变为“TC#getThing”）。如果存在名称冲突，可以使用 `@RequestMapping(name="..")` 来指定显式名称或实现自己的 `HandlerMethodMappingNamingStrategy`。

## 1.6 异步请求

Spring MVC 与 Servlet 异步请求处理有着广泛的集成：

- 控制器方法中的 `DeferredResult` 和 `Callable` 返回值为单个异步返回值提供了基本支持。
- 控制器可以流式传输多个值，包括 SSE 和原始数据。
- 控制器可以使用反应式客户端并返回反应式类型进行响应处理。

要了解这与 Spring WebFlux 的区别，请参阅下面的“异步Spring MVC 与 WebFlux” 部分。

### 1.6.1 DeferredResult

在 Servlet 容器中启用异步请求处理功能后，控制器方法可以使用 `DeferredResult` 包装任何受支持的控制器方法返回值，如下例所示：

```java
@GetMapping("/quotes")
@ResponseBody
public DeferredResult<String> quotes() {
    DeferredResult<String> deferredResult = new DeferredResult<String>();
    // Save the deferredResult somewhere..
    return deferredResult;
}

// From some other thread...
deferredResult.setResult(result);
```

控制器可以从不同的线程异步生成返回值 —— 例如，响应于外部事件（JMS消息）、调度任务或其他事件。

### 1.6.2 Callable

控制器可以使用 `java.util.concurrent.Callable` 包装任何支持的返回值，如下例所示：

```java
@PostMapping
public Callable<String> processUpload(final MultipartFile file) {
    return () -> "someView";
}
```

然后，可以通过配置的 `TaskExecutor` 运行给定的任务来获得返回值。

### 1.6.3 处理（Processing）

以下是 Servlet 异步请求处理的简要概述：

- 通过调用 `request.startAsync()`，可以将 `ServletRequest` 置于异步模式。这样做的主要效果是 Servlet（以及任何筛选器）可以退出，但响应保持打开状态，以便稍后完成处理。
- 对 `request.startAsync()` 的调用返回 `AsyncContext`，您可以使用它来进一步控制异步处理。例如，它提供了 `dispatch` 方法，该方法类似于 Servlet API 的转发，只是它允许应用程序在 Servlet 容器线程上恢复请求处理。
- `ServletRequest` 提供对当前 `DispatcherType` 的访问，您可以使用它来区分处理初始请求、异步调度、转发和其他调度程序类型。

`DeferredResult` 处理的工作原理如下：

- 控制器返回一个 `DeferredResult`，并将其保存在内存中的某个队列或列表中，以便访问。
- Spring MVC 调用 `request.startAsync()`。
- 同时，`DispatcherServlet` 和所有配置的筛选器退出请求处理线程，但响应保持打开状态。
- 应用程序从某个线程设置 `DeferredResult`，Spring MVC 将请求分派回 Servlet 容器。
- `DispatcherServlet` 将被再次调用，处理将使用异步生成的返回值继续进行。

`Callable` 处理工作如下：

- 控制器返回一个 `Callable`。
- Spring MVC 调用 `request.startAsync()` 并将 `Callable` 提交给`TaskExecutor`，以便在单独的线程中进行处理。
- 同时，`DispatcherServlet` 和所有过滤器退出 Servlet 容器线程，但响应保持打开状态。
- 最终，`Callable` 生成一个结果，Spring MVC 将请求分派回 Servlet 容器以完成处理。
- `DispatcherServlet` 将被再次调用，处理将通过 `Callable` 异步生成的返回值继续进行。

有关进一步的背景和上下文，您还可以阅读在 Spring MVC 3.2 中引入异步请求处理支持的博客文章。

#### 异常处理

当您使用 `DeferredResult` 时，您可以选择是调用 `setResult` 还是调用带有异常的 `setErrorResult`。在这两种情况下，Spring MVC 都会将请求分派回 Servlet 容器以完成处理。然后，它被视为控制器方法返回了给定的值，或者被视为产生了给定的异常。然后，异常通过常规异常处理机制（例如，调用 `@ExceptionHandler` 方法）。
当您使用 `Callable` 时，会出现类似的处理逻辑，主要区别在于结果是从 `Callable` 返回的，或者由它引发异常。

#### 拦截

`HandlerInterceptor` 实例可以是 `AsyncHandlerInterreceptor` 类型，以接收启动异步处理的初始请求上的 `afterCurrentHandlingStarted` 回调（而不是 `postHandle` 和 `afterCompletion`）。

`HandlerInterceptor` 实现还可以注册 `CallableProcessingInterceptor` 或 `DeferredResultProcessingIntersector`，以便与异步请求的生命周期进行更深入的集成（例如，处理超时事件）。有关更多详细信息，请参阅 `AsyncHandlerInterceptor`。

`DeferredResult` 提供 `onTimeout(Runnable)` 和 `onCompletion(Runnable)` 回调。有关更多详细信息，请参阅 `DeferredResult` 的 javadoc。`Callable` 可以替代 `WebAsyncTask`，后者公开了用于超时和完成回调的其他方法。

#### 异步 Spring MVC 和 WebFlux 对比

Servlet API 最初是为通过 Filter-Servlet 链进行单次传递而构建的。异步请求处理允许应用程序退出 Filter-Servlet 链，但保留响应以供进一步处理。Spring MVC 异步支持就是围绕这个机制构建的。当控制器返回 `DeferredResult` 时，Filter-Servlet 链将退出，Servlet 容器线程将释放。稍后，当设置 `DeferredResult` 时，将进行 `ASYNC` 分发（到同一 URL），在此期间，控制器将再次映射，但不是调用它，而是使用 `DeferredResult` 值（就好像控制器返回了它一样）来恢复处理。

相比之下，Spring WebFlux 既不是基于 Servlet API 构建的，也不需要这样的异步请求处理功能，因为它在设计上是异步的。异步处理内置于所有框架合同中，并且在请求处理的所有阶段都得到了本质上的支持。

从编程模型的角度来看，Spring MVC 和 Spring WebFlux 都支持异步类型和反应类型作为控制器方法中的返回值。Spring MVC 甚至支持流式传输，包括反应式背压（reactive back pressure）。然而，对响应的单独写入仍然是阻塞的（并且在单独的线程上执行），这与 WebFlux 不同，WebFlux 依赖于非阻塞 I/O，并且每次写入不需要额外的线程。

另一个根本区别是，Spring MVC 不支持控制器方法参数中的异步或反应类型（例如，`@RequestBody`、`@RequestPart` 和其他），也不明确支持异步和反应类型作为模型属性。Spring WebFlux 确实支持所有这些。

最后，从配置的角度来看，异步请求处理功能必须在 Servlet 容器级别启用。

### 1.6.4 HTTP 流

您可以对单个异步返回值使用 `DeferredResult` 和 `Callable`。如果您想生成多个异步值并将这些值写入响应，该怎么办？本节介绍如何做到这一点。

#### 对象

您可以使用 `ResponseBodyEmitter` 返回值来生成一个对象流，其中每个对象都使用 `HttpMessageConverter` 进行序列化并写入响应，如下例所示：

```java
@GetMapping("/events")
public ResponseBodyEmitter handle() {
    ResponseBodyEmitter emitter = new ResponseBodyEmitter();
    // Save the emitter somewhere..
    return emitter;
}

// In some other thread
emitter.send("Hello once");

// and again later on
emitter.send("Hello again");

// and done at some point
emitter.complete();
```

您也可以使用 `ResponseBodyEmitter` 作为 `ResponseEntity` 中的主体，从而可以自定义响应的状态和标头。

当 `emitter` 抛出 `IOException` 时（例如，如果远程客户端离开），应用程序不负责清理连接，不应调用 `emitter.complete` 或 `emitter.commpleteWithError`。相反，servlet 容器会自动启动 `AsyncListener` 错误通知，其中 Spring MVC 会调用 `completeWithError`。这个调用反过来执行对应用程序的最后一次 `ASYNC` 分发，在此期间，Spring MVC 调用配置的异常解析器并完成请求。

#### SSE

`SseEmitter`（`ResponseBodyEmitter` 的一个子类）提供了对服务器发送事件的支持，其中从服务器发送的事件根据 W3C SSE 规范进行格式化。要从控制器生成 SSE 流，请返回 `SseEmitter`，如下例所示：

```java
@GetMapping(path="/events", produces=MediaType.TEXT_EVENT_STREAM_VALUE)
public SseEmitter handle() {
    SseEmitter emitter = new SseEmitter();
    // Save the emitter somewhere..
    return emitter;
}

// In some other thread
emitter.send("Hello once");

// and again later on
emitter.send("Hello again");

// and done at some point
emitter.complete();
```

虽然 SSE 是流式传输到浏览器的主要选项，但请注意，Internet Explorer 不支持服务器发送的事件。考虑将 Spring 的 WebSocket 消息与针对各种浏览器的 SockJS 回退传输（包括 SSE）一起使用。

有关异常处理的注意事项，请参阅上一节。

#### 原始数据

有时，绕过消息转换并直接流式传输到响应 `OutputStream` 是很有用的（例如，对于文件下载）。您可以使用 `StreamingResponseBody` 返回值类型来执行此操作，如下例所示：

```java
@GetMapping("/download")
public StreamingResponseBody handle() {
    return new StreamingResponseBody() {
        @Override
        public void writeTo(OutputStream outputStream) throws IOException {
            // write...
        }
    };
}
```

您可以使用 `StreamingResponseBody` 作为 `ResponseEntity` 中的主体来自定义响应的状态和标头。

### 1.6.5 反应式类型

Spring MVC 支持在控制器中使用反应式客户端库（也可以阅读 WebFlux 部分中的反应式库）。这包括 `spring-webflux` 中的 `WebClient` 和其他一些，如 Spring Data 反应式数据存储库。在这种情况下，能够从控制器方法返回反应式类型是很方便的。

反应式返回值处理如下：

- 类似于使用 `DeferredResult`，对单值 promise 进行了调整。示例包括 `Mono`（Reactor）或 `Single`（RxJava）。
- 类似于使用 `ResponseBodyEmitter` 或 `SseEmitter`，具有流媒体类型的多值流（如 `application/x-ndjson` 或 `text/event-stream`）适用于。示例包括 `Flux`（Reactor）或 `Observable`（RxJava）。应用程序还可以返回 `Flux<ServerSentEvent>` 或 `Observable<ServerSentEvent>`。
- 具有任何其他媒体类型（如 `application/json`）的多值流都适用于，类似于使用 `DeferredResult<List<?>>`。

> Spring MVC 通过 `spring-core` 的 `ReactiveAdapterRegistry` 支持 Reactor 和 RxJava，这使它能够从多个反应式库中进行调整。

对于流式传输到响应，支持反应式背压，但对响应的写入仍处于阻塞状态，并通过配置的 `TaskExecutor` 在单独的线程上运行，以避免阻塞上游源（如 `WebClient` 返回的 `Flux`）。默认情况下，`SimpleAsyncTaskExecutor` 用于阻塞写入，但在负载下不适用。如果您计划使用反应式类型进行流式传输，那么应该使用 MVC 配置来配置任务执行器。

### 1.6.6 上下文传播

通过 `java.lang.ThreadLocal` 传播上下文是很常见的。这对于同一线程上的处理是透明的，但对于跨多个线程的异步处理需要额外的工作。Micrometer 上下文传播库简化了线程之间以及 `ThreadLocal` 值、Reactor上下文、GraphQL Java 上下文等上下文机制之间的上下文传播。

如果类路径上存在 Micrometer 上下文传播，则当控制器方法返回响应式类型（如 `Flux` 或 `Mono`）时，所有有注册 `io.micrometer.ThreadLocalAccessor` 的 `ThreadLocal` 值都将作为键值对写入 Reactor `Context`，使用 `ThreadLocalAccessor` 分配的键。

对于其他异步处理场景，可以直接使用上下文传播库。例如：

```java
// Capture ThreadLocal values from the main thread ...
ContextSnapshot snapshot = ContextSnapshot.captureAll();

// On a different thread: restore ThreadLocal values
try (ContextSnapshot.Scope scope = snapshot.setThreadLocals()) {
    // ...
}
```

有关更多详细信息，请参阅 Micrometer 上下文传播库的文档。

### 1.6.7 断开连接

当远程客户端离开时，Servlet API 不提供任何通知。因此，在流式传输到响应时，无论是通过 SseEmitter 还是反应式类型，定期发送数据都很重要，因为如果客户端断开连接，写入就会失败。发送可以采取空（仅有注释）SSE 事件或任何其他数据的形式，对方必须将其解释为心跳并忽略这些数据。

或者，考虑使用具有内置心跳机制的 web 消息传递解决方案（如基于 WebSocket 的 STOMP 或带有 SockJS 的 WebSocket）。

### 1.6.8 配置

异步请求处理功能必须在 Servlet 容器级别启用。MVC 配置还公开了用于异步请求的几个选项。

#### Servlet 容器

Filter 和 Servlet 声明有一个 `asyncSupported` 标志，需要将其设置为 `true` 才能启用异步请求处理。此外，应该声明 Filter 映射来处理 `ASYNC` `jakarta.servlet.DispatchType`。

在 Java 配置中，当您使用 `AbstractAnnotationConfigDispatcherServlet` 初始化器初始化 Servlet 容器时，这是自动完成的。

在 `web.xml` 配置中，您可以将 `<async-supported>true</async-supported>` 添加到 `DispatcherServlet` 和 `Filter` 声明中，并将 `<dispatcher>ASYNC</dispatcher>` 添加到筛选器映射中。

#### Spring MVC

MVC 配置公开了以下与异步请求处理相关的选项：

- Java 配置：在 `WebMvcConfigurer` 上使用 `configureAsyncSupport` 回调。
- XML 命名空间：使用 `<mvc:annotation-driven>` 下的 `<async-support>` 元素。

您可以配置以下内容：

- 异步请求的默认超时值，如果没有设置，则取决于底层 Servlet 容器。
- `AsyncTaskExecutor`，用于在使用反应式类型进行流式传输时阻止写入，并用于执行从控制器方法返回的 `Callable` 实例。如果您使用反应式类型进行流式传输或具有返回 `Callable` 的控制器方法，我们强烈建议您配置此属性，因为默认情况下，它是 `SimpleAsyncTaskExecutor`。
- `DeferredResultProcessingInterceptor` 实现和 `CallableProcessingIntersector` 实现。

请注意，您还可以设置 `DeferredResult`、`ResponseBodyEmitter` 和 `SseEmitter` 的默认超时值。对于 `Callable`，您可以使用 `WebAsyncTask` 来提供超时值。

## 1.7 CORS

Spring MVC 允许您处理 CORS（跨源资源共享）。本节介绍如何做到这一点。

### 1.7.1 介绍

出于安全原因，浏览器禁止 AJAX 调用当前来源之外的资源。例如，您可以在一个选项卡中显示您的银行帐户，在另一个选项卡上显示 evil.com。来自 evil.com 的脚本应该无法使用您的凭据向您的银行 API 发出 AJAX 请求 —— 例如，从您的帐户中取款！

跨域资源共享（CORS）是由大多数浏览器实现的 W3C 规范，它允许您指定授权哪种类型的跨域请求，而不是使用基于 IFRAME 或 JSONP 的不太安全、功能不太强大的解决方案。

### 1.7.2 处理

CORS 规范区分飞行前请求（preflight）、简单请求和实际请求。要了解 CORS 是如何工作的，您可以阅读本文以及其他许多文章，或者查看规范以了解更多详细信息。

Spring MVC `HandlerMapping` 实现提供了对 CORS 的内置支持。在成功地将请求映射到处理程序之后，`HandlerMapping` 实现会检查给定请求和处理程序的 CORS 配置，并采取进一步的操作。直接处理前缀请求，而拦截、验证简单和实际的 CORS 请求，并设置所需的 CORS 响应标头。

为了启用跨源请求（也就是说，`Origin` 标头存在并且与请求的主机不同），您需要有一些明确声明的 CORS 配置。如果没有找到匹配的 CORS 配置，飞行前请求将被拒绝。简单和实际的 CORS 请求的响应中没有添加 CORS 头，因此浏览器会拒绝它们。

每个 `HandlerMapping` 都可以使用基于 URL 模式的 `CorsConfiguration` 映射进行单独配置。在大多数情况下，应用程序使用 MVC Java 配置或 XML 命名空间来声明此类映射，这会导致将单个全局映射传递给所有 `HandlerMapping` 实例。

您可以将 `HandlerMapping` 级别的全局 CORS 配置与更细粒度的、处理程序级别的 CORS 配置相结合。例如，带注解的控制器可以使用类或方法级别的 `@CrossOrigin` 注解（其他处理程序可以实现 `CorsConfigurationSource`）。

组合全局配置和局部配置的规则通常是相加的 —— 例如，所有全局和所有本地起源。对于那些只能接受单值的属性，例如 `allowCredentials` 和 `maxAge`，本地值会覆盖全局值。有关更多详细信息，请参阅 `CorsConfiguration#combine(CorsConfigoration)`。

> 要从源代码中了解更多信息或进行高级自定义，请检查后面的代码：
>
> - `CorsConfiguration`
> - `CorsProcessor`，`DefaultCorsProcessor`
> - `AbstractHandlerMapping`

### 1.7.3 @CrossOrigin

`@CrossOrigin` 注解在带注解的控制器方法上启用跨源请求，如下例所示：

```java
@RestController
@RequestMapping("/account")
public class AccountController {

    @CrossOrigin
    @GetMapping("/{id}")
    public Account retrieve(@PathVariable Long id) {
        // ...
    }

    @DeleteMapping("/{id}")
    public void remove(@PathVariable Long id) {
        // ...
    }
}
```

默认情况下，`@CrossOrigin` 允许：

- 所有的源。
- 所有标头。
- 控制器方法映射到的所有 HTTP 方法。

`allowCredentials` 默认情况下不启用，因为它建立了一个信任级别，暴露敏感的用户特定信息（如 cookie 和 CSRF 令牌），并且只应在适当的情况下使用。启用时，必须将 `allowOrigins` 设置为一个或多个特定域（但不是特殊值 `"*"`），或者可以使用 `allowOriginalPatterns` 属性来匹配一组动态的源。

`maxAge` 设置为 30 分钟。

`@CrossOrigin` 在类级别也受支持，并且由所有方法继承，如下例所示：

```java
@CrossOrigin(origins = "https://domain2.com", maxAge = 3600)
@RestController
@RequestMapping("/account")
public class AccountController {

    @GetMapping("/{id}")
    public Account retrieve(@PathVariable Long id) {
        // ...
    }

    @DeleteMapping("/{id}")
    public void remove(@PathVariable Long id) {
        // ...
    }
}
```

您可以在类级别和方法级别使用 `@CrossOrigin`，如下例所示：

```java
@CrossOrigin(maxAge = 3600)
@RestController
@RequestMapping("/account")
public class AccountController {

    @CrossOrigin("https://domain2.com")
    @GetMapping("/{id}")
    public Account retrieve(@PathVariable Long id) {
        // ...
    }

    @DeleteMapping("/{id}")
    public void remove(@PathVariable Long id) {
        // ...
    }
}
```

### 1.7.4 全局配置

除了细粒度的控制器方法级配置之外，您可能还想定义一些全局 CORS 配置。您可以在任何 `HandlerMapping` 上单独设置基于 URL 的 `CorsConfiguration` 映射。然而，大多数应用程序都使用 MVC Java 配置或 MVC XML 命名空间来实现这一点。

默认情况下，全局配置启用以下功能：

- 所有的源。
- 所有标头。
- GET、HEAD 和 POST 方法。

`allowCredentials` 默认情况下不启用，因为它建立了一个信任级别，暴露敏感的用户特定信息（如 cookie 和 CSRF 令牌），并且只应在适当的情况下使用。启用时，必须将 `allowOrigins` 设置为一个或多个特定域（但不是特殊值 `"*"`），或者可以使用 `allowOriginalPatterns` 属性来匹配一组动态的原点。

`maxAge` 设置为 30 分钟。

#### Java 配置

要在 MVC Java 配置中启用 CORS，可以使用 `CorsRegistry` 回调，如下例所示：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {

        registry.addMapping("/api/**")
            .allowedOrigins("https://domain2.com")
            .allowedMethods("PUT", "DELETE")
            .allowedHeaders("header1", "header2", "header3")
            .exposedHeaders("header1", "header2")
            .allowCredentials(true).maxAge(3600);

        // Add more mappings...
    }
}
```

#### XML 配置

要在XML命名空间中启用CORS，可以使用 `<mvc:cors>` 元素，如下例所示：

```xml
<mvc:cors>

    <mvc:mapping path="/api/**"
        allowed-origins="https://domain1.com, https://domain2.com"
        allowed-methods="GET, PUT"
        allowed-headers="header1, header2, header3"
        exposed-headers="header1, header2" allow-credentials="true"
        max-age="123" />

    <mvc:mapping path="/resources/**"
        allowed-origins="https://domain1.com" />

</mvc:cors>
```

### 1.7.5 CORS 过滤器

您可以通过内置的 `CorsFilter` 应用 CORS 支持。

> 如果您尝试将 `CorsFilter` 与 Spring Security 一起使用，请记住 Spring Security 内置了对 CORS 的支持。

要配置筛选器，请将 `CorsConfigurationSource` 传递给其构造函数，如下例所示：

```java
CorsConfiguration config = new CorsConfiguration();

// Possibly...
// config.applyPermitDefaultValues()

config.setAllowCredentials(true);
config.addAllowedOrigin("https://domain1.com");
config.addAllowedHeader("*");
config.addAllowedMethod("*");

UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
source.registerCorsConfiguration("/**", config);

CorsFilter filter = new CorsFilter(source);
```

## 1.8 错误响应

REST 服务的一个常见要求是在错误响应的主体中包含详细信息。Spring 框架支持“HTTP API 的问题详细信息”规范 RFC 7807。

以下是此支持的主要抽象：

- `ProblemDetail` — RFC 7807 问题细节的表示；一个简单的容器，用于规范中定义的标准字段和非标准字段。
- `ErrorResponse` — 公开 HTTP 错误响应详细信息的合同，包括 HTTP 状态、响应头和RFC 7807 格式的主体；这允许异常封装并公开它们如何映射到 HTTP 响应的详细信息。所有 Spring MVC 异常都实现了这一点。
- `ErrorResponseException` — 基本的 `ErrorResponse` 实现，其他人可以将其用作方便的基类。
- `ResponseEntityExceptionHandler` — 用于 @ControllerAdvice 的方便基类，该基类处理所有 Spring MVC 异常和任何 `ErrorResponseException`，并用返回体呈现错误响应。

### 1.8.1 渲染器

您可以从任何 `@ExceptionHandler` 或任何 `@RequestMapping` 方法返回 `ProblemDetail` 或 `ErrorResponse` 以呈现 RFC 7807 响应。处理方式如下：

- `ProblemDetail` 的 `status` 属性决定 HTTP 状态。
- `ProbemDetail` 的 `instance` 属性是根据当前 URL 路径设置的（如果尚未设置的话）。
- 对于内容协商，Jackson `HttpMessageConverter` 在呈现 `ProblemDetail` 时更喜欢 “application/problem+json” 而不是 “application/json”，如果找不到兼容的媒体类型，也会使用它。

要为 Spring WebFlux 异常和任何 `ErrorResponseException` 启用RFC 7807响应，请扩展 `ResponseEntityExceptionHandler` 并在 Spring 配置中将其声明为 @ControllerAdvice。该处理程序有一个 `@ExceptionHandler` 方法，用于处理任何 `ErrorResponse` 异常，其中包括所有内置的 web 异常。您可以添加更多的异常处理方法，并使用受保护的方法将任何异常映射到 `ProbemDetail`。

### 1.8.2 非标准字段

您可以通过以下两种方式之一使用非标准字段扩展 RFC 7807 响应。

第一，插入 `ProblemDetail` 的“属性” `Map`。使用 Jackson 库时，Spring Framework 会注册 `ProblemDetailJacksonMixin`，以确保此“属性” `Map` 在响应中展开并呈现为顶级 JSON 属性，同样，反序列化期间的任何未知属性都会插入此映射。

您还可以扩展 `ProblemDetail` 以添加专用的非标准属性。`ProblemDetail` 中的复制构造函数允许一个子类，使其可以很容易地从现有的 `ProblemDetail` 中创建。这可以集中完成，例如通过 `@ControllerAdvice`（如 `ResponseEntityExceptionHandler`）将异常的 `ProblemDetail` 重新创建到具有额外非标准字段的子类中。

### 1.8.3 国际化

国际化错误响应详细信息是一种常见的要求，为 Spring MVC 异常定制问题详细信息也是一种良好的实践。支持的方式如下：

- 每个 `ErrorResponse` 公开一个消息代码和参数，以通过 MessageSource 解析 “detail” 字段。实际的消息代码值是用占位符参数化的，例如要从参数中展开的 `"HTTP method {0} not supported"`。
- 每个 `ErrorResponse` 还公开一个消息代码来解析 “title” 字段。
- `ResponseEntityExceptionHandler` 使用消息代码和参数来解析 “detail” 和 “title” 字段。

默认情况下，“detail” 字段的消息代码为 “problemDetail” + 完全限定的异常类名。某些异常可能会暴露额外的消息代码，在这种情况下，会在默认消息代码中添加后缀。下表列出了 Spring MVC 异常的消息参数和代码：

| 异常                                          | 消息码                 | 消息码参数                                                   |
| :-------------------------------------------- | :--------------------- | :----------------------------------------------------------- |
| `AsyncRequestTimeoutException`                | (默认)                 |                                                              |
| `ConversionNotSupportedException`             | (默认)                 | `{0}` 属性名, `{1}` 属性值                                   |
| `HttpMediaTypeNotAcceptableException`         | (默认)                 | `{0}` 支持的媒体类型的队列                                   |
| `HttpMediaTypeNotAcceptableException`         | (默认) + ".parseError" |                                                              |
| `HttpMediaTypeNotSupportedException`          | (默认)                 | `{0}` 不支持的媒体类型, `{1}` 支持的媒体类型                 |
| `HttpMediaTypeNotSupportedException`          | (默认) + ".parseError" |                                                              |
| `HttpMessageNotReadableException`             | (默认)                 |                                                              |
| `HttpMessageNotWritableException`             | (默认)                 |                                                              |
| `HttpRequestMethodNotSupportedException`      | (默认)                 | `{0}` 当前 HTTP 方法, `{1}` 支持的 HTTP 方法的队列           |
| `MethodArgumentNotValidException`             | (默认)                 | `{0}` 全局错误的队列, `{1}` 字段错误的队列。`BindingResult` 中每个错误的消息代码和参数也通过 `MessageSource` 解析。 |
| `MissingRequestHeaderException`               | (默认)                 | `{0}` 请求头名                                               |
| `MissingServletRequestParameterException`     | (默认)                 | `{0}` 请求参数名                                             |
| `MissingMatrixVariableException`              | (默认)                 | `{0}` 矩阵变量名                                             |
| `MissingPathVariableException`                | (默认)                 | `{0}` 路径变量名                                             |
| `MissingRequestCookieException`               | (默认)                 | `{0}` cookie 名                                              |
| `MissingServletRequestPartException`          | (默认)                 | `{0}` part 名                                                |
| `NoHandlerFoundException`                     | (默认)                 |                                                              |
| `TypeMismatchException`                       | (默认)                 | `{0}` 属性名, `{1}` 属性值                                   |
| `UnsatisfiedServletRequestParameterException` | (默认)                 | `{0}` 参数条件队列                                           |

默认情况下，“title” 字段的消息代码为 “problemDetail.title.” + 完全限定的异常类名。

### 1.8.4 客户端处理

客户端应用程序可以在使用 `WebClient` 时捕获 `WebClientResponseException`，或在使用 `RestTemplate` 时捕获 `RestClientResponceException`，并使用它们的 `getResponseBodyAs` 方法将错误响应主体解码为任何目标类型，如 `ProblemDetail` 或 `ProblemDetail` 的子类。

## 1.9 Web 安全

Spring Security 项目为保护 web 应用程序免受恶意攻击提供了支持。请参阅 Spring Security 参考文档，包括：

- Spring MVC 安全性
- Spring MVC 测试支持
- CSRF 保护
- 安全响应标头

HDIV 是另一个与 Spring MVC 集成的 web 安全框架。

## 1.10 HTTP 缓存

HTTP 缓存可以显著提高 web 应用程序的性能。HTTP 缓存围绕着 `Cache-Control` 响应标头，然后是条件请求标头（如 `Last-Modified` 和 `ETag`）。`Cache-Control` 建议私有（例如浏览器）和公共（例如代理）缓存如何缓存和重用响应。`ETag` 报头用于进行条件请求，如果内容没有改变，则可能导致 304（NOT_MODIFIED）而没有正文。`ETag` 可以被视为 `Last-Modified` 标头的更复杂的继承者。

本节描述了 Spring Web MVC 中可用的 HTTP 缓存相关选项。

### 1.10.1 CacheControl

`CacheControl` 支持配置与 `Cache-Control` 标头相关的设置，并在许多地方被接受为参数：

- [`WebContentInterceptor`](https://docs.spring.io/spring-framework/docs/6.0.7/javadoc-api/org/springframework/web/servlet/mvc/WebContentInterceptor.html)
- [`WebContentGenerator`](https://docs.spring.io/spring-framework/docs/6.0.7/javadoc-api/org/springframework/web/servlet/support/WebContentGenerator.html)
- 控制器
- 静态资源

虽然 RFC 7234 描述了 `Cache-Control` 响应标头的所有可能指令，但 `CacheControl` 类型采用了面向用例的方法，重点关注常见场景：

```java
// Cache for an hour - "Cache-Control: max-age=3600"
CacheControl ccCacheOneHour = CacheControl.maxAge(1, TimeUnit.HOURS);

// Prevent caching - "Cache-Control: no-store"
CacheControl ccNoStore = CacheControl.noStore();

// Cache for ten days in public and private caches,
// public caches should not transform the response
// "Cache-Control: max-age=864000, public, no-transform"
CacheControl ccCustom = CacheControl.maxAge(10, TimeUnit.DAYS).noTransform().cachePublic();
```

`WebContentGenerator` 还接受一个更简单的 `cachePeriod` 属性（以秒为单位定义），其工作原理如下：

- `-1` 值不会生成 `Cache-Control` 响应标头。
- `0` 值通过使用 `'Cache-Control: no-store'` 指令来阻止缓存。
- `n>0` 的值通过使用 `'Cache-Control: max-age=n'` 指令将给定响应缓存 `n` 秒。

### 1.10.2 控制器

控制器可以添加对 HTTP 缓存的明确支持。我们建议这样做，因为在将资源的`lastModified` 或 `ETag` 值与条件请求头进行比较之前，需要计算该值。控制器可以将 `ETag` 标头和 `Cache-Control` 设置添加到 `ResponseEntity`，如下例所示：

```java
@GetMapping("/book/{id}")
public ResponseEntity<Book> showBook(@PathVariable Long id) {

    Book book = findBook(id);
    String version = book.getVersion();

    return ResponseEntity
            .ok()
            .cacheControl(CacheControl.maxAge(30, TimeUnit.DAYS))
            .eTag(version) // lastModified is also available
            .body(book);
}
```

如果与条件请求报头的比较表明内容没有改变，则前面的示例发送具有空正文的 304（NOT_MODIFIED）响应。否则，`ETag` 和 `Cache-Control` 标头将添加到响应中。

您也可以对照控制器中的条件请求标头进行检查，如下例所示：

```java
@RequestMapping
public String myHandleMethod(WebRequest request, Model model) {

    long eTag = ... (1)

    if (request.checkNotModified(eTag)) {
        return null; (2)
    }

    model.addAttribute(...); (3)
    return "myViewName";
}

// (1) 特定于应用程序的计算。
// (2) 响应已设置为304（NOT_MODIFIED）—— 无需进一步处理。
// (3) 继续处理请求。
```

有三种变体用于根据 `eTag` 值、`lastModified` 值或两者来检查条件请求。对于条件 `GET` 和 `HEAD` 请求，可以将响应设置为 304（NOT_MODIFIED）。对于条件 `POST`、`PUT` 和 `DELETE`，您可以将响应设置为 412（PRECONDITION_FAILED），以防止并发修改。

### 1.10.3 静态资源

您应该为静态资源提供 `Cache-Control` 和条件响应标头，以获得最佳性能。请参阅关于配置静态资源的部分。

### 1.10.4 ETag 过滤器

您可以使用 `ShallowEtagHeaderFilter` 添加根据响应内容计算的“浅” `eTag` 值，从而节省带宽，但不节省 CPU 时间。参见浅 ETag。

## 1.11 视图技术

Spring MVC 中视图技术的使用是可插入的。您是否决定使用 Thymelaf、Groovy 标记模板、JSP 或其他技术主要取决于配置更改。本章介绍了与 Spring MVC 集成的视图技术。我们假设您已经熟悉“视图解析”。

> Spring MVC 应用程序的视图位于该应用程序的内部信任边界内。视图可以访问应用程序上下文的所有 bean。因此，不建议在模板可由外部源编辑的应用程序中使用 Spring MVC 的模板支持，因为这可能会带来安全隐患。

### 1.11.1 Thymeleaf

Thymeleaf 是一个现代的服务器端 Java 模板引擎，它强调可以通过双击在浏览器中预览的自然 HTML 模板，这对于在不需要运行服务器的情况下独立处理 UI 模板（例如，由设计师）非常有帮助。如果您想取代 JSP，Thymeleaf 提供了一组最广泛的功能，使这种转换更容易。Thymeleaf 被积极开发和维护。有关更完整的介绍，请参阅 Thymeleaf 项目主页。

Thymeleaf 与 Spring MVC 的集成由 Thymeleaf 项目管理。该配置涉及一些 bean 声明，如 `ServletContextTemplateResolver`、`SpringTemplateEngine` 和 `ThymelafViewResolver`。有关更多详细信息，请参阅 “Thymeleaf + Spring”。

### 1.11.2 FreeMarker

Apache FreeMarker 是一个模板引擎，用于生成从 HTML 到电子邮件等任何类型的文本输出。Spring 框架具有内置集成，用于将 Spring MVC 与 FreeMarker 模板结合使用。

#### 视图配置

以下示例显示了如何将 FreeMarker 配置为视图技术：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.freeMarker();
    }

    // Configure FreeMarker...

    @Bean
    public FreeMarkerConfigurer freeMarkerConfigurer() {
        FreeMarkerConfigurer configurer = new FreeMarkerConfigurer();
        configurer.setTemplateLoaderPath("/WEB-INF/freemarker");
        return configurer;
    }
}
```

以下示例显示了如何在 XML 中配置相同的内容：

```xml
<mvc:annotation-driven/>

<mvc:view-resolvers>
    <mvc:freemarker/>
</mvc:view-resolvers>

<!-- Configure FreeMarker... -->
<mvc:freemarker-configurer>
    <mvc:template-loader-path location="/WEB-INF/freemarker"/>
</mvc:freemarker-configurer>
```

或者，您也可以声明 `FreeMarkerConfigurer` bean 以完全控制所有属性，如下例所示：

```xml
<bean id="freemarkerConfig" class="org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer">
    <property name="templateLoaderPath" value="/WEB-INF/freemarker/"/>
</bean>
```

您的模板需要存储在前面示例中显示的 `FreeMarkerConfigurer` 指定的目录中。给定前面的配置，如果您的控制器返回一个 `welcome` 的视图名称，那么解析器会查找 `/WEB-INF/freemarker/welcome.ftl` 模板。

#### FreeMarker 配置

您可以通过在 `FreeMarkerConfigurer` bean 上设置适当的 bean 属性，将FreeMarker “Settings” 和 “SharedVariables” 直接传递给 FreeMarkers `Configuration` 对象（由 Spring 管理）。`freemarkerSettings` 属性需要 `java.util.Properties` 对象，而 `freemarkerVariables` 属性需要 `java.util.Map`。以下示例显示了如何使用 `FreeMarkerConfiguration`：

```xml
<bean id="freemarkerConfig" class="org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer">
    <property name="templateLoaderPath" value="/WEB-INF/freemarker/"/>
    <property name="freemarkerVariables">
        <map>
            <entry key="xml_escape" value-ref="fmXmlEscape"/>
        </map>
    </property>
</bean>

<bean id="fmXmlEscape" class="freemarker.template.utility.XmlEscape"/>
```

有关应用于 `Configuration` 对象的设置和变量的详细信息，请参阅 FreeMarker 文档。

#### 表格处理

Spring 提供了一个在 JSP 中使用的标记库，其中包含一个 `<spring:bind/>` 元素。此元素主要允许表单显示表单支持对象的值，并显示 web 或业务层 `Validator` 验证失败的结果。Spring 还支持 FreeMarker 中的相同功能，并提供了额外的方便宏来生成表单输入元素。

##### 绑定宏

FreeMarker 的 `spring-webmvc.jar` 文件中维护了一组标准的宏，因此它们始终可用于适当配置的应用程序。
Spring 模板库中定义的一些宏被认为是内部的（私有的），但宏定义中不存在这样的作用域，这使得调用代码和用户模板可以看到所有宏。以下部分仅集中介绍需要从模板中直接调用的宏。如果您想直接查看宏代码，该文件名为 `spring.ftl`，位于 `org.springframework.web.servlet.view.freemarker` 包中。

##### 简单绑定

在基于 FreeMarker 模板的 HTML 表单中，作为 Spring MVC 控制器的表单视图，您可以使用类似于下一个示例的代码绑定到字段值，并以类似于 JSP 的方式显示每个输入字段的错误消息。以下示例显示了一个 `personForm` 视图：

```xml
<!-- FreeMarker macros have to be imported into a namespace.
    We strongly recommend sticking to 'spring'. -->
<#import "/spring.ftl" as spring/>
<html>
    ...
    <form action="" method="POST">
        Name:
        <@spring.bind "personForm.name"/>
        <input type="text"
            name="${spring.status.expression}"
            value="${spring.status.value?html}"/><br />
        <#list spring.status.errorMessages as error> <b>${error}</b> <br /> </#list>
        <br />
        ...
        <input type="submit" value="submit"/>
    </form>
    ...
</html>
```

`<@spring.bind>` 需要一个 “path” 参数，该参数由命令对象的名称（除非您在控制器配置中更改了它，否则它是 “command”）、句点和要绑定的命令对象上的字段名称组成。您也可以使用嵌套字段，如 `command.address.street`。`bind` 宏采用 `web.xml` 中 `ServletContext` 参数 `defaultHtmlEscape` 指定的默认 HTML 转义行为。

名为 `<@spring.bindEscaped>` 的宏的另一种形式采用第二个参数，该参数明确指定是否应在状态错误消息或值中使用 HTML 转义。您可以根据需要将其设置为 `true` 或 `false`。附加的表单处理宏简化了 HTML 转义的使用，您应该尽可能使用这些宏。它们将在下一节中进行解释。

##### 输入宏

FreeMarker 的附加便利宏简化了绑定和表单生成（包括验证错误显示）。从来没有必要使用这些宏来生成表单输入字段，您可以将它们与简单的 HTML 或直接调用我们之前强调的 Spring 绑定宏进行混合和匹配。

可用宏的下表显示了 FreeMarker 模板（FTL）定义和每个定义的参数列表：

| 宏                                                           | FTL 定义                                                     |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `message` (基于代码参数从资源捆绑包输出字符串)               | <@spring.message code/>                                      |
| `messageText` (根据代码参数从资源束中输出一个字符串，返回到默认参数的值) | <@spring.messageText code, text/>                            |
| `url` (在相对 URL 前面加上应用程序的上下文根)                | <@spring.url relativeUrl/>                                   |
| `formInput` (用于收集用户输入的标准输入字段)                 | <@spring.formInput path, attributes, fieldType/>             |
| `formHiddenInput` (用于提交非用户输入的隐藏输入字段)         | <@spring.formHiddenInput path, attributes/>                  |
| `formPasswordInput` (用于收集密码的标准输入字段。请注意，在这种类型的字段中永远不会填充任何值。) | <@spring.formPasswordInput path, attributes/>                |
| `formTextarea` (用于收集长的自由形式文本输入的大文本字段)    | <@spring.formTextarea path, attributes/>                     |
| `formSingleSelect` (用于选择单个必需值的选项下拉框)          | <@spring.formSingleSelect path, options, attributes/>        |
| `formMultiSelect` (选项列表框，允许用户选择 0 个或多个值)    | <@spring.formMultiSelect path, options, attributes/>         |
| `formRadioButtons` (一组单选按钮，用于从可用选项中进行单个选择) | <@spring.formRadioButtons path, options separator, attributes/> |
| `formCheckboxes` (允许选择 0 个或多个值的一组复选框)         | <@spring.formCheckboxes path, options, separator, attributes/> |
| `formCheckbox` (单个复选框)                                  | <@spring.formCheckbox path, attributes/>                     |
| `showErrors` (简化绑定字段的验证错误显示)                    | <@spring.showErrors separator, classOrStyle/>                |

> 在 FreeMarker 模板中，实际上不需要 `formHiddenInput` 和 `formPasswordInput`，因为您可以使用普通的 `formInput` 宏，指定隐藏或密码作为 `fieldType` 参数的值。

上述任何宏的参数具有一致的含义：

- `path`：要绑定到的字段的名称（例如，“command.name”）
- `options`：可以在输入字段中选择的所有可用值的 `Map`。映射的键表示从表单 已 POST 返回并绑定到命令对象的值。根据键存储的地图对象是显示在表单上给用户的标签，可能与表单返回的相应值不同。通常，控制器会提供这样的地图作为参考数据。您可以使用任何 `Map` 实现，具体取决于所需的行为。对于严格排序的映射，您可以使用带有合适 `Comparator` 的 `SortedMap`（如 `TreeMap`），对于应按插入顺序返回值的任意映射，可以使用 `commons-colections` 中的 `LinkedHashMap` 或 `LinkedMap`。
- `seperator`：当多个选项作为离散元素（单选按钮或复选框）可用时，用于分隔列表中每个选项的字符序列（如 `<br>`）。
- `attributes`: 要包含在 HTML 标记本身中的任意标记或文本的附加字符串。这个字符串是由宏直接回显的。例如，在 `textarea` 字段中，您可以提供属性（如 'rows="5" cols="60"'），也可以传递样式信息，如 'style="border:1px solid silver"'。
- `classOrStyle`：对于 `showErrors` 宏，包装每个错误的 `span` 元素使用的 CSS 类的名称。如果未提供任何信息（或值为空），则错误将封装在 `<b></b>` 标记中。

以下部分概述了宏的示例。

**输入字段**

`formInput` 宏采用 `path` 参数（`command.name`）和一个附加的 `attributes` 参数（在接下来的示例中为空）。该宏与所有其他表单生成宏一起，对路径参数执行隐式 Spring 绑定。绑定在发生新的绑定之前一直有效，因此 `showErrors` 宏不需要再次传递路径参数 — 它对上次为其创建绑定的字段进行操作。

`showErrors` 宏接受一个分隔符参数（用于分隔给定字段上的多个错误的字符），还接受第二个参数 — 这次是类名或样式属性。请注意，FreeMarker 可以为属性参数指定默认值。以下示例显示了如何使用 `formInput` 和 `showErrors` 宏：

```xml
<@spring.formInput "command.name"/>
<@spring.showErrors "<br>"/>
```

下一个示例显示表单片段的输出，生成名称字段，并在表单提交后显示验证错误，但字段中没有值。验证通过 Spring 的验证框架进行。

生成的 HTML 类似于以下示例：

```jsp
Name:
<input type="text" name="name" value="">
<br>
    <b>required</b>
<br>
<br>
```

`formTextarea` 宏的工作方式与 `formInput` 宏相同，并且接受相同的参数列表。通常，第二个参数（`attributes`）用于传递 `textarea` 的样式信息或 `rows` 和 `cols` 属性。

**选择字段**

您可以使用四个选择字段宏在 HTML 表单中生成常见的 UI 值选择输入：

- `formSingleSelect`
- `formMultiSelect`
- `formRadioButtons`
- `formCheckboxes`

四个宏中的每一个都接受一个选项 `Map`，该映射包含表单字段的值和与该值对应的标签。值和标签可以相同。

下一个例子是 FTL 中的单选按钮。表单支持对象为此字段指定了默认值 “London”，因此不需要验证。当呈现表单时，可供选择的整个城市列表将作为模型中的参考数据以 “cityMap” 的名称提供。以下列表显示了示例：

```jsp
...
Town:
<@spring.formRadioButtons "command.address.town", cityMap, ""/><br><br>
```

上面的列表呈现了一行单选按钮，`cityMap` 中的每个值对应一个单选按钮，并使用分隔符 `""`。没有提供其他属性（宏的最后一个参数丢失）。`cityMap` 对映射中的每个键值对使用相同的 `String`。映射的键是表单实际提交的 `POST` 请求参数。贴图值是用户看到的标签。在前面的示例中，给定三个著名城市的列表和表单支持对象中的默认值，HTML 类似于以下内容：

```jsp
Town:
<input type="radio" name="address.town" value="London">London</input>
<input type="radio" name="address.town" value="Paris" checked="checked">Paris</input>
<input type="radio" name="address.town" value="New York">New York</input>
```

如果您的应用程序希望通过内部代码处理城市（例如），您可以使用合适的键创建代码地图，如下例所示：

```java
protected Map<String, ?> referenceData(HttpServletRequest request) throws Exception {
    Map<String, String> cityMap = new LinkedHashMap<>();
    cityMap.put("LDN", "London");
    cityMap.put("PRS", "Paris");
    cityMap.put("NYC", "New York");

    Map<String, Object> model = new HashMap<>();
    model.put("cityMap", cityMap);
    return model;
}
```

代码现在生成输出，其中无线电值为相关代码，但用户仍然可以看到更用户友好的城市名称，如下所示：

```jsp
Town:
<input type="radio" name="address.town" value="LDN">London</input>
<input type="radio" name="address.town" value="PRS" checked="checked">Paris</input>
<input type="radio" name="address.town" value="NYC">New York</input>
```

##### HTML 转义

前面描述的表单宏的默认使用导致 HTML 元素符合 HTML 4.01，并且使用在 `web.xml` 文件中定义的 HTML 转义的默认值，正如 Spring 的绑定支持所使用的那样。为了使元素符合 XHTML 或覆盖默认的 HTML 转义值，您可以在模板中指定两个变量（或在模型中，它们对模板可见）。在模板中指定它们的优点是，可以在稍后的模板处理中将它们更改为不同的值，从而为表单中的不同字段提供不同的行为。

要为标记切换到 XHTML 兼容，请为名为 `xhtmlCompliant` 的模型或上下文变量指定 `true` 值，如下例所示：

```jsp
<#-- for FreeMarker -->
<#assign xhtmlCompliant = true>
```

处理完这个指令后，Spring 宏生成的任何元素现在都是 XHTML 兼容的。

以类似的方式，您可以为每个字段指定 HTML 转义，如下例所示：

```jsp
<#-- until this point, default HTML escaping is used -->

<#assign htmlEscape = true>
<#-- next field will use HTML escaping -->
<@spring.formInput "command.name"/>

<#assign htmlEscape = false in spring>
<#-- all future fields will be bound with HTML escaping off -->
```

### 1.11.3 Groovy 标记

Groovy 标记模板引擎主要用于生成类似 XML 的标记（XML、XHTML、HTML5 和其他），但您可以使用它来生成任何基于文本的内容。Spring 框架有一个内置的集成，用于将 Spring MVC 与 Groovy 标记结合使用。

> Groovy 标记模板引擎需要 Groovy 2.3.1+。

#### 配置

以下示例显示了如何配置 Groovy 标记模板引擎：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.groovy();
    }

    // Configure the Groovy Markup Template Engine...

    @Bean
    public GroovyMarkupConfigurer groovyMarkupConfigurer() {
        GroovyMarkupConfigurer configurer = new GroovyMarkupConfigurer();
        configurer.setResourceLoaderPath("/WEB-INF/");
        return configurer;
    }
}
```

以下示例显示了如何在 XML 中配置相同的内容：

```xml
<mvc:annotation-driven/>

<mvc:view-resolvers>
    <mvc:groovy/>
</mvc:view-resolvers>

<!-- Configure the Groovy Markup Template Engine... -->
<mvc:groovy-configurer resource-loader-path="/WEB-INF/"/>
```

#### 例子

与传统的模板引擎不同，Groovy Markup 依赖于使用生成器语法的 DSL。以下示例显示了 HTML 页面的示例模板：

```groovy
yieldUnescaped '<!DOCTYPE html>'
html(lang:'en') {
    head {
        meta('http-equiv':'"Content-Type" content="text/html; charset=utf-8"')
        title('My page')
    }
    body {
        p('This is an example of HTML contents')
    }
}
```

### 1.11.4 脚本视图

Spring Framework 有一个内置的集成，可以将 Spring MVC 与任何可以在 JSR-223 Java 脚本引擎上运行的模板库一起使用。我们在不同的脚本引擎上测试了以下模板库：

| 脚本库                                                       | 脚本引擎                                              |
| :----------------------------------------------------------- | :---------------------------------------------------- |
| [Handlebars](https://handlebarsjs.com/)                      | [Nashorn](https://openjdk.java.net/projects/nashorn/) |
| [Mustache](https://mustache.github.io/)                      | [Nashorn](https://openjdk.java.net/projects/nashorn/) |
| [React](https://facebook.github.io/react/)                   | [Nashorn](https://openjdk.java.net/projects/nashorn/) |
| [EJS](https://www.embeddedjs.com/)                           | [Nashorn](https://openjdk.java.net/projects/nashorn/) |
| [ERB](https://www.stuartellis.name/articles/erb/)            | [JRuby](https://www.jruby.org/)                       |
| [String templates](https://docs.python.org/2/library/string.html#template-strings) | [Jython](https://www.jython.org/)                     |
| [Kotlin Script templating](https://github.com/sdeleuze/kotlin-script-templating) | [Kotlin](https://kotlinlang.org/)                     |

> 集成任何其他脚本引擎的基本规则是，它必须实现 `ScriptEngine` 和 `Invocable` 接口。

#### 必需要求

您需要在类路径上有脚本引擎，其细节因脚本引擎而异：

- Nashorn JavaScript 引擎是由 Java 8+ 提供的。强烈建议使用可用的最新更新版本。
- 应该添加 JRuby 作为 Ruby 支持的依赖项。
- Jython 应该作为 Python 支持的依赖项添加。
- `org.jetbrains.kotlin:kotlin-script-util` 依赖项和一个 `META-INF/services/javax.script.ScriptEngineFactory` 文件，该文件包含一个 `org.jetbrans.kotlin.script.jsr223.KotlinJsr223JvmLocalScriptEngineFactory` 行，以支持 Kotlin 脚本。有关更多详细信息，请参见此示例。

您需要有脚本模板库。JavaScript 实现这一点的一种方法是通过 WebJars。

#### 脚本模板

您可以声明 `ScriptTemplateConfigurer` bean 来指定要使用的脚本引擎、要加载的脚本文件、调用什么函数来渲染模板等等。以下示例使用 Mustache 模板和 Nashorn JavaScript 引擎：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.scriptTemplate();
    }

    @Bean
    public ScriptTemplateConfigurer configurer() {
        ScriptTemplateConfigurer configurer = new ScriptTemplateConfigurer();
        configurer.setEngineName("nashorn");
        configurer.setScripts("mustache.js");
        configurer.setRenderObject("Mustache");
        configurer.setRenderFunction("render");
        return configurer;
    }
}
```

以下示例在 XML 中显示了相同的排列方式：

```xml
<mvc:annotation-driven/>

<mvc:view-resolvers>
    <mvc:script-template/>
</mvc:view-resolvers>

<mvc:script-template-configurer engine-name="nashorn" render-object="Mustache" render-function="render">
    <mvc:script location="mustache.js"/>
</mvc:script-template-configurer>
```

对于 Java 和 XML 配置，控制器看起来没有什么不同，如下例所示：

```java
@Controller
public class SampleController {

    @GetMapping("/sample")
    public String test(Model model) {
        model.addAttribute("title", "Sample title");
        model.addAttribute("body", "Sample body");
        return "template";
    }
}
```

以下示例显示 Mustache 模板：

```html
<html>
    <head>
        <title>{{title}}</title>
    </head>
    <body>
        <p>{{body}}</p>
    </body>
</html>
```

使用以下参数调用渲染函数：

- `String template`：模板内容
- `Map model`：视图模型
- `RenderingContext renderingContext`：提供对应用程序上下文、区域设置、模板加载程序和 URL 的访问的 `RenderingContext`（自 5.0 起）

`Mustache.render()` 与此签名在本机上是兼容的，因此您可以直接调用它。

如果模板技术需要一些自定义，则可以提供一个实现自定义渲染函数的脚本。例如，Handlerbars 在使用模板之前需要编译模板，并且需要 polyfill 来模拟服务器端脚本引擎中不可用的一些浏览器功能。

以下示例显示了如何执行此操作：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.scriptTemplate();
    }

    @Bean
    public ScriptTemplateConfigurer configurer() {
        ScriptTemplateConfigurer configurer = new ScriptTemplateConfigurer();
        configurer.setEngineName("nashorn");
        configurer.setScripts("polyfill.js", "handlebars.js", "render.js");
        configurer.setRenderFunction("render");
        configurer.setSharedEngine(false);
        return configurer;
    }
}
```

> 当使用非线程安全脚本引擎和非为并发设计的模板库时，需要将 `sharedEngine` 属性设置为 `false`，例如在 Nashorn 上运行的 Handlebars 或 React。在这种情况下，由于这个错误，需要 Java SE 8 更新 60，但通常建议在任何情况下使用最新的 Java SE 补丁版本。

`polyfill.js` 只定义 Handlebars 正确运行所需的 `windows` 对象，如下所示：

```javascript
var window = {};
```

这个基本的 `render.js` 实现在使用模板之前对其进行编译。生产就绪的实现还应该存储任何重用的缓存模板或预编译模板。您可以在脚本端执行此操作（并处理您需要的任何自定义 —— 管理模板引擎配置）。以下示例显示了如何执行此操作：

```javascript
function render(template, model) {
    var compiledTemplate = Handlebars.compile(template);
    return compiledTemplate(model);
}
```

查看 Spring Framework 单元测试、Java 和参考资料，了解更多配置示例。

### 1.11.5 JSP 和 JSTL

Spring 框架有一个内置的集成，用于将 Spring MVC 与 JSP 和 JSTL 结合使用。

#### 视图解析器

使用 JSP 进行开发时，通常会声明一个 `InternalResourceViewResolver` bean。

`InternalResourceViewResolver` 可以用于调度到任何 Servlet 资源，但特别是 JSP。作为最佳实践，我们强烈建议将 JSP 文件放在 `'WEB-INF'` 目录下的目录中，这样客户端就不能直接访问。

```xml
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
    <property name="prefix" value="/WEB-INF/jsp/"/>
    <property name="suffix" value=".jsp"/>
</bean>
```

####  JSPs 对阵 JSTL

当使用 JSP 标准标记库（JSTL）时，您必须使用一个特殊的视图类 `JstlView`，因为 JSTL 在 I18N 特性等功能工作之前需要做一些准备。

#### Spring 的 JSP 标签库

Spring 提供了请求参数到命令对象的数据绑定，如前几章所述。为了方便结合这些数据绑定功能开发 JSP 页面，Spring 提供了一些标记，使事情变得更加容易。所有Spring 标记都具有 HTML 转义功能，可以启用或禁用字符转义。

`spring.tld` 标记库描述符（tld）包含在 `spring-webmvc.jar` 中。有关单个标记的全面参考，请浏览 API 参考或查看标记库描述。

#### Spring 的表格标签库

从 2.0 版开始，Spring 提供了一组全面的数据绑定感知标记，用于在使用 JSP 和 Spring Web MVC 时处理表单元素。每个标记都提供了对其对应 HTML 标记的一组属性的支持，使标记变得熟悉和直观。标记生成的 HTML 与 HTML 4.01/XHTML 1.0 兼容。

与其他表单/输入标记库不同，Spring 的表单标记库与 Spring Web MVC 集成，使标记可以访问控制器处理的命令对象和引用数据。正如我们在以下示例中所展示的，表单标记使 JSP 更易于开发、读取和维护。

我们浏览表单标签，并查看如何使用每个标签的示例。我们已经包含了生成的 HTML 片段，其中某些标记需要进一步的注释。

##### 配置

表单标记库捆绑在 `spring-webmvc.jar` 中。库描述符称为 `spring-form.tld`。

要使用此库中的标记，请将以下指令添加到 JSP 页面的顶部：

```xml
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
```

其中，`form` 是要用于此库中标记的标记名前缀。

##### 表格标签

此标记呈现 HTML “form” 元素，并向内部标记公开绑定路径以进行绑定。它将命令对象放在 `PageContext` 中，以便内部标记可以访问命令对象。此库中的所有其他标记都是表单标记的嵌套标记。

假设我们有一个名为 `User` 的域对象。它是一个具有 `firstName` 和 `lastName` 等属性的 JavaBean。我们可以将其用作表单控制器的表单支持对象，该对象返回 `form.jsp`。以下示例显示了 `form.jsp` 的样子：

```xml
<form:form>
    <table>
        <tr>
            <td>First Name:</td>
            <td><form:input path="firstName"/></td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><form:input path="lastName"/></td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="submit" value="Save Changes"/>
            </td>
        </tr>
    </table>
</form:form>
```

`firstName` 和 `lastName` 值由页面控制器从放置在 `PageContext` 中的命令对象中检索。继续阅读，了解如何将内部标记与 `form` 标记一起使用的更复杂的示例。

下面的列表显示了生成的 HTML，它看起来像一个标准表单：

```xml
<form method="POST">
    <table>
        <tr>
            <td>First Name:</td>
            <td><input name="firstName" type="text" value="Harry"/></td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><input name="lastName" type="text" value="Potter"/></td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="submit" value="Save Changes"/>
            </td>
        </tr>
    </table>
</form>
```

前面的 JSP 假设表单支持对象的变量名是 `command`。如果您已经将表单支持对象以另一个名称放入模型中（这绝对是一种最佳实践），则可以将表单绑定到命名变量，如下例所示：

```xml
<form:form modelAttribute="user">
    <table>
        <tr>
            <td>First Name:</td>
            <td><form:input path="firstName"/></td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><form:input path="lastName"/></td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="submit" value="Save Changes"/>
            </td>
        </tr>
    </table>
</form:form>
```

##### input 标签

默认情况下，此标记呈现具有绑定值和 `type='text'` 的 HTML `input` 元素。有关此标记的示例，请参见表单标记。您还可以使用HTML5特定的类型，如 `email`、`tel`、`date` 和其他类型。

##### checkbox 标签

此标记呈现 `type` 设置为 `checkbox` 的 HTML `input` 标记。

假设我们的 `User` 有偏好，例如订阅时事通讯和兴趣爱好列表。以下示例显示了 `Preferences` 类：

```java
public class Preferences {

    private boolean receiveNewsletter;
    private String[] interests;
    private String favouriteWord;

    public boolean isReceiveNewsletter() {
        return receiveNewsletter;
    }

    public void setReceiveNewsletter(boolean receiveNewsletter) {
        this.receiveNewsletter = receiveNewsletter;
    }

    public String[] getInterests() {
        return interests;
    }

    public void setInterests(String[] interests) {
        this.interests = interests;
    }

    public String getFavouriteWord() {
        return favouriteWord;
    }

    public void setFavouriteWord(String favouriteWord) {
        this.favouriteWord = favouriteWord;
    }
}
```

相应的 `form.jsp` 可以类似于以下内容：

```xml
<form:form>
    <table>
        <tr>
            <td>Subscribe to newsletter?:</td>
            <%-- Approach 1: Property is of type java.lang.Boolean --%>
            <td><form:checkbox path="preferences.receiveNewsletter"/></td>
        </tr>

        <tr>
            <td>Interests:</td>
            <%-- Approach 2: Property is of an array or of type java.util.Collection --%>
            <td>
                Quidditch: <form:checkbox path="preferences.interests" value="Quidditch"/>
                Herbology: <form:checkbox path="preferences.interests" value="Herbology"/>
                Defence Against the Dark Arts: <form:checkbox path="preferences.interests" value="Defence Against the Dark Arts"/>
            </td>
        </tr>

        <tr>
            <td>Favourite Word:</td>
            <%-- Approach 3: Property is of type java.lang.Object --%>
            <td>
                Magic: <form:checkbox path="preferences.favouriteWord" value="Magic"/>
            </td>
        </tr>
    </table>
</form:form>
```

`checkbox` 标记有三种方法，应该可以满足您的所有复选框需求。

- 方法一：当绑定值为 `java.lang.Boolean` 类型时，如果绑定值为 `true`，则输入（复选框）标记为已选中。`value` 属性对应于 `setValue(Object)` value 属性的解析值。
- 方法二：当绑定值的类型为 `array` 或 `java.util.Collection` 时，如果绑定 `Collection` 中存在配置的 `setValue(Object)` 值，则 `input(checkbox)` 标记为 `checked`。
- 方法三：对于任何其他绑定值类型，如果配置的 `setValue(Object)` 等于绑定值，则 `input(checkbox)` 标记为 `checked`。

请注意，无论采用何种方法，都会生成相同的 HTML 结构。以下 HTML 代码段定义了一些复选框：

```xml
<tr>
    <td>Interests:</td>
    <td>
        Quidditch: <input name="preferences.interests" type="checkbox" value="Quidditch"/>
        <input type="hidden" value="1" name="_preferences.interests"/>
        Herbology: <input name="preferences.interests" type="checkbox" value="Herbology"/>
        <input type="hidden" value="1" name="_preferences.interests"/>
        Defence Against the Dark Arts: <input name="preferences.interests" type="checkbox" value="Defence Against the Dark Arts"/>
        <input type="hidden" value="1" name="_preferences.interests"/>
    </td>
</tr>
```

您可能不希望在每个复选框之后看到额外的隐藏字段。当 HTML 页面中的复选框未被选中时，表单提交后，其值不会作为 HTTP 请求参数的一部分发送到服务器，因此我们需要一个解决 HTML 中这种怪癖的方法，以便 Spring 表单数据绑定能够工作。`checkbox` 标记遵循现有的 Spring 约定，即为每个复选框包含一个以下划线（`_`）为前缀的隐藏参数。通过这样做，您实际上是在告诉 Spring “复选框在表单中是可见的，我希望表单数据绑定到的对象反映复选框的状态，无论发生什么。”

##### checkboxes 标签

此标记呈现类型设置为复选框的多个 HTML 输入标记。

本节以上一个 `checkbox` 标记部分的示例为基础。有时，您不希望在 JSP 页面中列出所有可能的爱好。您更愿意在运行时提供可用选项的列表，并将其传递给标记。这就是 `checkboxes` 标记的用途。您可以传入包含 `items` 属性中可用选项的 `Array`、`List` 或 `Map`。通常，绑定属性是一个集合，因此它可以包含用户选择的多个值。以下示例显示了一个使用此标记的 JSP：

```xml
<form:form>
    <table>
        <tr>
            <td>Interests:</td>
            <td>
                <%-- Property is of an array or of type java.util.Collection --%>
                <form:checkboxes path="preferences.interests" items="${interestList}"/>
            </td>
        </tr>
    </table>
</form:form>
```

本例假设 `interestList` 是一个可用作模型属性的列表，其中包含要从中选择的值的字符串。如果使用 `Map`，则映射条目键将用作值，映射条目的值将用作要显示的标签。也可以使用自定义对象，在该对象中可以使用 `itemValue` 提供值的特性名称，使用 `itemLabel` 提供标签。

##### radiobutton 标签

此标记呈现 `type` 设置为 `radio` 的 HTML `input` 元素。

典型的使用模式涉及绑定到同一属性但具有不同值的多个标记实例，如以下示例所示：

```xml
<tr>
    <td>Sex:</td>
    <td>
        Male: <form:radiobutton path="sex" value="M"/> <br/>
        Female: <form:radiobutton path="sex" value="F"/>
    </td>
</tr>
```

##### radiobuttons 标签

此标记呈现 `type` 设置为 `radio` 的多个 HTML `input` 元素。
与 `checkboxes` 标记一样，您可能希望将可用选项作为运行时变量传入。对于此用法，您可以使用 `radiobuttons` 标记。传入一个 `Array`、`List` 或 `Map`，其中包含 `items` 属性中的可用选项。如果使用 `Map`，则映射条目键将用作值，映射条目的值将用作要显示的标签。您也可以使用自定义对象，在该对象中，您可以通过使用 `itemValue` 提供值的特性名称，并通过使用 `itemLabel` 提供标签，如以下示例所示：

```xml
<tr>
    <td>Sex:</td>
    <td><form:radiobuttons path="sex" items="${sexOptions}"/></td>
</tr>
```

##### password 标签

此标记呈现一个 HTML `input` 标记，该标记的 `type` 设置为具有绑定值的 `password`。

```xml
<tr>
    <td>Password:</td>
    <td>
        <form:password path="password"/>
    </td>
</tr>
```

请注意，默认情况下，不会显示密码值。如果确实希望显示密码值，可以将 `showPassword` 属性的值设置为 `true`，如下例所示：

```xml
<tr>
    <td>Password:</td>
    <td>
        <form:password path="password" value="^76525bvHGq" showPassword="true"/>
    </td>
</tr>
```

##### select 标签

此标记呈现 HTML “select” 元素。它支持将数据绑定到所选选项，以及使用嵌套的 `option` 和 `options` 标记。

假设 `User` 有一个技能列表。相应的 HTML 可以如下所示：

```xml
<tr>
    <td>Skills:</td>
    <td><form:select path="skills" items="${skills}"/></td>
</tr>
```

如果 `User` 的技能是草药，“技能”行的 HTML 源代码可能如下：

```xml
<tr>
    <td>Skills:</td>
    <td>
        <select name="skills" multiple="true">
            <option value="Potions">Potions</option>
            <option value="Herbology" selected="selected">Herbology</option>
            <option value="Quidditch">Quidditch</option>
        </select>
    </td>
</tr>
```

##### option 标签

此标记呈现 HTML `option` 元素。它根据绑定值设置 `selected`。以下 HTML 显示了它的典型输出：

```xml
<tr>
    <td>House:</td>
    <td>
        <form:select path="house">
            <form:option value="Gryffindor"/>
            <form:option value="Hufflepuff"/>
            <form:option value="Ravenclaw"/>
            <form:option value="Slytherin"/>
        </form:select>
    </td>
</tr>
```

如果 `User` 的房子在格兰芬多，“房子”行的 HTML 源代码如下：

```xml
<tr>
    <td>House:</td>
    <td>
        <select name="house">
            <option value="Gryffindor" selected="selected">Gryffindor</option> (1)
            <option value="Hufflepuff">Hufflepuff</option>
            <option value="Ravenclaw">Ravenclaw</option>
            <option value="Slytherin">Slytherin</option>
        </select>
    </td>
</tr>
```

(1) 注意额外的 `selected` 属性

##### options 标签

此标记呈现 HTML `option` 元素的列表。它根据绑定值设置 `selected` 的属性。以下 HTML 显示了它的典型输出：

```xml
<tr>
    <td>Country:</td>
    <td>
        <form:select path="country">
            <form:option value="-" label="--Please Select"/>
            <form:options items="${countryList}" itemValue="code" itemLabel="name"/>
        </form:select>
    </td>
</tr>
```

如果 `User` 居住在英国，“国家”行的 HTML 源代码如下：

```xml
<tr>
    <td>Country:</td>
    <td>
        <select name="country">
            <option value="-">--Please Select</option>
            <option value="AT">Austria</option>
            <option value="UK" selected="selected">United Kingdom</option> (1)
            <option value="US">United States</option>
        </select>
    </td>
</tr>
```

(1) 注意额外的一个 `selected` 属性

如前一个示例所示，`option` 标记和 `options` 标记的组合使用会生成相同的标准 HTML，但允许您在 JSP 中明确指定一个仅用于显示的值（它所属的位置），例如示例中的默认字符串：“--Please Select”。

`items` 属性通常由项对象（item objects）的集合或数组填充。`itemValue` 和 `itemLabel` 引用这些项对象的 bean 属性（如果指定）。否则，项对象本身将变成字符串。或者，可以指定项目 `Map`，在这种情况下，映射键被解释为选项值，映射值对应于选项标签。如果碰巧也指定了 `itemValue` 或 `itemLabel`（或两者都指定），则项值属性将应用于映射键，项标签属性则应用于映射值。

##### textarea 标签

此标记呈现 HTML `textarea` 元素。以下 HTML 显示了它的典型输出：

```xml
<tr>
    <td>Notes:</td>
    <td><form:textarea path="notes" rows="3" cols="20"/></td>
    <td><form:errors path="notes"/></td>
</tr>
```

##### hidden 标签

此标记呈现一个 HTML 输入标记，该标记的类型设置为使用绑定值隐藏。若要提交未绑定的隐藏值，请使用类型设置为隐藏的 HTML 输入标记。以下 HTML 显示了它的典型输出：

```xml
<form:hidden path="house"/>
```

如果我们选择将房屋价值作为隐藏价值提交，HTML 将如下所示：

```xml
<input name="house" type="hidden" value="Gryffindor"/>
```

##### errors 标签

此标记在 HTML `span` 元素中呈现字段错误。它提供对控制器中创建的错误或与控制器关联的任何验证器创建的错误的访问。

假设我们希望在提交表单后显示 `firstName` 和 `lastName` 字段的所有错误消息。我们有一个名为 `UserValidator` 的 `User` 类实例的验证器，如下例所示：

```java
public class UserValidator implements Validator {

    public boolean supports(Class candidate) {
        return User.class.isAssignableFrom(candidate);
    }

    public void validate(Object obj, Errors errors) {
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "firstName", "required", "Field is required.");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "lastName", "required", "Field is required.");
    }
}
```

`form.jsp` 可以如下所示：

```xml
<form:form>
    <table>
        <tr>
            <td>First Name:</td>
            <td><form:input path="firstName"/></td>
            <%-- Show errors for firstName field --%>
            <td><form:errors path="firstName"/></td>
        </tr>

        <tr>
            <td>Last Name:</td>
            <td><form:input path="lastName"/></td>
            <%-- Show errors for lastName field --%>
            <td><form:errors path="lastName"/></td>
        </tr>
        <tr>
            <td colspan="3">
                <input type="submit" value="Save Changes"/>
            </td>
        </tr>
    </table>
</form:form>
```

如果我们提交的表单的 `firstName` 和 `lastName` 字段中有空值，HTML 将如下所示：

```xml
<form method="POST">
    <table>
        <tr>
            <td>First Name:</td>
            <td><input name="firstName" type="text" value=""/></td>
            <%-- Associated errors to firstName field displayed --%>
            <td><span name="firstName.errors">Field is required.</span></td>
        </tr>

        <tr>
            <td>Last Name:</td>
            <td><input name="lastName" type="text" value=""/></td>
            <%-- Associated errors to lastName field displayed --%>
            <td><span name="lastName.errors">Field is required.</span></td>
        </tr>
        <tr>
            <td colspan="3">
                <input type="submit" value="Save Changes"/>
            </td>
        </tr>
    </table>
</form>
```

如果我们想显示给定页面的整个错误列表，该怎么办？下一个示例显示 `errors` 标记还支持一些基本的通配符功能。

- `path="*"`：显示所有错误。
- `path="lastName"`：显示与 `lastName` 字段相关的所有错误。
- 如果 `path` 被忽略，则只显示对象错误。

以下示例在页面顶部显示错误列表，然后在字段旁边显示特定于字段的错误：

```xml
<form:form>
    <form:errors path="*" cssClass="errorBox"/>
    <table>
        <tr>
            <td>First Name:</td>
            <td><form:input path="firstName"/></td>
            <td><form:errors path="firstName"/></td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><form:input path="lastName"/></td>
            <td><form:errors path="lastName"/></td>
        </tr>
        <tr>
            <td colspan="3">
                <input type="submit" value="Save Changes"/>
            </td>
        </tr>
    </table>
</form:form>
```

HTML 将如下所示：

```xml
<form method="POST">
    <span name="*.errors" class="errorBox">Field is required.<br/>Field is required.</span>
    <table>
        <tr>
            <td>First Name:</td>
            <td><input name="firstName" type="text" value=""/></td>
            <td><span name="firstName.errors">Field is required.</span></td>
        </tr>

        <tr>
            <td>Last Name:</td>
            <td><input name="lastName" type="text" value=""/></td>
            <td><span name="lastName.errors">Field is required.</span></td>
        </tr>
        <tr>
            <td colspan="3">
                <input type="submit" value="Save Changes"/>
            </td>
        </tr>
    </table>
</form>
```

`spring-form.tld` 标记库描述符（TLD）包含在 `spring-webmvc.jar` 中。有关单个标记的全面参考，请浏览 API 参考或查看标记库描述。

##### HTTP 方法转换

REST 的一个关键原则是使用“统一接口”。这意味着所有资源（URL）都可以通过使用相同的四种 HTTP 方法进行操作：GET、PUT、POST 和 DELETE。对于每种方法，HTTP 规范都定义了确切的语义。例如，GET 应该始终是一个安全的操作，这意味着它没有副作用，PUT 或 DELETE 应该是幂等的，这意味着您可以一次又一次地重复这些操作，但最终结果应该是相同的。虽然 HTTP 定义了这四种方法，但 HTML 只支持两种：GET 和 POST。幸运的是，有两种可能的解决方案：您可以使用 JavaScript 来执行 PUT 或 DELETE，也可以使用 “real” 方法作为附加参数（建模为 HTML 表单中的隐藏输入字段）来执行 POST。Spring 的 HiddenHttpMethodFilter 使用了后一种技巧。这个过滤器是一个普通的 Servlet 过滤器，因此，它可以与任何 web 框架（不仅仅是 SpringMVC）结合使用。将此筛选器添加到 web.xml 中，带有隐藏方法参数的 POST 将转换为相应的 HTTP 方法请求。

为了支持 HTTP 方法转换，Spring MVC 表单标记被更新为支持设置 HTTP 方法。例如，以下片段来自宠物诊所示例：

```xml
<form:form method="delete">
    <p class="submit"><input type="submit" value="Delete Pet"/></p>
</form:form>
```

前面的示例执行 HTTP POST，在请求参数后面隐藏 “real” 的 DELETE 方法。它由 web.xml 中定义的 `HiddenHttpMethodFilter` 获取，如下例所示：

```xml
<filter>
    <filter-name>httpMethodFilter</filter-name>
    <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
</filter>

<filter-mapping>
    <filter-name>httpMethodFilter</filter-name>
    <servlet-name>petclinic</servlet-name>
</filter-mapping>
```

以下示例显示了相应的 `@Controller` 方法：

```java
@RequestMapping(method = RequestMethod.DELETE)
public String deletePet(@PathVariable int ownerId, @PathVariable int petId) {
    this.clinic.deletePet(petId);
    return "redirect:/owners/" + ownerId;
}
```

##### HTML 5 标签

Spring 表单标记库允许输入动态属性，这意味着您可以输入任何 HTML5 特定的属性。

表单 `input` 标记支持输入 `text` 以外的类型属性。这旨在允许呈现新的 HTML5 特定输入类型，如 `email`、`date`、`range` 和其他类型。请注意，由于 `text` 是默认类型，因此不需要输入 `type='text'`。

### 1.11.6 RSS 和 Atom

`AbstractAtomFeedView` 和 `AbstractRssFeedView` 都继承了 `AbstractFeedView` 基类，分别用于提供 Atom 和 RSSFeed 视图。它们基于 ROME 项目，位于 `org.springframework.web.servlet.view.feed` 包中。

`AbstractAtomFeedView` 要求您实现 `buildFeedEntry()` 方法，并可选地重写 `buildFeedMetadata()` 方法（默认实现为空）。以下示例显示了如何执行此操作：

```java
public class SampleContentAtomView extends AbstractAtomFeedView {

    @Override
    protected void buildFeedMetadata(Map<String, Object> model,
            Feed feed, HttpServletRequest request) {
        // implementation omitted
    }

    @Override
    protected List<Entry> buildFeedEntries(Map<String, Object> model,
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        // implementation omitted
    }
}
```

类似的要求适用于实现 `AbstractRssFeedView`，如下例所示：

```java
public class SampleContentRssView extends AbstractRssFeedView {

    @Override
    protected void buildFeedMetadata(Map<String, Object> model,
            Channel feed, HttpServletRequest request) {
        // implementation omitted
    }

    @Override
    protected List<Item> buildFeedItems(Map<String, Object> model,
            HttpServletRequest request, HttpServletResponse response) throws Exception {
        // implementation omitted
    }
}
```

`buildFeedItems()` 和 `buildFeedEntries()` 方法传入 HTTP 请求，以防您需要访问 Locale。HTTP 响应仅用于 Cookie 或其他 HTTP 标头的设置。在方法返回后，提要会自动写入响应对象。

有关创建 Atom 视图的示例，请参阅 Alef Arendsen 的 Spring Team 博客条目。

### 1.11.7 PDF 和 Excel

Spring 提供了返回 HTML 以外的输出的方法，包括 PDF 和 Excel 电子表格。本节介绍如何使用这些功能。

#### 文件视图的介绍

HTML 页面并不总是用户查看模型输出的最佳方式，Spring 使从模型数据动态生成 PDF 文档或 Excel 电子表格变得简单。文档是视图，并以正确的内容类型从服务器流式传输，以（希望）使客户端 PC 能够运行其电子表格或 PDF 查看器应用程序作为响应。

为了使用 Excel 视图，您需要将 Apache POI 库添加到类路径中。对于 PDF 生成，您需要（最好）添加 OpenPDF 库。

> 如果可能的话，您应该使用最新版本的底层文档生成库。特别是，我们强烈建议使用 OpenPDF（例如，OpenPDF 1.2.12），而不是过时的原始 iText 2.1.7，因为 OpenPDF 是积极维护的，并修复了不受信任的 PDF 内容的一个重要漏洞。

#### PDF 视图

单词列表的简单 PDF 视图可以扩展 `org.springframework.web.servlet.view.document.AbstractPdfView` 并实现 `buildPdfDocument()` 方法，如下例所示：

```java
public class PdfWordList extends AbstractPdfView {

    protected void buildPdfDocument(Map<String, Object> model, Document doc, PdfWriter writer,
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        List<String> words = (List<String>) model.get("wordList");
        for (String word : words) {
            doc.add(new Paragraph(word));
        }
    }
}
```

控制器可以从外部视图定义（按名称引用它）或作为处理程序方法的 `View` 实例返回这样的视图。

#### Excel 视图

自 Spring Framework 4.2 以来，提供了 `org.springframework.web.servlet.view.dococument.AbstractXlsView` 作为 Excel 视图的基类。它基于 Apache POI，具有专门的子类（`AbstractXlsxView` 和 `AbstractXtlsxStreamingView`），取代了过时的 `AbstractExcelView` 类。

编程模型类似于 `AbstractPdfView`，使用 `buildExcelDocument()` 作为中心模板方法，控制器能够从外部定义（按名称）或作为处理程序方法的 `View` 实例返回这样的视图。

### 1.11.8 Jackson

Spring 提供了对 Jackson JSON 库的支持。

#### 基于 Jackson 的 JSON MVC 视图

`MappingJackson2JsonView` 使用 Jackson 库的 `ObjectMapper` 将响应内容呈现为 JSON。默认情况下，模型映射的整个内容（框架特定类除外）都编码为 JSON。对于需要过滤映射内容的情况，可以使用 `modelKeys` 属性指定一组特定的模型属性进行编码。也可以使用 `extractValueFromSingleKeyModel` 属性直接提取和序列化单键模型中的值，而不是将其作为模型属性的映射。

您可以根据需要使用 Jackson 提供的注解自定义 JSON 映射。当您需要进一步控制时，可以通过 `ObjectMapper` 属性注入自定义 `ObjectMapper`，用于需要为特定类型提供自定义 JSON 序列化程序和反序列化程序的情况。

#### 基于 Jackson 的 XML 视图

`MappingJackson2XmlView` 使用 Jackson XML 扩展的 `XmlMapper` 将响应内容呈现为 XML。如果模型包含多个条目，则应使用 `modelKey` bean 属性显式设置要序列化的对象。如果模型包含单个条目，则会自动对其进行序列化。

您可以根据需要使用 JAXB 或 Jackson 提供的注解来定制 XML 映射。当需要进一步控制时，可以通过 `ObjectMapper` 属性注入自定义 `XmlMapper`，对于需要为特定类型提供序列化程序和反序列化程序的自定义 XML 的情况。

### 1.11.9 XML 封送（Marshalling）

`MarshallingView` 使用 XML `Marshaller`（在 `org.springframework.oxm` 包中定义）将响应内容呈现为 XML。您可以使用 `MarshallingView` 实例的 `modelKey` bean 属性显式设置要编组的对象。或者，视图迭代所有模型属性并封送 `Marshaller` 支持的第一个类型。有关 `org.springframework.oxm` 包中功能的更多信息，请参阅使用 O/X 映射器封送 XML。

### 1.11.10 XSLT 视图

XSLT 是 XML 的一种转换语言，作为一种视图技术在 web 应用程序中很受欢迎。如果您的应用程序自然地处理 XML，或者您的模型可以很容易地转换为 XML，那么 XSLT 作为视图技术是一个不错的选择。以下部分展示了如何生成 XML 文档作为模型数据，并在 Spring Web MVC 应用程序中使用 XSLT 进行转换。

这个例子是一个简单的 Spring 应用程序，它在 `Controller` 中创建一个单词列表，并将它们添加到模型映射中。将返回映射以及 XSLT 视图的视图名称。有关 Spring Web MVC 的 `Controller` 接口的详细信息，请参阅带注解的控制器。XSLT 控制器将单词列表转换为一个简单的 XML 文档，以便进行转换。

#### Beans

配置是简单 Spring web 应用程序的标准配置：MVC 配置必须定义 `XsltViewResolver` bean 和常规 MVC 注解配置。以下示例显示了如何执行此操作：

```java
@EnableWebMvc
@ComponentScan
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public XsltViewResolver xsltViewResolver() {
        XsltViewResolver viewResolver = new XsltViewResolver();
        viewResolver.setPrefix("/WEB-INF/xsl/");
        viewResolver.setSuffix(".xslt");
        return viewResolver;
    }
}
```

#### Controller

我们还需要一个控制器来封装我们的单词生成逻辑。

控制器逻辑封装在 `@Controller` 类中，处理程序方法定义如下：

```java
@Controller
public class XsltController {

    @RequestMapping("/")
    public String home(Model model) throws Exception {
        Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        Element root = document.createElement("wordList");

        List<String> words = Arrays.asList("Hello", "Spring", "Framework");
        for (String word : words) {
            Element wordNode = document.createElement("word");
            Text textNode = document.createTextNode(word);
            wordNode.appendChild(textNode);
            root.appendChild(wordNode);
        }

        model.addAttribute("wordList", root);
        return "home";
    }
}
```

到目前为止，我们只创建了一个 DOM 文档并将其添加到模型映射中。请注意，您还可以将 XML 文件加载为 `Resource`，并使用它来代替自定义 DOM 文档。

有一些软件包可以自动“初始化”对象图，但在 Spring 中，您可以完全灵活地以任何选择的方式从模型中创建 DOM。这可以防止 XML 的转换在模型数据的结构中扮演太大的角色，而在使用工具管理 DOMiification 过程时，这是一种危险。

#### Transformation

最后，`XsltViewResolver` 解析“主” XSLT 模板文件，并将 DOM 文档合并到其中以生成我们的视图。如 `XsltViewResolver` 配置中所示，XSLT 模板位于 `WEB-INF/xsl` 目录中的 `war` 文件中，并以 `xslt` 文件扩展名结束。

以下示例显示了一个 XSLT 转换：

```xml
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <html>
            <head><title>Hello!</title></head>
            <body>
                <h1>My First Words</h1>
                <ul>
                    <xsl:apply-templates/>
                </ul>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="word">
        <li><xsl:value-of select="."/></li>
    </xsl:template>

</xsl:stylesheet>
```

前面的转换呈现为以下 HTML：

```html
<html>
    <head>
        <META http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hello!</title>
    </head>
    <body>
        <h1>My First Words</h1>
        <ul>
            <li>Hello</li>
            <li>Spring</li>
            <li>Framework</li>
        </ul>
    </body>
</html>
```

## 1.12 MVC 设置

MVC Java 配置和 MVC XML 命名空间提供了适用于大多数应用程序的默认配置，并提供了一个用于自定义它的配置 API。

有关配置 API 中不可用的更高级自定义，请参阅高级 Java 配置和高级 XML 配置。

您不需要理解 MVC Java 配置和 MVC 命名空间创建的底层 bean。如果您想了解更多信息，请参阅特殊 Bean 类型和 Web MVC 配置。

### 1.12.1 启用 MVC 配置

在 Java 配置中，您可以使用 `@EnableWebMvc` 注解来启用 MVC 配置，如下例所示：

```java
@Configuration
@EnableWebMvc
public class WebConfig {
}
```

在 XML 配置中，您可以使用 `<mvc:annotation-driven>` 元素来启用 mvc 配置，如下例所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:mvc="http://www.springframework.org/schema/mvc"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/mvc
        https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <mvc:annotation-driven/>

</beans>
```

前面的示例注册了许多 Spring MVC 基础结构 bean，并适应类路径上可用的依赖项（例如，JSON、XML 和其他的有效负载转换器）。

### 1.12.2 MVC 配置 API

在 Java 配置中，您可以实现 `WebMvcConfigurer` 接口，如下例所示：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    // Implement configuration methods...
}
```

在 XML 中，您可以检查 `<mvc:annotation-driven/>` 的属性和子元素。您可以查看 Spring MVC XML 模式，或者使用 IDE 的代码完成功能来发现哪些属性和子元素可用。

### 1.12.3 类型转换

默认情况下，安装了各种数字和日期类型的格式化程序，并支持通过 `@NumberFormat` 和 `@DateTimeFormat` 对字段进行自定义。

要在 Java 配置中注册自定义格式化程序和转换器，请使用以下命令：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addFormatters(FormatterRegistry registry) {
        // ...
    }
}
```

要在 XML 配置中执行相同操作，请使用以下操作：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:mvc="http://www.springframework.org/schema/mvc"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/mvc
        https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <mvc:annotation-driven conversion-service="conversionService"/>

    <bean id="conversionService"
            class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
        <property name="converters">
            <set>
                <bean class="org.example.MyConverter"/>
            </set>
        </property>
        <property name="formatters">
            <set>
                <bean class="org.example.MyFormatter"/>
                <bean class="org.example.MyAnnotationFormatterFactory"/>
            </set>
        </property>
        <property name="formatterRegistrars">
            <set>
                <bean class="org.example.MyFormatterRegistrar"/>
            </set>
        </property>
    </bean>

</beans>
```

默认情况下，Spring MVC 在解析和格式化日期值时会考虑请求 Locale。这适用于日期表示为带有 “input” 表单字段的字符串的表单。然而，对于 “date” 和 “time” 表单字段，浏览器使用 HTML 规范中定义的固定格式。对于这种情况，日期和时间格式可以自定义如下：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addFormatters(FormatterRegistry registry) {
        DateTimeFormatterRegistrar registrar = new DateTimeFormatterRegistrar();
        registrar.setUseIsoFormat(true);
        registrar.registerFormatters(registry);
    }
}
```

> 有关何时使用 FormatterRegistrar 实现的更多信息，请参阅 `FormatterRegistrar` SPI 和 `FormattingConversionServiceFactoryBean`。

### 1.12.4 校验

默认情况下，如果类路径上存在 Bean Validation（例如，Hibernate Validator），则 `LocalValidatorFactoryBean` 将注册为全局 Validator，用于控制器方法参数上的 `@Valid` 和 `Validated`。

在 Java 配置中，您可以自定义全局 `Validator` 实例，如下例所示：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public Validator getValidator() {
        // ...
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:mvc="http://www.springframework.org/schema/mvc"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/mvc
        https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <mvc:annotation-driven validator="globalValidator"/>

</beans>
```

请注意，您也可以在本地注册 `Validator` 实现，如下例所示：

```java
@Controller
public class MyController {

    @InitBinder
    protected void initBinder(WebDataBinder binder) {
        binder.addValidators(new FooValidator());
    }
}
```

> 如果您需要在某个地方注入 `LocalValidatorFactoryBean`，请创建一个 bean 并用 `@Primary` 标记它，以避免与 MVC 配置中声明的 bean 发生冲突。

### 1.12.5 拦截器

在 Java 配置中，您可以注册拦截器以应用于传入请求，如下例所示：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LocaleChangeInterceptor());
        registry.addInterceptor(new ThemeChangeInterceptor()).addPathPatterns("/**").excludePathPatterns("/admin/**");
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

```xml
<mvc:interceptors>
    <bean class="org.springframework.web.servlet.i18n.LocaleChangeInterceptor"/>
    <mvc:interceptor>
        <mvc:mapping path="/**"/>
        <mvc:exclude-mapping path="/admin/**"/>
        <bean class="org.springframework.web.servlet.theme.ThemeChangeInterceptor"/>
    </mvc:interceptor>
</mvc:interceptors>
```

> 映射拦截器不适合作为安全层，因为它可能与带注解的控制器路径匹配不匹配，后者也可以透明地匹配尾部斜线和路径扩展，以及其他路径匹配选项。其中许多选项已被弃用，但不匹配的可能性仍然存在。通常，我们建议使用 Spring Security，它包括一个专用的 MvcRequestMatcher 来与 Spring MVC 路径匹配对齐，并且还具有一个安全防火墙，可以阻止 URL 路径中的许多不需要的字符。

### 1.12.6 内容类型

您可以配置 Spring MVC 如何根据请求确定请求的媒体类型（例如，`Accept` 标头、URL 路径扩展、查询参数等）。

默认情况下，仅检查 `Accept` 标头。

如果必须使用基于 URL 的内容类型解析，请考虑在路径扩展上使用查询参数策略。有关更多详细信息，请参见后缀匹配和后缀匹配以及 RFD。

在 Java 配置中，您可以自定义请求的内容类型解析，如下例所示：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
        configurer.mediaType("json", MediaType.APPLICATION_JSON);
        configurer.mediaType("xml", MediaType.APPLICATION_XML);
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

```xml
<mvc:annotation-driven content-negotiation-manager="contentNegotiationManager"/>

<bean id="contentNegotiationManager" class="org.springframework.web.accept.ContentNegotiationManagerFactoryBean">
    <property name="mediaTypes">
        <value>
            json=application/json
            xml=application/xml
        </value>
    </property>
</bean>
```

### 1.12.7 消息转换器

您可以在 Java 配置中通过重写 `configureMessageConverters()`（替换 Spring MVC 创建的默认转换器）或重写 `extendMessageConverter()`（自定义默认转换器或在默认转换器上添加其他转换器）来自定义 `HttpMessageConverter`。

以下示例使用自定义的 `ObjectMapper`（而不是默认的）添加 XML 和 Jackson JSON 转换器：

```java
@Configuration
@EnableWebMvc
public class WebConfiguration implements WebMvcConfigurer {

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        Jackson2ObjectMapperBuilder builder = new Jackson2ObjectMapperBuilder()
                .indentOutput(true)
                .dateFormat(new SimpleDateFormat("yyyy-MM-dd"))
                .modulesToInstall(new ParameterNamesModule());
        converters.add(new MappingJackson2HttpMessageConverter(builder.build()));
        converters.add(new MappingJackson2XmlHttpMessageConverter(builder.createXmlMapper(true).build()));
    }
}
```

在前面的示例中，`Jackson2ObjectMapperBuilder` 用于为 `MappingJackson2HttpMessageConverter` 和 `MappingJackson2XmlHttpMessageConverter` 创建一个通用配置，启用缩进、自定义日期格式和注册 `jackson-module-parameter-names`，这增加了对访问参数名称的支持（Java 8 中添加的一项功能）。

此生成器自定义 Jackson 的默认财产，如下所示：

- [`DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES`](https://fasterxml.github.io/jackson-databind/javadoc/2.6/com/fasterxml/jackson/databind/DeserializationFeature.html#FAIL_ON_UNKNOWN_PROPERTIES) 已禁用。
- [`MapperFeature.DEFAULT_VIEW_INCLUSION`](https://fasterxml.github.io/jackson-databind/javadoc/2.6/com/fasterxml/jackson/databind/MapperFeature.html#DEFAULT_VIEW_INCLUSION) 已禁用。

如果在类路径上检测到以下众所周知的模块，它还会自动注册这些模块：

- jackson-datetype-joda：支持 joda-Time 类型。
- jackson-datatype-jsr310：支持 Java 8 日期和时间 API 类型。
- jackson-datatype-jdk8：支持其他 Java 8类型，例如 `Optional`。
- `jackson-module-kotlin`：支持 Kotlin 类和数据类。

> 使用 Jackson XML 支持启用缩进需要 `woodstox-core-asl` 依赖项，此外还需要 `jackson-dataformat-xml` 依赖项。

还有其他有趣的 Jackson 模块：

- jackson-datatype-money：支持 `javax.money` 类型（非官方模块）。
- jackson-datatype-hibernate：支持特定于 Hibernate 的类型和财产（包括延迟加载方面）。

以下示例显示了如何在 XML 中实现相同的配置：

```xml
<mvc:annotation-driven>
    <mvc:message-converters>
        <bean class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter">
            <property name="objectMapper" ref="objectMapper"/>
        </bean>
        <bean class="org.springframework.http.converter.xml.MappingJackson2XmlHttpMessageConverter">
            <property name="objectMapper" ref="xmlMapper"/>
        </bean>
    </mvc:message-converters>
</mvc:annotation-driven>

<bean id="objectMapper" class="org.springframework.http.converter.json.Jackson2ObjectMapperFactoryBean"
      p:indentOutput="true"
      p:simpleDateFormat="yyyy-MM-dd"
      p:modulesToInstall="com.fasterxml.jackson.module.paramnames.ParameterNamesModule"/>

<bean id="xmlMapper" parent="objectMapper" p:createXmlMapper="true"/>
```

### 1.12.8 视图控制器

这是定义 `ParameterizableViewController` 的快捷方式，该控制器在调用时立即转发到视图。当视图生成响应之前没有 Java 控制器逻辑要运行时，您可以在静态情况下使用它。

以下 Java 配置示例将 `/` 请求转发到一个名为 `home` 的视图：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("home");
    }
}
```

以下示例通过使用 `<mvc:view-controller>` 元素，实现了与前面示例相同的功能，但使用了 XML：

```xml
<mvc:view-controller path="/" view-name="home"/>
```

如果 `@RequestMapping` 方法映射到任何 HTTP 方法的 URL，则视图控制器不能用于处理同一 URL。这是因为 URL 与带注解的控制器的匹配被认为是端点所有权的足够强的指示，因此 405（METHOD_NOT_ALLOWED）、415（UNSUPPORTED_MEDIA_TYPE）或类似的响应可以被发送到客户端以帮助调试。因此，建议避免在带注释的控制器和视图控制器之间拆分 URL 处理。

### 1.12.9 视图解析器

MVC 配置简化了视图解析器的注册。

以下 Java 配置示例通过使用 JSP 和 Jackson 作为 JSON 呈现的默认视图来配置内容协商 `View` 解析：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.enableContentNegotiation(new MappingJackson2JsonView());
        registry.jsp();
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

```xml
<mvc:view-resolvers>
    <mvc:content-negotiation>
        <mvc:default-views>
            <bean class="org.springframework.web.servlet.view.json.MappingJackson2JsonView"/>
        </mvc:default-views>
    </mvc:content-negotiation>
    <mvc:jsp/>
</mvc:view-resolvers>
```

然而，请注意，FreeMarker、Groovy Markup 和脚本模板也需要配置底层视图技术。

MVC 命名空间提供了专用的元素。以下示例适用于 FreeMarker：

```xml
<mvc:view-resolvers>
    <mvc:content-negotiation>
        <mvc:default-views>
            <bean class="org.springframework.web.servlet.view.json.MappingJackson2JsonView"/>
        </mvc:default-views>
    </mvc:content-negotiation>
    <mvc:freemarker cache="false"/>
</mvc:view-resolvers>

<mvc:freemarker-configurer>
    <mvc:template-loader-path location="/freemarker"/>
</mvc:freemarker-configurer>
```

在 Java 配置中，您可以添加相应的 `Configurer` bean，如下例所示：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.enableContentNegotiation(new MappingJackson2JsonView());
        registry.freeMarker().cache(false);
    }

    @Bean
    public FreeMarkerConfigurer freeMarkerConfigurer() {
        FreeMarkerConfigurer configurer = new FreeMarkerConfigurer();
        configurer.setTemplateLoaderPath("/freemarker");
        return configurer;
    }
}
```

### 1.12.10 静态资源

此选项提供了一种方便的方式，可以从基于 `Resource` 的位置列表中提供静态资源。

在下一个示例中，给定一个以 `/resources` 开头的请求，相对路径用于在 web 应用程序根目录下或在 `/static` 下的类路径上查找和服务相对于 `/public` 的静态资源。这些资源的使用期限为一年，以确保最大限度地使用浏览器缓存，并减少浏览器发出的 HTTP 请求。`Last-Modified` 信息是从 `Resource#lastModified` 推导出来的，因此 HTTP 条件请求支持 `"Last-Modified"` 标头。

以下列表显示了如何使用 Java 配置执行此操作：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/public", "classpath:/static/")
                .setCacheControl(CacheControl.maxAge(Duration.ofDays(365)));
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

```xml
<mvc:resources mapping="/resources/**"
    location="/public, classpath:/static/"
    cache-period="31556926" />
```

另请参阅对静态资源的 HTTP 缓存支持。

资源处理程序还支持一系列 `ResourceResolver` 实现和 `ResourceTransformer` 实现，您可以使用它们来创建用于处理优化资源的工具链。

您可以基于从内容、固定应用程序版本或其他版本计算的 MD5 哈希，对版本化的资源 URL 使用 `VersionResourceResolver`。`ContentVersionStrategy`（MD5 散列）是一个不错的选择 — 除了一些显著的例外，例如与模块加载程序一起使用的 JavaScript 资源。

以下示例显示了如何在 Java 配置中使用 `VersionResourceResolver`：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/public/")
                .resourceChain(true)
                .addResolver(new VersionResourceResolver().addContentVersionStrategy("/**"));
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

```xml
<mvc:resources mapping="/resources/**" location="/public/">
    <mvc:resource-chain resource-cache="true">
        <mvc:resolvers>
            <mvc:version-resolver>
                <mvc:content-version-strategy patterns="/**"/>
            </mvc:version-resolver>
        </mvc:resolvers>
    </mvc:resource-chain>
</mvc:resources>
```

然后，您可以使用 `ResourceUrlProvider` 重写 URL，并应用完整的解析器和转换器链 — 例如插入版本。MVC 配置提供了一个 `ResourceUrlProvider` bean，这样它就可以被注入到其他 bean 中。您还可以使用 `ResourceUrlEncodingFilter` 为Thymelaf、JSP、FreeMarker 和其他具有依赖 `HttpServletResponse#encodeURL` 的 URL 标记的应用程序进行透明重写。

请注意，当同时使用 `EncodedResourceResolver`（例如，用于提供 gzip 了的或 brotli 编码的资源）和 `VersionResourceResolver` 时，必须按此顺序注册它们。这确保了基于内容的版本总是基于未编码的文件进行可靠的计算。

对于 WebJars，像 `/webJars/jquery/1.2.0/jquery.min.js` 这样的版本化 URL 是推荐的也是最有效的使用方式。相关的资源位置是通过 Spring Boot 开箱即用配置的（或者可以通过 `ResourceHandlerRegistry` 手动配置），不需要添加 `org.webjars:webjars-locator-core` 依赖项。

`WebJarsResourceResolver` 支持像 `/webjars/jquery/jquery.min.js` 这样的无版本 URL，当 `org.webjars:webjars-locator-core` 库出现在类路径上时，`WebJarsResourceResolver` 会自动注册，代价是类路径扫描可能会减慢应用程序的启动。解析器可以重写 URL 以包含 jar 的版本，也可以与没有版本的传入 URL 进行匹配 — 例如，从 `/webjars/jquery/jquery.min.js` 到 `/webjars/jquery/1.2.0/jquery.min.js`。

> 基于 `ResourceHandlerRegistry` 的 Java 配置为细粒度控制提供了进一步的选项，例如上次修改的行为和优化的资源解析。

### 1.12.11 默认 Servlet

Spring MVC 允许将 `DispatcherServlet` 映射到 `/`（从而覆盖容器默认 Servlet 的映射），同时仍然允许容器的默认 Servlet 处理静态资源请求。它配置了一个 `DefaultServletHttpRequestHandler`，其 URL 映射为 `/**`，并且相对于其他 URL 映射具有最低优先级。

此处理程序将所有请求转发到默认 Servlet。因此，它必须保持在所有其他 URL 句柄映射顺序的最后一个。如果您使用 `<mvc:annotation-driven>`，就会出现这种情况。或者，如果您设置了自己的自定义 `HandlerMapping` 实例，请确保将其 `order` 属性设置为低于 `DefaultServletHttpRequestHandler` 的值，即 `Integer.MAX_VALUE`。

以下示例显示了如何使用默认设置启用该功能：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

```xml
<mvc:default-servlet-handler/>
```

重写 `/` Servlet 映射的注意事项是，必须按名称而不是按路径检索默认 Servlet 的 `RequestDispatcher`。`DefaultServletHttpRequestHandler` 试图在启动时自动检测容器的默认 Servlet，使用大多数主要 Servlet 容器（包括 Tomcat、Jetty、GlassFish、JBoss、Resin、WebLogic 和 WebSphere）的已知名称列表。如果使用不同的名称自定义配置了默认 Servlet，或者在默认 Servlet 名称未知的情况下使用了不同的 Servlet 容器，则必须显式提供默认 Servlet 的名称，如下例所示：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable("myCustomDefaultServlet");
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

```xml
<mvc:default-servlet-handler default-servlet-name="myCustomDefaultServlet"/>
```

### 1.12.12 路径匹配

您可以自定义与路径匹配和 URL 处理相关的选项。有关各个选项的详细信息，请参阅 `PathMatchConfigurer` javadoc。

以下示例显示了如何在 Java 配置中自定义路径匹配：

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer.addPathPrefix("/api", HandlerTypePredicate.forAnnotation(RestController.class));
    }

    private PathPatternParser patternParser() {
        // ...
    }
}
```

以下示例显示了如何在 XML 配置中自定义路径匹配：

```xml
<mvc:annotation-driven>
    <mvc:path-matching
        path-helper="pathHelper"
        path-matcher="pathMatcher"/>
</mvc:annotation-driven>

<bean id="pathHelper" class="org.example.app.MyPathHelper"/>
<bean id="pathMatcher" class="org.example.app.MyPathMatcher"/>
```

### 1.12.13 高级 Java 配置

`@EnableWebMvc` 导入 `DelegatingWebMvcConfiguration`，该配置：

为Spring MVC应用程序提供默认的Spring配置
检测并委托WebMvcConfigurer实现以自定义该配置。

对于高级模式，您可以删除 `@EnableWebMvc` 并直接从 `DelegatingWebMvcConfiguration` 进行扩展，而不是实现 `WebMvcConfigurer`，如下例所示：

```java
@Configuration
public class WebConfig extends DelegatingWebMvcConfiguration {

    // ...
}
```

您可以将现有方法保留在 `WebConfig` 中，但现在也可以覆盖基类中的 bean 声明，并且类路径上仍然可以有任意数量的其他 `WebMvcConfigurer` 实现。

### 1.12.14 高级 XML 配置

MVC 命名空间没有高级模式。如果您需要在 bean 上自定义一个无法更改的属性，则可以使用 Spring `ApplicationContext` 的 `BeanPostProcessor` 生命周期挂钩，如下例所示：

```java
@Component
public class MyPostProcessor implements BeanPostProcessor {

    public Object postProcessBeforeInitialization(Object bean, String name) throws BeansException {
        // ...
    }
}
```

请注意，您需要将 `MyPostProcessor` 声明为 bean，可以用 XML 显式声明，也可以通过 `<component-scan/>` 声明来检测它。

## 1.13 HTTP/2

Servlet 4 容器需要支持 HTTP/2，Spring Framework 5 与 Servlet API 4 兼容。从编程模型的角度来看，应用程序不需要做任何特定的事情。但是，有一些与服务器配置有关的注意事项。有关更多详细信息，请参阅 HTTP/2 wiki 页面。

Servlet API 确实公开了一个与 HTTP/2 相关的构造。您可以使用 `jakarta.servlet.http.PushBuilder` 主动向客户端推送资源，并且它被支持作为 `@RequestMapping` 方法的方法参数。

# 2 REST 客户端

本节介绍客户端访问 REST 端点的选项。

## 2.1 RestTemplate

`RestTemplate` 是一个用于执行 HTTP 请求的同步客户端。它是最初的 Spring REST 客户端，并通过底层 HTTP 客户端库公开了一个简单的模板方法 API。

> 从 5.0 开始，`RestTemplate` 处于维护模式，只接受微小更改和错误的请求。请考虑使用 WebClient，它提供了更现代的 API，并支持同步、异步和流式传输场景。

有关详细信息，请参阅 REST 端点。

## 2.2 WebClient

WebClient 是一个非阻塞、响应式客户端，用于执行 HTTP 请求。它在 5.0 中引入，提供了 `RestTemplate` 的现代替代方案，有效支持同步和异步以及流媒体场景。

与 `RestTemplate` 相比，`WebClient` 支持以下功能：

- 非阻塞I/O。
- 反应式流背压。
- 硬件资源较少的高并发性。
- 函数式、流畅的 API，充分利用了 Java 8 lambdas。
- 同步和异步交互。
- 流式传输到服务器或从服务器流式传输。

有关详细信息，请参阅 WebClient。

## 2.3 HTTP 接口

Spring Frameworks 允许您将 HTTP 服务定义为具有 HTTP 交换方法的 Java 接口。然后，您可以生成一个实现该接口并执行交换的代理。这有助于简化 HTTP 远程访问，并为选择 API 样式（如同步或响应式）提供了额外的灵活性。

有关详细信息，请参阅 REST 端点。

# 3 测试

本节总结了 Spring MVC 应用程序 `spring-test` 中可用的选项。

- Servlet API 模拟：用于单元测试控制器、过滤器和其他 web 组件的 Servlet API 合同的模拟实现。有关更多详细信息，请参阅 Servlet API mock 对象。
- TestContext Framework：支持在 JUnit 和 TestNG 测试中加载 Spring 配置，包括跨测试方法高效缓存加载的配置，并支持使用 `MockServletContext` 加载 `WebApplicationContext`。有关更多详细信息，请参阅 TestContext Framework。
- Spring MVC 测试：一个框架，也称为 `MockMvc`，用于通过 `DispatcherServlet` 测试带注解的控制器（即支持注解），配有 Spring MVC 基础设施，但没有 HTTP 服务器。有关更多详细信息，请参阅 Spring MVC 测试。
- 客户端 REST: `spring-test` 提供了一个 `MockRestServiceServer`，您可以将其用作模拟服务器，用于测试内部使用 `RestTemplate` 的客户端代码。有关更多详细信息，请参阅客户端 REST 测试。
- `WebTestClient`：专为测试 WebFlux 应用程序而构建，但它也可以用于通过 HTTP 连接对任何服务器进行端到端集成测试。它是一个无阻塞、响应式的客户端，非常适合测试异步和流式场景。有关更多详细信息，请参阅 `WebTestClient`。

# 4 WebSockets

这部分参考文档涵盖了对 Servlet 栈的支持、包括原始 WebSocket 交互的 WebSocket 消息传递、通过 SockJS 的 WebSocket 仿真，以及通过 STOMP 作为 WebSocket 上的子协议发布订阅消息传递。

## 4.1 介绍 WebSocket

WebSocket 协议，RFC 6455，提供了一种标准化的方法，可以通过单个 TCP 连接在客户端和服务器之间建立全双工、双向的通信信道。它是一种不同于 HTTP 的 TCP 协议，但被设计为通过 HTTP 工作，使用端口 80 和 443，并允许重用现有的防火墙规则。

WebSocket 交互以 HTTP 请求开始，该请求使用 HTTP `Upgrade` 标头进行升级，或者在本例中切换到 WebSocket 协议。以下示例显示了这样的交互：

```yaml
GET /spring-websocket-portfolio/portfolio HTTP/1.1
Host: localhost:8080
Upgrade: websocket (1)
Connection: Upgrade (2)
Sec-WebSocket-Key: Uc9l9TMkWGbHFD2qnFHltg==
Sec-WebSocket-Protocol: v10.stomp, v11.stomp
Sec-WebSocket-Version: 13
Origin: http://localhost:8080
```

(1) `Upgrade` 标头。

(2) 使用 `Upgrade` 连接。

支持 WebSocket 的服务器返回类似于以下内容的输出，而不是通常的 200 状态代码：

```yaml
HTTP/1.1 101 Switching Protocols (1)
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: 1qVdfYHU9hPOl4JYYNXF623Gzn0=
Sec-WebSocket-Protocol: v10.stomp
```

(1) 协议切换

成功握手后，HTTP 升级请求的 TCP 套接字将保持打开状态，以便客户端和服务器继续发送和接收消息。

关于 WebSockets 如何工作的完整介绍超出了本文档的范围。请参阅 RFC 6455，HTML5 的 WebSocket 章节，或 Web 上的许多介绍和教程中的任何一个。

请注意，如果 WebSocket 服务器在 web 服务器（例如 nginx）后面运行，则可能需要对其进行配置，以便将 WebSocket 升级请求传递到 WebSocket server。同样，如果应用程序在云环境中运行，请检查云提供商与 WebSocket 支持相关的说明。

### 4.1.1 HTTP 对比 WebSocket

尽管 WebSocket 被设计为与 HTTP 兼容，并且从 HTTP 请求开始，但重要的是要理解这两种协议会导致非常不同的体系结构和应用程序编程模型。

在 HTTP 和 REST 中，应用程序被建模为多个 URL。为了与应用程序交互，客户端访问这些 URL，请求-响应样式。服务器根据 HTTP URL、方法和标头将请求路由到适当的处理程序。

相比之下，在 WebSockets 中，通常只有一个 URL 用于初始连接。随后，所有应用程序消息都在同一个 TCP 连接上流动。这指向一个完全不同的异步、事件驱动的消息传递体系结构。

WebSocket 也是一种低级传输协议，与 HTTP 不同，它不对消息的内容规定任何语义。这意味着，除非客户端和服务器在消息语义上达成一致，否则无法路由或处理消息。

WebSocket 客户端和服务器可以通过 HTTP 握手请求上的 `Sec-WebSocket-Protocol` 头协商使用更高级别的消息传递协议（例如 STOMP）。如果没有这一点，他们需要制定自己的惯例。

### 4.1.2 什么时候使用 WebSockets

WebSockets 可以使网页具有动态性和交互性。然而，在许多情况下，AJAX 和 HTTP 流或长轮询的组合可以提供简单有效的解决方案。

例如，新闻、邮件和社交订阅源需要动态更新，但每隔几分钟更新一次可能是完全可以的。另一方面，协作、游戏和金融应用程序需要更接近实时。

延迟本身并不是决定因素。如果消息量相对较低（例如，监视网络故障），HTTP 流或轮询可以提供有效的解决方案。低延迟、高频率和高容量的组合是使用 WebSocket 的最佳条件。

还要记住，在 Internet 上，您无法控制的限制性代理可能会阻止 WebSocket 交互，原因可能是它们没有配置为传递 `Upgrade` 标头，也可能是因为它们关闭了看起来空闲的长期连接。这意味着，将 WebSocket 用于防火墙内的内部应用程序比用于面向公众的应用程序更简单。

## 4.2 WebSocket API

Spring Framework 提供了一个 WebSocket API，您可以使用它来编写处理 WebSocket 消息的客户端和服务器端应用程序。

### 4.2.1 WebSocketHandler

创建 WebSocket 服务器就像实现 `WebSocketHandler` 一样简单，或者更可能的是扩展 `TextWebSocketHandler` 或 `BinaryWebSocketHandler`。以下示例使用 `TextWebSocketHandler`：

```java
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.TextMessage;

public class MyHandler extends TextWebSocketHandler {

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) {
        // ...
    }

}
```

有专门的 WebSocket Java 配置和 XML 命名空间支持，用于将前面的 WebSocket 处理程序映射到特定的 URL，如下例所示：

```java
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(myHandler(), "/myHandler");
    }

    @Bean
    public WebSocketHandler myHandler() {
        return new MyHandler();
    }

}
```

以下示例显示了与前面示例等效的 XML 配置：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:websocket="http://www.springframework.org/schema/websocket"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/websocket
        https://www.springframework.org/schema/websocket/spring-websocket.xsd">

    <websocket:handlers>
        <websocket:mapping path="/myHandler" handler="myHandler"/>
    </websocket:handlers>

    <bean id="myHandler" class="org.springframework.samples.MyHandler"/>

</beans>
```

前面的例子用于 SpringMVC 应用程序，应该包含在 `DispatcherServlet` 的配置中。然而，Spring 的 WebSocket 支持并不依赖于 Spring MVC。在 `WebSocketHttpRequestHandler` 的帮助下，将 `WebSocketHandler` 集成到其他 HTTP 服务环境中相对简单。

当直接或间接使用 `WebSocketHandler` API 时，例如通过 STOMP 消息传递，应用程序必须同步消息的发送，因为底层标准 WebSocket 会话（JSR-356）不允许并发发送。一种选择是用 `ConcurrentWebSocketSessionDecorator` 包装 `WebSocketSession`。

### 4.2.2 WebSocket 握手

自定义初始 HTTP WebSocket 握手请求的最简单方法是通过 `HandshakeInterceptor`，它公开握手之前和之后的方法。您可以使用这样的拦截器来排除握手或使任何属性可用于 `WebSocketSession`。以下示例使用内置的拦截器将 HTTP 会话属性传递给 WebSocket 会话：

```java
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(new MyHandler(), "/myHandler")
            .addInterceptors(new HttpSessionHandshakeInterceptor());
    }

}
```

以下示例显示了与前面示例等效的 XML 配置：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:websocket="http://www.springframework.org/schema/websocket"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/websocket
        https://www.springframework.org/schema/websocket/spring-websocket.xsd">

    <websocket:handlers>
        <websocket:mapping path="/myHandler" handler="myHandler"/>
        <websocket:handshake-interceptors>
            <bean class="org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor"/>
        </websocket:handshake-interceptors>
    </websocket:handlers>

    <bean id="myHandler" class="org.springframework.samples.MyHandler"/>

</beans>
```

一个更高级的选项是扩展 `DefaultHandshakeHandler`，它执行 WebSocket 握手的步骤，包括验证客户端来源、协商子协议以及其他细节。如果应用程序需要配置自定义 `RequestUpgradeStrategy` 以适应尚未支持的 WebSocket 服务器引擎和版本，则可能还需要使用此选项（有关此主题的更多信息，请参阅部署）。Java 配置和 XML 命名空间都可以配置自定义 `HandshakeHandler`。

> Spring 提供了一个 `WebSocketHandlerDecorator` 基类，您可以使用它来用其他行为装饰 `WebSocketHandler`。当使用 WebSocket Java 配置或 XML 命名空间时，默认情况下会提供和添加日志记录和异常处理实现。`ExceptionWebSocketHandlerRecorder` 捕获任何 `WebSocketHandler` 方法产生的所有未捕获的异常，并关闭状态为 `1011` 的 WebSocket 会话，这表示服务器错误。

### 4.2.3 部署

Spring WebSocket API 很容易集成到 Spring MVC 应用程序中，`DispatcherServlet` 同时为 HTTP WebSocket 握手和其他 HTTP 请求提供服务。通过调用 `WebSocketHttpRequestHandler` 也可以很容易地集成到其他 HTTP 处理场景中。这既方便又易于理解。然而，对于 JSR-356 运行时，需要特别注意。

Jakarta WebSocket API（JSR-356）提供了两种部署机制。第一个是在启动时进行 Servlet 容器类路径扫描（Servlet 3 的一个特性）。另一个是在 Servlet 容器初始化时使用的注册 API。这两种机制都不可能对所有 HTTP 处理使用单个“前端控制器” — 包括 WebSocket 握手和所有其他 HTTP 请求 — 例如 Spring MVC 的 `DispatcherServlet`。

这是 JSR-356 的一个重要限制，Spring 的 WebSocket 支持通过特定于服务器的 `RequestUpgradeStrategy` 实现来解决这个问题，即使在 JSR-356 运行时运行也是如此。Tomcat、Jetty、GlassFish、WebLogic、WebSphere 和 Undertow（以及WildFly）目前都有这样的策略。从 Jakarta WebSocket 2.1 开始，Spring 可以在基于 Jakarta EE 10 的 web 容器（如 Tomcat 10.1 和 Jetty 12）上选择标准请求升级策略。

第二个考虑因素是，支持 JSR-356 的 Servlet 容器预计将执行 `ServletContainerInitializer`（SCI）扫描，这可能会减慢应用程序的启动速度 — 在某些情况下，是戏剧性的。如果在升级到支持 JSR-356 的 Servlet 容器版本后观察到重大影响，那么应该可以通过使用 `web.xml` 中的 `<absolute-ordering/>` 元素来选择性地启用或禁用 web 片段（和 SCI 扫描），如下例所示：

```xml
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        https://jakarta.ee/xml/ns/jakartaee
        https://jakarta.ee/xml/ns/jakartaee/web-app_5_0.xsd"
    version="5.0">

    <absolute-ordering/>

</web-app>
```

然后，您可以按名称选择性地启用 web 片段，例如 Spring 自己的 `SpringServletContainerInitializer`，它提供了对 Servlet 3 Java 初始化 API 的支持。以下示例显示了如何执行此操作：

```xml
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        https://jakarta.ee/xml/ns/jakartaee
        https://jakarta.ee/xml/ns/jakartaee/web-app_5_0.xsd"
    version="5.0">

    <absolute-ordering>
        <name>spring_web</name>
    </absolute-ordering>

</web-app>
```

### 4.2.4 服务器配置

每个底层 WebSocket 引擎都公开控制运行时特征的配置属性，例如消息缓冲区大小、空闲超时等。

对于 Tomcat、WildFly 和 GlassFish，您可以将 `ServletServerContainerFactoryBean` 添加到WebSocket Java配置中，如下例所示：

```java
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Bean
    public ServletServerContainerFactoryBean createWebSocketContainer() {
        ServletServerContainerFactoryBean container = new ServletServerContainerFactoryBean();
        container.setMaxTextMessageBufferSize(8192);
        container.setMaxBinaryMessageBufferSize(8192);
        return container;
    }

}
```

以下示例显示了与前面示例等效的 XML 配置：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:websocket="http://www.springframework.org/schema/websocket"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/websocket
        https://www.springframework.org/schema/websocket/spring-websocket.xsd">

    <bean class="org.springframework...ServletServerContainerFactoryBean">
        <property name="maxTextMessageBufferSize" value="8192"/>
        <property name="maxBinaryMessageBufferSize" value="8192"/>
    </bean>

</beans>
```

> 对于客户端 WebSocket 配置，您应该使用 `WebSocketContainerFactoryBean`（XML）或 `ContainerProvider.getWebSocketContent()`（Java配置）。

对于 Jetty，您需要提供一个预先配置的 Jetty `WebSocketServerFactory`，并通过 WebSocket Java 配置将其插入 Spring 的 `DefaultHandshakeHandler`。以下示例显示了如何执行此操作：

```java
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(echoWebSocketHandler(),
            "/echo").setHandshakeHandler(handshakeHandler());
    }

    @Bean
    public DefaultHandshakeHandler handshakeHandler() {

        WebSocketPolicy policy = new WebSocketPolicy(WebSocketBehavior.SERVER);
        policy.setInputBufferSize(8192);
        policy.setIdleTimeout(600000);

        return new DefaultHandshakeHandler(
                new JettyRequestUpgradeStrategy(new WebSocketServerFactory(policy)));
    }

}
```

以下示例显示了与前面示例等效的 XML 配置：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:websocket="http://www.springframework.org/schema/websocket"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/websocket
        https://www.springframework.org/schema/websocket/spring-websocket.xsd">

    <websocket:handlers>
        <websocket:mapping path="/echo" handler="echoHandler"/>
        <websocket:handshake-handler ref="handshakeHandler"/>
    </websocket:handlers>

    <bean id="handshakeHandler" class="org.springframework...DefaultHandshakeHandler">
        <constructor-arg ref="upgradeStrategy"/>
    </bean>

    <bean id="upgradeStrategy" class="org.springframework...JettyRequestUpgradeStrategy">
        <constructor-arg ref="serverFactory"/>
    </bean>

    <bean id="serverFactory" class="org.eclipse.jetty...WebSocketServerFactory">
        <constructor-arg>
            <bean class="org.eclipse.jetty...WebSocketPolicy">
                <constructor-arg value="SERVER"/>
                <property name="inputBufferSize" value="8092"/>
                <property name="idleTimeout" value="600000"/>
            </bean>
        </constructor-arg>
    </bean>

</beans>
```

### 4.2.5 允许的来源

从 Spring Framework 4.1.5 开始，WebSocket 和 SockJS 的默认行为是只接受同源请求。也可以允许所有或指定的起源列表。此检查主要是为浏览器客户端设计的。没有什么可以阻止其他类型的客户端修改 `Origin` 头值（更多详细信息，请参阅RFC 6454：Web Origin 概念）。

三种可能的行为是：

- 仅允许相同的来源请求（默认值）：在此模式下，当 SockJS 启用时，Iframe  HTTP 响应标头 `X-Frame-Options` 设置为 `SAMEORIGIN`，并且 JSONP 传输被禁用，因为它不允许检查请求的来源。因此，当启用此模式时，不支持 IE6 和 IE7。
- 允许指定的来源列表：每个允许的来源必须以 `http://` 或 `https://` 开头。在这种模式下，当 SockJS 被启用时，IFrame 传输被禁用。因此，当启用此模式时，不支持 IE6 到 IE9。
- 允许所有来源：要启用此模式，您应该提供 `*` 作为允许的原点值。在此模式下，所有传输都可用。

您可以配置 WebSocket 和 SockJS 允许的起源，如下例所示：

```java
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(myHandler(), "/myHandler").setAllowedOrigins("https://mydomain.com");
    }

    @Bean
    public WebSocketHandler myHandler() {
        return new MyHandler();
    }

}
```

以下示例显示了与前面示例等效的 XML 配置：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:websocket="http://www.springframework.org/schema/websocket"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/websocket
        https://www.springframework.org/schema/websocket/spring-websocket.xsd">

    <websocket:handlers allowed-origins="https://mydomain.com">
        <websocket:mapping path="/myHandler" handler="myHandler" />
    </websocket:handlers>

    <bean id="myHandler" class="org.springframework.samples.MyHandler"/>

</beans>
```

## 4.3 SockJS 回退

在公共 Internet 上，您无法控制的限制性代理可能会阻止 WebSocket 交互，原因可能是它们没有配置为传递 `Upgrade` 标头，也可能是因为它们关闭了看似空闲的长期连接。

这个问题的解决方案是 WebSocket 仿真 — 也就是说，先尝试使用 WebSocket，然后依靠基于 HTTP 的技术来模拟 WebSocket 交互并公开相同的应用程序级 API。

在 Servlet 栈上，Spring Framework 为 SockJS 协议提供了服务器（以及客户端）支持。

### 4.3.1 总览

SockJS 的目标是让应用程序使用 WebSocket API，但在运行时必要时可以使用非 WebSocket 替代方案，而无需更改应用程序代码。

SockJS 包括：

- 以可执行叙述测试的形式定义的 SockJS 协议。
- SockJS JavaScript 客户端 — 用于浏览器的客户端库。
- SockJS 服务器实现，包括 Spring Framework `spring-websocket` 模块中的一个。
- `spring-websocket` 模块中的 SockJS Java 客户端（自 4.1 版起）。

SockJS 是为在浏览器中使用而设计的。它使用各种技术来支持各种各样的浏览器版本。有关 SockJS 传输类型和浏览器的完整列表，请参阅 SockJS 客户端页面。传输分为三大类：WebSocket、HTTP 流式传输和 HTTP 长轮询。有关这些类别的概述，请参阅此博客文章。

SockJS 客户端首先发送 `GET/info` 以从服务器获取基本信息。在那之后，它必须决定使用什么传输工具。如果可能的话，使用 WebSocket。如果没有，在大多数浏览器中，至少有一个 HTTP 流选项。如果没有，则使用 HTTP （长）轮询。

所有传输请求都具有以下 URL 结构：

```
https://host:port/myApp/myEndpoint/{server-id}/{session-id}/{transport}
```

其中：

- `{server-id}` 对于在集群中路由请求很有用，但在其他情况下不会使用。
- `{session-id}` 关联属于 SockJS 会话的 HTTP 请求。
- `{transport}` 表示传输类型（例如，`websocket`、`xhr-streaming` 和其他）。

WebSocket 传输只需要一个 HTTP 请求就可以进行 WebSocket 握手。此后的所有消息都在该套接字上进行交换。

HTTP 传输需要更多的请求。例如，Ajax/XHR 流依赖于一个针对服务器到客户端消息的长时间运行的请求，以及针对客户端到服务器消息的额外 HTTP POST 请求。长轮询是类似的，只是它在每个服务器到客户端发送后结束当前请求。

SockJS 添加了最小的消息框架。例如，服务器最初发送字母 `o`（“打开”帧），消息以 `a["message1"、“message2”]`（JSON 编码数组）的形式发送，如果 25 秒内没有消息流动（默认情况下），则发送字母 `h`（“心跳”帧）；关闭会话时发送字母 `c`（“关闭”帧）。

要了解更多信息，请在浏览器中运行一个示例并查看 HTTP 请求。SockJS 客户端允许修复传输列表，因此可以一次看到一个传输。SockJS 客户端还提供了一个调试标志，它可以在浏览器控制台中启用有用的消息。在服务器端，您可以为 `org.springframework.web.socket` 启用 `TRACE` 日志记录。有关更多详细信息，请参阅 SockJS 协议叙述测试。

### 4.3.2 启用 SockJS

您可以通过 Java 配置启用 SockJS，如下例所示：

```java
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(myHandler(), "/myHandler").withSockJS();
    }

    @Bean
    public WebSocketHandler myHandler() {
        return new MyHandler();
    }

}
```

以下示例显示了与前面示例等效的 XML 配置：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:websocket="http://www.springframework.org/schema/websocket"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/websocket
        https://www.springframework.org/schema/websocket/spring-websocket.xsd">

    <websocket:handlers>
        <websocket:mapping path="/myHandler" handler="myHandler"/>
        <websocket:sockjs/>
    </websocket:handlers>

    <bean id="myHandler" class="org.springframework.samples.MyHandler"/>

</beans>
```

前面的例子用于 SpringMVC 应用程序，应该包含在 `DispatcherServlet` 的配置中。然而，Spring 的 WebSocket 和 SockJS 支持并不依赖于 Spring MVC。借助 `SockJsHttpRequestHandler` 集成到其他 HTTP 服务环境中相对简单。

在浏览器端，应用程序可以使用 `sockjs-client`（版本1.0.x）。它模拟 W3C WebSocket API，并与服务器通信，根据运行的浏览器选择最佳传输选项。请参阅 sockjs-client 页面和浏览器支持的传输类型列表。客户端还提供了几个配置选项 — 例如指定要包括哪些传输。

### 4.3.3 IE 8 和 9

Internet Explorer 8 和 9 仍在使用中。它们是拥有 SockJS 的一个关键原因。本节介绍了在这些浏览器中运行的重要注意事项。

SockJS 客户端通过使用 Microsoft 的 `XDomainRequest` 在 IE 8 和 9 中支持 Ajax/XHR 流。这可以跨域工作，但不支持发送 cookie。Cookie 对于 Java 应用程序来说通常是必不可少的。然而，由于 SockJS 客户端可以与许多服务器类型（而不仅仅是 Java 服务器类型）一起使用，因此它需要知道 cookie 是否重要。如果是这样，那么 SockJS 客户端更喜欢 Ajax/XHR 进行流式传输。否则，它依赖于基于 iframe 的技术。

来自 SockJS 客户端的第一个 `/info` 请求是对可能影响客户端选择传输的信息的请求。其中一个细节是服务器应用程序是否依赖 cookie（例如，用于身份验证或使用粘性会话进行集群）。Spring 的 SockJS 支持包括一个名为 `sessionCookieNeeded` 的属性。它在默认情况下是启用的，因为大多数 Java 应用程序都依赖于 `JSESSIONID` cookie。如果你的应用程序不需要它，你可以关闭这个选项，然后 SockJS 客户端应该在 IE 8 和 9 中选择 `xdr-streaming`。

如果您确实使用基于 iframe 的传输，请记住，可以指示浏览器通过将 HTTP 响应标头 `X-Frame-Options` 设置为 `DENY`、`SAMEORIGIN` 或 `ALLOW-FROM <origin>` 来阻止在给定页面上使用 iframe。这是用来防止点击劫持的。

> Spring Security 3.2+ 支持在每个响应上设置 `X-Frame-Options`。默认情况下，Spring Security Java 配置将其设置为 `DENY`。在 3.2 中，Spring Security XML 命名空间默认不设置该标头，但可以配置为这样做。将来，它可能会默认设置该标头。
>
> 有关如何配置 `X-Frame-Options` 标头设置的详细信息，请参阅 Spring Security 文档的 Default Security Headers。你也可以看到 gh-2718 的额外背景。

如果您的应用程序添加了 `X-Frame-Options` 响应标头（应该如此！）并依赖于基于 iframe 的传输，则需要将标头值设置为 `SAMEORIGIN` 或 `ALLOW-FROM <origin>`。Spring SockJS 支持还需要知道 SockJS 客户端的位置，因为它是从 iframe 加载的。默认情况下，iframe 设置为从 CDN 位置下载 SockJS 客户端。将此选项配置为使用与应用程序来源相同的 URL 是一个好主意。

以下示例显示了如何在 Java 配置中执行此操作：

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/portfolio").withSockJS()
                .setClientLibraryUrl("http://localhost:8080/myapp/js/sockjs-client.js");
    }

    // ...

}
```

XML 命名空间通过 `<websocket:sockjs>` 元素提供了类似的选项。

> 在初始开发过程中，请启用 SockJS 客户端开发模式，以防止浏览器缓存原本会缓存的 SockJS 请求（如 iframe）。有关如何启用它的详细信息，请参阅 SockJS 客户端页面。

### 4.3.4 心跳

SockJS 协议要求服务器发送心跳消息，以防止代理得出连接挂起的结论。Spring SockJS 配置有一个名为 `heartbeatTime` 的属性，您可以使用它来自定义频率。默认情况下，心跳会在 25 秒后发送，假设该连接上没有发送其他消息。这个 25 秒的值符合 IETF 针对公共互联网应用的以下建议。

> 在 WebSocket 和 SockJS 上使用 STOMP 时，如果 STOMP 客户端和服务器协商要交换的检测信号，则 SockJS 检测信号将被禁用。

Spring SockJS 支持还允许您配置 `TaskScheduler` 来安排检测信号任务。任务调度程序由线程池支持，默认设置基于可用处理器的数量。您应该考虑根据您的具体需求自定义设置。

### 4.3.5 客户端断连

HTTP 流和 HTTP 长轮询 SockJS 传输要求连接保持打开的时间比平时更长。有关这些技术的概述，请参阅这篇博客文章。

在 Servlet 容器中，这是通过 Servlet 3 异步支持实现的，该异步支持允许退出 Servlet 容器线程，处理请求，并继续从另一个线程写入响应。

一个特定的问题是 Servlet API 不会为已经离开的客户端提供通知。请参阅 eclipse-ee4j/servlet-api#44。但是，Servlet 容器在随后尝试写入响应时会引发异常。由于 Spring 的 SockJS 服务支持服务器发送的检测信号（默认情况下每 25 秒一次），这意味着通常会在该时间段内检测到客户端断开连接（如果消息发送频率更高，则会更早）。

> 因此，由于客户端已断开连接，可能会发生网络 I/O 故障，这可能会在日志中填充不必要的堆栈跟踪。Spring 尽最大努力识别代表客户端断开连接（特定于每台服务器）的此类网络故障，并使用专用日志类别 `DISCONNECTED_CLIENT_LOG_CATEGORY`（在 `AbstractSockJsSession` 中定义）记录最小消息。如果需要查看堆栈跟踪，可以将该日志类别设置为 TRACE。

### 4.3.6 SockJS 和 CORS

如果允许跨域请求（请参阅允许的源），SockJS 协议将使用 CORS 在 XHR 流和轮询传输中提供跨域支持。因此，除非检测到响应中存在 CORS 标头，否则会自动添加 CORS 标头。因此，如果应用程序已经配置为提供 CORS 支持（例如，通过 Servlet Filter），Spring 的 `SockJsService` 将跳过这一部分。

也可以通过在 Spring 的 SockJsService 中设置 `suppressCors` 属性来禁用这些 CORS 头的添加。

SockJS 需要以下标头和值：

- `Access-Control-Allow-Origin`：根据 `Origin` 请求标头的值初始化。
- `Access-Control-Allow-Credentials`：始终设置为 `true`。
- `Access-Control-Request-Headers`：从等效请求标头中的值初始化。
- `Access-Control-Allow-Methods`：传输支持的 HTTP 方法（请参阅 `TransportType` 枚举）。
- `Access-Control-Max-Age`：设置为 31536000（1 年）。

有关确切的实现，请参阅 `AbstractSockJsService` 中的 `addCorsHeaders` 和源代码中的 `TransportType` 枚举。

或者，如果 CORS 配置允许，可以考虑排除带有 SockJS 端点前缀的 URL，从而让 Spring 的 `SockJsService` 处理它。

### 4.3.7 SockJsClient

Spring 提供了一个 SockJS Java 客户端，可以在不使用浏览器的情况下连接到远程 SockJS 端点。当需要在公共网络上的两个服务器之间进行双向通信时（即，网络代理可以排除 WebSocket 协议的使用），这可能特别有用。SockJS Java 客户端对于测试目的也非常有用（例如，模拟大量并发用户）。

SockJS Java 客户端支持 `websocket`、`xhr-streaming` 和 `xhr-polling` 传输。剩下的只有在浏览器中使用才有意义。

您可以使用以下配置 `WebSocketTransport`：

- JSR-356 运行时中的 `StandardWebSocketClient`。
- `JettyWebSocketClient` 通过使用 Jetty 9+ 本地 WebSocket API。
- Spring 的 `WebSocketClient` 的任何实现。

根据定义，`XhrTransport` 同时支持 `xhr-streaming` 和 `xhr-polling`，因为从客户端的角度来看，除了用于连接服务器的 URL 之外，没有其他区别。目前有两种实现方式：

- `RestTemplateXhrTransport` 将 Spring 的 `RestTemplate` 用于 HTTP 请求。
- `JettyXhrTransport` 使用 Jetty 的 `HttpClient` 进行 HTTP 请求。

以下示例显示了如何创建 SockJS 客户端并连接到 SockJS 端点：

```java
List<Transport> transports = new ArrayList<>(2);
transports.add(new WebSocketTransport(new StandardWebSocketClient()));
transports.add(new RestTemplateXhrTransport());

SockJsClient sockJsClient = new SockJsClient(transports);
sockJsClient.doHandshake(new MyWebSocketHandler(), "ws://example.com:8080/sockjs");
```

> SockJS 对消息使用 JSON 格式的数组。默认情况下，使用 Jackson 2，并且需要位于类路径上。或者，您可以配置 `SockJsMessageCodec` 的自定义实现，并在 `SockJsClient` 上进行配置。

要使用 SockJsClient 模拟大量并发用户，您需要配置底层 HTTP 客户端（用于 XHR 传输）以允许足够数量的连接和线程。以下示例显示了如何使用 Jetty 执行此操作：

```java
HttpClient jettyHttpClient = new HttpClient();
jettyHttpClient.setMaxConnectionsPerDestination(1000);
jettyHttpClient.setExecutor(new QueuedThreadPool(1000));
```

以下示例显示了服务器端 SockJS 相关的财产（有关详细信息，请参阅 javadoc），您还应该考虑自定义这些属性：

```java
@Configuration
public class WebSocketConfig extends WebSocketMessageBrokerConfigurationSupport {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/sockjs").withSockJS()
            .setStreamBytesLimit(512 * 1024) (1)
            .setHttpMessageCacheSize(1000) (2)
            .setDisconnectDelay(30 * 1000); (3)
    }

    // ...
}

// (1) 将 `streamBytesLimit` 属性设置为 512KB（默认值为 128KB — 128 * 1024).
// (2) 将 `httpMessageCacheSize` 属性设置为 1000（默认值为 100）。
// (3) 将 `disconnectDelay` 属性设置为 30 属性秒（默认值为 5 秒 — 5 * 1000).
```

## 4.4 STOMP

WebSocket 协议定义了两种类型的消息（文本和二进制），但它们的内容是未定义的。该协议定义了一种机制，让客户端和服务器协商一个子协议（即更高级别的消息传递协议），在 WebSocket 之上使用该协议来定义每个消息可以发送什么类型的消息、格式是什么、每个消息的内容等等。子协议的使用是可选的，但无论哪种方式，客户端和服务器需要就一些定义消息内容的协议达成一致。

### 4.4.1 总览

STOMP（简单面向文本的消息传递协议）最初是为脚本语言（如 Ruby、Python 和 Perl）创建的，用于连接到企业消息代理。它旨在解决常用消息传递模式的最小子集。STOMP 可以通过任何可靠的双向流网络协议使用，如 TCP 和 WebSocket。尽管 STOMP 是一个面向文本的协议，但消息有效载荷可以是文本的，也可以是二进制的。

STOMP 是一种基于帧的协议，其帧以 HTTP 为模型。以下列表显示了 STOMP 框架的结构：

```
COMMAND
header1:value1
header2:value2

Body^@
```

客户端可以使用 `SEND` 或 `SUBSCRIBE` 命令发送或订阅消息，以及描述消息内容和接收对象的 `destination` 标头。这启用了一个简单的发布-订阅机制，您可以使用该机制通过代理向其他连接的客户端发送消息，或向服务器发送消息，请求执行某些工作。

当您使用 Spring 的 STOMP 支持时，Spring WebSocket 应用程序充当客户端的 STOMP 代理。消息被路由到 `@Controller` 消息处理方法或一个简单的内存代理，该代理跟踪订阅并向订阅的用户广播消息。您还可以将 Spring 配置为使用专用的 STOMP 代理（如 RabbitMQ、ActiveMQ 和其他代理）来进行消息的实际广播。在这种情况下，Spring 维护到代理的 TCP 连接，将消息中继到代理，并将消息从代理传递到连接的 WebSocket 客户端。因此，Spring web 应用程序可以依赖于统一的基于 HTTP 的安全性、通用验证和熟悉的消息处理编程模型。

以下示例显示了订阅以接收股票报价的客户端，服务器可能会定期发出股票报价（例如，通过一个调度任务，该任务通过 `SimpMessagingTemplate` 向经纪人发送消息）：

```
SUBSCRIBE
id:sub-1
destination:/topic/price.stock.*

^@
```

以下示例显示了一个发送交易请求的客户端，服务器可以通过 `@MessageMapping` 方法处理该请求：

```
SEND
destination:/queue/trade
content-type:application/json
content-length:44

{"action":"BUY","ticker":"MMM","shares",44}^@
```

执行之后，服务器可以向客户端广播交易确认消息和详细信息。

目的地的含义在 STOMP 规范中故意保持不透明。它可以是任何字符串，完全由 STOMP 服务器来定义它们支持的目的地的语义和语法。然而，目的地通常是像路径一样的字符串，其中 `/topic/..` 暗示发布-订阅（一对多）和 `/queue/` 暗示点对点（一对一）消息交换。

STOMP 服务器可以使用 `MESSAGE` 命令向所有订阅者广播消息。以下示例显示了一个服务器向订阅的客户端发送股票报价：

```
MESSAGE
message-id:nxahklf6-1
subscription:sub-1
destination:/topic/price.stock.MMM

{"ticker":"MMM","price":129.45}^@
```

服务器无法发送未经请求的消息。来自服务器的所有消息都必须响应特定的客户端订阅，并且服务器消息的 `subscription` 标头必须与客户端订阅的 `id` 标头匹配。

上述概述旨在提供对 STOMP 协议的最基本理解。我们建议全面审查协议规范。

### 4.4.2 优势

与使用原始 WebSockets 相比，使用 STOMP 作为子协议可以让 Spring Framework 和 Spring Security 提供更丰富的编程模型。关于 HTTP 与原始 TCP 以及它如何让 SpringMVC 和其他 web 框架提供丰富的功能，也可以提出同样的观点。以下是好处列表：

- 无需发明自定义消息传递协议和消息格式。
- STOMP 客户端，包括 Spring Framework 中的 Java 客户端，都是可用的。
- 您可以（可选）使用消息代理（如 RabbitMQ、ActiveMQ 和其他）来管理订阅和广播消息。
- 应用程序逻辑可以组织在任意数量的 `@Controller` 实例中，消息可以基于 STOMP 目的地标头路由到它们，而不是使用给定连接的单个 `WebSocketHandler` 处理原始 WebSocket 消息。
- 您可以使用 Spring Security 来保护基于 STOMP 目的地和消息类型的消息。

### 4.4.3 启用 STOMP

`spring-messaging` 和 `spring-websocket` 模块中提供了基于 WebSocket 的 STOMP 支持。一旦有了这些依赖项，就可以通过 SockJS Fallback 在 WebSocket 上公开 STOMP 端点，如下例所示：

```java
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/portfolio").withSockJS(); (1)
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.setApplicationDestinationPrefixes("/app"); (2)
        config.enableSimpleBroker("/topic", "/queue"); (3)
    }
}
// (1) `/portfolio` 是 WebSocket（或 SockJS）客户端需要连接到的端点的 HTTP URL，以便进行 WebSocket 握手。
// (2) 目标标头以 `/app` 开头的 STOMP 消息被路由到 `@Controller` 类中的 `@MessageMapping` 方法。
// (3) 使用内置消息代理进行订阅和广播，并将目标标头以 `/topic` 或 `/queue` 开头的消息路由到代理。
```

以下示例显示了与前面示例等效的 XML 配置：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:websocket="http://www.springframework.org/schema/websocket"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/websocket
        https://www.springframework.org/schema/websocket/spring-websocket.xsd">

    <websocket:message-broker application-destination-prefix="/app">
        <websocket:stomp-endpoint path="/portfolio">
            <websocket:sockjs/>
        </websocket:stomp-endpoint>
        <websocket:simple-broker prefix="/topic, /queue"/>
    </websocket:message-broker>

</beans>
```

> 对于内置的简单代理，`/topic` 和 `/queue` 前缀没有任何特殊含义。它们只是区分 pub-sub 和点对点消息传递（即，多个订户和一个消费者）的一种惯例。当您使用外部 broker 时，请查看 broker 的 STOMP 页面，以了解它支持什么类型的 STOMP 目的地和前缀。

要从浏览器进行连接，对于 SockJS，您可以使用 SockJS 客户端。对于 STOMP，许多应用程序都使用了 jmesnil/stomp-websocket 库（也称为 stomp.js），该库功能齐全，已在生产中使用多年，但不再维护。目前，JSteunou/webstomp-client 是该库维护最积极、发展最快的继任者。以下示例代码基于此：

```javascript
var socket = new SockJS("/spring-websocket-portfolio/portfolio");
var stompClient = webstomp.over(socket);

stompClient.connect({}, function(frame) {
}
```

或者，如果您通过 WebSocket（不带 SockJS）进行连接，则可以使用以下代码：

```javascript
var socket = new WebSocket("/spring-websocket-portfolio/portfolio");
var stompClient = Stomp.over(socket);

stompClient.connect({}, function(frame) {
}
```

请注意，前面示例中的 `stompClient` 不需要指定 `login` 和 `passcode` 头。即使是这样，它们也会在服务器端被忽略（或者更确切地说，被覆盖）。有关身份验证的更多信息，请参阅连接到 Broker 和身份验证。

有关更多示例代码，请参阅：

- 使用 WebSocket 构建交互式 web 应用程序 — 入门指南。
- 股票投资组合 — 示例应用程序。

### 4.4.4 WebSocket 服务器

要配置底层 WebSocket 服务器，请应用“服务器配置”中的信息。然而，对于 Jetty，您需要通过 `StompEndpointRegistry` 设置 `HandshakeHandler` 和 `WebSocketPolicy`：

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/portfolio").setHandshakeHandler(handshakeHandler());
    }

    @Bean
    public DefaultHandshakeHandler handshakeHandler() {

        WebSocketPolicy policy = new WebSocketPolicy(WebSocketBehavior.SERVER);
        policy.setInputBufferSize(8192);
        policy.setIdleTimeout(600000);

        return new DefaultHandshakeHandler(
                new JettyRequestUpgradeStrategy(new WebSocketServerFactory(policy)));
    }
}
```

### 4.4.5 信息流
