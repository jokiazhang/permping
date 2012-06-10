//
//  PermInfoCell.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermModel.h"
#import "PermCellDelegate.h"

@interface PermInfoCell : UITableViewCell {
    UILabel     *commentLabel;
    UILabel     *descriptionLabel;

    UIButton    *repermButton;
    UIButton    *likeButton;
    UIButton    *commentButton;
    UIButton    *locationButton;
    
    UILabel     *statusLabel;
    
    id<PermCellDelegate> delegate;
    PermModel   *perm;
}
@property (nonatomic, assign)   id<PermCellDelegate> delegate;
@property (nonatomic, retain)   PermModel *perm;
@property (nonatomic, readonly) UILabel *commentLabel;
@property (nonatomic, readonly) UILabel *descriptionLabel;

@property (nonatomic, readonly) UIButton *repermButton;
@property (nonatomic, readonly) UIButton *likeButton;
@property (nonatomic, readonly) UIButton *commentButton;
@property (nonatomic, readonly) UIButton *locationButton;

@property (nonatomic, readonly) UILabel *statusLabel;

- (void)setCellWithPerm:(PermModel*)perm;
@end
