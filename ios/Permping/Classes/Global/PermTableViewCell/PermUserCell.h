//
//  PermUserCell.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermCellDelegate.h"

@interface PermUserCell : UITableViewCell {
    id<PermCellDelegate>   delegate;
    UIImageView *avatarView;
    UIButton    *profileButton;
    NSString    *userId;
}
@property (nonatomic, assign) id<PermCellDelegate>  delegate;
@property (nonatomic, readonly) UIImageView     *avatarView;
@property (nonatomic, retain) NSString *userId;

- (void)setCellWithUserId:(NSString*)in_userId avartarURLString:(NSString*)urlString userName:(NSString*)userName category:(NSString*)category;

@end
