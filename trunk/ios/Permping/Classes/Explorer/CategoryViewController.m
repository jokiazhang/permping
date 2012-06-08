//
//  CategoryViewController.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "FollowingScreen_DataLoader.h"
#import "PermListResponse.h"
#import "Utils.h"

@implementation CategoryViewController
@synthesize category;
- (void)dealloc {
    self.category = nil;
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
    [self resetData];
    self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancelAllThreads];
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
        
        PermListResponse *response = [(FollowingScreen_DataLoader *)loader getPermWithCategorydId:self.category.categoryId nextItemId:nextId requestedCount:30];
        
        nextId = response.nextItemId;
        arr = [response getResponsePermList];
        if (![threadObj isCancelled]) {
            self.resultModel.arrResults = arr;
            self.resultModel.nextItemId = nextId;
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               [self finishLoadData]; 
                           });
            //[self downloadThumbnailForObjectList:arr];
        }
        
        
        
//        if (![threadObj isCancelled]) {
//            self.resultModel.arrResults = arr;
//            self.resultModel.nextItemId = response.nextItemId;
//            dispatch_async(dispatch_get_main_queue(), ^(void)
//                           {
//                               [self stopActivityIndicator];
//                               //reload table
//                               [permTableview reloadData]; 
//                           });
//        }
    }
    [pool drain];
}

- (void)loadMoreDataForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSInteger nextId = self.resultModel.nextItemId;

    
    PermListResponse *response = [(FollowingScreen_DataLoader *)loader getPermWithCategorydId:self.category.categoryId nextItemId:nextId requestedCount:30];
    nextId = response.nextItemId;
    NSArray *moreItems = [response getResponsePermList];
    
    if (![threadObj isCancelled]) {
        self.resultModel.arrResults = [self.resultModel.arrResults arrayByAddingObjectsFromArray:moreItems];
        
        if([resultModel.arrResults count] == 0)
        {
            //show alert
            NSString *content = NSLocalizedString(@"LoadMorePermsNoResult", @"");
            [Utils displayAlert:content delegate:nil];
        }
        self.resultModel.nextItemId = nextId;
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [permTableview reloadData]; 
                       });
        
        //[self downloadThumbnailForObjectList:moreItems];
    }
    self.resultModel.isFetching = NO;    
    [pool drain];
}

@end
