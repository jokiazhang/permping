//
//  PermUrlViewController.h
//  Permping
//
//  Created by MAC on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"


@interface PermUrlViewController : CommonViewController<UIWebViewDelegate> {
    UIWebView   *permUrlWebView;
}
@property (nonatomic, retain)NSString *urlString;
@end
