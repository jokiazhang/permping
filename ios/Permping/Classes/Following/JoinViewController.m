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
#import "Taglist_CloudService.h"
#import "CreateAccount_DataLoader.h"
#import "CreateAccountResponse.h"

@implementation JoinViewController
@synthesize loggedin, fieldsTitle;

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
    
    if (loggedin) {
        self.fieldsTitle = [NSArray arrayWithObjects:@"Name :", @"Email :", @"Password :", @"Confirm Password :", nil];
    } else {
        self.fieldsTitle = [NSArray arrayWithObjects:@"Name :", @"Nick Name :", @"Username :", @"Email :", @"Password :", @"Confirm Password :", nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [super dealloc];
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
    }
    
    cell.textLabel.text = [self.fieldsTitle objectAtIndex:indexPath.row];
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

- (IBAction)createAccountButtonDidTouch:(id)sender {
    [self startActivityIndicator];
    self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
}

#pragma mark - Override methods
- (id)getMyDataLoader
{
    CreateAccount_DataLoader *loader = [[CreateAccount_DataLoader alloc] init];
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
        userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"perm", kUserServiceTypeKey, @"test123", kUserServiceNameKey, @"test123", kUserServiceUserNameKey, @"test123@test.com", kUserServiceEmailKey, @"123456", kUserServicePasswordKey, @"123456", kUserServiceCPasswordKey, @"", kUserServiceOauthTokenKey, nil];
        CreateAccountResponse *response = [(CreateAccount_DataLoader *)loader createAccountWithUserInfo:userInfo];
        
        if (![threadObj isCancelled]) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                           });
        }
    }
    //[myLoader release];
    [pool drain];
}

- (void)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
