package indi.zeromax.service;

import indi.zeromax.spring.MyApplicationContext;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/2/5 15:10
 */
public class Test {
    public static void main(String[] args) {
        MyApplicationContext applicationContext = new MyApplicationContext(AppConfig.class);

        // 测试单例、多例
//        System.out.println(applicationContext.getBean("userService"));
//        System.out.println(applicationContext.getBean("userService"));
//        System.out.println(applicationContext.getBean("userService"));
//        System.out.println(applicationContext.getBean("orderService"));

        IUserService userService = (IUserService) applicationContext.getBean("userService");
        userService.test();
    }
}
