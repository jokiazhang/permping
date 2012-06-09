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
#import "SA_OAuthTwitterEngine.h"

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
    [_engine release];
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
        UserProfileModel *lc_user = [response getUserProfile];
        if (lc_user && lc_user.userId) {
            self.user = lc_user;
            _isLogout = NO;
            [self saveState];
        }
        
        if (![threadObj isCancelled]) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               if (error) {
                                   [Utils displayAlert:[error localizedDescription] delegate:nil];
                               }
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:kCreateAccountFinishNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:!_isLogout], @"isSuccess", nil]];
                           });
        }
    }
    //[myLoader release];
    [pool drain];
}


- (void)createAccountWithUserInfo:(NSDictionary*)in_userInfo {
    if (in_userInfo == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreateAccountFinishNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:!_isLogout], @"isSuccess", nil]];
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
        UserProfileModel *lc_user = [response getUserProfile];
        if ((error && error.code == 200) || (lc_user && lc_user.userId)) {
            self.user = lc_user;
            _isLogout = NO;
            [self saveState];
        }
        
        if (![threadObj isCancelled]) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               if (error) {
                                   [Utils displayAlert:[error localizedDescription] delegate:nil];
                               }
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFinishNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:!_isLogout], @"isSuccess", nil]];
                           });
        }
    }
    //[myLoader release];
    [pool drain];
}

- (void)loginWithUserInfo:(NSDictionary*)in_userInfo {
    if (in_userInfo == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFinishNotification object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:!_isLogout], @"isSuccess", nil] userInfo:nil];
        return;
    }
    self.userInfo = in_userInfo;
    [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadLoginDataForMe:thread:) dataObject:[self getLoginDataLoader]];
}

- (void)loadLogoutDataForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        Taglist_CloudResponse *response = [(Login_DataLoader *)loader logoutWithUserId:self.user.userId];
        NSError *error = response.responseError;
        if (error && error.code == 200) {
            self.user = nil;
            _isLogout = YES;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (![threadObj isCancelled]) {
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               if (error) {
                                   [Utils displayAlert:[error localizedDescription] delegate:nil];
                               }
                               [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutFinishNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:_isLogout], @"isSuccess", nil]];
                           });
        }
    }
    //[myLoader release];
    [pool drain];
}

- (void)logout {
    if (!self.user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutFinishNotification object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:_isLogout], @"isSuccess", nil]];
    }
    
    // logout facebook
    [[FBRequestWrapper defaultManager] FBLogout];
    
    // logout twitter
    [_engine endUserSession];
    
    
    [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadLogoutDataForMe:thread:) dataObject:[self getLoginDataLoader]];
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
    if ([defaults objectForKey:@"kCurrentUser"]) {
        NSDictionary *userDict = [defaults objectForKey:@"kCurrentUser"];
        self.user = [[[UserProfileModel alloc] init] autorelease];
        self.user.userId = [userDict objectForKey:@"kUserID"];
        self.user.userName = [userDict objectForKey:@"kUserName"];
        self.user.userAvatar = [userDict objectForKey:@"kUserAvatar"];
        self.user.pinCount = [userDict valueForKey:@"kPins"];
        self.user.followerCount = [userDict valueForKey:@"kFollowers"];
        _isLogout = NO;
    }
    
    return;
}

- (void) saveState
{
    if (!_isLogout && self.user.userId) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        [userDict setObject:self.user.userId forKey:@"kUserID"];
        [userDict setObject:self.user.userName forKey:@"kUserName"];
        [userDict setObject:self.user.userAvatar forKey:@"kUserAvatar"];
        [userDict setObject:self.user.pinCount forKey:@"kPins"];
        [userDict setObject:self.user.followerCount forKey:@"kFollowers"];
        [defaults setObject:userDict forKey:@"kCurrentUser"];
        [defaults synchronize];
        [userDict release];
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
- (BOOL)twitterLoggedIn:(UIViewController*)controller {
    if (!_engine) {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        _engine.consumerKey = TWITTER_CONSUMER_KEY;
        _engine.consumerSecret = TWITTER_CONSUMER_SECRECT;
    }
    
    if ([_engine isAuthorized]) {
        return YES;
    }

    UIViewController *sacontroller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
    sacontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    sacontroller.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [controller presentModalViewController: sacontroller animated: YES];
    
    return NO;
}

#pragma mark - SA_OAuthTwitterEngineDelegatedelayedDismiss
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    NSLog(@"storing twitter login: %@", username);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: data forKey: @"authData"];
    
    if (!username  || [username isEqualToString:@""]) {
        [defaults removeObjectForKey:kUserServiceTypeKey];
    }
    
	[defaults synchronize];
    
    NSLog(@"cached login data: %@", data);
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    NSLog(@"twitter login: %@", username);
    
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocialNetworkDidLoginNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"isSuccess", kUserServiceTypeTwitter, kUserServiceTypeKey, nil]];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocialNetworkDidLoginNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"isSuccess", nil]];
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");

}

#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    
}

- (NSString*)oauthTokenType {
    NSString *oauthTokenType = [[NSUserDefaults standardUserDefaults] objectForKey:kUserServiceTypeKey];
    if (!oauthTokenType) {
        oauthTokenType = kUserServiceTypeNormal;
    }
    return oauthTokenType;
}

- (NSDictionary*)twDataInfo {
    NSString *twData = [[NSUserDefaults standardUserDefaults] objectForKey:@"authData"];
    if (twData) {
        NSArray *components = [twData componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSInteger i=0; i<components.count-1; i+=2) {
            NSString *key = [components objectAtIndex:i];
            NSString *value = [components objectAtIndex:i+1];
            [dict setObject:value forKey:key];
        }
        return [dict autorelease];
    }
    return nil;
}

- (NSString*)oauthToken {
    NSString *oauthTokenType = [self oauthTokenType];
    NSString *oauthToken = nil;
    if ([oauthTokenType isEqualToString:kUserServiceTypeFacebook]) {
        NSString *fbToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        if (fbToken) {
            oauthToken = fbToken;
        }
    } else if ([oauthTokenType isEqualToString:kUserServiceTypeTwitter]){
        oauthToken = [[self twDataInfo] valueForKey:@"oauth_token"];
    }
    return oauthToken;
}

- (NSString*)oauthTokenSecret {
    NSString *oauthTokenType = [self oauthTokenType];
    NSString *secrect = nil;
    if ([oauthTokenType isEqualToString:kUserServiceTypeTwitter]){
        secrect = [[self twDataInfo] valueForKey:@"oauth_token_secret"];
    }
    return secrect;
}

- (NSString*)oauthVerifier {
    NSString *oauthTokenType = [self oauthTokenType];
    if ([oauthTokenType isEqualToString:kUserServiceTypeTwitter]){
        return [[self twDataInfo] valueForKey:@"oauth_verifier"];
    }
    return nil;
}
@end
