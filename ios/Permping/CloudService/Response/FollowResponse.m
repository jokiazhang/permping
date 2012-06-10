//
//  FollowResponse.m
//  Permping
//
//  Created by MAC on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FollowResponse.h"

@interface FollowResponse ()
@property (nonatomic, retain) NSString *totalFollows;
@property (nonatomic, retain) NSString *status;
@end

@implementation FollowResponse

@synthesize totalFollows, status;

- (void)dealloc {
    self.status = nil;
    self.totalFollows = nil;
    [super dealloc];
}

- (void) onStartElement:(NSString *)path name:(NSString *)name
{
    [super onStartElement:path name:name];
	return;
}

- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    [super foundCDATA:CDATABlock onPath:path];
    return;
}

- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    [super onEndElement:path name:name text:text];        
	if ([@"/response/totalfollows" isEqualToString:path]) 
	{
        self.totalFollows = [[text copy] autorelease];
	} else if ([@"/response/status" isEqualToString:path]) {
        self.status = [[text copy] autorelease];
	}
   	return;
}
- (void) onAttribute:(NSString *)path name:(NSString *)name value:(NSString *)value
{ 
    [super onAttribute:path name:name value:value];
    
    return;	   	
} 

- (void) onParsingError:(NSError *)error
{
    [super onParsingError:error];
    NSLog(@"ERRRRRO = %@",error.description);
}

/*
 <response>
 <totalfollows>3</totalfollows>
 <status>1</status>
 </response>
 */

@end
