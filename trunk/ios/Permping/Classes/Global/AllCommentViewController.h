//
//  AllCommentViewController.h
//  Permping
//
//  Created by MAC on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "Taglist_NDModel.h"

@interface AllCommentViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource> {
    Taglist_NDModel *resultModel;
}
@property (nonatomic, retain) Taglist_NDModel *resultModel;
@end
