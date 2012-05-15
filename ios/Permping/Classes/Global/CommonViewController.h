//
//  CommonViewController.h
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSUser.h"

@interface CommonViewController : UIViewController {
    WSUser      *user;
}

@property (nonatomic, retain) WSUser *user;

- (BOOL)checkDidLogin;
@end