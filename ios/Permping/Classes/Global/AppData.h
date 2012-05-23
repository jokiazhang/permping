//
//  AppData.h
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WSUser;

typedef enum {
    LoginTypeNormal,
    LoginTypeFacebook,
    LoginTypeTwitter
}LoginType;

@interface AppData : NSObject {
    WSUser          *_user;
    NSString        *_password;
    BOOL            _isLogout;
}
@property (nonatomic, retain) WSUser *user;
@property (nonatomic, retain) NSString *password;

+ (AppData *)getInstance;

- (BOOL) loginWithUsername:(NSString *)username password:(NSString *)password type:(LoginType)type accessToken:(NSString*)accessToken;

- (void) restoreState;

- (void) saveState;
@end
