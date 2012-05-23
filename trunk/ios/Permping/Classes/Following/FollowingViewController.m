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
#import "Webservices.h"
#import "AppData.h"


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
    
    if (![[AppData getInstance] checkDidLogin]) {
        permTableview.tableHeaderView = tableHeaderView;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PermListRequest *request = [[PermListRequest alloc] initWithType:PermListRequestTypePopular options:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerResponse:) name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
	[[RequestManager sharedInstance] performRequest:request];
}

- (void)handleServerResponse: (NSNotification*)in_response {
	ServerRequest *request = in_response.object;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
	
	if (!request.result.error) {
		id result = request.result.object;
		if ([result isKindOfClass:[NSArray class]]) {
            self.permsArray = result;
            [permTableview reloadData];
		}
	} else {
		NSLog(@"Failed to load permlist");
	}
}

- (IBAction)joinButtonDidTouch:(id)sender {
    [self.view addSubview:joinView];
}

- (IBAction)loginButtonDidTouch:(id)sender {
    LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)showJoinViewControllerLoggedin:(BOOL)loggedin {
    JoinViewController *controller = [[JoinViewController alloc] initWithNibName:@"JoinViewController" bundle:nil];
    controller.loggedin = loggedin;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    [joinView removeFromSuperview];
}

- (IBAction)joinViewButtonDidTouch:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (button.tag == 0) {
        [joinView removeFromSuperview];
    } else if (button.tag == 1) { // facebook
        if ([[AppData getInstance] fbLoggedIn]) {
            [self showJoinViewControllerLoggedin:YES];
        }
    } else if (button.tag == 2) { // twitter
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            if ([TWTweetComposeViewController canSendTweet]) {
                [self showJoinViewControllerLoggedin:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No twitter account has been setup." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            return;
        } else {
            if ([[AppData getInstance] twitterLoggedIn] == YES) {
                [self showJoinViewControllerLoggedin:YES];
            }
        }
    } else {
        [self showJoinViewControllerLoggedin:NO];
    }
}

@end
