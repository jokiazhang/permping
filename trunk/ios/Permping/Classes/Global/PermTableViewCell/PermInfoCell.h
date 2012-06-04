//
//  PermInfoCell.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermModel.h"

@class PermInfoCell;

@protocol PermInfoCellDelegate <NSObject>

@optional
- (void)likePermAtCell:(PermInfoCell*)cell;
- (void)commentPermAtCell:(PermInfoCell*)cell;
- (void)repermPermAtCell:(PermInfoCell*)cell;

@end

@interface PermInfoCell : UITableViewCell {
    UILabel     *commentLabel;
    UILabel     *descriptionLabel;

    UIButton    *repermButton;
    UIButton    *likeButton;
    UIButton    *commentButton;
    UIButton    *locationButton;
    
    UILabel     *statusLabel;
    
    id<PermInfoCellDelegate> delegate;
    PermModel   *perm;
}
@property (nonatomic, assign)   id<PermInfoCellDelegate> delegate;
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
