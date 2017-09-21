package com.banck.poup.comment.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

/**
 * 字符串、日期工具类
 * 
 * @author yuyi
 * 
 */
public class StringDateUtil {

	private static Logger logger = Logger.getLogger(StringDateUtil.class);

	/**
	 * 获取两个日期之间间隔的天数，结果可正可负
	 * 
	 * @param before
	 * @param after
	 * @return
	 */
	public static int getBetweenDays(Date before, Date after) {
		int betweenDays = 0;
		long msecond1 = before.getTime();
		long msecond2 = after.getTime();
		betweenDays = (int) (msecond2 - msecond1) / (1000 * 60 * 60 * 24);
		return betweenDays;
	}

	/**
	 * 字符串转成日期类型
	 * 
	 * @param date
	 * @return
	 */
	public static Date StringToDate(String date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
			return sdf.parse(date);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
			return null;
		}
	}

	/**
	 * 日期转字符串
	 * 
	 * @param Date
	 *            需要进行转换的日期
	 * @param String
	 *            需要转换的类型
	 * @return String
	 */
	public static String DateToString(Date d, String type) {
		if (d == null) {
			return "";
		}
		SimpleDateFormat sdf = new SimpleDateFormat(type);
		return sdf.format(d);
	}

	/**
	 * 将字符串按指定长度左补齐,rex为替换符
	 * 
	 * @param rex
	 *            补充的字符
	 * @param i
	 *            需补充位数
	 * @param origin
	 *            原字符串
	 * @return String 返回已补齐的字符串
	 */
	public static String padLeft(String rex, int i, String origin) {
		if (origin == null) {
			origin = "";
		}
		int len = origin.length();
		if (len >= i) {
			return origin;
		} else {
			StringBuffer sb = new StringBuffer();
			for (int j = 0; j < i - len; j++) {
				sb.append(rex);
			}
			sb.append(origin);
			return sb.toString();
		}
	}

	/**
	 * 将字符串按指定长度右补齐,rex为替换符
	 * 
	 * @param rex
	 *            补充的字符
	 * @param i
	 *            需补充位数
	 * @param origin
	 *            原字符串
	 * @return String 返回已补齐的字符串
	 */
	public static String padRight(String rex, int i, String origin) {
		if (origin == null) {
			origin = "";
		}
		int len = origin.length();
		if (len >= i)
			return origin;
		else {
			StringBuffer sb = new StringBuffer();
			sb.append(origin);
			for (int j = 0; j < i - len; j++) {
				sb.append(rex);
			}
			return sb.toString();
		}
	}
	/**
	 * 对两个时间字符串进行比较
	 * 先将字符串转为Date型，可能会出现类型转换异常
	 * @param dateStr1
	 * @param dateStr2
	 * @return -1 ：前者小于后者；0：两者相等；2：前者大于后者
	 * @throws ParseException
	 */
	public static int stringDateCompare(String dateStr1,String dateStr2) throws ParseException{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date1 = sdf.parse(dateStr1);
		Date date2 = sdf.parse(dateStr2);
		return date1.compareTo(date2);
	}
}
