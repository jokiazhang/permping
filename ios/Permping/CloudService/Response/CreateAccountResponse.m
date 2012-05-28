//
//  CreateAccountResponse.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateAccountResponse.h"

@implementation CreateAccountResponse


- (void) onStartElement:(NSString *)path name:(NSString *)name
{
    [super onStartElement:path name:name];
	return;
}

- (void)foundCDATA:(NSData *)CDATABlock onPath:(NSString *)path
{
    return;
}

- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    [super onEndElement:path name:name text:text];        
	
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
