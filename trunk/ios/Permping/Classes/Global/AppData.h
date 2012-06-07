//
//  AppData.h
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "UserProfileModel.h"
#import "SA_OAuthTwitterController.h"

#define kCreateAccountFinishNotification    @"CreateAccountFinishNotification"
#define kLoginFinishNotification            @"kLoginFinishNotification"
#define kSocialNetworkDidLoginNotification  @"SocialNetworkDidLoginNotification"
#define kLogoutFinishNotification           @"LogoutFinishNotification"

@interface AppData : NSObject <SA_OAuthTwitterControllerDelegate>{
    UserProfileModel        *_user;
    NSDictionary            *_userInfo;
    
    SA_OAuthTwitterEngine *_engine;
    
    BOOL            _isLogout;
    BOOL            _isCreatingAccount;
    BOOL            _isLogging;
}
@property (nonatomic, retain) UserProfileModel  *user;

+ (AppData *)getInstance;

- (void)createAccountWithUserInfo:(NSDictionary*)userInfo;

- (void)loginWithUserInfo:(NSDictionary*)userInfo;

- (void)logout;

- (void) restoreState;

- (void) saveState;

- (BOOL)fbLoggedIn;

- (BOOL)twitterLoggedIn:(UIViewController*)controller;

- (BOOL)didLogin;

- (NSString*)oauthTokenType;

- (NSString*)oauthToken;

- (NSString*)oauthTokenSecret;

@end
