//
//  CreatePermViewController.h
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardModel.h"

@interface CreatePermViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UITableView *permTableView;
    NSDictionary    *imageInfo;
    BoardModel      *selectedBoard;
}
@property (nonatomic, retain) NSDictionary  *imageInfo;
@property (nonatomic, retain) BoardModel    *selectedBoard;
@end
