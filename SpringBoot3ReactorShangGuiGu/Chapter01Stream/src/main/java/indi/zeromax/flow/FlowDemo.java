package indi.zeromax.flow;

import java.util.concurrent.Flow;
import java.util.concurrent.SubmissionPublisher;

public class FlowDemo {
    // 定义流中间操作处理器；只用写订阅者的接口
    static class MyProcessor extends SubmissionPublisher<String>
            implements Flow.Processor<String, String> {
private Flow.Subscription subscription;
        @Override
        public void onSubscribe(Flow.Subscription subscription) {
            System.out.println("processor 订阅绑定完成");
            this.subscription = subscription;
            subscription.request(1); // 找上游要一个数据
        }

        @Override
        public void onNext(String item) {
            System.out.println("processor 拿到数据：" + item);
            // 再加工
            item += "哈哈";
            submit(item); // 把加工后的数据发出去
            subscription.request(1); // 再要新数据
        }

        @Override
        public void onError(Throwable throwable) {

        }

        @Override
        public void onComplete() {

        }
    }

    // 发布订阅模型：观察者模式
    public static void main(String[] args) {
        // 1. 定义一个发布者：发布数据；
        SubmissionPublisher<String> publisher = new SubmissionPublisher<>();

        // 2. 定义一个中间操作：给每个元素加个 哈哈 后缀；
        MyProcessor myProcessor = new MyProcessor();

        // 3. 定义一个订阅者：订阅者感兴趣发布者的数据；
        Flow.Subscriber<String> subscriber = new Flow.Subscriber<>() {
            private Flow.Subscription subscription;

            @Override
            public void onSubscribe(Flow.Subscription subscription) {
                System.out.println(Thread.currentThread() + "订阅开始了： " + subscription);
                this.subscription = subscription;
                // 从上游请求一个数据
                this.subscription.request(1);
            }

            @Override
            public void onNext(String item) {
                System.out.println(Thread.currentThread() + "订阅者，接受到数据：" + item);
                this.subscription.request(1);
            }

            @Override
            public void onError(Throwable throwable) {
                System.out.println(Thread.currentThread() + "订阅者，接受到错误信号：" + throwable);
            }

            @Override
            public void onComplete() {
                System.out.println(Thread.currentThread() + "订阅者，接受到完成信号");
            }
        };

        // 4. 绑定发布者、中间操作和订阅者
        publisher.subscribe(myProcessor); // 此时处理器相当于订阅者
        myProcessor.subscribe(subscriber); // 此时处理器相当于发布者
        // 绑定操作，就是发布者记住了所有订阅者，有数据后，给所有订阅者把数据推送过去

        // （必须先绑定再发送，不然收不到）
        // 发布者有数据，订阅者就会拿到
        for (int i = 0; i < 10; i++) {
            // 发布 10 条数据
            publisher.submit("p-" + i);
            // publisher 发布的所有数据在它的 buffer 区
        }

        // JVM 底层对于整个发布订阅关系做好了 异步+缓存区处理 = 响应式系统

        // 发布者通道关闭
        publisher.close();

        try {
            Thread.sleep(20000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

}