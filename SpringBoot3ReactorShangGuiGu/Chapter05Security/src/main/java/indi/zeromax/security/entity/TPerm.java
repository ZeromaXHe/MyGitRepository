package indi.zeromax.security.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 17:34
 */
@Table("t_perm")
@Data
public class TPerm {
    @Id
    @Column("id")
    private Long id;

    @Column("value")
    private String value;

    @Column("uri")
    private String uri;

    @Column("description")
    private String description;

    @Column("create_time")
    private Instant createTime;

    @Column("update_time")
    private Instant updateTime;
}
