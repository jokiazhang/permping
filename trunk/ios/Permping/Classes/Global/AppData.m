//
//  AppData.m
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppData.h"
#import "Webservices.h"
#import "Constants.h"
#import "XMLReader.h"

@implementation AppData

@synthesize user=_user, password=_password;

// --------------------------------------------------------------------------
// singelton
// --------------------------------------------------------------------------
+ (AppData*)getInstance
{
	static AppData *instance = nil;
	if (instance == nil) {
		@synchronized(self) {
			if (instance == nil) {
				instance = [[AppData alloc] init];
			}
		}
	}
	return instance;
}



// --------------------------------------------------------------------------
// constructor
// --------------------------------------------------------------------------
-(id) init
{
	self = [super init];
	if (self != nil)
	{
        _user               = nil;
        _password           = nil;
		_isLogout           = NO;
        // read the user settings.
        [self restoreState];
	}
	
	return self;
}

// --------------------------------------------------------------------------
// destructor 
// --------------------------------------------------------------------------
- (void)dealloc
{
    [self saveState];
	
    [_user release];
    [_password release];
    [super dealloc];
}

- (BOOL) loginWithUsername:(NSString *)username password:(NSString *)password type:(LoginType)type accessToken:(NSString*)accessToken {
    if( !username || !password )
		return FALSE;  

	self.user.userName = username;
	self.password = password;
	
	NSURL *url = [NSURL URLWithString:kLoginURLString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
	[request setHTTPMethod:@"POST"];
    NSString *body = nil;
    if (type == LoginTypeNormal) {
        body = [NSString stringWithFormat:@"username=%@&password=%@", self.user.userName, _password];
    } else if (type == LoginTypeFacebook) {
        body = [NSString stringWithFormat:@"access_token=%@&type=facebook", accessToken];
    } else if (type == LoginTypeTwitter) {
        body = [NSString stringWithFormat:@"access_token=%@&type=twitter", accessToken];
    }

	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	NSError *error = nil;
	NSURLResponse *response = nil;
	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"login response: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    
	[request release];
	if (!error) {
        // process data response
		return TRUE;
	}

	return FALSE;	
}

#pragma mark	-
#pragma mark		save / restore state
#pragma mark	-


- (void) restoreState
{
    self.user = nil;
	self.password = nil;
    
    //
    // Read the global preferences and set the app preferences 
    //
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *userDict = [defaults objectForKey:@"userkey"];
	
    self.user = [[[WSUser alloc] initWithDictionary:userDict] autorelease];
    self.password = @"";
    
    return;
	
}


- (void) saveState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.user dictionary] forKey:@"userkey"];
    [defaults synchronize];
    return;
}


@end
