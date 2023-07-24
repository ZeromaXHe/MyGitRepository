package indi.zeromax.springboot3demo.controller;

import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2023/7/24 17:23
 */
@Controller
public class ShortUrlController {
    private final Logger logger = LoggerFactory.getLogger(ShortUrlController.class);

    // 模拟数据库
    private Map<String, String> sToLMap = new HashMap<>();
    private Map<String, String> lToSMap = new HashMap<>();

    @GetMapping("shorten")
    @ResponseBody
    public String shorten(@RequestParam String url) {
        // http://localhost:8080/shorten?url=localhost%3A8080%2FgetA
        logger.info("shorten url:{}", url);
        String shortenUrl;
        if (lToSMap.containsKey(url)) {
            shortenUrl = lToSMap.get(url);
        } else {
            int id = sToLMap.size();
            shortenUrl = base62hash(id);
            sToLMap.put(shortenUrl, url);
            lToSMap.put(url, shortenUrl);
        }
        logger.info("shorten sUrl:{}", shortenUrl);
        return shortenUrl;
    }

    private String base62hash(int id) {
        if (id == 0) {
            return "0";
        }
        StringBuilder sb = new StringBuilder();
        while (id > 0) {
            int idx = id % 62;
            if (idx < 10) {
                sb.append(idx);
            } else if (idx < 36) {
                sb.append((char) ('a' + (idx - 10)));
            } else {
                sb.append((char) ('A' + (idx - 36)));
            }
            id /= 62;
        }
        return sb.toString();
    }

    @GetMapping("v/{shortenUrl}")
    public ModelAndView redirectVisit(@PathVariable String shortenUrl) {
        logger.info("redirectVisit shortenUrl:{}", shortenUrl);
        if (sToLMap.containsKey(shortenUrl)) {
            String redirectUrl = sToLMap.get(shortenUrl);
            if (redirectUrl.startsWith("localhost:8080")) {
                redirectUrl = redirectUrl.substring(14);
            }
            logger.info("redirectVisit redirectUrl:{}", redirectUrl);
            // 302 重定向
            RedirectView redirectView = new RedirectView(redirectUrl);
            redirectView.setStatusCode(HttpStatus.FOUND);
            ModelAndView view = new ModelAndView();
            view.setView(redirectView);
            return view;
        } else {
            throw new RuntimeException("failed to find");
        }
    }

    @GetMapping("r/{shortenUrl}")
    public void redirectVisitByResp(@PathVariable String shortenUrl, HttpServletResponse response) throws IOException {
        logger.info("redirectVisitByResp shortenUrl:{}", shortenUrl);
        if (sToLMap.containsKey(shortenUrl)) {
            String redirectUrl = sToLMap.get(shortenUrl);
            if (redirectUrl.startsWith("http://") || redirectUrl.startsWith("https://")) {
                redirectUrl = "http://" + redirectUrl;
            }
            logger.info("redirectVisitByResp redirectUrl:{}", redirectUrl);
            // 302 重定向
            response.sendRedirect(redirectUrl);
        } else {
            logger.info("redirectVisitByResp shortenUrl:{}", shortenUrl);
        }
    }
}
