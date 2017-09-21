package com.banck.poup.comment.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.commons.lang3.StringUtils;

public class LoadProperty {
	public static String getValueByKey(String fileName, String key){ 
		InputStream inputStream = LoadProperty.class.getClassLoader().getResourceAsStream(fileName);  
		Properties p = new Properties();
		String filePath="";
		try {  
			p.load(inputStream);  
			filePath=p.getProperty(key);
			if(StringUtils.isNotBlank(filePath)){
				filePath=filePath.trim();
			}
			
		} catch (IOException e1) {  
			e1.printStackTrace();  
		}  finally {
			try {
				inputStream.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return filePath;  
	}  
}
