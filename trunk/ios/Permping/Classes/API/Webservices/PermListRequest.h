//
//  PermListRequest.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerRequest.h"

@interface PermListRequest : ServerRequest {
    NSString *userId;
}

- (id)initWithUserId:(NSString*)in_userId;

@end
