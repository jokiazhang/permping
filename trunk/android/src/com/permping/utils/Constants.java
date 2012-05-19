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
	public static final String CONSUMER_KEY = "aZNx8rmFPHMMNm8t4kqhmQ";
	public static final String CONSUMER_SECRET= "P2m0Ow5pKFjql1Uco0aiTeYZ7089fP4s7wmWxanE";
	
	public static final String REQUEST_URL = "https://api.twitter.com/oauth/request_token";
	public static final String ACCESS_URL = "https://api.twitter.com/oauth/access_token";
	public static final String AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize";
	
	public static final String	OAUTH_CALLBACK_SCHEME	= "perm";
	public static final String	OAUTH_CALLBACK_HOST		= "twitter";
	public static final String	OAUTH_CALLBACK_URL		=  "perm://twitter";
	
	/**
	 * Facebook app configuration
	 */
	public static final String FACEBOOK_APP_ID = "164668790213609";
	public static final String EMAIL = "email";
	public static final String PUBLISH_STREAM = "publish_stream";
	
	/**
	 * Login type
	 */
	public static final String LOGIN_TYPE = "loginType";
	// For Facebook: use ACCESS_TOKEN and ACCESS_EXPIRES
	public static final String FACEBOOK_LOGIN = "facebook";
	public static final String ACCESS_TOKEN = "access_token";
	public static final String ACCESS_EXPIRES = "access_expires";
	// For Twitter: use built-in OAuth.OAUTH_TOKEN and OAuth.OAUTH_TOKEN_SECRET
	public static final String TWITTER_LOGIN  = "twitter";
	// For Permping: use 
	public static final String PERMPING_LOGIN = "permping";
	
}
