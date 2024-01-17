package indi.zeromax.r2dbc.repositories;

import indi.zeromax.r2dbc.entity.TAuthor;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

import java.util.Collection;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 9:47
 */
@Repository
public interface AuthorRepository extends R2dbcRepository<TAuthor, Long> {
    // ReactiveCrudRepository 默认继承了一堆 CRUD 方法；像 MyBatis-plus
    // R2dbcRepository 还多继承了 ReactiveSortingRepository<T, ID>, ReactiveQueryByExampleExecutor<T>

    // QBC： Query By Criteria
    // QBE： Query By Example
    // 成为一名起名工程师 where id in () and name like ?
    // 仅限单表复杂查询
    Flux<TAuthor> findAllByIdInAndNameLike(Collection<Long> id, String name);

    // 多表复杂查询
    @Query("SELECT * FROM t_author")
    Flux<TAuthor> findHaha();
}
