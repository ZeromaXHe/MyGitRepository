package indi.zeromax.spring;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/2/5 17:16
 */
public interface BeanPostProcessor {
    Object postProcessBeforeInitialization(String beanName, Object bean);
    Object postProcessAfterInitialization(String beanName, Object bean);
}
