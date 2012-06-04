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
#import "PermModel.h"
#import "PermInfoCell.h"

@interface PermsViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource, PermInfoCellDelegate, UITextFieldDelegate> {
    UITableView         *permTableview;
    NSMutableDictionary *permsImageHeight;
    
    UILabel             *noFoundLabel;
    
    Taglist_NDModel     *resultModel;
    NSMutableArray      *selectedPerms;
    
    UIToolbar      *commentToolBar;
    UITextField    *commentTextField;
}
@property (nonatomic, retain) NSMutableArray *selectedPerms;
@property (nonatomic, retain) Taglist_NDModel *resultModel;
- (void)resetData;
- (void)finishLoadData;

- (void)doneCommentButtonDidTouch:(id)sender;
@end
