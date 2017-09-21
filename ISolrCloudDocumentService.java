package com.banck.poup.loan.service;

import org.apache.solr.client.solrj.impl.CloudSolrServer;

public interface ISolrCloudDocumentService {

	/**
	 * 导入门店数据到索引库
	 */
	public void importStores() throws Exception;
	
	/**
	 *  导入联想词数据到索引库
	 */
	public void importSuggests() throws Exception;
	
	/**
	 * 删除所有索引文件
	 */
	public void deleteSolrIndex(CloudSolrServer cloudSolrServer) throws Exception;
}
