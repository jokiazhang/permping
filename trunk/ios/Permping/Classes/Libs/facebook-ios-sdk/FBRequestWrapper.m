//
//  FBRequestWrapper.m
//  Facebook Demo
//
//  Created by Andy Yanok on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBRequestWrapper.h"
#import "AppData.h"
#import "Taglist_CloudService.h"

static FBRequestWrapper *defaultWrapper = nil;

@interface FBRequestWrapper ()
- (void) getFacebookName;
@end

@implementation FBRequestWrapper
@synthesize isLoggedIn;
@synthesize loggedInName;

+ (id) defaultManager {
	
	if (!defaultWrapper)
		defaultWrapper = [[FBRequestWrapper alloc] init];
	
	return defaultWrapper;
}

- (void) setIsLoggedIn:(BOOL) _loggedIn {
	isLoggedIn = _loggedIn;
	
	if (isLoggedIn) {
        [self getFacebookName];
		[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:kUserServiceTypeFacebook forKey:kUserServiceTypeKey];
		[[NSUserDefaults standardUserDefaults] setObject:facebook.expirationDate forKey:@"exp_date"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else {
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"access_token"];
		[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"exp_date"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void) FBSessionBegin:(id<FBSessionDelegate>) _delegate showDialog:(BOOL)showDialog{
	
	if (facebook == nil) {
		facebook = [[Facebook alloc] init];
		
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
		NSDate *exp = [[NSUserDefaults standardUserDefaults] objectForKey:@"exp_date"];
		
		if (token != nil && exp != nil && [token length] > 2) {
			isLoggedIn = YES;
			facebook.accessToken = token;
            facebook.expirationDate = [NSDate distantFuture];
		} 
		
		
		[facebook retain];
	}
	
	NSArray * permissions = [NSArray arrayWithObjects:
							 @"publish_stream",
							 nil];
	
	//if no session is available login
	[facebook authorize:FB_APP_ID permissions:permissions delegate:_delegate showDialog:showDialog];	
}

- (void) FBLogout {
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"access_token"];
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"exp_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[facebook logout:self];
}

// Make simple requests
- (void) getFBRequestWithGraphPath:(NSString*) _path andDelegate:(id) _delegate {
	if (_path != nil) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		
		if (_delegate == nil)
			_delegate = self;
		
		[facebook requestWithGraphPath:_path andDelegate:_delegate];
	}
}

// Used for publishing
- (void) sendFBRequestWithGraphPath:(NSString*) _path params:(NSMutableDictionary*) _params andDelegate:(id) _delegate {
	
	if (_delegate == nil)
		_delegate = self;
	
	if (_params != nil && _path != nil) {
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[facebook requestWithGraphPath:_path andParams:_params andHttpMethod:@"POST" andDelegate:_delegate];
	}
}

#pragma mark -
#pragma mark FacebookSessionDelegate

- (void)fbDidLogin {
	isLoggedIn = YES;
	[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setObject:kUserServiceTypeFacebook forKey:kUserServiceTypeKey];
	[[NSUserDefaults standardUserDefaults] setObject:facebook.expirationDate forKey:@"exp_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	isLoggedIn = NO;
}

- (void)fbDidLogout {
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"access_token"];
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"exp_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	isLoggedIn = NO;
}

/**
 * Request the facebook name for the user
 * Response will be obtained on delegate
 */
- (void) getFacebookName {
    [facebook requestWithGraphPath:@"me?fields=name" andDelegate:self];  
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//NSLog(@"ResponseFailed: %@", error);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"Result: %@", result);
    NSDictionary *userInfo = (NSDictionary *)result;
    self.loggedInName = [userInfo objectForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setValue:self.loggedInName forKey:@"FacebookLoggedInUserName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FACEBOOK_DID_GET_USERNAME_NOTIFICATION" object:nil];
    //fb_id = [userInfo objectForKey:@"id"];
}


- (void) dealloc {
	[facebook release], facebook = nil;
	[super dealloc];
}

@end
