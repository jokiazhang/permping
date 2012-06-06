//
//  Login_DataLoader.h
//  Permping
//
//  Created by Andrew Duck on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileResponse.h"

@interface Login_DataLoader : NSObject

- (UserProfileResponse*)loginWithUserInfo:(NSDictionary*)userInfo;

- (Taglist_CloudResponse*)logoutWithUserId:(NSString*)userId;

@end
