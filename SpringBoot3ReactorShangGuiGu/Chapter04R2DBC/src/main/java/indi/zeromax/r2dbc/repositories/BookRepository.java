package indi.zeromax.r2dbc.repositories;

import indi.zeromax.r2dbc.entity.TBook;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 10:11
 */
@Repository
public interface BookRepository extends R2dbcRepository<TBook, Long> {
}
