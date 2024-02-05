package indi.zeromax.service;

import indi.zeromax.spring.BeanPostProcessor;
import indi.zeromax.spring.Component;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/2/5 17:17
 */
@Component
public class MyBeanPostProcessor implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(String beanName, Object bean) {
        if (beanName.equals("userService")) {
            System.out.println("=== userService postProcessBeforeInitialization");
        }
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(String beanName, Object bean) {
        if (beanName.equals("userService")) {
            System.out.println("=== userService postProcessAfterInitialization");
            Object proxyInstance = Proxy.newProxyInstance(MyBeanPostProcessor.class.getClassLoader(),
                    bean.getClass().getInterfaces(),
                    (proxy, method, args) -> {
                        System.out.println("切面逻辑");
                        return method.invoke(bean, args);
                    });
            return proxyInstance;
        }
        return bean;
    }
}
