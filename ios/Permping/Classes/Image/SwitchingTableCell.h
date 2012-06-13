//
//  SwitchingTableCell.h
//  Permping
//
//  Created by Andrew Duck on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchingTableCell : UITableViewCell {
    UISwitch *switching;
}
@property (nonatomic, readonly) UISwitch *switching;
@end
