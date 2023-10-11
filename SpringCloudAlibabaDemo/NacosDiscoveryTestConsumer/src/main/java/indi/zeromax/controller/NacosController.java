package indi.zeromax.controller;

import com.alibaba.csp.sentinel.annotation.SentinelResource;
import indi.zeromax.service.EchoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.loadbalancer.LoadBalancerClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2023/10/9 11:11
 */
@RestController
public class NacosController {
    @Autowired
    private LoadBalancerClient loadBalancerClient;
    @Autowired
    private RestTemplate restTemplate;
    @Autowired
    private EchoService echoService;

    @Value("${spring.application.name}")
    private String appName;

    /**
     * Nacos Discovery 服务发现调用生产者测试
     *
     * @return
     */
    @GetMapping("/echo/app-name")
    public String echoAppName() {
        //使用 LoadBalanceClient 和 RestTemplate 结合的方式来访问
        ServiceInstance serviceInstance = loadBalancerClient.choose("nacos-provider");
        String url = String.format("http://%s:%s/echo/%s", serviceInstance.getHost(), serviceInstance.getPort(), appName);
        System.out.println("request url:" + url);
        return restTemplate.getForObject(url, String.class);
    }

    /**
     * OpenFeign 测试
     *
     * @return
     */
    @GetMapping("/echo/feign/{str}")
    public String echoFeign(@PathVariable String str) {
        return echoService.echo(str);
    }

    /**
     * Sentinel 测试
     *
     * @return
     */
    @GetMapping(value = "/hello")
    @SentinelResource("hello")
    public String hello() {
        return "Hello Sentinel";
    }
}
