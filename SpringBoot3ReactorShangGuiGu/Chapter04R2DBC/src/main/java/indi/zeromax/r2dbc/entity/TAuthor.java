package indi.zeromax.r2dbc.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.relational.core.mapping.Table;

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
    private Long id;
    private String name;
}
