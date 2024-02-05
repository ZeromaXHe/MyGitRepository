package indi.zeromax.service;

import indi.zeromax.spring.Autowired;
import indi.zeromax.spring.BeanNameAware;
import indi.zeromax.spring.Component;
import indi.zeromax.spring.InitializingBean;
import indi.zeromax.spring.Scope;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/2/5 15:10
 */
@Component("userService")
//@Scope("prototype")
public class UserService implements IUserService, BeanNameAware, InitializingBean {
    @Autowired
    private OrderService orderService;

    private String beanName;

    @Override
    public void setBeanName(String beanName) {
        this.beanName = beanName;
    }

    @Override
    public void afterPropertiesSet() {
        System.out.println("afterPropertiesSet");
    }

    @Override
    public void test() {
        System.out.println(orderService);
    }
}
