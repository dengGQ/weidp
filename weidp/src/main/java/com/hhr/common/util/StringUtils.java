package com.hhr.common.util;

/**
 * 字符串工具类
 * @author zhaoqh
 */
public class StringUtils extends org.apache.commons.lang3.StringUtils{
	
	/**
	 * object 转 int
	 * @param obj	对象
	 * @param defaultVal 默认值
	 * @return 数值
	 */
	public static int objToInt(Object obj, int defaultVal){
		if(obj == null) return defaultVal;
		return Integer.valueOf(obj.toString());
	}
	
	/**
	 * object 转 String
	 * @param obj	对象
	 * @param defaultVal 默认值
	 * @return 字符串
	 */
	public static String objToString(Object obj, String defaultVal){
		if(obj == null) return defaultVal;
		return obj.toString();
	}
	
	/**
	 * object 转 boolean
	 * @param obj	对象
	 * @param defaultVal 默认值
	 * @return 布尔值
	 */
	public static boolean objToBoolean(Object obj, boolean defaultVal){
		if(obj == null) return defaultVal;
		return Boolean.valueOf(obj.toString());
	}
	
	/**
	 * object 转 byte
	 * @param obj	对象
	 * @param defaultVal 默认值
	 * @return 字节
	 */
	public static byte objToByte(Object obj, byte defaultVal){
		if(obj == null) return defaultVal;
		return Byte.valueOf(obj.toString());
	}
}
