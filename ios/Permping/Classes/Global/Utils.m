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

+ (CGSize)sizeWithImage:(UIImage*)image constrainedToSize:(CGSize)constraintSize {
    /*CGSize size;
    CGSize imageSize = image.size;
    CGFloat hscale = constraintSize.height / imageSize.height;
    CGFloat wscale = constraintSize.width / imageSize.width;
    if (hscale < wscale) {
        size.height = constraintSize.height;
        size.width = imageSize.width * hscale;
    } else {
        size.width = constraintSize.width;
        size.height = imageSize.height * wscale;
    }
    return size;*/
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
//    float desiredWidth = width;
//    float desiredHeight = height;
//    if (width > constraintSize.width) {
//        desiredWidth = constraintSize.width;
//        desiredHeight = (float)height*constraintSize.width/(float)width;
//    }
    float desiredWidth = 304;
    float desiredHeight = height;
    if(width < 560)
    {
        desiredWidth = width/560 * 304;
        desiredHeight = height/560 *304;
    }
    else {
        desiredHeight = height/width *304;
    }
    return CGSizeMake(desiredWidth, desiredHeight);
}

@end
