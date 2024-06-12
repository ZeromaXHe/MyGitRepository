package indi.zeromax.springboot3demo.threadpool;

import jakarta.annotation.PreDestroy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.scheduling.concurrent.CustomizableThreadFactory;
import org.springframework.stereotype.Component;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * @author Zhu Xiaohe
 * @apiNote
 * @implNote
 * @since 2024/6/12 20:52
 */
@Component
public class ThreadPoolManager implements ApplicationRunner {
    private static final Logger LOGGER = LoggerFactory.getLogger(ThreadPoolManager.class);

    private final ExecutorService DOWNLOAD_POOL = new ThreadPoolExecutor(8 + 1, 2 * 8,
            10, TimeUnit.MINUTES, new LinkedBlockingQueue<>(),
            new CustomizableThreadFactory("test-pool-"));

    @Override
    public void run(ApplicationArguments args) throws Exception {
        init();
    }

    public void init() {
        LOGGER.info("开始创建线程池");
        int threadNum = 4;
        for (int i = 0; i < threadNum; i++) {
            DOWNLOAD_POOL.submit(ApplicationContextProvider.getBean("testThread", TestThread.class));
        }
    }

    @PreDestroy
    public void destroy() {
        LOGGER.info("开始销毁线程池!");
        // 原代码没销毁线程池
//        DOWNLOAD_POOL.shutdown();
    }
}
