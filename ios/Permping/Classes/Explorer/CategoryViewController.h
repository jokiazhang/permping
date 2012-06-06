//
//  CategoryViewController.h
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PermsViewController.h"
#import "CategoryModel.h"
#import "Taglist_NDModel.h"

@interface CategoryViewController : PermsViewController {
    CategoryModel               *category;
}
@property (nonatomic, retain)CategoryModel      *category;

@end
