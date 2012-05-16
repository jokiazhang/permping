//
//  FollowingViewController.h
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CommonViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@interface FollowingViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate>{
    IBOutlet UILabel    *headerLabel;
    IBOutlet UIButton   *loginButton;
    IBOutlet UIButton   *joinButton;
    IBOutlet UIView     *tableHeaderView;
    
    IBOutlet UITableView *permTableview;
    
    IBOutlet UIView     *joinView;
    IBOutlet UIView     *joinViewContainer;
    IBOutlet UIButton   *useFacebookButton;
    IBOutlet UIButton   *useTwitterButton;
    IBOutlet UIButton   *joinPermpingButton;
    
    NSArray              *permsArray;
    
    SA_OAuthTwitterEngine       *twitterEngine;
    SA_OAuthTwitterController   *saController;
}

@property (nonatomic, retain) NSArray *permsArray;

- (IBAction)joinButtonDidTouch:(id)sender;

- (IBAction)loginButtonDidTouch:(id)sender;

- (IBAction)joinViewButtonDidTouch:(id)sender;

@end
