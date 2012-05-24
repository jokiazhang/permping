//
//  ThreadManager.h
//  EyeconSocial
//
//  Created by PhongLe on 8/11/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadObject.h"

@interface ThreadManager : NSObject {
    NSOperationQueue        *concurrentQueueHigh;
    NSOperationQueue        *concurrentQueueNormal;
    NSOperationQueue        *concurrentQueueLow;
    
    NSOperationQueue        *serialQueue;
    NSOperationQueue        *mainQueue;
}

+ (ThreadManager *)getInstance;

- (id<ThreadManagementProtocol>)dispatchToMainThreadWithTarget:(id)target selector:(SEL)selector dataObject:(id)object;

- (id<ThreadManagementProtocol>)dispatchToConcurrentBackgroundHighPriorityQueueWithTarget:(id)target selector:(SEL)selector dataObject:(id)object;
- (id<ThreadManagementProtocol>)dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:(id)target selector:(SEL)selector dataObject:(id)object;
- (id<ThreadManagementProtocol>)dispatchToConcurrentBackgroundLowPriorityQueueWithTarget:(id)target selector:(SEL)selector dataObject:(id)object;
- (id<ThreadManagementProtocol>)dispatchToSerialBackgroundQueueWithTarget:(id)target selector:(SEL)selector dataObject:(id)object;

@end
