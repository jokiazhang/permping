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
#import "PermHeaderCell.h"
#import "PermCommentCell.h"
#import "Webservices.h"
#import <Twitter/TWTweetComposeViewController.h>
#import "FBFeedPost.h"


@implementation FollowingViewController
@synthesize permsArray;

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
    
    if (![self checkDidLogin]) {
        permTableview.tableHeaderView = tableHeaderView;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    PermListRequest *request = [[PermListRequest alloc] initWithUserId:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerResponse:) name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
//	[[RequestManager sharedInstance] performRequest:request];

}

- (void)handleServerResponse: (NSNotification*)in_response {
	NSLog(@"handleServerResponse: %@", in_response);
	
	ServerRequest *request = in_response.object;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
	
	if (!request.result.error) {
		id result = request.result.object;
        NSLog(@"result class: %@, %d", [result class], [result count]);
		if ([result isKindOfClass:[NSArray class]]) {
            self.permsArray = result;
            [permTableview reloadData];
		}
	} else {
		NSLog(@"Failed to load permlist");
	}
}


#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.permsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WSPerm *perm = [self.permsArray objectAtIndex:section];
    NSInteger count = 1 + perm.permComments.count;
    return MIN(count, 6);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO :
    CGFloat h = 60.0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        h = 400;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        h = 420;
    }
    return h;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *permReuseIdentifier = @"PermCellIdentifier";
    static NSString *commentReuseIdentifier = @"CommentReuseIdentifier";
    WSPerm *perm = [self.permsArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        PermHeaderCell *cell = (PermHeaderCell*)[tableView dequeueReusableCellWithIdentifier:permReuseIdentifier];
        if (cell == nil) {
            cell = [[PermHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:permReuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setPerm:perm];
        return cell;
    } else {
        PermCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentReuseIdentifier];
        if (cell == nil) {
            cell = [[PermCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentReuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        WSComment *comment = [perm.permComments objectAtIndex:indexPath.row-1];
        [cell setComment:comment];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[PermCommentCell class]]) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
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

#pragma mark - Twitter
- (BOOL)twitterLoggedIn {
    if (!twitterEngine) {
        twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        twitterEngine.consumerKey = @"XL030SY0ABiJNVBq4grQ";
        twitterEngine.consumerSecret = @"ttNPLjqLnjOkmjyZK5IsjvHU1iW0zC2hSSHigV1EU";
    }
    
    if ([twitterEngine isAuthorized]) {
        return YES;
    }
    
    // show login diaglog
    if (saController) {
        [saController release];        
    }
    SA_OAuthTwitterController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twitterEngine delegate:self];
    if (controller) {
        saController = [controller retain];
    }
    [saController showLoginDialog];
    return NO;
}

#pragma mark - Facebook
- (BOOL)fbLoggedIn {
    // if the user is not currently logged in begin the session
	BOOL loggedIn = [[FBRequestWrapper defaultManager] isLoggedIn];
    //loggedIn = NO;
	if (!loggedIn) {
        FBFeedPost *post = [[FBFeedPost alloc] init];
        [post showLoginViewWithDelegate:self];
	}
    return loggedIn;
}

- (IBAction)joinViewButtonDidTouch:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (button.tag == 0) {
        [joinView removeFromSuperview];
    } else if (button.tag == 1) { // facebook
        if ([self fbLoggedIn]) {
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
            if ([self twitterLoggedIn] == YES) {
                [self showJoinViewControllerLoggedin:YES];
            }
        }
    } else {
        [self showJoinViewControllerLoggedin:NO];
    }
}

#pragma mark - FBFeedPostDelegate

- (void) didLogin:(FBFeedPost *)_post {
    [self showJoinViewControllerLoggedin:YES];
}

- (void) didNotLogin:(FBFeedPost *)_post {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"Failed to connect to Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [view show];
    [view release];
}


#pragma mark - SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"storeCachedTwitterOAuthData data - username: %@ - %@", data, username);
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}


#pragma mark - SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    
	NSLog(@"Authenticated with user %@", username);
    [self showJoinViewControllerLoggedin:YES];
    
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    
	NSLog(@"Authentication Failure");
    
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    
	NSLog(@"Authentication Canceled");
}


#pragma mark - MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    
	NSLog(@"Request Suceeded: %@", connectionIdentifier);

}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    
    NSLog(@"Request Failed: %@. Error: %@", connectionIdentifier, [error localizedDescription]);
     
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Recieved Status");
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Misc Info Received: %@", miscInfo);
}

@end
