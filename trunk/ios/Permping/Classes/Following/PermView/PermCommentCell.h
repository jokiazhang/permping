//
//  PermCommentCell.h
//  Permping
//
//  Created by MAC on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSComment;

@interface PermCommentCell : UITableViewCell {
    UIImageView *avatarView;
    WSComment *comment;
}
@property (nonatomic, readonly) UIImageView *avatarView;

- (void)setComment:(WSComment*)in_comment;

@end
