//
//  CheckNetworkStatus.h
//  Eyecon
//
//  Created by PhongLe on 7/7/10.
//  Copyright 2010 Appo CO., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface CheckNetworkStatus : NSObject {
	BOOL					isNetworkAvailable;
	BOOL					done;
}

@property (nonatomic, assign) BOOL isNetworkAvailable;
@property (nonatomic, assign) BOOL done;

- (BOOL)connectedToNetwork;

@end
