//
//  ThreadManager.m
//  EyeconSocial
//
//  Created by PhongLe on 8/11/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import "ThreadManager.h"

#define CONCURRENT_QUEUE_HIGH_MAX_OP            20
#define CONCURRENT_QUEUE_NORMAL_MAX_OP          50
#define CONCURRENT_QUEUE_LOW_MAX_OP             20


@implementation ThreadManager

- (void)dealloc
{
    [concurrentQueueHigh release];
    [concurrentQueueLow release];
    [serialQueue release];
    [mainQueue release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        concurrentQueueHigh = [[NSOperationQueue alloc] init];
        [concurrentQueueLow setMaxConcurrentOperationCount:CONCURRENT_QUEUE_HIGH_MAX_OP];
        
        concurrentQueueNormal = [[NSOperationQueue alloc] init];
        [concurrentQueueNormal setMaxConcurrentOperationCount:CONCURRENT_QUEUE_NORMAL_MAX_OP];
        
        concurrentQueueLow = [[NSOperationQueue alloc] init];
        [concurrentQueueLow setMaxConcurrentOperationCount:CONCURRENT_QUEUE_LOW_MAX_OP];
        
        serialQueue = [[NSOperationQueue alloc] init];
        [serialQueue setMaxConcurrentOperationCount:1];
        
        mainQueue = [[NSOperationQueue mainQueue] retain];
    }
    return self;
}

static ThreadManager *instance;
+ (ThreadManager *)getInstance
{
    if(instance)
    {
        return instance;
    }
    @synchronized (self)
    {
        if (!instance) {
        instance = [[ThreadManager alloc] init];
    }
    }
    return instance;
}
 
- (id<ThreadManagementProtocol>)dispatchToMainThreadWithTarget:(id)target selector:(SEL)selector dataObject:(id)object
{
    NSMethodSignature *sig = [target methodSignatureForSelector:selector];
    ArgumentThreadObject *argumentThreadObj = [[ArgumentThreadObject alloc] init];
    ThreadObject *manageThreadObj = [[ThreadObject alloc] init];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target]; 
    [invocation setSelector:selector];
    [invocation setArgument:&object atIndex:2];
    [invocation setArgument:&argumentThreadObj atIndex:3];
 
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
    argumentThreadObj.operation = operation;
    manageThreadObj.operation = operation;
    
    [mainQueue addOperation:operation];
    [operation release];
    [argumentThreadObj release];
    return [manageThreadObj autorelease];
}
- (id<ThreadManagementProtocol>)dispatchToConcurrentBackgroundHighPriorityQueueWithTarget:(id)target selector:(SEL)selector dataObject:(id)object
{
    NSMethodSignature *sig = [target methodSignatureForSelector:selector];
    ArgumentThreadObject *argumentThreadObj = [[ArgumentThreadObject alloc] init];
    ThreadObject *manageThreadObj = [[ThreadObject alloc] init];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target]; 
    [invocation setSelector:selector];
    [invocation setArgument:&object atIndex:2];
    [invocation setArgument:&argumentThreadObj atIndex:3];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
    argumentThreadObj.operation = operation;
    manageThreadObj.operation = operation;
    
    [concurrentQueueHigh addOperation:operation];
    [operation release];
    [argumentThreadObj release];
    return [manageThreadObj autorelease];
}
- (id<ThreadManagementProtocol>)dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:(id)target selector:(SEL)selector dataObject:(id)object
{
    NSMethodSignature *sig = [target methodSignatureForSelector:selector];
    ArgumentThreadObject *argumentThreadObj = [[ArgumentThreadObject alloc] init];
    ThreadObject *manageThreadObj = [[ThreadObject alloc] init];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target]; 
    [invocation setSelector:selector];
    [invocation setArgument:&object atIndex:2];
    [invocation setArgument:&argumentThreadObj atIndex:3];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
    argumentThreadObj.operation = operation;
    manageThreadObj.operation = operation;
    
    [concurrentQueueNormal addOperation:operation];
    [operation release];
    [argumentThreadObj release];
    return [manageThreadObj autorelease];
}
- (id<ThreadManagementProtocol>)dispatchToConcurrentBackgroundLowPriorityQueueWithTarget:(id)target selector:(SEL)selector dataObject:(id)object
{
    NSMethodSignature *sig = [target methodSignatureForSelector:selector];
    ArgumentThreadObject *argumentThreadObj = [[ArgumentThreadObject alloc] init];
    ThreadObject *manageThreadObj = [[ThreadObject alloc] init];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target]; 
    [invocation setSelector:selector];
    [invocation setArgument:&object atIndex:2];
    [invocation setArgument:&argumentThreadObj atIndex:3];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
    argumentThreadObj.operation = operation;
    manageThreadObj.operation = operation;
    
    [concurrentQueueLow addOperation:operation];
    [operation release];
    [argumentThreadObj release];
    return [manageThreadObj autorelease];
}

- (id<ThreadManagementProtocol>)dispatchToSerialBackgroundQueueWithTarget:(id)target selector:(SEL)selector dataObject:(id)object
{
    NSMethodSignature *sig = [target methodSignatureForSelector:selector];
    ArgumentThreadObject *argumentThreadObj = [[ArgumentThreadObject alloc] init];
    ThreadObject *manageThreadObj = [[ThreadObject alloc] init];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target]; 
    [invocation setSelector:selector];
    [invocation setArgument:&object atIndex:2];
    [invocation setArgument:&argumentThreadObj atIndex:3];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
    argumentThreadObj.operation = operation;
    manageThreadObj.operation = operation;

    [serialQueue addOperation:operation];
    [operation release];
    [argumentThreadObj release];
    return [manageThreadObj autorelease];
}
@end
