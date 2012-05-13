//
//  UserInfoTableViewCell.h
//  Permping
//
//  Created by MAC on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell {
    UITextField     *valueTextField;
}
@property (nonatomic, readonly) UITextField *valueTextField;
@end
