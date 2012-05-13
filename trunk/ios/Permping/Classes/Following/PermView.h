//
//  PermView.h
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermView : UIView 

@property (nonatomic, readonly) UIImageView     *userAvatarView;
@property (nonatomic, readonly) UILabel         *usernameLabel;
@property (nonatomic, readonly) UILabel         *categoryLabel;
@property (nonatomic, readonly) UIImageView     *imageView;
@property (nonatomic, readonly) UILabel         *commentLabel;
@property (nonatomic, readonly) UILabel         *timeLabel;
@property (nonatomic, readonly) UIButton        *repermButton;
@property (nonatomic, readonly) UIButton        *likeButton;
@property (nonatomic, readonly) UIButton        *commentButton;
@property (nonatomic, readonly) UILabel         *statusLabel;

@end
