package com.hhr.auth.realm;
import java.util.HashSet;
import java.util.Set;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.cache.Cache;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.SimplePrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;

import com.hhr.auth.entity.LoginUser;
import com.hhr.auth.service.ILoginUserService;
import com.hhr.common.util.PubMethod;

public class LoginRealm extends AuthorizingRealm {
	@Autowired
	private ILoginUserService iLoginUserService;

	public LoginRealm() {
		super();
	}

	/**
	 * 验证登陆
	 */
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authcToken)
			throws AuthenticationException {
		UsernamePasswordToken token = (UsernamePasswordToken) authcToken;
		String password = "";
		if(!PubMethod.isEmpty(token.getCredentials())){
			password = new String((char[])token.getCredentials());
		}else {
			throw new AuthenticationException("用户名或密码输入错误，请从新输入");
		}
		if(PubMethod.isEmpty(token.getUsername())){
			throw new AuthenticationException("用户名或密码输入错误，请从新输入");
		}
		LoginUser user = iLoginUserService.getByUserNameAndPassword(token.getUsername(),password);
		//CipherUtil cipher = new CipherUtil();// MD5加密
		if (null!=user) {
			SimpleAuthenticationInfo siminfo = new SimpleAuthenticationInfo(user.getUsername(), user.getPassword(), getName());
			return siminfo;
		} else {
			throw new AuthenticationException("用户名或密码输入错误，请从新输入");
		}
	}

	/**
	 * 登陆成功之后，进行角色和权限验证
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		/* 这里应该根据userName使用role和permission 的serive层来做判断，并将对应 的权限加进来，下面简化了这一步 */
		Set<String> roleNames = new HashSet<String>();
		Set<String> permissions = new HashSet<String>();
		roleNames.add("admin");// 添加角色。对应到index.jsp
		roleNames.add("administrator");
		permissions.add("create");// 添加权限,对应到index.jsp
		permissions.add("login.do?main");
		permissions.add("login.do?logout");
		SimpleAuthorizationInfo info = new SimpleAuthorizationInfo(roleNames);
		info.setStringPermissions(permissions);
		return info;
	}

	/**
	 * 清除所有用户授权信息缓存.
	 */
	public void clearCachedAuthorizationInfo(String principal) {
		SimplePrincipalCollection principals = new SimplePrincipalCollection(principal, getName());
		clearCachedAuthorizationInfo(principals);
	}

	/**
	 * 清除所有用户授权信息缓存.
	 */
	public void clearAllCachedAuthorizationInfo() {
		Cache<Object, AuthorizationInfo> cache = getAuthorizationCache();
		if (cache != null) {
			for (Object key : cache.keys()) {
				cache.remove(key);
			}
		}
	}

}