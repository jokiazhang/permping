//
//  ExplorerViewController.m
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExplorerViewController.h"
#import "CategoryViewController.h"
#import "Webservices.h"

@implementation ExplorerViewController
@synthesize categories;

- (void)dealloc {
    [categories release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"ExplorerTabTitle", @"Explorer");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-item-explorer"];
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
    CategoriesRequest *request = [[CategoriesRequest alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerResponse:) name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
	[[RequestManager sharedInstance] performRequest:request];
}

- (void)handleServerResponse: (NSNotification*)in_response {
	ServerRequest *request = in_response.object;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
	
	if (!request.result.error) {
		id result = request.result.object;
		if ([result isKindOfClass:[NSArray class]]) {
            self.categories = result;
            [categoriesTableView reloadData];
		}
	}
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
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
    WSCategory *category = [categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CategoryViewController *lc_controller = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
    lc_controller.category = [self.categories objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:lc_controller animated:YES];
    [lc_controller release];
}

@end
