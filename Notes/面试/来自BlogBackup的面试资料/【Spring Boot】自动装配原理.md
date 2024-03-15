# Spring Boot 自动装配原理

# 简答

Spring Boot 自动装配就是自动将 Bean 装配到 IoC 容器中。

自动装配在 Spring Boot 中是通过 `@EnableAutoConfiguration` 注解来开启的，这个注解的声明在启动类注解 `@SpringBootApplication` 内。

进入 `@EnableAutoConfiguration` 注解里，可以看到除 `@Import` 注解之外，还多了一个 `@AutoConfigurationPackage` 注解（它的作用是把使用了该注解的类所在的包及子包下所有组件扫描到 Spring IoC 容器中）。

并且，`@Import` 注解中导入的并不是一个 Configuration 的配置类，而是一个 `AutoConfigurationImportSelector` 类。

核心过程：

- 通过 @Import(AutoConfigurationImportSelector) 实现配置类的导入，但是这里并不是传统意义上的单个配置类装配。
- AutoConfigurationImportSelector 类实现了 ImportSelector 接口，重写了方法 selectImports，它用于实现选择性批量配置类的装配。
- 通过 Spring 提供的 SpringFactoriesLoader 机制，扫描 classpath 路径下的 META-INF/spring.factories，读取需要实现自动装配的配置类。
- 通过条件筛选的方式，把不符合条件的配置类移除，最终完成自动装配。

~~~
@SpringBootApplication
→ @EnableAutoConfiguration
→ @AutoConfigurationPackage 和 @Import(AutoConfigurationImportSelector.class)
→ AutoConfigurationImportSelector 类实现了 ImportSelector 接口，重写了方法 selectImports
→ 配置类的收集方法 getAutoConfigurationEntry 用到了 SpringFactoriesLoader 
~~~

# 详解

## 自动装配的定义

简单来说，就是自动将 Bean 装配到 IoC 容器中。

例如：

- 添加 Starter 依赖

  ~~~xml
  <dependency>
  	<groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-redis</artifactId>
  </dependency>
  ~~~

- 在 application.properties 中配置 Redis 的数据源：

  ~~~properties
  spring.redis.host=localhost
  spring.redis.port=6379
  ~~~

- 在 HelloController 中使用 RedisTemplate 实现 Redis 的操作：

  ~~~java
  @RestController
  public class HelloController {
      @Autowired
      RedisTemplate<String, String> redisTemplate;
      @GetMapping("/hello")
      public String hello() {
          redisTemplate.opsForValue().set("key","value");
          return "Hello World";
      }
  }
  ~~~

在这个案例中，我们并没有通过 XML 形式或者注解形式把 RedisTemplate 注入 IoC 容器中，但是在 HelloController 中却可以直接使用 `@Autowired` 来注入 redisTemplate 实例，这就说明，IoC 容器中已经存在 RedisTemplate。这就是 Spring Boot 的自动装配机制。

## 自动装配的实现

自动装配在 Spring Boot 中是通过 `@EnableAutoConfiguration` 注解来开启的，这个注解的声明在启动类注解 `@SpringBootApplication` 内。

```java
@SpringBootApplication
public class SpringBootDemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(SpringBootDemoApplication.class, args);
    }
}
```

进入 `@SpringBootApplication` 注解，可以看到 `@EnableAutoConfiguration` 注解的声明。

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan(excludeFilters = {
    @Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class),
    @Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class)
})
public @interface SpringBootApplication {
}
```

> 其实 Spring 3.1 版本就已经支持 `@Enable` 注解了，它的主要作用把相关组件的 Bean 装配到 IoC 容器中。
>
> `@Enable` 注解对 JavaConfig 的进一步完善，为使用 Spring Framework 的开发者减少了配置代码量，降低了使用的难度。
>
> 比如常见的 `@Enable` 注解有 `@EnableWebMvc`、`@EnableScheduling`、`@EnableCaching`、`@EnavleMBeanExport` 等。
>
> - `@EnableScheduling` 是通过 `@Import` 将 Spring 调度框架相关的 bean 定义都加载到 IoC 容器。
> - `@EnableMBeanExport` 是通过 `@Import` 将 JMX 相关的 bean 定义加载到 IoC 容器。

如果基于 JavaConfig 的形式来完成 Bean 的装载，则必须要使用 `@Configuration` 注解及 `@Bean` 注解。而 `@Enable` 本质上就是针对这两个注解的封装，所以大家如果仔细关注过这些注解，就不难发现这些注解都会携带一个 `@Import` 注解，比如 `@EnableScheduling`：

```java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Import({SchedulingConfiguration.class})
@Documented
public @interface EnableScheduling {
}
```

因此，使用 `@Enable` 注解后，Spring 会解析到 `@Import` 导入的配置类，从而根据这个配置类中的描述来实现 Bean 的装配。

### @EnableAutoConfiguration

而 `@EnableAutoConfiguration` 也是借助 `@Import` 的帮助，将所有符合自动配置条件的 bean 定义加载到 IoC 容器。

进入 `@EnableAutoConfiguration` 注解里，可以看到除 `@Import` 注解之外，还多了一个 `@AutoConfigurationPackage` 注解（它的作用是把使用了该注解的类所在的包及子包下所有组件扫描到 Spring IoC 容器中）。

并且，`@Import` 注解中导入的并不是一个 Configuration 的配置类，而是一个 `AutoConfigurationImportSelector` 类。

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@AutoConfigurationPackage
@Import(AutoConfigurationImportSelector.class)
public @interface EnableAutoConfiguration
```

### AutoConfigurationImportSelector

`AutoConfigurationImportSelector` 实现了 `ImportSelector`，它只有一个 `selectImports` 抽象方法，并且返回一个 String 数组，在这个数组中可以指定需要装配到 IoC 容器的类，当在 `@Import` 中导入一个 `ImportSelector` 的实现类之后，会把该实现类中返回的 Class 名称都装载到 IoC 容器中。

```java
public interface ImportSelector {
    String[] selectImports(AnnotationMetadata var1);
}
```

和 `@Configuration` 不同的是，`ImportSelector` 可以实现批量装配，并且还可以通过逻辑处理来实现 Bean 的选择性装配，也就是可以根据上下文来决定哪些类能够被 IoC 容器初始化。

## 自动装配原理分析

基于前面章节的分析可以猜想到，自动装配的核心是扫描约定目录下的文件进行解析，解析完成之后把得到的 Configuration 配置类通过 `ImportSelector` 进行导入，从而完成 Bean 的自动装配过程。

那么接下来我们通过分析 `AutoConfigurationImportSelector` 的实现来求证这个猜想是否正确。

定位到 `AutoConfigurationImportSelector` 中的 `selectImports` 方法，它是 `ImportSeletor` 接口的实现，这个方法中主要有两个功能：

- `AutoConfigurationMetadataLoader.loaderMetadata` 从 `META-INF/spring-autoconfigure-metadata.properties` 中加载自动装配的条件元数据，简单来说就是只有满足条件的 Bean 才能够进行装配。
- 收集所有符合条件的配置类 `autoConfigurationEntry.getConfigurations()`，完成自动装配。

```java
@Override
public String[] selectImports(AnnotationMetadata annotationMetadata) {
    if (!isEnabled(annotationMetadata)){
        return NO_IMPORTS;
    }
    AutoConfigurationMetadata autoConfigurationMetadata = AutoConfigurationMetadataLoader.loadMetadata(this.beanClassLoader);
    AutoConfigurationEntry autoConfigurationEntry = getAutoConfigurationEntry(autoConfigurationMetadata, annotationMetadata);
    return StringUtils.toStringArray(autoConfigurationEntry.getConfigurations());
}
```

需要注意的是，在 `AutoConfigurationImportSelector` 中不执行 `selectImports` 方法，而是通过 `ConfigurationClassPostProcessor` 中的 `processConfigBeanDefinitions` 方法来扫描和注册所有配置类的 Bean，最终还是会调用 `getAutoConfigurationEntry` 方法获得所有需要自动装配的配置类。

我们重点分析一下配置类的收集方法 `getAutoConfigurationEntry`，结合之前 Starter 的作用不难猜测到，这个方法应该会扫描指定路径下的文件解析得到需要装配的配置类，而这里面用到了 `SpringFactoriesLoader`，这块内容后续随着代码的展开再来讲解。简单分析一下这段代码，它主要做几件事情：

- getAttributes 获得 `@EnableAutoConfiguration` 注解中的属性 exclude、excludeName 等。
- getCandidateConfigurations 获得所有自动装配的配置类，后续会重点分析。
- removeDuplicates 去除重复的配置项。
- getExclusions 根据 `@EnableAutoConfiguration` 注解中配置的 exclude 等属性，把不需要自动装配的配置类移除。
- fireAutoConfigurationImportEvents 广播事件。
- 最后返回经过多层判断和过滤之后的配置类集合。

```java
protected AutoConfigurationEntry getAutoConfigurationEntry(AutoConfigurationMetadata autoConfigurationMetadata, AnnotationMetadata annotationMetadata) {
    if (!isEnabled(annotationMetadata)){
        return EMPTY_ENTRY;
    }
    AnnotationAttributes attributes = getAttributes(annotationMetadata);
    List<String> configurations = getCandidateConfigurations(annotationMetadata, attributes);
    configurations = removeDuplicates(configurations);
    Set<String> exclusions = getExclusions(annotationMetadata, attributes);
    checkExcludedClasses(configurations, exclusions);
    configurations.removeAll(exclusions);
    configurations = filter(configurations, autoConfigurationMetadata);
    fireAutoConfigurationImportEvents(configurations, exclusions);
    return new AutoConfigurationEntry(configurations, exclusions);
}
```

总的来说，它先获得所有的配置类，通过去重、exclude 排除等操作，得到最终需要实现自动装配的配置类。这里需要重点关注的是 getCandidateConfigurations ，它是获得配置类最核心的方法。

```java
protected List<String> getCandidateConfigurations(AnnotationMetadata metadata, AnnotationAttributes attributes) {
    List<String> configurations = SpringFactoriesLoader.loadFactoryNames(getSpringFactoriesLoaderFactoryClass(), getBeanClassLoader());
    Assert.notEmpty(configurations, "No auto configuration classes found in META-INF/spring.factories. "
                    + "If you are using a custom packaging, make sure that file is correct.");
    return configurations;
}
```

### SpringFactoriesLoader

这里用到了 `SpringFactoriesLoader`，它是 Spring 内部提供的一种约定俗成的加载方式，属于Spring 框架私有的一种扩展方案（类似于 Java 中的 SPI 方案 java.util.ServiceLoader），其主要功能就是从指定的配置文件 `META-INF/spring.factories` 加载配置。

简单来说，它会扫描 classpath 下的 `META-INF/spring.factories` 文件，spring.factories 文件中的数据以 Key = Value 形式存储，而 SpringFactoriesLoader.loaderFactoryNames 会根据 Key 得到对应的 value 值。因此在这个场景中，Key 对应为 EnableAutoConfiguration，Value 是多个配置类，也就是 getCandidateConfigurations 方法所返回的值。

```properties
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
org.springframework.boot.autoconfigure.admin.SpringApplicationAdminJmxAutoConfiguration,\
org.springframework.boot.autoconfigure.aop.AopAutoConfiguration,\
org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration,\
org.springframework.boot.autoconfigure.batch.BatchAutoConfiguration,\
org.springframework.boot.autoconfigure.cache.CacheAutoConfiguration,\
// 省略部分
```

打开 RabbitAutoConfiguration，可以看到，它就是一个基于 JavaConfig 形式的配置类。

```java
@Configuration(proxyBeanMethods = false)
@ConditionalOnClass({RabbitTemplate.class, Channel.class})
@EnableConfigurationProperties(RabbitProperties.class)
@Import(RabbitAnnotationDrivenConfiguration.class)
public class RabbitAutoConfiguration
```

除了基本的 `@Configuration` 注解，还有一个 `@ConditionalOnClass` 注解，这个条件控制机制在这里的用途是，判断 classpath 下是否存在 RabbitTemplate 和 Channel 这两个类，如果是，则把当前配置类注册到 IoC 容器。

另外，`@EnableConfigurationProperties` 是属性配置，也就是说我们可以按照约定在 `application.properties` 中配置 RabbitMQ 的参数，而这些配置会加载到 RabbitProperties 中。实际上，这些东西都是 Spring 本身就有的功能。

至此，自动装配的原理基本上就分析完了，**简单来总结一下核心过程**：

- 通过 @Import（AutoConfigurationImportSelector）实现配置类的导入，但是这里并不是传统意义上的单个配置类装配。
- AutoConfigurationImportSelector 类实现了 ImportSelector 接口，重写了方法 selectImports，它用于实现选择性批量配置类的装配。
- 通过 Spring 提供的 SpringFactoriesLoader 机制，扫描 classpath 路径下的 META-INF/spring.factories，读取需要实现自动装配的配置类。
- 通过条件筛选的方式，把不符合条件的配置类移除，最终完成自动装配。

## @Conditional 条件装配

`@Conditional` 是 Spring Framework 提供的一个核心注解，这个注解的作用是提供自动装配的条件约束，一般与 `@Configuration` 和 `@Bean` 配合使用。

简单来说，Spring 在解析 `@Configuration` 配置类时，如果该配置类增加了 `@Conditional` 注解，那么会根据该注解配置的条件来决定是否要实现 Bean 的装配。

### @Conditional 的使用

`@Conditional` 的注解类声明代码如下，该注解可以接收一个 Condition 的数组。

```java
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Conditional {
    Class<? extends Condition>[] value();
}
```

Condition 是一个函数式接口，提供了 matches 方法，它主要提供一个条件匹配规则，返回 true 表示可以注入 Bean，反之则不注入。

```java
@FunctionalInterface
public interface Condition {
    boolean matches(ConditionContext var1, AnnotatedTypeMetadata var2);
}
```

### Spring Boot 中的 @Conditional

在 Spring Boot 中，针对 `@Conditional` 做了扩展，提供了更简单的使用方式，扩展注解如下：

- ConditionalOnBean / ConditionalOnMissingBean : 容器中存在某个类或者不存在某个 Bean 时进行 Bean 装载。
- ConditionalOnClass / ConditionalOnMissingClass: classpath 下存在指定类或者不存在指定类时进行 Bean 装载。
- ConditionalOnCloudPlatform： 只有运行在指定的云平台上才加载指定的 Bean。
- ConditionalOnExpression：基于 SpEl 表达式的条件判断。
- ConditionalOnJava：只有运行指定版本的 Java 才会加载 Bean。
- ConditionalOnJndi：只有指定的资源通过 JNDI 加载后才加载 Bean。
- ConditionalOnWebApplication / ConditionalOnNotWebApplication : 如果是 Web 应用或者不是 Web 应用，才加载指定的 Bean。
- ConditionalOnProperty：系统中指定的对应的属性是否有对应的值。
- ConditionalOnResource：要加载的 Bean 依赖指定资源是否存在于 classpath 中。
- ConditionalOnSingleCandidate：只有在确定了给定 Bean 类的单个候选项时才会加载 Bean。

## spring-autoconfigure-metadata

除了 @Conditional 注解类，在 Spring Boot 中还提供了 spring-autoconfigure-metadata.properties 文件来实现批量自动装配条件配置。

它的作用和 @Conditional 是一样的，只是将这些条件配置放在了配置文件中。

同样这种形式也是“约定优于配置”的体现，通过这种配置化的方式来实现条件过滤必须要遵循两个条件：

- 配置文件的路径和名称必须是 /META-INF/spring-autoconfigure-metadata.properties。
- 配置文件中 key 的配置格式：自动配置类的类全路径名.条件 = 值

这种配置方法的好处在于，它可以有效地降低 Spring Boot 的启动时间，通过这种过滤方式可以减少配置类的加载数量，因为这个过滤发生在配置类的装载之前，所以它可以降低 Spring Boot 启动时装载 Bean 的耗时。

# 参考文档

- 《Spring Cloud Alibaba 微服务原理与实战》3.3 Spring Boot 自动装配的原理
- 《Spring Boot 揭秘：快速构建微服务体系》3.2.2 @EnableAutoConfiguration 的功效