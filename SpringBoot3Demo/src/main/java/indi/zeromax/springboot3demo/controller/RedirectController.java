package indi.zeromax.springboot3demo.controller;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

/**
 * @author zhuxi
 * @apiNote
 * @implNote
 * @since 2023/3/14 14:29
 */
@Controller
public class RedirectController {
    @GetMapping("getA")
    @ResponseBody
    @CrossOrigin
    public String getA(){
        return "a";
    }

    @GetMapping("getBToA301")
    public ModelAndView getBToA_301(){
        RedirectView redirectView=new RedirectView("/getA");
        redirectView.setStatusCode(HttpStatus.MOVED_PERMANENTLY);
        ModelAndView view=new ModelAndView();
        view.setView(redirectView);
        return view;
    }

    @GetMapping("getBToA302")
    public ModelAndView getBToA_302(){
        RedirectView redirectView=new RedirectView("/getA");
        redirectView.setStatusCode(HttpStatus.FOUND);
        ModelAndView view=new ModelAndView();
        view.setView(redirectView);
        return view;
    }
}
