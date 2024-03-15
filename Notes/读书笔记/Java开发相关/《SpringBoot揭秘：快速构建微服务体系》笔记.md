# SpringBoot揭秘 快速构建微服务体系

# 第1章 了解微服务

## 1.2 微服务因何而生

总的来说，一方面微服务可以帮助我们应对飙升的系统复杂度;另一方面，微服务可以帮助我们进行更大范围的拓展，从开发阶段项目并行开发的扩展，到交付阶段并行交付的扩展，再到相应的组织结构和组织能力的扩展，皆因微服务而受惠。

## 1.3 微服务会带来哪些好处

### 1.3.1 独立，独立，还是独立

首先，在开发层面，每个微服务基本上都是各自独立的项目（project），而对应各自独立项目的研发团队基本上也是独立对应，这样的结构保证了微服务的并行研发，并且各自快速迭代，不会因为所有研发都投入一个近乎单点的项目，从而造成开发阶段的瓶颈。开发阶段的独立，保证了微服务的研发可以高效进行。

服务开发期间的形态，跟服务交付期间的形态原则上是不需要高度统一的，即使我们在开发的时候都是各自进行，但交付的时候还是可以一起交付，不过这不是微服务的做法。在微服务治理体系下，各个微服务交付期间也是各自独立交付的，从而使得每个微服务从开发到交付整条链路上都是独立进行，这大大加快了微服务的迭代和交付效率。

服务交付之后需要部署运行，对微服务来说，它们运行期间也是各自独立的。

微服务独立运行可以带来两个比较明显的好处，第一个就是可扩展性。我们可以快速地添加服务集群地实例，提升整个微服务集群的服务能力，而在传统Monolith模式下，为了能够提升服务能力，很多时候必须强化和扩展单一结点的服务能力来达成。如果单结点服务能力已经扩展到了极限，再寻求扩展的话，就得从软件到硬件整体进行重构。

软件行业有句话：“Threads don't scale, Processes do!”，很明确地道出了原来Monolith服务与微服务再扩展（Scale）层面的差异。

对于Java开发者来说，早些年（当然现在也依然存在），我们遵循JavaEE规范开发的Web应用，都需要以WAR包的形式部署到TOMCAT、Jetty、RESIN等Web容器中运行，即使每个WAR包提供的都是独立的微服务，但因为它们都是统一部署运行在一个Web容器中，所以扩展能力受限于Web容器作为一个进程（process）的现状。无论如何调整Web容器内部实现的线程（thread）设置，还是会受限于Web容器整体的扩展能力。所以，现在很多情况下，大家都是一个TOMCAT只部署一个WAR，然后通过复制和扩展多个TOMCAT实例来扩展整个应用服务集群。

当然，说到在TOMCAT实例中只部署一个WAR包这样的做法，实际上不单单只是因为扩展的因素，还涉及微服务运行期间给我们带来的第二个好处，即隔离性。

### 1.3.2 多语言生态

## 1.4 微服务会带来哪些挑战

服务“微”化之后，一个显著的特点就是服务的数量增多了。

要实施高效可重复的标准化微服务生产，我们需要有类似传统行业生产线的基础设施。否则，高效可重复的开发和交付大量的微服务就无从谈起，所以，完备的微服务研发和交付体系基础设施建设就成为了实施微服务的终极挑战。一个公司或者组织要很好地或者说成熟地实施微服务化战略，为交付链路提供完备支撑地基础设施建设必不可少！

# 第2章 饮水思源：回顾与探索Spring框架地本质

## 2.1 Spring框架的起源

## 2.2 Spring IoC其实很简单

有部分Java开发者对IoC（Inversion Of Control）和DI（Dependency Injection）的概念有些混淆，认为两者是对等的，实际上我在之前的著作中已经说过了，IoC其实有两种方式，一种都是DI，而另一种是DL，即Dependency Lookup（依赖查找），前者是当前软件实体被动接受其依赖的其他组件被IoC容器注入，而后者则是当前软件实体主动去某个服务注册地查找其依赖的那些服务。

我们通常提到的 Spring IoC，实际上是指Spring框架提供的IoC容器实现，而使用Spring IoC容器的一个典型代码片段就是：

```java
public class App{
    public static void main(String[] args){
        ApplicationContext context = new FileSystemXmlApplicationContext("...");
        // ...
        MockService service = context.getBean(MockService.class);
        service.doSomething();
    }
}
```

任何一个使用Spring框架构建的独立的Java应用（Standalone Java Application），通常都会存在一行类似于"context.getBean(..);"的代码，实际上，这行代码做的就是DL的工作，而构建的任何一种IoC容器背后（比如BeanFactory或者ApplicationContext）发生的事情，则更多是DI的过程（也可能有部分DL的逻辑用于对接遗留系统）。

Spring IoC容器的依赖注入工作可以分为两个阶段：

**阶段一：收集和注册**

第一阶段可以认为是构建和收集bean定义的阶段，在这个阶段中，我们可以通过XML或者Java代码的方式定义一些bean，然后通过手动组装或者让容器基于某些机制自动扫描的形式，将这些bean定义收集到IoC容器中。

假设我们以XML配置的形式来收集并注册单一bean，一般形式如下：

~~~xml
<bean id="mockService" class="..MockServiceImpl">
    ...
</bean>
~~~

如果嫌逐个收集bean定义麻烦，想批量地收集并注册到IoC容器中，我们也可以通过XML Schema形式的配置进行批量扫描并采集和注册：
~~~xml
<context:component-scan base-package="com.keevol">
~~~

**阶段二：分析和组装**

当第一阶段工作完成后，我们可以先暂且认为IoC容器中充斥着一个个独立的bean，它们之间没有任何关系。但实际上，它们之间是有依赖关系的，所以，IoC容器在第二阶段要干的事情就是分析这些已经在IoC容器之中的bean，然后根据它们之间的依赖关系先后组装它们。如果IoC容器发现某个bean依赖另一个bean，它就会将这另一个bean注入给依赖它的那个bean，直到所有bean的依赖都注入完成，所有bean都”整装待发“，整个IoC容器的工作即算完成。

至于分析和组装的依据，Spring框架最早是通过XML配置文件的形式来描述bean与bean之间的关系的，随着Java业界研发技术和理念的转变，基于Java代码和Annotation元信息的描述方式也日渐兴盛（比如@Autowired和@Inject），但不管使用哪种方式，都只是为了简化绑定逻辑描述的各种”表象“，最终都是为本阶段的最终目的服务。

> 很多Java开发者一定认为Spring的XML配置文件是一种配置（Configuration），但本质上，这些配置文件更应该是一种代码形式，XML在这里其实可以看作一种DSL，它用来表述的是bean与bean之间的依赖绑定关系，诸君还记得没有IoC容器的年代要自己写代码新建（new）对象并配置（set）依赖的吧？

## 2.3 了解一点儿JavaConfig

Java 5 的推出，加上当年基于纯Java Annotation的依赖注入框架Guice的出现，使得Spring框架及其社区也”顺应民意“，推出并持续完善了基于Java的代码和Annotation元信息的依赖关系绑定描述方式，即JavaConfig项目。

基于JavaConfig方式的依赖关系绑定描述基本上映射了最早的基于XML的配置方式，比如：

（1）表达形式层面

基于XML的配置方式是这样的：

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:context="http://www.springframework.org/schema/context"
        xsi:schemaLocation="http://www.springframework.org/schema/beans 
                            http://www.springframework.org/schema/beans/spring-beans.xsd 
                            http://www.springframework.org/schema/context 
                            http://www.springframework.org/schema/context/spring-context.xsd">
    <!-- bean 定义 -->
</beans>
~~~

而基于JavaConfig的配置方式是这样的：

~~~java
@Configuration
public class MockConfiguration{
    // bean 定义
}
~~~

任何一个标注了 @Configuration 的Java类定义都是一个JavaConfig配置类。

（2）注册bean定义层面

基于XML的配置形式是这样的：
~~~xml
<bean id="mockService" class="..MockServiceImpl">
    ...
</bean>
~~~

而基于JavaConfig的配置形式是这样的：
~~~java
@Configuration
public class MockConfiguration {
    @Bean
    public MockService mockService() {
        return new MockServiceImpl();
    }
}
~~~

任何一个标注了@Bean的方法，其返回值将作为一个bean定义注册到Spring的IoC容器，方法名将默认成为该bean定义的id。

（3）表达依赖注入关系层面

为了表达bean与bean之间的依赖关系，在XML形式中一般是这样的：
~~~xml
<bean id="mockService" class="..MockServiceImpl">
    <property name="dependencyService" ref="dependencyService"/>
</bean>

<bean id="dependencyService" class="DependencyServiceImpl"/>
~~~

而在JavaConfig中则是这样的：
~~~java
@Configuration
public class MockConfiguration {
    @Bean
    public MockService mockService() {
        return new MockServiceImpl(dependencyService());
    }

    @Bean
    public DependencyService dependencyService(){
        return new DependencyServiceImpl();
    }
}
~~~
如果一个bean的定义依赖其他bean，则直接调用对应JavaConfig类中依赖bean的创建方法就可以了。

>在JavaConfig形式的依赖注入过程中，我们使用方法调用的形式注入依赖，如果这个方法返回的对象实例只被一个bean依赖注入，那也还好，如果多于一个bean需要依赖这个方法调用返回的对象实例，那是不是意味着我们就会创建多个同一类型的对象实例？
>
>从代码表述的逻辑来看，直觉上应该是会创建多个同一类型的对象实例，但实际上最终结果却不是这样，依赖注入的都是同一个Singleton的对象实例，那这是如何做到的？
>
>笔者一开始以为Spring框架会通过解析JavaConfig的代码结构，然后通过解析器转换加上反射等方式完成这一目的，但实际上Spring框架的设计和实现者采用了另一种更通用的方式，这在Spring的参考文档中有说明，即通过拦截配置类的方法调用来避免多次初始化同一类型对象的问题，一旦拥有拦截逻辑的子类发现当前方法没有对应的类型实例时才会去请求父类的同一个方法来初始化对象实例，否则直接返回之前的对象实例。

### 2.3.1 那些高曝光率的Annotation

1.@ComponentScan

@ComponentScan对应XML配置形式中的\<context:component-scan>元素，用于配合一些元信息Java Annotation，比如@Component和@Repository等，将标注了这些元信息Annotation的bean定义类批量采集到Spring的IoC容器中。

我们可以通过basePackages等属性来细粒度地定制@ComponentScan自动扫描的范围，如果不指定，则默认Spring框架实现会从声明@ComponentScan所在类的package进行扫描。

@ComponentScan是SpringBoot框架魔法得以实现的一个关键组件，大家可以重点关注，我们后面还会遇到它。

2.@PropertySource与@PropertySources

@PropertySource用于从某些地方加载*.properties文件内容，并将其中的属性加载到IoC容器中，便于填充一些bean定义属性的占位符（placeholder），当然，这需要PropertySourcesPlaceholderConfigurer的配合。

如果我们使用Java8或更高版本开发，那么，我们可以并行声明多个@PropertySource：
~~~java
@Configuration
@PropertySource("classpath1:1.properties")
@PropertySource("classpath2:2.properties")
@PropertySource("...")
public class XConfiguration{
    ...
}
~~~

如果我们使用低于Java 8 版本的Java开发Spring应用，又想声明多个@PropertySource，则需要借助@PropertySources的帮助了：
~~~java
@PropertySources({
    @PropertySource("classpath1:1.properties"),
    @PropertySource("classpath2:2.properties"),
    ...
})
public class XConfiguration{
    ...
}
~~~

3.@Import与@ImportResource

在XML形式的配置中，我们通过`<import resource="XXX.xml"/>`的形式将多个分开的容器配置整合到一个配置中，在JavaConfig形式的配置中，我们则使用@Import这个Annotation完成同样的目的：
~~~java
@Configuration
@Import(MockConfiguration.class)
public class XConfiguration {
    ...
}
~~~

@Import 只负责引入JavaConfig形式定义的IoC容器配置，如果有一些遗留的配置或者遗留系统需要以XML形式来配置（比如dubbo框架），我们依然可以通过@ImportResource将它们一起合并到当前JavaConfig配置的容器中：
~~~java
@Configuration
@Import(MockConfiguration.class)
@ImportResource("...")
public class XConfiguration {
    ...
}
~~~

# 第3章 SpringBoot的工作机制

我们说SpringBoot是Spring框架对“约定优先于配置（Convention Over Configuration）”理念的最佳实践的产物，一个典型的SpringBoot应用本质上其实就是一个基于Spring框架的应用，而如果大家对Spring框架已经了如指掌，那么，在我们一步步揭开SpringBoot微框架的面纱之后，大家就会发现“阳光之下，并无新事”。

## 3.1 SpringBoot初体验

一个典型的SpringBoot应用长什么样子呢？如果我们使用http://start.spring.io/创建一个最简单的依赖Web模块的SpringBoot应用，一般情况下，我们会得到一个SpringBoot应用的启动类，如下面代码所示：
~~~java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args){
        SpringApplication.run(DemoApplication.class, args);
    }
}
~~~

所有的SpringBoot无论怎么定制，本质上与上面的启动类代码是一样的，而以上代码示例中，Annotation定义（@SpringBootApplication）和类定义（SpringApplication.run）最为耀眼。那么，要揭开SpringBoot应用的奥秘，很明显的，我们只要先从这两位开始就可以了。

## 3.2 @SpringBootApplication背后的秘密

@SpringBootApplication是一个“三体”结构，实际上它是一个复合Annotation：

~~~java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@Configuration
@EnableAutoConfiguration
@ComponentScan
public @interface SpringBootApplication {
    ...
}
~~~

虽然它的定义使用了多个Annotation进行元信息标注，但实际上对于SpringBoot应用来说，重要的只有三个Annotation,而“三体”结构实际上指的就是这三个Annotation：
- @Configuration
- @EnableAutoConfiguration
- @ComponentScan

所以，如果我们使用如下的SpringBoot启动类，整个SpringBoot应用依然可以与之前的启动类功能对等：
~~~java
@Configuration
@EnableAutoConfiguration
@ComponentScan
public class DemoApplication {
    public static void main(String[] args){
        SpringApplication.run(DemoApplication.class, args);
    }
}
~~~

但每次都写这三个Annotation显然过于繁琐，所以写一个@SpringBootApplication这样的一站式复合Annotation显然更方便一些。

### 3.2.1 @Configuration创世纪

这里的@Configuration对我们来说并不陌生，它就是JavaConfig形式的Spring IoC容器的配置类使用的那个@Configuration，既然SpringBoot应用骨子里就是一个Spring应用，那么，自然也需要加载某个IoC容器的配置，而SpringBoot社区推荐使用基于JavaConfig的配置形式，所以，很明显，这里的启动类标注了@Configuration之后，本身其实也是一个IoC容器的配置类！

很多SpringBoot的代码示例都喜欢在启动类上直接标注@Configuration或@SpringBootApplication，对于初接触SpringBoot的开发者来说，其实这种做法不便于理解，如果我们将上面的SpringBoot启动类拆分为两个独立的Java类，整个形式就明朗了：
~~~java
@Configuration
@EnableAutoConfiguration
@ComponentScan
public class DemoConfiguration {
    @Bean
    public Controller controller(){
        return new Controller();
    }
}    

public class DemoApplication
    public static void main(String[] args){
        SpringApplication.run(DemoConfiguration.class, args);
    }
}
~~~

所以，启动类DemoApplication其实就是一个标准的Standalone类型Java程序的main函数启动类，没有什么特殊的。

而@Configuration标注的DemoConfiguration定义其实也是一个普通的JavaConfig形式的IoC容器配置类，没啥新东西，全是Spring框架里的概念！

### 3.2.2 @EnableAutoConfiguration的功效

@EnableAutoConfiguration其实也没啥“创意”，各位是否还记得Spring框架提供的各种名字为@Enable开头的Annotation定义？比如@EnableScheduling、@EnableCaching、@EnableMBeanExport等，@EnableAutoConfiguration的理念和“做事方式”其实一脉相承，简单概括一下就是，借助@Import的支持，收集和注册特定场景相关的bean定义：
- @EnableScheduling 是通过@Import将Spring调度框架相关的bean定义都加载到IoC容器。
- @EnableMBeanExport是通过@Import将JMX相关的bean定义加载到IoC容器。

而@EnableAutoConfiguration也是借助@Import的帮助，将所有符合自动配置条件的bean定义加载到IoC容器，仅此而已！

@EnableAutoConfiguration作为一个复合Annotation，其自身定义关键信息如下：
~~~java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@AutoConfigurationPackage
@Import(EnableAutoConfigurationImportSelector.class)
public @interface EnableAutoConfiguration {
    ...
}
~~~

其中，最关键的要属@Import(EnableAutoConfigurationImportSelector.class)，借助EnableAutoConfigurationImportSelector，@EnableAutoConfiguration可以帮助SpringBoot应用将所有符合条件的@Configuration配置都加载到当前SpringBoot创建并使用的IoC容器，就跟一只“八爪鱼”一样。

借助于Spring框架原有的一个工具类：SpringFactoriesLoader的支持，@EnableAutoConfiguration可以“智能”地自动配置功效才得以大功告成！

**自动配置的幕后英雄：SpringFactoriesLoader详解**

SpringFactoriesLoader属于Spring框架私有的一种扩展方案（类似于Java的SPI方案java.util.ServiceLoader),其主要功能就是从指定的配置文件META-INF/spring.factories加载配置，spring.factories是一个典型的java properties文件，配置的格式为Key = Value形式，只不过Key和Value都是Java类型的完整类名（Full qualified name），比如：

`example.MyService=example.MyServiceImpl,example.MyServiceImpl2`

然后框架就可以根据某个类型作为Key来查找对应的类型名称列表了：

~~~java
public abstract class SpringFactoriesLoader {
    //...
    public static <T> List<T> loadFactories(Class<T> factoryClass, ClassLoader classLoader) {
        ...
    }
    
    public static List<String> loadFactoryNames(Class<?> factoryClass, ClassLoader classLoader){
        ...
    }
    //,,,
}
~~~

对于@EnableAutoConfiguration来说，SpringFactoriesLoader的用途稍微不同一些，其本意是为了提供SPI扩展的场景，而在@EnableAutoConfiguration的场景中，它更多是提供了一种配置查找的功能支持，即根据@EnableAutoConfiguration的完整类名org.springframework.boot.autoconfigure.EnableAutoConfiguration作为查找的Key，获取对应的一组@Configuration类

所以，@EnableAutoConfiguration自动配置的魔法其实就变成了：从classpath中搜寻所有META-INF/spring.factories配置文件，并将其中org.springframework.boot.autoconfigure.EnableAutoConfiguration对应的配置项通过反射（Java Reflection）实例化为对应的标注了@Configuration的JavaConfig形式的IoC容器配置类，然后汇总为一个并加载到IoC容器。

目前为止，还是Spring框架的原有概念和支持，依然没有“新鲜事”！

### 3.2.3 可有可无的@ComponentScan

为啥说@ComponentScan是可有可无的？因为原则上来说，作为Spring框架里的“老一辈革命家”，@ComponentScan的功能其实就是自动扫描并加载符合条件的组件或bean定义，最终将这些bean定义加载到容器中。加载bean定义到Spring的IoC容器，我们可以手工单个注册，不一定非要通过批量的自动扫描完成，所以说@ComponentScan是可有可无的。

对于SpringBoot应用来说，同样如此，比如我们本章的启动类。如果我们当前应用没有任何bean定义需要通过@ComponentScan加载到当前SpringBoot应用对应使用的IoC容器，那么，除去@ComponentScan的声明，当前SpringBoot应用依然可以照常运行，功能对等！

看，还是没有啥新东西！

## 3.3 SpringApplication：SpringBoot程序启动的一站式解决方案

如果非说SpringBoot微框架提供了点儿自己特有的东西，在核心类层面（各种场景下的自动配置一站式插拔模块，我们下一章再重点介绍），也就是SpringApplication了。

SpringApplication将一个典型的Spring应用启动的流程“模板化”（这里是动词），在没有特殊需求的情况下，默认模板化后的执行流程就可以满足需求了；但有特殊需求也没关系，SpringApplication在合适的流程结点开放了一系列不同类型的扩展点，我们可以通过这些扩展点对SpringBoot程序的启动和关闭过程进行扩展。

最“肤浅”的扩展或者配置是SpringApplication通过一系列设置方法（setters)开放的定制方式，比如，我们之前的启动类的main方法中只有一句:

`SpringApplication.run(DemoApplication.class, args);`

但如果我们想通过SpringApplication的一系列设置方法来扩展启动行为，则可以用如下方式进行：

~~~java
public class DemoApplication{
    public static void main(String[] args){
        //SpringApplication.run(DemoConfiguration.class, args);

        SpringApplication bootstrap = new SpringApplication(DemoConfiguration.class);
        bootstrap.setBanner(new Banner(){
            @Override
            public void printBanner(Environment environment, Class<?> aClass, PrintStream printStream) {
                //比如打印一个我们喜欢的ASCII Arts字符画
            }
        });
        bootstrap.setBannerMode(Banner.Mode.CONSOLE);
        // 其他定制设置 ...
        bootstrap.run(args);
    }
}
~~~

>设置自定义banner最简单的方式其实是把ASCII Art字符画放到一个资源文件，然后通过ResourceBanner来加载：bootstrap.setBanner(new ResourceBanner(new ClassPathResource("banner.txt")));

### 3.3.1 深入探索SpringApplication执行流程

SpringApplication的run方法的实现是我们本次旅程的主要线路，该方法的主要流程大体可以归纳如下：

1） 如果我们使用的是SpringApplication的静态run方法，那么，这个方法里面首先需要创建一个SpringApplication对象实例，然后调用这个创建好的SpringApplication的实例run方法。在SpringApplication实例初始化的时候，它会提前做几件事情：
- 根据classpath里面是否存在某个特征类（org.springframework.web.context.ConfigurationWebApplicationContext)来决定是否应该创建一个为Web应用使用的ApplicationContext类型，还是应该创建一个标准Standalone应用使用的ApplicationContext类型。
- 使用SpringFactoriesLoader在应用的classpath中查找并加载所有可用的ApplicationContextInitializer。
- 使用SpringFactoriesLoader在应用的classpath中查找并加载所有可用的ApplicationListener。
- 推断并设置main方法的定义类。

2）SpringApplication实例初始化完成并且完成设置后，就开始执行run方法的逻辑了，方法执行伊始，首先遍历执行所有通过SpringFactoriesLoader可以查找到并加载的SpringApplicationRunListener，调用它们的started()方法，告诉这些SpringApplicationRunListener，“嘿，SpringBoot应用要开始执行咯！”。

3）创建并配置当前SpringBoot应用将要使用的Environment（包括配置要使用的PropertySource以及Profile）。

4）遍历调用所有SpringApplicationRunListener的environmentPrepared()的方法，告诉它们：“当前SpringBoot应用使用的Environment准备好咯！”

5）如果SpringApplication的showBanner属性被设置为true，则打印banner（SpringBoot 1.3.x版本，这里应该是基于Banner.Mode决定banner的打印行为）。这一步的逻辑其实可以不关心，我认为唯一的用途就是“好玩”（Just For Fun）。

6）根据用户是否明确设置了applicationContextClass类型以及初始化阶段的推断结果，决定该为当前SpringBoot应用创建什么类型的ApplicationContext并创建完成，然后根据条件决定是否添加ShutdownHook，决定是否使用自定义的BeanNameGenerator，决定是否使用自定义的ResourceLoader，当然，最重要的，将之前准备好的Environment设置给创建好的ApplicationContext使用。

7）ApplicationContext创建好之后，SpringApplication会再次借助SpringFactoriesLoader，查找并加载classpath中所有可用的ApplicationContextInitializer，然后遍历调用这些ApplicationContextInitializer的initialize(applicationContext)方法来对已经创建好的ApplicationContext进行进一步的处理。

8）遍历调用所有SpringApplicationRunListener的contextPrepared()方法,通知它们：“SpringBoot应用使用的ApplicationContext准备好啦！”

9）最核心的一步，将之前通过@EnableAutoConfiguration获取的所有配置以及其他形式的IoC容器配置加载到已经准备完毕的ApplicationContext。

10）遍历调用所有SpringApplicatuionRunListener的contextLoaded()方法，告知所有SpringApplicationRunListener，ApplicationContext“装填完毕”！

11）调用ApplicationContext的refresh()方法，完成IoC容器可用的最后一道工序。

12）查找当前ApplicationContext中是否注册有CommandLineRunner，如果有，则遍历执行它们。

13）正常情况下，遍历执行SpringApplicationRunListener的finished()方法，告知它们：“搞定！”。（如果整个过程出现异常，则依然调用所有SpringApplicationRunListener的finished()方法，只不过这种情况下会将异常信息一并传入处理）。

至此，一个完整的SpringBoot应用启动完毕！

整个过程看起来冗长无比，但其实很多都是一些事件通知的扩展点，如果我们将这些逻辑暂时忽略，那么其实整个SpringBoot应用启动的逻辑就可以压缩到极其精简的几步：

- 开始
- 收集各种条件和回调接口，例如，ApplicationContextInitializer、ApplicationListener
    - 通告started()
- 创建并准备Environment
    - 通告environmentPrepared()
- 创建并初始化ApplicationContext 例如，设置Environment，加载配置等
    - 通告contextPrepared()
    - 通告contextLoaded()
- refresh ApplicationContext 完成最终程序启动
    - 执行CommandLineRunner
    - 通告finished()
- 结束

前后对比我们就可以发现，其实SpringApplication提供的这些各类拓展点近乎“喧宾夺主”，占据了一个Spring应用启动逻辑的大部分“江山”，除了初始化并准备好ApplicationContext，剩下的大部分工作都是通过这些扩展点完成的，所以，我们有必要对各类扩展点进行逐一剖析，以便在需要的时候可以信手拈来，为我所用。

### 3.3.2 SpringApplicationRunListener

SpringApplicationRunListener是一个只有SpringBoot应用的main方法执行过程中接收不同执行时点事件通知的监听者：
~~~java
public interface SpringApplicationRunListener {
    void started();
    void environmentPrepared(ConfigurableEnvironment environment);
    void contextPrepared(ConfigurableApplicationContext context);
    void contextLoaded(ConfigurableApplicationContext context);
    void finished(ConfigurableApplicationContext context, Throwable exception);
}
~~~

对于我们来说，基本没什么常见的场景需要自己实现一个SpringApplicationRunListener，即使SpringBoot默认也只是实现了一个org.springframework.boot.context.event.EventPublishingRunListener,用于在SpringBoot启动的不同时点发布不同的应用事件类型（ApplicationEvent），如果有哪些ApplicationListener对这些应用事件感兴趣，则可以接收并处理。（还记得SpringApplication实例初始化的时候加载了一批ApplicationListener，但是在run方法执行流程中却没有被使用的丝毫痕迹吗？EventPublishingRunListener就是答案！）

假如我们真的有场景需要自定义一个SpringApplicationRunListener实现，那么有一点需要注意，即任何一个SpringApplicationRunListener实现类的构造方法（Constructor）需要有两个构造参数，一个构造参数的类型就是我们的org.springframework.boot.SpringApplication,另外一个就是args参数列表的String[]:
~~~java
public class DemoSpringApplicationRunListener implements SpringApplicationRunListener {
    @Override
    public void started() {
        // do whatever you want to do
    }

    @Override
    public void environmentPrepared(ConfigurableEnvironment environment) {
        // do whatever you want to do
    }

    @Override
    public void contextPrepared(ConfigurableApplicationContext context){
        // do whatever you want to do
    }

    @Override
    public void contextLoaded(ConfigurableApplicationContext context){
        // do whatever you want to do
    }

    @Override
    public void finished(ConfigurableApplicationContext context, Throwable exception) {
        // do whatever you want to do
    }
}
~~~

之后，我们可以通过SpringFactoriesLoader立下的规矩，在当前SpringBoot应用的classpath下的META-INF/spring.factories文件中进行类似如下的配置：
~~~properties
org.springframework.boot.SpringApplicationRunListener=\
  com.keevol.springboot.demo.DemoSpringApplicationRunListener
~~~
然后SpringApplication就会在运行的时候调用它啦！

### 3.3.3 ApplicationListener

ApplicationListener其实时老面孔，属于Spring框架对Java中实现的监听者模式的一种框架实现，这里唯一值得着重强调的是，对于初次接触SpringBoot，但对Spring框架本身又没有过多接触的开发者来说，可能会将这个名字与SpringApplicationRunListener混淆。

如果我们要为SpringBoot应用添加自定义的ApplicationListener，有两种方式：

1）通过SpringApplication.addListeners(...)或者SpringApplication.setListeners(...)方法添加一个或者多个自定义的ApplicationListener;

2）借助SpringFactoriesLoader机制，在META-INF/spring.factories文件中添加配置（以下代码是为SpringBoot默认注册的ApplicationListener配置）：
~~~properties
org.springframework.context.ApplicationListener=\
  org.springframework.boot.builder.ParentContextCloserApplicationListener,\
  org.springframework.boot.cloudfoundry.VcapApplicationListener,\
  org.springframework.boot.context.FileEncodingApplicationListener,\
  org.springframework.boot.context.config.AnsiOutputApplicationListener,\
  org.springframework.boot.context.config.ConfigFileApplicationListener,\
  org.springframework.boot.context.config.DelegatingApplicationListener,\
  org.springframework.boot.liquibase.LiquibaseServiceLocatorApplicationListener,\
  org.springframework.boot.logging.ClasspathLoggingApplicationListener,\
  org.springframework.boot.logging.LoggingApplicationListener
~~~

### 3.3.4 ApplicationContextInitializer

ApplicationContextInitializer也是Spring框架原有的概念，这个类的主要目的就是在ConfigurableApplicationContext类型（或者子类型）的ApplicationContext做refresh之前，允许我们对ConfigurableApplicationContext实例做进一步的设置或者处理。

实现一个ApplicationContextInitializer很简单，因为它只有一个方法需要实现：
~~~java
public class DemoApplicationContextInitializer implements ApplicationContextInitializer {
    @Override
    public void initialize(ConfigurableApplicationContext applicationContext){
        // do whatever you want with applicationContext
        // e.g. applicationContext.registerShutdownHook();
    }
}
~~~

不过，一般情况下我们基本不会需要自定义一个ApplicationContextInitializer,即使SpringBoot框架默认也只是注册了三个实现：
~~~properties
org.springframework.context.ApplicationContextInitializer=\
  org.springframework.boot.context.ConfigurationWarningApplicationContextInitializer,\
  org.springframework.boot.context.ContextIdApplicationContextInitializer,\
  org.springframework.boot.context.config.DelegatingApplicationContextInitializer
~~~

如果我们真的需要自定义一个ApplicationContextInitializer，那么只要像上面这样，通过SpringFactoriesLoader机制进行配置，或者通过SpringApplication.addInitializers(...)设置即可。

### 3.3.5 CommandLineRunner

CommandLineRunner不是Spring框架原有的“宝贝”，它属于SpringBoot应用特定的回调扩展接口：
~~~java
public interface CommandLineRunner {
    void run(String... args) throws Exception;
}
~~~

CommandLineRunner需要大家关注的其实就两点：

1）所有CommandLineRunner的执行时点在SpringBoot应用的ApplicationContext完全初始化开始工作之后（可以认为是main方法执行完成之前最后一步）。

2）只要存在于当前SpringBoot应用的ApplicationContext中的任何CommandLineRunner，都会被加载执行（不管你是手动注册这个CommandLineRunner到IoC容器，还是自动扫描进去的）。

与其他几个扩展点接口类型相似，建议CommandLineRunner的实现类使用@org.springframework.core.annotation.Order进行标注或者实现org.springframework.core.Ordered接口，便于对它们的执行顺序进行调整，这其实十分重要，我们不希望顺序不当的CommandLineRunner实现类阻塞了后面其他CommandLineRunner的执行。

CommandLineRunner是很好的扩展接口，大家可以重点关注，我们在后面的扩展和微服务实践章节会再次遇到它。

## 3.4 再谈自动配置

此前我们讲到，@EnableAutoConfiguration可以借助SpringFactoriesLoader这个特性将标注了@Configuration的JavaConfig类“一股脑儿”的汇总并加载到最终的ApplicationContext，不过，这其实只是“简化版”的说明，实际上，基于@EnableAutoConfiguration的自动配置功能拥有更加强大的调控能力，通过配合比如基于条件的配置能力或者调整加载顺序，我们可以对自动配置进行更加细粒度的调整和控制。

### 3.4.1 基于条件的自动配置

基于条件的自动配置来源于Spring框架中“基于条件的配置”这一特性。在Spring框架中，我们可以使用@Conditional这个Annotation配合@Configuration或者@Bean等Annotation来干预一个配置或者bean定义是否能够生效，其最终实现的效果或者语义类似于如下伪代码：
~~~java
if(符合@Conditional规定的条件){
    加载当前配置或者注册当前bean定义;
}
~~~

要实现基于条件的配置，我们只要通过@Conditional指定自己的Condition实现类就可以了（可以应用于类型Type的标注或者方法Method的标注）：

`@Conditional({MyCondition1.class, MyCondition2.class, ...})`

最主要的是，@Conditional可以作为一个Meta Annotation用来标注其他Annotation实现类，从而构建各色的复合Annotation，比如SpringBoot的autoconfigure模块就基于这一优良的革命传统，实现了一批这样的Annotation（位于org.springframework.boot.autoconfigure.condition包下）：
- @ConditionalOnClass
- @ConditionalOnBean
- @ConditionalOnMissingClass
- @ConditionalOnMissingBean
- @ConditionalOnProperty
- ......

有了这些复合Annotation的配合，我们就可以结合@EnableAutoConfiguration实现基于条件的自动配置了。

SpringBoot能够风靡，很大一部分功劳需要归功于它预先提供的一系列自动配置的依赖模块，而这些依赖模块都是基于以上@Conditional复合Annotation实现的，这也意味着所有的这些依赖模块都是按需加载的，只有符合某些特定条件，这些依赖模块才会生效，这也就是我们所谓的“智能”自动配置。

### 3.4.2 调整自动配置的顺序

在实现自动配置的过程中，除了可以提供基于条件的配置，我们还可以对当前要提供的配置或者组件的加载顺序进行相应调整，从而让这些配置或者组件之间的依赖分析和组装可以顺利完成。

我们可以使用@org.springframework.boot.autoconfigure.AutoConfigureBefore或者@org.springframework.boot.autoconfigure.AutoConfigureAfter让当前配置或者组件在某个其他组件之前或者之后进行，比如，假设我们希望某些JMX操作相关的bean定义在MBeanServer配置完成之后进行，那么我们就可以提供一个类似如下的配置：

~~~java
@Configuration
@AutoConfigureAfter(JmxAutoConfiguration.class)
public class AfterMBeanServerReadyConfiguration {
    @Autowired
    MBeanServer mBeanServer;
    
    // 通过@Bean添加必要的bean定义
}
~~~

# 第4章 了解纷杂的spring-boot-starter

我认为，SpringBoot微框架从两个主要层面影响Spring社区的开发者们：

1）基于Spring框架的“约定优先于配置（COC）”理念以及最佳实践之路

2）提供了针对日常企业应用研发各种场景的spring-boot-starter自动配置依赖模块，如此多“开箱即用”的依赖模块，使得开发各种场景的Spring应用更加快速和高效。

SpringBoot提供的这些“开箱即用”的依赖模块都约定以spring-boot-starter-作为命名的前缀，并且皆位于org.springframework.boot包或者命名空间下（虽然SpringBoot官方参考文档中提到不建议大家使用spring-boot-starter-来命名自己写的类似的自动配置依赖模块，但实际上，配合不同的groupId，这不应该是什么问题）。

如果我们访问http://start.spring.io，并单击“Switch to the full version”链接，就会发现SpringBoot1.3.1默认支持和提供了大约80多个自动配置依赖模块。

鉴于数量如此之多，并且也不是所有人都会在任何一个应用中用到所有，我只会就几个常见的通用spring-boot-starter模块进行讲解，希望大家可以举一反三，灵活应用所有日后工作过程中将会用到的那些spring-boot-starter模块。

所有的spring-boot-starter都有约定俗成的默认配置，但允许我们调整这些配置以改变默认的配置行为，即“约定优先于配置”。

简单来讲，我们可以将对SpringBoot的行为可以进行干预的配置方式划分为几类：
- 命令行参数（Command Line Args）。
- 系统环境变量（Environment Variables）。
- 位于文件系统中的配置文件
- 位于classpath中的配置文件。
- 固化到代码中的配置项。

为了简化，其他比较少见场景的配置方式不在这里罗列。总的来说，以上几种方式安照优先级从高到低排列，高优先级方式提供的配置项可以覆盖或者优先生效，比如通过命令行参数传入的配置项会覆盖通过环境变量传入的同一配置项，当然也会覆盖其他后面几种方式给出的同一配置项。

不管是位于文件系统还是classpath，SpringBoot应用默认的配置文件名叫作application.properties，可以直接放在当前项目的根目录下或者名称为config的子目录下。

以上是关于SpringBoot应用配置方式的简单介绍，基本可以满足我们后面讲解的需要，所以，现在让我们进入纷杂的spring-boot-starter探索之旅吧！

## 4.1 应用日志和spring-boot-starter-logging

java的日志系统多种多样，从java.util默认提供的日志支持，到log4j，log4j2，commons logging等，复杂繁多，所以，应用日志系统的配置就会比较特殊，从而spring-boot-starter-logging也比较特殊一些，下面将其作为我们第一个了解的自动配置依赖模块。

加入maven依赖中添加了spring-boot-starter-logging：

~~~xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-logging</artifactId>
</dependency>
~~~

那么，我们的SpringBoot应用将自动使用logback作为应用日志框架，SpringBoot启动的时候，由org.springframework.boot.Logging-Application-Listener根据情况初始化并使用。

SpringBoot为我们提供了很多默认的日志配置，所以，只要将spring-boot-starter-logging作为依赖加入到当前应用的classpath，则“开箱即用”，不需要做任何多余的配置，但假设我们要对默认SpringBoot提供的应用日志设定做调整，则可以通过几种方式进行配置调整：
- 遵循logback的约定，在classpath中使用自己定制的logback.xml配置文件。
- 在文件系统中任何一个位置提供自己的logback.xml配置文件，然后通过logging.config配置项指向这个配置文件来启动它，比如在application.properties中指定如下的配置。
`logging.config=/{some.path.you.defined}/any-logfile-name-I-like.log`

> SpringBoot 默认允许我们通过在配置文件或者命令行等方式使用logging.file和logging.path来自定义日志文件的名称和存放路径，不过，这只是允许我们在SpringBoot框架预先定义的默认日志系统设定的基础上做有限的设置，如果我们希望更灵活的配置，最好通过框架特定的配置方式提供相应的配置文件，然后通过logging.config来启用。

如果大家更习惯使用log4j或者log4j2，那么也可以采用类似的方式将它们对应的spring-boot-starter依赖模块加到Maven依赖中即可：
~~~xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-log4j</artifactId>
</dependency>
~~~
或者
~~~xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-log4j2</artifactId>
</dependency>
~~~
但一定不要将这些完成同一目的的spring-boot-starter都加到依赖中。

## 4.2 快速Web应用开发与spring-boot-starter-web

在这个互联网时代，使用Spring框架除了开发少数的独立应用，大部分情况下实际上在使用SpringMVC开发web应用，为了帮我们简化快速搭建并开发一个Web项目，SpringBoot为我们提供了spring-boot-starter-web自动配置模块。

只要将spring-boot-starter-web加入项目的maven依赖：
~~~xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
~~~

我们就得到了一个直接可执行的Web应用，当前项目下运行mvn spring-boot:run就可以直接启动一个使用了嵌入式tomcat服务请求的Web应用，只不过，我们还没有提供任何服务Web请求的Controller，所以，访问任何路径都会返回一个SpringBoot默认提供的错误页面（一般称其为whitelabel error page），我们可以在当前项目下新建一个服务根路径Web请求的Controller实现：
~~~java
@RestController
public class IndexController {
    @RequestMapping("/")
    public String index(){
        return "hello, there";
    }
}
~~~

重新运行 mvn spring-boot:run 并访问 http://localhost:8080，错误页面将被我们的Controller返回的消息所替代，一个简单的Web应用就这样完成了。

但是，简单的背后，其实却有很多“潜规则”（约定），我们只有充分了解了这些“潜规则”，才能更好地应用spring-boot-starter-web。

### 4.2.1 项目结构层面地约定

项目结构层面与传统打包为war的Java Web应用的差异在于，静态文件和页面模板的存放位置变了，原来是放在src/main/webapp目录下的一系列资源，现在都统一放在src/main/resources相应子目录下，比如：

1）src/main/resources/static用于存放各类静态资源，比如css,js等。

2）src/main/resources/templates用于存放模板文件，比如*.vm。

> 当然，如果还是希望以war包的形式，而不是SpringBoot推荐使用的独立jar包形式发布Web应用，也可以继续原来Java Web应用的项目结构预定。

### 4.2.2 SpringMVC 框架层面的约定和定制

spring-boot-starter-web 默认将为我们自动配置如下一些SpringMVC必要组件：
- 必要的ViewResolver，比如ContentNegotiatingViewResolver和BeanNameViewResolver。
- 将必要的Converter、GenericConverter和Formatter等bean注册到IoC容器。
- 添加一系列的HttpMessageConverter以便支持对Web请求和相应的类型转换。
- 自动配置和注册MessageCodesResolver。
- 其他。

任何时候，如果我们对默认提供的SpringMVC组件设定不满意，都可以在IoC容器中注册新的同类型的bean定义来替换，或者直接提供一个基于WebMvcConfigurerAdapter类型的bean定义来定制，甚至直接提供一个标注了@EnableWebMvc的@Configuration配置类完全接管所有SpringMVC的相关配置，自己完全重新配置。

### 4.2.3 嵌入式Web容器层面的约定和定制

spring-boot-starter-web默认使用嵌入式tomcat作为web容器对外提供HTTP服务，默认将使用8080端口对外监听和提供服务：

1）假设我们不想使用默认的嵌入式tomcat（spring-boot-starter-tomcat自动配置模块），那么可以引入spring-boot-starter-jetty或者spring-boot-starter-undertow作为替代方案。

2）假设我们不想使用默认的8080端口，那么我们可以通过更改配置项server.port使用自己指定的端口，比如：
~~~properties
server.port=9000
~~~
spring-boot-starter-web 提供了很多以`server.`为前缀的配置项用于对嵌入式Web容器提供配置，比如：
- server.port
- server.address
- server.ssl.*
- server.tomcat.*

如果这些依然无法满足需求，SpringBoot甚至允许我们直接对嵌入式的Web容器实例进行定制，这可以通过向IoC容器中注册一个EmbeddedServletContainerCustomizer类型的组件来对嵌入式Web容器进行定制：
~~~java
public class UnveilSpringEmbeddedTomcatCustomizer implements EmbeddedServletContainerCustomizer {
    @Override
    public void customize(ConfigurableEmbeddedServletContainer container) {
        container.setPort(9999);
        container.setContextPath("/unveil-spring-chapter3");
        // ...
    }
}
~~~

再深入的定制则需要针对特定的嵌入式Web容器，使用实现对应的Factory并注册到IoC容器：
- TomcatEmbeddedServletContainerFactory
- JettyEmbeddedServletContainerFactory
- UndertowEmbeddedServletContainerFactory

但是，笔者认为大家几乎没有走到这一步的必要，而且建议最好也不要走到这一步，目前来看，spring-boot-starter-web提供的配置项列表已经是最简单和完备的定制方式了。

## 4.3 数据访问与spring-boot-starter-jdbc

大部分Java应用都需要访问数据库，尤其是服务层，所以，SpringBoot会为我们自动配置相应的数据访问设施。

若想SpringBoot为我们自动配置数据访问的基础设施，那么，我们需要直接或者间接地依赖spring-jdbc，一旦spring-jdbc位于我们SpringBoot应用的classpath，即会触发数据访问相关的自动配置行为，最简单的做法就是把spring-boot-starter-jdbc加为应用的依赖。

默认情况下，如果我们没有配置任何DataSource，那么，SpringBoot会为我们自动配置一个基于嵌入式数据库的DataSource，这种自动配置行为其实很适合于测试场景，但对实际的开发帮助不大，基本上我们会自己配置一个DataSource实例，或者通过自动配置模块提供的配置参数对DataSource实例进行自定义的配置。

假设我们的SpringBoot应用只依赖一个数据库，那么，使用DataSource自动配置模块提供的配置参数是最方便的：
~~~properties
spring.datasource.url=jdbc:mysql://{database host}:3306/{databaseName}
spring.datasource.username={database username}
spring.datasource.password={database password}
~~~

当然，自己配置一个DataSource也是可以的，SpringBoot也会智能地选择我们自己配置的这个DataSource实例（只不过必要性真不大）。

除了DataSource会自动配置，SpringBoot还会自动配置相应的JdbcTemplate、DataSourceTransactionManager等关联”设施“，可谓服务周到，我们只要在使用的地方注入就可以了：
~~~java
class SomeDao{
    @Autowired
    JdbcTemplate jdbcTemplate;
    
    public <T> List<T> queryForList(String sql){
        // ...
    }

    // ...
}
~~~

不过，spring-boot-starter-jdbc以及与其相关的自动配置也不总是带来便利，在某些场景下，我们可能会在一个应用中需要依赖和访问多个数据库，这个时间就会出现问题了。

假设我们在ApplicationContext中配置了多个DataSource实例指向多个数据库：
~~~java
@Bean
public DataSource dataSource1() throws Throwable {
    DruidDataSource dataSource = new DruidDataSource();
    dataSource.setUrl(...);
    dataSource.setUsername(...);
    dataSource.setPassword(...);
    // TODO other settings if necessary in the future.
    return dataSource;
}

@Bean
public DataSource dataSource2() throws Throwable {
    DruidDataSource dataSource = new DruidDataSource();
    dataSource.setUrl(...);
    dataSource.setUsername(...);
    dataSource.setPassword(...);
    // TODO other settings if necessary in the future.
    return dataSource;
}
~~~

那么，不好意思，启动SpringBoot应用的时候会抛出类似如下的异常（Exception）：
~~~
No qualifying bean of type [javax.sql.DataSource] is defined:
expected single matching bean but found 2
~~~

为了避免这种情况的发生，我们需要在SpringBoot的启动类上做点儿”手脚“：
~~~java
@SpringBootApplication(exclude = {
    DataSourceAutoConfiguration.class,
    DataSourceTransactionManagerAutoConfiguration.class
})
public class UnveilSpringChapter3Application{
    public static void main(String[] args) {
        SpringApplication.run(UnveilSpringChapter3Application.class, args);
    }
}
~~~

也就是说，我们需要在这种场景下排除掉对SpringBoot默认提供的DataSource相关的自动配置。

但如果我们还是想要享受SpringBoot提供的自动配置DataSource的机能，也可以通过为其中一个DataSource配置添加org.springframework.context.annotation.Primary这个Annotation的方式以实现两全其美：
~~~java
@Bean
@Primary
public DataSource dataSource1() throws Throwable {
    DruidDataSource dataSource = new DruidDataSource();
    dataSource.setUrl(...);
    dataSource.setUsername(...);
    dataSource.setPassword(...);
    // TODO other settings if necessary in the future.
    return dataSource;
}

@Bean
public DataSource dataSource2() throws Throwable {
    DruidDataSource dataSource = new DruidDataSource();
    dataSource.setUrl(...);
    dataSource.setUsername(...);
    dataSource.setPassword(...);
    // TODO other settings if necessary in the future.
    return dataSource;
}
~~~

另外，SpringBoot还提供了很多其他数据访问相关的自动配置模块，比如spring-boot-starter-data-jpa、spring-boot-starter-data-mongodb等，大家可以根据自己数据访问的具体场景选择使用这些自动配置模块。

> 如果选择了spring-boot-starter-data-jpa等关系数据库相关的数据访问自动配置模块，并且还需要同时依赖多个数据库，那么，也需要相应的在SpringBoot启动类中排除掉这些自动配置模块中的AutoConfiguration实现类（对应spring-boot-starter-data-jpa是JpaRepositoriesAutoConfiguration），或者标注某个DataSource为@Primary。

### 4.3.1 SpringBoot应用的数据库版本化管理

关于如何针对数据库的变更进行版本化管理，从Ruby On Rails的migration支持，到Java的MyBatis Migration，Flyway以及Liquibase，都给出了相应的最佳实践建议和方案，但是，从我所看到的国内业界现状，数据库migrations的实践方式并没有在国内普遍应用起来，大部分都是靠人来解决，这或许可以用一句”成熟度不够“来解释，另外一个原因或许是职能明确分工后造成的局面。

如果仔细分析以上数据库migration方案就会发现，它们给出的应用场景和实践几乎都是单应用、单部署的，这在庞大单一部署单元（Monolith）的年代显然是很适合的，因为应用从开发到发布部署，再到启动，整个生命周期内，应用相关的所有”原材料“都集中在一起进行管理，而且国外开发者往往偏”特种作战“（Full-Stack Developer）,一身多能，从而数据库migration这种实践自然可以成型并广泛应用。

但回到国内来看，我们往往是”集团军作战“，拼的是”大部队+明确分工“的模式，而且应用所面向的服务人数也往往更为庞大，所以，整个应用的交付链路上各个环节之间的衔接是不同的人，而应用最终部署的拓扑又往往是分布式部署居多，所以，在一个项目单元里维护数据库的migration脚本然后部署后启动前执行这些脚本就变得不合时宜了：

1）从职责上，这些migration脚本虽然大部分情况下都是开发人员写，但写完之后要不要进行SQL审查，是否符合规范，这些又会涉及应用运维DBA，代码管理系统对开发来说很亲切，对DBA来说则不尽然，而且DBA往往还要一人服务多个团队多个项目，从DBA的角度来说，他更愿意将SQL集中到一处进行管理，而不是分散在各个项目中。

2）应用分布式部署之后，就不单单是单一部署在应用启动的之前直接执行一次migration脚本那么简单了，你要执行多次，虽然migration方案都有版本控制，变更应该最终状态都是一样的，但这多个部署节点上都执行同一逻辑显然是多余的。更复杂一点儿，多个应用可能同时使用同一个数据库的情况（不要怀疑，遗留系统对大家来说并不陌生），一个项目的数据库migration操作跟另一个项目的数据库migration操作会不会在互不知晓的情况下产生冲突和破坏？

所以，数据库migration的思路和实践很好，但不能照搬（任何事情其实皆如此），不过，我们倒是不用一棒子打死，结合现有的一些数据库migration方案，比如flyway或者liquibase，我们可以对这些数据库migration的基础设施和支持外部化（Externalize）。

在这个架构中，数据库migration的版本化管理剥离到了单独的管理系统，单一项目中不再保存完整历史的migration记录，只需要提供当次发布要牵扯的数据库变更SQL。在项目发布的时候，由DBA进行统一的审查并纳入单独的数据库migration管理系统，由单独的数据库migration管理系统来管理完整的数据库migration记录，可以根据数据库的粒度进行管理和状态同步，从而既可以在开发阶段让开发人员可以集中管理数据库SQL，又能在发布期间审查SQL并同步migration状态和完整的历史记录管理。当然，这一切可以实现的前提是有一套完整的软件交付链路平台，能够从流程上，软件生命周期管理上进行统一的治理和规范，此为后话，我们将在下一章跟大家做进一步深入的探讨。

不管怎么样，SpringBoot还是为大家提供了针对Flyway和Liquibase的自动配置功能（org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration和org.springframework.boot.autoconfigure.liquibase.LiquibaseAutoConfiguration）,对于单一开发和部署的应用来说，还是可以考虑的。

## 4.4 spring-boot-starter-aop及其使用场景说明

如今，AOP（Aspect Oriented Programming）已经不是什么崭新的概念了，在经历了代码生成、动态代理、字节码增强甚至静态编译等不同时代的洗礼之后，Java平台上的AOP方案基本上已经以SpringAOP结合AspectJ的方式稳固下来（虽然大家依然可以自己通过各种字节码工具偶尔”打造一些轮子“）。

现在Spring框架提供的AOP方案倡导了一种各取所长的方案，即使用SpringAOP的面向对象的方式来编写和组织织入逻辑，并使用AspectJ的Pointcut描述语言配合Annotation来标注和指明织入点（Jointpoint）。

原则上来说，我们只要引入Spring框架中AOP的相应依赖就可以直接使用Spring的AOP支持了，不过，为了进一步为大家使用SpringAOP提供便利，SpringBoot还是”不厌其烦“地为我们提供了一个spring-boot-starter-aop自动配置模块。

spring-boot-starter-aop自动配置行为由两部分内容组成：

1）位于spring-boot-autoconfigure的org.springframework.boot.autoconfigure.aop.AopAutoConfiguration提供@Configuration配置类和相应的配置项。

2）spring-boot-starter-aop模块自身提供了针对spring-aop、aspectjrt和aspectjweaver的依赖。

一般情况下，只要项目依赖中加入了spring-boot-starter-aop，其实就会自动触发AOP的关联行为，包括构建相应的AutoProxyCreator，将横切关注点织入（Weave）相应的目标对象等，不过AopAutoConfiguration依然为我们提供了可怜的两个配置项，用来有限地干预AOP相关配置：
- spring.aop.auto = true
- spring.aop.proxy-target-class = false

对我们来说，这两个配置项的最大意义在于：允许我们投反对票，比如可以选择关闭自动的aop配置（spring.aop.auto=false），或者启用针对class而不是interface级别的aop代理（aop proxy）。

AOP的应用场景很多，我们不妨以当下最热门的APM(Application Performance Monitoring)为实例场景，尝试使用spring-boot-starter-aop的支持打造一个应用性能监控的工具原型。

### 4.4.1 spring-boot-starter-aop在构建spring-boot-starter-metrics自定义模块中的应用

