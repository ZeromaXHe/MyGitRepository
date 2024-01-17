package indi.zeromax.r2dbc;

import indi.zeromax.r2dbc.entity.TAuthor;
import indi.zeromax.r2dbc.entity.TBook;
import indi.zeromax.r2dbc.entity.TBookAuthor;
import indi.zeromax.r2dbc.repositories.AuthorRepository;
import indi.zeromax.r2dbc.repositories.BookAuthorRepository;
import indi.zeromax.r2dbc.repositories.BookRepository;
import io.asyncer.r2dbc.mysql.MySqlConnectionConfiguration;
import io.asyncer.r2dbc.mysql.MySqlConnectionFactory;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.r2dbc.convert.R2dbcCustomConversions;
import org.springframework.data.r2dbc.core.R2dbcEntityTemplate;
import org.springframework.data.relational.core.query.Criteria;
import org.springframework.data.relational.core.query.Query;
import org.springframework.r2dbc.core.DatabaseClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

    @Autowired
    AuthorRepository authorRepository;

    @Autowired
    BookRepository bookRepository;

    @Autowired
    BookAuthorRepository bookAuthorRepository;

    @Autowired
    R2dbcCustomConversions r2dbcCustomConversions;

    @Test
    void oneToN() {
        Flux<TAuthor> flux = databaseClient.sql("SELECT a.id aid, a.name, b.* FROM t_author a " +
                        "LEFT JOIN t_book b ON a.id = b.author_id " +
                        "ORDER BY a.id")
                .fetch()
                .all()
                .bufferUntilChanged(rowMap -> Long.parseLong(rowMap.get("aid").toString()))
                .map(list -> {
                    TAuthor tAuthor = new TAuthor();
                    Map<String, Object> map = list.get(0);
                    tAuthor.setId(Long.parseLong(map.get("aid").toString()));
                    tAuthor.setName(map.get("name").toString());

                    List<TBook> tBooks = list.stream()
                            .map(ele -> {
                                TBook tBook = new TBook();
                                tBook.setId(Long.parseLong(ele.get("id").toString()));
                                tBook.setTitle(ele.get("title").toString());
                                tBook.setAuthorId(Long.parseLong(ele.get("author_id").toString()));
                                return tBook;
                            })
                            .collect(Collectors.toList());
                    tAuthor.setBooks(tBooks);
                    return tAuthor;
                });

        flux.subscribe(tAuthor -> System.out.println("tAuthor = " + tAuthor));

        Flux.just(1, 2, 3, 4, 5, 6)
                .bufferUntilChanged(integer -> integer % 4 == 0)
                .subscribe(list -> System.out.println("list = " + list));

        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void author() {
        authorRepository.findById(1L)
                .subscribe(tAuthor -> System.out.println("tAuthor = " + tAuthor));

        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void book() {
        bookRepository.findAll()
                .subscribe(tBook -> System.out.println("tBook = " + tBook));

        // 自定义转换器 Converter<Row, TBook>：把数据库的 row 转成 TBook
        // 工作时机：Spring Data 发现方法签名只要是返回 TBook，就会利用自定义转换器进行工作
        // 对之前的 CRUD 产生影响
        bookAuthorRepository.hahaBook(1L)
                .subscribe(tBookAuthor -> System.out.println("tBookAuthor = " + tBookAuthor));

        bookRepository.findById(1L)
                /// 两次查询
//                .map(tBook -> {
//                    Long authorId = tBook.getAuthorId();
//                    TAuthor block = authorRepository.findById(authorId).block();
//                    tBook.setTAuthor(block);
//                    return tBook;
//                })
                .subscribe(tBook -> System.out.println("tBook = " + tBook));

        databaseClient.sql("SELECT b.*, t.name AS name" +
                        " FROM r_book b" +
                        " LEFT JOIN t_author t ON b.author_id = t.id" +
                        " WHERE b.id = ?")
                .bind(0, 1L)
                .fetch()
                .all()
                .map(source -> {
                    TBookAuthor tBook = new TBookAuthor();
                    tBook.setId(Long.parseLong(source.get("id").toString()));
                    tBook.setTitle(source.get("title").toString());
                    Long authorId = Long.parseLong(source.get("author_id").toString());
                    tBook.setAuthorId(authorId);
                    tBook.setPublishTime(Instant.parse(source.get("publish_time").toString()));

                    TAuthor tAuthor = new TAuthor();
                    tAuthor.setId(authorId);
                    tAuthor.setName(source.get("name").toString());
                    tBook.setTAuthor(tAuthor);
                    return tBook;
                })
                .subscribe(tBook -> System.out.println("tBook = " + tBook));

        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void authorRepository() {
        authorRepository.findAll()
                .subscribe(tAuthor -> System.out.println("tAuthor = " + tAuthor));

        // 方法起名
        authorRepository.findAllByIdInAndNameLike(Arrays.asList(1L, 2L), "张%")
                .subscribe(tAuthor -> System.out.println("tAuthor = " + tAuthor));

        // 自定义 @Query 注解
        authorRepository.findHaha()
                .subscribe(tAuthor -> System.out.println("tAuthor = " + tAuthor));

        // 1-1 关联
        // 1-N 关联
        // 场景：
        // 1. 一个图书有唯一作者（1-1）
        // 2. 一个作者可以有很多图书（1-N）

        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

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
                    return new TAuthor(Long.parseLong(id), name, null);
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
                    return new TAuthor(id, name, null);
                }))
                .subscribe(author -> System.out.println("author = " + author));

        try {
            System.in.read();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
