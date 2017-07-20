/*
 * 时间格式化工具 把Long类型的yyyy-MM-dd日期还原yyyy-MM-dd格式日期
 * 支持格式化成yyyyMMdd
 */
function dateFormatUtil(longTypeDate, pattern) {
	if (!longTypeDate||longTypeDate == null || longTypeDate == undefined || longTypeDate == '') {
		return ""
	}
	if (( longTypeDate+'').split('-').length >= 2) {
		if(!!pattern && pattern=='yyyyMMdd'){
			longTypeDate = ( longTypeDate+'').replace(new RegExp('-',"gm"),'');
		}
		return longTypeDate;
	}
	
		
	var dateTypeDate = "";
	var date = new Date();
	date.setTime(longTypeDate);
	dateTypeDate += date.getFullYear(); // 年
	dateTypeDate += "-" + getMonth(date); // 月
	dateTypeDate += "-" + getDay(date); // 日
	
	if(!!pattern && pattern=='yyyyMMdd'){
		dateTypeDate = dateTypeDate.replace(new RegExp('-',"gm"),'');
	}
	return dateTypeDate;
}

 
 

// 返回 01-12 的月份值
function getMonth(date) {
	var month = "";
	month = date.getMonth() + 1; // getMonth()得到的月份是0-11
	if (month < 10) {
		month = "0" + month;
	}
	return month;
}

// 返回01-30的日期
function getDay(date) {
	var day = "";
	day = date.getDate();
	if (day < 10) {
		day = "0" + day;
	}
	return day;
}
