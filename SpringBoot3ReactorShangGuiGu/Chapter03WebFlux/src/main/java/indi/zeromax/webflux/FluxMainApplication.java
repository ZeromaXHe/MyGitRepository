package indi.zeromax.webflux;

import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.core.io.buffer.DataBufferFactory;
import org.springframework.http.server.reactive.HttpHandler;
import org.springframework.http.server.reactive.ReactorHttpHandlerAdapter;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import reactor.core.publisher.Mono;
import reactor.netty.http.server.HttpServer;

import java.io.IOException;
import java.net.URI;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/1/13 17:24
 */
public class FluxMainApplication {
    public static void main(String[] args) {
        // 快速编写一个能处理请求的服务器

        // 1. 创建一个能处理 Http 请求的处理器
        HttpHandler httpHandler = (ServerHttpRequest request, ServerHttpResponse response) -> {
            URI uri = request.getURI();
            System.out.println(Thread.currentThread() + "请求进来了：" + uri);
            // 编写请求处理的业务，给浏览器写一个内容 URL + “Hello~”
//            response.getHeaders(); // 获取响应头
//            response.getCookies(); // 获取 Cookie
//            response.getStatusCode(); // 获取响应状态码
//            response.bufferFactory(); // buffer 工厂
//            response.writeWith(xxx); // 把 xxx 写出去
//            response.setComplete(); // 响应结束

            // 数据的发布者：Mono<DataBuffer>、Flux<DataBuffer>
            // 创建响应数据的 DataBuffer
            DataBufferFactory factory = response.bufferFactory();
            // 数据 Buffer
            DataBuffer buffer = factory.wrap((uri + " ==> Hello!").getBytes());
            // 需要一个 DataBuffer 的发布者
            return response.writeWith(Mono.just(buffer));
        };

        // 2. 启动一个服务器，监听 8080 接口，接受数据，拿到数据交给 HttpHandler 进行请求处理
        ReactorHttpHandlerAdapter adapter = new ReactorHttpHandlerAdapter(httpHandler);

        // 3. 启动 Netty 服务器
        HttpServer.create()
                .host("localhost")
                .port(8080)
                .handle(adapter)
                .bindNow();

        System.out.println("服务器启动完成... 监听8080，接受请求");
        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        System.out.println("服务器停止...");
    }
}
