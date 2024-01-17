package indi.zeromax.r2dbc.config;

import indi.zeromax.r2dbc.config.converter.BookAuthorConverter;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.r2dbc.convert.R2dbcCustomConversions;
import org.springframework.data.r2dbc.dialect.MySqlDialect;
import org.springframework.data.r2dbc.repository.config.EnableR2dbcRepositories;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 9:46
 */
@EnableR2dbcRepositories
@Configuration
public class R2dbcConfiguration {

    @Bean // 替换容器中原来的
    @ConditionalOnMissingBean
    public R2dbcCustomConversions conversions() {
        // 把我们的转换器加入进去
        return R2dbcCustomConversions.of(MySqlDialect.INSTANCE, new BookAuthorConverter());
    }
}
