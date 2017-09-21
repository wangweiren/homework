package com.banck.poup.comment.utils;

import java.beans.PropertyVetoException;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.mchange.v2.c3p0.ComboPooledDataSource;

public class ConnManager {
	
	
	private static Logger logger = Logger.getLogger(ConnManager.class);

	private static final ThreadLocal<Connection> threadLocal;

	private static Properties prop = new Properties();

	private static ComboPooledDataSource dataSource = new ComboPooledDataSource();
	static {
		try {
			prop.load(ConnManager.class.getClassLoader().getResourceAsStream(
					"jdbc.properties"));
		} catch (IOException e) {
			logger.error("属性文件读取错误", e);
		}
		dataSource.setUser(prop.getProperty("jdbc.username"));

		//增加密码安全机制
		try {
			String password = new DesUtils("ccbpccs").decrypt(prop.getProperty("jdbc.password"));
			dataSource.setPassword(password);
		} catch (Exception e){
			logger.error("获取密码错误", e);
		}

		dataSource.setJdbcUrl(prop.getProperty("jdbc.url"));
		try {
			dataSource.setDriverClass(prop.getProperty("jdbc.driverclass"));
		} catch (PropertyVetoException e) {
			logger.error("连接池构造异常", e);
			throw new IllegalStateException(e);
		}
		dataSource.setInitialPoolSize(Integer.parseInt(prop
				.getProperty("jdbc.initialPoolSize")));
		dataSource.setMinPoolSize(Integer.parseInt(prop
				.getProperty("jdbc.minPoolSize")));
		dataSource.setMaxPoolSize(Integer.parseInt(prop
				.getProperty("jdbc.maxPoolSize")));
		dataSource.setMaxStatements(Integer.parseInt(prop
				.getProperty("jdbc.maxStatements")));
		dataSource.setMaxIdleTime(Integer.parseInt(prop
				.getProperty("jdbc.maxidletime")));
		threadLocal = new ThreadLocal<Connection>();
	}
	public static Connection getConn() {
		Connection conn = threadLocal.get();
		try {
			if (conn == null || conn.isClosed()) {
				conn = dataSource.getConnection();
				threadLocal.set(conn);
			}
		} catch (SQLException e) {
			logger.error("获取连接异常", e);
			throw new IllegalStateException(e);
		}
		return conn;
	}

	public static void closeConn() {
		Connection conn = threadLocal.get();
		threadLocal.set(null);
		try {
			if (conn != null && !conn.isClosed()) {
				conn.close();
			}
		} catch (SQLException e) {
			logger.error("关闭连接异常", e);
			// throw new IllegalStateException(e);
		}
	}

	public static void beginTransaction() {
		try {
			getConn().setAutoCommit(false);
		} catch (SQLException e) {
			logger.error("开始事务异常", e);
			throw new IllegalStateException(e);
		}
	}

	public static void commit() {
		try {
			getConn().commit();
			getConn().setAutoCommit(true);
		} catch (SQLException e) {
			logger.error("提交事务异常", e);
			throw new IllegalStateException(e);
		}
	}

	public static void rollback() {
		try {
			getConn().rollback();
			getConn().setAutoCommit(true);
		} catch (SQLException e) {
			logger.error("事务回滚异常", e);
			throw new IllegalStateException(e);
		}
	}

//	public static List<?> executeQuery(String sql, AbstractDAO<?> dao) {
//		PreparedStatement pstmt = null;
//		ResultSet rs = null;
//		try {
//			pstmt = getConn().prepareStatement(sql);
//			rs = pstmt.executeQuery();
//			List<?> objList = dao.mapping(rs);
//			return objList;
//		} catch (SQLException e) {
//			logger.error("查询异常，查询语句[" + sql + "]", e);
//			return null;
//		} finally {
//			try {
//				if (rs != null)
//					rs.close();
//				if (pstmt != null)
//					pstmt.close();
//			} catch (Exception e) {
//				logger.error("statement关闭异常", e);
//			}
//		}
//	}

	public static List<?> executeQuery(String sql) {
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = getConn().createStatement();
			rs = stmt.executeQuery(sql);
			List<Map<String,Object>> objList = getMap(rs);
			return objList;
		} catch (SQLException e) {
			logger.error("查询异常，查询语句[" + sql + "]", e);
			return null;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception e) {
				logger.error("statement关闭异常", e);
			}
		}
	}

	private static List<Map<String, Object>> getMap(ResultSet rs) {
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		try {
			while (rs.next()) {
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				Map<String,Object> rowData = new HashMap<String,Object>();
				for (int i = 1; i <= columnCount; i++) {  
					rowData.put(rsmd.getColumnName(i), rs.getObject(i));
				}
				result.add(rowData);
			}
		} catch (SQLException e) {
			logger.error(e.getStackTrace());
			e.printStackTrace();
		}
		return result;
	}

	public static boolean execute(String sql) {
		Statement stmt = null;
		try {
			stmt = getConn().createStatement();
			return stmt.execute(sql);
		} catch (SQLException e) {
			logger.error("SQL异常,SQL语句[" + sql + "]", e);
			return false;
		} finally {
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					logger.error("statement关闭异常", e);
				}
			}
		}
	}

	public static int executeUpdate(String sql) {
		Statement stmt = null;
		try {
			stmt = getConn().createStatement();
			return stmt.executeUpdate(sql);
		} catch (SQLException e) {
			logger.error("SQL异常,SQL语句[" + sql + "]", e);
			return 0;
		} finally {
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					logger.error("statement关闭异常", e);
				}
			}
		}
	}
	public static boolean call(String classname) {
		CallableStatement call = null;
		try {
			call = getConn().prepareCall("{CALL " + classname + "}");
			return call.execute();
		} catch (SQLException e) {
			throw new RuntimeException(e);
		} finally {
			if (call != null) {
				try {
					call.close();
				} catch (SQLException e) {
					logger.error("CallableStatement关闭异常", e);
				}
			}
		}

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

}
