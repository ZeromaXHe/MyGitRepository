package indi.zeromax.reactor;

import org.junit.jupiter.api.Test;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Sinks;
import reactor.core.scheduler.Schedulers;
import reactor.util.context.Context;

import java.time.Duration;
import java.util.List;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/11 14:42
 */
public class ApiTest {
    @Test
    void filter() {
        Flux.just(1, 2, 3, 4)
                .filter(s -> s % 2 == 0)
                .log()
                .subscribe();
    }

    @Test
    void flatMap() {
        Flux.just("Zhang San", "Li Si")
                .flatMap(v -> {
                    String[] s = v.split(" ");
                    return Flux.fromArray(s);
                })
                .log()
                .subscribe();
    }

    @Test
    void concatMap() {
        Flux.just(1, 2)
                .concatMap(s -> Flux.just(s + "-a", 1))
                .log()
                .subscribe();

        Flux.concat(Flux.just(1, 2), Flux.just("h", "j"), Flux.just("haha", "hehe"))
                .log()
                .subscribe();

        Flux.just(1, 2)
                .concatWith(Flux.just(4, 5, 6))
                .log()
                .subscribe();
    }

    @Test
    void transform() {
        AtomicInteger atomic = new AtomicInteger(0);
        Flux<String> flux = Flux.just("a", "b", "c")
                .transformDeferred(values -> {
                    if (atomic.incrementAndGet() == 1) {
                        // 第一次调用
                        return values.map(String::toUpperCase);
                    } else {
                        return values;
                    }
                });
        // transform，不会共享外部变量的值，无状态转换；原理：无论多少个订阅者，transform 只执行一次
        // transformDeferred，会共享外部变量的值，有状态转换；原理：无论多少个订阅者，每个订阅者 transformDeferred 都执行一次
        flux.subscribe(v -> System.out.println("订阅者1：v = " + v));
        flux.subscribe(v -> System.out.println("订阅者2：v = " + v));
    }

    /**
     * defaultIfEmpty: 静态兜底数据
     * switchIfEmpty: 空转换；调用兜底方法，返回新流数据
     */
    @Test
    void empty() {
        haha()
                .switchIfEmpty(hehe())
                .defaultIfEmpty("x") // 如果发布者元素为空，指定默认值，否则用发布者的值
                .log()
                .subscribe();
    }

    Mono<String> haha() {
//        return Mono.just("a");
        return Mono.empty();
    }

    Mono<String> hehe() {
        return Mono.just("兜底数据");
    }

    /**
     * concat: 连接；A 流所有元素和 B 流所有元素拼接
     * merge: 合并；A 流所有元素和 B 流所有元素按照时间序列合并
     * mergeSequential: 按照哪个流先发元素排队
     */
    @Test
    void merge() {
        Flux.merge(
                        Flux.just(1, 2, 3)
                                .delayElements(Duration.ofSeconds(1)),
                        Flux.just("a", "b")
                                .delayElements(Duration.ofMillis(1500)),
                        Flux.just("haha", "hehe", "heihei", "xixi")
                                .delayElements(Duration.ofMillis(500))
                )
                .log()
                .subscribe();

        try {
            TimeUnit.SECONDS.sleep(4);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void zip() {
        Flux.just(1, 2, 3)
                .zipWith(Flux.just("a", "b", "c", "d"))
                .map(t -> t.getT1() + "===>" + t.getT2())
                .log()
                .subscribe();
    }

    @Test
    void error() {
        Flux.just(1, 2, 0, 4)
                .map(i -> "100 / " + i + " = " + (100 / i))
//                .onErrorReturn("Divided by zero :(")
//                .onErrorReturn(ArithmeticException.class, "Divided by zero :(")
                .onErrorResume(err -> Mono.just("哈哈-777"))
//                .onErrorResume(err -> Flux.error(new RuntimeException(err.getMessage() + ": 炸了")))
//                .onErrorMap(err -> new RuntimeException(err.getMessage() + ": 炸了"))
//                .doOnError(err -> System.out.println("err 已被记录 = " + err))
//                .log()
                .subscribe(
                        v -> System.out.println("v = " + v),
                        err -> System.out.println("err = " + err),
                        () -> System.out.println("流结束")
                );

        Flux.just(1, 2, 3, 4, 0, 5)
                .map(i -> 10 / i)
                .onErrorContinue((err, val) -> {
                    System.out.println("err = " + err);
                    System.out.println("val = " + val);
                    System.out.println("发现" + val + "有问题");
                }) // 发生错误后继续
//                .onErrorStop() // 错误后停止流，源头中断，所有监听者全部结束
//                .onErrorComplete() // 把错误结束信号，替换为正常结束信号
                .subscribe(
                        v -> System.out.println("v = " + v),
                        err -> System.out.println("err = " + err)
                );
    }

    @Test
    void retryAndTimeout() {
        Flux.just(1, 2, 3)
                .delayElements(Duration.ofSeconds(3))
                .log()
                .timeout(Duration.ofSeconds(2))
                .retry(3)
                .map(i -> i + "haha")
                .subscribe();

        try {
            TimeUnit.SECONDS.sleep(10);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void sinks() {
//        Sinks.many(); // 发送 Flux 数据
//        Sinks.one(); // 发送 Mono 数据

        // Sinks：接受器，数据管道，所有数据顺着这个管道往下走的
//        Sinks.many().unicast(); // 单播：这个管道只能绑定单个订阅者（消费者）
//        Sinks.many().multicast(); // 多播：这个管道能绑定多个订阅者
//        Sinks.many().replay(); // 重放：这个管道能重放元素。是否给后来的订阅者把之前的元素依然发给它；
        // 从头消费还是从订阅的那一刻消费

        // 默认订阅者，从订阅的那一刻开始接元素
        Sinks.Many<Object> many = Sinks.many()
//                .multicast() // 多播
                .unicast() // 单播
                .onBackpressureBuffer(new LinkedBlockingQueue<>(5));// 背压队列

        // 发布者数据重放；底层利用队列进行缓存之前数据
//        Sinks.Many<Object> many = Sinks.many()
//                .replay()
//                .limit(3);

        new Thread(() -> {
            for (int i = 0; i < 10; i++) {
                many.tryEmitNext("a - " + i);
                try {
                    TimeUnit.SECONDS.sleep(1);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();

        // 订阅
        many.asFlux()
                .subscribe(v -> System.out.println("v = " + v));

        try {
            TimeUnit.SECONDS.sleep(11);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void cache() {
        // 缓存
        Flux<Integer> cache = Flux.range(1, 10)
                .delayElements(Duration.ofSeconds(1))
                .cache(3); // cache 不写的话，v2 会从头消费，有点奇怪
        cache.subscribe(v -> System.out.println("v1 = " + v));
        // 再定义一个订阅者
        new Thread(() -> {
            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            cache.subscribe(v -> System.out.println("v2 = " + v));
        }).start();


        try {
            TimeUnit.SECONDS.sleep(11);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void block() {
        Integer integer = Flux.just(1, 2, 3, 4)
                .map(i -> i + 10)
                .blockLast();
        System.out.println("integer = " + integer);

        Mono<List<Integer>> mono = Flux.just(1, 2, 3, 4)
                .map(i -> i + 10)
                .collectList();
        List<Integer> integers = mono.block(); // 也是一种订阅者：BlockingMonoSubscriber
        System.out.println("integers = " + integers);
    }

    @Test
    void parallelFlux() {
        // 百万数据，8个线程，每个线程处理 100，分批处理一直到结束
        Flux.range(1, 100)
                .buffer(10)
//                .publishOn(Schedulers.newParallel("xx"))
                .parallel(8)
                .runOn(Schedulers.newParallel("yy"))
                .log()
                .subscribe();
    }

    /**
     * ThreadLocal 在响应式编程中无法使用。
     */
    @Test
    void threadLocal() {
        Flux.just(1,2,3)
                .transformDeferredContextual((flux, context) -> flux.map(i -> i + "==>" + context.get("prefix")))
                // 上游能拿到下游的最近一次数据
                .contextWrite(Context.of("prefix", "哈哈"))
                // ThreadLocal 共享了数据，上游的所有人都能看到； Context 由下游传播给上游
                .subscribe(v -> System.out.println("v = " + v));
    }
}
