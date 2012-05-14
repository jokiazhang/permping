//
//  LoginRequest.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerRequest.h"

@interface LoginRequest : ServerRequest

- (id)initWithUsername:(NSString*)username password:(NSString*)password accessToken:(NSString*)token;

@end
