package indi.zeromax.security.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 17:40
 */
@Table("t_user_role")
@Data
public class TUserRole {
    @Id
    private Long id;
    private Long userId;
    private Long roleId;
    private Instant createTime;
    private Instant updateTime;
}
