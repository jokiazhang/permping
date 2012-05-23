//
//  Utils.m
//  Permping
//
//  Created by MAC on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)displayAlert:(NSString*)message delegate:(id)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:NSLocalizedString(@"globals.ok", @"OK") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
