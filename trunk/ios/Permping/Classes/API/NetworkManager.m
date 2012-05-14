//
//  NetworkManager.m
//  Dani
//
//  Created by Andrew Duck on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkManager.h"


@implementation NetworkManager

- (void)alertIfNetworkReachable: (NetworkStatus)in_networkStatus {
	if (in_networkStatus == NotReachable) {
		UIAlertView *alert =[[UIAlertView alloc] initWithTitle: nil
														  message: @"Please check your wifi or 3G."
														 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        //UIAlertView *alert =[[UIAlertView alloc] initWithTitle: nil
        //                                                    message: @"Por favor, compruebe su wifi o 3G"
        //                                                    delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (NetworkStatus)checkNetworkStatus {
	NetworkStatus netStatus  = [internetReach currentReachabilityStatus];
	/*switch (netStatus) {
		case ReachableViaWiFi:
			NSLog(@"Access to internet throught wifi network");
			break;
		case ReachableViaWWAN:
			NSLog(@"Access to internet throught carrier network");
			break;
		default:
			NSLog(@"No access to internet");
			break;
	}*/
	return netStatus;
}

#pragma mark Singleton
static NetworkManager *singletonNetworkManager = nil;

-(void)setupReachability{
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
}

- (id)init {
	if (self = [super init]) {
		[self setupReachability];
	}
	return self;
}

+ (NetworkManager*)defaultNetworkManager
{
    @synchronized(self) {
        if (singletonNetworkManager == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return singletonNetworkManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (singletonNetworkManager == nil) {
            singletonNetworkManager = [super allocWithZone:zone];
            return singletonNetworkManager;  // assignment and return on first allocation
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

- (void)dealloc {
    [internetReach release];
    [super dealloc];
}

@end
