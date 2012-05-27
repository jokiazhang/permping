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

@class KalLogic, KalDate;

@interface MyDiaryViewController : CommonViewController<KalViewDelegate, KalDataSourceCallbacks> {
    IBOutlet UILabel    *headerLabel;
    KalView *kalView;
    KalLogic *logic;
    id <KalDataSource> dataSource;
    NSDate *initialDate;
    NSDate *selectedDate;
}

@property (nonatomic, assign) id<KalDataSource> dataSource;
@property (nonatomic, retain, readonly) NSDate *selectedDate;

- (void)reloadData;
- (void)showAndSelectDate:(NSDate *)date;
@end
