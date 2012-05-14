//
//  FBRequestWrapper.h
//  Facebook Demo
//
//  Created by Andy Yanok on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

#define FB_APP_ID @"128520630567207"
//#define FB_API_KEY @"3269fff9ef3b6fc13255e670ebb44c4d"
#define FB_APP_SECRET @"405025e0794d09eb052346071007a64f"

@interface FBRequestWrapper : NSObject <FBRequestDelegate, FBSessionDelegate> 
{
	Facebook *facebook;
	BOOL isLoggedIn;
    NSString *loggedInName;
}
@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, retain) NSString *loggedInName;

+ (id) defaultManager;
- (void) setIsLoggedIn:(BOOL) _loggedIn;
- (void) FBSessionBegin:(id<FBSessionDelegate>) _delegate showDialog:(BOOL)showDialog;
- (void) FBLogout;
- (void) getFBRequestWithGraphPath:(NSString*) _path andDelegate:(id) _delegate;
- (void) sendFBRequestWithGraphPath:(NSString*) _path params:(NSMutableDictionary*) _params andDelegate:(id) _delegate;

@end
