//
//  PermsViewController.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "Taglist_NDModel.h"

@interface PermsViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource> {
    UITableView         *permTableview;
    NSMutableDictionary *permsImageHeight;
    
    UILabel             *noFoundLabel;
    
    Taglist_NDModel     *resultModel;
}

@property (nonatomic, retain) Taglist_NDModel *resultModel;
- (void)resetData;
- (void)finishLoadData;

@end
