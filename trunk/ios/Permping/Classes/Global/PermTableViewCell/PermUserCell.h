//
//  PermUserCell.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermUserCell : UITableViewCell {
    UIImageView *avatarView;
    UIButton    *profileButton;
}
@property (nonatomic, readonly)UIImageView  *avatarView;
@property (nonatomic, readonly)UIButton     *profileButton;

- (void)setCellWithAvartarURLString:(NSString*)urlString userName:(NSString*)userName category:(NSString*)category;
@end
