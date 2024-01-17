package indi.zeromax.security;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2024/1/17 18:42
 */
@SpringBootTest
public class PasswordTest {
    @Autowired
    PasswordEncoder passwordEncoder;
    @Test
    void test() {
//        PasswordEncoder encoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        String encode = passwordEncoder.encode("123456");
        System.out.println("encode = " + encode);
    }
}
