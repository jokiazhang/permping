//
//  ProfileViewController.m
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "BoardViewController.h"
#import "UserProfile_DataLoader.h"
#import "UserProfileResponse.h"
#import "BoardModel.h"
#import "AppData.h"
#import "LoginViewController.h"
#import "LogoutViewController.h"
#import "Utils.h"

@implementation ProfileViewController

- (void) dealloc {
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ProfileTabTitle", @"Profile");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-item-profile"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"ProfileAccountButton", @"Account") target:self selector:@selector(accountButtonDidTouch:)];
    boardTableView.tableHeaderView = headerView;
    [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[AppData getInstance] didLogin]) {
        [self startActivityIndicator];
        self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if(![[AppData getInstance] didLogin]) {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.hasCancel = NO;
        [self.navigationController pushViewController:controller animated:NO];
        [controller release];
    }
}

- (void)accountButtonDidTouch:(id)sender {
    LogoutViewController *controller = [[LogoutViewController alloc] initWithNibName:@"LogoutViewController" bundle:nil];
    //[self.navigationController pushViewController:controller animationTransition:UIViewAnimationTransitionFlipFromRight];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark - Override methods
- (id)getMyDataLoader
{
    UserProfile_DataLoader *loader = [[UserProfile_DataLoader alloc] init];
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
        NSString *userId = [[[AppData getInstance] user] userId];
        if (userId) {
            UserProfileResponse *response = [(UserProfile_DataLoader *)loader getUserProfileWithId:@"121"];
            UserProfileModel *user = [response getUserProfile];
            if (![threadObj isCancelled]) {
                [AppData getInstance].user = user;
                dispatch_async(dispatch_get_main_queue(), ^(void)
                               {
                                   [self stopActivityIndicator];
                                   [self reloadData];
                               });
            }
        }
    }
    //[myLoader release];
    [pool drain];
}

- (void)reloadData {
    if ([[AppData getInstance] didLogin]) {
        UserProfileModel *user = [[AppData getInstance] user];
        boardTableView.hidden = NO;
        headerView.hidden = NO;
        [avatarView setImageWithURL:[NSURL URLWithString:user.userAvatar] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        userNameLabel.text = user.userName;
        permsNumberLabel.text = [NSString stringWithFormat:@"perms %@ followers %@", user.pinCount, user.followerCount];
        [boardTableView reloadData];
    } else {
        boardTableView.hidden = YES;
        headerView.hidden = YES;
    }
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[AppData getInstance] user].boards count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"boardReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    BoardModel *board = [[[AppData getInstance] user].boards objectAtIndex:indexPath.row];
    cell.textLabel.text = board.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"perms %@ followers %@", board.pinCount, board.followers];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BoardModel *board = [[[AppData getInstance] user].boards objectAtIndex:indexPath.row];
    NSLog(@"board : %@", board.boardId);
    
    BoardViewController *lc_controller = [[BoardViewController alloc] initWithNibName:@"BoardViewController" bundle:nil];
    lc_controller.board = board;
    [self.navigationController pushViewController:lc_controller animated:YES];
    [lc_controller release];
}

@end
