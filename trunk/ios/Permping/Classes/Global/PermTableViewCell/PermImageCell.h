//
//  PermImageCell.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermCellDelegate.h"

@interface PermImageCell : UITableViewCell {
    id<PermCellDelegate>   delegate;
    UIImageView *permImageView;
    UIView      *permImageViewBackground;
    UIButton    *openPermUrlButton;
    NSString *permUrl;
}
@property (nonatomic, assign) id<PermCellDelegate> delegate;
@property (nonatomic, readonly) UIImageView *permImageView;

- (void)setCellPermUrl:(NSString*)permUrl;
@end
