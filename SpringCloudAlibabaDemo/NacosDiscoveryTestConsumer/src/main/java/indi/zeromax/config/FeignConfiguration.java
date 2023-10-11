package indi.zeromax.config;

import indi.zeromax.service.EchoServiceFallback;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2023/10/11 11:58
 */
@Configuration
public class FeignConfiguration {
    @Bean
    public EchoServiceFallback echoServiceFallback() {
        return new EchoServiceFallback();
    }
}
