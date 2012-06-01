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

@implementation ProfileViewController
@synthesize userProfile;

- (void) dealloc {
    self.userProfile = nil;
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
    boardTableView.tableHeaderView = headerView;
    [self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startActivityIndicator];
    self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
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
        
        UserProfileResponse *response = [(UserProfile_DataLoader *)loader getUserProfileWithId:@"121"];
        UserProfileModel *user = [response getUserProfile];
        if (![threadObj isCancelled]) {
            self.userProfile = user;
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
    if (self.userProfile) {
        boardTableView.hidden = NO;
        headerView.hidden = NO;
        [avatarView setImageWithURL:[NSURL URLWithString:self.userProfile.userAvatar] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        userNameLabel.text = self.userProfile.userName;
        permsNumberLabel.text = [NSString stringWithFormat:@"perms %@ followers %@", self.userProfile.pinCount, self.userProfile.followerCount];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"perms %@ followers %@", board.pinCount, board.followers];
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
