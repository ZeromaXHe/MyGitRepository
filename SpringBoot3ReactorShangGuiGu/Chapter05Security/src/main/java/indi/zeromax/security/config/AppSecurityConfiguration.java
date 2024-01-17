package indi.zeromax.security.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.reactive.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.UserDetailsRepositoryReactiveAuthenticationManager;
import org.springframework.security.config.annotation.method.configuration.EnableReactiveMethodSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.server.SecurityWebFilterChain;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 17:59
 */
@Configuration
@EnableReactiveMethodSecurity // 开启响应式的方法级别的权限控制
public class AppSecurityConfiguration {
    @Autowired
    ReactiveUserDetailsService appReactiveUserDetailsService;

    @Bean
    SecurityWebFilterChain springSecurityFilterChain(ServerHttpSecurity http) {
        // 1. 定义哪些请求需要认证，哪些不需要
        http.authorizeExchange(exchanges -> {
            // 1.1 允许所有人都访问
            exchanges.matchers(PathRequest.toStaticResources().atCommonLocations()).permitAll();
            // 1.2 剩下的所有请求都需要认证
            exchanges.anyExchange().authenticated();
        });
        // 2. 开启默认的表单登录
        http.formLogin(formLoginSpec -> {
        });
        // 3. 安全控制
        http.csrf(csrfSpec -> {
            csrfSpec.disable();
        });

        // 目前认证：用户名是 user，密码是默认生成
        // 期望认证：去数据库查用户名和密码

        // 4. 配置认证规则：如何去数据库中查询到用户；
        // Spring Security 底层使用 ReactiveAuthenticationManager 去查询用户信息
        // ReactiveAuthenticationManager 有一个实现是 UserDetailsRepositoryReactiveAuthenticationManager
        // UserDetailsRepositoryReactiveAuthenticationManager： 用户信息去数据库中查
        // 它需要 ReactiveUserDetailsService: 响应式的用户详情查询服务
        // 我们只需要自己写一个 ReactiveUserDetailsService
        http.authenticationManager(new UserDetailsRepositoryReactiveAuthenticationManager(appReactiveUserDetailsService));

        // 构建出安全配置
        return http.build();
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }
}
