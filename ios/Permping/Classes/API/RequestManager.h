//
//  RequestManager.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"

#define REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION @"RequestManagerRequestTerminated"

extern NSString * const RequestManagerErrorDomain;

enum RequestManagerErrors {
	RequestManagerErrorNoAuthenticationRequestProvided     = -1,
};


@interface RequestManager : NSObject {
	NSMutableArray *inProgressRequests;
	id access;
}

@property(nonatomic, retain) id access;

+(RequestManager *)sharedInstance;
-(void)performRequest:(ServerRequest *)in_request;

@end
