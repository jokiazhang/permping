//
//  PermListRequest.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerRequest.h"

@interface PermListRequest : ServerRequest {
    NSString *accessToken;
}

- (id)initWithToken:(NSString*)in_token;

@end
