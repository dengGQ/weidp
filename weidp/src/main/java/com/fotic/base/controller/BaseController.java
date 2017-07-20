package com.fotic.base.controller;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;

import oracle.jdbc.OracleTypes;

@Controller
public class BaseController {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	/*public PageInfo<T> setPageInfo(){
		
	}*/

	/**
	 * 执行无返回参数的存储过程
	 * 
	 * @param procedureName
	 * @param params
	 *            输入参数（列表）
	 * @return
	 */
	public boolean procedureInvoke(String procedureName, String... params) {
		boolean flag = true;
		// sql语句
		StringBuffer sql = new StringBuffer();
		sql.append("call ").append(procedureName).append("(");
		// 拼接存储过程参数
		if (params != null && params.length > 0) {
			// 参数
			StringBuffer param = new StringBuffer();
			for (String str : params) {
				param.append(",").append(str);
			}
			sql.append(param.substring(1));
		}
		sql.append(")");
		try {
			jdbcTemplate.execute(sql.toString());
		} catch (Exception e) {
			flag = false;
			e.printStackTrace();
		}
		return flag;
	}

	/**
	 * 执行有返回值的存储过程,返回参数固定为一个，参数类型为varchar，格式为json字符串格式
	 * @param procedureName
	 * @param params
	 * @return
	 */
	public String procedureInvokeRetString(String procedureName, String... params) {
		StringBuffer sql = new StringBuffer();
		sql.append("{call ").append(procedureName).append("(");
		int len = 0;
		// 拼接存储过程参数的占位符
		if (params != null && params.length > 0) {
			len = params.length;
			StringBuffer param = new StringBuffer();
			for (int i = 0; i < len; i++) {
				param.append(",").append("?");// 入参占位符
			}
			param.append(",?");// 增加一个出参的占位符
			sql.append(param.substring(1));
		}
		sql.append(")}");

		CallableStatementCreator statement = new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection con) throws SQLException {
				CallableStatement cs = con.prepareCall(sql.toString());
				// 参数占位符位置
				int i = 1;
				for (String p : params) {
					cs.setString(i, p);// 设置输入参数的值
					i++;
				}
				cs.registerOutParameter(i, OracleTypes.VARCHAR);// 注册输出参数的类型
				return cs;
			}
		};

		// 出参所在位置
		final int outParamIndex = ++len;
		CallableStatementCallback<?> callback = new CallableStatementCallback<Object>() {
			public Object doInCallableStatement(CallableStatement cs) throws SQLException, DataAccessException {
				cs.execute();
				return cs.getString(outParamIndex);// 获取输出参数的值
			}
		};
		String outParamVal = (String) jdbcTemplate.execute(statement, callback);
		return "{"+outParamVal+"}";
	}
}
