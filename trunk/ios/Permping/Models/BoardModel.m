//
//  BoardModel.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardModel.h"

@implementation BoardModel
@synthesize boardId, userId, title, categoryId, desc, dateAdded, dateUpdated, type, friendId;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.boardId = nil;
    self.userId = nil;
    self.title = nil;
    self.categoryId = nil;
    self.desc = nil;
    self.dateAdded = nil;
    self.dateUpdated = nil;
    self.type = nil;
    self.friendId = nil;
    [super dealloc];
}
@end
