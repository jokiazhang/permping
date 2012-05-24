//
//  ThreadObject.h
//  EyeconSocial
//
//  Created by PhongLe on 8/15/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ThreadObject;

@protocol ThreadManagementProtocol < NSObject>
@optional
- (void)start;
- (BOOL)isCancelled;
- (void)cancel;
- (BOOL)isExecuting;
- (BOOL)isFinished; 
- (BOOL)isReady; 
- (BOOL)shouldReleaseArgument;
@end


@interface ThreadObject : NSObject <ThreadManagementProtocol>{
    NSInvocationOperation       *operation;
}
@property (nonatomic, retain) NSInvocationOperation *operation;

@end

@interface ArgumentThreadObject : NSObject <ThreadManagementProtocol> 
{
    NSInvocationOperation   *operation;
    
}
@property (nonatomic, assign) NSInvocationOperation *operation;
@end
