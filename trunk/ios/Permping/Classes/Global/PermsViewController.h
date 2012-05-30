//
//  PermsViewController.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface PermsViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource> {
    UITableView         *permTableview;
    NSArray             *permsArray;
    NSMutableDictionary *permsImageHeight;
}
@property (nonatomic, retain) NSArray *permsArray;
@end
