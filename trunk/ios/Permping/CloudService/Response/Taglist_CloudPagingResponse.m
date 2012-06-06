//
//  Taglist_CloudPagingResponse.m
//  EyeconSocial
//
//  Created by PhongLe on 3/23/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "Taglist_CloudPagingResponse.h"

@implementation Taglist_CloudPagingResponse
@synthesize startIndex, totalResult, nextItemId;

- (id)init
{
    if (self = [super init]) {
        nextItemId = -1;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) onStartElement:(NSString *)path name:(NSString *)name
{
    [super onStartElement:path name:name];

	return;
}
- (void) onEndElement:(NSString *)path name:(NSString *)name text:(NSString *)text
{
    [super onEndElement:path name:name text:text];    
    
    if ([@"/Response/StartIndex" isEqualToString:path]) 
	{
		self.startIndex = [text intValue];
	} 
	else if ([@"/Response/TotalResults" isEqualToString:path]) 
	{
		self.totalResult = [text intValue];
	}
    else if ([@"/response/nextItem" isEqualToString:path]) {
        self.nextItemId = [text intValue];
    }
    
 	return;
}
- (void) onAttribute:(NSString *)path name:(NSString *)name value:(NSString *)value
{ 
    [super onAttribute:path name:name value:value];
    
    return;	   	
} 

@end
