//
//  UserManager.m
//  Permping
//
//  Created by Phong Le on 5/24/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "UserManager.h"

static UserManager *userManagerInstance = nil;
@implementation UserManager


/**
 * create singleton instance for device manager
 */
+ (UserManager *)getInstance
{
	if (userManagerInstance)
	{
		return userManagerInstance;
	}
	@synchronized(self)
	{
		if (userManagerInstance == nil)
		{
			userManagerInstance = [[UserManager alloc] init];
		}
	}
	return userManagerInstance;
}
@end
