//
//  CategoryViewController.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "Webservices.h"
#import "Utils.h"

@implementation CategoryViewController
@synthesize category, boards;

- (void)dealloc {
    [category release];
    [boards release];
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
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.cancel", @"Cancel") target:self selector:@selector(dismiss:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BoardListRequest *request = [[BoardListRequest alloc] initWithCategoryId:self.category.categoryId];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerResponse:) name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
	[[RequestManager sharedInstance] performRequest:request];
}

- (void)handleServerResponse: (NSNotification*)in_response {
	ServerRequest *request = in_response.object;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
	
	if (!request.result.error) {
		id result = request.result.object;
		if ([result isKindOfClass:[NSArray class]]) {
            self.boards= result;
            [boardsTableView reloadData];
		}
	}
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.boards count];
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
    WSBoard *board = [boards objectAtIndex:indexPath.row];
    cell.textLabel.text = board.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
