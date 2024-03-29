//
//  CommonViewController.h
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ThreadManager.h"

@interface CommonViewController : UIViewController
{
    UIView                              *spinnerBackground;
    UIActivityIndicatorView             *spinner;
    
    id                                  dataLoader;
    id<ThreadManagementProtocol>        dataLoaderThread;
    
    NSMutableArray                      *thumbnailDownloaders;
    
    BOOL                                startedActivityIndicator;
    
    // check viewWillAppear from pop or from tabbar item pressed
    BOOL                                _didPushToAnotherViewController;
}

@property (nonatomic, retain) id                            dataLoader;
@property (nonatomic, retain) id<ThreadManagementProtocol>  dataLoaderThread;
@property (nonatomic, retain) NSMutableArray                *thumbnailDownloaders;
@property (nonatomic, retain) UIView                        *spinnerModalBackground;
@property (nonatomic, retain) UIView                        *spinnerBackground;
@property (nonatomic, retain) UIActivityIndicatorView       *spinner;

- (void)dismiss:(id)sender;

- (void)startActivityIndicator;
- (void)startActivityIndicatorAtYPos:(float)yPos;
- (void)stopActivityIndicator;
- (id)getMyDataLoader;
- (void)loadDataForMe:(id)dataLoader thread:(id<ThreadManagementProtocol>)threadObj;
- (void)loadMoreDataForMe:(id)dataLoader thread:(id<ThreadManagementProtocol>)threadObj;
- (void)cancelAllThreads;
#pragma mark thumbnail downloaders
- (id<ThreadManagementProtocol>)downloadThumbnailForObjectList:(NSArray *)objectList;
- (void)performDownloadThumbnailForObjectList:(NSArray *)objectList thread:(id<ThreadManagementProtocol>)threadObj;
- (void)thumbnailDownloadDidPartialFinishForThread:(id<ThreadManagementProtocol>)threadObj;
- (void)thumbnailDownloadDidFinishForThread:(id<ThreadManagementProtocol>)threadObj;

- (void)logoutDidFinish:(NSNotification*)notification;
@end



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UINavigationBarController + Rotation
@interface RotateNavigationBarController : UINavigationController
@end

@interface UINavigationController (CustomAnimation)

- (void)pushViewController:(UIViewController *)viewController animationTransition:(UIViewAnimationTransition)transition;

- (UIViewController*)popViewControllerAnimationTransition:(UIViewAnimationTransition)transition;

- (NSArray *)popToRootViewControllerAnimationTransition:(UIViewAnimationTransition)transition;


@end
