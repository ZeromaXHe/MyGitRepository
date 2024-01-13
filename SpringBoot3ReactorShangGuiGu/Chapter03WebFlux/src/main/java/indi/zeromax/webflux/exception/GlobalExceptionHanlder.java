package indi.zeromax.webflux.exception;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * @author ZeromaXHe
 * @apiNote
 * @implNote
 * @since 2024/1/13 22:18
 */
@RestControllerAdvice
public class GlobalExceptionHanlder {
    @ExceptionHandler(ArithmeticException.class)
    public String error(ArithmeticException exception) {
        System.out.println("发生了数学运算异常：" + exception.getMessage());
        return "炸了...哈哈";
    }
}
