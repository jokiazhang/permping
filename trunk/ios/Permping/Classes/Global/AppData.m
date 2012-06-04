//
//  AppData.m
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppData.h"
#import "Constants.h"
#import "Utils.h"
#import "FBFeedPost.h"
#import "ThreadManager.h"
#import "Taglist_CloudService.h"
#import "CreateAccount_DataLoader.h"
#import "CreateAccountResponse.h"
#import "Login_DataLoader.h"

@interface AppData ()
@property (nonatomic, retain)NSDictionary *userInfo;
@end

@implementation AppData

@synthesize user=_user;
@synthesize userInfo=_userInfo;

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
		_isLogout           = YES;
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
	[_userInfo release];
    [_user release];
    [super dealloc];
}

#pragma mark	-
#pragma mark		user service
#pragma mark	-
- (id)getCreateAccountDataLoader
{
    CreateAccount_DataLoader *loader = [[CreateAccount_DataLoader alloc] init];
    return [loader autorelease];
}

- (void)loadCreateAccountDataForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        CreateAccountResponse *response = [(CreateAccount_DataLoader *)loader createAccountWithUserInfo:self.userInfo];
        NSError *error = response.responseError;
        if (!error) {
            self.user = [response getUserProfile];
            //_isLogout = NO;
        }
        
        if (![threadObj isCancelled]) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               if (error) {
                                   [Utils displayAlert:[error localizedDescription] delegate:nil];
                               }
                               [[NSNotificationCenter defaultCenter] postNotificationName:kCreateAccountFinishNotification object:[NSNumber numberWithBool:(error==nil)] userInfo:nil];
                           });
        }
    }
    //[myLoader release];
    [pool drain];
}


- (void)createAccountWithUserInfo:(NSDictionary*)in_userInfo {
    if (in_userInfo == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreateAccountFinishNotification object:[NSNumber numberWithBool:_isLogout] userInfo:nil];
        return;
    }
    self.userInfo = in_userInfo;
    [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadCreateAccountDataForMe:thread:) dataObject:[self getCreateAccountDataLoader]];
}

- (id)getLoginDataLoader
{
    Login_DataLoader *loader = [[Login_DataLoader alloc] init];
    return [loader autorelease];
}

- (void)loadLoginDataForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        UserProfileResponse *response = [(Login_DataLoader *)loader loginWithUserInfo:self.userInfo];
        NSError *error = response.responseError;
        if (!error || error.code == 200) {
            self.user = [response getUserProfile];
            _isLogout = NO;
        }
        
        if (![threadObj isCancelled]) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               if (error) {
                                   [Utils displayAlert:[error localizedDescription] delegate:nil];
                               }
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFinishNotification object:[NSNumber numberWithBool:!_isLogout] userInfo:nil];
                           });
        }
    }
    //[myLoader release];
    [pool drain];
}

- (void)loginWithUserInfo:(NSDictionary*)in_userInfo {
    if (in_userInfo == nil) {
        return;
    }
    self.userInfo = in_userInfo;
    [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadLoginDataForMe:thread:) dataObject:[self getLoginDataLoader]];
}

- (void)logout {
    
}

#pragma mark	-
#pragma mark		save / restore state
#pragma mark	-

- (void) restoreState
{
    self.user = nil;
    
    //
    // Read the global preferences and set the app preferences 
    //
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"kUserID"]) {
        self.user = [[UserProfileModel alloc] init];
        self.user.userId = [defaults objectForKey:@"kUserID"];
        _isLogout = NO;
    }
    
    return;
	
}

- (void) saveState
{
    if (self.user) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.user.userId forKey:@"kUserID"];
        [defaults synchronize];
    }
    
    return;
}

- (BOOL)didLogin {
    return !_isLogout;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocialNetworkDidLoginNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"isSuccess", kUserServiceTypeFacebook, kUserServiceTypeKey, nil]];
    [_post release];
}

- (void) didNotLogin:(FBFeedPost *)_post {
    NSLog(@"Facebook login failed");
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocialNetworkDidLoginNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"isSuccess", nil]];
    [_post release];
}

#pragma mark	-
#pragma mark		Twitter
#pragma mark	-
- (BOOL)twitterLoggedIn {
    if (!twitterEngine) {
        twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        twitterEngine.consumerKey = TWITTER_CONSUMER_KEY;
        twitterEngine.consumerSecret = TWITTER_CONSUMER_SECRECT;
    }
    
    if ([twitterEngine isAuthorized]) {
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
    
    return NO;
}

#pragma mark - SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"storeCachedTwitterOAuthData data - username: %@ - %@", data, username);
	[defaults setObject: data forKey: @"authData"];
    [defaults setObject: kUserServiceTypeTwitter forKey:kUserServiceTypeKey];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}


#pragma mark - SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    
	NSLog(@"Authenticated with user %@", username);
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocialNetworkDidLoginNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"isSuccess", kUserServiceTypeTwitter, kUserServiceTypeKey, nil]];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocialNetworkDidLoginNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"isSuccess", nil]];
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


- (NSString*)oauthTokenType {
    NSString *oauthTokenType = [[NSUserDefaults standardUserDefaults] objectForKey:kOauthTokenTypeKey];
    if (!oauthTokenType) {
        oauthTokenType = kUserServiceTypeNormal;
    }
    return oauthTokenType;
    
}

- (NSString*)oauthToken {
    NSString *oauthTokenType = [self oauthTokenType];
    NSString *oauthToken = @"";
    if ([oauthTokenType isEqualToString:kUserServiceTypeFacebook]) {
        NSString *fbToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        if (fbToken) {
            oauthToken = fbToken;
        }
    } else if ([oauthTokenType isEqualToString:kUserServiceTypeTwitter]){
        NSString *twToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authData"];
        if (twToken) {
            oauthToken = twToken;
        }
    }
    return oauthToken;
}

@end
