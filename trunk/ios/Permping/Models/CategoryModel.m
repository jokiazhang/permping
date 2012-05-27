//
//  CategoryModel.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel
@synthesize categoryId;
@synthesize title;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.categoryId = nil;
    self.title = nil;
    [super dealloc];
}

@end
