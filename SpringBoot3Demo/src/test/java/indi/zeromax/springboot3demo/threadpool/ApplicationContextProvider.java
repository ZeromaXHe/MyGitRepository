package indi.zeromax.springboot3demo.threadpool;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

/**
 * @author Zhu Xiaohe
 * @apiNote
 * @implNote
 * @since 2024/6/12 20:56
 */
@Component
public class ApplicationContextProvider implements ApplicationContextAware {

    //Spring 容器
    private static ApplicationContext applicationContext;


    //私有化，不能New
    private ApplicationContextProvider(){}

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext; //记住Spring 容器方便从里面获取Bean
    }

    //获取Spring 容器中对象
    public  static <T> T getBean(String name,Class<T> aClass){
        return applicationContext.getBean(name, aClass);
    }
}