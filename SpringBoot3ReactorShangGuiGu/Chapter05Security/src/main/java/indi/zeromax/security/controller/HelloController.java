package indi.zeromax.security.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

/**
 * @author zhuxi
 * @apiNote
 * @implNote Spring Security 默认行为：所有请求都需要登录才能访问
 * 1. SecurityAutoConfiguration：
 * 导入 SecurityFilterChain 组件：默认所有请求都需要登录才可以访问，默认登录页
 * 2. SecurityFilterAutoConfiguration
 * 3. ReactiveSecurityAutoConfiguration
 * 导入 ServerHttpSecurityConfiguration 配置：
 * 4. MethodSecurityAspectJAutoProxyRegistrar
 * @since 2024/1/17 17:51
 */
@RestController
public class HelloController {
    @PreAuthorize("hasRole('admin')")
    @GetMapping("/hello")
    public Mono<String> hello() {
        return Mono.just("Hello, world!");
    }

    @PreAuthorize("hasAuthority('delete') && hasRole('haha')")
    @GetMapping("/world")
    public Mono<String> world() {
        return Mono.just("world!!!");
    }
}
