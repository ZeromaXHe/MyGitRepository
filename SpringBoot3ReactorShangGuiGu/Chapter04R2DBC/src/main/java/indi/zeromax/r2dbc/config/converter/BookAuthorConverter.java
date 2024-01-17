package indi.zeromax.r2dbc.config.converter;

import indi.zeromax.r2dbc.entity.TAuthor;
import indi.zeromax.r2dbc.entity.TBookAuthor;
import io.r2dbc.spi.Row;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.ReadingConverter;

import java.time.Instant;

/**
 * @author zhuxi
 * @apiNote 告诉 Spring Data 怎么封装 Book 对象
 * @implNote
 * @since 2024/1/17 15:23
 */
@ReadingConverter // 读取数据库数据的时候，把 row 转成 TBook
public class BookAuthorConverter implements Converter<Row, TBookAuthor> {
    /**
     * 1. @Query 指定了 SQL 如何发送
     * 2. 自定义 BookConverter 指定了数据库返回的 Row 数据，怎么封装成 TBookAuthor
     * 3. 配置 R2dbcCustomConversions 组件，让 BookConverter 加入其中生效
     *
     * @param source
     * @return
     */
    @Override
    public TBookAuthor convert(Row source) {
        if (source == null) {
            return null;
        }
        // 自定义结果集的封装
        TBookAuthor tBookAuthor = new TBookAuthor();
        tBookAuthor.setId(source.get("id", Long.class));
        tBookAuthor.setTitle(source.get("title", String.class));
        Long authorId = source.get("author_id", Long.class);
        tBookAuthor.setAuthorId(authorId);
        tBookAuthor.setPublishTime(source.get("publish_time", Instant.class));

        // 让 Converter 兼容更多的表结构处理
        if (source.getMetadata().contains("name")) {
            TAuthor tAuthor = new TAuthor();
            tAuthor.setId(authorId);
            tAuthor.setName(source.get("name", String.class));
            tBookAuthor.setTAuthor(tAuthor);
        }
        return tBookAuthor;
    }
}
