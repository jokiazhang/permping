//
//  ErrorModel.m
//  Permping
//
//  Created by Andrew Duck on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ErrorModel.h"

@implementation ErrorModel
@synthesize code, message;

- (void) dealloc {
    self.code = nil;
    self.message = nil;
    [super dealloc];
}
@end
