//
//  LoginViewController.h
//  Permping
//
//  Created by MAC on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@interface LoginViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate> {
    IBOutlet UILabel        *headerLabel;
    IBOutlet UIButton       *facebookButton;
    IBOutlet UIButton       *twitterButton;
    IBOutlet UITableView    *formTableView;
    IBOutlet UIButton       *loginButton;
    
    SA_OAuthTwitterEngine       *twitterEngine;
    SA_OAuthTwitterController   *saController;
}

- (IBAction)facebookButtonDidTouch:(id)sender;

- (IBAction)twitterButtonDidTouch:(id)sender;

- (IBAction)loginButtonDidTouch:(id)sender;

- (BOOL)fbLoggedIn;

- (BOOL)twitterLoggedIn;

@end
