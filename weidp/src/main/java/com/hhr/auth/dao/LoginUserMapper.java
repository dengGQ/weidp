package com.hhr.auth.dao;
import com.hhr.auth.entity.LoginUser;

import tk.mybatis.mapper.common.Mapper;
public interface LoginUserMapper extends Mapper<LoginUser> {
/*	@Select(value="SELECT * FROM T_LOGINUSER WHERE username = #{username} and password=#{password}")
	LoginUser getByUserNameAndPassword(@Param(value="username")String username,@Param(value="password")String password);*/
}
