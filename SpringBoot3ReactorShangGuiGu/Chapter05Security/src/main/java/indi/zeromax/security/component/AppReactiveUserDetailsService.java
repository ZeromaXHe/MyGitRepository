package indi.zeromax.security.component;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

/**
 * @author zhuxi
 * @apiNote 来定义如何去数据库中按照用户名查用户
 * @implNote
 * @since 2024/1/17 18:23
 */
@Component
public class AppReactiveUserDetailsService implements ReactiveUserDetailsService {
    @Autowired
    DatabaseClient databaseClient;
    @Autowired
    PasswordEncoder passwordEncoder;

    /**
     * 自定义如何按照用户名去数据库查询用户信息
     *
     * @param username
     * @return
     */
    @Override
    public Mono<UserDetails> findByUsername(String username) {
        return databaseClient.sql("SELECT u.*, r.id rid, r.name, r.value, pm.id pid, pm.value pvalue, pm.description " +
                        "FROM t_user u " +
                        "LEFT JOIN t_user_role ur on ur.user_id = u.id " +
                        "LEFT JOIN t_roles r on r.id = ur.role_id " +
                        "LEFT JOIN t_role_perm rp on rp.role_id = r.id " +
                        "LEFT JOIN t_perm pm on rp.perm_id = pm.id " +
                        "WHERE u.username = ? LIMIT 1")
                .bind(0, username)
                .fetch()
//                .all()
//                .bufferUntilChanged()
                .one()
                .map(map -> User.builder()
                        .username(username)
                        .password(map.get("password").toString())
                        .passwordEncoder(passwordEncoder::encode)
                        .authorities(new SimpleGrantedAuthority("delete")) // 权限
                        .roles("admin", "sale", "haha") // 角色
                        .build());
    }
}
