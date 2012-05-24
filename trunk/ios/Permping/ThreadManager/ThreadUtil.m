//
//  ThreadUtil.m
//  EyeconSocial
//
//  Created by PhongLe on 8/26/11.
//  Copyright 2011 Appo CO., LTD. All rights reserved.
//

#import "ThreadUtil.h"
#import "ThreadManager.h"

@implementation ThreadUtil

+ (BOOL)isAnyThreadRunning:(NSArray *)threads
{
    for (id<ThreadManagementProtocol> thread in threads) {
        if (![thread isFinished] && ![thread isCancelled]) {
            return YES;
        }
    }
    return NO;
}
@end
