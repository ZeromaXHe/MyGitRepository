package indi.zeromax.springboot3demo.threadpool;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

/**
 * @author Zhu Xiaohe
 * @apiNote
 * @implNote
 * @since 2024/6/12 20:57
 */
@Component
public class TestThread implements Runnable /*其实还实现了 cn.hutool.core.io.StreamProgress*/{
    private static final Logger LOGGER = LoggerFactory.getLogger(TestThread.class);

    private static final long TEN_MINUTES = 60 * 10;

    private static void sleep(long timeMill) {
        try {
            TimeUnit.MILLISECONDS.sleep(timeMill);
        } catch (InterruptedException e) {
            LOGGER.error("旦米sleep异常：", e);
        }
    }

    @Override
    public void run() {
        while (true) {
            final String key = "devtest:async:list";
            // 这里用 redis 取任务
            String billJson = "stringRedisTemplate.opsForList().rightPop(key, 1, TimeUnit.MINUTES)";
            if (StringUtils.isEmpty(billJson)) {
                sleep(ThreadLocalRandom.current().nextInt(1000, 2000));
                LOGGER.info("队列为空，等待");
                continue;//继续获取
            }
            // Bill bill = JSONObject.parseObject(billJson, Bill.class);
            // 原代码如此，这里用 jackson 代替 fastjson 示例
            Bill bill = null;
            try {
                bill = new ObjectMapper().readValue(billJson, Bill.class);
            } catch (JsonProcessingException e) {
                throw new RuntimeException(e);
            }
            if (bill == null) {
                LOGGER.warn("下载队列，json={}，转换为空，下载失败", billJson);
                continue;
            }
            long currTime = bill.getCurrTime();
            long second = (System.currentTimeMillis() - currTime) / 1000;
            if (second < TEN_MINUTES) {
                throw new RuntimeException("测试 Redis 异常的情况");
//                stringRedisTemplate.opsForList().leftPush(key, billJson);
//                sleep(ThreadLocalRandom.current().nextInt(1000, 2000));
//                LOGGER.info("需要等待 10 min，再处理");
//                continue;
            }
            // 后面是下载的业务逻辑
            LOGGER.info("成功处理了 {},耗时 {} s！！！！！！！", billJson, second);
        }
    }

    static class Bill {
        private long currTime;

        public long getCurrTime() {
            return currTime;
        }

        public void setCurrTime(long currTime) {
            this.currTime = currTime;
        }
    }
}
