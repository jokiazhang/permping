//
//  BoardListViewController.h
//  Permping
//
//  Created by Andrew Duck on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface BoardListViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView     *boardListTableView;
    NSArray                  *boardsArray;
    id  target;
    SEL action;
}
@property (nonatomic, retain) NSArray   *boardsArray;

- (void)setTarget:(id)in_target action:(SEL)in_action;

@end
