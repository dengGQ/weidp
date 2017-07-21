package com.hhr.common.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.persistence.Id;
import org.springframework.beans.BeansException;
/**
 * 
* @Title: PubMethod.java 
* @Package com.fotic.common.util 
* @Description: 工具方法   字符串操作 空值判断  日期操作 生成ID 
* @author 王明月   
* @date 2017年6月8日 下午5:15:56
 */
public class PubMethod {

	/**
	 * po对象的拷贝 （注：相同名字的属性其类型须一致；且属性的类型最好不是原始类型，类似int.long，最好使用Integer.Long ...）
	 * 
	 * @author peixiuyue
	 * @param srcObj
	 * @param desObj
	 * @param copyPropertyArr
	 *            指定需要拷贝的属性的名称集合，为空表示不限制
	 * @return
	 */
	public static void copyPersistantObject(Object srcObj, Object desObj, String[] copyPropertyArr) {
		if (isEmpty(srcObj) || isEmpty(desObj)) {
			System.err.println("NullPointerException at PubMethod.copyPersistantObject\n...........");
			// throw new NullPointerException();
		}
		Method[] method = srcObj.getClass().getDeclaredMethods();
		for (int index = 0; index < method.length; index++) {
			// PubMethod.toPrint("method[index].getName():"+method[index].getName());
			String methodName = method[index].getName();
			methodName = (methodName == null) ? "" : methodName.trim();
			if (methodName.startsWith("get") && hasMethodByName(desObj, methodName)) {
				String fieldName = methodName.substring(3);// cut 'get'
				String fieldRealName = fieldName.substring(0, 1).toLowerCase() + fieldName.substring(1);
				if (copyPropertyArr == null || copyPropertyArr.length == 0 || !isInArray(fieldRealName, copyPropertyArr)) {
					continue;
				}
				Method desMethod = getMethodByName(desObj, "set" + fieldName);
				Object val = null;
				try {
					val = method[index].invoke(srcObj, null);
					if (val == null)// || "".equals(val.toString().trim()))
					{
						continue;
					}
					desMethod.invoke(desObj, new Object[] { val });
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * hibernate使用select投影相应的字段后，仍然返回entity列表
	 * 
	 * @author peixiuyue
	 * @param dataList
	 * @param entityClass
	 * @param fields
	 * @return
	 */
	public static List convertToEntity(List dataList, Class entityClass, String[] fields) {
		if (PubMethod.isEmpty(dataList) || !(dataList.get(0) instanceof Object[])) {
			return dataList;
		}
		List resList = new ArrayList();
		try {
			Object entity = entityClass.newInstance();
		} catch (Exception e) {
			e.printStackTrace();
			return dataList;
		}
		for (Object data : dataList) {
			Object[] realDataArr = (Object[]) data;
			Object entity = null;
			try {
				entity = entityClass.newInstance();
			} catch (Exception e) {
				continue;
			}
			for (int i = 0; i < realDataArr.length; i++) {
				if (realDataArr[i] == null) {
					continue;
				}
				String fieldName = upperCaseFirstLetter(fields[i]);
				Method setMethod = getMethodByName(entity, "set" + fieldName);
				try {
					setMethod.invoke(entity, new Object[] { realDataArr[i] });
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			}
			resList.add(entity);
		}

		return resList;
	}

	/**
	 * 判断两对象的值是否不相等
	 * 
	 * @param oldOne
	 * @param newOne
	 * @return true 不相等；false 相等
	 */
	public static boolean isNotEquals(Object oldOne, Object newOne) {
		if (oldOne == null && newOne == null) {
			return false;
		} else if (oldOne == null && newOne != null) {
			return true;
		} else if (oldOne != null && newOne == null) {
			return true;
		}

		if (oldOne instanceof String) {
			if (((String) oldOne).equals((String) newOne)) {
				return false;
			}
		} else if (oldOne instanceof Long) {
			if (((Long) oldOne).longValue() == ((Long) newOne).longValue()) {
				return false;
			}
		} else if (oldOne instanceof Double) {
			if (((Double) oldOne).doubleValue() == ((Double) newOne).doubleValue()) {
				return false;
			}
		} else if (oldOne instanceof Integer) {
			if (((Integer) oldOne).intValue() == ((Integer) newOne).intValue()) {
				return false;
			}
		}

		return true;
	}

	/**
	 * 首字母大写
	 * 
	 * @param str
	 * @return
	 */
	public static String upperCaseFirstLetter(String str) {
		if (PubMethod.isEmpty(str)) {
			return "";
		}
		return str.substring(0, 1).toUpperCase() + str.substring(1);
	}

	public static String getValueNoNull(Object obj) {
		if (obj == null) {
			return "";
		} else {
			return obj.toString();
		}
	}

	public static String getJsonValueForObj(Object obj) {
		if (obj == null) {
			return "{}";
		} else {
			return obj.toString();
		}
	}
	
	public static String getJsonValueForArr(Object obj) {
		if (obj == null) {
			return "[]";
		} else {
			return obj.toString();
		}
	}

	/**
	 * 获得异常的详细信息
	 * 
	 * @param e
	 * @return
	 */
	public static String getStackTraceString(Exception e) {
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		e.printStackTrace(pw);

		return sw.getBuffer().toString();
	}

	/**
	 * 检查类中是否有指定的方法名
	 * 
	 * @author peixiuyue
	 * @param obj
	 * @param methodName
	 * @return
	 */
	public static boolean hasMethodByName(Object obj, String methodName) {
		boolean hasMethod = false;
		methodName = (methodName == null) ? "" : methodName.trim();
		if (isEmpty(obj) || isEmpty(methodName)) {
			return hasMethod;
		}

		Method[] method = obj.getClass().getDeclaredMethods();
		for (int index = 0; index < method.length; index++) {
			// PubMethod.toPrint("method[index].getName():"+method[index].getName());
			String tmpMethodName = method[index].getName();
			tmpMethodName = (tmpMethodName == null) ? "" : tmpMethodName.trim();
			if (tmpMethodName.equals(methodName)) {
				hasMethod = true;
				break;
			}
		}
		return hasMethod;
	}

	/**
	 * 通过指定的方法名找到Method
	 * 
	 * @author peixiuyue
	 * @param obj
	 * @param methodName
	 * @return
	 */
	public static Method getMethodByName(Object obj, String methodName) {
		Method resMethod = null;
		methodName = (methodName == null) ? "" : methodName.trim();
		if (isEmpty(obj) || isEmpty(methodName)) {
			return resMethod;
		}

		Method[] method = obj.getClass().getDeclaredMethods();
		for (int index = 0; index < method.length; index++) {
			// PubMethod.toPrint("method[index].getName():"+method[index].getName());
			String tmpMethodName = method[index].getName();
			tmpMethodName = (tmpMethodName == null) ? "" : tmpMethodName.trim();
			if (tmpMethodName.equals(methodName)) {
				resMethod = method[index];
				break;
			}
		}
		return resMethod;
	}

	/**
	 * 执行对象中指定的方法名
	 * 
	 * @param obj
	 * @param methodName
	 * @return
	 */
	public static Object execMethod(Object obj, String methodName) {
		Method method = getMethodByName(obj, methodName);
		Object val = null;
		try {
			val = method.invoke(obj, null);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		return val;
	}

	/**
	 * 返回hibernate entity的主键值
	 * 
	 * @param entityObj
	 * @return
	 */
	public static Object getIdValue(Object entityObj) {
		if (entityObj == null)
			return null;
		Object idValue = null;
		/*
		 * List<Field> fields = new ArrayList<Field>();
		 * if("BaseEntity".equals(entityObj
		 * .getClass().getSuperclass().getSimpleName())) {
		 * addArrayToList(fields,
		 * entityObj.getClass().getSuperclass().getDeclaredFields()); }
		 * addArrayToList(fields, entityObj.getClass().getDeclaredFields());
		 */

		Field[] fields = entityObj.getClass().getDeclaredFields();

		for (Field field : fields) {
			String fieldName = field.getName();
			if (field.isAnnotationPresent(Id.class)) {
				idValue = PubMethod.execMethod(entityObj, "get" + fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1));
				return idValue;
			}
		}
		return null;
	}

	public static void addArrayToList(List<Object> list, Object[] array) {
		for (Object obj : array) {
			list.add(obj);
		}
	}

	/**
	 * 拼写sql 中 in 语句后的串
	 * 
	 * @param values
	 * @return
	 */
	public static String getSqlInString(String[] values) {
		if (isEmpty(values))
			return "";
		StringBuffer res = new StringBuffer("(");
		int firstFlag = 1;
		for (String val : values) {
			if (firstFlag == 1) {
				res.append("'").append(val.trim()).append("'");
				firstFlag = 0;
			} else {
				res.append(",'").append(val.trim()).append("'");
			}
		}
		res.append(")");
		return res.toString();
	}

	/**
	 * 拼写sql 中 in 语句后的串
	 * 
	 * @param values
	 * @return
	 */
	public static String getSqlInString(List<String> values) {
		if (isEmpty(values))
			return "";
		StringBuffer res = new StringBuffer("(");
		int firstFlag = 1;
		for (String val : values) {
			if (firstFlag == 1) {
				res.append("'").append(val).append("'");
				firstFlag = 0;
			} else {
				res.append(",'").append(val).append("'");
			}
		}
		res.append(")");
		return res.toString();
	}

	/**
	 * 拼写sql 中 in 语句后的串
	 * 
	 * @param values
	 * @return
	 */
	public static String getSqlInStr(List<Long> values) {
		if (isEmpty(values))
			return "";
		StringBuffer res = new StringBuffer("(");
		int firstFlag = 1;
		for (Long val : values) {
			if (firstFlag == 1) {
				res.append(val);
				firstFlag = 0;
			} else {
				res.append(",").append(val);
			}
		}
		res.append(")");
		return res.toString();
	}

	/**
	 * 获取当前的日期和时间，格式为yyyy-MM-dd HH:mm:ss
	 * 
	 * @return
	 */
	public static String getDateTime() {
		String strCurrentDateTime = "";
		Date currentDateTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		strCurrentDateTime = formatter.format(currentDateTime);
		return strCurrentDateTime;
	}

	/**
	 * 获取当前的日期的前一天和时间，格式为yyyy-MM-dd HH:mm:ss
	 * 
	 * @return
	 */
	public static String getDateTimeBeforeDay() {
		Calendar caldate = Calendar.getInstance();
		String strCurrentDateTime = "";
		caldate.add(Calendar.DAY_OF_MONTH, -1);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		strCurrentDateTime = formatter.format(caldate.getTime());
		return strCurrentDateTime;
	}

	/**
	 * 获取当前年月日组成的字符串，格式为yyyyMMdd
	 * 
	 * @return
	 */
	public static String getYMD() {
		String strYMD = "";
		Date currentDateTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		strYMD = formatter.format(currentDateTime);
		return strYMD;
	}

	/**
	 * 获取当前年月日组成的字符串，格式为yyyy-MM-dd
	 * 
	 * @return
	 */
	public static String getDay() {
		String strYMD = "";
		Date currentDateTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		strYMD = formatter.format(currentDateTime);
		return strYMD;
	}

	/**
	 * 获取当前年月日组成的字符串，格式为yyyy-MM-dd
	 * 
	 * @return
	 */
	public static String getDayBeforeMonth() {
		String strYMD = "";
		Date currentDateTime = new Date();// 得到当前系统时间
		Calendar calendar = Calendar.getInstance();// 日历对象
		calendar.setTime(currentDateTime);// 设置当前日期
		calendar.add(Calendar.MONTH, -1);// 月份减一
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		return formatter.format(calendar.getTime());
	}

	/**
	 * 获取当前年字符串，格式为yyyy
	 * 
	 * @return
	 */
	public static String getYear() {
		String strYMD = "";
		Date currentDateTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy");
		strYMD = formatter.format(currentDateTime);
		return strYMD;
	}

	/**
	 * 获取当前年月日时分秒组成的字符串，格式为yyyyMMddHHmmss
	 * 
	 * @return
	 */
	public static String getYMDHMS() {
		String strYMDHMS = "";
		Date currentDateTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		strYMDHMS = formatter.format(currentDateTime);
		return strYMDHMS;
	}

	/**
	 * 获取当前年月日时分秒毫秒组成的字符串，格式为yyyyMMddHHmmssSSS
	 * 
	 * @return
	 */
	public static String getYMDHMSS() {
		String strYMDHMSS = "";
		Date currentDateTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		strYMDHMSS = formatter.format(currentDateTime);
		return strYMDHMSS;
	}

	// ***************************************************
	// 名称：dateToStr
	// 功能：将指定的日期转换成字符串
	// 输入：aDteValue: 要转换的日期;
	// aFmtDate: 转换日期的格式, 默认为:"yyyy/MM/dd"
	// 输出：
	// 返回：转换之后的字符串
	// ***************************************************
	public static String dateToStr(java.util.Date aDteValue, String aFmtDate) {
		String strRtn = null;

		if (aDteValue == null) {
			return "";
		}
		if (aFmtDate.length() == 0) {
			aFmtDate = "yyyy-MM-dd";
		}
		Format fmtDate = new SimpleDateFormat(aFmtDate);
		try {
			strRtn = fmtDate.format(aDteValue);
		} catch (Exception e) {

		}

		return (strRtn);
	}

	// ***************************************************
	// 名称：dateTimeToStr
	// 功能：将指定的日期转换成字符串
	// 输入：aDteValue: 要转换的日期;
	// aFmtDate: 转换日期的格式, 默认为:"yyyy/MM/dd"
	// 输出：
	// 返回：转换之后的字符串
	// ***************************************************
	public static String dateTimeToStr(java.util.Date aDteValue, String aFmtDate) {
		String strRtn = null;

		if (aDteValue == null) {
			return "";
		}
		if (aFmtDate.length() == 0) {
			aFmtDate = "yyyy-MM-dd HH:mm";
		}
		Format fmtDate = new SimpleDateFormat(aFmtDate);
		try {
			strRtn = fmtDate.format(aDteValue);
		} catch (Exception e) {

		}

		return (strRtn);
	}

	/*
	 * 对象间值的相互拷贝.
	 */
	public static void copyPropeties(Object srcObj, Object destObj) {
		if (srcObj == null || destObj == null)
			return;
		try {
			org.springframework.beans.BeanUtils.copyProperties(srcObj, destObj);
		} catch (BeansException e) {
			e.printStackTrace();
		}
	}

	// 判断是否为空。
	public static boolean isEmpty(String Value) {
		return (Value == null || Value.trim().equals("") || Value.trim().equals("null") || Value.trim().equals("[]"));
	}

	public static boolean isEmpty(StringBuffer Value) {

		return (Value == null || (Value.toString().trim()).equals(""));
	}

	/*
	 * @function:判空 @author:
	 */
	public static boolean isEmpty(List<?> list) {
		if (list == null || list.size() == 0)
			return true;
		else
			return false;
	}

	/*
	 * @function:判空 @author:
	 */
	public static boolean isEmpty(Set<?> set) {
		if (set == null || set.size() == 0)
			return true;
		else
			return false;
	}

	/*
	 * @function:判空
	 */
	public static boolean isEmpty(Map<?, ?> map) {
		if (map == null || map.size() == 0)
			return true;
		else
			return false;
	}

	// 判断是否为空。
	public static boolean isEmpty(Object Value) {
		if (Value == null)
			return true;
		else
			return false;
	}

	public static boolean isEmpty(Double value) {
		if (value == null || value.doubleValue() == 0.0)
			return true;
		else
			return false;
	}

	// 判断是否为空。
	public static boolean isEmpty(Long obj) {
		if (obj == null || obj.longValue() == 0)
			return true;
		else
			return false;
	}

	// 判断是否为空。
	public static boolean isEmpty(Object[] Value) {
		if (Value == null || Value.length == 0)
			return true;
		else
			return false;
	}

	/*
	 * 按要求分割字符串.
	 */
	public static String[] splitString(String srcStr, String splitter) {
		if (srcStr == null)
			return new String[] { "" };
		String[] tmpArr = srcStr.split(splitter);
		if (tmpArr == null || tmpArr.length == 0) {
			return new String[] { "" };
		} else {
			for (int index = 0; index < tmpArr.length; index++) {
				tmpArr[index] = tmpArr[index].trim();
			}
			return tmpArr;
		}
	}

	public static void main(String[] args) {
		String[] aa = splitString("119810629000000001|张四1507|1|3|rs1|19810629|15930000006|02111111117|02100000007|广发银行107|上海市||410086|||||||||||测试省||||||||||||||20101209|0204|阿斯顿|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||阿斯顿飞的萨芬|||||0", "\\|");
		System.out.println(aa.length);
		for (String a : aa)
			System.out.println(a);

	}

	public static String getFirstEleFromArr(Object obj) {
		String[] strArr = (String[]) obj;
		if (strArr == null || strArr.length == 0) {
			return "";
		}
		return (String) strArr[0];
	}

	/**
	 * 日期的加减
	 * 
	 * @param Date
	 * @param type
	 *            Y-年 M-月 D-天
	 * @param amount
	 *            加减的数量
	 * @author peixiuyue
	 * @return
	 */
	public static Date modifyDate(Date date, String type, int amount) {
		if (date == null) {
			date = new Date();
		}
		if (isEmpty(type)) {
			type = "";
		}
		Calendar now = Calendar.getInstance();
		now.setTime(date);
		// PubMethod.toPrint(now.get(Calendar.YEAR) + " " +
		// (now.get(Calendar.MONTH)+1) + " " + now.get(Calendar.DAY_OF_YEAR) + "
		// " + now.get(Calendar.DAY_OF_WEEK));
		if ("Y".equalsIgnoreCase(type)) {
			now.add(Calendar.YEAR, amount);
		} else if ("M".equalsIgnoreCase(type)) {
			now.add(Calendar.MONTH, amount);
		} else if ("D".equalsIgnoreCase(type)) {
			now.add(Calendar.DAY_OF_YEAR, amount);
		}
		return now.getTime();
	}

	/**
	 * 分钟的加减
	 * 
	 * @param Date
	 * @param amount
	 *            加减的数量
	 * @param format
	 * @author wanglx
	 * @return
	 */
	public static String modifyMinute(Date date, int amount, String format) {

		if (date == null) {
			date = new Date();
		}
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		java.util.Calendar Cal = java.util.Calendar.getInstance();
		Cal.getTime();
		Cal.setTime(date);
		Cal.add(java.util.Calendar.MINUTE, amount);

		return formatter.format(Cal.getTime());
	}

	/**
	 * 字符串转时间
	 * 
	 */
	public static Date StrToDate(String str) {

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = null;
		try {
			date = format.parse(str);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	/**
	 * 判断字符串s是否包含在数组中
	 * 
	 * @param s
	 * @param array
	 * @return
	 * @throws Exception
	 */
	public static boolean isInArray(String s, String[] array) {
		boolean b = false;
		if (s == null)
			return b;
		try {
			for (int i = 0; array != null && i < array.length; i++) {
				if (s.equals(array[i]))
					return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return b;
	}

	/**
	 * 判断字符串s是否包含在列表中
	 * 
	 * @param s
	 * @param array
	 * @return
	 * @throws Exception
	 */
	public static boolean isInArray(String s, List<String> array) {
		boolean b = false;
		if (s == null || isEmpty(array))
			return b;
		try {
			// for (int i = 0; array != null && i < array.length; i++) {
			for (String val : array) {
				if (s.equals(val))
					return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return b;
	}

	/**
	 * 字符数组转换为Long数组
	 * 
	 * @param strArr
	 * @return
	 */
	public static Long[] strArrToLongArr(String[] strArr) {
		if (PubMethod.isEmpty(strArr)) {
			return null;
		}
		Long[] longArr = new Long[strArr.length];
		int index = -1;
		for (String str : strArr) {
			Long val = new Long(str);
			longArr[++index] = val;
		}
		return longArr;
	}

	/**
	 * 文件的拷贝
	 * 
	 * @param src
	 *            源文件
	 * @param dst
	 *            目标文件
	 */
	public static void copy(File src, File dst) {
		int BUFFER_SIZE = 2096;
		InputStream in = null;
		OutputStream out = null;
		try {
			in = new BufferedInputStream(new FileInputStream(src), BUFFER_SIZE);
			out = new BufferedOutputStream(new FileOutputStream(dst), BUFFER_SIZE);
			byte[] buffer = new byte[BUFFER_SIZE];
			int len = 0;
			while ((len = in.read(buffer)) > 0) {
				out.write(buffer, 0, len);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (null != in) {
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (null != out) {
				try {
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * 
	 * 生成ID:格式为8位年月日+12位流水号，其中12位流水号不足的补0。 流水号为上一个ID的流水号加1.
	 * 例如：20110824000000000001
	 * 
	 * @return
	 */
	public static String generateId(String preId) {
		String newId = "";
		Long oldNum = Long.parseLong(preId.substring(preId.length() - 12, preId.length()));
		Long newNum = 0l;
		if (oldNum < 999999999999l) {
			newNum = oldNum + 1;
		}

		String newNumStr = String.valueOf(newNum);
		String formatter = "000000000000";
		newId = PubMethod.getYMD() + formatter.substring(0, 12 - newNumStr.length()) + newNumStr;
		return newId;
	}

	// 得到对比月变化的目标年月
	// getMonthChange("2003-10",1)="2003-11";
	// getMonthChange("2003-10",-2)="2003-08";
	/**
	 * 返回变化给定月份量的时间值，并格式化为yyyy-MM的时间字符串。<br>
	 * 如：getMonthChange("2003-10",1)="2003-11"，<br>
	 * getMonthChange("2003-10",-2)="2003-08"。
	 * 
	 * @param strCurrentTime
	 *            格式化为yyyy-MM的时间String
	 * @param iQuantity
	 *            添加的月份时间量
	 * @return 更改日期后的时间值，格式化yyyy-MM的时间字符串
	 */
	public static String getMonthChange(String strCurrentTime, int iQuantity) {
		String strTarget = "";
		int iYear = Integer.parseInt(strCurrentTime.substring(0, 4));
		int iMonth = Integer.parseInt(strCurrentTime.substring(5, 7));

		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR, iYear);
		cal.set(Calendar.MONTH, iMonth - 1);
		cal.add(Calendar.MONTH, iQuantity);
		Date currentDate = cal.getTime();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM");
		strTarget = formatter.format(currentDate);
		return strTarget;
	}

	// -----------------------------------------------------------------------------------
	// 得到对比日期变化的目标日期
	// getDateChange("2003-10-15",1)="2003-10-16";
	// getDateChange("2003-10-15",-2)="2003-10-13";
	/**
	 * 返回变化给定日期量的时间值，并格式化为yyyy-MM-dd的时间字符串。<br>
	 * 如：getDateChange("2003-10-15",1)="2003-10-16"，<br>
	 * getDateChange("2003-10-15",-2)="2003-10-13"
	 * 
	 * @param strCurrentDate
	 *            格式化为yyyy-MM-dd的时间String
	 * @param iQuantity
	 *            添加的日期时间量
	 * @return 更改日期后的时间值，格式化yyyy-MM-dd的时间字符串
	 */
	public static String getDateChange(String strCurrentDate, int iQuantity) {
		String strTarget = "";
		int iYear = Integer.parseInt(strCurrentDate.substring(0, 4));
		int iMonth = Integer.parseInt(strCurrentDate.substring(5, 7));
		int iDay = Integer.parseInt(strCurrentDate.substring(8, 10));

		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR, iYear);
		cal.set(Calendar.MONTH, iMonth - 1);
		cal.set(Calendar.DAY_OF_MONTH, iDay);
		cal.add(Calendar.DATE, iQuantity);
		Date currentDate = cal.getTime();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		strTarget = formatter.format(currentDate);
		return strTarget;
	}

	/**
	 * @param changeTime
	 *            改变的时间（分钟）
	 * @return 当前时间前多久或者后多久，格式化yyyy-MM-dd HH:mm:ss的时间字符串。 比如：当前时间俩小时前
	 *         getNowTimeChange(-120) ，俩小时后getNowTimeChange(120)
	 */
	public static String getNowTimeChange(int changeTime) {
		String strCurrentDateTime = "";
		Calendar caldate = null;
		Date currentDateTime = new Date();
		caldate = Calendar.getInstance();
		caldate.setTime(currentDateTime);
		currentDateTime = caldate.getTime();
		caldate.setTime(currentDateTime);
		caldate.add(Calendar.MINUTE, changeTime);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		strCurrentDateTime = formatter.format(caldate.getTime());
		return strCurrentDateTime;
	}

	/**
	 * 把格式为不同形式的时间字符串，去掉其中的"-"、" "和":"字符，转换为仅包含数字字符的时间字符串。
	 * 如：dateTimeFmtToStr("2011-04-15 16:54:33")="20110415165433"。
	 * 
	 * @param dt
	 *            格式为不同形式的时间字符串，如：yyyy-MM-dd HH:mm:ss或yyyy-MM-dd等。
	 * @return 仅包含数字字符的时间字符串，如：yyyyMMddHHmmss或yyyyMMdd。
	 */
	public static String dateTimeFmtToStr(String dt) {
		if (dt == null || dt.equals(""))
			return "";
		String str = "";
		for (int i = 0; i < dt.length(); i++) {
			if (dt.charAt(i) == '-' || dt.charAt(i) == ' ' || dt.charAt(i) == ':')
				continue;
			str += dt.charAt(i);
		}
		return str;

	}

	/**
	 * 根据map的value值从大到小进行排序
	 * 
	 * @param keyArr
	 *            关键词数组
	 * @param map
	 *            以keyArr为关键词的map
	 * @return 返回重新排序后的关键词数组
	 */
	public static String[] sortMapValue(String[] keyArr, Map<String, Double> map) {
		for (int i = 0; i < keyArr.length; i++) {
			for (int j = i + 1; j < keyArr.length; j++) {
				Double valuei = map.get(keyArr[i]);
				int n = i + 1;
				while (valuei == null) {
					if (n >= keyArr.length)
						break;
					String temp = keyArr[i];
					keyArr[i] = keyArr[n];
					keyArr[n] = temp;
					valuei = map.get(keyArr[i]);
					n++;
				}

				if (n >= keyArr.length)
					continue;
				Double valuej = map.get(keyArr[j]);
				if (valuej == null)
					continue;
				if (valuej > valuei) {
					String temp = keyArr[i];
					keyArr[i] = keyArr[j];
					keyArr[j] = temp;
				}
			}
		}
		return keyArr;
	}

	/**
	 * 流拷贝
	 * 
	 * @param input
	 * @param output
	 * @return
	 * @throws IOException
	 */
	private static int copy(InputStream input, OutputStream output) throws IOException {
		byte[] buffer = new byte[1024 * 5];
		int count = 0;
		int n = 0;
		while (-1 != (n = input.read(buffer))) {
			output.write(buffer, 0, n);
			count += n;
		}
		output.flush();
		return count;
	}

	/**
	 * 获取两个日期之间相隔 时间
	 */
	public static String datePlus(String startDate, String endDate) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// 将截取到的时间字符串转化为时间格式的字符串
		Date beginTime;
		try {
			beginTime = sdf.parse(startDate);

			Date endtime = sdf.parse(endDate);
			// 默认为毫秒，除以1000是为了转换成秒
			long interval = (endtime.getTime() - beginTime.getTime()) / 1000;// 秒
			long day = interval / (24 * 3600);// 天
			long hour = interval % (24 * 3600) / 3600;// 小时
			long minute = interval % 3600 / 60;// 分钟
			long second = interval % 60;// 秒
			String str = "两个时间相差：" + day + "天" + hour + "小时" + minute + "分" + second + "秒";
			return str;
		} catch (ParseException e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * 获取两个日期之间 相差小时数
	 */
	public static long datePlushour(String startDate, String endDate) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// 将截取到的时间字符串转化为时间格式的字符串
		Date beginTime;
		try {
			beginTime = sdf.parse(startDate);

			Date endtime = sdf.parse(endDate);
			// 默认为毫秒，除以1000是为了转换成秒
			long interval = (endtime.getTime() - beginTime.getTime()) / 1000;// 秒

			long hour = interval / 60 / 60;// 小时

			return hour;
		} catch (ParseException e) {
			e.printStackTrace();
			return 0;
		}
	}

	

	public static List<String> getVarName(String str) {
		Pattern p = Pattern.compile("\\{.*?\\}");// 查找规则公式中大括号以内的字符
		Matcher m = p.matcher(str);
		List<String> strs = new ArrayList<String>();
		String param = "";
		while (m.find()) {// 遍历找到的所有大括号
			strs.add(m.group());
		}
		return strs;
	}

	
	
	///除去以0020类似开头的数字
	public static boolean isNumeric(String str)
	{
		if(isEmpty(str))
		{
			return false;
		}
		if(str.startsWith("0")&&!str.startsWith("0."))
		{
			return false;
		}
		return str.matches("^[+|-]?[0-9]+(.[0-9]{1,})?$");
	}
	
	public static boolean isListEquals(List<String> list1,List<String> list2){
		if(null != list1 && null!=list2){
			if(list1.containsAll(list2)&&list2.containsAll(list1)){
				return true;
				
			}
			return false;
		}
		return false;
	}
}
