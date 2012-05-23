//
//  PermInfoCell.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSPerm;

@interface PermInfoCell : UITableViewCell {
    UILabel     *commentLabel;
    UILabel     *descriptionLabel;

    UIButton    *repermButton;
    UIButton    *likeButton;
    UIButton    *commentButton;
    UIButton    *locationButton;
    
    UILabel     *statusLabel;
}
@property (nonatomic, readonly) UILabel *commentLabel;
@property (nonatomic, readonly) UILabel *descriptionLabel;

@property (nonatomic, readonly) UIButton *repermButton;
@property (nonatomic, readonly) UIButton *likeButton;
@property (nonatomic, readonly) UIButton *commentButton;
@property (nonatomic, readonly) UIButton *locationButton;

@property (nonatomic, readonly) UILabel *statusLabel;

- (void)setCellWithPerm:(WSPerm*)perm;
@end
