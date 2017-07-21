package com.hhr.common.util;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hhr.auth.entity.LoginUser;
public class SessionUtil {

	public static final String USER = "user";

	/**
	 * 设置用户到session
	 * @param session
	 * @param user
	 */
	public static void saveUserToSession(HttpSession session, LoginUser user) {
		session.setAttribute(USER, user);
	}

	/**
	 * 从Session获取当前用户信息
	 * @param session
	 * @return
	 */
	public static LoginUser getUserFromSession(HttpSession session) {
		Object attribute = session.getAttribute(USER);
		return attribute == null ? null : (LoginUser) attribute;
	}
	
	public static LoginUser getUserFromHttpRequest(HttpServletRequest request) {
		if(!PubMethod.isEmpty(request)){
			if(!PubMethod.isEmpty(request.getSession())){
				Object attribute = request.getSession().getAttribute(USER);
				return attribute == null ? null : (LoginUser) attribute;
			}else{
				return null;
			}
		}else{
			return null;
		}
	}


}