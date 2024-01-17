package indi.zeromax.r2dbc.repositories;

import indi.zeromax.r2dbc.entity.TBookAuthor;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 10:11
 */
@Repository
public interface BookAuthorRepository extends R2dbcRepository<TBookAuthor, Long> {
    @Query("SELECT b.*, t.name AS name" +
            " FROM r_book b" +
            " LEFT JOIN t_author t ON b.author_id = t.id" +
            " WHERE b.id = :bookId")
    Mono<TBookAuthor> hahaBook(@Param("bookId") Long bookId);
}
