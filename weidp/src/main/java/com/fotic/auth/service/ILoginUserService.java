package com.fotic.auth.service;
import com.fotic.auth.entity.LoginUser;

public interface ILoginUserService {
	LoginUser getByUserNameAndPassword(String username,String password);
}
