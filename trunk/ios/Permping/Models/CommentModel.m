//
//  CommentModel.m
//  Permping
//
//  Created by Phong Le on 5/24/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
@synthesize                    commentUser;
@synthesize                    content; 
- (id)init
{
	if (self = [super init])
	{
        
	}
	return self;
}

- (void)dealloc
{ 
    self.commentUser = nil;
    self.content = nil; 
	[super dealloc];
}
@end
