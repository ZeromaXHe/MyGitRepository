package indi.zeromax;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.ConfigurableApplicationContext;

import java.util.concurrent.TimeUnit;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2023/10/9 11:00
 */
@SpringBootApplication
@EnableDiscoveryClient
public class NacosProviderDemoApplication {
    public static void main(String[] args) {
        ConfigurableApplicationContext applicationContext = SpringApplication.run(NacosProviderDemoApplication.class, args);
        for (int i = 0; i < 100; i++) {
            String testConfigName = applicationContext.getEnvironment().getProperty("test.config.name");
            String testConfigEnv = applicationContext.getEnvironment().getProperty("test.config.env");
            System.err.println("[" + i + "] testConfigName: " + testConfigName + ", env: " + testConfigEnv);
            try {
                TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
