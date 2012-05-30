//
//  CreateBoardViewController.h
//  Permping
//
//  Created by MAC on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "CategoryModel.h"

@interface CreateBoardViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UITableView    *boardInfoTableView;
    CategoryModel           *selectedCategory;
}
@property (nonatomic, retain) CategoryModel *selectedCategory;
@end
