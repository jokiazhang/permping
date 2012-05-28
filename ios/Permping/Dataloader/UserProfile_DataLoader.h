//
//  UserProfile_DataLoader.h
//  Permping
//
//  Created by MAC on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileResponse.h"

@interface UserProfile_DataLoader : NSObject

- (UserProfileResponse*)getUserProfileWithId:(NSString*)userId;

@end
