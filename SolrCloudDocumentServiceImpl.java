package com.banck.poup.loan.service.impl;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.CloudSolrServer;
import org.apache.solr.common.SolrInputDocument;

import com.banck.poup.comment.utils.LoadProperty;
import com.banck.poup.loan.dao.ISolrDocumentDao;
import com.banck.poup.loan.dao.impl.SolrDocumentDaoImpl;
import com.banck.poup.loan.service.ISolrCloudDocumentService;
import com.pccc.poup.core.model.loan.common.Constants;
import com.pccc.poup.core.model.loan.store.LoanStore;

public class SolrCloudDocumentServiceImpl implements ISolrCloudDocumentService {
	private static Logger logger = Logger.getLogger(SolrCloudDocumentServiceImpl.class);
	private static final String  zkHost =LoadProperty.getValueByKey("solr.properties", "solr.zkhost");
	private static final String  storeCollection = "collection1";
	private static final String  suggestCollection = "collection2";
	/**经度最大值*/
	private Double maxLog = 180.0;
	/**纬度最大值*/
	private Double maxLat = 90.0;
	/**经纬度为空、或者超过90时，设置0*/
	private String DEFAULT_DEGREE = "0.0";
	
	ISolrDocumentDao solrDocumentDao = new SolrDocumentDaoImpl();
	
	
	private CloudSolrServer getSolrCloudServer(String collection) throws MalformedURLException{
		CloudSolrServer cloudSolrServer = new CloudSolrServer(zkHost);
		cloudSolrServer.setDefaultCollection(collection);
		cloudSolrServer.setZkClientTimeout(20000);
		cloudSolrServer.setZkConnectTimeout(1000);
		cloudSolrServer.connect();
		return cloudSolrServer;
	}
	
	@Override
	public void importStores() throws Exception {
		try {
			CloudSolrServer cloudSolrServer = this.getSolrCloudServer(storeCollection);
			logger.info("连接CloudSolrServer成功，删除storeCollection原有索引");
			deleteSolrIndex(cloudSolrServer);
			logger.info("删除solr索引成功");
			//查询门店列表
			List<LoanStore> storeList = solrDocumentDao.getStoreList();
			for (LoanStore loanStore : storeList) {
				SolrInputDocument document = new SolrInputDocument();
				document.setField("id",loanStore.getMerShopId());
				document.setField("merShopId",loanStore.getMerShopId());
				document.setField("merUUId",loanStore.getMerUUID());
				String merShopName = StringUtils.isBlank(loanStore.getMerShopName())?"":loanStore.getMerShopName();
				document.setField("merShopName", merShopName);
				document.setField("cityNo",loanStore.getCityNo());
				document.setField("districtId",loanStore.getDistrictId());
				document.setField("imgId",loanStore.getImgId());
				document.setField("areaId",loanStore.getAreaId());
				String merAddress = StringUtils.isBlank(loanStore.getMerAddress())?"":loanStore.getMerAddress();
				document.setField("merAddress", merAddress);
				document.setField("volType",loanStore.getVolType());
				document.setField("merName", loanStore.getMerName());
				document.setField("merTel", loanStore.getMerTel());
				document.setField("cityName", loanStore.getCityName());
				document.setField("areaName", loanStore.getAreaName());
				document.setField("districtName", loanStore.getDistrictName());
				document.setField("updateTime",loanStore.getUpdateTime());
				
				if(StringUtils.isBlank(loanStore.getMerLongitude()) ||
						StringUtils.isBlank(loanStore.getMerLatitude()) ||
						(Double.valueOf(loanStore.getMerLongitude())>maxLog) ||
						(Double.valueOf(loanStore.getMerLatitude())>maxLat)
						){
					loanStore.setMerLongitude(DEFAULT_DEGREE);
					loanStore.setMerLatitude(DEFAULT_DEGREE);
				}
				document.setField("position", loanStore.getMerLatitude()+","+loanStore.getMerLongitude());
				//写入索引库
				cloudSolrServer.add(document);
			}
			cloudSolrServer.commit();
			cloudSolrServer.shutdown();
		} catch (Exception e) {
			logger.error("批量导入门店异常,异常信息为[{"+e.getMessage()+"}]",e);
			throw new Exception();
		}
		
	}

	@Override
	public void importSuggests() throws Exception {
		try {
			CloudSolrServer cloudSolrServer = this.getSolrCloudServer(suggestCollection);
			logger.info("连接 CloudSolrServer成功，删除suggestCollection原有的索引");
			deleteSolrIndex(cloudSolrServer);
			logger.info("删除solr索引成功");
			
			//查询门店列表
			List<LoanStore> list = solrDocumentDao.getStoreList();
			logger.info("从数据库获取索引列表成功,将信息写入 solr 索引文件...");
			//把联想词信息写入索引库
			for (LoanStore store : list) {
				SolrInputDocument document = new SolrInputDocument();
				document.setField("id", store.getMerShopId());
				document.setField("cityNo", store.getCityNo());
				document.setField("volType",store.getVolType());
				document.setField("merShopName",store.getMerShopName());
				document.setField("merAddress",store.getMerAddress());
				String suggestWord = StringUtils.isBlank(store.getMerShopName())?store.getMerAddress():store.getMerShopName();
				document.setField("suggestWord", suggestWord);
				document.setField("suggestWordS", suggestWord.toLowerCase());
				document.setField("isAddress", Constants.STATUS_FALSE);
				//写入索引库
				cloudSolrServer.add(document);
			}
			//提交修改
			logger.info("联想词到solr document成功,提交");
			cloudSolrServer.commit();
			logger.info("提交成功,关闭服务");
			cloudSolrServer.shutdown();
			logger.info("cloudSolrServer关闭成功");
		} catch (Exception e) {
			logger.info("导入门店数据到到索引库失败，异常信息{}",e);
			throw new Exception();
		}
		
	}

	@Override
	public void deleteSolrIndex(CloudSolrServer cloudSolrServer) throws Exception {
		try {
			cloudSolrServer.deleteByQuery("*:*");
			cloudSolrServer.commit();
		} catch (SolrServerException | IOException e) {
			logger.error("删除solr失败");
			throw new Exception();
		}
		
	}

}
