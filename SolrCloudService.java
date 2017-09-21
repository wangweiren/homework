package com.banck.poup.loan.service.impl;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrRequest.METHOD;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.CloudSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.banck.poup.comment.utils.LoadProperty;
import com.pccc.poup.core.model.loan.store.LoanStore;

@Controller
public class SolrCloudService {
	
	private static final String  zkHost =LoadProperty.getValueByKey("solr.properties", "solr.zkhost");
	private static final String  storeCollection = "collection1";
	//private static final String  suggestCollection = "collection2";
	@Autowired
	CloudSolrServer cloudSolrServer;
	private CloudSolrServer getSolrCloudServer(String collection) throws MalformedURLException{
		//CloudSolrServer cloudSolrServer = new CloudSolrServer(zkHost);
		//cloudSolrServer.setDefaultCollection(collection);
		cloudSolrServer.setZkClientTimeout(20000);
		cloudSolrServer.setZkConnectTimeout(1000);
		cloudSolrServer.connect();
		return cloudSolrServer;
	}
	
	public List<LoanStore> getLoanStore(SolrQuery solrQuery) throws MalformedURLException{
		List<LoanStore> list = new ArrayList<>();
		try {
			CloudSolrServer cloudServer = this.getSolrCloudServer(storeCollection);
			QueryResponse response = cloudServer.query(solrQuery,METHOD.POST);
			Map<String, Map<String, List<String>>> highlighting = response.getHighlighting();
			SolrDocumentList solrDocumentList = response.getResults();
			for (SolrDocument solrDocument : solrDocumentList) {
				String id = solrDocument.getFieldValue("id").toString();
				Map<String, List<String>> map = highlighting.get(id);
				solrDocument.setField("merName", map.get("merName"));
			}
			for (SolrDocument solrDocument : solrDocumentList) {
				LoanStore loanStore = new LoanStore();
				ArrayList<String> fieldValue = (ArrayList<String>)solrDocument.getFieldValue("merName");
				loanStore.setMerName(fieldValue.get(0));
				list.add(loanStore);
			}
			
		} catch (SolrServerException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public SolrQuery setSolrQuery(String keyWord){
		SolrQuery solrQuery = new SolrQuery();
		solrQuery.set("q", "merName:"+keyWord);
		solrQuery.set("start", 0);
		solrQuery.set("rows", 20);
		solrQuery.setHighlight(true);
		solrQuery.addHighlightField("merName");
		solrQuery.setHighlightSimplePre("<font color=\"red\">");
		solrQuery.setHighlightSimplePost("</font>");
		return solrQuery;
	}
	
	public static void main(String[] args) {
		try {
			SolrCloudService cloudService = new SolrCloudService();
			String keyWord = "客户";
			cloudService.getLoanStore(cloudService.setSolrQuery(keyWord));
		} catch (MalformedURLException e) {
			System.out.println("出现异常："+e.getMessage());
			e.printStackTrace();
		}
	}

}
