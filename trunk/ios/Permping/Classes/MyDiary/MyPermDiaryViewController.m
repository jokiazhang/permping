//
//  MyPermDiaryViewController.m
//  Permping
//
//  Created by Phong Le on 5/31/12.
//  Copyright (c) 2012 APPO. All rights reserved.
//

#import "MyPermDiaryViewController.h"
#import "Utils.h"
#import "MyDiaryScreen_DataLoader.h"

@interface MyPermDiaryViewController ()

@end

@implementation MyPermDiaryViewController
@synthesize currentDate;


- (void)dealloc {
    self.currentDate = nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.back", @"Back") target:self selector:@selector(dismiss:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetData];
    [self startActivityIndicator];
    self.resultModel.arrResults = nil;
    self.resultModel = [[[Taglist_NDModel alloc] init] autorelease];
    self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadDataForMe:thread:) dataObject:[self getMyDataLoader]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Override methods
- (id)getMyDataLoader
{
    MyDiaryScreen_DataLoader *loader = [[MyDiaryScreen_DataLoader alloc] init];
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
        
        PermListResponse *response = [(MyDiaryScreen_DataLoader *)loader getPermWithDate:self.currentDate  nextItemId:nextId requestedCount:30];
        nextId = response.nextItemId;
        arr = [response getResponsePermList];
        
        if (![threadObj isCancelled]) {
            self.resultModel.arrResults = arr;
            
            self.resultModel.nextItemId = nextId;
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               //reload table
                               [self finishLoadData]; 
                           });
            //[self downloadThumbnailForObjectList:arr];
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
