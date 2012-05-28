//
//  LoginViewController.m
//  Permping
//
//  Created by MAC on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfoTableViewCell.h"
#import "AppData.h"
#import "Utils.h"

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
    
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.cancel", @"Cancel") target:self selector:@selector(dismiss:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocialNetworkDidLoginNotification object:nil];
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

- (void)performLoginWithSocialNetworkToken:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocialNetworkDidLoginNotification object:nil];
    
}

- (IBAction)facebookButtonDidTouch:(id)sender {
    if ([[AppData getInstance] fbLoggedIn]) {
        [self performLoginWithSocialNetworkToken:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performLoginWithSocialNetworkToken:) name:kSocialNetworkDidLoginNotification object:nil];
    }
}

- (IBAction)twitterButtonDidTouch:(id)sender {
    if ([[AppData getInstance] twitterLoggedIn]) {
        [self performLoginWithSocialNetworkToken:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performLoginWithSocialNetworkToken:) name:kSocialNetworkDidLoginNotification object:nil];
    }
}

- (IBAction)loginButtonDidTouch:(id)sender {
    
}

- (void)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
