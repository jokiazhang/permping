//
//  Taglist_CloudDirectBodyRequest.m
//  EyeconSocial
//
//  Created by PhongLe on 4/10/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "Taglist_CloudDirectBodyRequest.h"

@implementation Taglist_CloudDirectBodyRequest
@synthesize requestBody;

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc
{
    self.requestBody = nil;
    [super dealloc];
}

- (NSData *)requestToXMLBody
{
    return [self.requestBody dataUsingEncoding:NSUTF8StringEncoding];
}
@end
