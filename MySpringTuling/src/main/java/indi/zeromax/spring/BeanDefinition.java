package indi.zeromax.spring;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/2/5 16:33
 */
public class BeanDefinition {

    private Class type;
    private String scope;

    public Class getType() {
        return type;
    }

    public void setType(Class type) {
        this.type = type;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }
}
