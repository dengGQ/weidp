package com.hhr.auth.controller;
import javax.servlet.http.HttpServletRequest;  
import javax.servlet.http.HttpServletResponse;  
import org.apache.shiro.SecurityUtils;  
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;  
import org.slf4j.Logger;  
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;  
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hhr.auth.entity.LoginUser;
import com.hhr.auth.service.ILoginUserService;
import com.hhr.common.util.SessionUtil;  

@Controller  
public class UserLoginController {  
    private static Logger logger = LoggerFactory.getLogger(UserLoginController.class);  
    @Autowired
	private ILoginUserService iLoginUserService;
   
    /** 
     * 初始登陆界面 
     * @param request 
     * @return 
     */  
	@RequestMapping(value = { "login" })
    public String tologin(HttpServletRequest request, HttpServletResponse response, Model model){  
        logger.info("来自IP[" + request.getRemoteHost() + "]的访问");  
        LoginUser user = SessionUtil.getUserFromHttpRequest(request);
        if(user!=null){
        	return "index";
        }
        return "login";  
    }  
	
	@RequestMapping(value = { "demoboottable" })
    public String demoboottable(HttpServletRequest request, HttpServletResponse response, Model model){  
        logger.info("来自IP[" + request.getRemoteHost() + "]的访问");  
        return "bootstraptable";  
    }  
	
	@RequestMapping(value = { "index" })
    public String index(HttpServletRequest request, HttpServletResponse response, Model model){  
        logger.info("来自IP[" + request.getRemoteHost() + "]的访问");  
        return "index";  
    }  
      
    /** 
     * 验证用户名和密码 
     * @param request 
     * @return 
     */
    @RequestMapping(value = { "checkLogin" }) 
    public String login(HttpServletRequest request,ModelMap map) {  
        String result = "login";  
        // 取得用户名  
        String username = request.getParameter("username");  
        //取得 密码，并用MD5加密  
        String password = request.getParameter("password");  
 
        UsernamePasswordToken token = new UsernamePasswordToken(username, password);  
        //这里去找realm认证信息  
        Subject currentUser = SecurityUtils.getSubject(); 
        currentUser.isPermitted("url");
        try {  
            if (!currentUser.isAuthenticated()){//使用shiro来验证  
                //token.setRememberMe(true);  
                currentUser.login(token);//验证角色和权限
                /**
                 * 设置user到容器session
                 */
                LoginUser user = iLoginUserService.getByUserNameAndPassword(username,password);
                SessionUtil.saveUserToSession(request.getSession(), user);
            } 
            result = "redirect:index";//验证成功  
        } catch (Exception e) {  
            logger.error(e.getMessage()); 
            map.put("message", e.getMessage());
            result = "login";//验证失败  
        }  
        return result;  
    }  
    
    /** 
     * 退出 
     * @return 
     */  
    @RequestMapping(value = "logout")     
    public String logout() {    
        Subject currentUser = SecurityUtils.getSubject();    
        String result = "redirect:login";    
        currentUser.logout();    
        return result;    
    }    
    
    
       
} 