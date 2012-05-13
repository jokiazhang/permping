//
//  RequestManager.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestManager.h"
#import "NetworkManager.h"

NSString * const RequestManagerErrorDomain = @"RequestManagerErrorDomain";

@implementation RequestManager
@synthesize access;

#pragma mark Init

- (id) init{
	self = [super init];
	if (self != nil) {
		inProgressRequests = [[NSMutableArray alloc] initWithCapacity:5]; 
	}
	return self;
}

-(void) dealloc{
	[inProgressRequests release];
	[access release];
	[super dealloc];
}

#pragma mark API

-(void)performRequest:(ServerRequest *)in_request{
	NetworkStatus status = [[NetworkManager defaultNetworkManager] checkNetworkStatus];
	if (status == NotReachable) {
		[[NetworkManager defaultNetworkManager] alertIfNetworkReachable:status];
	} else {
		[inProgressRequests addObject:in_request];
        [in_request startWithTarget:self action:@selector(handleRequest:)];
	}
}

-(void)handleRequest:(ServerRequest *)in_request{
	[[NSNotificationCenter defaultCenter] postNotificationName:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:in_request];
	[inProgressRequests removeObject:in_request];
}

#pragma mark Singleton pattern

static RequestManager *sharedInstance = nil;

+ (RequestManager*)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
			[[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
