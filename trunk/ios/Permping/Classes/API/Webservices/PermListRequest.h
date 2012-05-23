//
//  PermListRequest.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerRequest.h"

typedef enum {
    PermListRequestTypePopular = 0,
    PermListRequestTypeFollowing,
    PermListRequestTypeBoards
}PermListRequestType;

extern NSString * const PermListRequestOptionIDKey;
extern NSString * const PermListRequestOptionUserNameKey;
extern NSString * const PermListRequestOptionPasswordKey;

@interface PermListRequest : ServerRequest {
    PermListRequestType type;
    NSString            *requestId;
    NSString            *userName;
    NSString            *password;
}

- (id)initWithType:(PermListRequestType)in_type options:(NSDictionary*)options;

@end
