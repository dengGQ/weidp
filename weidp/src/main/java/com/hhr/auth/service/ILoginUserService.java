package com.hhr.auth.service;
import com.hhr.auth.entity.LoginUser;

public interface ILoginUserService {
	LoginUser getByUserNameAndPassword(String username,String password);
}
