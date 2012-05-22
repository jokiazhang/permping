/**
 * 
 */
package com.permping.utils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import android.util.Log;

/**
 * @author Linh Nguyen
 *
 */
public class HttpPermUtils {
	private DefaultHttpClient client = new DefaultHttpClient();
	
	public String sendPostRequest(String url, List<NameValuePair> nameValuePairs) {
		HttpPost postRequest = new HttpPost(url);
		try {			
			if (nameValuePairs != null) {
				postRequest.setEntity(new UrlEncodedFormEntity(nameValuePairs));
			}
			HttpResponse postResponse = client.execute(postRequest);
			int statusCode = postResponse.getStatusLine().getStatusCode();
			if (statusCode != HttpStatus.SC_OK) {
				Log.w(getClass().getSimpleName(), "Error " + statusCode + " for URL " + url); 
	            return null;				
			}
			HttpEntity postResponseEntity = postResponse.getEntity();
			if (postResponseEntity != null) {
				//return EntityUtils.toString(postResponseEntity).replace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "");
				return EntityUtils.toString(postResponseEntity);
			}
		} catch (IOException ioe) {
			postRequest.abort();
			Log.w(getClass().getSimpleName(), "Error for URL " + url, ioe);
		}
		
		return null;
	}
	
	
}
