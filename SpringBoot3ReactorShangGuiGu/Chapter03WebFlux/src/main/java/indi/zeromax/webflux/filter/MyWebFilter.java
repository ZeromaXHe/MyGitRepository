package indi.zeromax.webflux.filter;

import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/1/13 23:07
 */
@Component
public class MyWebFilter implements WebFilter {
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        ServerHttpResponse response = exchange.getResponse();
        System.out.println("请求处理放行到目标方法之前...");
        Mono<Void> mono = chain.filter(exchange)
                .doOnError(err -> System.out.println("目标方法异常之后..."))
                .doFinally(signalType -> System.out.println("目标方法执行之后..."));
        return mono;
    }
}
