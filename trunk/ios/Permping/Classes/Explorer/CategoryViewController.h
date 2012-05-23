//
//  CategoryViewController.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@class WSCategory;

@interface CategoryViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *boardsTableView;
    WSCategory  *category;
    NSArray     *boards;
}
@property (nonatomic, retain) WSCategory    *category;
@property (nonatomic, retain) NSArray       *boards;
@end
