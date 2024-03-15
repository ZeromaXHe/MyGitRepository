# 简答

**循环依赖**就是循环引用，就是两个或多个 bean 相互之间的持有对方，比如 CircleA 引用 CircleB，CircleB 引用 CircleC，CircleC 引用 CircleA，则它们最终反映为一个环。需注意，与循环调用意义不同。

Spring 中，只有 setter 属性注入时，单例的循环依赖可以被解决。构造器注入、多例的属性注入的循环依赖均不可以被解决。

解决循环依赖主要使用了三级缓存的结构

```java
/** Cache of singleton objects: bean name --> bean instance */
/** 一级缓存，存放完整的bean */
private final Map<String, Object> singletonObjects = new ConcurrentHashMap<>(256);

/** Cache of early singleton objects: bean name --> bean instance */
/** 二级缓存，存放提前暴露的bean,bean是不完整的，没有完成属性注入和执行初始化 */
private final Map<String, Object> earlySingletonObjects = new HashMap<>(16);

/** Cache of singleton factories: bean name --> ObjectFactory */
/** 三级缓存，存放的是bean工厂，主要是生产bean，存放到二级缓存中 */
private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<>(16);
```

如上面的代码所示：

- **一级缓存**：用于存储被完整创建了的 Bean。也就是完成了初始化之后，可以直接被其他对象使用的 Bean。
- **二级缓存**：用于存储提前暴露的 Bean。也就是刚实例化但是还没有进行初始化的 Bean。这些 Bean 只能用于解决循环依赖的问题。因为还没有被初始化，对象里面的数据还不完整，无法被正常使用。所以，只能用于那些需要先持有这个 Bean 但不会使用这个 Bean 的对象，也就是正在创建过程中的对象了。
- **三级缓存**：三级缓存存储的是工厂对象。工厂对象可以产生对象提前暴露的引用。在 Spring 中，抽象工厂设计模式用到的地方有很多。只有我们真正调用工厂对象的 getObject() 方法时，才会真正去执行创建对象的逻辑。

具体解析请看下面详解。

# 详解

实例化 bean 是一个非常复杂的过程，而其中比较难以理解的就是对循环依赖的解决。

我们知道，在 Bean 发⽣循环依赖时，整个应⽤是不能正常⼯作的。循环依赖⼀旦形成，这些 Bean 则将⽆法实例化。下面从几个角度来看看 Spring Bean 的循环依赖，看看Spring是怎么解决循环依赖问题的，以及是怎么在应⽤中避免循环依赖问题的。

# 1 什么是循环依赖

**循环依赖**就是循环引用，就是两个或多个 bean 相互之间的持有对方，比如 CircleA 引用 CircleB，CircleB 引用 CircleC，CircleC 引用 CircleA，则它们最终反映为一个环。

此处不是循环调用，循环调用是方法之间的环调用。循环调用是无法解决的，除非有终结条件，否则就是死循环，最终导致内存溢出错误。

# 2 Spring 如何解决循环依赖

Spring 容器循环依赖包括构造器循环依赖和 setter 循环依赖，那 Spring 容器如何解决循环依赖呢？

首先让我们来定义循环引用类：

```java
public class TestA {
    private TestB testB;
    
    public void a() {
        testB.b();
    }
    public TestB getTestB() {
        return testB;
    }
    public void setTestB(TestB testB) {
        this.testB = testB;
    }
}

public class TestB {
    private TestC testC;
    
    public void b() {
        testC.c();
    }
    public TestC getTestC() {
        return testC;
    }
    public void setTestC(TestC testC) {
        this.testC = testC;
    }
}

public class TestC {
    private TestA testA;
    
    public void c() {
        testA.a();
    }
    public TestA getTestA() {
        return testA;
    }
    public void setTestA(TestA testA) {
        this.testA = testA;
    }
}
```

在 Spring 中将循环依赖的处理分成了 3 种情况。

## 2.1 构造器循环依赖

表示通过构造器注入构成的循环依赖，此依赖是无法解决的，只能抛出 BeanCurrentlyInCreationException 异常表示循环依赖。

如在创建 TestA 类时，构造器需要 TestB 类，那将去创建 TestB，在创建 TestB 类时又发现需要 TestC 类，则又去创建 TestC，最终在创建 TestC 时发现又需要 TestA，从而形成一个环，没办法创建。

Spring 容器将每一个正在创建的 bean 标识符放在一个“当前创建 bean 池”中，bean 标识符在创建过程中将一直保持在这个池中，因此如果在创建 bean 过程中发现自己已经在“当前创建 bean 池”里时，将抛出 BeanCurrentlyInCreationException 异常表示循环依赖；而对于创建完毕的 bean 将从“当前创建 bean 池”中清除掉。

我们通过一个直观的测试用例来进行分析。

1. 创建配置文件。

   ```xml
   <bean id="testA" class="com.bean.TestA">
   	<constructor-arg index="0" ref="testB"/>
   </bean>
   <bean id="testB" class="com.bean.TestB">
   	<constructor-arg index="0" ref="testC"/>
   </bean>
   <bean id="testC" class="com.bean.TestC">
   	<constructor-arg index="0" ref="testA"/>
   </bean>
   ```

2. 创建测试用例

   ```java
   @Test(expected = BeanCurrentlyInCreationException.class)
   public void testCircleByConstructor() throws Throwable {
       try {
           new ClassPathXmlApplicationContext("test.xml");
       } catch (Exception e) {
           // 因为要在创建 testC 时抛出；
           Throwable e1 = e.getCause().getCause().getCause();
           throw e1;
       }
   }
   ```

针对以上代码的分析如下：

- Spring 容器创建 “testA” bean，首先去“当前创建 bean 池”查找是否当前 bean 正在创建，如果没发现，则继续准备其需要的构造器参数 “testB”，并将“testA”标识符放到“当前创建 bean 池”。
- Spring 容器创建 “testB” bean，首先去“当前创建 bean 池”查找是否当前 bean 正在创建，如果没发现，则继续准备其需要的构造器参数 “testC”，并将“testB”标识符放到“当前创建 bean 池”。
- Spring 容器创建 “testC” bean，首先去“当前创建 bean 池”查找是否当前 bean 正在创建，如果没发现，则继续准备其需要的构造器参数 “testA”，并将“testC”标识符放到“当前创建 bean 池”。
- 到此为止 Spring 容器要去创建 “testA” bean，发现该 bean 标识符在“当前创建 bean 池”中，因为表示循环依赖，抛出 BeanCurrentlyInCreationException。

Spring 如果在配置中 bean 后面使用 `lazy-init="true"`，则加载启动时不报错，但是在调用 `getBean("testA")` 时报错，无法获取已配置的 Bean。出现该情况的原因是，Spring 在启动时会自动加载 lazy-init 属性为 false 的单例 Bean，所以 Bean 的 lazy-init 属性被设置为 true，就不会提前加载，而是在运行时加载；而配置中 bean 的配置没有指明 lazy-init 属性时，使用默认配置 false。

### 2.1.1 构造函数注入循环依赖代码详解

Spring 加载 Bean 时，不管是提前加载还是运行时加载，都调用 getBean 方法进行处理：

1. AbstractBeanFactory: getBean("testA")
2. AbstractBeanFactory → DefaultSingletonRegistry: getSingleton
3. DefaultSingletonRegistry → ObjectFactory: getObject
4. ObjectFactory --> AbstractBeanFactory: createBean
5. AbstractBeanFactory: doCreateBean
6. AbstractBeanFactory → AbstractAutowireCapableBeanFactory: createBeanInstance
7. AbstractAutowireCapableBeanFactory: determineConstructorsFromBeanPostProcessors
8. AbstractAutowireCapableBeanFactory → ConstructorResolver: autowireConstructor
9. ConstructorResolver: resolvePreparedArguments
10. ConstructorResolver → BeanDefinitionValueResolver: resolveValueIfNecessary
11. BeanDefinitionValueResolver --> AbstractBeanFactory: getBean("testB")

可以看出，在 `getBean("testA")` 创建 Bean 实例时，会先找到需要实例化的构造⽅法，并且解析构造⽅法的参数，由于依赖的是另⼀个 Bean，所以调用 `getBean("testB")` 方法获取 testB 实例对象（如果没有，则创建⼀个实例）。⽽在创建 testB 实例时要使⽤构造函数，此时构造函数⼜依赖 testC 实例。而 testC 根据同样逻辑，构造函数又依赖于 testA 实例，依赖⽆法解决，所以报错。

我们再来看看为什么会报错：

```java
public Object getSingleton(String beanName, ObjectFactory<?> singletonFactory) {
    Assert.notNull(beanName, "'beanName' must not be null");
    synchronized (this.singletonObjects) {
        Object singletonObject = this.singletonObjects.get(beanName);
        if (singletonObject == null) {
            if (this.singletonCurrentlyInDestruction) {
                throw new BeanCreationNotAllowedException(
                    beanName,
                    "Singleton bean creation not allowed while the singletons of this factory are in destruction " + "(Do not request a bean from a BeanFactory in a destroy method implementation!)");
            }
            // 在创建单例前校验
            beforeSingletonCreation(beanName);
            boolean newSingleton = false;
            boolean recordSuppressedExceptions = (this.suppressedExceptions == null);
            if (recordSuppressedExceptions) {
                this.suppressedExceptions = new LinkedHashSet<Exception>();
            }
            try {
                // 获取实例
                singletonObject = singletonFactory.getObject();
                newSingleton = true;
            } catch (IllegalStateException ex) {
                singletonObject = this.singletonObjects.get(beanName);
                if (singletonObject == null) {
                    throw ex;
                }
            } catch (BeanCreationException ex) {
                if (recordSuppressedExceptions) {
                    for (Exception suppressedException : this.suppressedExceptions) {
                        ex.addRelatedCause(suppressedException);
                    }
                }
                throw ex;
            } finally {
                if (recordSuppressedExceptions) {
                    this.suppressedExceptions = null;
                }
                // 在创建后处理
                afterSingletonCreation(beanName);
            }
            if (newSingleton) {
                // 添加单例
                addSingleton(beanName, singletonObject);
            }
        }
        return (singletonObject != NULL_OBJECT ? singletonObject : null);
    }
}

protected void beforeSingletonCreation(String beanName) {
    // 如果名称为 beanName 的 Bean 已经被创建，则抛出异常
    if (!this.inCreationCheckExclusions.contains(beanName)
        && !this.singletonsCurrentlyInCreation.add(beanName)) {
        throw new BeanCurrentlyInCreationException(beanName);
    }
}

// 在 Bean 创建完成后进行校验，并且删除正在创建 Bean 的标志
protected void afterSingletonCreation(String beanName) {
    if (!this.inCreationCheckExclusions.contains(beanName)
        && !this.singletonsCurrentlyInCreation.remove(beanName)) {
        throw new IllegalStateException("Singleton '" + beanName + "' isn't currently in creation");
    }
}

public class BeanCurrentlyInCreationException extends BeanCreationException {
    public BeanCurrentlyInCreationException(String beanName) {
        super(beanName,
              "Requested bean is currently in creation: Is there an unresolvable circular reference?");
    }
}
```

根据以上代码和时序，我们可以整理⼀下流程：testA 在 getBean 时，需要获取构造⽅法和装载构造⽅法的参数值来创建 testA 实例，注 意，此时还没有创建真正的实例，但是已经设置了正在创建的标志；同时，因为没有创建完成，所以没有清除正在创建的标志。在装载构造⽅法时调用 `getBean("testB")` 方法，在装载 testB 构造⽅法时发现需要获取 testC 实例（getBean），而在装载 testC 构造⽅法时发现需要获取 testA 实例。在调用 DefaultSingletonBeanRegistry 的 beforeSingletonCreation 方法时发现 testA 的 Bean 创建标志为已创建，抛出异常。

得出结论：Spring 不能处理 Bean 之间使用构造方法进行注入并形成循环依赖的情况。 

如果在 Bean 之间用构造方法进行注入并形成循环依赖，则当Bean实例化时，被依赖的 Bean 的实例必须已经存在，从而在实例化的同时完成依赖属性（也就是另⼀个Bean的实例）的注入，所以两个 Bean 都需要在自己实例化前就依赖对方的实例，这是无法做到的，因为在⼀般场景下使用构造方法创建实例是不可以绕过的。那是不是可以去掉 beforeSingletonCreation 校验呢？试想⼀下，如果去掉这个校验，则很有可能会导致有⼀个Bean循环创建实例，直到内存或者栈溢出。

## 2.2 setter 循环依赖

表示通过 setter 注入方式构成的循环依赖。对于 setter 注入造成的依赖是通过 Spring 容器提前暴露刚完成构造器注入但未完成其他步骤（如 setter 注入）的 bean 来完成的，而且只能解决单例作用域的 bean 循环依赖。通过提前暴露一个单例工厂方法，从而使其他 bean 能引用到该 bean ，如下代码所示：

```java
addSingletonFactory(beanName, new ObjectFactory() { 
	public Object getobject() throws BeansException { 
		return getEarlyBeanReference(beanName, mbd, bean);
    }
});
```

具体步骤如下：

1. Spring 容器创建单例 “testA” bean，首先根据无参构造器创建 bean，并暴露一个 “ObjectFactory” 用于返回一个提前暴露一个创建中的 bean，并将 “testA” 标识符放到“当前创建 bean 池”，然后进行 setter 注入 “testB”。
2. Spring 容器创建单例 “testB” bean，首先根据无参构造器创建 bean，并暴露一个 “ObjectFactory” 用于返回一个提前暴露一个创建中的 bean，并将 “testB” 标识符放到“当前创建 bean 池”，然后进行 setter 注入“circle”。
3. Spring 容器创建单例 “testC” bean，首先根据元参构造器创建 bean，并暴露一个 “ObjectFactory” 用于返回一个提前暴露一个创建中的 bean，并将 “testC” 标识符放到“当前创建 bean 池”，然后进行 setter 注入“testA”。进行注入 “testA” 时由于提前暴露了 “ObjectFactory” 工厂，从而使用它返回提前暴露一个创建中的 bean。
4. 最后在依赖注入 “testB” 和 “testA”，完成 setter 注入。

### 2.2.1 属性注入循环依赖代码详解

为什么Spring 能⾃动解决属性的循环依赖问题，却不能解决构造⽅法的循环依赖问题？ 由于xml配置和注解配置的运⾏模式⼀致，所以这⾥只考虑⼀种情况就可以了。

Spring getBean 的时序如下：

1. AbstractBeanFactory: getSingleton
2. AbstractBeanFactory → DefaultSingletonBeanRegistry: getSingleton(with allowEarlyReference)
3. AbstractBeanFactory → DefaultSingletonBeanRegistry: getSingleton(with singletonFactory)
4. DefaultSingletonBeanRegistry: beforeSingletonCreation
5. DefaultSingletonBeanRegistry → ObjectFactory: getObject
6. ObjectFactory → AbstractAutorwireCapableBeanFactory: createBean
7. AbstractAutorwireCapableBeanFactory: doCreateBean
8. AbstractAutorwireCapableBeanFactory: populateBean
9. AbstractAutorwireCapableBeanFactory --> AbstractBeanFactory: getBean
10. AbstractAutorwireCapableBeanFactory: initializeBean
11. AbstractAutorwireCapableBeanFactory --> DefaultSingletonBeanRegistry: return bean
12. DefaultSingletonBeanRegistry: afterSingletonCreation
13. DefaultSingletonBeanRegistry --> AbstractBeanFactory: return bean

> **注意**：在此时序中只以分析循环依赖为主线，不够详细。流程较全的时序请参考 Spring Bean 的运行（获取、创建）的实现

上面时序中，第 2 步为 `DefaultSingletonBeanRegistry.getSingleton(String beanName, boolean allowEarlyReference)` 方法；第 3 步为 `DefaultSingletonBeanRegistry.getSingleton(String beanName, ObjectFactory<?> singletonFactory)` 方法。

Spring 在 getBean("testA") 时创建 testA Bean 实例，之后注入属性并开始 getBean("testB")，然后依此类推重复操作 testC。此时为什么没发⽣死循环或者抛出异常呢？ 

其源码如下：

```java
protected <T> T doGetBean(final String name, final Class<T> requiredType,
                          final Object[] args, boolean typeCheckOnly) throws BeansException {
    final String beanName = transformedBeanName(name);
    Object bean;
    
    // 如果已经创建了，则从缓存中获取，默认的解决依赖为 true
    Object sharedInstance = getSingleton(beanName);
    // ……
}

protected Object getSingleton(String beanName, boolean allowEarlyReference) {
    Object singletonObject = this.singletonObjects.get(beanName);
    // 如果在单例池中没有这个 Bean，并且正在创建这个 Bean
    if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
        synchronized (this.singletonObjects) {
            // 如果提前创建的 Bean 为空，并且允许提前解决依赖问题
            singletonObject = this.earlySingletonObjects.get(beanName);
            if (singletonObjects == null && allowEarlyReference) {
                // 如果含有单例工厂，则从单例工厂中获取 Bean
                ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
                if (singletonFactory != null) {
                    singletonObject = singletonFactory.getObject();
                    this.earlySingletonObjects.put(beanName, singletonObject);
                    this.singletonFactories.remove(beanName);
                }
            }
        }
    }
    return (singletonObject != NULL_OBJECT ? singletonObject : null);
}

protected Object doCreateBean(final String beanName, final RootBeanDefinition mbd, final Object[] args) {
    BeanWrapper instanceWrapper = null;
    if (mbd.isSingleton()) {
        instanceWrapper = this.factoryBeanInstanceCache.remove(beanName);
    }
    if (instanceWrapper == null) {
        // 创建 Bean 的实例（构造方法的注入也肯定在此处进行）
        instanceWrapper = createBeanInstance(beanName, mbd, args);
    }
    final Object bean = (instanceWrapper != null ? instanceWrapper.getWrappedIntsance() : null);
    Class<?> beanType = (instanceWrapper != null ? instanceWrapper.getWrapperClass() : null);
    synchronized (mbd.postProcessingLock) {
        if (!mbd.postProcessed) {
            applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName);
            mbd.postProcessed = true;
        }
    }
    // 如果 Bean 为单例，则当前 BeanFactory 允许循环依赖的参数值为 true（默认为 true），
    // 并且当前对象正在创建的标志值为 true。如果在实例化对象时（构造函数装配时）发生异常，则是不会走到这一步的
    boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences
                                      && isSingletonCurrentlyInCreation(beanName));
    if (earlySingletonExposure) {
        // 添加单例工厂
        addSingletonFactory(beanName, new ObjectFactory<Object>() {
            @Override
            public Object getObject() throws BeansException {
                return getEarlyBeanReference(beanName, mbd, bean);
            }
        });
    }
    // 注入 Bean 的属性，并且初始化 Bean
    Object exposedObject = bean;
    try {
        populateBean(beanName, mbd, instanceWrapper);
        if (exposedObject != null) {
            exposedObject = initializeBean(beanName, exposedObject, mbd);
        }
    }
}

// 添加单例工厂
protected void addSingletonFactory(String beanName, ObjectFactory<?> singletonFactory) {
    synchronized (this.singletonObjects) {
        if (!this.singletonFactories.containsKey(beanName)){
            this.singletonFactories.put(beanName, singletonFactory);
            this.earlySingletonObjects.remove(beanName);
            this.registeredSingletons.add(beanName);
        }
    }
}
```

我们按照这个循环依赖的例子来整理其中的逻辑，把上面的代码串起来。

1. `getBean("testA")`。此时到 `DefaultSingletonBeanRegistry.getSingleton(String beanName, boolean allowEarlyReference)` 中获取 Bean 实例，因为在单例对象池和正在创建的单例对象中都没有获取到，所以没有找到有当前 Bean 名称的单例对象。
2. 到 `DefaultSingletonBeanRegistry.getSingleton(String beanName, ObjectFactory<?> singletonFactory)` 中获取 Bean 实例，同时把这个 Bean 的名称添加到正在创建的 Bean 的集合中，然后创建 Bean 实例。
3. 在 Bean 实例创建完成后创建一个 Bean 对象工厂，放置当前 Bean 到单例的工厂池中（如果没有特殊定制，则这个工厂返回的就是这个 Bean 刚才创建的实例）。
4. 在实例化 testA Bean 后，Spring 开始准备调用 getBean("testB") 获取 testB Bean 的实例，将这个实例注入名称为 testB 的属性中；依此类推，testB Bean 中的 testC 属性也类似逻辑注入。Spring 在获取（如不存在则会创建）testC Bean 的实例后，开始通过 getBean("testA") 注入其属性 testA；Spring 在 getBean("testA") 时发现在普通单例对象池和提前加载的单例对象池中都不存在 testA 实例，但当前允许“提前解决”属性引用的标志值为 true，同时 testA Bean 正在被创建，所以此时使用 testA 的单例工厂创建 testA 实例对象来完成 testC Bean 的属性装配。
5. 但是此时 testB 对象并没有持有 testC 属性的引用地址。在 getBean("testC") 执行完毕后，testB Bean 开始装配它的 testC 属性，在装配 testB Bean 和 testC Bean 时均完成了属性注入；以此类推，testA 的 getBean("testB") 执行完毕后装配 testB 属性，testA Bean 也完成了属性注入，从而完成了整个循环依赖的自动解决过程。



下面来说说构造函数为什么不能自动解决循环依赖问题。Spring 默认是允许循环依赖的，那么为什么不能自动解决构造函数注入的循环依赖问题呢？因为构造函数是在 Bean 实例化时完成构造方法注入的，如果对象没有实例化，则是不会将单例工厂对象添加到单例池中的，所以在调用 getBean 时从提前加载的 Bean 集合（Spring 启动时加载的 Bean 实例集合）中还是获取不到，还要调用 `DefaultSingletonBeanRegistry.getSingleton(String beanName, ObjectFactory<?> singletonFactory)` 方法获取单例，这触发了 beforeSingletonCreation 方法的校验（前面讲到过源码），所以发生了异常。

解决循环依赖问题的Bean的属性设置代码如下： 

```java
public abstract class AbstractAutowireCapableBeanFactory
    extends AbstractBeanFactory implements AutowireCapableBeanFactory {
    // 也就是 Spring 默认解决循环依赖问题
    private boolean allowCiruclationReferences = true;
    // ...
}
```

对于 “singleton” 作用域 bean，可以通过 “`setAllowCircularReferences(false);`” 来禁用循环引用。

Spring在解决这个问题时用了两个思路，一个是提前准备（单例 Bean 在 Spring启动时提前创建实例⽽不是在发⽣调⽤或者注⼊时创建）；一个是使用可扩展的参数 allowCircularReferences，实现更灵活地解决 Bean 循环依赖场景的目的。

至此，Spring单例的循环依赖问题就剖析完了，这些问题可以在进行代码设计或配置时规避，或者使⽤属性注入的方式来解决。这样就算出现了循环依赖问题，Spring默认的设置也能帮助解决。 

### 2.2.2 三级缓存

从上面代码中可以看到，单例属性注入解决循环依赖问题中最关键的结构就在于 Spring 使用的三级缓存：

```java
/** Cache of singleton objects: bean name --> bean instance */
/** 一级缓存，存放完整的bean */
private final Map<String, Object> singletonObjects = new ConcurrentHashMap<>(256);

/** Cache of early singleton objects: bean name --> bean instance */
/** 二级缓存，存放提前暴露的bean,bean是不完整的，没有完成属性注入和执行初始化 */
private final Map<String, Object> earlySingletonObjects = new HashMap<>(16);

/** Cache of singleton factories: bean name --> ObjectFactory */
/** 三级缓存，存放的是bean工厂，主要是生产bean，存放到二级缓存中 */
private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<>(16);
```

如上面的代码所示：

- **一级缓存**：用于存储被完整创建了的 Bean。也就是完成了初始化之后，可以直接被其他对象使用的 Bean。
- **二级缓存**：用于存储提前暴露的 Bean。也就是刚实例化但是还没有进行初始化的 Bean。这些 Bean 只能用于解决循环依赖的问题。因为还没有被初始化，对象里面的数据还不完整，无法被正常使用。所以，只能用于那些需要先持有这个 Bean 但不会使用这个 Bean 的对象，也就是正在创建过程中的对象了。
- **三级缓存**：三级缓存存储的是工厂对象。工厂对象可以产生对象提前暴露的引用。在 Spring 中，抽象工厂设计模式用到的地方有很多。只有我们真正调用工厂对象的 getObject() 方法时，才会真正去执行创建对象的逻辑。

> **二级缓存就可以直接存储对象提前暴露的引用了，为什么还要一个储存工厂方法的三级缓存？**
>
> 那是因为三级缓存不是针对不同的循环依赖，而是针对有动态代理的循环依赖，同样是在填充属性阶段，如果依赖的是动态代理的对象，那么，我们需要提前暴露的就不是原来刚实例化的对象，而是这个对象的动态代理对象。但是，创建动态代理的成本是很高的，因此，我们使用工厂方法，在真正要获取动态代理对象的时候才去创建对象，将这种开销比较大的任务尽量延迟做，能尽量保证我们的性能。

## 2.3 prototype 范围的依赖处理

对于 “prototype” 作用域 bean，Spring 容器无法完成依赖注入，因为 Spring 容器不进行缓存 “prototype” 作用域的 bean，因此无法提前暴露一个创建中的 bean。示例如下：

1. 创建配置文件。

   ```xml
   <bean id="testA" class="com.bean.TestA" scope="prototype">
   	<constructor-arg index="0" ref="testB"/>
   </bean>
   <bean id="testB" class="com.bean.TestB" scope="prototype">
   	<constructor-arg index="0" ref="testC"/>
   </bean>
   <bean id="testC" class="com.bean.TestC" scope="prototype">
   	<constructor-arg index="0" ref="testA"/>
   </bean>
   ```

2. 创建测试用例

   ```java
   @Test(expected = BeanCurrentlyInCreationException.class)
   public void testCircleBySetterAndPrototype() throws Throwable {
       try {
           ClassPathXmlApplicationContext ctx = new ClassPathXmlApplicationContext("testPrototype.xml");
           System.out.println(ctx.getBean("testA"));
       } catch (Exception e) {
           Throwable e1 = e.getCause().getCause().getCause();
           throw e1;
       }
   }
   ```

### 2.3.1 多例 Bean 的循环依赖代码详解

我们再来看看代码，由于逻辑调⽤层次都⽐较简单，所以就不写时序了

```java
protected <T> T doGetBean(final String name, final Class<T> requiredType,
                          final Object[] args, boolean typeCheckOnly) throws BeansException {
    final String beanName = transformedBeanName(name);
    Object bean;
    
    Object sharedInstance = getSingleton(beanName);
    if (sharedInstance != null && args == null) {
        bean = getObjectForBeanInstance(sharedInstance, name, beanName, null);
    } else {
        // 如果是多例 Bean，并且已经创建，则抛出异常
        if (isPrototypeCurrentlyInCreation(beanName)) {
            throw new BeanCurrentlyIncreationException(beanName);
        }
        
        BeanFactory parentBeanFactory = getParentBeanFactory();
        if (parentBeanFactory != null && !containsBeanDefition(beanName)) {
            String nameToLookup = originalBeanName(name);
            if (args != null) {
                return (T) parentBeanFactory.getBean(nameToLookup, args);
            } else {
                return parentBeanFactory.getBean(nameToLookup, requiredType);
            }
        }
        
        if (!typeCheckOnly) {
            markBeanAsCreated(beanName);
        }
        
        try {
            final RootBeanDefinition mbd = getMergedLocalBeanDefinition(beanName);
            checkMergedBeanDefinition(mbd, beanName, args);
            
            String[] dependsOn = mbd.getDependsOn();
            if (dependsOn != null) {
                for (String dependsOnBean : dependsOn) {
                    if (isDependent(beanName, dependsOnBean)) {
                        throw new BeanCreationException(
                            mbd.getResourceDescription(), beanName,
                            "Circular depends-on relationship between '" + beanName
                            + "' and '" + dependsOnBean + "'");
                    }
                    registerDependentBean(dependsOnBean, beanName);
                    getBean(dependsOnBean);
                }
            }
            
            if (mbd.isSingleton()) {
                sharedInstance = getSingleton(beanName, new ObjectFactory<Object>() {
                    @Override
                    public Object getObject() throws BeansException {
                        try {
                            return createBean(beanName, mbd, args);
                        } catch (BeansException ex) {
                            destroySingleton(beanName);
                            throw ex;
                        }
                    }
                });
                bean = getObjectForBeanInstance(sharedInstance, name, beanName, mbd);
            } else if (mbd.isProtoType()) {
                // 创建多例
                Object prototypeInstance = null;
                try {
                    beforeProtypeCreation(beanName);
                    prototypeInstance = createBean(beanName, mbd, args);
                } finally {
                    afterPrototypeCreation(beanName);
                }
                bean = getObjectForBeanInstance(prototypInstance, name, beanName, mbd);
            }
            // ...
        }
    }
}

protected void beforePrototypeCreation(String beanName) {
    Object curVal = this.prototypesCurrentlyInCreation.get();
    // 在 thread local 中为空，则在 threadlocal 中设置这个 Bean 的名称
    if (curVal == null) {
        this.prototypesCurrentlyInCreation.set(beanName);
    }
    // 处理多个场景
    else if (curVal instanceof String) {
        Set<String> beanNameSet = new HashSet<String>(2);
        beanNameSet.add((String) curVal);
        beanNameSet.add(beanName);
        this.prototypesCurrentlyInCreation.set(beanNameSet);
    } else {
        Set<String> beanNameSet = (Set<String>) curVal;
        beanNameSet.add(beanName);
    }
}

protected boolean isPrototypeCurrentlyInCreation(String beanName) {
    // 判断在 threadlocal 中是否存在这个 Bean
    Object curVal = this.prototypesCurrentlyInCreation.get();
    return (curVal != null && (curVal.equals(beanName) || (curVal instanceof Set && ((Set<?>) curVal).contains(beanName))));
}
```

从源码可以看出，Spring 使用 threadLocal 控制多例 Bean 的循环依赖问题。

1. testA 在获取 Bean 时，发现在单例池和父容器中都没有这个 Bean，所以对 Bean 名称的设置在 threadlocal 中进行，如果 threadlocal 不为空，则把它们都放在 set 中在放回 threadlocal，然后注入属性，开始获取 testB Bean 实例
2. testB 重复第 1 步操作，然后同样 testC 也重复第 1 步操作，在注入它的属性时调用 `getBean("testA")`，通过 Bean 的配置得知 testA 是多例 Bean 并且这个 beanName 已经存在于当前线程的上下文中（`getBean("testA")`、`getBean("testB")` 和 `getBean("testC")` 在同一个线程中执行），所以报错。

由此可知，多例构造函数注入同样会发生循环依赖问题。

所以 Spring 是无法解决多例场景下的循环依赖问题的，在处理多例场景时，不是在线程内重复创建，而是把创建好的实例放置在线程上下文中。在线程内复用 Bean，才有可能解决多例场景下的循环依赖问题。不过这种处理方式同时会带来新的问题：发生在线程内的不是多例（在同一线程内多次调用），而是单例。

# 参考文档

- 《Spring 源码深度解析（第 2 版）》5.6 循环依赖
- 《互联网轻量级 SSM 框架解密：Spring、Spring MVC、MyBatis 源码深度剖析》6.2 Spring Bean 循环依赖的问题
- Spring 三级缓存解决循环依赖问题详解：https://blog.csdn.net/x18423118112/article/details/122600382