//
//  ExplorerViewController.m
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExplorerViewController.h"
#import "CategoryViewController.h"
#import "CategoryList_DataLoader.h"
#import "CategoryListResponse.h"
#import "CategoryModel.h"

@implementation ExplorerViewController
@synthesize resultModel;

- (void)dealloc {
    [target release];
    self.resultModel = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ExplorerTabTitle", @"Explorer");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-item-explorer"];
        hasAllCategory = YES;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];

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
    CategoryList_DataLoader *loader = [[CategoryList_DataLoader alloc] init];
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
        
        CategoryListResponse *response = [(CategoryList_DataLoader *)loader getCategoryList];
        arr = [response getResponseCategoryList];
        
        if (![threadObj isCancelled]) {
            self.resultModel.arrResults = arr;
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               //reload table
                               [categoriesTableView reloadData]; 
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
    NSInteger count = [self.resultModel.arrResults count];
    if (hasAllCategory && count > 0) {
        count++;
    }
    return count;
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
    if (hasAllCategory) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"All Category";
        } else {
            CategoryModel *category = [self.resultModel.arrResults objectAtIndex:indexPath.row-1];
            cell.textLabel.text = category.title;
        }
    } else {
        CategoryModel *category = [self.resultModel.arrResults objectAtIndex:indexPath.row];
        cell.textLabel.text = category.title;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if(target) {
        CategoryModel *category = [self.resultModel.arrResults objectAtIndex:indexPath.row];
        [target performSelector:action withObject:category];
    } else {
        CategoryModel *category = nil;
        if (indexPath.row > 0) {
            category = [self.resultModel.arrResults objectAtIndex:indexPath.row-1];
        }
        CategoryViewController *lc_controller = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
        lc_controller.category = category;
        [self.navigationController pushViewController:lc_controller animated:YES];
        [lc_controller release];
    }
}

- (void)setTarget:(id)in_target action:(SEL)in_action {
    [target release];
    target = [in_target retain];
    action = in_action;
    hasAllCategory = NO;
}

@end
