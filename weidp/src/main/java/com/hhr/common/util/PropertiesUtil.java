package com.hhr.common.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import com.hhr.common.exception.FTPClientException;

/**
 * properties文件工具类
 * @author zhaoqh
 */
public class PropertiesUtil {
	private static Properties properties = new Properties();
	
	static{
		//加载配置文件
		loadConfig("/conf/ftpConfig.properties");
		loadConfig("/conf/dsConfig.properties");
	}
	
	/**
	 * 加载配置文件
	 * @param fileName
	 */
	private static void loadConfig(String fileName) {
		InputStream in =  PropertiesUtil.class.getResourceAsStream(fileName);
		try {
			properties.load(in);
		} catch (IOException e) {
			new FTPClientException("加载配置文件出错", e);
		}
	}
	
	/**
	 * 根据key获取配置文件value
	 * @param key
	 * @return
	 */
	public static String get(String key){
		return properties.getProperty(key);
	}
	
	
}
