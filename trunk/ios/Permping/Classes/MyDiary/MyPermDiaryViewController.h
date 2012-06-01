//
//  MyPermDiaryViewController.h
//  Permping
//
//  Created by Phong Le on 5/31/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermsViewController.h"
#import "Taglist_NDModel.h"

@interface MyPermDiaryViewController : PermsViewController
{
    Taglist_NDModel     *resultModel;
    NSString            *currentDate;
}
@property (nonatomic, copy) NSString *currentDate;
@property (nonatomic, retain) Taglist_NDModel *resultModel;
@end

