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
    if(width < 500)
    {
        desiredWidth = width/500 * 304;
        desiredHeight = height/500 *304;
    }
    else {
        desiredHeight = height/width *304;
    }
    return CGSizeMake(desiredWidth, desiredHeight);
}

+ (UIImage *)scaleAndRotateImage:(UIImage *)image maxWidth:(NSInteger)maxWidth{
    int kMaxResolution = maxWidth;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution) {
        /*CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }*/
        CGFloat scale = width/kMaxResolution;
        bounds.size.width = kMaxResolution;
        bounds.size.height = height/scale;
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
