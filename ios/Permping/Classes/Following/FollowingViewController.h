//
//  FollowingViewController.h
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface FollowingViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UILabel    *headerLabel;
    IBOutlet UIButton   *loginButton;
    IBOutlet UIButton   *joinButton;
    IBOutlet UIView     *tableHeaderView;
    
    IBOutlet UITableView *permTableview;
}

- (IBAction)joinButtonDidTouch:(id)sender;

- (IBAction)loginButtonDidTouch:(id)sender;

@end
