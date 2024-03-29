//
//  LoginViewController.m
//  Permping
//
//  Created by MAC on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfoTableViewCell.h"
#import "Taglist_CloudService.h"
#import "AppData.h"
#import "Utils.h"
#import "JoinViewController.h"

@implementation LoginViewController
@synthesize hasCancel, loginType;

- (void)dealloc {
    [self removeObservers];
    self.loginType = nil;
    [target release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        hasCancel = YES;
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

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidFinish:) name:kLoginFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocialNetworkDidLoginNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Bug black corner on iOS 4
    formTableView.backgroundColor = [UIColor clearColor];
    
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"btn-background"] stretchableImageWithLeftCapWidth:20 topCapHeight:30] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"btn-background-pressed"] stretchableImageWithLeftCapWidth:20 topCapHeight:30] forState:UIControlStateHighlighted];
    [loginButton setTitle:NSLocalizedString(@"globals.login", @"Login") forState:UIControlStateNormal];
    headerLabel.text = NSLocalizedString(@"LoginHeader", nil);
    
    [self addObservers];
    if (hasCancel) {
        self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.cancel", @"Cancel") target:self selector:@selector(dismiss:)];
    } else {
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self removeObservers];
}

- (void)updateInterface {
    CGRect r = self.view.frame;
    if (_showingKeyBoard) {
        r.origin.y = -60;
    } else {
        r.origin.y = 0;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = r;
    }];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    _showingKeyBoard = YES;
    [self updateInterface];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    _showingKeyBoard = NO;
    [self updateInterface];
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
        cell.valueTextField.text = @"";
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"EmailAddress", nil)];
        //cell.valueTextField.text = @"demo@demo.com";
        //cell.valueTextField.text = @"phonghunter@yahoo.com";
        cell.valueTextField.keyboardType = UIKeyboardTypeEmailAddress;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"Password", nil)];
        //cell.valueTextField.text = @"demo";
        //cell.valueTextField.text = @"5104100";
        cell.valueTextField.secureTextEntry = YES;
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

- (void)performLoginWithType:(NSString*)type {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidFinish:) name:kLoginFinishNotification object:nil];

    [self startActivityIndicator];
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:kUserServiceTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.loginType = type;
    UserInfoTableViewCell *cell1 = (UserInfoTableViewCell*)[formTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UserInfoTableViewCell *cell2 = (UserInfoTableViewCell*)[formTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:type, kUserServiceTypeKey, nil];
    if ([type isEqualToString:kUserServiceTypeNormal]) {
        [userInfo setObject:[cell2.valueTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kUserServicePasswordKey];
        [userInfo setObject:[cell1.valueTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kUserServiceEmailKey];
    } else {
        NSString *token = [[AppData getInstance] oauthToken];
        if (token) {
            [userInfo setObject:token forKey:kUserServiceOauthTokenKey];
        }
        if ([type isEqualToString:kUserServiceTypeTwitter]) {
            NSString *secret = [[AppData getInstance] oauthTokenSecret];
            if (secret) {
                [userInfo setObject:secret forKey:kUserServiceOauthTokenSecretKey];
            }
            NSString *verifier = [[AppData getInstance] oauthVerifier];
            if (verifier) {
                [userInfo setObject:verifier forKey:kUserServiceOauthVerifierKey];
            }
        }
    }
        
    NSLog(@"loginWithUserInfo: %@", userInfo);
    [[AppData getInstance] loginWithUserInfo:userInfo];
}

- (void)socialNetworkLoginDidFinish:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocialNetworkDidLoginNotification object:nil];
    BOOL isSuccess = [[notification.userInfo objectForKey:@"isSuccess"] boolValue];
    if (isSuccess) {
        NSString *type = [notification.userInfo objectForKey:kUserServiceTypeKey];
        [self performLoginWithType:type];
    }
}

- (IBAction)facebookButtonDidTouch:(id)sender {
    if ([[AppData getInstance] fbLoggedIn]) {
        [self performLoginWithType:kUserServiceTypeFacebook];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socialNetworkLoginDidFinish:) name:kSocialNetworkDidLoginNotification object:nil];
    }
}

- (IBAction)twitterButtonDidTouch:(id)sender {
    if ([[AppData getInstance] twitterLoggedIn:self]) {
        [self performLoginWithType:kUserServiceTypeTwitter];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socialNetworkLoginDidFinish:) name:kSocialNetworkDidLoginNotification object:nil];
    }
}

- (BOOL)validateInputData {
    NSString *errorMessage = nil;
    
    UserInfoTableViewCell *cell1 = (UserInfoTableViewCell*)[formTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UserInfoTableViewCell *cell2 = (UserInfoTableViewCell*)[formTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if ([cell1.valueTextField.text isEqualToString:@""] ||
         [cell2.valueTextField.text isEqualToString:@""]) {
        errorMessage = @"Please input required fields";
    }
    
    if (errorMessage) {
        [Utils displayAlert:errorMessage delegate:nil];
        return NO;
    }
    return YES;
}


- (IBAction)loginButtonDidTouch:(id)sender {
    if ([self validateInputData]) {
        [self performLoginWithType:kUserServiceTypeNormal];
    }
}

- (void)loginDidFinish:(NSNotification*)notification {
    [self stopActivityIndicator];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginFinishNotification object:nil];
    BOOL isSuccess = [[notification.userInfo objectForKey:@"isSuccess"] boolValue];
    if (isSuccess) {
        if (target) {
            [target performSelector:action withObject:self];
        } else {
            [self dismiss:nil];
        }
    } else {
        if ([self.loginType isEqualToString:kUserServiceTypeFacebook] ||
            [self.loginType isEqualToString:kUserServiceTypeTwitter]) {
            JoinViewController *controller = [[JoinViewController alloc] initWithNibName:@"JoinViewController" bundle:nil];
            controller.joinType = self.loginType;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
}

- (void)setTarget:(id)in_target action:(SEL)in_action {
    [target release];
    target = [in_target retain];
    action = in_action;
}

@end
