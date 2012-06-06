//
//  LogoutViewController.h
//  Permping
//
//  Created by Andrew Duck on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface LogoutViewController : CommonViewController {
    IBOutlet UIButton   *logoutButton;
    IBOutlet UIButton   *cancelButton;
}

- (IBAction)logoutButtonDidTouch:(id)sender;

- (IBAction)cancelButtonDidTouch:(id)sender;

- (void)dismissWithFlipAnimationTransition;
@end
