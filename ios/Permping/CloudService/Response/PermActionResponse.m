//
//  PermActionResponse.m
//  Permping
//
//  Created by MAC on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermActionResponse.h"

@interface PermActionResponse ()
@property (nonatomic, retain) NSString *totalLikes;
@property (nonatomic, retain) NSString *status;
@end

@implementation PermActionResponse
@synthesize totalLikes, status;

- (void)dealloc {
    self.status = nil;
    self.totalLikes = nil;
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
    //NSLog(@"onEndElement:%@ name:%@ text:\"%@\"", path, name, text);
	if ([@"/response/like/totallikes" isEqualToString:path]) 
	{
        self.totalLikes = [[text copy] autorelease];
	} else if ([@"/response/like/status" isEqualToString:path]) {
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


@end
