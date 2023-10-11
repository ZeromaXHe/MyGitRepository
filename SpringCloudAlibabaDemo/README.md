# Spring Cloud Alibaba 官方网站

[GitHub Release](https://github.com/alibaba/spring-cloud-alibaba/releases)

[2021.0.5.0 官方中文文档](https://spring-cloud-alibaba-group.github.io/github-pages/2021/zh-cn/2021.0.5.0/index.html)

[Nacos 快速开始文档](https://nacos.io/zh-cn/docs/quick-start.html)

[Sentinel 控制台 GitHub Wiki](https://github.com/alibaba/Sentinel/wiki/%E6%8E%A7%E5%88%B6%E5%8F%B0)

# 流程记录

## Nacos

Nacos 安装版本 2.2.3

控制台页面：http://127.0.0.1:8848/nacos/index.html

### 启动服务器

#### Linux/Unix/Mac

启动命令(standalone代表着单机模式运行，非集群模式):

`sh startup.sh -m standalone`

如果您使用的是ubuntu系统，或者运行脚本报错提示[[符号找不到，可尝试如下运行：

`bash startup.sh -m standalone`

#### Windows

启动命令(standalone代表着单机模式运行，非集群模式):

`startup.cmd -m standalone`

## Sentinel

Sentinel 版本 1.8.6

# 过程中碰到的问题

## Nacos Discovery 服务发现测试相关

官方文档里面的 `@Autowired private LoadBalancerClient loadBalancerClient;` 根本就注入不进去，参考下面的文章引入 `spring-cloud-loadbalancer` 依赖才解决。

[关于SpringCloud H版 使用SpringCloudAlibaba nacos注册中心时出现spring-cloud-loadbalancer的错误](https://blog.csdn.net/lovemzy_27/article/details/114086241)

IDEA properties 默认 ISO-8859-1 编码，中文麻烦

[IDEA设置Properties配置文件的编码](https://blog.csdn.net/weixin_64353239/article/details/131795141)

“3.5 如何开启权重路由”里面第一行的 ribbon 相关的配置貌似都没了，文档不知道是不是又没更新…… 吐了，官方文档写的和坨大便一样……

## Nacos Config 配置管理测试相关

properties 配置 Map 和 List：

[SpringBoot properties配置Map、List](https://blog.csdn.net/u010735988/article/details/129991364)

配置文件里面 spring.config.import 也并不需要像文档里那样加扩展名，直接用 data ID 就可以匹配，加了反而匹配不了。（后来发现文档的意思是它的 id 里面就写了扩展名……）

文档里配置动态刷新的 `spring.cloud.nacos.config.refresh-enabled` 又把中划线写成了点……

> **Spring boot 中配置文件的加载顺序**：
> 
> 1. `config/application.properties` （项目根目录中 config 目录下）
> 2. `config/application.yml`
> 3. `application.properties` （项目根目录下）
> 4. `application.yml`
> 5. `resources/config/application.properties` （项目 resources 目录中的 config 目录下）
> 6. `resources/config/application.yml`
> 7. `resources/application.properties` （项目 resources 目录下）
> 8. `resources/application.yml`
> 
> 若 application.yml 和 bootstrap.yml 在同一目录下，则 bootstrap.yml 的加载顺序要高于 application.yml

使用支持 profile 粒度的配置时，必须引入依赖 `spring-cloud-starter-bootstrap`（文档在前面说了，但前言不搭后语的，鬼知道这相关性）：

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bootstrap</artifactId>
</dependency>
```

## Sentinel 测试相关

使用命令启动 Sentinel 控制台：

```shell
java -Dserver.port=8080 -Dcsp.sentinel.dashboard.server=localhost:8080 -Dproject.name=sentinel-dashboard -jar sentinel-dashboard.jar
```

如果使用 PowerShell 执行，会报错误：`错误: 找不到或无法加载主类 .port=8080`

需要改为：

```shell
java '-Dserver.port=8080' '-Dcsp.sentinel.dashboard.server=localhost:8080' '-Dproject.name=sentinel-dashboard' -jar sentinel-dashboard.jar
```

参见[spring cloud alibaba 笔记 (四)服务熔断 集成sentinel](https://blog.csdn.net/z357904947/article/details/110230892)

控制台的默认账号密码都是 sentinel。（Spring Cloud Alibaba 文档里没有，得去 Sentinel 控制台文档查）

用户可以通过如下参数进行配置：

- `-Dsentinel.dashboard.auth.username=sentinel` 用于指定控制台的登录用户名为 sentinel； 
- `-Dsentinel.dashboard.auth.password=123456` 用于指定控制台的登录密码为 123456；如果省略这两个参数，默认用户和密码均为 sentinel； 
- `-Dserver.servlet.session.timeout=7200` 用于指定 Spring Boot 服务端 session 的过期时间，如 7200 表示 7200 秒；60m 表示 60 分钟，默认为 30 分钟；

