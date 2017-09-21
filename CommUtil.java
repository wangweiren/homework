package com.banck.poup.comment.utils;


import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import org.apache.log4j.Logger;

/**
 * 通用工具类
 * @author: Chengdong Wang
 * @date:   2017年7月20日 下午4:45:20 
 * @Description:
 */
public class CommUtil {
	private static Logger logger = Logger.getLogger(CommUtil.class);
	
	/**
	 * 格式化日期
	 * 
	 * @param batchdate
	 * @return
	 */
	public static String formatBatchdate(Date batchdate) {
		return new SimpleDateFormat("yyyyMMdd").format(batchdate);
	}

	/**
	 * 释放资源
	 * 
	 * @param rs
	 * @param ps
	 * @param conn
	 */
	public static void release(ResultSet rs, PreparedStatement ps, Connection conn) {
		try {
			if (rs != null) {
				rs.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			rs = null;
		}

		try {
			if (ps != null) {
				ps.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ps = null;
		}

		try {
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			conn = null;
		}
	}
	/**
	 * 
	 * @Description 释放资源
	 * @param in
	 * @param out      
	 * @return void      
	 * @throws
	 */
	public static void releaseIO(InputStream in, OutputStream out){
		if(in!=null){
			try {
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			}finally {
				in = null;
			}
		}
		if(out!=null){
			try {
				out.close();
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				out = null;
			}
		}
	}
	
	public static Boolean isNullOrEmpty(String...args){
		Boolean flag = false;
		for(String str : args){
			if(str==null||str.isEmpty()){
				flag=true;
			}
		}
		return flag;
	}
}
