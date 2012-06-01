//
//  JoinViewController.m
//  Permping
//
//  Created by MAC on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoinViewController.h"
#import "UserInfoTableViewCell.h"
#import "Utils.h"
#import "AppData.h"
#import "Taglist_CloudService.h"

@implementation JoinViewController
@synthesize fieldsTitle, userInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userInfo = [[NSMutableDictionary alloc] init];
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
    
    self.fieldsTitle = [NSArray arrayWithObjects:@"Name :", @"Username :", @"Email :", @"Password :", @"Confirm Password :", nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    self.userInfo = nil;
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createAccountDidFinish:) name:kCreateAccountFinishNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCreateAccountFinishNotification object:nil];
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fieldsTitle.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuserIdentifier = @"JoinInfoCellIdentifier";
    UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (cell == nil) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuserIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.valueTextField.delegate = self;
        // note : cell must not be reused
        cell.valueTextField.tag = indexPath.row;
    }
    if (indexPath.row == 3 || indexPath.row == 4) {
        cell.valueTextField.secureTextEntry = YES;
    }
    cell.textLabel.text = [self.fieldsTitle objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)validateInputData {
    NSString *errorMessage = nil;
    NSInteger count = self.fieldsTitle.count;
    for (NSInteger i=0; i<count; i++) {
        UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.valueTextField.text isEqualToString:@""]) {
            errorMessage = @"Please input required fields";
            break;
        }
        if (i == 0) {
            [self.userInfo setObject:cell.valueTextField.text forKey:kUserServiceNameKey];
        } else if (i == 1) {
            [self.userInfo setObject:cell.valueTextField.text forKey:kUserServiceUserNameKey];
        } else if (i == 2) {
            [self.userInfo setObject:cell.valueTextField.text forKey:kUserServiceEmailKey];
        } else if (i == 3) {
            [self.userInfo setObject:cell.valueTextField.text forKey:kUserServicePasswordKey];
        } else if (i == 4) {
            [self.userInfo setObject:cell.valueTextField.text forKey:kUserServiceCPasswordKey];
        }
    }
    
    if (errorMessage) {
        [Utils displayAlert:errorMessage delegate:nil];
        return NO;
    }
    [self.userInfo setObject:[[AppData getInstance] oauthToken] forKey:kUserServiceOauthTokenKey];
    [self.userInfo setObject:[[AppData getInstance] oauthTokenType] forKey:kUserServiceTypeKey];
    return YES;
}

- (IBAction)createAccountButtonDidTouch:(id)sender {
    [self startActivityIndicator];
    
    [self.userInfo setObject:@"abcd" forKey:kUserServiceNameKey];
    [self.userInfo setObject:@"abcd" forKey:kUserServiceUserNameKey];
    [self.userInfo setObject:@"abcd@test.com" forKey:kUserServiceEmailKey];
    [self.userInfo setObject:@"123456" forKey:kUserServicePasswordKey];
    [self.userInfo setObject:@"123456" forKey:kUserServiceCPasswordKey];

    [self.userInfo setObject:[[AppData getInstance] oauthToken] forKey:kUserServiceOauthTokenKey];
    [self.userInfo setObject:[[AppData getInstance] oauthTokenType] forKey:kUserServiceTypeKey];
    //if ([self validateInputData]) {
        [[AppData getInstance] createAccountWithUserInfo:self.userInfo];
    //}
}

- (void)createAccountDidFinish:(NSNotification*)notification {
    [self stopActivityIndicator];
    BOOL isSuccess = [(NSNumber*)notification.object boolValue];
    if (isSuccess) {
        [self dismiss:nil];
    }
}

@end
