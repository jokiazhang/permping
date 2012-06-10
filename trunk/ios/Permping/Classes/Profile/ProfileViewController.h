//
//  ProfileViewController.h
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "UserProfileModel.h"

@interface ProfileViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UIView         *headerView;
    IBOutlet UIImageView    *avatarView;
    IBOutlet UILabel        *userNameLabel;
    IBOutlet UILabel        *permsNumberLabel;
    IBOutlet UIButton       *followButton;
    
    IBOutlet UITableView *boardTableView;
    
    BOOL                    isFollowed;
}
@property (nonatomic, retain)UserProfileModel *userProfile;
@property (nonatomic, retain)NSString *userId;

- (void)reloadData;

- (IBAction)followButtonDidTouch:(id)sender;
@end
