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

+ (UIBarButtonItem*)barButtonnItemWithTitle:(NSString*)title target:(id)target selector:(SEL)selector {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setBackgroundImage:[UIImage imageNamed:@"bar-item-btn.png"] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button release];
    return [barButtonItem autorelease];
}

@end
