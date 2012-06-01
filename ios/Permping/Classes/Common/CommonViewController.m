//
//  CommonViewController.m
//  yogofly
//
//  Created by Phong Le on 5/22/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "CommonViewController.h"

#define SPINNER_BACKGROUND_WIDTH    100
#define SPINNER_BACKGROUND_HEIGHT   60

#define SPINNER_VIEW_WIDTH      32
#define SPINNER_VIEW_HEIGHT     32

#define THUMBNAIL_DOWNLOAD_ALERT_COUNT      1

@implementation CommonViewController
@synthesize spinner, spinnerBackground;
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
    UINavigationBar *bar = [self.navigationController navigationBar];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        [bar setBackgroundImage:[UIImage imageNamed:@"nav-bar-background.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationItem.title = @"Permping";
    self.view.backgroundColor = [UIColor clearColor];
    
    
    self.dataLoader = nil;
    self.dataLoaderThread = nil;
    
    self.thumbnailDownloaders = [NSMutableArray array];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc {
    
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
    [self.view addSubview:spinnerBackground];
    [self.view addSubview:spinView];
    [spinView startAnimating];
    self.spinner = spinView;
    [spinView release];
}

- (void)startActivityIndicatorAtYPos:(float)yPos
{
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
    [self.view addSubview:spinnerBackground];
    [self.view addSubview:spinView];
    [spinView startAnimating];
    self.spinner = spinView;
    [spinView release];
}

- (void)stopActivityIndicator
{
    [self.spinnerBackground removeFromSuperview];
    self.spinnerBackground = nil;
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
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
@end
