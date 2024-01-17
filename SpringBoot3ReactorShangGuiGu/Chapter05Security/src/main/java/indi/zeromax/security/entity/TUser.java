package indi.zeromax.security.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.Instant;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 17:39
 */
@Table("t_user")
@Data
public class TUser {
    @Id
    private Long id;
    private String username;
    private String password;
    private String email;
    private String phone;
    private Instant createTime;
    private Instant updateTime;
}
