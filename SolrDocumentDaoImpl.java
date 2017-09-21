package com.banck.poup.loan.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.banck.poup.comment.utils.CommUtil;
import com.banck.poup.comment.utils.ConnManager;
import com.banck.poup.loan.dao.ISolrDocumentDao;
import com.pccc.poup.core.model.loan.store.LoanStore;

public class SolrDocumentDaoImpl implements ISolrDocumentDao{
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Override
	public List<LoanStore> getStoreList() throws InstantiationException, IllegalAccessException {
		List<LoanStore> storeList = new ArrayList<LoanStore>();
		logger.info("批量导入solr document,开始查询门店列表...");
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			Connection conn = ConnManager.getConn();
			sql = "SELECT ID id, MER_SHOP_ID merShopId, MER_UUID merUUID, MER_SHOP_NAME merShopName, MER_LONGITUDE merLongitude, MER_LATITUDE merLatitude, CITY_NO cityNo, DISHSET_ID dishsetId, DISTRICT_ID districtId, IMG_ID imgId," +
					"MER_SHOP_ADDRESS merAddress,AREA_ID areaId,VOL_TYPE volType,MER_NAME merName,MER_SHOP_TEL merTel,CITY_NAME cityName,AREA_NAME areaName,DISTRICT_NAME districtName FROM TBL_LOAN_STORE WHERE CITY_NO IS NOT NULL" ; 
			pstmt = conn.prepareStatement(sql);
			ResultSet resultSet = pstmt.executeQuery();
			while(resultSet.next()){
				LoanStore store = new LoanStore();
				store.setId(resultSet.getInt("id"));
				store.setMerShopId(resultSet.getString("merShopId"));
				store.setMerUUID(resultSet.getString("merUUID"));
				store.setMerShopName(resultSet.getString("merShopName"));
				store.setMerLongitude(resultSet.getString("merLongitude"));
				store.setMerLatitude(resultSet.getString("merLatitude"));
				store.setCityNo(resultSet.getString("cityNo"));
				store.setAreaId(resultSet.getString("areaId"));	
				store.setDistrictId(resultSet.getString("districtId"));
				store.setImgId(resultSet.getString("imgId"));
				store.setMerAddress(resultSet.getString("merAddress"));
				store.setVolType(resultSet.getString("volType"));
				store.setMerName(resultSet.getString("merName"));
				store.setMerTel(resultSet.getString("merTel"));
				store.setAreaName(resultSet.getString("areaName"));
				store.setCityName(resultSet.getString("cityName"));
				store.setDistrictName(resultSet.getString("districtName"));
				storeList.add(store);
			}
		} catch (SQLException e) {
			logger.error("批量导入solr document,查询门店列表异常SQL异常,SQL: [" + sql + "]"+"异常信息+"+e);
			throw new RuntimeException(e);
		} finally {
			CommUtil.release(null, pstmt, null);
		}
		return storeList;
	}

}
