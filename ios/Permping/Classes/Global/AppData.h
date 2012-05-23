//
//  AppData.h
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@class WSUser;

typedef enum {
    LoginTypeNormal,
    LoginTypeFacebook,
    LoginTypeTwitter
}LoginType;

@interface AppData : NSObject<SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate> {
    WSUser          *_user;
    NSString        *_password;
    
    SA_OAuthTwitterEngine       *twitterEngine;
    SA_OAuthTwitterController   *saController;
    
    BOOL            _isLogout;
}
@property (nonatomic, retain) WSUser *user;
@property (nonatomic, retain) NSString *password;

+ (AppData *)getInstance;

- (BOOL) loginWithUsername:(NSString *)username password:(NSString *)password type:(LoginType)type accessToken:(NSString*)accessToken;

- (void) restoreState;

- (void) saveState;

- (BOOL)fbLoggedIn;

- (BOOL)twitterLoggedIn;

- (BOOL)checkDidLogin;

@end
