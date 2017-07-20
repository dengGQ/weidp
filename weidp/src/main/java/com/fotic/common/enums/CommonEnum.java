package com.fotic.common.enums;

/**
 * 公共枚举类
 * @author zhaoqh
 *
 */
public class CommonEnum {
	
	/**
	 * 成功失败状态枚举
	 * @author zhaoqh
	 */
	public enum StatusEnum{
		 /**
		  * 成功
		  */
		 SUCCESS(1),
		 /**
		  * 失败
		  */
	     FAIL(0);
	     private int status;
	     private StatusEnum(int status){
	    	 this.status = status;
	     }
	     public int getStatus(){
	    	 return this.status;
	     }
	}
}
