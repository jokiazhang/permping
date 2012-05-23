//
//  AppData.m
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppData.h"
#import "Webservices.h"
#import "Constants.h"
#import "FBFeedPost.h"

@implementation AppData

@synthesize user=_user, password=_password;

// --------------------------------------------------------------------------
// singelton
// --------------------------------------------------------------------------
+ (AppData*)getInstance
{
	static AppData *instance = nil;
	if (instance == nil) {
		@synchronized(self) {
			if (instance == nil) {
				instance = [[AppData alloc] init];
			}
		}
	}
	return instance;
}



// --------------------------------------------------------------------------
// constructor
// --------------------------------------------------------------------------
-(id) init
{
	self = [super init];
	if (self != nil)
	{
        _user               = nil;
        _password           = nil;
		_isLogout           = NO;
        // read the user settings.
        [self restoreState];
	}
	
	return self;
}

// --------------------------------------------------------------------------
// destructor 
// --------------------------------------------------------------------------
- (void)dealloc
{
    [self saveState];
	
    [_user release];
    [_password release];
    [super dealloc];
}

- (BOOL) loginWithUsername:(NSString *)username password:(NSString *)password type:(LoginType)type accessToken:(NSString*)accessToken {
    if( !username || !password )
		return FALSE;  

	self.user.userName = username;
	self.password = password;
	
	NSURL *url = [NSURL URLWithString:[SERVER_API stringByAppendingString:@"/userservice/login"]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
	[request setHTTPMethod:@"POST"];
    NSString *body = nil;
    if (type == LoginTypeNormal) {
        body = [NSString stringWithFormat:@"username=%@&password=%@", self.user.userName, _password];
    } else if (type == LoginTypeFacebook) {
        body = [NSString stringWithFormat:@"access_token=%@&type=facebook", accessToken];
    } else if (type == LoginTypeTwitter) {
        body = [NSString stringWithFormat:@"access_token=%@&type=twitter", accessToken];
    }

	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSError *error = nil;
	NSURLResponse *response = nil;
	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"login response: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    
	[request release];
	if (!error) {
        // process data response
		return TRUE;
	}

	return FALSE;	
}

#pragma mark	-
#pragma mark		save / restore state
#pragma mark	-


- (void) restoreState
{
    self.user = nil;
	self.password = nil;
    
    //
    // Read the global preferences and set the app preferences 
    //
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *userDict = [defaults objectForKey:@"userkey"];
	
    self.user = [[[WSUser alloc] initWithDictionary:userDict] autorelease];
    self.password = @"";
    
    return;
	
}


- (void) saveState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.user dictionary] forKey:@"userkey"];
    [defaults synchronize];
    return;
}

- (BOOL)checkDidLogin {
    return NO;
}

#pragma mark	-
#pragma mark		Facebook
#pragma mark	-

- (BOOL)fbLoggedIn {
    // if the user is not currently logged in begin the session
	BOOL loggedIn = [[FBRequestWrapper defaultManager] isLoggedIn];
    //loggedIn = NO;
	if (!loggedIn) {
        FBFeedPost *post = [[FBFeedPost alloc] init];
        [post showLoginViewWithDelegate:self];
	}
    return loggedIn;
}

#pragma mark - FBFeedPostDelegate

- (void) failedToPublishPost:(FBFeedPost*) _post {
	[_post release];
}

- (void) finishedPublishingPost:(FBFeedPost*) _post {
	[_post release];
    
}

- (void) didLogin:(FBFeedPost *)_post {
    NSLog(@"Facebook login successed");
    [_post release];
}

- (void) didNotLogin:(FBFeedPost *)_post {
    NSLog(@"Facebook login failed");
    [_post release];
}

#pragma mark	-
#pragma mark		Twitter
#pragma mark	-
- (BOOL)twitterLoggedIn {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        if ([TWTweetComposeViewController canSendTweet]) {
            return YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No twitter account has been setup." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    } else {
        if (!twitterEngine) {
            twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
            twitterEngine.consumerKey = TWITTER_CONSUMER_KEY;
            twitterEngine.consumerSecret = TWITTER_CONSUMER_SECRECT;
        }
        
        if ([twitterEngine isAuthorized]) {
            // logged in
            return YES;
        }
        
        // show login diaglog
        if (saController) {
            [saController release];        
        }
        SA_OAuthTwitterController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twitterEngine delegate:self];
        if (controller) {
            saController = [controller retain];
        }
        [saController showLoginDialog];
    }
    
    return NO;
}



#pragma mark - SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"storeCachedTwitterOAuthData data - username: %@ - %@", data, username);
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}


#pragma mark - SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    
	NSLog(@"Authenticated with user %@", username);
    //[self showJoinViewControllerLoggedin:YES];
    
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    
	NSLog(@"Authentication Failure");
    
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    
	NSLog(@"Authentication Canceled");
}


#pragma mark - MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    
	NSLog(@"Request Suceeded: %@", connectionIdentifier);
    
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    
    NSLog(@"Request Failed: %@. Error: %@", connectionIdentifier, [error localizedDescription]);
    
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Recieved Status");
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Misc Info Received: %@", miscInfo);
}


@end
