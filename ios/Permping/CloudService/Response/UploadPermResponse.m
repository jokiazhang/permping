//
//  UploadPermResponse.m
//  Permping
//
//  Created by Andrew Duck on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UploadPermResponse.h"

@implementation UploadPermResponse
@synthesize permId, permIphoneLink, permAndroidLink;

- (void)dealloc {
    self.permId = nil;
    [super dealloc];
}

- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    [super foundCDATA:CDATABlock onPath:path];
    
    if ([@"/respond/error/permIphoneLink" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        self.permIphoneLink = [[text copy] autorelease];
        [text release];
	} else if ([@"/respond/error/permAndroidLink" isEqualToString:path]) 
	{
        NSString *text = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        self.permAndroidLink = [[text copy] autorelease];
        [text release];
	}
    return;
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
