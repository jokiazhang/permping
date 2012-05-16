//
//  JoinPopupDialog.m
//  Permping
//
//  Created by MAC on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoinPopupDialog.h"

static CGFloat kTransitionDuration = 0.3;

static CGFloat kPadding = 5;

@implementation JoinPopupDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
    CGContextBeginPath(context);
    CGContextSaveGState(context);
    
    if (radius == 0) {
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddRect(context, rect);
    } else {
        rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
        CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
        CGContextScaleCTM(context, radius, radius);
        float fw = CGRectGetWidth(rect) / radius;
        float fh = CGRectGetHeight(rect) / radius;
        
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    }
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    if (fillColors) {
        CGContextSaveGState(context);
        CGContextSetFillColor(context, fillColors);
        if (radius) {
            [self addRoundedRectToPath:context rect:rect radius:radius];
            CGContextFillPath(context);
        } else {
            CGContextFillRect(context, rect);
        }
        CGContextRestoreGState(context);
    }
    
    CGColorSpaceRelease(space);
}


- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)sizeToFitOrientation:(BOOL)transform {
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(
                                 frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    
    //CGFloat scale_factor = 1.0f;
    CGFloat scale_factor = _scale;
    
    CGFloat width = floor(scale_factor * frame.size.width) - kPadding * 2;
    CGFloat height = floor(scale_factor * frame.size.height) - kPadding * 2;
    
    _orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        self.frame = CGRectMake(kPadding, kPadding, height, width);
    } else {
        self.frame = CGRectMake(kPadding, kPadding, width, height);
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    self.transform = [self transformForOrientation];
    [UIView commitAnimations];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)postDismissCleanup {
    [self removeObservers];
    [self removeFromSuperview];
    [_modalBackgroundView removeFromSuperview];
}

- (void)dismiss:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
        self.alpha = 0;
        [UIView commitAnimations];
    } else {
        [self postDismissCleanup];
    }
}

- (void)close {
    [self dismiss:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
    if (self = [super initWithFrame:CGRectZero]) {
        _orientation = UIDeviceOrientationUnknown;
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        
        NSString *mainBundle = [[NSBundle mainBundle] resourcePath];
        UIImage* closeImage = [UIImage imageWithContentsOfFile:[mainBundle stringByAppendingFormat:@"/close.png"]];
        
        _contentView = [[UIWebView alloc] initWithFrame:CGRectMake(kPadding, kPadding, 1, 1)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_contentView];
        
        _closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close)
               forControlEvents:UIControlEventTouchUpInside];
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
        | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_closeButton];
        
        _modalBackgroundView = [[UIView alloc] init];
    }
    return self;
}

- (BOOL)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == _orientation) {
        return NO;
    } else {
        return orientation == UIDeviceOrientationLandscapeLeft
        || orientation == UIDeviceOrientationLandscapeRight
        || orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIDeviceOrientationDidChangeNotification

- (void)deviceOrientationDidChange:(void*)object {
    UIDeviceOrientation orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    if ([self shouldRotateToOrientation:orientation]) {
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

- (id)initWithDelegate:(id)in_delegate {
    self = [self init];
    delegate = in_delegate;
    return self;
}

- (void)showWithScale:(float)scale {
    _scale = scale;
    [self sizeToFitOrientation:NO];
    self.backgroundColor = [UIColor grayColor];
    CGSize s = CGSizeMake(30, 30);
    _closeButton.frame = CGRectMake(
                                    self.frame.size.width - s.width,
                                    0,
                                    s.width,
                                    s.height);

    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    _modalBackgroundView.frame = window.frame;
    [_modalBackgroundView addSubview:self];
    [window addSubview:_modalBackgroundView];
    
    [window addSubview:self];
    
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
   
    [UIView commitAnimations];
    
    [self addObservers];
    
}


- (void)dealloc
{
    [_closeButton release];
    [_modalBackgroundView release];
    [super dealloc];
}

@end
