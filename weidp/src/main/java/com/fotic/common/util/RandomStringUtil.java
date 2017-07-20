package com.fotic.common.util;

import java.util.Random;

/**
 * 生成随机字符串
 * @author zhaoqh
 */
public class RandomStringUtil {
	
	/**
	 * 生成N位的随机字符串
	 * @param length	位数
	 * @return
	 */
	public static String getString(int length) {

		char[] charArray = new char[length];

		for (int i = 0; i < length; i++) {

			Random r = new Random();
			int n = r.nextInt(123);
			while (n < 48 || (n > 57 && n < 65) || (n > 90 && n < 97) || n > 122) {
				n = r.nextInt(123);
			}
			charArray[i] = (char) n;
		}

		return String.valueOf(charArray);

	}
	
	public static void main(String[] args) {
		System.out.println(getString(6));
	}
}
