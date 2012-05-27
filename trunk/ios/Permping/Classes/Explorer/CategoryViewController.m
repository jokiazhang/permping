//
//  CategoryViewController.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "BoardViewController.h"
#import "BoardList_DataLoader.h"
#import "BoardListReponse.h"
#import "BoardModel.h"
#import "Utils.h"

@implementation CategoryViewController
@synthesize category;
@synthesize resultModel;
- (void)dealloc {
    self.category = nil;
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
    BoardList_DataLoader *loader = [[BoardList_DataLoader alloc] init];
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
        NSArray *arr = nil;
        
        BoardListReponse *response = [(BoardList_DataLoader *)loader getBoardListWithCategoryId:self.category.categoryId];
        arr = [response getResponseBoardList];
        
        if (![threadObj isCancelled]) {
            self.resultModel.arrResults = arr;
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               //reload table
                               [boardsTableView reloadData]; 
                           });
        }
    }
    [pool drain];
}


#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultModel.arrResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *categoryReuseIdentifier = @"categoryReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    BoardModel *board = [self.resultModel.arrResults objectAtIndex:indexPath.row];
    cell.textLabel.text = board.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BoardViewController *lc_controller = [[BoardViewController alloc] initWithNibName:@"BoardViewController" bundle:nil];
    lc_controller.board = [self.resultModel.arrResults objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:lc_controller animated:YES];
    [lc_controller release];
}

- (void)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
