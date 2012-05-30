//
//  Login_DataLoader.m
//  Permping
//
//  Created by Andrew Duck on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Login_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation Login_DataLoader

- (UserProfileResponse*)loginWithUserInfo:(NSDictionary*)userInfo {
    return [Taglist_CloudService loginWithUserInfo:userInfo];
}

@end
