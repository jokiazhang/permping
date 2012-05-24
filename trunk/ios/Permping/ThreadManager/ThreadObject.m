//
//  ThreadObject.m
//  EyeconSocial
//
//  Created by PhongLe on 8/15/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import "ThreadObject.h"


@implementation ThreadObject
@synthesize operation;

- (void)dealloc
{
    self.operation = nil;
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
 
    }    
    return self;
}

- (void)start
{
    if (![operation isExecuting]) {
        [operation start];
    }
}
- (BOOL)isCancelled
{
    return [operation isCancelled];
}
- (void)cancel
{
    [operation cancel];
}
- (BOOL)isExecuting
{
    return [operation isExecuting];
}
- (BOOL)isFinished
{
    return [operation isFinished];
}
- (BOOL)isReady
{
    return [operation isReady];
}
 
- (BOOL)shouldReleaseArgument
{
    return [operation.invocation argumentsRetained];
}

@end

@implementation ArgumentThreadObject
@synthesize operation;

- (void)dealloc
{
    self.operation = nil;
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        
    }    
    return self;
}

- (void)start
{
    if (![operation isExecuting]) {
        [operation start];
    }
}
- (BOOL)isCancelled
{
    return [operation isCancelled];
}
- (void)cancel
{
    [operation cancel];
}
- (BOOL)isExecuting
{
    return [operation isExecuting];
}
- (BOOL)isFinished
{
    return [operation isFinished];
}
- (BOOL)isReady
{
    return [operation isReady];
}

- (BOOL)shouldReleaseArgument
{
    return [operation.invocation argumentsRetained];
}


@end
