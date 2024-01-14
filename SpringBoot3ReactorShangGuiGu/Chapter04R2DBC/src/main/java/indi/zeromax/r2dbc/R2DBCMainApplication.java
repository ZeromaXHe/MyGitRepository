package indi.zeromax.r2dbc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote Spring Boot 对 R2DBC 的自动配置
 * 1. R2dbcAutoConfiguration 主要配置连接工厂、连接池
 * 2. R2dbcDataAutoConfiguration
 * (R2dbcEntityTemplate 操作数据库的响应式客户端, 提供 CRUD API、数据映射关系、转换器、R2dbcCustomConversions 自定义转换器组件)
 * 3. R2dbcRepositoriesAutoConfiguration 开启 Spring Data 声明式接口方式的 CRUD
 * 4. R2dbcTransactionManagerAutoConfiguration 事务管理
 * @since 2024/1/14 17:53
 */
@SpringBootApplication
public class R2DBCMainApplication {
    public static void main(String[] args) {
        SpringApplication.run(R2DBCMainApplication.class, args);
    }
}
