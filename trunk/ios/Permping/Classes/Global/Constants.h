//
//  Constants.h
//  Permping
//
//  Created by Andrew Duck on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Permping_Constants_h
#define Permping_Constants_h
#import <Foundation/Foundation.h>

//#define SERVER_API   @"http://newpermping.autwin.com/services"
#define SERVER_API   @"http://newpermping.appo.vn/services"
//#define SERVER_API   @"http://permping.com/services"

#define SERVER_REQUEST_TIMEOUT_DEFAULT 30

#define TWITTER_CONSUMER_KEY        @"uMtOaN3CLE7dvvVSR1giLA"
#define TWITTER_CONSUMER_SECRECT    @"erVQyuoDUu3cwOG48cgUm5V14puqN3JbjSP4v4NE"

#define FB_APP_ID           @"272022539557655"
#define FB_APP_SECRET       @"9d0b54305b11a48b7ca724cdd607cd60"

#define LAUNCH_APP_URL             @"permping://"


#endif

/*
 *  Constant.h
 *
 *  Created by PhongLe on 7/20/10.
 *  Copyright 2010 Appo CO., LTD. All rights reserved.
 *
 */


#import "Configuration.h"
#import "CustomizedEnumType.h"

#define PARSERTYPE							@"XML"
/*****************************************************************
 *							DEBUG
 *****************************************************************/

#ifdef DEBUG_MODE
#define	EYELOG(arg1...) NSLog(arg1)
#else
#define	EYELOG(arg1,arg2...)  
#endif

//specific sources
#define CLOUD_INTERNET_YOUTUBE_SOURCE							100
#define CLOUD_INTERNET_NETFLIX_SOURCE							101
#define CLOUD_INTERNET_TUNEINTERNET_SOURCE						102
#define CLOUD_INTERNET_INTERNET_SOURCE							103

#ifndef IPADOS
#define IPADOS ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? NO : YES )
#endif


#define SCREEN_SIZE_WIDTH									480
#define SCREEN_SIZE_HEIGHT									200



//flash screen delay - only affect debug mode
#define	FLASH_SCREEN_DELAY							3

//Define maximum of the height of user list view
#define MAXIMUM_HEIGHT_USERLISTVIEW					7

#define GLOBAL_SEARCH_CATEGORY_THUMBNAIL_COUNT      4
/**
 * Define kind of device for control point.
 */
#define MEDIA_DEVICE_UNKNOWN						0
#define MEDIA_DEVICE_SERVER							1
#define MEDIA_DEVICE_RENDERER						2
#define MEDIA_DEVICE_CLOUD							3
#define MEDIA_DEVICE_RESTREAMER						4
#define MEDIA_DEVICE_LOCAL							5
#define MEDIA_DEVICE_ABSTRACTSOURCE					6

#define	AUTO_LOGIN_DELAY							0.75

/*****************************************************************
 *							CONFIGURATION
 *****************************************************************/


#define CLOUD_SUPPORT_CONFIGURATIONS						@"cloud.supported.configs"
#define APP_VERSION_KEY										@"app.version"

/*****************************************************************
 *						DEFAULT CONFIGURATION
 *****************************************************************/
#define CONFIGURATION_FOLDER_NAME							@"Configuration"
#define CONFIGURATION_FILE_NAME								@"configuration"
#define CONFIGURATION_FILE_EXTENTION						@"plist"

#define IPHONE_SUPPORT_IMAGE_MIMETYPE_KEY					@"iphone.support.image.mimetype"
#define IPHONE_SUPPORT_TROUBLESHOOTING_LOG_KEY				@"iphone.support.troubleshooting.log"
#define IPHONE_SUPPORT_TROUBLESHOOTING_SELECTEDLEVEL_KEY	@"iphone.support.troubleshooting.selectedlevel"
#define IPHONE_SUPPORT_TROUBLESHOOTING_LEVELS_KEY			@"iphone.support.troubleshooting.levels"
#define IPHONE_SUPPORT_TROUBLESHOOTING_FILESIZE_KEY			@"iphone.support.troubleshooting.filesize"

#define CONFIGURATION_FILE_LASTCHANGED						@"configuration_file_lastchanged"
#define CLOUD_SUPPORT_ICONPERSONALIZATION_GUEST_KEY			@"cloud.support.iconpersonalization.guest"
#define CLOUD_SERVICE_WEBSITE_KEY							@"cloud.api.website.url"
#define CLOUD_SERVICE_HOSTNAME_PRODUCT_KEY					@"cloud.api.host.product"
#define CLOUD_SERVICE_HOSTNAME_DEVELOP_KEY					@"cloud.api.host.development"
#define CLOUD_SERVICE_HOSTNAME_KEY							@"cloud.api.host"
#define CLOUD_SERVICE_HOST_PORT_KEY							@"cloud.api.host.port"
#define CLOUD_SERVICE_BASE_URL_KEY							@"cloud.api.url.base"
#define CLOUD_SERVICE_BASE_HTTPS_URL_KEY					@"cloud.api.url.base.https"
#define CLOUD_SERVICE_DISCOVERY_AUDIENCE_KEY				@"cloud.discover.audience"
#define CLOUD_SERVICE_DISCOVERY_KEY							@"cloud.discover.url"
#define CLOUD_SERVICE_ALIVE_KEY								@"cloud.ping.url"
#define CLOUD_SERVICE_LOGIN_KEY								@"cloud.api.url.User.Login"
#define CLOUD_SERVICE_ENABLEPERSONALACCESS_KEY				@"cloud.api.url.User.EnablePersonalAccess.get"
#define CLOUD_SERVICE_SUBSCRIBE_SOURCE_RESULT_PREFIX_KEY	@"cloud.subscribe_search_source_result_prefix_key"
#define CLOUD_SERVICE_SUBSCRIBE_AUTHORIZE_RESULT_PREFIX_KEY	@"cloud.subscribe_search_authorize_result_prefix_key"
#define CLOUD_SERVICE_SUBSCRIBE_SOURCE_RESULT_KEY			@"cloud.subscribe_search_source_result_key"
#define CLOUD_SERVICE_SUBSCRIBE_SOURCE_NAME_START_KEY		@"cloud.subscribe_search_source_name_start_key"
#define CLOUD_SERVICE_SUBRCRIBE_SOURCE_NAME_END_KEY			@"cloud.subscribe_search_source_name_end_key"
#define	CLOUD_SERVICE_BROWSE_URL_KEY						@"cloud.api.url.Search.Browse"
#define	CLOUD_SERVICE_SEARCH_URL_KEY						@"cloud.api.url.Search.Search"
#define CLOUD_SERVICE_REGISTER_URL_KEY						@"cloud.register_url"
#define CLOUD_SERVICE_CLOUD_LOGIN_URL_KEY					@"cloud.cloud_login"
#define CLOUD_SERVICE_LOGIN_AS_GUEST_KEY					@"cloud.login_as_guest"
#define CLOUD_SERVICE_FORGOT_PASSWORD_URL_KEY				@"cloud.user_forgot_password"
#define CLOUD_SERVICE_REGISTER_SUCCESSFUL_URL_KEY			@"cloud.register_successful_url"
#define CLOUD_SERVICE_REGISTER_SUCCESSFUL_OLD_URL_KEY		@"cloud.register_successful_old_url"

#define CLOUD_SERVICE_REGISTRATION_URL						@"cloud.api.url.User.CreateUser"
#define CLOUD_SERVICE_GETGUIDECONTENT_KEY					@"cloud.api.url.Common.GetGuideContent"
#define CLOUD_SERVICE_PUBLISHSHARE_KEY						@"cloud.api.url.Publish.Share"
#define CLOUD_SERVICE_ACTIVITY_LOGGING_KEY					@"cloud.api.url.activity_logging"

#define CLOUD_RESOURCE_DLNA_SUPPORT_SPECIALDEVICE_KEY		@"dlna.support.specialdevice"
#define CLOUD_SUPPORT_CISCO_NAME_KEY						@"cloud.support.cisco.name"
#define CLOUD_SUPPORT_CISCO_MANUFACTURE_KEY					@"cloud.support.cisco.manufacture"
#define CLOUD_SUPPORT_CISCO_DEVICE_UUID_KEY					@"cloud.support.cisco.device_uuid"




#define TWITTER_SETTING_CHANGED_NOTIFICATION                @"eyecTwitterSettingChangedNotification"
/*****************************************************************
 *						QA CONFIGURATION
 *****************************************************************/
#define CLOUD_SUPPORT_QAMODE_KEY							@"cloud.supported.qamode"

/*****************************************************************
 *						ANALYTIC CONFIGURATION
 *****************************************************************/
#define ANALYTIC_LOG_EVENT_BATCH_SIZE_KEY					@"LOG_EVENT_BATCH_SIZE"
#define ANALYTIC_LOG_EVENT_REPORT_PERIODICITY_KEY			@"LOG_EVENT_REPORT_PERIODICITY"
#define ANALYTIC_LOG_EVENT_BACKGROUND_TIME_KEY				@"LOG_EVENT_BACKGROUND_TIME"

/*****************************************************************
 *						EXTENSION MIMETYPE CONFIGURATION
 *****************************************************************/
#define APP_SUPPORT_EXTENSION_MIMETYPE_KEY					@"app.support.extension_mimetype"


/*****************************************************************
 *						PARTNER CONFIGURATION
 *****************************************************************/
#define PARTNER_ID_KEY										@"partner_id"
#define PARTNER_ID_PATH										@"Partners/%@"
#define APP_LOGO_KEY										@"app.logo"
#define PARTNER_DEFAULT_NAME								@"default"




/*****************************************************************
 *						TROUBLESHOOTING CONFIGURATION
 *****************************************************************/
#define WRITELOG_TOKEN										@"@@bug"
#define EYECON_WRITELOG_FILENAME							@"APPO_log.txt"
#define EYECON_TROUBLESHOOTING_MESSAGE_NOTIFICATION			@"APPO_TROUBLESHOOTING_MESSAGE"

#define AUTHENTICATION_REQUEST_TIMEOUT						10.0
#define CLOUD_REQUEST_TIMEOUT								60.0
#define TAGLIST_CLOUD_REQUEST_TIMEOUT						60.0
#define CLOUD_HTTP_STATUS_OK								200


#define USER_AGENT_STRING									@"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2) Gecko/20100122 Fedora/3.6.1-1.fc13 Firefox/3.6 EyeconMobile/1.4"

#define IPAD_USER_AGENT_STRING								@"Mozilla/5.0 (iPad; U; CPU OS 4_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Mobile/8C134"

#define WEB_DEVICE_UA_CONFIG_NAME							@"RegistrationUA"

#define PINCH_ZOOM_IN_THRESH_HOLD							1.1
#define PINCH_ZOOM_OUT_THRESH_HOLD							0.9


// Interval for checking for Cloud Server availability - 2 minutes
#define CLOUD_SERVER_PING_INTERVAL							1000 * 60 * 2
// Counter for refreshing the web services configuration every 30 ping requests
#define WEB_SERVICES_REFRESH_COUNTER						30
#define CLOUD_SERVER_REQUEST_TIMEOUT						10

#ifdef DEBUG_MODE
#define PLAYBACK_TIMER_PREPARE_AUDIO				(IPADOS?15:10)
#define PLAYBACK_TIMER_PREPARE_VIDEO_LOCAL				(IPADOS ? 25 : 20)
#define PLAYBACK_TIMER_PREPARE_VIDEO_INTERNET		(IPADOS ? 25 : 20)
#else

#define PLAYBACK_TIMER_PREPARE_AUDIO				(IPADOS? 10 : 10)
#define PLAYBACK_TIMER_PREPARE_VIDEO_LOCAL				(IPADOS ? 15:15)
#define PLAYBACK_TIMER_PREPARE_VIDEO_INTERNET		(IPADOS ? 25 : 20)
#endif

#define USERLIST_FILENAME							@"users.xml"


/*****************************************************************
 *							UI SIZE
 *****************************************************************/
#define BLOCK_WIDTH									(!IPADOS ? 160 : 192)
#define BLOCK_MOVED_DISTANCE						(!IPADOS ? 50 : 60)
#define BLOCK_HEADER_HEIGHT							(!IPADOS ? 40 : 46)
#define BLOCK_TITLE_FONTSIZE						(!IPADOS ? 12 : 13)

// Blocks
#define IPAD_BLOCK_WIDTH_PORTRAIT					192
#define IPAD_BLOCK_HEIGHT_PORTRAIT					570

#define IPAD_BLOCK_WIDTH_LANDSCAPE					192
#define IPAD_BLOCK_HEIGHT_LANDSCAPE					384

#define IPAD_PREVIEW_WIDTH_PORTRAIT					768
#define IPAD_PREVIEW_HEIGHT_PORTRAIT				400

#define IPAD_PREVIEW_WIDTH_LANDSCAPE				1024
#define IPAD_PREVIEW_HEIGHT_LANDSCAPE				330

// IPAD Portrait Coordinates
#define USER_LIST_IMAGE_VIEW_FRAME					CGRectMake(603, 0, 165, 53)
#define LOGIN_USER_LIST_IMAGE_VIEW_FRAME			CGRectMake(604, 0, 164, 53)
#define LABEL_NICKNAME_FRAME						CGRectMake(603, 0, 138, 53)
#define USER_LIST_VIEW_FRAME						CGRectMake(603, 54, 140, 201)
#define LOGIN_USER_LIST_VIEW_FRAME					CGRectMake(604, 54, 164, 201)
#define CUSTOM_SCROLLVIEW_FRAME						CGRectMake(0, 54 + IPAD_PREVIEW_HEIGHT_PORTRAIT, 768, IPAD_BLOCK_HEIGHT_PORTRAIT)
#define PREVIEW_BLOCK_FRAME							CGRectMake(0, 54, IPAD_PREVIEW_WIDTH_PORTRAIT, IPAD_PREVIEW_HEIGHT_PORTRAIT)



// IPAD Landscape Coordinates
#define USER_LIST_IMAGE_VIEW_FRAME_LAND				CGRectMake(859 - 128, 0, 165, 53)
#define LOGIN_USER_LIST_IMAGE_VIEW_FRAME_LAND		CGRectMake(1024 - 164, 0, 164, 53)
#define LABEL_NICKNAME_FRAME_LAND					CGRectMake(859 - 128, 0, 138, 53)
#define USER_LIST_VIEW_FRAME_LAND					CGRectMake(859 - 128, 54, 140, 201)
#define LOGIN_USER_LIST_VIEW_FRAME_LAND				CGRectMake(1024 - 164, 54, 164, 201)
#define CUSTOM_SCROLLVIEW_FRAME_LAND				CGRectMake(128, 54 + IPAD_PREVIEW_HEIGHT_LANDSCAPE, 1024 - 256, IPAD_BLOCK_HEIGHT_LANDSCAPE)
#define PREVIEW_BLOCK_FRAME_LAND					CGRectMake(128, 54, IPAD_PREVIEW_WIDTH_LANDSCAPE - 256, IPAD_PREVIEW_HEIGHT_LANDSCAPE)

/*****************************************************************
 *							SHARE REQUEST
 *****************************************************************/
#define SHARING_ARGUMENT_PRIVACYSETTING_NAME				@"PrivacySettings"
#define TOKEN_START											@"TOKEN_START"
#define TOKEN_END											@"TOKEN_END"
#define SELF_ENDING_TOKEN									@"SELF_ENDING_TOKEN"
#define TOKEN_NOVALUE										@"TOKEN_NOVALUE"
#define ACTIONSHEET_MOREACTION								5050
#define ACTIONSHEET_SHAREACTION								5051

#define ACTIONSHEET_MOREACTION_SHARE						5052
#define ACTIONSHEET_MOREACTION_ADDREMOVEPICK				5053
#define ACTIONSHEET_MOREACTION_QUIT							5054



//define number of requested count for search and browse


#define CLICKABLE_HTML_TYPE								20
#define NONCLICKABLE_HTML_TYPE							30

#define PEOPLE_ONLINE_STATUS_THUMBNAIL_SIZE             12
#define PEOPLE_ONLINE_STATUS_THUMBNAIL_BIG_SIZE         28
#define DEFAULT_MEDIA_REQUEST_COUNT                     20
#define MAXIMUM_MEDIA_REQUEST_COUNT						200
#define EYECON_HTTP_TEMPLATE							@"appo://"
#define EYECON_HTTPS_TEMPLATE							@"appos://"

#define CLOUD_DISPATCH_WAIT_INTERVAL                    0.01



#define MAX_MULTITAG_ITEM   10
#define MAX_BULK_HASH_TAG   5

#define CLOUD_HTTP_CLIENT_UPGRADE_CODE                  426
#define CLOUD_HTTP_CLIENT_ERROR_CODE                    450


/******************** UPLOAD INFO *********************/
#define UPLOAD_BUFFER_LENGTH                            1024 * 8
#define UPLOAD_MULTIPART_BOUNDARY                       @"172kOJ-Wswzs9extYgGEj5J1BXDdPUtP"

