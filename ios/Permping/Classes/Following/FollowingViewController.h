//
//  FollowingViewController.h
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PermsViewController.h"
#import "Taglist_NDModel.h"

@interface FollowingViewController : PermsViewController {
    IBOutlet UILabel    *headerLabel;
    IBOutlet UIButton   *loginButton;
    IBOutlet UIButton   *joinButton;
    IBOutlet UIView     *tableHeaderView;
    
    IBOutlet UIView     *joinView;
    IBOutlet UIView     *joinViewContainer;
    IBOutlet UIButton   *useFacebookButton;
    IBOutlet UIButton   *useTwitterButton;
    IBOutlet UIButton   *joinPermpingButton;
    
    Taglist_NDModel                     *resultModel;
}

@property (nonatomic, retain) Taglist_NDModel               *resultModel;

- (IBAction)joinButtonDidTouch:(id)sender;

- (IBAction)loginButtonDidTouch:(id)sender;

- (IBAction)joinViewButtonDidTouch:(id)sender;

@end
