//
//  NetworkManager.h
//  Dani
//
//  Created by Andrew Duck on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkManager : NSObject {
    Reachability *internetReach;
}

+ (NetworkManager*)defaultNetworkManager;
- (NetworkStatus)checkNetworkStatus;
- (void)alertIfNetworkReachable: (NetworkStatus)in_networkStatus;

@end
