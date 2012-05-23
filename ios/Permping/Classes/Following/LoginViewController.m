//
//  LoginViewController.m
//  Permping
//
//  Created by MAC on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Twitter/TWTweetComposeViewController.h>
#import "LoginViewController.h"
#import "UserInfoTableViewCell.h"
#import "FBFeedPost.h"


@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self.navigationController.navigationItem setHidesBackButton:YES];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setBackgroundImage:[UIImage imageNamed:@"bar-item-btn.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = barButtonItem;
	[barButtonItem release];
    [button release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuserIdentifier = @"LoginInfoCellIdentifier";
    UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (cell == nil) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuserIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.valueTextField.delegate = self;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Email Address :";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Password :";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)facebookButtonDidTouch:(id)sender {
    if ([self fbLoggedIn]) {
        
    }
}

- (IBAction)twitterButtonDidTouch:(id)sender {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        if ([TWTweetComposeViewController canSendTweet]) {
            // do login with server
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No twitter account has been setup." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    } else {
        if (!twitterEngine) {
            twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
            twitterEngine.consumerKey = @"XL030SY0ABiJNVBq4grQ";
            twitterEngine.consumerSecret = @"ttNPLjqLnjOkmjyZK5IsjvHU1iW0zC2hSSHigV1EU";
        }
        
        if ([self twitterLoggedIn] == YES) {
            
        }
    }
}

- (IBAction)loginButtonDidTouch:(id)sender {
    
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

#pragma mark - FBFeedPostDelegate

- (void) failedToPublishPost:(FBFeedPost*) _post {
	[_post release];
}

- (void) finishedPublishingPost:(FBFeedPost*) _post {
	[_post release];
    
}

- (void) didLogin:(FBFeedPost *)_post {
    NSLog(@"Facebook login successed");
    [_post release];
}

- (void) didNotLogin:(FBFeedPost *)_post {
    NSLog(@"Facebook login failed");
    [_post release];
}

#pragma mark - Twitter
- (BOOL)twitterLoggedIn {
    if ([twitterEngine isAuthorized]) {
        // logged in
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

- (void)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
