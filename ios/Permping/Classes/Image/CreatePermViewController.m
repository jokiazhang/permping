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
#import "SwitchingTableCell.h"
#import "Utils.h"
#import "CreatePermScreen_DataLoader.h"
#import "FollowingScreen_DataLoader.h"
#import "AppData.h"
#import "Taglist_CloudService.h"

@interface CreatePermViewController ()
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
        self.currentPerm = [[PermModel alloc] init];
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
    self.selectedBoard =  [[[[AppData getInstance] user] boards] objectAtIndex:0];
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
    if (target ) {
        FollowingScreen_DataLoader * loader = [[FollowingScreen_DataLoader alloc] init];
        return [loader autorelease];
    } else {
        CreatePermScreen_DataLoader *loader = [[CreatePermScreen_DataLoader alloc] init];
        return [loader autorelease];
    }
}

- (NSDictionary*)permInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.currentPerm forKey:@"perm"];
    
    BOOL shareFacebook = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShareFacebook"];
    BOOL shareTwitter = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShareTwitter"];
    NSString *shareType = nil;
    if (shareFacebook && shareTwitter) {
        shareType = @"all";
    } else if (shareFacebook) {
        shareType = @"facebook";
    } else if (shareTwitter) {
        shareType = @"twitter";
    }
    if (shareType) {
        [dict setObject:shareType forKey:@"share"];
    }
    NSLog(@"shareType : %@", shareType);
    return [dict autorelease];
}

- (void)uploadPermForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
//        NSArray *keys = [NSArray arrayWithObjects:@"perm", @"board", @"fileData", nil];
//        NSArray *objects = [NSArray arrayWithObjects:self.currentPerm, self.selectedBoard, self.fileData, nil];
//        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects 
//                                                               forKeys:keys];
        NSString *userId = [[[AppData getInstance] user] userId];
        self.currentPerm.permCategoryId   = self.selectedBoard.boardId;
        if (target) {
            PermActionResponse *response =  [(FollowingScreen_DataLoader *)loader repermWithId:self.currentPerm.permId userId:userId boardId:self.selectedBoard.boardId description:self.currentPerm.permDesc];
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
                                       [Utils displayAlert:NSLocalizedString(@"UploadPermFailed", "Failed to upload perm. Please try again later.") delegate:nil];
                                       [self dismiss:nil];
                                   }
                               });
                
            } 

        } else {
            self.currentPerm.fileData = self.fileData;
            UploadPermResponse *response =  [(CreatePermScreen_DataLoader *)loader uploadPerm:[self permInfo]];
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
                                       [Utils displayAlert:NSLocalizedString(@"UploadPermFailed", "Failed to upload perm. Please try again later.") delegate:nil];
                                       [self dismiss:nil];
                                   }
                               });
                
            }
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
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.valueTextField.delegate = self;
                if (self.currentPerm.permDesc) {
                    cell.valueTextField.text = self.currentPerm.permDesc;
                }
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
        } else {
            static NSString *reuseIdentifier = @"placeReuseIdentifier";
            SwitchingTableCell *cell = (SwitchingTableCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (cell == nil) {
                cell = [[SwitchingTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"Place";
                cell.switching.tag = 0;
            }
            return cell;
        }
    } else {
        static NSString *reuseIdentifier = @"shareReuseIdentifier";
        SwitchingTableCell *cell = (SwitchingTableCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[SwitchingTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.switching addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        }
        cell.switching.tag = indexPath.row+1;
        if (row == 0) {
            cell.textLabel.text = @"Facebook";
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShareFacebook"]) {
                [cell.switching setOn:YES];
            }
        } else if (row == 1) {
            cell.textLabel.text = @"Twitter";
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShareTwitter"]) {
                [cell.switching setOn:YES];
            }
        } else {
            cell.textLabel.text = @"Kakao Talk";
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShareKakao"]) {
                [cell.switching setOn:YES];
            }
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
    if (![board.boardId isEqualToString:self.selectedBoard.boardId]) {
        self.selectedBoard = board;
    }
    [self.navigationController popToViewController:self animated:YES];
}

- (BOOL)validateInputData {
    CreatePermCell *cell = (CreatePermCell*)[permTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.valueTextField.text.length == 0) {
        [Utils displayAlert:@"Please input description for perm." delegate:nil];
        return NO;
    }
    return YES;
}

- (void)createPerm {
    if([self validateInputData])
    {
        [self startActivityIndicator];
        self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(uploadPermForMe:thread:) dataObject:[self getMyDataLoader]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField.text isEqualToString:self.currentPerm.permDesc]) {
        self.currentPerm.permDesc = textField.text;
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)socialNetworkLoginDidFinish:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocialNetworkDidLoginNotification object:nil];
    BOOL isSuccess = [[notification.userInfo objectForKey:@"isSuccess"] boolValue];
    if (isSuccess) {
        NSString *type = [notification.userInfo objectForKey:kUserServiceTypeKey];
        if ([type isEqualToString:kUserServiceTypeFacebook]) {
            [[NSUserDefaults standardUserDefaults] setBool:isSuccess forKey:@"ShareFacebook"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else if ([type isEqualToString:kUserServiceTypeTwitter]) {
            [[NSUserDefaults standardUserDefaults] setBool:isSuccess forKey:@"ShareTwitter"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    [currentSwitch setOn:isSuccess];
}


- (void)switchDidChangeValue:(id)sender {
    currentSwitch = (UISwitch*)sender;
    BOOL isOn = currentSwitch.isOn;
    if (currentSwitch.tag == 0) {
        geoEnable = currentSwitch.isOn;
    } else {
        NSString *key = @"";
        if (currentSwitch.tag == 1) {
            key = @"ShareFacebook";
            if (isOn && ![[AppData getInstance] fbLoggedIn]) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socialNetworkLoginDidFinish:) name:kSocialNetworkDidLoginNotification object:nil];
                return;
            }
        } else if (currentSwitch.tag == 2) {
            key = @"ShareTwitter";
            if (isOn && ![[AppData getInstance] twitterLoggedIn:self]) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socialNetworkLoginDidFinish:) name:kSocialNetworkDidLoginNotification object:nil];
                return;
            }
        } else {
            key = @"ShareKakao";
        }
        [[NSUserDefaults standardUserDefaults] setBool:isOn forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setTarget:(id)in_target action:(SEL)in_action {
    [target release];
    target = [in_target retain];
    action = in_action;
}

@end
