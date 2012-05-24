//
//  CarManager.m
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "PermManager.h"

static PermManager *permManagerInstance = nil;
@implementation PermManager


/**
 * create singleton instance for device manager
 */
+ (PermManager *)getInstance
{
	if (permManagerInstance)
	{
		return permManagerInstance;
	}
	@synchronized(self)
	{
		if (permManagerInstance == nil)
		{
			permManagerInstance = [[PermManager alloc] init];
		}
	}
	return permManagerInstance;
}
@end
