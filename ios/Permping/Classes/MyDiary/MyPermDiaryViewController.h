//
//  MyPermDiaryViewController.h
//  Permping
//
//  Created by Phong Le on 5/31/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermsViewController.h"


@interface MyPermDiaryViewController : PermsViewController
{

    NSString            *currentDate;
}
@property (nonatomic, copy) NSString *currentDate;

@end

