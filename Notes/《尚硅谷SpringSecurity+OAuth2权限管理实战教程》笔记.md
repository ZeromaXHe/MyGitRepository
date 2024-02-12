尚硅谷Java项目SpringSecurity+OAuth2权限管理实战教程 2024-01-30 14:55:00

https://www.bilibili.com/video/BV14b4y1A7Wz/

# P1 教程简介

# P2 入门-Spring Security 基本功能

功能：

- 身份认证（authentication）
- 授权（authorization）
- 防御常见攻击（protection against common attacks）

身份认证：

- 身份认证是验证谁正在访问系统资源，判断用户是否为合法用户。认证用户的常见方式是要求用户输入用户名和密码

授权：

- 用户进行身份认证后，系统会控制谁能访问哪些资源，这个过程叫做授权。用户无法访问没有权限的资源。

防御常见攻击：

- CSRF
- HTTP Headers
- HTTP Requests

# P3 入门-实现最简单的身份认证

## 1.1 创建 Spring Boot 项目

JDK 17

Spring Boot 3.2.0（依赖了 Spring Security 6.2.0）

Dependencies：Spring Web、Spring Security、Thymeleaf

## 1.2 创建 IndexController

```java
@Controller
public class IndexController {
    @GetMapping("/")
    public String index() {
        return "index";
    }
}
```

## 1.3 创建 index.html

## 1.4 启动项目测试 Controller

# P4 入门-使用动态链接

## 1.5 注意事项

### 1.5.1 @{/logout} 的作用

# P5 入门-登录页面加载慢的问题

### 1.5.2 页面样式无法加载的问题

# P6 入门-Spring Security 默认做了什么

## 1.6 Spring Security 默认做了什么

- 保护应用程序 URL，要求对应用程序的任何交互进行身份验证
- 程序启动时生成一个默认用户“user”。
- 生成一个默认的随机密码，并将此密码记录在控制台上。
- 生成默认的登录表单和注销页面。
- 提供基于表单的登录和注销流程。
- 对于 Web 请求，重定向到登录页面；
- 对于服务请求，返回 401 未经授权。
- 处理跨站请求伪造（CSRF）攻击。
- 处理会话劫持攻击。
- 写入 Strict-Transport-Security 以确保 HTTPS。
- 写入 X-Content-Type-Options 以处理嗅探攻击。
- 写入 Cache Control 头来保护经过身份验证的资源。
- 写入 X-Frame-Options 以处理点击劫持攻击。

# P7 入门-Spring Security 底层原理

## 2、Spring Security 的底层原理

Spring Security 之所以默认帮助我们做了那么多事情，它的底层原理是传统的 Servlet 过滤器

### 2.1 Filter

FilterChain

DelegatingFilterProxy

FilterChainProxy

SecurityFilterChain

# P8 入门-DefaultSecurityFilterChain

## 3、程序的启动和运行

### 3.1 DefaultSecurityFilterChain

SecurityFilterChain 接口的实现，加载了默认的 16 个 Filter

1. DisableEncodeUrlFilter
2. WebAsyncManagerIntegrationFilter
3. SecurityContextHolderFilter
4. HeaderWriterFilter
5. CorsFilter
6. CsrfFilter
7. LogoutFilter
8. UsernamePasswordAuthenticationFilter
9. DefaultLoginPageGeneratingFilter
10. DefaultLogoutPageGeneratingFilter
11. BasicAuthenticationFilter
12. RequestCacheAwareFilter
13. SecurityContextHolderAwareRequestFilter
14. AnonymousAuthenticationFilter
15. ExceptionTransactionFilter
16. AuthorizationFilter

# P9 入门-SecurityProperties

### 3.2 SecurityProperties

初始化配置，配置了默认的用户名（user）和密码（uuid）

在 application.properties 中配置自定义用户名和密码

```properties
spring.security.user.name=user
spring.security.user.password=123
```

# P10 自定义配置-基于内存的用户认证

## 1、基于内存的用户认证

### 1.1 创建自定义配置

实际开发的过程中，我们需要应用程序更加灵活，可以在 Spring Security 中创建自定义配置文件

UserDetailsService 用来管理用户信息，InMemoryUserDetailsManager 是 UserDetailsService 的一个实现，用来管理基于内存的用户信息。

创建一个 WebSecurityConfig 文件：

定义一个 @Bean，类型是 UserDetailsService，实现是 InMemoryUserDetailsManager

```java
@Configuration
@EnableWebSecurity // Spring 项目总需要添加此注解，Spring Boot 项目中不需要
public class WebSecurityConfig {
    @Bean
    public UserDetailsService userDetailsService() {
        InMemoryUserDetailsManager manager = new InMemoryUserDetailsManager();
        manager.createUser(
            User
            .withDefaultPasswordEncoder()
            .username("user")
            .password("password")
            .roles("USER")
            .build());
        return manager;
    }
}
```

# P11 自定义配置-用户认证源码分析

## 1.2 基于内存的用户认证流程

- 程序启动时：
  - 创建 InMemoryUserDetailsManager 对象
  - 创建 User 对象，封装用户名密码
  - 使用 InMemoryUserDetailsManager 将 User 存入内存
- 校验用户时：
  - SpringSecurity 自动使用 InMemoryUserDetailsManager 的 loadUserByUsername 方法从内存中获取 User 对象
  - 在 UsernamePasswordAuthenticationFilter 过滤器中的 attemptAuthentication 方法中将用户输入的用户名密码和从内存中获取到的用户信息进行比较，进行用户认证

# P12 自定义配置-基于数据库的数据源

## 2、基于数据库的数据源

### 2.1 SQL

```mysql
-- 创建数据库
CREATE DATABASE 'security-demo';
USE 'security-demo';
-- 创建用户表
CREATE TABLE `User`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) DEFAULT NULL,
    `password` VARCHAR(500) DEFAULT NULL,
    `enabled` BOOLEAN NOT NULL
);
-- 唯一索引
CREATE UNIQUE INDEX `user_username_uindex` ON `user`(`username`);
-- 插入用户数据（密码是 "abc"）
INSERT INTO `user`(`username`, `password`, `enabled`) VALUES
('admin', '{bcrypt}$2a$10$GRLdNijSQMUv1/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW', TRUE),
('Helen', '{bcrypt}$2a$10$GRLdNijSQMUv1/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW', TRUE),
('Tom', '{bcrypt}$2a$10$GRLdNijSQMUv1/au9ofL.eDwmoohzzS7.rmNSJZ.0FxO/BTk76klW', TRUE);
```



### 2.2 引入依赖

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.30</version>
</dependency>
```

# P13 自定义配置-基于数据库的用户认证流程分析

## 3、基于数据库的用户认证

### 3.1 基于数据库的用户认证

- 程序启动时：
  - 创建 `DBUserDetailsManager` 对象，实现接口 UserDetailsManager，UserDetailsPasswordService
- 校验用户时：
  - SpringSecurity 自动使用 `DBUserDetailsManager` 的 `loadUserByUsername` 方法从数据库中中获取 User 对象
  - 在 `UsernamePasswordAuthenticationFilter` 过滤器中的 `attemptAuthentication` 方法中将用户输入的用户名密码和从内存中获取到的用户信息进行比较，进行用户认证

# P14 自定义配置-基于数据库的用户认证流程实现

### 3.2 定义 DBUserDetailsManager

```java
public class DBUserDetailsManager implements UserDetailsManager, UserDetailsPassordService {
    @Resource
    private UserMapper userMapper;
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        User user = userMapper.selectOne(queryWrapper);
        if (user == null) {
            throw new UsernameNotFoundException(username);
        }
        Collection<GrantedAuthority> authorities = new ArrayList<>();
        return new org.springframework.securty.core.userdetails.User(
            user.getUsername(),
            user.getPassword(),
            user.getEnabled(),
            true, // 用户账号是否过期
            true, // 用户凭证是否过期
            true, // 用户是否未被锁定
            authorities // 权限列表
        );
    }
}
```

