# 拦截器和过滤器的区别

# 简答

拦截器（Interceptor）是 Spring MVC 中的概念，而过滤器（Filter）是 Servlet 的概念。

拦截器与过滤器有相似之处，比如两者都是 AOP 编程思想的体现，都能实现权限检查、日志记录等。不同的是：

- **使用范围不同**：过滤器是 Servlet 规范规定的，只能用于 Web 程序中。而拦截器既可以用于 Web 程序，也可以用于 Application、Swing 程序中。
- **规范不同**：过滤器是在 Servlet 规范中定义的，是 Servlet 容器支持的。而拦截器是 Spring 容器内的，是 Spring 框架支持的。
- **使用的资源不同**：同其他的代码块一样，拦截器也是一个 Spring 的组件，归 Spring 管理，配置在 Spring 文件中，因此能使用 Spring 里的任何资源、对象，例如 Service 对象、数据源、事务管理等，通过 IoC 注入到拦截器即可；而过滤器则不能。
- **深度不同**：过滤器只在 Servlet 前后起作用。而拦截器能够深入到方法前后、异常抛出前后等，因此拦截器的使用具有更大的弹性。所以在 Spring 架构的程序中，要优先使用拦截器。
- **实现机制不同**：拦截器是基于 Java 的反射机制的，而过滤器是基于函数回调。
- **触发时机不同**：过滤器是在请求进入容器后，但请求进入 Servlet 之前进行预处理的。请求结束返回也是，是在 Servlet 处理完后，返回给前端之前。过滤器包裹住 Servlet，Servlet 包裹住拦截器。
- 在 action 的生命周期中，拦截器可以多次被调用，而过滤器只能在容器初始化时被调用一次。
- 过滤器可以修改 request，而拦截器不能

# 详解

## 1 拦截器

SpringMVC 中的Interceptor 拦截请求是通过HandlerInterceptor 来实现的。在SpringMVC 中定义一个Interceptor 非常简单，主要有两种方式

- 第一种方式是要定义的 Interceptor 类要实现了 Spring 的 HandlerInterceptor 接口，或者是这个类继承实现了 HandlerInterceptor 接口的类，比如 Spring 已经提供的实现了HandlerInterceptor 接口的抽象类 HandlerInterceptorAdapter ；
- 第二种方式是实现 Spring 的 WebRequestInterceptor 接口，或者是继承实现了 WebRequestInterceptor 的类。

### 1.1 装配拦截器

在收到请求时，Spring MVC 的 DispatcherServlet 将请求交给**处理器映射**（HandlerMapping），让它找出对应该请求的 HandlerExecutionChain 对象。

**HandlerExecutionChain** 顾名思义是一个执行链，它包含一个处理该请求的处理器（Handler），同时包括若干个对该请求实施拦截的拦截器（HandlerInterceptor）。当 HandlerMapping 返回 HandlerExecutionChain 之后，DispatcherServlet 将请求交给定义在 HandlerExecutionChain 中的拦截器和处理器一并处理。

HandlerExecutionChain 是负责处理请求并返回 ModelAndView 的处理执行链。请求在被 Hanlder 执行的前后，链中装配的 HandlerInterceptor 会实现拦截操作。

拦截器到底做了什么事情？我们通过考查拦截器的几个接口方法进行了解。

- `boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)`：在请求到达 Handler 之前，先执行这个前置处理方法。当该方法返回 false 时，请求直接返回，不会传递到链中的下一个拦截器，更不会传递到处理器链末端的 Handler 中。只有返回 true 时，请求才向链中的下一个处理节点传递。
- `void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView)`：在请求被 HandlerAdapter 执行后，执行这个后置处理方法。
- `void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)`：在响应已经被渲染后，执行该方法。

位于处理器链末端的是一个 Handler，DispatcherServlet 通过 HandlerAdapter 适配器对 Handler 进行封装，并按统一的适配器接口对 Handler 处理方法进行调用。

~~~xml
<mvc:interceptors>
    <mvc:interceptor>
        <mapping path="/secure/*"/>
        <bean class="com.smart.web.MyInterceptor"/>
    </mvc:interceptor>
</mvc:interceptors>
~~~

可以在配置文件中配置多个拦截器，每个拦截器都可以指定一个匹配的映射路径，以限制拦截器的作用范围。

## 2 过滤器

**Filter**（过滤器）是 Servlet 规范 2.3 中新增的技术，其基本功能就是对 Servlet 容器调用 Servlet 的过程进行拦截，从而在 Servlet 进行响应处理的前后实现一些特殊功能，例如，记录所有客户端的每次访问信息、统计静态 HTML 页面的访问次数、验证访问者的身份、修改 Servlet 容器传递给 Servlet 的请求信息、修改 Servlet 回送给 Servlet 容器的响应结果，等等。

Filter 是在 web.xml 中常用配置项，可以通过 `<filter>` 和 `<filter-mapping>` 组合来使用 Filter。实际上 Filter 可以完成与 Servlet 同样的工作，甚至比 Servlet 使用起来更加灵活，因为它除了提供了 request 和 response 对象外，还提供了一个 FilterChain 对象，这个对象可以让我们更加灵活地控制请求的流转。

在 Servlet API 中定义了三个接口类来供开发人员编写 Filter 程序，它们分别是：`javax.servlet.Filter`、`javax.servlet.FilterChain`、`javax.servlet.FilterConfig`。

在 Tomcat 容器中，FilterConfig 和 FilterChain 的实现类分别是 ApplicationFilterConfig 和 ApplicationFilterChain（这个链与 Jetty 中的 Handler 链有异曲同工之妙），而 Filter 的实现类由用户自定义，只要实现 Filter 接口中定义的三个接口方法就行：

- init(FilterConfig)
- doFilter(ServletRequest, ServletResponse, FilterChain)
- destroy

### 2.1 Filter 的基本工作原理

Filter 程序是一个实现了特殊接口（`javax.servlet.Filter`）的 Java 类，与 Servlet 程序相似，它也是由 Servlet 容器进行调用和执行的。Filter 程序需要在 web.xml 文件中进行注册和设置它所能拦截的资源。

当在 web.xml 文件中注册了一个 Filter 来对某个 Servlet 程序进行拦截处理时，这个 Filter 就成了 Servlet 容器与该 Servlet 程序的通信线路上的一道关卡，它可以对 Servlet 容器发送给 Servlet 程序的请求和 Servlet 程序回送给 Servlet 容器的响应进行拦截，可以决定是否将请求继续传递给 Servlet 程序，以及对请求和响应信息是否进行修改。

当 Servlet 容器开始调用某个 Servlet 程序时，如果发现已经注册了一个 Filter 程序来对该 Servlet 进行拦截，那么，Servlet 容器将不再直接调用 Servlet 的 `service` 方法，而是调用 Filter 的 `doFilter` 方法，再由 `doFilter` 方法决定是否去激活 Servlet 的 `service` 方法。

在 `Filter.doFilter` 方法中不能直接调用目标 Servlet 的 `service` 方法，而是调用 `FilterChain.doFilter` 方法来激活目标 Servlet 的 `service` 方法，FilterChain 对象是通过 `Filter.doFilter` 方法的参数传递进来的。

### 2.2 Filter 链

在一个 Web 应用程序中可以注册多个 Filter 程序，每个 Filter 程序都可以对一个或一组 Servlet 程序进行拦截。如果有多个 Filter 程序都可以对某个 Servlet 程序的访问过程进行拦截，当针对该 Servlet 的访问请求到达时，Web 容器将把这多个 Filter 程序组合成一个 **Filter 链**（也叫过滤器链）。

Filter 链中的各个 Filter 的拦截顺序与它们在应用程序的 web.xml 文件中的映射顺序一致，上一个 Filter 的 `doFilter` 方法中调用的 `FilterChain.doFilter` 方法将激活下一个 Filter 的 `doFilter` 方法，最后一个 Filter 的 `doFilter` 方法中调用的 `FilterChain.doFilter` 方法将激活目标 Servlet 的 `service` 方法。

只要 Filter 链中有任意一个 Filter 没有调用 `FilterChain.doFilter` 方法，那么，目标 Servlet 的 service 方法都将不会执行。

### 2.3 Filter 接口

一个 Filter 程序就是一个 Java 类，它必须实现 `javax.servlet.Filter` 接口，`javax.servlet.Filter` 接口中定义了三个方法：`init`、`doFilter` 和 `destroy`。

#### 2.3.1 init 方法

在 Web 应用程序启动时，Web 服务器（Web 容器）将根据其 web.xml 文件的配置信息来创建每个注册的 Filter 的实例对象，并将其保存在内存中。

Web 容器创建 Filter 的实例对象后，将立即调用该 Filter 对象的 `init` 方法。`init` 方法在 Filter 的生命期中仅执行一次，Web 容器在调用 `init` 方法时，会传递一个包含 Filter 的配置和运行环境信息的 FilterConfig 对象。`init` 方法的完整语法定义如下：

~~~java
public void init(FilterConfig filterConfig) throws ServletException
~~~

Filter 开发人员可以在 `init` 方法中完成与构造方法类似的初始化功能，如果初始化代码中要使用到 FilterConfig 对象，那么，这些初始化代码就只能在 Filter 的 `init` 方法中编写，而不能在构造方法中编写。Filter 的 `init` 方法和 Servlet 的 `init` 的作用非常相似，只要之前掌握了 Servlet 的 `init` 方法和 ServletConfig 对象的应用，就很容易推测出 Filter 的 `init` 方法和 FilterConfig 对象的应用。

如果 `init` 方法抛出了 ServletException 或者 `init` 方法中初始化过程超过了 Web 容器规定的时间，Web 容器将销毁 Filter 对象。

#### 2.3.2 doFilter 方法

当一个 Filter 对象能够拦截的访问请求到达后，Servlet 容器将调用该 Filter 对象的 `doFilter` 方法，`doFilter` 方法的完整语法定义如下：

~~~java
public void doFilter(ServletRequest request,
                     ServletResponse response,
                     FilterChain chain)
    throws java.io.IOException, ServletException
~~~

其中，参数 request 和 response 为 Web 容器或 Filter 链上的上一个 Filter 传递过来的请求和响应对象；参数 chain 为代表当前 Filter 链的对象。

只有 Filter 对象的 `init` 方法执行成功后，Filter 对象才会被加入到 Filter 链中，该 Filter 对象的 `doFilter` 方法才会被调用。

#### 2.3.3 destroy 方法

`destroy` 方法在 Web 容器卸载 Filter 对象之前被调用，显然，该方法在 Filter 对象的生命期中也仅执行一次。开发人员可以在 destroy 方法中完成与 init 方法相反的功能，释放被该 Filter 对象打开的资源。

### 2.4 FilterChain 接口

`javax.servlet.FilterChain` 接口用于定义一个代表 Filter 链的对象应该对外提供的方法，这个接口中只定义了一个 doFilter 方法，该方法的完整语法定义如下：

~~~java
public void doFilter(ServletRequest request, ServletResponse response)
    throws java.io.IOException, ServletException
~~~

FilterChain 接口的 doFilter 方法用于通知 Web 容器把请求交给 Filter 链中的下一个 Filter 去处理，如果当前调用此方法的 Filter 对象是 Filter 链中的最后一个 Filter，那么将把请求交给目标 Servlet 程序去处理。可见，Filter 链的起点是第一个 Filter 程序，Filter 链的末端实际上就是目标 Servlet 程序。

### 2.5 FilterConfig 接口

Filter 程序需要在 web.xml 文件中进行注册，在注册 Filter 程序时还可以设置其初始化参数，如下所示：

~~~xml
<filter>
    <filter-name>FirstFilter</filter-name>
    <filter-class>org.it315.filters.FirstFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>GB2312</param-value>
    </init-param>
</filter>
~~~

Servlet 规范将代表 ServletContext 对象和 Filter 的配置参数信息都封装到一个称为 FilterConfig 的对象中，FilterConfig 接口则用于定义 FilterConfig 对象应该对外提供的方法，以便在 Filter 程序中可以调用这些方法来获取 ServletContext 对象，以及获取在 web.xml 文件中为 Filter 设置的友好名称和初始化参数。

Web 容器装载并创建一个 Filter 的实例对象后，接着调用该实例对象的 `init(FilterConfig config)` 方法，将 FilterConfig 对象通过这个方法传递给该 Filter 对象。在 Filter 实现类的 init 方法中可以将作为参数传递进来的 FilterConfig 对象赋值给一个成员变量，以后在 Filter 实现类的 `doFilter` 和 `destroy` 方法中就可以通过这个成员变量来调用 FilterConfig 对象的各个方法。只要以前掌握了 Servlet 的 init 方法和 ServletConfig 对象的应用，就很容易推测出 Filter 的 init 方法和 FilterConfig 对象的应用。

## 3 Servlet

Sun 公司定义了一套专门用于开发 Servlet 程序的 Java 类和接口，这些类和接口提供 Servlet 程序开发中所涉及的各种功能，它们统称为 Servlet API（Servlet Application Programming Interface）。Servlet 引擎与 Servlet 程序之间采用 Servlet API 进行通信，因此，Servlet 引擎与 Servlet 程序都需要用到 Servlet API。

事实上，一个 Servlet 程序就是一个在 Web 服务器端运行的调用了 Servlet API 的 Java 类，这个特殊的 Java 类必须实现 `javax.servlet.Servlet` 接口，Servlet 接口定义了 Servlet 引擎与 Servlet 程序之间通信的协议约定。

为了简化 Servlet 程序的编写，Servlet API 中也提供了一个实现 Servlet 接口的最简单的 `javax.servlet.GenericServlet` 类，这个类实现了 Servlet 程序的基本特征和功能。

Servlet API 中还提供了一个专用于 HTTP 协议的 Servlet 类，其名称是 `javax.servlet.HttpServlet`，它是 GenericServlet 的子类，在 GenericServlet 类的基础上进行了一些针对 HTTP 特点的扩充。

GenericServlet 和 HttpServlet 类中的回调方法是供容器调用的方法，可以在子类中进行覆盖，而不能在程序代码中直接调用。

### 3.1 init 方法

`init` 方法在 Servlet 的生命期中仅执行一次，Servlet 引擎创建 Servlet 实例对象后立即调用该方法，Servlet 开发人员可以在这个方法中完成与构造方法类似的初始化功能。

Servlet 引擎在调用 `init` 方法时，会传递一个包含 Servlet 的配置和运行环境信息的 ServletConfig 对象，Servlet 接口中定义的 `init` 方法的语法格式为：

~~~java
public void init(ServletConfig config) throws ServletException
~~~

可见，如果初始化代码中要使用到 ServletConfig 对象，那么，这些初始化代码就只能在 Servlet 的 `init` 方法中编写，而不能在构造方法中编写。如果 `init` 方法抛出了异常，Servlet 引擎将卸载 Servlet。

在 GenericServlet 中还定义了一个无参数的 `init` 方法，如下所示：

~~~java
public void init() throws ServletException
~~~

GenericServlet 中的这个无参数的 `init()` 方法的方法体中没有编写任何程序的语句，是一个空函数。GenericServlet 实现的 `init(ServletConfig config)` 方法中调用了这个无参数的 `init()` 方法，所以，对于继承 GenericServlet 类的 Servlet 程序，也可以覆盖这个无参数的 `init()` 方法来编写初始化代码。并且覆盖这个无参数的 `init()` 方法还有一个好处，那就是省去了覆盖 `init(ServletConfig config)` 方法时总是要编写 `super.init(config)` 语句的麻烦。

### 3.2 service 方法

`service` 方法是 Servlet 的核心方法，每当针对某个 Servlet 的访问请求到达时，Servlet 引擎就会调用该 Servlet 实例对象的 `service` 方法来进行响应。Servlet 接口中定义的 `service` 方法的语法格式为：

~~~java
public void service(ServletRequest req, ServletResponse res)
    throws ServletException, java.io.IOException
~~~

GenericServlet 类没有对这个方法进行实现，HttpServlet 类实现了这个方法。由于 Servlet 接口中定义的 `service` 方法接受的参数类型分别为 ServletRequest 和 ServletResponse，对于采用 HTTP 协议的访问请求，如果要在这个 `service` 方法内部使用 HTTP 消息的特有功能，也就是要调用 HttpServletRequest 和 HttpServletResponse。

为了简化这一转换过程，HttpServlet 类实现的 `service` 方法内部调用了另外一个重载形式的 `service` 方法，重载的 `service` 方法的定义语法为：

~~~java
protected void service(HttpServletRequest req, HttpServletResponse res)
    throws ServletException, java.io.IOException
~~~

在 HttpServlet 所实现的 Servlet 接口中定义的 `service` 方法内部，将请求和响应对象的类型转换成 HttpServletRequest 和 HttpServletResponse 类型后，再将它们作为参数传递给这个重载的 service 方法。

### 3.3 destroy 方法

`destroy` 方法在 Web 容器卸载 Servlet 之前被调用，显然，该方法在 Servlet 的生命期中也仅执行一次。可以通过覆盖 `destroy` 方法来完成与 `init` 方法相反的功能，释放被该 Servlet 打开的资源，例如，关闭数据库连接和 IO 流。

### 3.4 doXxx方法

HttpServlet 类为每一种 HTTP 请求方式都定义了一个对应的 doXxx 方法，例如，与 GET 请求方式对应的是 doGet 方法。HttpServlet 中重载的 service 方法根据客户端的请求方式，分别调用与之对应的 doXxx 方法来完成具体的处理和响应细节，并将它接收的两个参数传递给该 doXxx 方法。

HttpServlet 中的 doXxx 方法分别用于对客户端的响应请求方式进行处理，一个 doXxx 方法是专用于处理某种请求方式的分岔入口，如果 Servlet 只想对某种或某几种请求方式进行处理，只需要覆盖这些方式各自对应的 doXxx 方法，而不用覆盖 HttpService 的 service 方法。

# 参考文档

- 拦截器和过滤器的区别：https://www.cnblogs.com/panxuejun/p/7715917.html
- 详解SpringMVC中使用Interceptor拦截器：https://www.jianshu.com/p/de2be0338495
- 《精通 Spring 4.x 企业应用开发实战》17.8.2 装配拦截器
- 《深入体验 Java Web 开发内幕——高级特性》第 2 章 Filter（过滤器）
- 《深入分析 Java Web 技术内幕》（修订版） 第 9 章 Servlet 工作原理解析
- 《深入体验 Java Web 开发内幕——核心基础》第 4 章 Servlet 开发基础