//
//  UploadPermResponse.m
//  Permping
//
//  Created by Andrew Duck on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UploadPermResponse.h"

@implementation UploadPermResponse
@synthesize permId;

- (void)dealloc {
    self.permId = nil;
    [super dealloc];
}

- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    [super onEndElement:path name:name text:text]; 
	if ([@"/respond/error/permId" isEqualToString:path]) 
	{
        self.permId = [[text copy] autorelease];
	}
   	return;
}

@end
