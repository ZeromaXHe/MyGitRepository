# 简答

1. **数据库引擎不支持事务**：这里以 MySQL 为例，其 MyISAM 引擎是不支持事务操作的，InnoDB 才是支持事务的引擎，一般要支持事务都会使用 InnoDB，这时候选择支持事务的数据库即可
2. **数据源没有配置事务管理器**：相当于没开启事务管理
3. **没有被 Spring 容器管理**：通常情况下，我们通过@Controller、@Service、@Component、@Repository等注解，可以自动实现Bean 实例化和依赖注入的功能。如果把这些注解注释掉，这个类就不会被加载成一个 Bean，那这个类就不会被 Spring 管理了，事务自然就失效了。
4. **方法访问权限不是 public 的**：@Transactional 只能用于 public 的方法上，否则事务失效。如果要用在非 public 方法上，可以开启 AspectJ 代理模式。对应不能实施 Spring AOP 事务的方法可以参考详解第二节的具体介绍。
5. **传播特性配置错误**：例如，`NOT_SUPPORTED` 传播特性是指如果当前上下文中存在事务，则挂起当前事务，然后新的方法在没有事务的环境中执行。`NEVER` 是如果当前上下文中存在事务，则抛出异常，否则在无事务环境上执行代码。对于这种情况，改成支持事务的传播特性即可。
6. **异常类型错误**：因为默认的异常类型是运行时异常，如果抛出了其他异常就不生效。解决方式：（1）将异常改成运行时异常；（2）指定异常进行事物回滚，如：`@Transactional(rollbackFor = Exception.class)`
7. **异常被 catch 掉了**：必须要抛出异常，否则 Spring 事务管理，不会走到回滚逻辑
8. **类内部调用**：因为内部调用不会涉及到代理类的调用，更不会有AOP的增强，因此不会生效。
9. **多线程调用**：两个方法不在同一个线程中，获取到的数据库连接不一样，从而是两个不同的事务。只有拥有同一个数据库连接才能同时提交和回滚。

# 详解

我们先简单介绍一下 Spring 注解配置声明式事务的做法和特点（基于 XML 的事务配置暂时忽略，想了解的话请自行查看相关资料），再具体分析哪些方法不能实施 Spring AOP 事务，最后我们将回答事务失效有哪些场景。

# 1 使用 @Transactional 注解

因为 @Transactional 注解本身具有一组普适性的默认事务属性，所以往往只要在需要事务管理的业务类中添加一个 @Transactional 注解，就完成了业务类事务属性的配置。

当然，注解只提供元数据，它本身并不能完成事务切面织入的功能。因此，还需要在 Spring 配置文件中通过一行小小的配置“通知” Spring 容器对标注 @Transactional 注解的 Bean 进行加工处理：

```xml
<tx:annotation-driven transaction-manager="txManager"/>
```

在默认情况下，`<tx:annotation-driven>` 会自动使用名为 “transactionManager” 的事务管理器。所以，如果用户的事务管理器 id 为 “transactionManager”，则可以进一步将配置简化为 “`<tx:annotation-driven>`”

`<tx:annotation-driven>` 还有另外两个属性。

- `proxy-target-class`：如果为 true，则 Spring 将通过创建子类来代理业务类；如果为 false，则使用基于接口的代理。如果使用子类代理，则需要在类路径中添加 CGLib.jar 类库。
- `order`：如果业务类除事务切面外，还需要织入其他的切面，则通过该属性可以控制事务切面在目标连接点的织入顺序。

## 1.1 关于 @Transactional 的属性

基于 @Transational 注解的配置和基于 XML 的配置方式一样，它拥有一组普适性很强的默认事务属性，往往可以直接使用这些默认的属性。

- 事务传播行为：PROPAGATION_REQUIRED
- 事务隔离级别：ISOLATION_DEFAULT
- 读写事务属性：读/写事务
- 超时时间：依赖于底层的事务系统的默认值
- 回滚设置：任何运行期异常引发回滚，任何检查型异常不会引发回滚

因为这些默认设置在大多数情况下都是适用的，所以一般不需要手工设置事务注解的属性。当然，Spring 允许通过手工设定属性值覆盖默认值：

| 属性名                 | 说明                                                         |
| ---------------------- | ------------------------------------------------------------ |
| propagation            | 事务传播行为，通过以下枚举类提供合法值：`org.springframework.transaction.annotation.Propogation`。例如：`@Transactional(propagation.REQUIRES_NEW)` |
| isolation              | 事务隔离级别，提供以下枚举类提供合法值：`org.springframework.transaction.annotation.Isolation`。例如：`@Transactional(isolation=Isolation.READ_COMMITED)` |
| readOnly               | 事务读写性，布尔型。例如 `@Transactional(readOnly = true)`   |
| timeout                | 超时时间，int 型，以秒为单位。例如 `@Transactional(timeout = 10)` |
| rollbackFor            | 一组异常类，遇到时进行回滚，类型为：`Class <? extends Throwable>[]`，默认值为 `{}`。例如： `@Transactional(rollbackFor={SQLException.class})`。多个异常之间可用逗号分隔 |
| rollbackForClassName   | 一组异常类名，遇到时进行回滚，类型为 `String[]`，默认值为 `{}`。例如： `@Transactional(rollbackForClassName={"Exception"})` |
| noRollbackFor          | 一组异常类，遇到时不回滚，类型为：`Class <? extends Throwable>[]`，默认值为 `{}`。 |
| noRollbackForClassName | 一组异常类名，遇到时不回滚，类型为 `String[]`，默认值为 `{}`。 |

## 1.2 在何处标注 @Transactional 注解

@Transactional 注解可以被应用于接口定义和接口方法、类定义和类的 public 方法上。

但 Spring 建议在业务实现类上使用 @Transactional 注解。当然也可以在业务接口上使用 @Transactional 注解，但这样会留下一些容易被忽视的隐患。因为注解不能被继承，所以在业务接口中标注的 @Transactional 注解不会被业务实现类继承。如果通过以下配置启用子类代理：

```xml
<tx:annotation-driven transaction-manager="txManager" proxy-target-class="true"/>
```

那么业务类不会添加事务增强，照样工作在非事务环境下。举一个具体的实例：如果使用子类代理，假设用户为 BbtForum 接口标注了 @Transactional 注解，那么其实现类 BbtForumImpl 依旧不会启用事务机制。

因此，Spring 建议在具体业务类上使用 @Transactional 注解。这样，不管 `<tx:annotation-driven>` 将 `proxy-target-class` 属性配置为 true 或 false，业务类都会启用事务机制。

## 1.3 在方法处使用注解

方法处的注解会覆盖类定义处的注解。如果有些方法需要使用特殊的事务属性，则可以在类注解的基础上提供方法注解，如下：

```java
// ① 类级注解，适用于类中所有 public 的方法
@Transactional
public class BbtForum {
    // ② 提供额外的注解信息，它将覆盖 ① 处的类级注解
    @Transactional(readOnly=true)
    public Forum getForum(int forumId) {
        return forumDao.getForum(forumId);
    }
    // ...
}
```

② 处的方法注解提供了 readOnly 事务属性的设置，它将覆盖类级注解中默认的 readOnly=false 设置。

## 1.4 使用不同的事务管理器

一般情况下，一个应用仅需使用一个事务管理器。如果希望在不同的地方使用不同的事务管理器，则可以通过如下方式实现：

```java
@Service
public class MultiForumService {
    // ① 使用名为 topic 的事务管理器
    @Transactional("topic")
    public void addTopic(Topic topic) throws Exception {
        // ...
    }
    // ② 使用名为 forum 的事务管理器
    @Transactional("forum")
    public void updateForum(Forum forum) {
        // ...
    }
}
```

而 topic 和 forum 的事务管理器可以在 XML 中分别定义，如下：

```xml
<bean id="forumTxManager"
      class="org.springframework.jdbc.datasource.DataSourceTransactionManager"
      p:dataSource-ref="forumDataSource"><!-- ①可以使用不同的数据源 -->
    <qualifier value="forum"/> <!-- ②为事务管理器指定一个名字 -->
</bean>
<bean id="topicTxManager"
      class="org.springframework.jdbc.datasource.DataSourceTransactionManager"
      p:dataSource-ref="topicDataSource">
    <qualifier value="topic"/>
</bean>
<tx:annotation-driven/>
```

在 ① 处，为事务管理器指定了一个数据源，每个事务管理器都可以绑定一个独立的数据源。在 ② 处，指定了一个可被 @Transactional 注解引用的事务管理器标识。

在一两处使用带标识的 @Transactional 注解也许是合适的，但是如果到处都使用，则显得比较啰嗦。可以自定义一个绑定到特定事物管理器的注解，然后使用这个自定义的注解进行标识，如下：

```java
@Target({ElementType.METHOD, ElementType.Type})
@Retention(RetentionPolicy.RUNTIME)
@Transactional("forum") // ① 绑定到 forum 的事务管理器中
public @interface ForumTransactional {
}
```

# 2 哪些方法不能实施 Spring AOP 事务

由于 Spring 事务管理是基于接口代理或动态字节码技术，通过 AOP 实施事务增强的，虽然 Spring 依然支持 AspectJ LTW 在类加载期实施增强，但这种方法很少使用，所以我们不予关注。

对于基于接口动态代理的 AOP 事务增强来说，由于接口的方法都必须是 public 的，这就要求实现类的实现方法也必须是 public 的（不能是 protected、private 等），同时不能使用 static 修饰符。所以，可以实施接口动态代理的方法只能是使用 public 或 public final 修饰符的方法，其他方法不可能被动态代理，相应地也就不能实施 AOP 增强。换句话说，即不能进行 Spring 事务增强。

基于 CGLib 字节码动态代理的方案是通过扩展被增强类，动态创建其子类的方式进行 AOP 增强植入的。由于使用 final、static、private 修饰符的方法都不能被子类覆盖，相应地这些方法将无法实施 AOP 增强。所以方法签名必须特别注意这些修饰符的使用，以免使方法不小心成为事务管理的“漏网之鱼”。

| 动态代理策略          | 不能被事务增强的方法                                         |
| --------------------- | ------------------------------------------------------------ |
| 基于接口的动态代理    | 除 public 外的其他所有方法。此外，public static 也不能被增强 |
| 基于 CGLib 的动态代理 | private、static、final 方法                                  |

不过，需要特别指出的是，这些不能被 Spring 事务增强的特殊方法并非就不工作在事务环境下。只要它们被外层的事务方法调用了，由于 Spring 事务管理的传播级别，内部方法也可以在外部方法所启动的事务上下文中。我们说这些方法不能被 Spring 进行 AOP 事务增强，是指这些方法不能启动事务，但是外层方法的事务上下文依旧可以顺利地传播到这些方法中。

这些不能被 Spring 事务增强的方法和可被 Spring 事务增强的方法的唯一区别在于“是否可以主动启动一个新事务”：前者不能而后者可以。对于事物传播行为来说，二者是完全相同的，前者也和后者一样不会造成数据连接的泄漏问题。换句话说，如果这些“特殊方法”被无事务上下文的方法调用，则它们就工作在无事务上下文中；反之，如果被具有事务上下文的方法调用，则它们就工作在事务上下文中。

对于 private 方法，由于最终都会被 public 方法封装后再开放给外部调用，而 public 方法是可以被事务增强的，所以基本上没有什么问题。在实际开发中，最容易造成隐患的是基于 CGLib 动态代理的 public static 和 public final 这两种特殊方法。原因是它们本身是 public 的，因此可以直接被外部类（如 Web 层的 Controller 类）调用，只要调用者没有事务上下文，这些特殊方法也就以无事务的方式运作。

# 3 事务失效的 9 种情况

## 3.1 七种较为简单的情况

根据上面的介绍，我们对 Spring 事务有些基本了解，可以知道事务失效有 7 种较为简单的情况：

1. **数据库引擎不支持事务**：这里以 MySQL 为例，其 MyISAM 引擎是不支持事务操作的，InnoDB 才是支持事务的引擎，一般要支持事务都会使用 InnoDB，这时候选择支持事务的数据库即可
2. **数据源没有配置事务管理器**：相当于没开启事务管理
3. **没有被 Spring 容器管理**：通常情况下，我们通过@Controller、@Service、@Component、@Repository等注解，可以自动实现Bean 实例化和依赖注入的功能。如果把这些注解注释掉，这个类就不会被加载成一个 Bean，那这个类就不会被 Spring 管理了，事务自然就失效了。
4. **方法访问权限不是 public 的**：@Transactional 只能用于 public 的方法上，否则事务失效。如果要用在非 public 方法上，可以开启 AspectJ 代理模式。对应上一节不能实施 Spring AOP 事务的方法，详情可以参考第二节的具体介绍。
5. **传播特性配置错误**：例如，`NOT_SUPPORTED` 传播特性是指如果当前上下文中存在事务，则挂起当前事务，然后新的方法在没有事务的环境中执行。`NEVER` 是如果当前上下文中存在事务，则抛出异常，否则在无事务环境上执行代码。对于这种情况，改成支持事务的传播特性即可。
6. **异常类型错误**：因为默认的异常类型是运行时异常，如果抛出了其他异常就不生效。解决方式：（1）将异常改成运行时异常；（2）指定异常进行事物回滚，如：`@Transactional(rollbackFor = Exception.class)`
7. **异常被 catch 掉了**：必须要抛出异常，否则 Spring 事务管理，不会走到回滚逻辑

## 3.2 第八种事务失效情况：类内部调用

这种情况相对难理解，单独拿出来讲解一下：

```java
@Service
public class UserInfoService {
    public void justUpdate(){
        updateUser2();
    }
    @Transactional(rollbackFor = Exception.class)
    public void updateUser2() {
		// ...
    }
}
```

上述代码不生效，因为内部调用不会涉及到代理类的调用，更不会有AOP的增强，因此不会生效。

我们看到在方法 justUpdate 中，直接调用事务方法 updateUser2。从前面介绍的内容可以知道，updateUser2 方法拥有事务的能力是因为 Spring AOP 生成代理了对象，但是 justUpdate 这种方法直接调用了 this 对象的方法，所以 updateUser2 方法不会生成事务。

解决办法：

**1、自注入**

```java
@Service
public class UserInfoService {
	@Autowired
    private UserInfoService userInfoService;
    public void justUpdate(){
        userInfoService.updateUser2();
    }
    @Transactional(rollbackFor = Exception.class)
    public void updateUser2() {
		// ...
    }
}
```

有人会担心这种做法会不会出现循环依赖问题? 

这里是不会的，其实 Spring IOC 内部的三级缓存保证了它，不会出现循环依赖问题。但有些坑，如果你想进一步了解循环依赖问题，可以参考我之前整理的面试题：[【Spring】如何解决循环依赖问题](./【Spring】如何解决循环依赖问题.md)。

**2、Spring上下文**

```java
@Service
public class UserInfoService {
    ApplicationContext applicationContext;
    public void justUpdate(){
		UserInfoService userInfoService =
            (UserInfoService) applicationContext.getBean("userInfoService");
        userInfoService.updateUser2();
    }
    @Transactional(rollbackFor = Exception.class)
    public void updateUser2() {
        // ...
    }
}
```

**3、获取他的代理类，直接调用代理类**

```java
@Service
public class UserInfoService {
    public void justUpdate(){
		((UserInfoService) AopContext.currentProxy()).updateUser2();
    }
    @Transactional(rollbackFor = Exception.class)
    public void updateUser2() {
        // ...
    }
}
```

##  3.3 第九种事务失效情况：多线程调用

在实际项目开发中，多线程的使用场景还是挺多的。所以这里单独介绍一下 Spring 事务用在多线程场景的事务失效情况。

```java
@Slf4j
@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;
    @Autowired
    private RoleService roleService;

    @Transactional
    public void add(UserModel userModel) throws Exception {
        userMapper.insertUser(userModel);
        new Thread(() -> {
            roleService.doOtherThing();
        }).start();
    }
}

@Service
public class RoleService {

    @Transactional
    public void doOtherThing() {
        System.out.println("保存role表数据");
    }
}
```

从上面的例子中，我们可以看到事务方法 add 中，调用了事务方法 doOtherThing，但是事务方法 doOtherThing 是在另外一个线程中调用的。

这样会导致两个方法不在同一个线程中，获取到的数据库连接不一样，从而是两个不同的事务。如果想 doOtherThing 方法中抛了异常，add 方法也回滚是不可能的。

如果看过 Spring 事务源码的朋友，可能会知道 Spring 的事务是通过数据库连接来实现的。当前线程中保存了一个 map，key 是数据源，value 是数据库连接。

```java
private static final ThreadLocal<Map<Object, Object>> resources =
    new NamedThreadLocal<>("Transactional resources");
```

我们说的同一个事务，其实是指同一个数据库连接，只有拥有同一个数据库连接才能同时提交和回滚。如果在不同的线程，拿到的数据库连接肯定是不一样的，所以是不同的事务。

# 参考文档

- 《精通 Spring 4.x 企业应用开发实战》11.6.1 使用 @Transactional 注解、12.6 特殊方法成漏网之鱼
- 事物失效的8种情况及解决办法：https://www.cnblogs.com/zeenzhou/p/15219794.html
- 聊聊 Spring 事务失效的 12 种场景，太坑了：https://blog.csdn.net/lisu061714112/article/details/120098743