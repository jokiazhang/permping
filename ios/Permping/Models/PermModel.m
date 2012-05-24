//
//  CarModel.m
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "PermModel.h"

@implementation PermModel
@synthesize                    permUser;
@synthesize                    permId; 
@synthesize                    permDesc;
@synthesize                    permCategory;
@synthesize                    permImage; 
@synthesize                    permRepinCount;
@synthesize                    permLikeCount;
@synthesize                    permCommentCount; 
@synthesize                    permComments;

- (id)init
{
	if (self = [super init])
	{
        
	}
	return self;
}

- (void)dealloc
{ 
    self.permUser = nil;
    self.permId = nil; 
    self.permDesc = nil;
    self.permCategory = nil;
    self.permImage = nil; 
    self.permRepinCount = nil;
    self.permLikeCount = nil;
    self.permCommentCount = nil; 
    self.permComments = nil;
	[super dealloc];
}

@end
