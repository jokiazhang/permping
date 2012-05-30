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
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

import android.util.Log;

/**
 * @author Linh Nguyen
 *
 */
public class HttpPermUtils {
	private DefaultHttpClient client = new DefaultHttpClient();
	
	/**
	 * Get the response as string from the GET method request with its parameters
	 * @param url the url
	 * @return the response as string
	 */
	public String sendPostRequest(String url, List<NameValuePair> nameValuePairs) {
		HttpPost postRequest = new HttpPost(url);
		try {			
			if (nameValuePairs != null) {
				postRequest.setEntity(new UrlEncodedFormEntity(nameValuePairs, HTTP.UTF_8));
			}
			HttpResponse postResponse = client.execute(postRequest);
			int statusCode = postResponse.getStatusLine().getStatusCode();
			if (statusCode != HttpStatus.SC_OK) {
				Log.w(getClass().getSimpleName(), "ERROR: " + statusCode + " for URL: " + url); 
	            return null;				
			}
			HttpEntity postResponseEntity = postResponse.getEntity();
			if (postResponseEntity != null)
				return EntityUtils.toString(postResponseEntity);
		} catch (IOException ioe) {
			postRequest.abort();
			Log.w(getClass().getSimpleName(), "ERROR for URL " + url, ioe);
		}
		
		return null;
	}
	
	/**
	 * Get the response as string from the GET method request without parameters
	 * @param url the url
	 * @return the response as string
	 */
	public String sendGetRequest(String url) {
		HttpGet getRequest = new HttpGet(url);
		try {
			HttpResponse getResponse = client.execute(getRequest);
			int statusCode = getResponse.getStatusLine().getStatusCode();
			if (statusCode != HttpStatus.SC_OK) {
				Log.w(getClass().getSimpleName(), "ERROR: " + statusCode + " for URL: " + url);
				return null;
			}
			HttpEntity getResponseEntity = getResponse.getEntity();
			if (getResponseEntity != null)
				return EntityUtils.toString(getResponseEntity);					
		} catch (IOException ioe) {
			getRequest.abort();
			Log.w(getClass().getSimpleName(), "ERROR for URL: " + url, ioe);
		}
		
		return null;
	}
}
