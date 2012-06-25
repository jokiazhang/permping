//
//  CommonViewController.m
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "CommonViewController.h"
#import "AppData.h"
#import "Utility.h"

#define SPINNER_BACKGROUND_WIDTH    100
#define SPINNER_BACKGROUND_HEIGHT   60

#define SPINNER_VIEW_WIDTH      32
#define SPINNER_VIEW_HEIGHT     32

#define THUMBNAIL_DOWNLOAD_ALERT_COUNT      1

@implementation CommonViewController
@synthesize spinner, spinnerBackground, spinnerModalBackground;
@synthesize dataLoader, dataLoaderThread;
@synthesize thumbnailDownloaders;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutDidFinish:) name:kLogoutFinishNotification object:nil];
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        [bar setBackgroundImage:[UIImage imageNamed:@"nav-bar-background.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationItem.title = @"PERMPING";
    self.view.backgroundColor = [UIColor clearColor];
    
    
    self.dataLoader = nil;
    self.dataLoaderThread = nil;
    
    self.thumbnailDownloaders = [NSMutableArray array];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogoutFinishNotification object:nil];
    [self cancelAllThreads];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogoutFinishNotification object:nil];
    self.dataLoader = nil;
    self.dataLoaderThread = nil;
    self.thumbnailDownloaders = nil;    
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Public methods
- (void)startActivityIndicator
{
    if (startedActivityIndicator) {
        return;
    }
    // Tuan add: Ensures that UI elements behind the loadingview are disabled.
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.spinnerModalBackground = backgroundView;
    [backgroundView release];
    
    UIActivityIndicatorView *spinView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinView.hidesWhenStopped = YES;
    CGRect  thisFrame = self.view.frame;
    
    UIView *spinBackground = [[UIView alloc] initWithFrame:CGRectMake((thisFrame.size.width - SPINNER_BACKGROUND_WIDTH)/2,
                                                                      (thisFrame.size.height - SPINNER_BACKGROUND_HEIGHT)/2 - 80,
                                                                      SPINNER_BACKGROUND_WIDTH, SPINNER_BACKGROUND_HEIGHT)];
    spinBackground.backgroundColor = [UIColor blackColor];
    spinBackground.alpha = 0.6;
    [spinBackground.layer setMasksToBounds:YES];
    [spinBackground.layer setCornerRadius:10.0f];
    self.spinnerBackground = spinBackground;
    [spinBackground release];
    
    
    spinView.frame = CGRectMake((thisFrame.size.width - SPINNER_VIEW_WIDTH)/2, (thisFrame.size.height - SPINNER_VIEW_HEIGHT)/2 - 80, SPINNER_VIEW_WIDTH, SPINNER_VIEW_HEIGHT);
    spinView.hidesWhenStopped = YES;
    [self.view addSubview:spinnerModalBackground];
    [self.view addSubview:spinnerBackground];
    [self.view addSubview:spinView];
    [spinView startAnimating];
    self.spinner = spinView;
    [spinView release];
    startedActivityIndicator = YES;
}

- (void)startActivityIndicatorAtYPos:(float)yPos
{
    if (startedActivityIndicator) {
        return;
    }
    // Tuan add: Ensures that UI elements behind the loadingview are disabled.
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.spinnerModalBackground = backgroundView;
    [backgroundView release];
    
    UIActivityIndicatorView *spinView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinView.hidesWhenStopped = YES;
    CGRect  thisFrame = self.view.frame;
    
    UIView *spinBackground = [[UIView alloc] initWithFrame:CGRectMake((thisFrame.size.width - SPINNER_BACKGROUND_WIDTH)/2,
                                                                      yPos - SPINNER_BACKGROUND_HEIGHT/2,
                                                                      SPINNER_BACKGROUND_WIDTH, SPINNER_BACKGROUND_HEIGHT)];
    spinBackground.backgroundColor = [UIColor blackColor];
    spinBackground.alpha = 0.6;
    [spinBackground.layer setMasksToBounds:YES];
    [spinBackground.layer setCornerRadius:10.0f];
    self.spinnerBackground = spinBackground;
    [spinBackground release];
    
    
    spinView.frame = CGRectMake((thisFrame.size.width - SPINNER_VIEW_WIDTH)/2, yPos - SPINNER_VIEW_HEIGHT/2, SPINNER_VIEW_WIDTH, SPINNER_VIEW_HEIGHT);
    spinView.hidesWhenStopped = YES;
    [self.view addSubview:spinnerModalBackground];
    [self.view addSubview:spinnerBackground];
    [self.view addSubview:spinView];
    [spinView startAnimating];
    self.spinner = spinView;
    [spinView release];
    startedActivityIndicator = YES;
}

- (void)stopActivityIndicator
{
    startedActivityIndicator = NO;
    [self.spinnerBackground removeFromSuperview];
    self.spinnerBackground = nil;
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
    [self.spinnerModalBackground removeFromSuperview];
    self.spinnerModalBackground = nil;
}

- (id)getMyDataLoader
{
    return nil;
}

- (void)loadDataForMe:(id)dataLoader thread:(id<ThreadManagementProtocol>)threadObj
{
    
}

- (void)loadMoreDataForMe:(id)dataLoader thread:(id<ThreadManagementProtocol>)threadObj
{
    
}

/*
 *  This function should be called before screen quits.
 */
- (void)cancelAllThreads
{
    [self.dataLoaderThread cancel];
    self.dataLoaderThread = nil;
    
    //cancel all thumbnail thread
    NSArray *thumbArray = [NSArray arrayWithArray:self.thumbnailDownloaders];
    self.thumbnailDownloaders = nil;
    for (id<ThreadManagementProtocol> thread in thumbArray) {
        [thread cancel];
    }
}

- (void)thumbnailDownloadDidPartialFinishForThread:(id<ThreadManagementProtocol>)threadObj
{
    
}

- (void)thumbnailDownloadDidFinishForThread:(id<ThreadManagementProtocol>)threadObj
{    
    [self.thumbnailDownloaders removeObject:threadObj];
}

- (id<ThreadManagementProtocol>)downloadThumbnailForObjectList:(NSArray *)objectList
{
    id<ThreadManagementProtocol> threadObj = [[ThreadManager getInstance] dispatchToConcurrentBackgroundLowPriorityQueueWithTarget:self selector:@selector(performDownloadThumbnailForObjectList:thread:) dataObject:objectList];
    
    [self.thumbnailDownloaders addObject:threadObj];
    
    return threadObj;
}

- (void)performDownloadThumbnailForObjectList:(NSArray *)objectList thread:(id<ThreadManagementProtocol>)threadObj
{
    
}

- (void)logoutDidFinish:(NSNotification*)notification {
    // Need check
    BOOL isSuccess = [[notification.userInfo objectForKey:@"isSuccess"] boolValue];
    if (isSuccess) {
        if (self == [self.navigationController topViewController]) {
            [self cancelAllThreads];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

@end



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UINavigationBarController + Rotation

@implementation UINavigationController (CustomAnimation)

- (void)pushViewController:(UIViewController *)viewController animationTransition:(UIViewAnimationTransition)transition {
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [self pushViewController:viewController animated:NO];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
}

- (UIViewController*)popViewControllerAnimationTransition:(UIViewAnimationTransition)transition {
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    UIViewController * controller = [self popViewControllerAnimated:NO];
    [UIView commitAnimations];
    return controller;
}

- (NSArray *)popToRootViewControllerAnimationTransition:(UIViewAnimationTransition)transition {
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    NSArray * controllers = [self popToRootViewControllerAnimated:NO];
    [UIView commitAnimations];
    return controllers;
}

@end
