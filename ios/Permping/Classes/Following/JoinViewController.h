//
//  JoinViewController.h
//  Permping
//
//  Created by MAC on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface JoinViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UILabel        *headerLabel;
    IBOutlet UITableView    *infoTableView;
    IBOutlet UIButton       *createAccountButton;
    
    NSArray     *fieldsTitle;
    NSMutableDictionary *userInfo;
}
@property (nonatomic, retain) NSMutableDictionary *userInfo;
@property (nonatomic, retain) NSArray *fieldsTitle;
- (IBAction)createAccountButtonDidTouch:(id)sender;

@end
