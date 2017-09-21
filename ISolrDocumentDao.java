package com.banck.poup.loan.dao;

import java.util.List;

import com.pccc.poup.core.model.loan.store.LoanStore;

public interface ISolrDocumentDao {
	
	/**获取门店列表 */
	List<LoanStore> getStoreList() throws InstantiationException, IllegalAccessException;
}
