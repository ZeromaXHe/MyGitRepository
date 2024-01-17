package indi.zeromax.r2dbc.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 10:04
 */
@Table("t_book")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class TBook {
    @Id
    private Long id;
    private String title;
    private Long authorId;
    /**
     * 响应式中日期的映射用 Instant 或者 LocalXxx
     */
    private Instant publishTime;
}
