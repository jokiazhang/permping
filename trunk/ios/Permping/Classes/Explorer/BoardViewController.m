//
//  BoardViewController.m
//  Permping
//
//  Created by MAC on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"
#import "FollowingScreen_DataLoader.h"
#import "PermListResponse.h"
#import "Utils.h"

@implementation BoardViewController
@synthesize board;
@synthesize resultModel;

- (void)dealloc {
    self.board = nil;
    self.resultModel = nil;
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
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.back", @"Back") target:self selector:@selector(dismiss:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startActivityIndicator];
    self.resultModel.arrResults = nil;
    self.resultModel = [[[Taglist_NDModel alloc] init] autorelease];
    self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
}

#pragma mark - Override methods
- (id)getMyDataLoader
{
    FollowingScreen_DataLoader *loader = [[FollowingScreen_DataLoader alloc] init];
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
        NSInteger    nextId = -1;
        NSArray *arr = nil;
        NSLog(@"getPermWithBoardId : %@", self.board.boardId);
        PermListResponse *response = [(FollowingScreen_DataLoader *)loader getPermWithBoardId:self.board.boardId nextItemId:nextId requestedCount:30];
        nextId = response.nextItemId;
        arr = [response getResponsePermList];
        
        if (![threadObj isCancelled]) {
            self.resultModel.arrResults = arr;
            self.permsArray = self.resultModel.arrResults;
            self.resultModel.nextItemId = nextId;
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               //reload table
                               [permTableview reloadData]; 
                           });
            [self downloadThumbnailForObjectList:arr];
        }
    }
    //[myLoader release];
    [pool drain];
}

- (void)loadMoreDataForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    
}

- (void)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
