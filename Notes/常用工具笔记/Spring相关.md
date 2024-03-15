# Spring 事务嵌套

来源：https://www.cnblogs.com/duanxz/p/4746892.html

## 一、基本概念
 事务的隔离级别，事务传播行为见《事务之二：spring事务（事务管理方式，事务5隔离级别，7个事务传播行为，spring事务回滚条件） 》 https://www.cnblogs.com/duanxz/p/3439387.html

## 二、 嵌套事务示例

调用顺序：
~~~
ServiceA-1      A       外层方法        1
ServiceB        B       内层方法        2
ServiceA-2      A       外层方法        3
~~~

### 2.1、Propagation.REQUIRED+Propagation.REQUIRES_NEW
~~~java
package dxz.demo1;


@Service
public class ServiceAImpl implements ServiceA {

    @Autowired
    private ServiceB serviceB;
    
    @Autowired
    private VcSettleMainMapper vcSettleMainMapper;
    
    @Override
    @Transactional(propagation = Propagation.REQUIRED, readOnly = false)
    public void methodA() {
        String id = IdGenerator.generatePayId("A");
        VcSettleMain vc = buildModel(id);
        vcSettleMainMapper.insertVcSettleMain(vc);
        System.out.println("ServiceAImpl VcSettleMain111:" + vc);
        
        serviceB.methodB();  
        
        VcSettleMain vc2 = buildModel(id);
        vcSettleMainMapper.insertVcSettleMain(vc2);
        System.out.println("ServiceAImpl VcSettleMain22222:" + vc2);
    }

    private VcSettleMain buildModel(String id) {
        VcSettleMain vc = new VcSettleMain();
        vc.setBatchNo(id);
        vc.setCreateBy("dxz");
        vc.setCreateTime(LocalDateTime.now());
        vc.setTotalCount(11L);
        vc.setTotalMoney(BigDecimal.ZERO);
        vc.setState("5");
        return vc;
    }

}
~~~

ServiceB

~~~java
package dxz.demo1;


@Service
public class ServiceBImpl implements ServiceB {

    @Autowired
    private VcSettleMainMapper vcSettleMainMapper;
    
    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW, readOnly = false)
    public void methodB() {
        String id = IdGenerator.generatePayId("B");
        VcSettleMain vc = buildModel(id);
        vcSettleMainMapper.insertVcSettleMain(vc);
        System.out.println("---ServiceBImpl VcSettleMain:" + vc);
    }
}
~~~

controller

~~~java
package dxz.demo1;

@RestController
@RequestMapping("/dxzdemo1")
@Api(value = "Demo1", description="Demo1")
public class Demo1 {
    @Autowired
    private ServiceA serviceA;

    /**
     * 嵌套事务测试
     */
    @PostMapping(value = "/test1")
    public String methodA() throws Exception {
        serviceA.methodA();
        return "ok";
    }
}
~~~
结果：

Response Body
"exception":"org.springframework.dao.DuplicateKeyException"

看数据库表记录：

存在B中插入的数据

这种情况下, 因为 ServiceB#methodB 的事务属性为 PROPAGATION_REQUIRES_NEW，ServiceB是一个独立的事务，与外层事务没有任何关系。如果ServiceB执行失败（上面示例中让ServiceB的id为已经存在的值），ServiceA的调用出会抛出异常，导致ServiceA的事务回滚。

并且， 在 ServiceB#methodB 执行时 ServiceA#methodA 的事务已经挂起了 (关于事务挂起的内容已经超出了本文的讨论范围）。

### 2.2、Propagation.REQUIRED+Propagation.REQUIRED
~~~java
//ServiceA
//...
    @Override
    @Transactional(propagation = Propagation.REQUIRED, readOnly = false)
    public void methodA() {

//ServiceB
//...
    @Override
    @Transactional(propagation = Propagation.REQUIRED, readOnly = false)
    public void methodB(String id) {
//...
~~~
--“1”可插入，“2”可插入，“3”不可插入：

结果是“1”，“2”，“3”都不能插入，“1”，“2”被回滚。

--“1”可插入，“2”不可插入，“3”可插入：

结果是“1”，“2”，“3”都不能插入，“1”，“2”被回滚。

### 2.3、Propagation.REQUIRED+无事务注解
~~~java
//ServiceA
//...
    @Override
    @Transactional(propagation = Propagation.REQUIRED, readOnly = false)
    public void methodA() {

//ServiceB
//...
    @Override
    //没有加事务注解
    public void methodB(String id) {
//...
~~~
--“1”可插入，“2”可插入，“3”不可插入：

结果是“1”，“2”，“3”都不能插入，“1”，“2”被回滚。

### 2.4、内层事务被try-catch：

2.4.1、trycatch+Propagation.REQUIRED+Propagation.REQUIRED
~~~java
//ServiceA
//...
    @Override
    @Transactional(propagation = Propagation.REQUIRED, readOnly = false)
    public void methodA() {
        try {
            serviceB.methodB(id);
        } catch (Exception e) {
            System.out.println("内层事务出错啦。");
        }
    }

//ServiceB
//...
    @Override
    @Transactional(propagation = Propagation.REQUIRED, readOnly = false)
    public void methodB(String id) {
//...
~~~
--“1”可插入，“2”不可插入，“3”可插入：

结果是“1”，“2”，“3”都不能插入，“1”被回滚。

事务设置为Propagation.REQUIRED时，如果内层方法抛出Exception，外层方法中捕获Exception但是并没有继续向外抛出，最后出现“Transaction rolled back because it has been marked as rollback-only”的错误。外层的方法也将会回滚。

其原因是：内层方法抛异常返回时，transacation被设置为rollback-only了，但是外层方法将异常消化掉，没有继续向外抛，那么外层方法正常结束时，transaction会执行commit操作，但是transaction已经被设置为rollback-only了。所以，出现“Transaction rolled back because it has been marked as rollback-only”错误。

2.4.2、trycatch+Propagation.REQUIRED+Propagation.NESTED
~~~java
//ServiceA
//...
    @Override
    @Transactional(propagation = Propagation.REQUIRED, readOnly = false)
    public void methodA() {
        try {
            serviceB.methodB(id);
        } catch (Exception e) {
            System.out.println("内层事务出错啦。");
        }
    }

//ServiceB
//...
    @Override
    @Transactional(propagation = Propagation.NESTED, readOnly = false)
    public void methodB(String id) {
//...
~~~
--“1”可插入，“2”不可插入，“3”可插入：

结果是“1”，“3"记录插入成功，“2”记录插入失败。

说明：

当内层配置成 PROPAGATION_NESTED, 此时两者之间又将如何协作呢? 从 Juergen Hoeller 的原话中我们可以找到答案, ServiceB#methodB 如果 rollback, 那么内部事务(即 ServiceB#methodB) 将回滚到它执行前的 SavePoint(注意, 这是本文中第一次提到它, 潜套事务中最核心的概念), 而外部事务(即 ServiceA#methodA) 可以有以下两种处理方式：

1、内层失败，外层调用其它分支，代码如下

~~~java
ServiceA {  
      
    /** 
     * 事务属性配置为 PROPAGATION_REQUIRED 
     */  
    void methodA() {  
        try {  
            ServiceB.methodB();  
        } catch (SomeException) {  
            // 执行其他业务, 如 ServiceC.methodC();  
        }  
    }  
  
}  
~~~
这种方式也是潜套事务最有价值的地方, 它起到了分支执行的效果, 如果 ServiceB.methodB 失败, 那么执行 ServiceC.methodC(), 而 ServiceB.methodB 已经回滚到它执行之前的 SavePoint, 所以不会产生脏数据(相当于此方法从未执行过), 这种特性可以用在某些特殊的业务中, 而 PROPAGATION_REQUIRED 和 PROPAGATION_REQUIRES_NEW 都没有办法做到这一点。

2.代码不做任何修改, 那么如果内部事务(即 ServiceB#methodB) rollback, 那么首先 ServiceB.methodB 回滚到它执行之前的 SavePoint(在任何情况下都会如此), 外部事务(即 ServiceA#methodA) 将根据具体的配置决定自己是 commit 还是 rollback。

## 三、嵌套事务总结

使用嵌套事务的场景有两点需求：

需要事务BC与事务AD一起commit，即：作为事务AD的子事务，事务BC只有在事务AD成功commit时（阶段3成功）才commit。这个需求简单称之为“联合成功”。这一点PROPAGATION_NESTED和PROPAGATION_REQUIRED可以做到。

需要事务BC的rollback不（无条件的）影响事务AD的commit。这个需求简单称之为“隔离失败”。这一点PROPAGATION_NESTED和PROPAGATION_REQUIRES_NEW可以做到。
分解下，可知PROPAGATION_NESTED的特殊性有：

- 1、使用PROPAGATION_REQUIRED满足需求1，但子事务BC的rollback会无条件地使父事务AD也rollback，不能满足需求2。即使对子事务进行了try-catch，父事务AD也不能commit。示例见2.4.1、trycatch+Propagation.REQUIRED+Propagation.REQUIRED

- 2、使用PROPAGATION_REQUIRES_NEW满足需求2，但子事务（这时不应该称之为子事务）BC是完全新的事务上下文，父事务（这时也不应该称之为父事务）AD的成功与否完全不影响BC的提交，不能满足需求1。

同时满足上述两条需求就要用到PROPAGATION_NESTED了。PROPAGATION_NESTED在事务AD执行到B点时，设置了savePoint（关键）。

当BC事务成功commit时，PROPAGATION_NESTED的行为与PROPAGATION_REQUIRED一样。只有当事务AD在D点成功commit时，事务BC才真正commit，如果阶段3执行异常，导致事务AD rollback，事务BC也将一起rollback ，从而满足了“联合成功”。

 当阶段2执行异常，导致BC事务rollback时，因为设置了savePoint，AD事务可以选择与BC一起rollback或继续阶段3的执行并保留阶段1的执行结果，从而满足了“隔离失败”。

当然，要明确一点，事务传播策略的定义是在声明或事务管理范围内的（首先是在EJB CMT规范中定义，Spring事务框架补充了PROPAGATION_NESTED），编程式的事务管理不存在事务传播的问题。

## 四、PROPAGATION_NESTED的必要条件

上面大致讲述了嵌套事务的使用场景, 下面我们来看如何在 spring 中使用 PROPAGATION_NESTED, 首先来看 AbstractPlatformTransactionManager 

~~~java
/** 
 * Create a TransactionStatus for an existing transaction. 
 */  
private TransactionStatus handleExistingTransaction(  
        TransactionDefinition definition, Object transaction, boolean debugEnabled)  
        throws TransactionException {  
  
   ... 省略  
  
    if (definition.getPropagationBehavior() == TransactionDefinition.PROPAGATION_NESTED) {  
        if (!isNestedTransactionAllowed()) {  
            throw new NestedTransactionNotSupportedException(  
                    "Transaction manager does not allow nested transactions by default - " +  
                    "specify 'nestedTransactionAllowed' property with value 'true'");  
        }  
        if (debugEnabled) {  
            logger.debug("Creating nested transaction with name [" + definition.getName() + "]");  
        }  
        if (useSavepointForNestedTransaction()) {  
            // Create savepoint within existing Spring-managed transaction,  
            // through the SavepointManager API implemented by TransactionStatus.  
            // Usually uses JDBC 3.0 savepoints. Never activates Spring synchronization.  
            DefaultTransactionStatus status =  
                    newTransactionStatus(definition, transaction, false, false, debugEnabled, null);  
            status.createAndHoldSavepoint();  
            return status;  
        }  
        else {  
            // Nested transaction through nested begin and commit/rollback calls.  
            // Usually only for JTA: Spring synchronization might get activated here  
            // in case of a pre-existing JTA transaction.  
            doBegin(transaction, definition);  
            boolean newSynchronization = (this.transactionSynchronization != SYNCHRONIZATION_NEVER);  
            return newTransactionStatus(definition, transaction, true, newSynchronization, debugEnabled, null);  
        }  
    }  
} 
~~~

1、 我们要设置 transactionManager 的 nestedTransactionAllowed 属性为 true, 注意, 此属性默认为 false!!! 

再看 AbstractTransactionStatus#createAndHoldSavepoint() 方法 

~~~java
/** 
 * Create a savepoint and hold it for the transaction. 
 * @throws org.springframework.transaction.NestedTransactionNotSupportedException 
 * if the underlying transaction does not support savepoints 
 */  
public void createAndHoldSavepoint() throws TransactionException {  
    setSavepoint(getSavepointManager().createSavepoint());  
}  
~~~
  可以看到 Savepoint 是 SavepointManager.createSavepoint 实现的, 再看 SavepointManager 的层次结构, 发现其 Template 实现是 JdbcTransactionObjectSupport, 常用的 DatasourceTransactionManager, HibernateTransactionManager 中的 TransactonObject 都是它的子类 : 

  JdbcTransactionObjectSupport 告诉我们必须要满足两个条件才能 createSavepoint : 

 2、 java.sql.Savepoint 必须存在, 即 jdk 版本要 1.4+ 

 3、 Connection.getMetaData().supportsSavepoints() 必须为 true, 即 jdbc drive 必须支持 JDBC 3.0 确保以上条件都满足后, 你就可以尝试使用 PROPAGATION_NESTED 了。

# 不同的bean控制初始化顺序

来源：https://sq.163yun.com/blog/article/191350999869239296

开发过程中有这样一个场景，2个 bean 初始化逻辑中有依赖关系，需要控制二者的初始化顺序。实现方式可以有多种，本文结合目前对 Spring 的理解，尝试列出几种思路。

场景

假设A，B两个 bean 都需要在初始化的时候从本地磁盘读取文件，其中B加载的文件，依赖A中加载的全局配置文件中配置的路径，所以需要A先于B初始化，此外A中的配置改变后也需要触发B的重新加载逻辑，所以A，B需要注入彼此。

对于下面的模型，问题简化为：我们需要initA()先于initB()得到执行。
~~~java
@Service
public class A {
    @Autowired
    private B b;

    public A() {
        System.out.println("A construct");
    }

    @PostConstruct
    public void init() {
        initA();
    }

    private void initA() {
        System.out.println("A init");
    }
}

@Service
public class B  {
    @Autowired
    private A a;

    public B() {
        System.out.println("B construct");
    }

    @PostConstruct
    public void init() {
        initB();
    }

    private void initB(){
        System.out.println("B init");
    }
}
~~~
## 方案一：立Flag

我们可以在业务层自己控制A，B的初始化顺序，在A中设置一个“是否初始化的”标记，B初始化前检测A是否得以初始化，如果没有则调用A的初始化方法，所谓的check-and-act。对于上述模型，实现如下：

~~~java
@Service
public class A {

    private static volatile boolean initialized;

    @Autowired
    private B b;

    public A() {
        System.out.println("A construct");
    }

    @PostConstruct
    public void init() {
        initA();
    }

    public boolean isInitialized() {
        return initialized;
    }

    public void initA() {
        if (!isInitialized()) {
            System.out.println("A init");
        }
        initialized = true;
    }
}

@Service
public class B {

    @Autowired
    private A a;


    public B() {
        System.out.println("B construct");
    }

    @PostConstruct
    public void init() {
        initB();
    }


    private void initB() {
        if (!a.isInitialized()) {
            a.initA();
        }
        System.out.println("B init");
    }
}
~~~
执行效果：

~~~
A construct
B construct
A init
B init
~~~
这种立flag的方法好处是可以做到lazy initialization，但是如果类似逻辑很多的话代码中到处充斥着类似代码，不优雅，所以考虑是否框架本身就可以满足我们的需要。

## 方案二：使用DependsOn

Spring 中的 DependsOn 注解可以保证被依赖的bean先于当前bean被容器创建，但是如果不理解Spring中bean加载过程会对 DependsOn 有误解，自己也确实踩过坑。对于上述模型，如果在B上加上注解`@DependsOn({"a"})`，得到的执行结果是：

~~~
A construct
B construct
B init
A init
~~~
在这里问题的关键是：bean属性的注入是在初始化方法调用之前。

~~~java
// 代码位置：AbstractAutowireCapableBeanFactory.doCreateBean
// 填充 bean 的各个属性，包括依赖注入
populateBean(beanName, mbd, instanceWrapper);
if (exposedObject != null) {
    // 调用初始化方法，如果是 InitializingBean 则先调用 afterPropertiesSet 然后调用自定义的init-method 方法
    exposedObject = initializeBean(beanName, exposedObject, mbd);
}
~~~
结合本例，发生的实际情况是，因为出现了循环依赖，A依赖B，加载B，B依赖A，所以得到了一个提前暴露的A，然后调用B的初始化方法，接着回到A的初始化方法。具体源码分析过程如下：

ApplicationContext 在 refresh 过程中的最后会加载所有的 no-lazy 单例。

~~~
AbstractApplicationContext.refresh()
↓
AbstractApplicationContext.finishBeanFactoryInitialization()
↓
DefaultListableBeanFactory.preInstantiateSingletons()
↓
AbstractBeanFactory.getBean()
↓
AbstractBeanFactory.doGetBean()
↓
AbstractAutowireCapableBeanFactory.createBean()
~~~

本例中，先加载的bean A，最终通过无参构造器构造，然后，继续属性填充（populateBean），发现需要注入 bean B。所以转而加载 bean B（递归调用 getBean()）。此时发现 bean B 需要 DependsOn("a")，在保存依赖关系（为了防止循环 depends）后，调用 getBean("a")，此时会得到提前暴露的 bean A ，所以继续 B 的加载，流程为： 初始化策略构造实例 -> 属性填充（同样会注入提前暴露的 bean A ） -> 调用初始化方法。
~~~java
// 代码位置：AbstractBeanFactory.doGetBean
// Guarantee initialization of beans that the current bean depends on. 实例化依赖的 bean
        String[] dependsOn = mbd.getDependsOn();
        if (dependsOn != null) {
            for (String dep : dependsOn) {
                if (isDependent(beanName, dep)) {
                    throw new BeanCreationException(mbd.getResourceDescription(),
                            beanName, "Circular depends-on relationship between '"
                            + beanName + "' and '" + dep + "'");
                }
                registerDependentBean(dep, beanName); // 缓存 bean 依赖的关系
                getBean(dep);
            }
        }
~~~
得到提前暴露的 bean A的过程为：
~~~java
protected Object getSingleton(String beanName, boolean allowEarlyReference) {
    // 查缓存
    // 看看有没有正在创建？
    // 更新缓存earlySingletonObjects和singletonFactory互斥
}
~~~


此时此刻，bean A 的属性注入完成了， 返回到调用初始化方法，所以表现的行为是：构造A -> 构造B -> B初始化 -> A初始化。

DependsOn只是保证的被依赖的bean先于当前bean被实例化，被创建，所以如果要采用这种方式实现bean初始化顺序的控制，那么可以把初始化逻辑放在构造函数中，但是复杂耗时的逻辑放在构造器中是不合适的，会影响系统启动速度。

## 方案三：容器加载bean之前

Spring 框架中很多地方都为我们提供了扩展点，很好的体现了开闭原则（OCP）。其中 BeanFactoryPostProcessor 可以允许我们在容器加载任何bean之前修改应用上下文中的BeanDefinition（从XML配置文件或者配置类中解析得到的bean信息，用于后续实例化bean）。

在本例中，就可以把A的初始化逻辑放在一个 BeanFactoryPostProcessor 中。
~~~java
@Component
public class ABeanFactoryPostProcessor implements BeanFactoryPostProcessor {
    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory configurableListableBeanFactory) throws BeansException {
        A.initA();
    }
}
~~~
执行效果：
~~~
A init
A construct
B construct
B init
~~~
这种方式把A中的初始化逻辑放到了加载bean之前，很适合加载系统全局配置，但是这种方式中初始化逻辑不能依赖bean的状态。

## 方案四：事件监听器的有序性

Spring 中的 Ordered 也是一个很重要的组件，很多逻辑中都会判断对象是否实现了 Ordered 接口，如果实现了就会先进行排序操作。比如在事件发布的时候，对获取到的 ApplicationListener 会先进行排序。
~~~java
// 代码位置：AbstractApplicationEventMulticaster.ListenerRetriever.getApplicationListeners()
public Collection<ApplicationListener<?>> getApplicationListeners() {
        LinkedList<ApplicationListener<?>> allListeners = new LinkedList<ApplicationListener<?>>();
        for (ApplicationListener<?> listener : this.applicationListeners) {
            allListeners.add(listener);
        }
        if (!this.applicationListenerBeans.isEmpty()) {
            BeanFactory beanFactory = getBeanFactory();
            for (String listenerBeanName : this.applicationListenerBeans) {
                try {
                    ApplicationListener<?> listener = beanFactory.getBean(listenerBeanName, ApplicationListener.class);
                    if (this.preFiltered || !allListeners.contains(listener)) {
                        allListeners.add(listener);
                    }
                } catch (NoSuchBeanDefinitionException ex) {
                    // Singleton listener instance (without backing bean definition) disappeared -
                    // probably in the middle of the destruction phase
                }
            }
        }
        AnnotationAwareOrderComparator.sort(allListeners); // 排序
        return allListeners;
    }
~~~
所以可以利用事件监听器在处理事件时的有序性，在应用上下文 refresh 完成后，分别实现A，B中对应的初始化逻辑。
~~~java
@Component
public class ApplicationListenerA implements ApplicationListener<ApplicationContextEvent>, Ordered {
    @Override
    public void onApplicationEvent(ApplicationContextEvent event) {
        initA();
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE; // 比 ApplicationListenerB 优先级高
    }

    public static void initA() {
        System.out.println("A init");
    }
}

@Component
public class ApplicationListenerB implements ApplicationListener<ApplicationContextEvent>, Ordered{
    @Override
    public void onApplicationEvent(ApplicationContextEvent event) {
        initB();
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE -1;
    }

    private void initB() {
        System.out.println("B init");
    }
}
~~~
执行效果：
~~~
A construct
B construct
A init
B init
~~~
这种方式就是站在事件响应的角度，上下文加载完成后，先实现A逻辑，然后实现B逻辑。

## 总结
在平时的开发中使用的可能都是一个语言，一个框架的冰山一角，随着对语言，对框架的不断深入，你会发现更多的可能。本文只是基于目前对于 Spring 框架的理解做出的尝试，解决一个问题可能有多种方式，其中必然存在权衡选择，取决于对业务对技术的理解。



# <tx:annotation-driven /> 配置多事务管理时的一些问题

https://blog.csdn.net/zhanlanmg/article/details/79116539

spring事务`tx:annotation-driven`在使用中可能存在的问题。起因是在某实际工程中，配置了多个`tx:annotation-driven`以及多个`org.springframework.jdbc.datasource.DataSourceTransactionManager`导致最终事务失效的问题。

## 重点

1. `<tx:annotation-driven />` 只需要配置一个即可，如果配置了多个，事务以第一个为准，其它属性项，以级别最高的为准
2. 如果使用默认值`transactionManager`则`<tx:annotation-driven />`中可以不指定属性`transaction-manager`
3. 第一个`<tx:annotation-driven />`加载时，指定的事务会成为默认事务，无论指定的事务管理器的名称是否是`transactionManager`
4. 使用注解`@Transactional`时，如果不指定具体的事务管理器，会使用上面这个默认事务处理器
5. 如果在多个配置文件中配置了`<tx:annotation-driven />`，无法保证启动时的加载顺序，此时默认事务管理器就有可能会变
6. 为保证使用的事务永远是期望的，应该做到在使用注解`@Transactional`时，指明使用的事务处理器的id、name或者qualifier



# 多个事务管理器的情况下，使用`<aop:config>`配置事务导致No qualifying bean错误

### 简单原因：

使用了下面的配置

```xml
<beans>
    <!--省略其它配置-->
    <tx:advice id="1" transaction-manager="transactionManagerTest">
        <tx:attributes>
            <tx:method name="*" rollback-for="Exception"/>
        </tx:attributes>
    </tx:advice>

    <aop:config>
        <aop:pointcut id="interceptorPointCuts"
                      expression="execution(* org.nomadic.test.service.WordTestService.*(..))"/>
        <aop:advisor advice-ref="2"
                     pointcut-ref="interceptorPointCuts"/>
    </aop:config>
</beans>
```

### 详细原因：

在 `tx:advice` 配置中，无法指定 `tx:attribute` 的 `qualifier` ，导致创建 `TransactionInterceptor` 时，对其 `Properties` 没有设置 `qualifier` ，而是直接将引用的类写入了其父类 `TransactionAspectSupport` 的属性 `transactionManagerCache` 中，而 `transactionManagerCache` 中的值默认都是 `SoftReference` ( 只有 `SOFT` 和 `WEAK` 可选，默认 `SOFT` )，导致当内存不足时，此缓存中的事务配置会被GC回收掉。因此在执行事务的时候，会重新获取，由于没有 `qualifier` ，又没有类名（配置的时候只配置了具体的实例对象），所以 Spring 会通过类型获取，即获取 `PlatformTransactionManager` 的实现，而此时，多事务的情况下，就会有多个 `PlatformTransactionManager` 的 `Bean` 即会出现异常`org.springframework.beans.factory.NoUniqueBeanDefinitionException: No qualifying bean of type [org.springframework.transaction.PlatformTransactionManager] is defined: expected single matching bean but found 2: transactionManager,transactionManagerTest`。

### 解决方案：

#### 方案一：

使用配置bean的方式配置一个 `TransactionInterceptor` ，不使用注解 `tx:advice` 。

```xml
<beans>
    <!--省略其它配置-->
    <tx:advice id="1" transaction-manager="transactionManagerTest">
        <tx:attributes>
            <tx:method name="*" rollback-for="Exception"/>
        </tx:attributes>
    </tx:advice>

    <!--使用2这个bean替换1这个bean就好了。毕竟注解只是为了配置方便，但是功能有缺陷-->
    <bean id="2" class="org.springframework.transaction.interceptor.TransactionInterceptor">
        <property name="transactionAttributeSource">
            <bean class="org.springframework.transaction.interceptor.NameMatchTransactionAttributeSource">
                <property name="nameMap">
                    <map>
                        <entry key="*">
                            <bean class="org.springframework.transaction.interceptor.RuleBasedTransactionAttribute">
                                <!--指定事务-->
                                <property name="qualifier" value="transactionManagerTest"/>
                                <property name="rollbackRules">
                                    <list >
                                        <bean class="org.springframework.transaction.interceptor.RollbackRuleAttribute">
                                            <constructor-arg type="java.lang.Class" value="java.lang.Exception"/>
                                        </bean>
                                    </list>
                                </property>
                            </bean>
                        </entry>
                    </map>
                </property>
            </bean>
        </property>
    </bean>
</beans>
```

#### 方案二：

1. spring 在解析注解 `@Transactional` 的时候，会将 `value` 的值写入到 `qualifier` 中，和上面 `2` 的配置一样。如果不写，则是空的（会使用默认事务）。所以建议 `@Transactional` 一定要带上 `value` 属性，指定具体的事务管理器。
2.  `<tx:annotation-driven transaction-manager="transactionManager"/>` 会将属性 `transaction-manager` 的值设置到 `TransactionInterceptor` 的父类 `TransactionAspectSupport` 的 `transactionManagerBeanName` 属性中。如果不指定 `transaction-manager` ，设置的也是 `transactionManager` 。
3. 事务执行的时候，在 `TransactionAspectSupport#determineTransactionManager()` 中，先检查 `qualifier` ，再检查 `transactionManagerBeanName` ，如果这两个都没有值，则获取配置的 `TransactionManager bean` 对象。
4. 如上面原因说的那样，再结合以上三点，由于这个 `TransactionManager bean` 对象是放在 `SoftReference` 中的，随时可能会丢失。所以通过 `tx:advice` 配置的事务是严重不靠谱的，它会丢失`bean`，在单事务管理下没有问题，但是在多事务管理下，就会出现 `org.springframework.beans.factory.NoUniqueBeanDefinitionException: No qualifying bean of type [org.springframework.transaction.PlatformTransactionManager] is defined: expected single matching bean but found 2: transactionManager,transactionManagerTest` 这样的异常。所以使用全注解的方式，可以保证事务执行的正确性，另外，可以避免 `tx:advice` 在多事务下出现的异常。
5.  `<tx:annotation-driven transaction-manager="transactionManager"/>` 在 xml 中可以配置多个，但是只有第一个会生效，后面的不会创建新的 `TransactionInterceptor` 实例。

## 总结

这个问题总算是解决了，不再出现事务错误的问题了。谨记一点，能使用注解就使用注解 `<tx:annotation-driven transaction-manager="transactionManager"/>` 和 `@Transactional`，避免使用 `<tx:advice />` 这个配置项。

# @autowired 获取bean 在static方法中 报null指针异常(@PostConstruct等方式解决)

https://blog.csdn.net/qq_32784303/article/details/95750543

错误代码：

```java
@Component
public final class Util {
    private static Log log = LogFactory.getLog(Util.class);
    @Autowired
    private static RedisUtil redisUtil;

    public static String getValue(String key) {
        return redisUtil.getKey(key);
    }
}
```
原因：

静态变量、类变量不是对象的属性，而是一个类的属性，所以静态方法是属于类（class）的，普通方法才是属于实体对象（也就是New出来的对象）的，spring注入是在容器中实例化对象，所以不能使用静态方法。

## 解决方法1：


```java
@Component
public final class Util {
    private static Log log = LogFactory.getLog(Util.class);
    private static RedisUtil redisUtil;
    @Autowired
    public Util(RedisUtil redisUtil){
        Util.redisUtil=redisUtil;
    }

    public static String getValue(String key) {
        return redisUtil.getKey(key);
    }
}
```
## 解决方法2：


```java
@Component
public final class Util {
    private static Log log = LogFactory.getLog(Util.class);
    private static RedisUtil redisUtil;

    @Autowired
    private RedisUtil redisUtil2;

    @PostConstruct
    public void beforeInit() {
        redisUtil = redisUtil2;
    }

    public static String getValue(String key) {
        return redisUtil.getKey(key);
    }
}
```
## 解决方法3：实现ApplicationContextAware类

```java
@Component
public class SMSVerificationUtils implements ApplicationContextAware{
    protected static Logger smsLogger=LoggerFactory.getLogger("SMSVerificationUtils");

    private static SmsConfig smsConfig;
    @Resource(name="smsConfig")
    private SmsConfig smsConfigs;
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        // TODO Auto-generated method stub
        smsConfig=smsConfigs;
    }
}
```

# Spring Boot 和 JavaFX 的集成

转载自：https://codingdict.com/questions/130490



有很多方法可以将依赖项注入到JavaFX应用程序中。例如，Gluon有一个名为[Gluon Ignite](https://gluonhq.com/labs/ignite/)的项目，该项目使JavaFX应用程序可用于各种依赖项注入框架，例如Guice，Spring和Dagger。

在为依赖项注入框架选择了Spring并希望使用大量其他Spring工具（例如Spring Data存储库）之后，您可能希望考虑使用SpringBoot应用程序。

您可以将JavaFX应用程序设为SpringBoot应用程序（尽管严格来说，这并不是为了获得依赖注入而必须这样做），以便在应用程序中获得大量Spring设施。如果您四处搜寻，网上会有一些教程。

## Spring和JavaFX的基本示例集成

这是有关将JavaFX与SpringBoot应用程序集成的教程的示例：

- [让Spring成为您的JavaFX Controller Factory](http://www.greggbolinger.com/let-spring-be-your-javafx-controller-factory/)

该示例的关键部分是应用程序的 init() 方法（我刚刚在此处复制并粘贴并复制以供参考）：

```
@SpringBootApplication
public class DemoApplication extends Application {

    private ConfigurableApplicationContext springContext;
    private Parent root;

    @Override
    public void init() throws Exception {
        springContext = SpringApplication.run(DemoApplication.class);
        FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/sample.fxml"));
        fxmlLoader.setControllerFactory(springContext::getBean);
        root = fxmlLoader.load();
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        primaryStage.setTitle("Hello World");
        Scene scene = new Scene(root, 800, 600);
        primaryStage.setScene(scene);
        primaryStage.show();
    }

    @Override
    public void stop() throws Exception {
        springContext.stop();
    }


    public static void main(String[] args) {
        launch(DemoApplication.class, args);
    }
}
```

示例应用程序正在运行SpringBoot应用程序以启动Spring系统，并在init方法中提供应用程序上下文。然后，该应用程序使用FXMLLoader
[`setControllerFactory()`](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXMLLoader.html#setControllerFactory(javafx.util.Callback))方法允许Spring实例化FXML控制器，并在应用程序中注入对Spring Bean的引用。

## 自动接线JavaFX控制器

要自动连接您的JAVAFX FXML控制器，除了以下调用，还需要调用FXMLLoader：

```
fxmlLoader.setControllerFactory(springContext::getBean);
```

您还需要将类注释为Spring`@Component`，并且`@Autowired`在您希望控制器使用的任何Spring依赖项中。这样，FXMLLoader将注入基于@FXML的对UI元素的引用，还将委托给Spring上下文以注入Spring依赖项。

```
@Component
public class DemoController {
    @FXML
    private Label usernameLabel;

    @Autowired
    public void mySpringService;

    public void initialize() {
        usernameLabel.setText(
            mySpringService.getLoggedInUsername()
        );
    }
}
```

注意，Spring有一个`@Controller`注释，该注释可用于注释JavaFX控制器而不是`@Component`注释，但是我建议避免`@Controller`为此目的使用，而应`@Controller`为Spring REST服务端点控制器定义注释。

## Spring Boot应用程序和JavaFX应用程序之间的关注点分离

您可能需要注意的一件事是，运行SpringBoot应用程序，生成该应用程序的新实例，并且您已经拥有JavaFX系统启动的JavaFX应用程序实例，因此如果使用SpringBoot应用程序，则将导致两个JavaFX应用程序实例和JavaFX应用程序基于相同的类（如上所示），这可能会造成混淆。

因此，最好将Spring应用程序和JavaFX应用程序分开。这增强了应用程序的UI和服务部分之间关注点的分离，并使得测试更加容易，因为可以独立于启动和关闭JavaFX应用程序而对Spring应用程序进行单元测试。

## 自动装配JavaFX应用程序类

注意，使用上面的设置，它不会自动装配JavaFX应用程序类实例化实例。如果您希望这样做，可以使用下面说明的技术在JavaFX实例化的应用程序类中注入bean：

- [将bean注入到Spring托管上下文之外的类中](http://codingdict.com/questions/136398)

将以下代码放入应用程序的init方法中：

```
springContext
    .getAutowireCapableBeanFactory()
    .autowireBeanProperties(
        this,
        AutowireCapableBeanFactory.AUTOWIRE_BY_TYPE, 
        true
    );
```

该[mvvmFX框架](https://github.com/sialcasa/mvvmFX)采用了类似的方法除了以上概述，以SpringBoot使用JavaFX应用程序集成：

- [用于集成SpringBoot的mvvmFX代码](https://github.com/sialcasa/mvvmFX/blob/develop/mvvmfx-spring-boot/src/main/java/de/saxsys/mvvmfx/spring/MvvmfxSpringApplication.java)。

## 将命令行参数从JavaFX传递到SpringBoot

要将参数从JavaFX应用程序传递到SpringBoot应用程序，请使用：

```
SpringApplication.run(
    DemoApplication.class, 
    getParameters().getRaw().toArray(new String[0])
);
```

**其他事宜**

如果需要甚至更多地控制SpringApplication的启动，则可以使用SpringApplicationBuilder例如：

```
ConfigurableApplicationContext startupContext =
        new SpringApplicationBuilder(DemoApplication.class)
                .web(WebApplicationType.NONE)
                .run(args);
```

编写此答案仅是为了提示您如何解决此问题，而不是作为有关如何将依赖项注入与JavaFX集成的通用指南，这可能会是一个棘手的问题，因此无法全面介绍。
