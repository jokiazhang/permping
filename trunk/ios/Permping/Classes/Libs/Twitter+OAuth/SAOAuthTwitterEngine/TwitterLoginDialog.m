//
//  TwitterLoginDialog.m
//  DemoApp
//
//  Created by Tiet Anh Vu on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterLoginDialog.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* kDefaultTitle1 = @"Connect to Twitter";
//static NSString* kDefaultTitle = NSLocalizedString(@"FBDefaultTitle", @"Connect to Facebook");
//static CGFloat kFacebookBlue1[4] = {0.42578125, 0.515625, 0.703125, 1.0};
static CGFloat kFacebookBlue1[4] = {69.0/255.0, 120.0/255.0, 166.0/255.0, 1.0};
static CGFloat kBorderGray1[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderBlack1[4] = {0.3, 0.3, 0.3, 1};
static CGFloat kBorderBlue1[4] = {0.23, 0.35, 0.6, 1.0};

static CGFloat kTransitionDuration1 = 0.3;

static CGFloat kTitleMarginX1 = 8;
static CGFloat kTitleMarginY1 = 4;
static CGFloat kPadding1 = 10;
static CGFloat kBorderWidth1 = 10;

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TwitterIsDeviceIPad(void);
BOOL TwitterIsDeviceIPad(void) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TwitterLoginDialog
@synthesize webView  = _webView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    _webView.delegate = nil;
    [_webView release];
    [_spinner release];
    [_titleLabel release];
    [_iconView release];
    [_closeButton release];
    [_modalBackgroundView release];
    [_request release];
    [super dealloc];
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

- (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorSpace(context, space);
    CGContextSetStrokeColor(context, strokeColor);
    CGContextSetLineWidth(context, 1.0);
    
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y-0.5},
            {rect.origin.x+rect.size.width, rect.origin.y-0.5}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5},
            {rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+rect.size.width-0.5, rect.origin.y},
            {rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y},
            {rect.origin.x+0.5, rect.origin.y+rect.size.height}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(space);
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
    
    CGFloat scale_factor = 1.0f;
    if (TwitterIsDeviceIPad()) {
        // On the iPad the dialog's dimensions should only be 70% of the screen's
        scale_factor = 0.7f;
    }
    
    CGFloat width = floor(scale_factor * frame.size.width) - kPadding1 * 2;
    CGFloat height = floor(scale_factor * frame.size.height) - kPadding1 * 2;
    
    _orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        self.frame = CGRectMake(kPadding1, kPadding1, height, width);
    } else {
        self.frame = CGRectMake(kPadding1, kPadding1, width, height);
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

- (void)updateWebOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [_webView stringByEvaluatingJavaScriptFromString:
         @"document.body.setAttribute('orientation', 90);"];
    } else {
        [_webView stringByEvaluatingJavaScriptFromString:
         @"document.body.removeAttribute('orientation');"];
    }
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration1/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration1/2];
    self.transform = [self transformForOrientation];
    [UIView commitAnimations];
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
    if (params) {
        NSMutableArray* pairs = [NSMutableArray array];
        for (NSString* key in params.keyEnumerator) {
            NSString* value = [params objectForKey:key];
            NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL, /* allocator */
                                                                                          (CFStringRef)value,
                                                                                          NULL, /* charactersToLeaveUnescaped */
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8);
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
            [escaped_value release];
        }
        
        NSString* query = [pairs componentsJoinedByString:@"&"];
        NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        return [NSURL URLWithString:url];
    } else {
        return [NSURL URLWithString:baseURL];
    }
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)postDismissCleanup {
    [self removeObservers];
    [self removeFromSuperview];
    [_modalBackgroundView removeFromSuperview];
}

- (void)dismiss:(BOOL)animated {
    
    [_request release];
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
        self.alpha = 0;
        [UIView commitAnimations];
    } else {
        [self postDismissCleanup];
    }
}

- (void)cancel {

    [self dismiss:YES];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
    self = [super initWithFrame:CGRectZero];
    //if (self = [super initWithFrame:CGRectZero]) {
    if (self) {
        _orientation = UIDeviceOrientationUnknown;
        _showingKeyboard = NO;
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        
        UIImage* iconImage = [UIImage imageNamed:@"twitterIcon.png"];
        UIImage* closeImage = [UIImage imageNamed:@"FBDialog.bundle/images/close.png"];
        
        _iconView = [[UIImageView alloc] initWithImage:iconImage];
        [self addSubview:_iconView];
        
        UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
        _closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        [_closeButton setTitleColor:color forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(cancel)
               forControlEvents:UIControlEventTouchUpInside];
        
        // To be compatible with OS 2.x
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_2_2
        _closeButton.font = [UIFont boldSystemFontOfSize:12];
#else
        _closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
#endif
        
        _closeButton.showsTouchWhenHighlighted = YES;
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
        | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_closeButton];
        
        CGFloat titleLabelFontSize = (TwitterIsDeviceIPad() ? 18 : 14);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = kDefaultTitle1;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:titleLabelFontSize];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_titleLabel];
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(kPadding1, kPadding1, 480, 480)];
        //_webView.delegate = self;
        _webView.delegate = nil;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_webView];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                    UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_spinner];
        _modalBackgroundView = [[UIView alloc] init];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)drawRect:(CGRect)rect {
    
    CGRect grayRect = CGRectOffset(rect, -0.5, -0.5);
    [self drawRect:grayRect fill:kBorderGray1 radius:10];
    
    CGRect headerRect = CGRectMake(
                                   ceil(rect.origin.x + kBorderWidth1), ceil(rect.origin.y + kBorderWidth1),
                                   rect.size.width - kBorderWidth1*2, _titleLabel.frame.size.height);
    [self drawRect:headerRect fill:kFacebookBlue1 radius:0];
    [self strokeLines:headerRect stroke:kBorderBlue1];
    
    CGRect webRect = CGRectMake(
                                ceil(rect.origin.x + kBorderWidth1), headerRect.origin.y + headerRect.size.height,
                                rect.size.width - kBorderWidth1*2, _webView.frame.size.height+1);
    [self strokeLines:webRect stroke:kBorderBlack1];
}


// UIDeviceOrientationDidChangeNotification

- (void)deviceOrientationDidChange:(void*)object {
    UIDeviceOrientation orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    //if (!_showingKeyboard && [self shouldRotateToOrientation:orientation]) {
    if ([self shouldRotateToOrientation:orientation]) {
        [self updateWebOrientation];
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIKeyboardNotifications

- (void)keyboardWillShow:(NSNotification*)notification {
    
    _showingKeyboard = YES;
    
    if (TwitterIsDeviceIPad()) {
        // On the iPad the screen is large enough that we don't need to
        // resize the dialog to accomodate the keyboard popping up
        return;
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _webView.frame = CGRectInset(_webView.frame,
                                     -(kPadding1 + kBorderWidth1),
                                     -(kPadding1 + kBorderWidth1) - _titleLabel.frame.size.height);
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    _showingKeyboard = NO;
    
    if (TwitterIsDeviceIPad()) {
        return;
    }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _webView.frame = CGRectInset(_webView.frame,
                                     kPadding1 + kBorderWidth1,
                                     kPadding1 + kBorderWidth1 + _titleLabel.frame.size.height);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (id)initWithRequest:(NSURLRequest *)request {
    self = [self init];
    _request = [request retain];    
    return self;
}


- (NSString*)title {
    return _titleLabel.text;
}

- (void)setTitle:(NSString*)title {
    _titleLabel.text = title;
}

- (void)load {
    
    [self loadRequest:_request];
}

- (void)loadRequest:(NSURLRequest*)request {
    [_webView loadRequest:request];
}

- (void)show {
    [self load];
    [self sizeToFitOrientation:NO];
    
    CGFloat innerWidth = self.frame.size.width - (kBorderWidth1+1)*2;
    [_iconView sizeToFit];
    [_titleLabel sizeToFit];
    [_closeButton sizeToFit];
    
    _titleLabel.frame = CGRectMake(
                                   kBorderWidth1 + kTitleMarginX1 + _iconView.frame.size.width + kTitleMarginX1,
                                   kBorderWidth1,
                                   innerWidth - (_titleLabel.frame.size.height + _iconView.frame.size.width + kTitleMarginX1*2),
                                   _titleLabel.frame.size.height + kTitleMarginY1*2);
    
    _iconView.frame = CGRectMake(
                                 kBorderWidth1 + kTitleMarginX1,
                                 kBorderWidth1 + floor(_titleLabel.frame.size.height/2 - _iconView.frame.size.height/2),
                                 _iconView.frame.size.width,
                                 _iconView.frame.size.height);
    
    _closeButton.frame = CGRectMake(
                                    self.frame.size.width - (_titleLabel.frame.size.height + kBorderWidth1),
                                    kBorderWidth1,
                                    _titleLabel.frame.size.height,
                                    _titleLabel.frame.size.height);
    
    _webView.frame = CGRectMake(
                                kBorderWidth1+1,
                                kBorderWidth1 + _titleLabel.frame.size.height,
                                innerWidth,
                                self.frame.size.height - (_titleLabel.frame.size.height + 1 + kBorderWidth1*2));
    
    [_spinner sizeToFit];
    [_spinner startAnimating];
    _spinner.center = _webView.center;
    
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
    [UIView setAnimationDuration:kTransitionDuration1/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
    
    [self addObservers];
}

- (void)stopWaitingAnimating {

    [_spinner stopAnimating];
    _spinner.hidden = YES;
    
}

@end
