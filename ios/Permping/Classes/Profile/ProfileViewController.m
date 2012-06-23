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
#import "FollowResponse.h"


@implementation ProfileViewController
@synthesize userId, userProfile;

- (void) dealloc {
    self.userProfile = nil;
    self.userId = nil;
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
    // Bug black corner on iOS 4
    boardTableView.backgroundColor = [UIColor clearColor];
    
    if (self.userId) {
        self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.back", @"Back") target:self selector:@selector(dismiss:)];
    } else {
        self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"Account", @"Account") target:self selector:@selector(accountButtonDidTouch:)];
    }
    boardTableView.tableHeaderView = headerView;
    [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    followButton.hidden = ((self.userId==nil) || ![[AppData getInstance] didLogin]);
    if([[AppData getInstance] didLogin] || self.userId) {
        if (!self.userId) {
            self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"Account", @"Account") target:self selector:@selector(accountButtonDidTouch:)];
        }
        [self startActivityIndicator];
        self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
    } else {
        if (!self.userId) {
            [self reloadData];
            self.navigationItem.leftBarButtonItem = nil;
        }

//        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        controller.hasCancel = NO;
//        //[self.navigationController presentModalViewController:controller animated:YES];
//        [self.navigationController pushViewController:controller animated:NO];
//        [controller release];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![[AppData getInstance] didLogin] && !self.userId) {
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.hasCancel = NO;
        //[self.navigationController presentModalViewController:controller animated:YES];
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

- (IBAction)followButtonDidTouch:(id)sender {
    [self startActivityIndicator];
    self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(performFollow:thread:) dataObject:[self getMyDataLoader]];
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
        NSString *loggedinId = nil;
        NSString *uid = nil;
        if (self.userId) {
            uid = self.userId;
            loggedinId = [[[AppData getInstance] user] userId];
        } else {
            uid = [[[AppData getInstance] user] userId];
        }
        
        NSLog(@"get profile userid: %@", uid);
        if (uid) {
            UserProfileResponse *response = [(UserProfile_DataLoader *)loader getUserProfileWithId:uid loggedinId:loggedinId];
            if (![threadObj isCancelled]) {
                self.userProfile = [response getUserProfile];
                isFollowed = response.isFollowed;
                // update login user profile
                if (!self.userId) {
                    [AppData getInstance].user = self.userProfile;
                }
                
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


- (void)performFollow:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        FollowResponse *response = [(UserProfile_DataLoader *)loader followUserId:self.userId followerId:[[[AppData getInstance] user] userId]];
        if (![threadObj isCancelled]) {
            isFollowed = ([response.status intValue]==1);
            self.userProfile.followerCount = response.totalFollows;
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               [self reloadData];
                           });
        }
    }
    //[myLoader release];
    [pool drain];
}


- (void)reloadData {
    BOOL didLogin = [[AppData getInstance] didLogin];
    if (!self.userId && didLogin) {
        self.userProfile = [[AppData getInstance] user];
    }
    followButton.hidden = ((self.userId==nil) || !didLogin);
    if (self.userProfile) {
        boardTableView.hidden = NO;
        headerView.hidden = NO;
        [avatarView setImageWithURL:[NSURL URLWithString:self.userProfile.userAvatar] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        userNameLabel.text = self.userProfile.userName;
        permsNumberLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"Perms", nil), self.userProfile.pinCount, NSLocalizedString(@"Followers", nil), self.userProfile.followerCount];
        [followButton setTitle:isFollowed?NSLocalizedString(@"Unfollow", nil):NSLocalizedString(@"Follow", nil) forState:UIControlStateNormal];
        [boardTableView reloadData];
    } else {
        boardTableView.hidden = YES;
        [boardTableView reloadData];
        
        headerView.hidden = YES;
        avatarView.image = nil;
        userNameLabel.text = @"";
        permsNumberLabel.text = @"";
    }
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userProfile.boards count];
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
    BoardModel *board = [self.userProfile.boards objectAtIndex:indexPath.row];
    cell.textLabel.text = board.title;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"Perms", nil), board.pinCount, NSLocalizedString(@"Followers", nil), board.followers];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BoardModel *board = [self.userProfile.boards objectAtIndex:indexPath.row];
    NSLog(@"board : %@", board.boardId);
    
    BoardViewController *lc_controller = [[BoardViewController alloc] initWithNibName:@"BoardViewController" bundle:nil];
    lc_controller.board = board;
    [self.navigationController pushViewController:lc_controller animated:YES];
    [lc_controller release];
}

@end
