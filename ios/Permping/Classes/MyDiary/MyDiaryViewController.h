//
//  MyDiaryViewController.h
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "Kal.h"
#import "Taglist_NDModel.h"

@class KalLogic, KalDate;

@interface MyDiaryViewController : CommonViewController<KalViewDelegate, KalDataSourceCallbacks> {
    IBOutlet UILabel    *headerLabel;
    KalView *kalView;
    KalLogic *logic;
    id <KalDataSource> dataSource;
    NSDateFormatter *dateFormat;
    KalDate *selectedDate;
    
    Taglist_NDModel     *resultModel;
    
}
@property (nonatomic, retain) Taglist_NDModel *resultModel;
@property (nonatomic, assign) id<KalDataSource> dataSource;

- (void)reloadData;
- (void)showAndSelectDate:(NSDate *)date;

- (NSString *)currentMonth;
@end
