//
//  PermHeaderCell.h
//  Permping
//
//  Created by Andrew Duck on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSPerm;

@interface PermHeaderCell : UITableViewCell {
    UIImageView *avatarView;
    UIImageView *permImageView;
    UILabel     *ownerCommentLabel;
    UILabel     *descriptionLabel;
    UILabel     *statusLabel;
    
    UIButton    *repermButton;
    UIButton    *likeButton;
    UIButton    *commentButton;
    
    WSPerm      *perm;
}
@property (nonatomic, readonly) UIImageView *avatarView;
@property (nonatomic, readonly) UIImageView *permImageView;
@property (nonatomic, readonly) UILabel *ownerCommentLabel;
@property (nonatomic, readonly) UILabel *descriptionLabel;
@property (nonatomic, readonly) UILabel *statusLabel;

@property (nonatomic, readonly) UIButton *repermButton;
@property (nonatomic, readonly) UIButton *likeButton;
@property (nonatomic, readonly) UIButton *commentButton;

- (void)setPerm:(WSPerm*)in_perm;
@end
