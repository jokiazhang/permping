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
	public static final String CONSUMER_KEY = "9svvOiVkxleiWWcVNWyddg";
	public static final String CONSUMER_SECRET= "LUXYs5AdpGionGgPDd8nkKOdDbLrj3DAf8YyYgAM1U";
	
	public static final String REQUEST_URL = "https://api.twitter.com/oauth/request_token";
	public static final String ACCESS_URL = "https://api.twitter.com/oauth/access_token";
	public static final String AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize";
	
	public static final String	OAUTH_CALLBACK_SCHEME	= "perm";
	public static final String	OAUTH_CALLBACK_HOST		= "callback";
	public static final String	OAUTH_CALLBACK_URL		= OAUTH_CALLBACK_SCHEME + "://" + OAUTH_CALLBACK_HOST;
	
}
