//
//  CreateBoardViewController.m
//  Permping
//
//  Created by MAC on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateBoardViewController.h"
#import "ExplorerViewController.h"
#import "CreatePermCell.h"
#import "Utils.h"
#import "CreateBoard_DataLoader.h"
#import "AppData.h"

@implementation CreateBoardViewController
@synthesize selectedCategory;

- (void)dealloc {
    self.selectedCategory = nil;
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
    self.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.cancel", @"Cancel") target:self selector:@selector(dismiss:)];
    self.navigationItem.rightBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.ok", @"OK") target:self selector:@selector(createBoard)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        static NSString *reuseIdentifier = @"categoryReuseIdentifier";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"Category", nil)];
        if (self.selectedCategory) {
            cell.detailTextLabel.text = self.selectedCategory.title;
        }
        return cell;
    } else {
        static NSString *reuseIdentifier = @"boardReuseIdentifier";
        CreatePermCell *cell = (CreatePermCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[CreatePermCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.valueTextField.delegate = self;
            cell.valueTextField.placeholder = @"";
        }
        
        if (row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"Name", nil)];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"Description", nil)];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ExplorerViewController *controller = [[ExplorerViewController alloc] initWithNibName:@"ExplorerViewController" bundle:nil];
        controller.navigationItem.leftBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.back", @"Back") target:self selector:@selector(dismiss:)];
        [controller setTarget:self action:@selector(selectCategory:)];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

- (void)selectCategory:(CategoryModel*)category {
    self.selectedCategory = category;
    [boardInfoTableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

- (BOOL)validateInputData {
    // TODO
    return YES;
}

- (void)createBoard {
    if([self validateInputData])
    {
        [self startActivityIndicator];
        self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(createBoardForMe:thread:) dataObject:[self getMyDataLoader]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Override methods
- (id)getMyDataLoader
{
    CreateBoard_DataLoader *loader = [[CreateBoard_DataLoader alloc] init];
    return [loader autorelease];

}

- (void)createBoardForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        CreatePermCell *cell1 = (CreatePermCell*)[boardInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        CreatePermCell *cell2 = (CreatePermCell*)[boardInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        NSString *userId = [[[AppData getInstance] user] userId];
        NSDictionary *boardInfo = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"uid", self.selectedCategory.categoryId, @"cid", cell1.valueTextField.text, @"bname", cell2.valueTextField.text, @"board_desc", nil];
        Taglist_CloudResponse *response =  [(CreateBoard_DataLoader *)loader createBoardWithInfo:boardInfo];
        NSError *error = response.responseError;
        if (![threadObj isCancelled]) {
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               if (error) {
                                   [Utils displayAlert:[error localizedDescription] delegate:nil];
                                   if (error.code == 200) {
                                       [self dismiss:nil];
                                   }
                               } else {
                                   [Utils displayAlert:NSLocalizedString(@"CreateBoardFailed", @"Failed to create board. Please try again later.") delegate:nil];
                                   [self dismiss:nil];
                               }
                           });
            
        }
    }
    //[myLoader release];
    [pool drain];
}

@end
