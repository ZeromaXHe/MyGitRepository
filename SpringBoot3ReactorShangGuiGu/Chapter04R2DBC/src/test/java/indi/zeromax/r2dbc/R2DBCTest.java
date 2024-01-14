package indi.zeromax.r2dbc;

import indi.zeromax.r2dbc.entity.TAuthor;
import io.asyncer.r2dbc.mysql.MySqlConnectionConfiguration;
import io.asyncer.r2dbc.mysql.MySqlConnectionFactory;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.r2dbc.core.R2dbcEntityTemplate;
import org.springframework.data.relational.core.query.Criteria;
import org.springframework.data.relational.core.query.Query;
import org.springframework.r2dbc.core.DatabaseClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/1/14 12:14
 */
@SpringBootTest
public class R2DBCTest {
    @Autowired
    R2dbcEntityTemplate r2dbcEntityTemplate; // CRUD API; join 查询不好做，单表查询用

    @Autowired
    DatabaseClient databaseClient; // 数据库客户端；贴近底层，join 操作好做，复杂查询好用

    @Test
    void databaseClient() {
        databaseClient.sql("select * from t_author where id = ?")
                .bind(0, 2L)
                .fetch() // 抓取数据
                .all() // 返回所有
                .map(map -> {
                    System.out.println("map = " + map);
                    String id = map.get("id").toString();
                    String name = map.get("name").toString();
                    return new TAuthor(Long.parseLong(id), name);
                })
                .subscribe(tAuthor -> System.out.println("tAuthor = " + tAuthor));

        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void r2dbcEntityTemplate() {
        // 1、Criteria 构造查询条件 where id = 1 and name = '张三'
        Criteria criteria = Criteria.empty().and("id").is(1L)
                .and("name").is("张三");
        // 2、封装为 Query 对象
        Query query = Query.query(criteria);
        r2dbcEntityTemplate.select(query, TAuthor.class)
                .subscribe(tAuthor -> System.out.println("tAuthor = " + tAuthor));
    }

    // 思想：
    // 1. 有了 R2DBC，我们的应用在数据库层面天然支持高并发、高吞吐量。
    // 2. 并不能提升开发效率
    @Test
    void connection() {
        // r2dbc 基于全异步、响应式、消息驱动
        // 0. MySQL 配置
        MySqlConnectionConfiguration configuration = MySqlConnectionConfiguration.builder()
                .host("localhost")
                .port(3306)
                .database("test")
                .username("root")
                .password("root")
                .build();
        // 1. 获取连接工厂
        MySqlConnectionFactory connectionFactory = MySqlConnectionFactory.from(configuration);
        // 2. 获取到连接，发送 SQL

        // 3. 数据发布者
        Mono.from(connectionFactory.create())
                .flatMapMany(connection -> Flux.from(
                        connection.createStatement("SELECT * FROM t_author WHERE id = ?")
                                .bind(0, 2L)
                                .execute()
                ))
                .flatMap(result -> result.map(readable -> {
                    Long id = readable.get("id", Long.class);
                    String name = readable.get("name", String.class);
                    return new TAuthor(id, name);
                }))
                .subscribe(author -> System.out.println("author = " + author));

        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
