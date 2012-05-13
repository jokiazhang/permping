/**
 * 
 */
package com.permping.utils;

/**
 * @author Linh Nguyen
 *
 */
public class Constants {
	
	/**
	 * Twitter parameters required by the API
	 */
	public static final String CONSUMER_KEY = "iPFNLuoLkgDwtrwjY1X4Mg";
	public static final String CONSUMER_SECRET= "SA5tVx0Dh5DIUV3VvMcjlF70OCAU2zYHTVRwz2I";
	
	public static final String REQUEST_URL = "https://api.twitter.com/oauth/request_token";
	public static final String ACCESS_URL = "https://api.twitter.com/oauth/access_token";
	public static final String AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize";
	
	public static final String	OAUTH_CALLBACK_SCHEME	= "http";
	public static final String	OAUTH_CALLBACK_HOST		= "permping.com/new";
	public static final String	OAUTH_CALLBACK_URL		= OAUTH_CALLBACK_SCHEME + "://" + OAUTH_CALLBACK_HOST;
	
}
