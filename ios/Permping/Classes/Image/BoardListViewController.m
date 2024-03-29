//
//  BoardListViewController.m
//  Permping
//
//  Created by Andrew Duck on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardListViewController.h"
#import "Utils.h"
#import "AppData.h"
#import "BoardModel.h"
#import "UserProfile_DataLoader.h"
#import "UserProfileResponse.h"

@implementation BoardListViewController
@synthesize boardsArray;

- (void)dealloc {
    self.boardsArray = nil;
    [target release];
    [super dealloc];
}

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
    // Bug black corner on iOS 4
    boardListTableView.backgroundColor = [UIColor clearColor];
    
    
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.back", @"Back") target:self selector:@selector(dismiss:)];
    if ([[AppData getInstance] didLogin]) {
        NSMutableArray * boards = [[[AppData getInstance] user] boards];
        if (boards.count > 0) {
            self.boardsArray = boards;
        } else {
            // update board list
            [self startActivityIndicator];
            self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)reloadData {
    self.boardsArray = [[[AppData getInstance] user] boards];
    [boardListTableView reloadData];
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
        
        UserProfileResponse *response = [(UserProfile_DataLoader *)loader getUserProfileWithId:[[[AppData getInstance] user] userId] loggedinId:nil];
        if (![threadObj isCancelled]) {
            [AppData getInstance].user = [response getUserProfile];
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

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.boardsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"boardReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    BoardModel *board = [self.boardsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = board.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BoardModel *board = [self.boardsArray objectAtIndex:indexPath.row];
    [target performSelector:action withObject:board];
}

- (void)setTarget:(id)in_target action:(SEL)in_action {
    [target release];
    target = [in_target retain];
    action = in_action;
}

@end
