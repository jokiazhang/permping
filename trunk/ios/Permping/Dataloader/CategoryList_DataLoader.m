//
//  CategoryList_DataLoader.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryList_DataLoader.h"
#import "Taglist_CloudService.h"

@implementation CategoryList_DataLoader

- (CategoryListResponse *)getCategoryList
{
    return [Taglist_CloudService getCategoryList];
}

@end
