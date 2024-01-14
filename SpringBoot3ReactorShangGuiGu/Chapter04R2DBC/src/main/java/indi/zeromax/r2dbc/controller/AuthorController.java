package indi.zeromax.r2dbc.controller;

import indi.zeromax.r2dbc.entity.TAuthor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/1/14 17:52
 */
@RestController
public class AuthorController {
    @GetMapping("/author")
    public Flux<TAuthor> getAllAuthor() {
        return null;
    }
}
