//
//  CreatePermViewController.m
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreatePermViewController.h"
#import "BoardListViewController.h"
#import "CreatePermCell.h"
#import "Utils.h"
#import "CreatePermScreen_DataLoader.h"

@interface CreatePermViewController ()
@property (nonatomic, retain) PermModel    *currentPerm;
- (void)uploadPermForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj;
@end



@implementation CreatePermViewController
@synthesize imageInfo, selectedBoard;
@synthesize currentPerm;
@synthesize fileData;

- (void)dealloc {
    self.imageInfo = nil;
    self.selectedBoard = nil;
    self.currentPerm = nil;
    self.fileData = nil;
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
    self.navigationItem.rightBarButtonItem = [Utils barButtonnItemWithTitle:NSLocalizedString(@"globals.ok", @"OK") target:self selector:@selector(createPerm)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [permTableView reloadData];
}

#pragma mark - Override methods
- (id)getMyDataLoader
{
    CreatePermScreen_DataLoader *loader = [[CreatePermScreen_DataLoader alloc] init];
    return [loader autorelease];
}

- (void)uploadPermForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        NSArray *keys = [NSArray arrayWithObjects:@"perm", @"board", @"fileData", nil];
        NSArray *objects = [NSArray arrayWithObjects:self.currentPerm, self.selectedBoard, self.fileData, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects 
                                                               forKeys:keys];
        NSArray *arr = nil;
        
        UploadPermResponse *response =  [(CreatePermScreen_DataLoader *)loader uploadPerm:dictionary];

    
       // arr = [response getResponsePermList];
        
        if (![threadObj isCancelled]) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                                
                           });
            
        }
    }
    //[myLoader release];
    [pool drain];
}


#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 2;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            static NSString *reuseIdentifier = @"descReuseIdentifier";
            CreatePermCell *cell = (CreatePermCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (cell == nil) {
                cell = [[[CreatePermCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.valueTextField.delegate = self;
            }
            return cell;
        } else if (row == 1) {
            static NSString *reuseIdentifier = @"categoryReuseIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"Board :";
            }
            if (self.selectedBoard) cell.detailTextLabel.text = self.selectedBoard.title;
            return cell;
        }
    } else {
        static NSString *reuseIdentifier = @"shareReuseIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        if (row == 0) {
            cell.textLabel.text = @"Facebook";
        } else if (row == 1) {
            cell.textLabel.text = @"Twitter";
        } else {
            cell.textLabel.text = @"Kakao Talk";
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 1) {
        BoardListViewController *controller = [[BoardListViewController alloc] initWithNibName:@"BoardListViewController" bundle:nil];
        [controller setTarget:self action:@selector(selectBoard:)];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

- (void)selectBoard:(BoardModel*)board {
    self.selectedBoard = board; 
    [self.navigationController popToViewController:self animated:YES];
}

- (void)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)createPerm {
    
    if(self.selectedBoard  != nil)
    {
        self.currentPerm = [[PermModel alloc] init];
        self.currentPerm.permDesc = @"";
        [self startActivityIndicator];
        self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(uploadPermForMe:thread:) dataObject:[self getMyDataLoader]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
