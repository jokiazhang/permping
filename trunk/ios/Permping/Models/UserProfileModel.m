//
//  UserProfileModel.m
//  Permping
//
//  Created by MAC on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfileModel.h"

@implementation UserProfileModel

@synthesize userId, userName, userAvatar, userStatus, followingCount, followerCount, pinCount, likeCount, boardCount, boards;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.userId = nil;
    self.userName = nil;
    self.userAvatar = nil;
    self.userStatus = nil;
    self.followingCount = nil;
    self.followerCount = nil;
    self.pinCount = nil;
    self.likeCount = nil;
    self.boardCount = nil;
    self.boards = nil;
    [super dealloc];
}
@end
