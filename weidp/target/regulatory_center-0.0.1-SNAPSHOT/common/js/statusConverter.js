/**
 * 把校验编码转换成对于的中文含义
 * @param code 编码
 */
function getValidateStatus(code) {
	var value = "未知";
	 if(code==0){
		 value = "未校验";
	 }else if(code==1){
		 value = "通过";
	 }else if(code==2){
		 value = "未通过";
	 }
	 return value;
}

/**
 * 数据来源
 * @param code 编码
 * @returns
 */
function getDataSrc(code){
	var value = "未知";
	
	 if(code==1){
		 value = "信贷";
	 }else {
		 value = "CSV";
	 }
	 return value;
}

/**
 * 检查目标类型
 * @param type 类型
 * @returns
 */
function getCheckType(type){
	var value = "未知";
	if(type==1){
		value = "交易信息";
	}else if(value==2){
		value = "客户信息";
	}else if(value==3){
		value = "特殊交易信息";
	}
	return value;
}

function getCredType(type){
	var value = "未知";
	if(type==0){
		value = "身份证";
	}else if(value==1){
		value = "户口簿";
	}else if(value==2){
		value = "护照";
	}else if(value==3){
		value = "军官证";
	}else if(value==4){
		value = "士兵证";
	}else if(value==5){
		value = "港澳居民来往内地通行证";
	}else if(value==6){
		value = "台湾同胞来往内地通行证";
	}else if(value==7){
		value = "临时身份证";
	}else if(value==8){
		value = "外国人居留证";
	}else if(value==9){
		value = "警官证";
	}else if(value=="X"){
		value = "其他证件";
	}
	return value;
}


 
 
 