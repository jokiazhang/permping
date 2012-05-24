//
//  YogoFlyModel.m
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize                    userId;
@synthesize                    userName; 
@synthesize                    userAvatar;
@synthesize                    userStatus;
- (id)init
{
	if (self = [super init])
	{
        
	}
	return self;
}

- (void)dealloc
{ 
    self.userId = nil;
    self.userName = nil; 
    self.userAvatar = nil;
    self.userStatus = nil;
    [super dealloc];
}
@end
