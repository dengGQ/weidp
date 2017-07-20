package com.fotic.auth.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fotic.auth.dao.LoginUserMapper;
import com.fotic.auth.entity.LoginUser;
import com.fotic.auth.service.ILoginUserService;
import com.fotic.common.util.PubMethod;
import tk.mybatis.mapper.entity.Example;
import tk.mybatis.mapper.entity.Example.Criteria;
@Service
public class LoginUserServiceImpl implements ILoginUserService {
	@Autowired
	private LoginUserMapper loginUserMapper;
	@Override
	public LoginUser getByUserNameAndPassword(String username, String password) {
		Example example = new Example(LoginUser.class);
		Criteria  criteria = example.createCriteria();
		if(!PubMethod.isEmpty(username)&&!PubMethod.isEmpty(password)){
			criteria.andEqualTo("username", username);
			criteria.andEqualTo("password", password);
			List<LoginUser> selectByExample = loginUserMapper.selectByExample(example);
			if(!PubMethod.isEmpty(selectByExample)){
				return selectByExample.get(0);
			}else {
				return null;
			}
		}
		return null;

	}

}
