//
//  ExplorerViewController.h
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "Taglist_NDModel.h"

@interface ExplorerViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView        *categoriesTableView;
    Taglist_NDModel             *resultModel;
}
@property (nonatomic, retain)Taglist_NDModel *resultModel;

@end
