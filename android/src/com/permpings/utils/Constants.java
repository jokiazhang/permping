/**
 * 
 */
package com.permpings.utils;

/**
 * @author Linh Nguyen
 *
 */
public class Constants {
	
	/**
	 * Twitter parameters required by the API
	 */
	//public static final String CONSUMER_KEY = "uMtOaN3CLE7dvvVSR1giLA";
	//public static final String CONSUMER_SECRET= "erVQyuoDUu3cwOG48cgUm5V14puqN3JbjSP4v4NE";
	
	public static final String CONSUMER_KEY = "uMtOaN3CLE7dvvVSR1giLA";
	public static final String CONSUMER_SECRET= "erVQyuoDUu3cwOG48cgUm5V14puqN3JbjSP4v4NE";
	
	public static final String REQUEST_URL = "https://api.twitter.com/oauth/request_token";
	public static final String ACCESS_URL = "https://api.twitter.com/oauth/access_token";
	public static final String AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize";
	
	public static final String	OAUTH_CALLBACK_SCHEME	= "perm";
	public static final String	OAUTH_CALLBACK_HOST		= "twitter";
	public static final String	OAUTH_CALLBACK_URL		=  "perm://twitter";
	
	/**
	 * Facebook app configuration
	 */
	public static final String FACEBOOK_APP_ID = "272022539557655";
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
	public static final String PERMPING_LOGIN = "perm";
	
	/**
	 * XML tags
	 */
	// User response
	public static final String RESPONSE = "response";
	public static final String ERROR = "error";
	public static final String USER = "user";
	public static final String L_USER = "l_user";
	public static final String USER_ID = "userId";
	public static final String L_USER_ID = "l_userId";
	public static final String USER_NAME = "userName";
	public static final String L_USER_NAME = "l_userName";
	public static final String STATUS = "status";
	public static final String L_STATUS = "l_status";
	public static final String USER_AVATAR = "userAvatar";
	public static final String L_USER_AVATAR = "l_userAvatar";
	public static final String FOLLOWING_COUNT = "followingCount";
	public static final String FOLLOWER_COUNT = "followerCount";
	public static final String PIN_COUNT = "pinCount";
	public static final String LIKE_COUNT = "likeCount";
	public static final String BOARD_COUNT = "boardCount";
	public static final String BOARDS = "boards";
	public static final String ITEM = "item";
	public static final String ID = "id";
	public static final String NAME = "name";
	public static final String DESCRIPTION = "description";
	public static final String FOLLOWERS = "followers";
	public static final String PINS = "pins";
	// Perm list reponse 
	public static final String PERMS = "perms";
	public static final String PERM_ID = "permId";
	public static final String PERM_DESCRIPTION = "permDesc";
	public static final String PERM_CATEGORY = "permCategory";
	public static final String PERM_IMAGE = "permImage";
	public static final String PERM_COMMENTS = "permComments";
	public static final String COMMENT = "comment";
	public static final String CONTENT = "content";
	public static final String IS_MORE = "isMore";
	public static final String PERM_REPINCOUNT = "permRepinCount";
	public static final String PERM_LIKECOUNT = "permLikeCount";
	public static final String PERM_COMMENTCOUNT = "permCommentCount";
	public static final String PERM_USERLIKECOUNT = "permUserLikeCount";
	public static final String NEXT_ITEM = "nextItem";
	
	/**
	 * Create Board parameters
	 */
	public static final String BOARD_NAME = "bname";
	public static final String CATEGORY_ID = "cid";
	public static final String BOARD_USER_ID = "uid";
	public static final String BOARD_DESCRIPTION = "board_desc";

	/**
	 * Texts
	 */
	public static final String TRANSPORTER = "transporter";
	public static final String LIKE = "Like";
	public static final String UNLIKE = "Unlike";
	public static final String NOT_LOGIN = "You are not logged in!";
	public static final String CURRENT_BOARD = "current_board";
}
