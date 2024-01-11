package indi.zeromax.reactor;

import org.reactivestreams.Subscription;
import reactor.core.Disposable;
import reactor.core.publisher.*;
import reactor.core.scheduler.Schedulers;

import java.io.IOException;
import java.time.Duration;
import java.util.List;
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/11 11:08
 */
public class FluxDemo {
    public static void main(String[] args) {
        // Mono: 0|1 个元素的流
        // Flux: N 个元素的流
//        flux();
//        mono();
//        doOnFlux();
//        doOnFluxTiming();
//        logFlux();
//        customSubscribe();
//        bufferFlux();
//        limitFlux();
//        generateFlux();
//        dispose();
//        createFlux();
        thread();
    }

    // Mono<Integer>: 只有一个 Integer
    // Flux<Integer>: 有很多 Integer

    /**
     * 测试 Flux
     */
    private static void flux() {
        // 发布者发布数据流：源头
        // 1. 多元素的流
        Flux<Integer> just = Flux.just(1, 2, 3, 4, 5);
        // 流不消费就没用; 消费：订阅
        just.subscribe(e -> System.out.println("e1 = " + e));
        // 一个数据流可以有很多消费者
        just.subscribe(e -> System.out.println("e2 = " + e));
        // 对于每一个消费者来说流都是一样的； 广播模式；
        System.out.println("==========");
        Flux<Long> flux = Flux.interval(Duration.ofSeconds(1));// 每秒产生一个从 0 开始的递增数字
        flux.subscribe(System.out::println);
        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static void mono() {
        Mono<Integer> just = Mono.just(1);
        just.subscribe(System.out::println);
    }

    private static void doOnFlux() {
        // 空流
        Flux<Object> empty = Flux.empty() // 有一个信号：此时代表完成信号
                // 事件感知：当流发生什么事的时候，触发一个回调，系统调用提前定义好的钩子函数； doOnXxx
                .doOnComplete(() -> System.out.println("流正常结束了..."));
        empty.subscribe(System.out::println);

        // 链式 API 中，下面的操作符，操作的是上面的流。
        Flux<Integer> flux = Flux.range(1, 7)
                .delayElements(Duration.ofSeconds(1)) // 整流，调频
                // 事件感知：当流发生什么事的时候，触发一个回调，系统调用提前定义好的钩子函数； doOnXxx
                .doOnComplete(() -> System.out.println("流正常结束了..."))
                .doOnCancel(() -> System.out.println("流已被取消..."))
                .doOnError(e -> System.out.println("流出错..." + e))
                .doOnNext(i -> System.out.println("doOnNext..." + i));
        flux.subscribe(new BaseSubscriber<Integer>() {
            @Override
            protected void hookOnSubscribe(Subscription subscription) {
                System.out.println("订阅者和发布者绑定好了：" + subscription);
                request(1);
            }

            @Override
            protected void hookOnNext(Integer value) {
                System.out.println("元素到达：" + value);
                if (value < 5) {
                    request(1);
                    if (value == 3) {
                        throw new RuntimeException("异常");
                    }
                } else {
                    cancel();
                }
            }

            @Override
            protected void hookOnComplete() {
                System.out.println("数据流完成");
            }

            @Override
            protected void hookOnError(Throwable throwable) {
                System.out.println("数据流异常");
            }

            @Override
            protected void hookOnCancel() {
                System.out.println("数据流取消");
            }

            @Override
            protected void hookFinally(SignalType type) {
                System.out.println("结束信号：" + type);
            }
        });

        try {
            Thread.sleep(20000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 响应式编程核心：看懂文档弹珠图；
     * 信号： 正常/异常（取消）
     * SignalType:
     * SUBSCRIBE: 被订阅
     * REQUEST: 请求了 N 个元素
     * CANCEL: 流被取消
     * ON_SUBSCRIBE: 在订阅的时候
     * ON_NEXT: 在数据到达
     * ON_ERROR: 在流错误
     * ON_COMPLETE: 在流正常完成时
     * AFTER_TERMINATE: 中断以后
     * CURRENT_CONTEXT: 当前上下文
     * ON_CONTEXT: 感知上下文
     * doOnXxx API 触发的时机
     * 1. doOnNext: 每个数据（流的数据）到达的时候触发
     * 2. doOnEach: 每个元素（流的数据和信号）到达的时候触发
     * 3. doOnRequest: 消费者请求流元素的时候
     * 4. doOnError: 流发生错误
     * 5. doOnSubscribe: 流被订阅的时候
     * 6. doOnTerminate: 发送取消/异常信号中断了流
     * 7. doOnCancel: 流被取消
     * 8. doOnDiscard: 流中元素被忽略的时候
     */
    private static void doOnFluxTiming() {
        // doOnXxx 要感知某个流的事件，写在这个流的后面，新流的前面
        Flux.just(1, 2, 3, 4, 5, 6, 7, 0, 5, 6)
                .doOnNext(i -> System.out.println("元素到达1：" + i))
                .doOnEach(integerSignal -> System.out.println("doOnEach..." + integerSignal))
                .map(i -> 10 / i)
                .doOnError(t -> System.out.println("数据库已经保存了异常：" + t.getMessage()))
                .doOnNext(i -> System.out.println("元素到达2：" + i))
                .subscribe(System.out::println);
    }

    private static void logFlux() {
        Flux.concat(Flux.just(1, 2, 3), Flux.just(7, 8, 9))
                .subscribe(System.out::println);
        Flux.range(1, 7)
                .log() // OnNext(1~7)
                .filter(i -> i > 3)
//                .log() // OnNext(4~7)
                .map(i -> "haha-" + i)
//                .log() // OnNext(haha-4~7)
                .subscribe(System.out::println);
    }

    private static void customSubscribe() {
        // doOnXxx: 发生这个事件的时候产生一个回调，通知你
        // onXxx: 发生这个事件后执行一个动作，可以改变元素、信号
        // AOP: 普通通知（前置、后置、异常、返回） 环绕通知（ProceedingJoinPoint）
        Flux<String> flux = Flux.range(1, 10)
                .map(i -> {
                    System.out.println("map..." + i);
                    if (i == 9) {
//                        i = 10 / (9 - i); // 数学运算异常
                    }
                    return "哈哈：" + i;
                })
                .onErrorComplete(); // 流错误的时候，把错误吃掉，转为正常信号

//        flux.subscribe();// 流被订阅; 默认订阅
//        flux.subscribe(v -> System.out.println("v = " + v)); // 指定订阅规则；正常消费者，只消费正常元素
//        flux.subscribe(
//                v -> System.out.println("v = " + v),
//                throwable -> System.out.println("throwable = " + throwable), // 异常结束
//                () -> System.out.println("流结束了...")
//        );
        // 流的生命周期钩子可以传播给订阅者
        flux.subscribe(new BaseSubscriber<>() {
            /**
             * 生命周期钩子 1： 订阅关系绑定的时候触发
             * @param subscription
             */
            @Override
            protected void hookOnSubscribe(Subscription subscription) {
                // 流被订阅的时候触发
                System.out.println("绑定了..." + subscription);
                // 找发布者要数据
                request(1); // 要 1 个数据: 给上游传入数据传送一个信号
//                requestUnbounded(); // 要无限数据：上游给我所有
            }

            @Override
            protected void hookOnNext(String value) {
                System.out.println("数据到达：" + value);
                if ("哈哈：5".equals(value)) {
                    cancel();
                }
                request(1);
            }

            // hookOnComplete、hookOnError 二选一执行
            @Override
            protected void hookOnComplete() {
                System.out.println("流正常结束...");
            }

            @Override
            protected void hookOnError(Throwable throwable) {
                System.out.println("流异常..." + throwable);
            }

            @Override
            protected void hookOnCancel() {
                System.out.println("流被取消...");
            }

            @Override
            protected void hookFinally(SignalType type) {
                System.out.println("最终回调...一定会执行");
            }
        });
    }

    private static void bufferFlux() {
        Flux<List<Integer>> flux = Flux.range(1, 10)
                .buffer(3) // 缓冲区：缓冲 3 个元素；消费一次最多可以拿到三个元素;
                .log();
        flux.subscribe();
        // 消费者每次 request(1) 拿到的是几个真正的数据： buffer 的数据
//        flux.subscribe(new BaseSubscriber<>() {
//            @Override
//            protected void hookOnSubscribe(Subscription subscription) {
//                System.out.println("绑定关系...");
//                // request(N): 找发布者请求 N 次数据；总共得到 N * bufferSize 个数据
//                request(1);
//            }
//
//            @Override
//            protected void hookOnNext(List<Integer> value) {
//                System.out.println("元素：" + value);
//            }
//        });
    }

    private static void limitFlux() {
        Flux.range(1, 100)
                .log() // 限流触发，看上游是怎么限流获取数据的
                .limitRate(30) // 一次预取 30 个元素
                .subscribe();
        // 75% 预取策略： limitRate(100)
        // 第一次抓取 100 个数据，如果 75% 的元素已经处理了，继续抓取新的 75% 元素
    }

    /**
     * 编程方式创建序列
     * Sink: 接收器、水槽、通道
     * 同步环境-generate
     * 多线程-create
     */
    private static void generateFlux() {
        Flux<Object> flux = Flux.generate(
                () -> 0, // 初始值
                (state, sink) -> {
                    sink.next("哈哈-" + state); // 传递数据；可能会抛出【不受检异常（运行时异常）、受检异常（编译时异常）】
                    if (state == 10) {
                        sink.complete();
                    }
                    if (state == 7) {
                        sink.error(new RuntimeException("我不喜欢 7"));
                    }
                    return state + 1; // 返回一个新的迭代 state 值
                });
        flux.log()
                .subscribe();
    }

    private static void dispose() {
        Flux<Integer> flux = Flux.range(1, 10000)
                .delayElements(Duration.ofSeconds(1))
                .map(i -> i + 7)
                .log();
        // 消费者是实现了 Disposable 可取消
        Disposable disposable = flux.subscribe(System.out::println);

        new Thread(() -> {
            try {
                Thread.sleep(10000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            disposable.dispose(); // 销毁
        }).start();

        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static void createFlux() {
        // 异步环境下
        Flux.create(fluxSink -> {
                    MyListener listener = new MyListener(fluxSink);
                    for (int i = 0; i < 100; i++) {
                        listener.online("用户" + i);
                    }
                })
                .log()
                .subscribe();
    }

    static class MyListener {
        FluxSink<Object> sink;

        public MyListener(FluxSink<Object> sink) {
            this.sink = sink;
        }

        /**
         * 用户登录，触发 online 监听
         */
        public void online(String userName) {
            System.out.println("用户登陆了：" + userName);
            sink.next(userName); // 传入用户
        }
    }

    /**
     * 自定义流中元素处理规则
     */
    private static void handle() {
        Flux.range(1, 10)
                .handle((value, sink) -> {
                    System.out.println("拿到的值：" + value);
                    sink.next("张三：" + value);
                })
                .log()
                .subscribe();
    }

    private static void thread() {
        // 响应式编程：全异步、消息、事件回调
        // 默认还是用订阅者的当前线程，生成整个流、发布流、流操作
        Flux.range(1, 10)
                .publishOn(Schedulers.single()) // 在哪个线程池把这个流的数据和操作执行
                .log()
                .map(i -> i + 10)
                .log()
                .subscribe();

        // publishOn: 改变发布者所在线程池
        // subscribeOn: 改变订阅者所在的线程池

        // 调度器
        Schedulers.immediate(); // 无执行上下文，当前线程运行所有操作
        Schedulers.single(); // 使用固定的一个单线程
        Schedulers.boundedElastic(); // 有界、弹性调度; 线程池中有 10 * CPU 核心个线程；队列默认 100K
        Schedulers.parallel();
        Schedulers.fromExecutor(new ThreadPoolExecutor(4, 8, 60, TimeUnit.SECONDS, new LinkedBlockingDeque<>(1000)));
    }
}
