//
//  JoinViewController.m
//  Permping
//
//  Created by MAC on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoinViewController.h"
#import "UserInfoTableViewCell.h"

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
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setBackgroundImage:[UIImage imageNamed:@"bar-item-btn.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = barButtonItem;
	[barButtonItem release];
    [button release];
    
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
    // e.g. self.myOutlet = nil;
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
    
}

- (void)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
