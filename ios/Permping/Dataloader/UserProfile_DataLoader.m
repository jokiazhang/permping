//
//  UserProfile_DataLoader.m
//  Permping
//
//  Created by MAC on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfile_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation UserProfile_DataLoader

- (UserProfileResponse*)getUserProfileWithId:(NSString*)userId loggedinId:(NSString*)loggedinId  {
    return [Taglist_CloudService getUserProfileWithId:userId loggedinId:loggedinId];
}

- (FollowResponse*)followUserId:(NSString *)userId followerId:(NSString *)followerId {
    return [Taglist_CloudService followUserId:userId followerId:followerId];
}

@end
