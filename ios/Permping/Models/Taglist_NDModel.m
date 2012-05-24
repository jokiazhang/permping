//
//  Taglist_NDModel.m
//  EyeconSocial
//
//  Created by PhongLe on 3/30/12.
//  Copyright (c) 2012 Appo CO., LTD. All rights reserved.
//

#import "Taglist_NDModel.h"

@implementation Taglist_NDModel
@synthesize isFetching;
@synthesize nextItemId; 
@synthesize iRequestedCount;
@synthesize arrResults;

- (id)init
{
    self = [super init];
    if (self) {
        isFetching = NO;
        nextItemId = 0;
    }
    return self;
}

- (void)dealloc
{
    self.arrResults = nil;
    [super dealloc];
}

- (BOOL)isHasMoreResult
{
    return (nextItemId == -1) ? NO : YES;
}

- (void)resetModel
{
    self.arrResults = nil;
    self.nextItemId = 0; 
}
#pragma mark -
#pragma mark NSCopying methods
- (id)copyWithZone:(NSZone *)zone
{
    Taglist_NDModel *copiedModel = [[Taglist_NDModel alloc] init];
    copiedModel.isFetching = self.isFetching;
    copiedModel.nextItemId = self.nextItemId; 
    copiedModel.iRequestedCount = self.iRequestedCount;
    if (self.arrResults != nil) {
        copiedModel.arrResults = [NSArray arrayWithArray:self.arrResults];
    }
    return copiedModel;
}

@end
