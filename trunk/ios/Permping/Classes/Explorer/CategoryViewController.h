//
//  CategoryViewController.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "CategoryModel.h"
#import "Taglist_NDModel.h"

@interface CategoryViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *boardsTableView;
    CategoryModel               *category;
    Taglist_NDModel             *resultModel;
}
@property (nonatomic, retain)CategoryModel      *category;
@property (nonatomic, retain)Taglist_NDModel    *resultModel;

@end
