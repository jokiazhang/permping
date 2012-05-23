//
//  UserProfileView.h
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSUser;

@interface UserProfileView : UIScrollView<UITableViewDelegate, UITableViewDataSource> {
    UIImageView *avatarView;
    UILabel     *userNameLabel;
    UILabel     *permsNumberLabel;
    UIButton    *followButton;
    UITableView *boardTableView;
    WSUser      *user;
}

@property (nonatomic, retain) WSUser *user;

@end
