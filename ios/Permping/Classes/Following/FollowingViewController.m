//
//  FollowingViewController.m
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FollowingViewController.h"
#import "JoinViewController.h"
#import "LoginViewController.h"
#import "AppData.h"
#import "FollowingScreen_DataLoader.h"
#import "PermListResponse.h"

@implementation FollowingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"FollowingTabTitle", @"Followers");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-item-following"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [useFacebookButton setBackgroundImage:[[UIImage imageNamed:@"btn-background.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0] forState:UIControlStateNormal];
    
    [useTwitterButton setBackgroundImage:[[UIImage imageNamed:@"btn-background.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0] forState:UIControlStateNormal];
    
    [joinPermpingButton setBackgroundImage:[[UIImage imageNamed:@"btn-background.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0] forState:UIControlStateNormal];

    [joinViewContainer.layer setCornerRadius:10.0f];
    [joinViewContainer.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [joinViewContainer.layer setBorderWidth:1.f];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[AppData getInstance] didLogin]) {
        permTableview.tableHeaderView = tableHeaderView;
    } else {
        permTableview.tableHeaderView = nil;
    }
    
    //if (!_didPushToAnotherViewController) {
        [self startActivityIndicator];
        [self resetData];
        self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
        
    //}
    _didPushToAnotherViewController = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([joinView superview]) {
        [joinView removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocialNetworkDidLoginNotification object:nil];
    
}

#pragma mark - Override methods
- (id)getMyDataLoader
{
    FollowingScreen_DataLoader *loader = [[FollowingScreen_DataLoader alloc] init];
    return [loader autorelease];
}

- (void)loadDataForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        NSInteger    nextId = -1;
        NSArray *arr = nil;
        
        PermListResponse *response = nil;
        if ([[AppData getInstance] didLogin]) {
            NSString *userId = [[[AppData getInstance] user] userId];
            NSLog(@"userId: %@", userId);
            response = [(FollowingScreen_DataLoader *)loader getPermWithUserId:userId nextItemId:nextId requestedCount:30];
        } else {
            response = [(FollowingScreen_DataLoader *)loader getPopularFromNextItemId:nextId requestedCount:30];
        }
        nextId = response.nextItemId;
        arr = [response getResponsePermList];
        NSLog(@"arr count :%d", arr.count);
        if (![threadObj isCancelled]) {
            self.resultModel.arrResults = arr;
            self.resultModel.nextItemId = nextId;
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               [self finishLoadData]; 
                           });
            [self downloadThumbnailForObjectList:arr];
        }
    }
    //[myLoader release];
    [pool drain];
}

- (void)loadMoreDataForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    
}

- (void)thumbnailDownloadDidPartialFinishForThread:(id<ThreadManagementProtocol>)threadObj
{
    if (![threadObj isCancelled]) 
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //reload table
                           [permTableview reloadData];
                       });
    }
}

- (void)performDownloadThumbnailForObjectList:(NSArray *)objectList thread:(id<ThreadManagementProtocol>)threadObj
{
}

#pragma mark - publice methods

- (IBAction)joinButtonDidTouch:(id)sender {
    [self.view addSubview:joinView];
}

- (IBAction)loginButtonDidTouch:(id)sender {
    LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    _didPushToAnotherViewController = YES;
}

- (void)showJoinViewController {
    if ([joinView superview]) {
        [joinView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocialNetworkDidLoginNotification object:nil];
        JoinViewController *controller = [[JoinViewController alloc] initWithNibName:@"JoinViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        _didPushToAnotherViewController = YES;
    }
}

- (IBAction)joinViewButtonDidTouch:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (button.tag == 0) {
        [joinView removeFromSuperview];
    } else if (button.tag == 1) { // facebook
        if ([[AppData getInstance] fbLoggedIn]) {
            [self showJoinViewController];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showJoinViewController) name:kSocialNetworkDidLoginNotification object:nil];
        }
    } else if (button.tag == 2) { // twitter
        if ([[AppData getInstance] twitterLoggedIn]) {
            [self showJoinViewController];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showJoinViewController) name:kSocialNetworkDidLoginNotification object:nil];
        }
    } else {
        [self showJoinViewController];
    }
}

@end
