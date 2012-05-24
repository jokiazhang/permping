/*
 *  Constant.h
 *  Eyecon
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

#define SPECIAL_SEPARATE_TEXT						@"__@@EYECON@@__"
#define APPLICATION_EYEC_UDN						@"APPLICATION_EYEC_UDN"

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
#define	LOGIN_REMEMBER_ME_PREF						@"EYECON_REMEMBER_ME_PREFERENCE"
#define LOGIN_REMEMBER_ME_USER_PREF					@"EYECON_REMEMBER_ME_USER"
#define LOGIN_REMEMBER_ME_PASSWORD_PREF				@"EYECON_REMEMBER_ME_PASSWORD"

#define	TAGLIST_LOGIN_REMEMBER_ME_PREF				@"TAGLIST_REMEMBER_ME_PREFERENCE"
#define TAGLIST_LOGIN_REMEMBER_ME_USER_PREF			@"TAGLIST_REMEMBER_ME_USER"
#define TAGLIST_LOGIN_REMEMBER_ME_PASSWORD_PREF		@"TAGLIST_REMEMBER_ME_PASSWORD"

#define WEB_DEVICES_COUNT							6

/*****************************************************************
 *							LOCAL LIBRARY
 *****************************************************************/
#define LOCAL_LIBRARY_MANUFACTURER					@"Apple"
#define LOCAL_LIBRARY_SEARCH_CAP_STRING				@"dc:title, upnp:album"
#define LOCAL_LIBRARY_THUMBNAIL_ICON				@"apple_logo_blue.png"

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

#define YOUTUBE_PREPROCESSOR_CONFIG_FILE_NAME				@"youtubepreprocessor"

#define APP_EYECONTROLPOINT_USERAGENT_KEY					@"app.eyecontrolpoint.useragent"
 

#define IPHONE_SUPPORT_IMAGE_MIMETYPE_KEY					@"iphone.support.image.mimetype"
#define IPHONE_SUPPORT_TROUBLESHOOTING_LOG_KEY				@"iphone.support.troubleshooting.log"
#define IPHONE_SUPPORT_TROUBLESHOOTING_SELECTEDLEVEL_KEY	@"iphone.support.troubleshooting.selectedlevel"
#define IPHONE_SUPPORT_TROUBLESHOOTING_LEVELS_KEY			@"iphone.support.troubleshooting.levels"
#define IPHONE_SUPPORT_TROUBLESHOOTING_FILESIZE_KEY			@"iphone.support.troubleshooting.filesize"
#define IPHONE_SUPPORT_SETTING_KEY							@"iphone.support.setting"
#define IPHONE_SUPPORT_LOCAL_SHARING_KEY					@"iphone.support.local.sharing"
 

#define DETECTLONGPRESS_TIMEOUT_KEY							@"detectlongpress_timeout"
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

//KEYS FOR LIBRARY
#define CLOUD_SUPPORT_DEVICE_CATEGORY_KEY					@"cloud.support.device.category"
#define CLOUD_SUPPORT_LIBRARY_INTERNET_KEY					@"cloud.supported.internetlibrary"
#define CLOUD_SUPPORT_LIBRARY_LOCAL_KEY						@"cloud.supported.locallibrary"
#define CLOUD_SUPPORT_LOCAL_CONTENT_KEY						@"cloud.supported.localcontent"
//KEYS FOR RENDERER
#define CLOUD_SUPPORT_RENDERER_LOCAL_KEY					@"cloud.supported.localrenderer"
//KEYS FOR ROVI
#define CLOUD_SUPPORT_ROVI									@"cloud.supported.rovi"
//KEYS FOR RECOMMENDAION
#define CLOUD_SUPPORT_RECOMMENDATION_KEY					@"cloud.support.recommendation"
//KEYS FOR SHARING
#define CLOUD_SUPPORT_SHARINGITEM_KEY						@"cloud.support.sharingitem"
//KEYS FOR TRACKING LOG
#define CLOUD_SUPPORT_TRACKINGLOG_KEY						@"cloud.supported.trackinglog"
//XML MIMETYPE
#define XML_MIMETYPE_REQUEST_KEY							@"xml_mimetype"


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
 *						REQUEST HEADER DIFINITION
 *****************************************************************/
#define X_EYECON_USER_ID									@"X-Eyecon-UserId"
#define TAGLIST_CLIENT_VERSION                              @"3.0"
#define CLIENT_VERSION										@"2.4"
#define PROTOCOL_VERSION_1									@"1.0"
#define PROTOCOL_VERSION_2									@"2.0"
#define VERSION_MAJOR										@"1"
#define VERSION_MINOR										@"0"


/*****************************************************************
 *						TROUBLESHOOTING CONFIGURATION
 *****************************************************************/
#define WRITELOG_TOKEN										@"@@bug"
#define EYECON_WRITELOG_FILENAME							@"EYECON_log.txt"
#define EYECON_TROUBLESHOOTING_MESSAGE_NOTIFICATION			@"EYECON_TROUBLESHOOTING_MESSAGE"

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


#define CLOUD_PERSONAL_ACCESS_ENABLE_URI
#define CLOUD_PERSONAL_ACCESS_ENABLE_SUCCESS_URI

//#define DEFAULT_PAGE_SIZE									15
#define SEARCH_CACHED_SIZE									10
#define SEARCH_TIMEOUT_TIMES								3

#define SEARCH_CACHED_SCALE_FACTOR							3

#define THUMBNAILCELL_REUSEIDENTIFIER						@"ThumbnailCell"
#define THUMBNAIL_BUNDLE_SIZE								3

//<?xml version=\"1.0\" encoding=\"utf-8\"?>
#define XML_START_DOCUMENT									@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
#define DIDL_LITE_OPEN										@"<DIDL-Lite xmlns=\"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:upnp=\"urn:schemas-upnp-org:metadata-1-0/upnp/\">"
#define DIDL_LITE_CLOSE										@"</DIDL-Lite>"

#define CONTENT_FORMAT_VIDEO_MP4							@"video/mp4"

#define	WEB_FILTER_PREFIX									@"cloud:"

#define SYNC_DURATION_INTERVAL								10 //10 seconds

#ifdef DEBUG_MODE
	#define PLAYBACK_TIMER_PREPARE_AUDIO				(IPADOS?15:10)
#define PLAYBACK_TIMER_PREPARE_VIDEO_LOCAL				(IPADOS ? 25 : 20)
#define PLAYBACK_TIMER_PREPARE_VIDEO_INTERNET		(IPADOS ? 25 : 20)
#else

#define PLAYBACK_TIMER_PREPARE_AUDIO				(IPADOS? 10 : 10)
#define PLAYBACK_TIMER_PREPARE_VIDEO_LOCAL				(IPADOS ? 15:15)
#define PLAYBACK_TIMER_PREPARE_VIDEO_INTERNET		(IPADOS ? 25 : 20)
#endif

typedef enum
{
	CONFIG_UNKNOWN,
	CONFIG_PLAYER,
	CONFIG_LIBRARY
}DEVICE_CONFIG_TYPE;

/*****************************************************************
 *							DATABASE
 *****************************************************************/
#define DATABASE_FILE_NAME                          @"eyecon.db"
#define MEDIAITEM_TABLE                             @"MEDIAITEM"
#define METADATA_TABLE                              @"METADATA"
#define MEDIARESOURCE_TABLE                         @"MEDIARESOURCE"
#define PICKLIST_TABLE                              @"PICKLIST"
#define PLUGLIST_TABLE                              @"PLUGLIST"
#define PLAYINGITEM_RENDERER						@"PLAYINGITEM_RENDERER"
#define SETTING_TABLE                              	@"SETTING"
#define LOGGEDTIP_TABLE                             @"LOGGEDTIP"

/*****************************************************************
 *							COMMON
 *****************************************************************/
#define PREPROCESSOR_CLASSES						@"HashRedirectPreprocessor,LocalResourceDLNAProcessor,LocalRestreamerProcessor,MmsToRtspProcessor,PCHRedirectProcessor,RawRestreamerPreprocessor,RedirectProcessor,TVersityPreprocessor,URLLengthLimitProcessor,WebResourceDLNAProcessor"
#define FILTER_CLASSES								@"WebFilter"

#define WEB_SOURCE_UDN                              @"eyecon:cloud_websource"
#define PEOPLE_SOURCE_UDN                           @"eyecon:people_source"
#define PEOPLE_FACEBOOK_SOURCE_UDN                  @"facebook:people_source"
#define MEDIALINK_SOURCE_UDN                        @"eyecon:medialink_source"
#define HASHTAG_SOURCE_UDN                          @"eyecon:hashtag_source"

#define EYE_WEBSERVER_START_PORT					9009
#define	PLAYBACKEVENT_UNKNOWN						-1
#define PLAYBACKEVENT_STOPPED						0
#define PLAYBACKEVENT_TRANSITIONING					1
#define PLAYBACKEVENT_PLAYING						2
#define PLAYBACKEVENT_PAUSED						3
#define PLAYBACKEVENT_OK							4
#define PLAYBACKEVENT_ERROR_OCCURRED				5
#define PLAYBACKEVENT_COMMAND_ERROR					6
#define PLAYBACKEVENT_CURRENT_TRACK_DURATION		7
#define PLAYBACKEVENT_CURRENT_TRACK_METADATA		8
#define PLAYBACKEVENT_STATUS_MEDIA_END				9
#define PLAYBACKEVENT_NO_MEDIA_PRESENT				10
#define PLAYBACKEVENT_MUTE							11
#define PLAYBACKEVENT_UNMUTE						12
#define PLAYBACKEVENT_PLAYINGIMAGE					13
#define PLAYBACKEVENT_VIDEO_DECODER_ERROR			14
#define PLAYBACKEVENT_RENDERINGCTRL_CHANGED			15
#define PLAYBACKEVENT_BEFOREPLAYING					16
#define PLAYBACKEVENT_DEVICE_ERROR					17
#define PLAYBACKEVENT_AVTRANSPORT					18
#define PLAYBACKEVENT_PLAYINGITEMSTATUS				19
#define PLAYBACKEVENT_WILLPLAYITEM					20
#define PLAYBACKEVENT_CANTPLAYMEDIAITEM				21
#define PLAYBACKEVENT_WILLPLAYMEDIALIST				22
#define PLAYBACKEVENT_OWNSTOPPLAYINGMEDIA           23
#define PLAYBACKEVENT_FINISHPLAYLIST                24


#define PLUGBLOCK_PLAYLIST_UPDATE					1
#define PLUGBLOCK_PLAYLIST_RESET_UPDATE				2
#define PLUGBLOCK_PLAYLIST_CURRENTPLAYINGITEM		3

#define PLAYLIST_COMMAND_GETPLAYLIST				1
#define PLAYLIST_COMMAND_ADD_ITEM					2
#define PLAYLIST_COMMAND_MOVE_ITEM					3
#define PLAYLIST_COMMAND_REMOVE_ITEM				4
#define PLAYLIST_COMMAND_CLEAR_ADD_ITEM				5

#define PICKLIST_COMMAND_GETPLAYLIST				1
#define PICKLIST_COMMAND_ADD_ITEM					2
#define PICKLIST_COMMAND_REMOVE_ITEM				3
#define PICKLIST_COMMAND_REMOVE_ITEM_BYSELF			4

#define PERIODIC_DISCOVERY_INTERVAL					180
#define PERIODIC_CHECK_DEVICESTATE_INTERVAL			15


#define SOURCE_LOCAL_TYPE							5000
#define SOURCE_PREMIUM_TYPE							5001

#define EXTENDED_METADATA_ACTORS_LIMIT				10

#define USERLIST_FILENAME							@"users.xml"
#define USERLIST_SAVEDNUMBER						5

#define DEFAULT_LOCAL_USERNAME_ID					@"EYECON_DEFAULT_USER_ID"
//#define DEFAULT_LOCAL_USERNAME						@"Guest"

#define USERLIST_LOGOUT_ID							@"EYECON_LOGOUT_ID"
#define USERLIST_LOGIN_ID							@"EYECON_LOGIN_ID"

#define USERLIST_SET_LOCAL_PASSWORD_ID				@"EYECON_SET_LOCAL_PASS_ID"
//#define USERLIST_SET_LOCAL_PASSWORD_NAME			@"Set password"

#define USERLIST_REGISTER_ID						@"EYECON_REGISTER_ID"
//#define USERLIST_REGISTER_NAME						@"Register"

#define USERLIST_SETTING_ID							@"USERLIST_SETTING_ID"

#define USERLIST_SENDLOG_ID							@"EYECON_SENDLOG_ID"
//#define USERLIST_SENDLOG_NAME						@"Debug"

#define USERLIST_ADMIN_ID							@"EYECON_ADMIN_ID"
//#define USERLIST_ADMIN_NAME							@"Admin"

#define USERLIST_QUIT_ID							@"EYECON_QUIT_ID"
//#define USERLIST_QUIT_NAME							@"Quit"

#define USERLIST_SENDFEEDBACK_ID					@"EYECON_SENDFEEDBACK_ID"

#define SPINNER_ROWID								@"NDEYECONSPINNERONROW"

#define CACHED_TAG_ID                               @"CACHEDTAG"

#define DEBUG_ALERT_VIEW							2000
#define DEBUG_MODE_ACTVIATE							100
#define DEBUG_MODE_ALREADY_ACTIVATED				101
#define DEBUG_MODE_DEACTVIATE						102

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
 *							MESSAGES
 *****************************************************************/
#define MSG_LOCAL_USER_FAIL							@"Local user login fail! Please check your password again!"
#define MSG_NETWORK_AVAIL_LOGIN_FAIL				@"Authenticate failed!"
#define MSG_NO_NETWORK_LOGIN_FAIL					@"Can't authenticate due to no network!"
#define MSG_NO_RESULT_FOUND							@"No results found."
#define MSG_NO_LOCAL_NETWORK						@"Wifi network not available! You'll not see any UpnP devices."


#define MSG_PERSONAL_ACCESS_ENABLE_SUCCESS			@"Personal data access setup for %@ is done"

#define MSG_PERSONAL_ACCESS_ENABLE_ERROR			@"Personal data access setup for %@ could not finish"

#define MSG_PERSONAL_ACCESS_DISABLE_SUCCESS			@"Disabled accessing to personal data for %@ successful"
#define MSG_PERSONAL_ACCESS_DISABLE_ERROR			@"Could not disable access to personal data for %@"

#define MSG_NO_PUBLIC_CONTENT_PERSONAL_DISABLE		@"%@ does not support public content browsing. Please enable personal access for content browsing."

#define MSG_NETWORK_CHANGE_TITLE					@"Network change"
#define MSG_NETWORK_CHANGE_DETAIL					@"You're using 3G network. Do you want continue to run this app?"



/*****************************************************************
 *							XML TOKEN
 *****************************************************************/
#define	LASTUSERS_TOKEN									@"LastUsers"
#define	USER_TOKEN										@"User"
#define	USERID_TOKEN									@"UserID"
#define	USERNAME_TOKEN									@"UserName"
#define	MATURITY_TOKEN									@"Maturity"
#define	NICKNAME_TOKEN									@"Nickname"
#define AUTHORIZER_TOKEN								@"Authorizer"
#define	LOGINDATE_TOKEN									@"LoginDate"
#define USERNAME_SHOWNGUIDELINE							@"ShowGuideLine"


/*****************************************************************
 *							LOCAL PLAYER
 *****************************************************************/
//UDN
#define LOCALPLAYER_UDN									([[UpnpLocalRenderer getInstance] getPlayerUuid])
//ACTION
#define LOCALPLAYER_CONTROL_PLAYITEM					1
#define LOCALPLAYER_CONTROL_PLAY						2
#define LOCALPLAYER_CONTROL_PAUSE						3
#define LOCALPLAYER_CONTROL_STOP						4
#define LOCALPLAYER_CONTROL_SEEK						5
#define LOCALPLAYER_CONTROL_RESUME						6
#define LOCALPLAYER_CONTROL_UPDATE_CURRENT_POSITION		7

#define LOCALPLAYERCONFIRMPLAY							201
//STATUS
#define LOCALPLAYER_STATUS_STOPPED						8
#define LOCALPLAYER_STATUS_PAUSED						9
#define LOCALPLAYER_STATUS_PLAYED						10
#define LOCALPLAYER_STATUS_ENDED						11
#define LOCALPLAYER_STATUS_TRANSITIONING				12
#define LOCALPLAYER_STATUS_OCCURRED_ERROR				13
#define LOCALPLAYER_STATUS_MEDIA_END					14
#define LOCALPLAYER_STATUS_FORCE_PAUSED					15
#define LOCALPLAYER_STATUS_FORCE_STOPPED				16

#define LOCALPLAYER_CONTROL_FORCE_PAUSE					17
#define LOCALPLAYER_CONTROL_FORCE_STOP					18
#define LOCALPLAYER_USER_CONFIRM_YES					19
#define LOCALPLAYER_USER_CONFIRM_NO						20
#define LOCALPLAYER_CONTROL_DURATION					21
#define LOCALPLAYER_CONTROL_ALLOWTOPLAY					22
#define LOCALPLAYER_CONTROL_PREV						23
#define LOCALPLAYER_CONTROL_NEXT						24
#define LOCALPLAYER_CONTROL_VOLUMECHANGED				25

#define LOCALPLAYER_REQUEST_STOP						@"LOCALPLAYER_REQUEST_STOP"
#define LOCALPLAYER_REQUEST_STOP_SUCCESSFULLY			@"LOCALPLAYER_REQUEST_STOP_SUCCESSFULLY"

#define LOCALPLAYER_TIMER_PREPARE_AUDIO					20
#define LOCALPLAYER_TIMER_PREPARE_VIDEO					40
#define LOCALPLAYER_TIMER_PREPARE_PHOTO					20

#define LOCALPLAYER_RECT_IPAD_PLAYBACK_VIEW_PORTRAIT	CGRectMake(0, 924, 768, 100)
#define LOCALPLAYER_RECT_IPAD_PLAYBACK_VIEW_LANDSCAPE	CGRectMake((1024 - 768) / 2, 668, 768, 100)

#define LOCALPLAYER_RECT_IPHONE_THUMB_AUDIO				CGRectMake(26, 56, 128, 128)
#define LOCALPLAYER_RECT_IPAD_THUMB_AUDIO_PORTRAIT		CGRectMake(34, 50, 200, 200)
#define LOCALPLAYER_RECT_IPAD_THUMB_AUDIO_LANDSCAPE		CGRectMake(34, 50, 200, 200)

#define LOCALPLAYER_RECT_IPHONE_MOVIEPLAYER				CGRectMake(10, 10, 460, 300)
#define LOCALPLAYER_RECT_IPAD_MOVIEPLAYER_PORTRAIT		CGRectMake(20, 20, 728, 984)
#define LOCALPLAYER_RECT_IPAD_MOVIEPLAYER_LANDSCAPE		CGRectMake(20, 20, 984, 728)

#define LOCALPLAYER_RECT_IPAD_SPINNER_PORTRAIT			CGRectMake(365, 300, 37, 37)
#define LOCALPLAYER_RECT_IPAD_SPINNER_LANDSCAPE			CGRectMake(493, 300, 37, 37)


/*****************************************************************
 *							MEDIAITEM SHARE USERGROUP
 *****************************************************************/
#define SHAREUSERGROUP_IPAD_TITLE_FRAME					CGRectMake(0, 0, 764, 70)
#define SHAREUSERGROUP_IPAD_TABLEVIEW_FRAME				CGRectMake(120, 64, 322, 250)
#define SHAREUSERGROUP_IPAD_RECOMMENDBTN_FRAME			CGRectMake(522, 64, 100, 40)
#define SHAREUSERGROUP_IPAD_CANCELBTN_FRAME				CGRectMake(522, 131, 100, 40)
#define SHAREUSERGROUP_IPAD_SPINNER_FRAME				CGRectMake(363, 169, 37, 37)

/*****************************************************************
 *							MEDIAITEM SHARE ITEM
 *****************************************************************/
#define SHAREITEM_IPAD_TITLE_FRAME						CGRectMake(0, 0, 764, 70)
#define SHAREITEM_IPAD_TABLEVIEW_FRAME					CGRectMake(120, 64, 322, 250)
#define SHAREITEM_IPAD_SHAREDBTN_FRAME					CGRectMake(522, 64, 100, 40)
#define SHAREITEM_IPAD_CANCELBTN_FRAME					CGRectMake(522, 131, 100, 40)
#define SHAREITEM_IPAD_SPINNER_FRAME					CGRectMake(363, 169, 37, 37)

#define SHAREITEM_IPHONE_TITLE_FRAME					CGRectMake(0, 0, 480, 30)
#define SHAREITEM_IPHONE_TABLEVIEW_FRAME				CGRectMake(40, 35, 400, 198)
#define SHAREITEM_IPHONE_SHAREDBTN_FRAME				CGRectMake(120, 238, 60, 37)
#define SHAREITEM_IPHONE_CANCELBTN_FRAME				CGRectMake(300, 238, 60, 37)
#define SHAREITEM_IPHONE_SPINNER_FRAME					CGRectMake(221, 120, 37, 37)


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


#define EYECON_TEMP_UPLOAD_FILE								@"eyeconsharelocal.tmp"

/*****************************************************************
 *							ADMIN
 *****************************************************************/
#define ADMIN_SETTING_AUDIENCE								100
#define ADMIN_SETTING_SERVER								101
//RECT
#define ADMIN_DETAIL_TABLE_NORMAL_RECT_IPHONE				CGRectMake(0, 44, 480, 276)
#define ADMIN_DETAIL_TABLE_EDIT_RECT_IPHONE					CGRectMake(0, 184, 480, 116)

#define ADMIN_DETAIL_TABLE_NORMAL_RECT_IPAD					CGRectMake(0, 44, 768, 1024)
#define ADMIN_DETAIL_TABLE_EDIT_RECT_IPAD					CGRectMake(0, 200, 768, 1024)


/*****************************************************************
 *							ANALYTICS EVENTS
 *****************************************************************/
#define ANALYTICEVENT_APPVERSION_KEY                        @"appVersion"
#define ANALYTICEVENT_USERSESSION_KEY                       @"userSessionId"
#define ANALYTICEVENT_CATEGORY_KEY							@"category"
#define ANALYTICEVENT_CATEGORY_VALUE_SESSIONLIFECYCLEEVENT	@"SessionLifecycleEvent"
#define ANALYTICEVENT_CATEGORY_VALUE_SEARCHACTIONEVENT		@"SearchActionEvent"
#define ANALYTICEVENT_CATEGORY_VALUE_PREVIEWEVENT			@"PreviewEvent"
#define ANALYTICEVENT_CATEGORY_VALUE_PLAYBACKDEVICEEVENT	@"PlaybackDeviceEvent"
#define ANALYTICEVENT_CATEGORY_VALUE_PLUGLISTEVENT			@"PlugListEvent"
#define ANALYTICEVENT_CATEGORY_VALUE_PICKLISTEVENT			@"PickListEvent"
#define ANALYTICEVENT_CATEGORY_VALUE_SOURCEACCOUNTMNGEVENT	@"SourceAccountManagementEvent"
#define ANALYTICEVENT_CATEGORY_VALUE_BROWSEEVENT			@"BrowseEvent"
#define ANALYTICEVENT_CATEGORY_VALUE_EXCEPTIONEVENT			@"ExceptionEvent"
#define ANALYTICEVENT_CATEGORY_VALUE_APPLIFECYCLEEVENT		@"ApplicationLifecycleEvent"

#define ANALYTICEVENT_DEVICEUNIQUEID_KEY					@"deviceUniqueId"
#define ANALYTICEVENT_EVENT_KEY								@"event"
#define ANALYTICEVENT_EVENT_VALUE_LOGIN						@"Login"
#define ANALYTICEVENT_EVENT_VALUE_LOGOUT					@"Logout"
#define ANALYTICEVENT_EVENT_VALUE_SEARCH					@"Search"
#define ANALYTICEVENT_EVENT_VALUE_PREVIEW					@"Preview"
#define ANALYTICEVENT_EVENT_VALUE_PLAY						@"Play"
#define ANALYTICEVENT_EVENT_VALUE_STOP						@"Stop"
#define ANALYTICEVENT_EVENT_VALUE_PAUSE						@"Pause"
#define ANALYTICEVENT_EVENT_VALUE_MUTE						@"Mute"
#define ANALYTICEVENT_EVENT_VALUE_VOLUME					@"Volume"
#define ANALYTICEVENT_EVENT_VALUE_ADD						@"Add"
#define ANALYTICEVENT_EVENT_VALUE_REMOVE					@"Remove"
#define ANALYTICEVENT_EVENT_VALUE_REORDER					@"Reorder"
#define ANALYTICEVENT_EVENT_VALUE_ASSOCIATE					@"Associate"
#define ANALYTICEVENT_EVENT_VALUE_DISASSOCIATE				@"Disassociate"
#define ANALYTICEVENT_EVENT_VALUE_BROWSE					@"Browse"
#define ANALYTICEVENT_EVENT_VALUE_EXCEPTION					@"Exception"
#define ANALYTICEVENT_EVENT_VALUE_INSTALL					@"Install"
#define ANALYTICEVENT_EVENT_VALUE_UPDATE					@"Update"
#define ANALYTICEVENT_EVENT_VALUE_UNINSTALL					@"UnInstall"

#define ANALYTICEVENT_DEVICEMANUFACTURER_KEY				@"deviceManufacturer"
#define ANALYTICEVENT_DEVICEMODEL_KEY						@"deviceModel"
#define ANALYTICEVENT_OPERATINGSYSTEM_KEY					@"operatingSystem"
#define ANALYTICEVENT_OSVERSION_KEY							@"osVersion"
#define ANALYTICEVENT_DATETIMESTAMP_KEY						@"datetimeStamp"
#define ANALYTICEVENT_LOGEVENTVERSION_KEY					@"logEventVersion"
#define ANALYTICEVENT_USERTYPE_KEY							@"userType"
#define ANALYTICEVENT_USERTYPE_VALUE_GUEST					@"guest"
#define ANALYTICEVENT_USERTYPE_VALUE_REGISTERED				@"registered"
#define ANALYTICEVENT_SESSIONDURATION_KEY					@"session duration"

#define ANALYTICEVENT_CONTENTTYPEFILTER_KEY					@"contentTypeFilter"
#define ANALYTICEVENT_CONTENTTYPEFILTER_VALUE_VIDEO			@"video"
#define ANALYTICEVENT_CONTENTTYPEFILTER_VALUE_AUDIO			@"audio"
#define ANALYTICEVENT_CONTENTTYPEFILTER_VALUE_PHOTO			@"photo"
#define ANALYTICEVENT_CONTENTTYPEFILTER_VALUE_ALL			@"all"

#define ANALYTICEVENT_INTERNET_KEY							@"internet"
#define ANALYTICEVENT_LOCAL_KEY								@"local"
#define ANALYTICEVENT_LOCALSOURCESLIST_KEY					@"localSourcesList"
#define ANALYTICEVENT_INTERNETSOURCESLIST_KEY				@"internetSourcesList"
#define ANALYTICEVENT_RESULTLISTSIZE_KEY					@"resultListSize"
#define ANALYTICEVENT_TIMETAKENT_KEY						@"timeTaken"

#define ANALYTICEVENT_MEDIASOURCETYPE_KEY					@"mediaSourceType"
#define ANALYTICEVENT_MEDIASOURCETYPE_VALUE_LOCAL			@"Local"
#define ANALYTICEVENT_MEDIASOURCETYPE_VALUE_INTERNET		@"Internet"

#define ANALYTICEVENT_PLAYBACKDEVICENAME_KEY				@"playbackDeviceName"
#define ANALYTICEVENT_PLAYBACKDEVICEMANUFACTURER_KEY		@"playbackDeviceManufacturer"
#define ANALYTICEVENT_PLAYBACKDEVICEMODEL_KEY				@"playbackDeviceModel"

#define ANALYTICEVENT_LOGINID_KEY							@"loginId"
#define ANALYTICEVENT_MEDIASOURCE_KEY						@"mediaSource"
#define ANALYTICEVENT_EXCEPTIONSTACKTRACE_KEY				@"exceptionStackTrace"

#define ANALYTICEVENT_ACTIONCATEGORY_KEY					@"actionCategory"
#define ANALYTICEVENT_ACTIONEVENT_KEY						@"actionEvent"
#define ANALYTICEVENT_ACTIONPARAMETERS_KEY					@"actionParameters"
#define ANALYTICEVENT_SOCIALNETWORK_KEY						@"socialnetwork"


/*****************************************************************
 *			TuneInPreprocessor & MmsToRtspProcessor
 *****************************************************************/
#define PROTOCOL_MMS    	@"mms://"
#define PROTOCOL_RTSP   	@"rtsp://"
#define PROTOCOL_RTMP		@"rtmp://"

#define M3U_MIMETYPE		@"audio/x-mpegurl"
#define PLS_MIMETYPE		@"audio/x-scpls"
#define ASX_MIMETYPE		@"video/x-ms-asf"
#define WAX_MIMETYPE		@"audio/x-ms-wax"
#define WVX_MIMETYPE		@"video/x-ms-wvx"
// There is no such mime-type but some Internet radio stations mistakenly use it for ASX playlist
#define ASX_MIMETYPE_BAD	@"audio/x-ms-asf"

#define TEXTHTML_MIMETYPE	@"text/html"
#define TEXTPLAIN_MIMETYPE	@"text/plain"

#define M3U_HEADER			@"#EXTM3U"
#define ASX_HEADER			@"<asx"
#define PLS_HEADER			@"[playlist]"

#define CYCLIC_REF			@"#!break"
#define STREAMING_URL		@"#!stream"

/*****************************************************************
 *			SHARING ERROR CODE
 *****************************************************************/
#define SHARING_CONTRAINT_ERROR_CODE_UNKNOWN								10
#define SHARING_CONTRAINT_ERROR_CODE_SOURCES								11
#define SHARING_CONTRAINT_ERROR_CODE_RESOURCE								12

#define SHARING_CONTRAINT_MEDIAITEM_KEY										@"CONTRAINT_MEDIAITEM"
#define SHARING_CONTRAINT_MEDIARESOURCE_KEY									@"CONTRAINT_MEDIARESOURCE"

/*****************************************************************
 *			FB LOGIN CONTROLLER
 *****************************************************************/
#define UI_ALERT_PROMPT_LOGIN_LOCAL		1
#define UI_ALERT_PROMPT_LOCAL_PASSWORD  2

#define FBLOGIN_CONTAINER_VIEW_FRAME			CGRectMake(0, 100, 768, 400)
#define FBLOGIN_CONTAINER_VIEW_FRAME_LAND		CGRectMake(128, 75, 768, 400)

#define FBLOGIN_LABEL_VERSION_FRAME				CGRectMake(121, 15, 89, 29)
#define FBLOGIN_LABEL_VERSION_FRAME_LAND		CGRectMake(145, 15, 89, 29)


/*****************************************************************
 *			AUTHORIZER NAME
 *****************************************************************/
#define AUTHORIZER_EYECON						@"eyecon"
#define AUTHORIZER_FACEBOOK						@"facebook"




/**
 * define resource of media item
 */
#define RESOURCE_UPNP								400
#define RESOURCE_CLOUD								401
#define RESOURCE_FAKE								402

#define REQUESTED_SUBSCRIPTION_PERIOD_SEC			180 //seconds
/**
 * Define events for device listener
 */
#define UPNP_DEVICE_CHANGE_NOTIFICATION					@"UPNP_DEVICE_CHANGE_NOTIFICATION"
#define UPNP_DEVICE_STATUS_EVENT						@"UPNP_DEVICE_STATUS"
#define UPNP_DEVICE_JOINED								@"UPNP_DEVICE_JOINED"
#define UPNP_DEVICE_LEFT								@"UPNP_DEVICE_LEFT"
#define UPNP_DEVICE_UPDATED								@"UPNP_DEVICE_UPDATED"

/**
 * Define events for event subscriber
 */
#define UPNP_EVENT_SUBSCRIBER_CHANGE_NOTIFICATION		@"UPNP_EVENT_SUBSCRIBER_CHANGE_NOTIFICATION"
#define CONTENT_DIRECTORY_STATE_CHANGED					@"CONTENT_DIRECTORY_STATE_CHANGED"
#define CONNECTION_MANAGER_STATE_CHANGED				@"CONNECTION_MANAGER_STATE_CHANGED"
#define RENDERING_CONTROL_STATE_CHANGED					@"RENDERING_CONTROL_STATE_CHANGED"
#define AV_TRANSPORT_STATE_CHANGED						@"AV_TRANSPORT_STATE_CHANGED"

#define SERVICE_NOTIFY_CHANGED							@"SERVICE_NOTIFY_CHANGED"

/**
 * Service of media device is changed
 */

#define MEDIA_SERVER_SERVICE_EVENT						@"MEDIA_SERVER_SERVICE_EVENT"
#define MEDIA_RENDERER_SERVICE_EVENT					@"MEDIA_RENDERER_SERVICE_EVENT"


/**
 * event type for send command from UIs to mobile manager
 */
#define COMMAND_ADD										@"COMMAND_ADD"
#define COMMAND_LOGIN									2000
#define COMMAND_GETLOCALSOURCE							2001
#define COMMAND_GETINTERNETSOURCE						2002
#define COMMAND_GETRENDERER								2003
#define COMMAND_BROWSE									2004
#define COMMAND_SEARCH									2005
#define COMMAND_PLAYBACK								2006
#define COMMAND_PLAYLIST								2007
#define COMMAND_LOGOUT									2008
#define COMMAND_PICKLIST								2009
#define COMMAND_PERSONAL_ACCESS_DISABLE					2010
#define COMMAND_REGISTER								2011
#define COMMAND_GETGUIDE								2012
#define COMMAND_CHECKNETWORK							2013
#define COMMAND_FETCH_RESULT							2014
#define COMMAND_BROWSE_PLUG								2015
#define COMMAND_GETPREMIUM_SOURCE						2016
#define COMMAND_SYNCPLUGLISTWITHUSERNAME				2017
#define COMMAND_LOCALPLAYER								2018
#define COMMAND_EXPOSELOCALPLAYER						2019
#define COMMAND_RESETPASS								2020
#define COMMAND_SEARCHMORE                              2021
#define COMMAND_USER_PROPERTY_SETTING                   2022
#define WRITELOG_ENABLE									@"WRITELOG_ENABLE"
/**
 * Define event type to exchange information between UIs Control and Mobile Manager
 */
#define WIFI_SERVICE_STOPPED							@"WIFI_SERVICE_STOPPED"
#define ACCESS_RIGHT_TO_PLAY							@"ACCESS_RIGHT_TO_PLAY"

#define MEDIA_SERVER_JOINED								@"MEDIA_SERVER_JOINED"
#define MEDIA_SERVER_LEFT								@"MEDIA_SERVER_LEFT"
#define MEDIA_RENDERER_JOINED							@"MEDIA_RENDERER_JOINED"
#define MEDIA_RENDERER_LEFT								@"MEDIA_RENDERER_LEFT"

#define WEB_SOURCE_PERSONAL_ACCESS_DISABLE				@"WEB_SOURCE_PERSONAL_ACCESS_DISABLE"
/**
 * Event for Login screen
 */
#define USER_LOGIN_SUCCESS								@"USER_LOGIN_SUCCESS"
#define LOCAL_USER_LOGIN_FAILED							@"LOCAL_USER_LOGIN_FAILED"
#define CLOUD_USER_LOGIN_FAILED							@"CLOUD_USER_LOGIN_FAILED"

#define CLOUD_USER_REGISTER_SUCCESSFULLY				@"CLOUD_USER_REGISTER_SUCCESSFULLY"
#define CLOUD_USER_REGISTER_FAILED						@"CLOUD_USER_REGISTER_FAILED"

#define LOCAL_SOURCE_RESPONSE							@"LOCAL_SOURCE_RESPONSE"
#define PREMIUM_SOURCE_RESPONSE							@"PREMIUM_SOURCE_RESPONSE"
#define INTERNET_SOURCE_RESPONSE						@"INTERNET_SOURCE_RESPONSE"
#define LOCAL_RENDERER_RESPONSE							@"LOCAL_RENDERER_RESPONSE"


#define BROWSE_DIRECTORY_STARTFROMDEVICE				@"BROWSE_DIRECTORY_STARTFROMDEVICE"
#define BROWSE_DIRECTORY_CLEAROLDRESULT					@"BROWSE_DIRECTORY_CLEAROLDRESULT"
#define BROWSE_DIRECTORY_SUCCESS						@"BROWSE_DIRECTORY_SUCCESS"
#define BROWSE_DIRECTORY_FAILED							@"BROWSE_DIRECTORY_FAILED"

#define BROWSEPLUG_DIRECTORY_CLEAROLDRESULT				@"BROWSEPLUG_DIRECTORY_CLEAROLDRESULT"
#define BROWSEPLUG_DIRECTORY_SUCCESS					@"BROWSEPLUG_DIRECTORY_SUCCESS"
#define BROWSEPLUG_DIRECTORY_FAILED						@"BROWSEPLUG_DIRECTORY_FAILED"


#define SEARCH_RESULT_CLEAR								@"SEARCH_RESULT_CLEAR"
#define SEARCH_RESULT_NEW_SEARCH						@"SEARCH_RESULT_NEW_SEARCH"
#define SEARCH_REQUEST_SUCCESS							@"SEARCH_REQUEST_SUCCESS"
#define SEARCH_REQUEST_RESULT_END						@"SEARCH_REQUEST_RESULT_END"
#define SEARCH_REQUEST_FAIL								@"SEARCH_REQUEST_FAIL"

#define PLAYBACK_RENDERINGCONTROL_CHANGE				@"PLAYBACK_RENDERINGCONTROL_CHANGE"
#define PLAYBACK_EVENT_CHANGE							@"PLAYBACK_EVENT_CHANGE"

#define LOCALPLAYBACK_RENDERINGCONTROL_CHANGE			@"LOCALPLAYBACK_RENDERINGCONTROL_CHANGE"
#define LOCALPLAYBACK_EVENT_CHANGE						@"LOCALPLAYBACK_EVENT_CHANGE"

#define RESET_CURRENT_PLAYING_ITEM						@"RESET_CURRENT_PLAYING_ITEM"
#define UPDATE_CURRENT_PLAYING_ITEM						@"UPDATE_CURRENT_PLAYING_ITEM"


#define RENDERER_PLAYBACK_OPEN_CLOSE					@"RENDERER_PLAYBACK_OPEN_CLOSE"
#define RENDERER_PLAYBACK_PLAY_NEWLIST					@"RENDERER_PLAYBACK_PLAY_NEWLIST"
#define PLUGBLOCK_UPDATE_PLAYLIST						@"PLUGBLOCK_UPDATE_PLAYLIST"
#define PLUGBLOCK_CLOSE_PLAYLIST						@"PLUGBLOCK_CLOSE_PLAYLIST"

#define LOGOUT_COMMAND									@"LOGOUT_COMMAND"

#define PICKLIST_MEDIAITEM_ADD							@"PICKLIST_MEDIAITEM_ADD"
#define PICKLIST_MEDIAITEM_REMOVE						@"PICKLIST_MEDIAITEM_REMOVE"
#define PICKLIST_MEDIAITEM_LOAD							@"PICKLIST_MEDIAITEM_LOAD"

#define GET_GUIDECONTENT_RESULT							@"GET_GUIDECONTENT_RESULT"

#define CHECK_NETWORK_RESPONSE							@"CHECK_NETWORK_RESPONSE"

//define number of requested count for search and browse
#define CELL_HEIGHT_SMALL                               40.0
#define CELL_HEIGHT_NORMAL								50.0
#define CELL_HEIGHT_AVERAGE								60.0
#define CELL_HEIGHT_LARGE								80.0
#define CELL_HEIGHT_SUPER_LARGE                         90.0

#define ACTIVITY_LINE_HEIGHT                            22
#define COMMENT_LINE_HEIGHT                             22
#define FILTER_CELL_CHECKBOXEMPTY_RECT					CGRectMake(255, 12, 20, 20)
#define ADDGROUP_CELL_CHECKBOXEMPTY_RECT				CGRectMake(285, 12, 20, 20)

#define DEFAULT_SEARCH_CHUNK							20
#define DEFAULT_BROWSE_PAGE								50

#define REQUESTED_COUNT									20
#define MAXIMUM_REQUEST_COUNT							1000
#define PREVIOUS_TEXT									@"...Previous"
#define NEXT_TEXT										@"Next..."

#define METADATA_TITLE									@"Title"
#define METADATA_SUMMARY								@"Summary"
#define METADATA_CREATOR								@"Creator"
#define METADATA_DATE									@"Date"
#define METADATA_ALBUM									@"Album"
#define METADATA_ARTIST									@"Artist"
#define METADATA_GENRE									@"Genre"
#define METADATA_ACTOR									@"Actor"
#define METADATA_AUTHOR									@"Author"
#define METADATA_PRODUCER								@"Producer"
#define METADATA_DIRECTOR								@"Director"
#define METADATA_DURATION								@"Duration"
#define METADATA_SIZE									@"Size"
#define METADATA_SOURCE									@"Source"
 
#define CLICKABLE_HTML_TYPE								20
#define NONCLICKABLE_HTML_TYPE							30

#define PEOPLE_ONLINE_STATUS_THUMBNAIL_SIZE             12
#define PEOPLE_ONLINE_STATUS_THUMBNAIL_BIG_SIZE         28
#define DEFAULT_MEDIA_REQUEST_COUNT                     20
#define MAXIMUM_MEDIA_REQUEST_COUNT						200
#define EYECON_HTTP_TEMPLATE							@"eyecon://"
#define EYECON_HTTPS_TEMPLATE							@"eyecons://"

#pragma mark -
#pragma mark FILTER KEYS
// User filter
#define FILTER_USER_EVERYONE_KEY					   	@"everyone"
#define FILTER_USER_HASHI_KEY					   		@"hashi"
#define FILTER_USER_ME_KEY					   			@"me"
#define FILTER_USER_ME_FRIENDS_FOLLOWING_KEY	   		@"me+friends+following"
#define FILTER_USER_GROUPS_KEY					   		@"groups"

// Media type filter
#define FILTER_MEDIA_EVERYTHING_KEY					   	@"everything"
#define FILTER_MEDIA_VIDEO_KEY					   		@"video"
#define FILTER_MEDIA_AUDIO_KEY					   		@"audio"
#define FILTER_MEDIA_PHOTO_KEY					   		@"photo"
#define FILTER_MEDIA_TAGLISTS_KEY					   	@"taglists"

#define DEFAULT_FILTER_USER_KEY                         FILTER_USER_ME_FRIENDS_FOLLOWING_KEY
#define DEFAULT_FILTER_MEDIA_KEY                        FILTER_MEDIA_EVERYTHING_KEY

// Media type Setting
#define SETTING_EVERYTHING_VALUE                         @"everything"
#define SETTING_WHAT_I_COMMENT_ON_AND_TAG_VALUE           @"commentsandtags"
#define SETTING_WHAT_I_SHARE_WITH_OTHERS_KEY		@"sharing"
#define SETTING_ALL_NOTHING_VALUE                    @"nothing"

//Syndication Setting
#define SETTING_SYNDICATETAGS_NAME                       @"SyndicateTags"
#define SETTING_SYNDICATECOMMENTS_NAME                   @"SyndicateComments"

// User Setting
#define SETTING_USER_EVERYONE_KEY					   	@"all"
#define SETTING_USER_HASHI_KEY					   		@"hashi"
#define SETTING_USER_ME_KEY					   			@"me"
#define SETTING_USER_FRIENDS_KEY					   	@"friends"
#define SETTING_USER_GROUPS_KEY					   		@"groups"
#define SETTING_USER_FOLLOWERS_KEY					   	@"followers"
#define SETTING_USER_EYEC_USERS_KEY					   	@"all"
#define SETTING_SOURCE_TWITTER                          @"twitter"
#define SETTING_SOURCE_FACEBOOK                          @"facebook"
//LOCALPLAYBACK NOTIFICATION
#define LOCALPLAYBACK_EYEC_NOTIFICATION					@"NDORTHERPLAYBACKFUNCTION"
#define LOCALPLAYBACK_EYEC_USERINFO_KEY					@"LOCALPLAYBACK_EYEC_USERINFO_KEY"

#pragma mark -
#pragma mark MENU
#define POPOVER_MENU_WIDTH                          140.0
#define POPOVER_ITEM_HEIGHT                         30.0
#define MENU_WIDTH                                  250.0
#define MENU_ITEM_HEIGHT                            50.0
#define MENU_BORDER_PADDING      3.0

#define CLOSE_BUTTON_WIDTH  30.0
#define CLOSE_BUTTON_HEIGHT 30.0

#pragma mark -
#pragma mark COLOR DEFINITION
/*****************************************************************
 *							COLOR
 *****************************************************************/

#define COLOR_ACTIVITY_NORMALTEXT_STR					@"#FF424242"
#define COLOR_ACTIVITY_LINKTEXT_STR						@"#FF0094D3"
#define COLOR_ACTIVITY_TAGLINKTEXT_STR					@"#FFF05A23"

#define COLOR_ALERTMODEL_NORMALTEXT_STR					@"#FFFFFFFF"
#define COLOR_ALERTMODEL_LINKTEXT_STR					@"#FF0094D3"

#define COLOR_SECTION_BG_STR                      		@"#FFE7E0C4"
#define COLOR_SECTION_TITLE_STR                   		@"#FF4D4D4D"
#define COLOR_SECTION_COUNT_STR                   		@"#FF797979"
#define COLOR_SECTION_ALPHABET_STR                  	@"#FF868686"
#define COLOR_SEPARATECELL_IPAD_STR                     @"#FF1F1E23"

#define COLOR_LIGHT_BLUE_STR							@"#FFCAE3F0"

#define COLOR_BG_STR									COLOR_LIGHT_BLUE_STR


#define COLOR_HASHTAG									[UIColor colorWithRed:(240.0f/255) green:(90.0f/255) blue:(35.0f/255) alpha:1.0f]
#define COLOR_DARKBLUE									[UIColor colorWithRed:(0.0f/255) green:(148.0f/255) blue:(211.0f/255) alpha:1.0f]
#define COLOR_NORMALTEXT								[UIColor colorWithRed:(66.0f/255) green:(66.0f/255) blue:(66.0f/255) alpha:1.0f]
#define COLOR_SEPARATECELL								[UIColor colorWithRed:(173.0f/255) green:(173.0f/255) blue:(173.0f/255) alpha:1.0f]
#define COLOR_HASHTAG_SELECTED							[UIColor colorWithRed:(210.0f/255) green:(202.0f/255) blue:(140.0f/255) alpha:1.0f]
#define COLOR_HASHTAG_UNSELECTED						[UIColor colorWithRed:(117.0f/255) green:(117.0f/255) blue:(117.0f/255) alpha:1.0f]
#define COLOR_CELL_EVEN									[UIColor colorWithRed:(252.0f/255) green:(247.0f/255) blue:(229.0f/255) alpha:1.0f]
#define COLOR_CELL_ODD									[UIColor colorWithRed:(233.0f/255) green:(225.0f/255) blue:(200.0f/255) alpha:1.0f]

#define COLOR_DARK_YELLOW                               [UIColor colorWithRed:(233.0f/255) green:(226.0f/255) blue:(200.0f/255) alpha:1.0f]
#define COLOR_LIGHT_YELLOW                              [UIColor colorWithRed:(253.0f/255) green:(248.0f/255) blue:(229.0f/255) alpha:1.0f]

#define COLOR_MORE_DARK_YELLOW                          [UIColor colorWithRed:(213.0f/255) green:(198.0f/255) blue:(141.0f/255) alpha:1.0f]

#define CLOUD_DISPATCH_WAIT_INTERVAL                    0.01

#define PAGE_VISITED_TIMELINE							@"timeline"
#define PAGE_VISITED_PLAYBACK							@"play"
#define PAGE_VISITED_TAGCONTENT							@"tagListContent"
#define PAGE_VISITED_MYHISTORY							@"myHistory"
#define PAGE_VISITED_FRIENDHISTORY						@"friendHistory"
#define PAGE_VISITED_SEARCHDETAIL						@"searchDetail"
#define PAGE_VISITED_BROWSESOURCE						@"sourceBrowsing"

#define MAX_MULTITAG_ITEM   10
#define MAX_BULK_HASH_TAG   5

#define CLOUD_HTTP_CLIENT_UPGRADE_CODE                  426
#define CLOUD_HTTP_CLIENT_ERROR_CODE                    450


/*****************************************************
                                TAGLISTS V2.0
 *****************************************************/
#define NAVIGATIONBAR_HEIGHT_DEFAULT                    30
#define NAVIGATIONBAR_BUTTON_TEXT_PADDINGLEFTRIGHT      20

#define PHONE_PLAYLIST_SPLITTER_BG                              @"#414244"
#define PHONE_PLAYLIST_SEPARATE_CELL_BG                         @"#414244"
#define PHONE_PLAYLIST_ODD_ITEM_BG                              @"#3b3d3c"
#define PHONE_PLAYLIST_EVEN_ITEM_BG                             @"#2e2e2e"

#define PHONE_TAGLIST_LIST_TAG_TEXT_COLOR                       @"#F15A29"
#define PHONE_TAGLIST_LIST_TAG_NUMITEM_COLOR                    @"#939598"


#define TAGLIST_COMMON_TABLE_ROW_HEIGHT                 50
#define TAGLIST_DEFAULT_PAGE_SIZE                       10

#define TAGLIST_GLOBAL_SEARCH_CATEGORY_PREVIEW_COUNT    7

#define SHARABLESOURCE_TAGLIST_UUID                     @"taglists"

/******************** LOGIN INFO TAG NAME *********************/
#define LOGIN_REQUEST_PARAM_USERNAME                    @"Username"
#define LOGIN_REQUEST_PARAM_PASSWORD                    @"Password"
#define LOGIN_REQUEST_PARAM_NEWPASSWORD                 @"NewPassword"
#define LOGIN_REQUEST_PARAM_DISPLAYNAME                 @"DisplayName"
#define LOGIN_REQUEST_PARAM_EMAIL                       @"Email"
#define LOGIN_REQUEST_PARAM_STATEMENT                   @"Statement"
#define LOGIN_REQUEST_PARAM_AUTHORIZER                  @"Authorizer"

/******************** UPLOAD INFO *********************/
#define UPLOAD_BUFFER_LENGTH                            1024 * 8
#define UPLOAD_MULTIPART_BOUNDARY                       @"172kOJ-Wswzs9extYgGEj5J1BXDdPUtP"
