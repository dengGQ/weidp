package com.iss.framework.web.page;

import javax.servlet.FilterChain;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.SimplePrincipalCollection;
import org.apache.shiro.subject.Subject.Builder;
import org.apache.shiro.util.ThreadContext;
import org.apache.shiro.web.subject.WebSubject;

import com.hhr.auth.entity.LoginUser;
import com.hhr.common.util.SessionUtil;

import edu.yale.its.tp.cas.client.IContextInit;

/**
 * 单点登录, 单点服务器回调接口
 * @author zhaoqh
 */
public class SSOInitContext  implements IContextInit {

	/**
	 * 可以用作用户转换
	 * 如:注释中的代码
	 */
	public String getTranslatorUser(String userId) {
	/*	if ("sysadmin".equals(userId)) {
			userId = "admin";
		}*/
		return userId;
	}

	public void initContext(ServletRequest request, ServletResponse response,
			FilterChain fc, String userId) {
		HttpServletRequest servletRequest = (HttpServletRequest) request;
		LoginUser user = new LoginUser();
		user.setId(userId);
		user.setUsercode(userId);
		
		if (user != null) {
			//使用无密码验证shiro
			PrincipalCollection principals = new SimplePrincipalCollection( userId, "ssoRealm");  
			Builder builder = new WebSubject.Builder(request,  response);  
			builder.principals(principals);  
			builder.authenticated(true);  
			WebSubject subject = (WebSubject) builder.buildSubject();  
			ThreadContext.bind(subject);  
			subject.getSession().setAttribute("user", user);
			SessionUtil.saveUserToSession(servletRequest.getSession(), user);
		}
	}

}
