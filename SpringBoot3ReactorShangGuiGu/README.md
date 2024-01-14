# 参考教程

尚硅谷SpringBoot3响应式编程教程，2024最新springboot入门到实战

https://www.bilibili.com/video/BV1sC4y1K7ET

# 章节笔记

## P8 为什么有 Reactive Stream 规范

Java 9 中的 Flow 类定义了响应式编程的 API。实际上就是拷贝了 Reactive Stream 的四个接口定义，然后放在
java.util.concurrent.Flow 类中。Java 9 提供了 SubmissionPublisher 和 ConsumerSubscriber 两个默认实现。

### Reactive Manifesto

https://www.reactivemanifesto.org/zh-CN

反应式系统的特质：

- **即时响应性**：只要有可能，系统就会即时地做出响应。
- **回弹性**：系统在出现失败时依然保持即时响应性。
- **弹性**：系统在不断变化的工作负载之下依然保持即时响应性。
- **消息驱动**：反应式系统依赖异步的消息传递，从而确保了松耦合、隔离、位置透明的组件之间有着明确边界。这一边界还提供了将失败做完消息委托出去的手段。

价值：即时响应性
形式：弹性、回弹性
手段：消息驱动

### Reactive Streams

Reactive Streams 是 JVM 面向流的库的标准和规范

1. 处理可能无限数量的元素
2. 有序
3. 在组件之间异步传递元素
4. 强制性非阻塞背压模式（迭代的问题：1.迭代速度取决于数据量 2.数据还得有容器缓存；正压：正向压力，数据的生产者给消费者压力）

思路：让少量的线程一直忙，而不是让大量的线程一直切换等待

只要占了一个 CPU 核心的线程一直不闲，不等任何数据返回。数据到达后自动放到缓存区，worker 闲了去缓存区拿数据继续处理

## P9 消息传递是响应式核心

基于异步、消息驱动的全事件回调系统：响应式系统

## P10 Reactive-Stream 规范核心接口

API Components:

1. Publisher：发布者，产生数据流
2. Subscriber：订阅者，消费数据流
3. Subscription：订阅关系（订阅关系是发布者和订阅者之间的关键接口。订阅者通过订阅来表示对发布者产生的数据的兴趣。订阅者可以请求一定数量的元素，也可以取消订阅。）
4. Processor：处理器（处理器是同时实现了发布者和订阅者接口的组件。它可以接收来自一个发布者的数据，进行处理，并将结果发布给下一个订阅者。处理器在
   Reactor 中充当中间环节，代表一个处理阶段，允许你在数据流中进行转换、过滤和其他操作。）

这种模型遵循 Reactive Streams 规范，确保了异步流的一致性和可靠性。

数据是自流动的，而不是靠迭代被动流动；

推拉模型：

推：流模式；上游有数据，自动推送给下游

拉：迭代器；自己遍历，自己拉取

Publisher(dataBuffer) -> 多个 Processor（Subscriber -> Publisher，既是订阅者又是发布者） -> Subscriber

## P11 Reactive-Stream 发布数据

## P12 Reactive-Stream 发布订阅写法

## P13 Reactive-Stream 四大核心组件

P11 ~ P13 见 Chapter01Stream 的 FlowDemo

响应式编程：

1. 底层：基于数据缓冲队列 + 消息驱动模型 + 异步回调机制
2. 编码：流式编程 + 链式调用 + 声明式 API
3. 效果：优雅全异步 + 消息实时处理 + 高吞吐量 + 占用少量资源

## P14 第二次课-小结

痛点：以前要做一个高并发系统：缓存、异步、队排好；手动控制整个逻辑
现在：全自动控制整个逻辑。只需要组装好数据处理流水线即可。

## P15 前情提要

Reactor 是基于 Reactive Streams 的第四代响应式库规范，用于在 JVM 上构建非阻塞应用程序；https://projectreactor.io

1. 一个完全非阻塞的，并提供高效的需求管理。它直接与 Java 的功能 API、CompletableFuture、Stream 和 Duration 交互。
2. Reactor 提供了两个响应式和可组合的 API，Flux[N] 和 Mono[0|1];
3. 适合微服务，提供基于 Netty 背压机制的网络引擎（HTTP、TCP、UDP）

高并发：“缓存、异步、队排好”
高可用：“分片、复制、选领导”

非阻塞的原理：缓冲 + 回调

1. 开线程不是解决问题的重点
2. 不要浪费时间去等待

## P16 响应式编程模型

1. 数据流：数据源头
2. 变化传播：数据操作（中间操作）
3. 异步编程模式：底层控制异步

这就是响应式编程

## P17 Mono 和 Flux 简单数据

## P18 事件感知 API-doOnXxx

## P19 响应式流日志

## P20 核心 - subscribe()

## P21 核心 - 自定义消费者

## P22 核心 - 自定义消费者 - 生命周期钩子

## P23 核心 - 请求重塑 - buffer

## P24 核心 - 请求重塑 - limitRate

## P25 核心 - 创建序列 - generate、create

## P26 核心 - 自定义元素处理 - handle

## P27 核心 - 自定义线程调度规则

P17 ~ P27 见 Chapter02Reactor 的 FluxDemo

## P28 核心 - 常见操作

见 Chapter02Reactor 的 ApiTest

## P29 核心 - 错误处理

见 Chapter02Reactor 的 ApiTest

命令式编程：常见的错误处理方式

1. 捕获异常返回一个静态默认值（对应 onErrorReturn 实现上面效果，错误的时候返回一个值）
   1. 吃掉异常，消费者无异常感知
   2. 返回一个默认值
   3. 流正常完成
2. 吃掉异常，执行一个兜底方法；（对应 onErrorResume）
   1. 吃掉异常，消费者无异常感知
   2. 调用一个兜底方法
   3. 流正常完成
3. 捕获并动态计算一个返回值（对应 onErrorResume）
4. 捕获并包装为一个业务异常，并重新抛出（对应 onErrorResume/onErrorMap）
   1. 吃掉异常，消费者有感知
   2. 抛新异常
   3. 流异常完成
5. 捕获异常，记录特殊的错误日志，重新抛出（对应 doOnError）
   1. 异常被捕获，做自己的事情
   2. 不影响异常继续顺着流水线传播
   3. 不吃掉异常，只在异常发生的时候做一件事，消费者有感知
6. finally （对应 doFinally）
7. 忽略当前异常，仅通知记录，继续推进

## P30 核心 - Sinks、重试、Context、阻塞 API

见 Chapter02Reactor 的 ApiTest

## P31 WebFlux - 响应式Web与阻塞式Web组件对应关系

WebFlux：底层完全基于 Netty + Reactor + SpringWeb 完成一个全异步非阻塞的 Web 响应式框架

底层：异步 + 消息队列（内存） + 事件回调机制 = 整套系统

优点：能使用少量资源处理大量请求

组件对比

| API 功能   | Servlet                        | WebFlux                  |
|----------|--------------------------------|--------------------------|
| 前端处理器    | DispatcherServlet              | DispatcherHandler        |
| 处理器      | Controller                     | WebHandler/Controller    |
| 请求、响应    | ServletRequest/ServletResponse | ServerWebExchange        |
| 过滤器      | Filter（HttpFilter）             | WebFilter                |
| 异常处理器    | HandlerExceptionResolver       | DispatchExceptionHandler |
| web配置    | @EnableWebMvc                  | @EnableWebFlux           |
| 自定义配置    | WebMvcConfigurer               | WebFluxConfigurer        |
| 返回结果     | 任意                             | Mono/Flux/任意             |
| 发送REST请求 | RestTemplate                   | WebClient                |

## P32 WebFlux - 引入 & 介绍

## P33 WebFlux - 使用 HttpHandler、HttpServer 原生 Reactor-Netty API 编写一个服务器

见 Chapter03 的 FluxMainApplication

## P34 WebFlux - Controller 注解 & SSE 功能

见 Chapter03 的 WebFluxMainApplication\HelloController\index.html

## P35 WebFlux - SSE 的完整 API

见 Chapter03 的 HelloController

# P36 WebFlux - DispatcherHandler 源码

- HandlerMapping：请求映射处理器；保存每个请求由哪个方法进行处理
- HandlerAdapter：处理器适配器；反射执行目标方法
- HandlerResultHandler：处理器结果处理器

SpringMVC: DispatchServlet 有一个 doDispatch() 方法，来处理所有请求；

WebFlux: DispatchHandler 有一个 handle() 方法，来处理所有请求

1. 请求和响应都封装在 ServerWebExchange 对象中，由 handle 方法进行处理
2. 如果没有任何的请求映射器了；直接返回一个；创建一个未找到的错误；404；返回 Mono.error；终结流
3. 跨域工具，是否跨域请求。跨域请求检查是否复杂跨域，需要预检请求。
4. Flux 流式操作
   1. 拿到所有的 handlerMappings
   2. 找每一个 mapping 看谁能处理请求
   3. 直接触发获取元素，拿到流的第一个元素；即找到第一个能处理这个请求的 handlerAdapter
   4. 如果没拿到元素，则响应 404 错误
   5. 异常处理，一旦前面发生异常，调用处理异常
   6. 调用方法处理请求，得到响应结果

源码中的核心两个：

- handleRequestWith: 编写了 handlerAdapter 怎么处理请求
- handleResult: String、User、ServerSendEvent、Mono、Flux...

## P37 WebFlux - Filter 等其他 API

注解开发

SSE 和 WebSocket 区别：

- SSE：单工；请求过去以后，等待服务端源源不断的数据
- WebSocket：双工：连接建立以后，可以任何交互；

### 目标方法传参

- ServerWebExchange 封装了请求和响应对象的对象；自定义获取数据、自定义响应
- ServerHttpRequest\ServerHttpResponse 请求、响应
- WebSession 访问Session对象
- org.springframework.http.HttpMethod 请求方式
- java.util.Locale 国际化
- java.util.TimeZone + java.time.ZoneId 时区
- @PathVariable 路径变量
- @MatrixVariable 矩阵变量
- @RequestParam 请求参数
- @RequestHeader 请求头
- @CookieValue 获取Cookie
- @RequestBody 获取请求体，Post、文件上传
- HttpEntity<B> 封装后的请求对象
- @RequestPart 获取文件上传的数据 multipart/form-data
- java.util.Map, org.springframework.ui.Model, org.springframework.ui.ModelMap
- Errors, BindingResult 数据校验，封装错误
- SessionStatus + 类级别 @SessionAttributes
- UriComponentsBuilder
- @SessionAttributes
- @RequestAttributes 转发请求的请求域数据
- 所有其他对象都能作为参数：基本类型等于标注 @RequestParam, 对象类型等于标注 @ModelAttribute

### 返回值的写法

- @ResponseBody 把响应数据写出去，如果是对象，可以自动转为 Json
- HttpEntity<B>, ResponseEntity<B> ResponseEntity支持快捷自定义响应内容
- HttpHeaders 没有响应内容，只有响应头
- ErrorResponse 快速构建错误响应
- ProblemDetail
- String 就是和之前的使用规则一样；forward:转发到一个地址；redirect:重定向到一个地址；配合模板引擎
- View 直接返回视图对象
- java.util.Map, org.springframework.ui.Model 以前一样
- @ModelAttribute 以前一样
- Rendering 新版的页面跳转 API；不能标注 @ResponseBody
- void 仅代表响应完成信号
- Flux<ServerSentEvent>, Observable<ServerSentEvent> 使用 text/event-stream 完成 SSE 效果
- 其他返回值，都会当成给页面的数据

## P38 R2DBC - 课程介绍

## P39 R2DBC - 体验简单查询

见 Chapter04R2DBC 的 R2DBCTest

## P40 Spring Data R2DBC - 整合与自动配置

见 Chapter04R2DBC 的 AuthorController

## P41 Spring Data R2DBC - DatabaseClient & R2dbcEntityTemplate API


