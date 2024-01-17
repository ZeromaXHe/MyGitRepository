package indi.zeromax.security.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 17:38
 */
@Table("t_roles")
@Data
public class TRoles {
    @Id
    private Long id;
    private String name;
    private String value;
    private Instant createTime;
    private Instant updateTime;
}
