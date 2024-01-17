package indi.zeromax.security.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 17:36
 */
@Table("t_role_perm")
@Data
public class TRolePerm {
    @Id
    private Long id;
    private Long roleId;
    private Long permId;
    private Instant createTime;
    private Instant updateTime;
}

