//
//  PermTableView.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermTableView.h"
#import "PermView.h"

@implementation PermTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableHeaderView = [[[PermView alloc] initWithFrame:frame] autorelease];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
