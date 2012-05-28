//
//  Taglist_CloudRequestDispatcher.m
//  Eyecon
//
//  Created by PhongLe on 8/26/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import "Taglist_CloudRequestDispatcher.h"
#import "Taglist_CloudResponseParser.h" 
#import "Taglist_CloudResponse.h"
#import "Constants.h"
#import "Utility.h" 
#import "Taglist_AlertManager.h"
#import "Logger.h"

static Taglist_CloudRequestDispatcher *instance = nil;
 

@interface Taglist_CloudRequestDispatcher()
- (void)checkResponseTimeout:(NSTimer *)aTimer; 
//- (NSUInteger)silentLogin;
- (NSString *)setupRequestHeaders:(NSMutableURLRequest *)request additionalHeaders:(NSDictionary *)headers;
- (NSString *)changeEyeconTemplateToRealConfig:(NSString *)text;
@end

@implementation Taglist_CloudRequestDispatcher

- (void)dealloc
{
	[super dealloc];
}

- (id)init
{
    self = [super init];
    if (self != nil) {
 
    }
    return self;
}

+ (Taglist_CloudRequestDispatcher *)getInstance
{
	if (instance)
	{
		return instance;
	}
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[Taglist_CloudRequestDispatcher alloc] init];
        }
	}
	return instance;
}
 

- (void)dispatchRequest:(Taglist_CloudRequest *)request response:(id<Taglist_CloudResponseProtocol>)response
{
    NSURL	 *URL = nil;
    @try
    {
        NSString *strUrl = [request getTargetRequestURL];
        if (strUrl == nil)
        {
            [Logger logError:@"Taglist_CloudRequestDispatcher - dispatchRequest: target request URL is null"];
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Target request URL is nil" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"Taglists" code:100 userInfo:errorDetail];
            [response onParsingError:error];
			return;
        }
        
        URL = [NSURL URLWithString: strUrl];
        if (URL == nil)
        {
            [Logger logError:@"Taglist_CloudRequestDispatcher - dispatchRequest: could not initiate NSURL for targetURL:%@", strUrl];
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:[NSString stringWithFormat:@"Could not initiate NSURL for target %@", strUrl] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"Taglists" code:101 userInfo:errorDetail];
            [response onParsingError:error];
            return;
        }
        
        [Logger logDebug:@"Taglist_CloudRequestDispatcher - dispatchRequest for target URL %@", strUrl];
        NSMutableString *log = [NSMutableString string];
        [log appendFormat:@"Taglist_CloudRequestDispatcher - dispatchRequest for target URL:%@\n", [URL absoluteString]];
        
        NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval: TAGLIST_CLOUD_REQUEST_TIMEOUT];
        
        [log appendFormat:@"\tMethod : %@\n", request.method];
        if ([request.method isEqualToString:@"POST"])
        {
            [URLRequest setHTTPMethod:@"POST"];
            
            // tuan change
            // NSData *body = [request requestToXMLBody];
            NSData *body = [[request parameterListForGetMethod] dataUsingEncoding:NSUTF8StringEncoding];
            
            [log appendFormat:@"\tBodyMsg : %@\n", [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]];
            /* if ([Configuration applicationSupportGZIPCommunication]) {
                [URLRequest setHTTPBody:[body gzipDeflate]];
                [URLRequest setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
            }
            else */
            {
                [URLRequest setHTTPBody:body];
            }
        }
        else {
            [URLRequest setHTTPMethod:request.method];
        }
        
        //set up request
//        NSString *headerLog = [self setupRequestHeaders:URLRequest additionalHeaders:[request getAdditionalHeaders]];
//        [log appendString:headerLog];
        
        if (request.contentType != nil) {
            [URLRequest setValue:request.contentType forHTTPHeaderField:@"Content-Type"];
        }
        
        Taglist_CloudConnectionHandler *conHandler = [[Taglist_CloudConnectionHandler alloc] init];
        conHandler.currentRequest = request;
        conHandler.responseDelegate = response;
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:URLRequest delegate:conHandler startImmediately:YES];
        [NSTimer scheduledTimerWithTimeInterval:CLOUD_REQUEST_TIMEOUT target:self selector:@selector(checkResponseTimeout:) userInfo:conHandler repeats:NO];
        if(connection)
        {
            while(!conHandler.finishConnection)
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:CLOUD_DISPATCH_WAIT_INTERVAL]];
            }
            [log appendFormat:@"\tDispatch request executing thread exit successfully for target URL: %@", strUrl];
        }
        else
        {
            [log appendFormat:@"\tdispatchRequest function could not allocate NSURLConnection for target URL: %@", strUrl];
        }
        [Logger logInfo:log];
		
        if (conHandler.responseReceiveBegin == NO) 
        {
            [connection cancel];
        }
        [connection release];
        [conHandler release];
    }
    @catch (NSException * e)
    {
        if ([Logger isDebugEnabled])
        {
            NSMutableString *str = [NSMutableString string];
            [str appendFormat:@"%@ - dispatchRequest function throws exception\n", NSStringFromClass([self class])];
            [str appendFormat:@"\t\tname : %@. Reason : %@\n", [e name], [e reason]];
            if ([Utility isOS4Device]) {
                [str appendString:@"\tCallStackSymbol\n"];
                NSArray *stackSymbol = [e callStackSymbols];
                for (NSString *class in stackSymbol)
                {
                    [str appendFormat:@"\t\t%@\n", class];
                }
            }
            [Logger logDebug:str];
        }
    }
}

- (NSData *)sendSynchronizeRequestWithCloud:(Taglist_CloudRequest *)request response:(id<Taglist_CloudResponseProtocol>)response
{
	NSURL	*URL = nil;
	NSData	*data = nil;
    NSString *strUrl;
    NSUInteger httpCode = 0;
	@try {
        strUrl = [request getTargetRequestURL];
		if (strUrl == nil)
        {
            [Logger logError:@"Taglist_CloudRequestDispatcher - dispatchRequest: target request URL is null"];
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Target request URL is nil" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"Taglists" code:100 userInfo:errorDetail];
            [response onParsingError:error];
			return nil;
        }
        
        if ([strUrl hasPrefix:EYECON_HTTP_TEMPLATE] || [strUrl hasPrefix:EYECON_HTTPS_TEMPLATE]) {
            strUrl = [self changeEyeconTemplateToRealConfig:strUrl];
        }
        URL = [NSURL URLWithString: strUrl];
        
		if (URL == nil)
        {
            [Logger logError:@"Taglist_CloudRequestDispatcher - dispatchRequest: could not initiate NSURL for targetURL:%@", strUrl];
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:[NSString stringWithFormat:@"Could not initiate NSURL for target %@", strUrl] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"Taglists" code:101 userInfo:errorDetail];
            [response onParsingError:error];
			return nil;
        }
		
		NSMutableString *log = [NSMutableString string];
		[log appendFormat:@"Taglist_CloudRequestDispatcher - sendSynchronizeRequestWithCloud for request with targetURL is %@\n", [URL absoluteURL]];
		
		NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval:TAGLIST_CLOUD_REQUEST_TIMEOUT];
		
		[log appendFormat:@"\tMethod : %@\n", request.method];
		if ([request.method isEqualToString:@"POST"])
		{
            NSData *body = [request requestToXMLBody];
			[log appendFormat:@"\tBodyMsg : %@\n", [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]];
			[URLRequest setHTTPMethod:@"POST"];
            
            if ([Configuration applicationSupportGZIPCommunication]) {
                [URLRequest setHTTPBody:[body gzipDeflate]];
                [URLRequest setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
            }
            else
            {
                [URLRequest setHTTPBody:body];
            }
		}
		else {
			[URLRequest setHTTPMethod:[request.method uppercaseString]];
		}
        //set up request
//        NSString *headerLog = [self setupRequestHeaders:URLRequest additionalHeaders:[request getAdditionalHeaders]];
//        
//        [log appendString:headerLog];
        
		NSURLResponse *response = nil;
		NSError *error = nil;
		data = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&response error:&error];
		
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        httpCode = [httpResponse statusCode];
        
        //handle special http code for upgrade and error message
        //handle special http code for upgrade and error message
        if (httpCode == CLOUD_HTTP_CLIENT_UPGRADE_CODE) {        
            NSString *upgradeMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];        
            [self displayClientUpgradeMessageAndLaunchAppStore:upgradeMsg];
            [upgradeMsg release];
            return nil;
        } 
        else if(httpCode == CLOUD_HTTP_CLIENT_ERROR_CODE)
        {
            NSString *errorMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];        
            [self displayServerPushErrorMessage:errorMsg];
            [errorMsg release];
            return nil;
        }
        
		if (error == nil) {
			[log appendFormat:@"\tTaglist_CloudRequestDispatcher - sendSynchronizeRequestWithCloud request executing thread exit successfully for request:%@", [URL absoluteString]];
		}
		else {
			[log appendFormat:@"\tTaglist_CloudRequestDispatcher - sendSynchronizeRequestWithCloud function failed for request:%@. Reason:%@", [URL absoluteString], [error localizedFailureReason]];
		}
		[Logger logInfo:log];
	}
	@catch (NSException * e)
	{
		if ([Logger isDebugEnabled])
		{
			NSMutableString *str = [NSMutableString string];
			[str appendFormat:@"%@ - sendSynchronizeRequestWithCloud function throws exception\n", NSStringFromClass([self class])];
			[str appendFormat:@"\t\tname : %@. Reason : %@\n", [e name], [e reason]];
			if ([Utility isOS4Device]) {
				[str appendString:@"\tCallStackSymbol\n"];
				NSArray *stackSymbol = [e callStackSymbols];
				for (NSString *class in stackSymbol)
				{
					[str appendFormat:@"\t\t%@\n", class];
				}
			}
			[Logger logDebug:str];
		}
		data = nil;
	}
	@finally {
        return data;
	}
}

- (void)displayClientUpgradeMessageAndLaunchAppStore:(NSString *)message
{        
    [[Taglist_AlertManager getInstance] showAlertWithId:CLOUD_HTTP_CLIENT_UPGRADE_CODE title:NSLocalizedString(@"ID_TEXT_UPGRADE_REQUIRED", @"") body:message delegate:self cancelButtonTitle:NSLocalizedString(@"ID_TEXT_OK", @"") otherButtonTitle:nil];
    
}

- (void)displayServerPushErrorMessage:(NSString *)message
{
    [[Taglist_AlertManager getInstance] showAlertWithId:CLOUD_HTTP_CLIENT_ERROR_CODE title:NSLocalizedString(@"ID_TEXT_ERROR", @"")  body:message delegate:self cancelButtonTitle:NSLocalizedString(@"ID_TEXT_OK", @"") otherButtonTitle:nil]; 
}
#pragma mark -
#pragma mark Internal methods
- (void)checkResponseTimeout:(NSTimer *)aTimer
{
	Taglist_CloudConnectionHandler *connHandler = [aTimer userInfo];
	if (!connHandler.responseReceiveBegin) {
		[Logger logError:@"%@ - checkResponseTimeout - connection handler of target URL:%@", NSStringFromClass([self class]), [connHandler.currentRequest getTargetRequestURL]];
		connHandler.finishConnection = YES;
	}
}
 
- (NSString *)setupRequestHeaders:(NSMutableURLRequest *)request additionalHeaders:(NSDictionary *)headers
{ 
   
    return @"";
}

- (NSString *)changeEyeconTemplateToRealConfig:(NSString *)text
{
    NSString *str = [text stringByReplacingOccurrencesOfString:EYECON_HTTP_TEMPLATE withString:[NSString stringWithFormat:@"%@/", [Configuration getValueForKey:@"taglist.api.url.base"]]];
    return [str stringByReplacingOccurrencesOfString:EYECON_HTTPS_TEMPLATE withString:[NSString stringWithFormat:@"%@/", [Configuration getValueForKey:@"taglist.api.url.base.https"]]];
}
#pragma mark -
#pragma mark syndication alert
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CLOUD_HTTP_CLIENT_UPGRADE_CODE) {
        switch (buttonIndex) {
            case 0:
                //cancel
                [Utility openAppStoreForEyeC];
                break;
            case 1:
            default:
                
                break;
        }
    } 
}

//- (NSUInteger)silentLogin
//{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSUInteger statusCode = 200;
//    CloudLoginResponse *loginResponse = nil;
//    CloudUser *clouduser = [UserManager getInstance].currentUser;
//    
//    @synchronized(self) {
//        if ([clouduser isExpiredAccount]) {
//            //relogin
//            clouduser.isReLoginSucc = NO;
//            [Logger logInfo:@"%@ - Silent login with cloud server for user %@", NSStringFromClass([self class]), clouduser.userName];
//            CloudRequest *loginRequest = [[CloudRequest alloc] initWithCommand:@"Login" service:@"User"];
//            [loginRequest addParameter:@"UserName" value:clouduser.userName];
//            [loginRequest addParameter:@"Password" value:clouduser.password];
//            [loginRequest addParameter:@"Authorizer" value:clouduser.authorizer];
//            if ([clouduser.userName caseInsensitiveCompare:NSLocalizedString(@"ID_USERLIST_LOCAL_USERNAME_TEXT", @"")] == NSOrderedSame) {
//                [loginRequest addParameter:@"AutoLogin" value:@"false"];
//            }
//            else {
//                [loginRequest addParameter:@"AutoLogin" value:@"true"];
//            }
//            
//            loginResponse = [[CloudLoginResponse alloc] initWithCommand: @"Password" service:@"User"];
//            
//            [self internalDispatchRequest:loginRequest response:loginResponse];
//            
//            //get response code
//            statusCode = [loginResponse httpCode];
//            if([loginResponse isHTTPSuccess] && [loginResponse isStatusCodeSuccess])
//            {
//                [Logger logInfo:@"%@ - silent login success for user %@", NSStringFromClass([self class]), clouduser.userName];
//                
//                clouduser.strUserId = loginResponse.user.strUserId;
//                clouduser.isReLoginSucc = YES;
//            }
//            else
//            {
//                [Logger logInfo:@"%@ - silent login fail for user %@. Reason:%@", NSStringFromClass([self class]), clouduser.userName, loginResponse.responseMessage];
//                clouduser.strUserId = nil;
//            }
//			[clouduser saveLastLoginDate:[NSDate date]];
//
//            [loginRequest release];
//            [loginResponse release];
//        }
//        else {
//            //reset isReloginSucc in 2 minutes (heuristic)
//            NSDate *lastLoginDate = [UserPreference getLastLoginDateForUser:clouduser.userName];
//            if (-1 * [lastLoginDate timeIntervalSinceNow] >= 2 * 60) {
//                clouduser.isReLoginSucc = NO;
//            }
//        }
//        //check re-login 
//        if (![clouduser isExpiredAccount] && clouduser.isReLoginSucc == NO) {
//            if (isExpiredAlertShown == NO) {
//                //notify to UI to log out
//                UIScreenEvent *screenEvent = [[UIScreenEvent alloc] init];
//                screenEvent.screenTag = ALERT_LOGOUT_UNAUTHORIZED_ACCOUNT;
//                [[EventManager getInstance] callbackToChannelProtocolWithEvent:screenEvent channel:CHANNEL_UI];
//                [screenEvent release];
//                isExpiredAlertShown = YES;
//                
//                //set user to logged out state
//                [UserManager getInstance].loginStatus = NOT_LOGGEDIN;
//            }
//            statusCode = 0;
//        }
//    }
//    [pool drain];
//    return statusCode;
//}
 


@end


#pragma mark -
#pragma mark CloudConnectionHandler
@implementation Taglist_CloudConnectionHandler
@synthesize currentRequest, finishConnection, responseDelegate;
@synthesize responseReceiveBegin;
@synthesize receivedContentIsZipped;

- (void)dealloc
{
	self.responseDelegate = nil;
	self.currentRequest = nil;
 	[super dealloc];
}

- (id) init
{
    self = [super init];
	if(self)
	{
		receivedData = [[NSMutableData data] retain];
		finishConnection = NO;
		responseReceiveBegin = NO;
	}
	return self;
}



- (BOOL)connection:(NSURLConnection *)conn canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace 
{
    [Logger logDebug:@"CloudRequestDispatcher - canAuthenticateAgainstProtectionSpace for target URL %@", [self.currentRequest getTargetRequestURL]];
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	{ 
 
 
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
 
	}
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    [Logger logDebug:@"CloudRequestDispatcher - didReceiveResponse for target URL: %@.\nAll response headers: %@\nHTTP status code:%d", [self.currentRequest getTargetRequestURL], [(NSHTTPURLResponse *)response allHeaderFields], [(NSHTTPURLResponse *)response statusCode]];
    
	responseReceiveBegin = YES;
    [receivedData setLength:0];
    
 
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([responseDelegate isKindOfClass:[Taglist_CloudResponse class]]) {
        Taglist_CloudResponse *taglistResponse = (Taglist_CloudResponse *)responseDelegate;
        taglistResponse.httpCode = [httpResponse statusCode];
        NSDictionary *allHeaders = [httpResponse allHeaderFields];
        
        taglistResponse.responseHeaders = [NSDictionary dictionaryWithDictionary:allHeaders];
    }
    //iOS auto unzip
//	NSString *contentEncoding = [[httpResponse allHeaderFields] objectForKey:@"Content-Encoding"]; 
//    if (contentEncoding && [contentEncoding isEqualToString:@"gzip"]) {
//        receivedContentIsZipped = YES;
//    }
 
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [receivedData appendData:data];	
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
	[receivedData release];	
	receivedData = nil;
	
	[Logger logError:@"%@ - Connection failed for target URL %@! Error - %@ %@", NSStringFromClass([self class]), [self.currentRequest getTargetRequestURL], [error localizedDescription], 
		   [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
	
	finishConnection = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [Logger logDebug:@"Cloud Dispatch request result for target URL:%@\n%@\nTotal bytes received:%d", [currentRequest getTargetRequestURL], [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease], [receivedData length]];
	
    Taglist_CloudResponse *cloudResponse = (Taglist_CloudResponse *)responseDelegate;
    
    //handle special http code for upgrade and error message
    if (cloudResponse.httpCode == CLOUD_HTTP_CLIENT_UPGRADE_CODE) {        
        NSString *upgradeMsg = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];        
        [[Taglist_CloudRequestDispatcher getInstance] displayClientUpgradeMessageAndLaunchAppStore:upgradeMsg];
        [upgradeMsg release];
    } 
    else if(cloudResponse.httpCode == CLOUD_HTTP_CLIENT_ERROR_CODE)
    {
        NSString *errorMsg = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];        
        [[Taglist_CloudRequestDispatcher getInstance] displayServerPushErrorMessage:errorMsg];
        [errorMsg release];
    }
    else {
        if ([receivedData length] > 0 && !cloudResponse.keepPureData){
            if([@"JSON" compare:PARSERTYPE] != NSOrderedSame){
                Taglist_CloudResponseParser *parser = [[Taglist_CloudResponseParser alloc] init];
                [parser parseCloudResponse:receivedData withDelegate:responseDelegate];
                [parser release];
            }
            else {
                NSString *jsonString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                [cloudResponse parserWithJson:jsonString];
            }
            
        }	
        else {
            cloudResponse.pureResponseData = [NSData dataWithData:receivedData];
        }
    }
	[receivedData release];
	receivedData = nil;
	
	finishConnection = YES; 
	
	[pool drain];
}

- (NSURLRequest *)connection:(NSURLConnection *)conn willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (currentRequest.shouldFollowRedirect) return request;
	if (response) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary *allHeaders = [httpResponse allHeaderFields];
        
		if ([httpResponse statusCode] >= 301 && [httpResponse statusCode] <= 302 &&
            [responseDelegate isKindOfClass:[Taglist_CloudResponse class]] &&
            [allHeaders objectForKey:@"Location"] != nil) {
            Taglist_CloudResponse *taglistResponse = (Taglist_CloudResponse *)responseDelegate;
            taglistResponse.httpCode = [httpResponse statusCode];
            
            taglistResponse.responseHeaders = [NSDictionary dictionaryWithDictionary:allHeaders];
            
            [Logger logDebug:@"CloudRequestDispatcher - willSendRequest get redirect URL: %@", [taglistResponse.responseHeaders objectForKey:@"Location"]];
            [conn cancel];
            finishConnection = YES;
            return nil;
        }
	}
	return request;
}
@end
