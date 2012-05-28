//
//  UserProfileModel.h
//  Permping
//
//  Created by MAC on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfileModel : NSObject
{
    NSString *userId;
    NSString *userName;
    NSString *userAvatar;
    NSString *userStatus;
    NSString *followingCount;
    NSString *followerCount;
    NSString *pinCount;
    NSString *likeCount;
    NSString *boardCount;
    NSMutableArray  *boards;
}

@property (nonatomic, copy)     NSString                    *userId;
@property (nonatomic, copy)     NSString                    *userName; 
@property (nonatomic, copy)     NSString                    *userAvatar;
@property (nonatomic, copy)     NSString                    *userStatus;
@property (nonatomic, copy)     NSString                    *followingCount;
@property (nonatomic, copy)     NSString                    *followerCount;
@property (nonatomic, copy)     NSString                    *pinCount;
@property (nonatomic, copy)     NSString                    *likeCount;
@property (nonatomic, copy)     NSString                    *boardCount;
@property (nonatomic, assign)   NSMutableArray              *boards;

@end
