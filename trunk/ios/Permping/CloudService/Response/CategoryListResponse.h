//
//  CategoryListResponse.h
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Taglist_CloudResponse.h"
#import "CategoryModel.h"

@interface CategoryListResponse : Taglist_CloudResponse {
    NSMutableArray      *categoryList;
    CategoryModel       *currentCategory;
}
- (NSArray *)getResponseCategoryList;
@end
