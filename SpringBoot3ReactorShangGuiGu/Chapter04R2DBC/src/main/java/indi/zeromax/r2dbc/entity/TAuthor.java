package indi.zeromax.r2dbc.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Transient;
import org.springframework.data.relational.core.mapping.Table;

import java.util.List;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/1/14 16:52
 */
@Table("t_author")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class TAuthor {
    @Id
    private Long id;
    private String name;

    // 1-N 如何封装
    @Transient // 临时字段，并不是数据库表中的一个字段
    private List<TBook> books;
}
