//
//  Taglist_CloudPagingRequest.m
//  EyeconSocial
//
//  Created by PhongLe on 3/23/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "Taglist_CloudPagingRequest.h"

@implementation Taglist_CloudPagingRequest
 
- (id)init
{
    if (self = [super init]) {
 
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)addRequestCount:(NSUInteger)count
{
    [self addParameter:@"count" value:[NSString stringWithFormat:@"%u", count]];
}
- (void)addNextItemId:(NSUInteger)nextItemId
{
    [self addParameter:@"nextItem" value:[NSString stringWithFormat:@"%u", nextItemId]];
}
@end
