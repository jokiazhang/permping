//
//  JoinPopupDialog.h
//  Permping
//
//  Created by MAC on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinPopupDialog : UIView<UIWebViewDelegate> {
    id delegate;
    UIButton* _closeButton;
    UIDeviceOrientation _orientation;
    
    UIView  *_contentView;
    
    UIView* _modalBackgroundView;
    float _scale; 
}

- (id)initWithDelegate:(id)in_delegate;

- (void)showWithScale:(float)scale;

- (void)close;

@end
