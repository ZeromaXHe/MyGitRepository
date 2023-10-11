package indi.zeromax.service;

import org.springframework.web.bind.annotation.PathVariable;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2023/10/11 11:58
 */
public class EchoServiceFallback implements EchoService {
    @Override
    public String echo(@PathVariable("str") String str) {
        return "echo fallback";
    }
}
