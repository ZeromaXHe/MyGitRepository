package indi.zeromax.webflux.controller;

import org.springframework.http.MediaType;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.reactive.result.view.Rendering;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.Duration;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/1/13 17:47
 */
@Controller
public class HelloController {

    // WebFlux: 向下兼容原来 SpringMVC 的大多数注解和 API
    @ResponseBody
    @GetMapping("/hello")
    public String hello(@RequestParam(value = "key", required = false, defaultValue = "haha") String key) {
        return "Hello world! key = " + key;
    }

    @ResponseBody
    @GetMapping("/haha")
    public Mono<String> haha() {
//        return Mono.just("哈哈哈");
        return Mono.just(0)
                .map(i -> 10 / i)
                .map(i -> "哈哈" + i);
    }

    @ResponseBody
    @GetMapping("/hehe")
    public Flux<String> hehe() {
        return Flux.just("呵呵", "呵呵2");
    }

    /**
     * SSE 测试；服务端推送
     *
     * @return
     */
    @ResponseBody
    @GetMapping(value = "/sse", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> sse() {
        return Flux.range(1, 10)
                .map(i -> "ha" + i)
                .delayElements(Duration.ofMillis(500));
    }

    @ResponseBody
    @GetMapping(value = "/sse2", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<ServerSentEvent<String>> sse2() {
        return Flux.range(1, 10)
                .map(i -> ServerSentEvent.builder("ha-" + i)
                        .id(i + "")
                        .comment("hei - " + i)
                        .event("haha")
                        .build())
                .delayElements(Duration.ofMillis(500));
    }

    @GetMapping("/baidu")
    public Rendering render() {
        return Rendering.redirectTo("http://www.baidu.com").build();
    }
}
