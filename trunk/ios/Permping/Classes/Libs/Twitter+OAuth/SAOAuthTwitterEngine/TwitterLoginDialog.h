//
//  TwitterLoginDialog.h
//  DemoApp
//
//  Created by Tiet Anh Vu on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterLoginDialog : UIView <UIWebViewDelegate> {
    
    NSURLRequest *_request;
    UIWebView* _webView;
    UIActivityIndicatorView* _spinner;
    UIImageView* _iconView;
    UILabel* _titleLabel;
    UIButton* _closeButton;
    UIDeviceOrientation _orientation;
    BOOL _showingKeyboard;
    
    // Ensures that UI elements behind the dialog are disabled.
    UIView* _modalBackgroundView;
}

@property (nonatomic, retain) UIWebView *webView;

/**
 * The title that is shown in the header atop the view.
 */
@property(nonatomic,copy) NSString* title;

- (id)initWithRequest:(NSURLRequest *)request;
- (void)stopWaitingAnimating;
- (void)dismiss:(BOOL)animated;

/**
 * Displays the view with an animation.
 *
 * The view will be added to the top of the current key window.
 */
- (void)show;

/**
 * Displays the first page of the dialog.
 *
 * Do not ever call this directly.  It is intended to be overriden by subclasses.
 */
- (void)load;

/**
 * Displays a request in the dialog.
 */
- (void)loadRequest:(NSURLRequest*)request;

@end
