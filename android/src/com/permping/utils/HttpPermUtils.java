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
import org.w3c.dom.Document;

import com.permping.interfaces.HttpAccess;

import android.os.AsyncTask;
import android.util.Log;

/**
 * @author Linh Nguyen
 *
 */
public class HttpPermUtils {
	private DefaultHttpClient client = new DefaultHttpClient();
	private HttpAccess httpAccess;
	public HttpPermUtils(HttpAccess delegate) {
		// TODO Auto-generated constructor stub
		httpAccess = delegate;
	}

	public HttpPermUtils() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * Get the response as string from the GET method request with its parameters
	 * @param url the url
	 * @return the response as string
	 */
	public String sendPostRequest(String url, List<NameValuePair> nameValuePairs) {
		 new sendRequestTask(nameValuePairs, null).execute(url);
		 return null;
	}
	public String sendPostRequest(String url, List<NameValuePair> nameValuePairs, String id) {
		 new sendRequestTask(nameValuePairs, id).execute(url);
		 return null;
	}
	class sendRequestTask extends AsyncTask<String, Void, String> {

	    private Exception exception;
	    private List<NameValuePair> nameValuePairs;
	    private String myDiaryThumbId;
	    public sendRequestTask(List<NameValuePair> nameValuePairs, String id) {
			// TODO Auto-generated constructor stub
	    	this.nameValuePairs = nameValuePairs;
	    	this.myDiaryThumbId = id;
		}

		protected String doInBackground(String... urls) {
			String url = null;
			String result=null;
			if(urls != null)
				 url = urls[0];
			HttpPost postRequest = new HttpPost(url);
			try {			
				if (nameValuePairs != null) {
					postRequest.setEntity(new UrlEncodedFormEntity(nameValuePairs, HTTP.UTF_8));
				}
				HttpResponse postResponse = client.execute(postRequest);
				int statusCode = postResponse.getStatusLine().getStatusCode();
				if (statusCode != HttpStatus.SC_OK) {
					Log.w(getClass().getSimpleName(), "ERROR: " + statusCode + " for URL: " + url); 
		            result = null;			
				}else{
					HttpEntity postResponseEntity = postResponse.getEntity();
					if (postResponseEntity != null)
						result =  EntityUtils.toString(postResponseEntity);
				}
				if (result != null && !result.isEmpty() && httpAccess != null) {				
					httpAccess.onSeccess(result, this.myDiaryThumbId);
				}else if(httpAccess != null){
					httpAccess.onError();
				}
				Log.d("==>","THIen.....==========>"+url);
			} catch (IOException ioe) {
//				postRequest.abort();
				Log.w(getClass().getSimpleName(), "thien====>ERROR for URL " + url, ioe);
				httpAccess.onError();
				return null;
			}

			return result;
	    }

	    protected void onPostExecute(String result) {
	        // TODO: check this.exception 
	        // TODO: do something with the feed

	    }
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
