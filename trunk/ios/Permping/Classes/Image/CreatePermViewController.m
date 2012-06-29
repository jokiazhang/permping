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
#import "KakaoLinkCenter.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface CreatePermViewController ()
@property (nonatomic, retain) NSString *permId;
@property (nonatomic, retain) NSString *permAndroidLink;
@property (nonatomic, retain) NSString *permIphoneLink;
- (void)uploadPermForMe:(id)loader thread:(id<ThreadManagementProtocol>)threadObj;
@end



@implementation CreatePermViewController
@synthesize imageInfo, selectedBoard;
@synthesize currentPerm;
@synthesize fileData;
@synthesize locationManager, bestEffortAtLocation;
@synthesize permId, permAndroidLink, permIphoneLink;

- (void)dealloc {
    self.locationManager = nil;
    self.bestEffortAtLocation = nil;
    self.imageInfo = nil;
    self.selectedBoard = nil;
    self.currentPerm = nil;
    self.fileData = nil;
    self.permId = nil;
    self.permAndroidLink = nil;
    self.permIphoneLink = nil;
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
    // Bug black corner on iOS 4
    permTableView.backgroundColor = [UIColor clearColor];
    
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
    [super viewWillAppear:animated];
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
        NSString *fbtoken = [[AppData getInstance] oauthTokenForType:kUserServiceTypeFacebook];
        if (fbtoken) {
            [dict setObject:fbtoken forKey:@"fb_oauth_token"];
        }
        NSString *twtoken = [[AppData getInstance] oauthTokenForType:kUserServiceTypeTwitter];
        if (twtoken) {
            [dict setObject:twtoken forKey:@"tw_oauth_token"];
        }
        NSString *twsecret = [[AppData getInstance] oauthTokenSecret];
        if (twsecret) {
            [dict setObject:twsecret forKey:@"tw_oauth_token_secret"];
        }
    } else if (shareFacebook) {
        shareType = @"facebook";
        NSString *fbtoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        if (fbtoken) {
            [dict setObject:fbtoken forKey:@"fb_oauth_token"];
        }
    } else if (shareTwitter) {
        shareType = @"twitter";
        NSString *twtoken = [[AppData getInstance] oauthTokenForType:kUserServiceTypeTwitter];
        if (twtoken) {
            [dict setObject:twtoken forKey:@"tw_oauth_token"];
        }
        NSString *twsecret = [[AppData getInstance] oauthTokenSecret];
        if (twsecret) {
            [dict setObject:twsecret forKey:@"tw_oauth_token_secret"];
        }
    }
    
    if (shareType) {
        [dict setObject:shareType forKey:@"share"];
    }
    
    if (geoEnable && self.bestEffortAtLocation) {
        NSString *lat = [NSString stringWithFormat:@"%f", bestEffortAtLocation.coordinate.latitude];
        NSString *longi = [NSString stringWithFormat:@"%f", bestEffortAtLocation.coordinate.longitude];
        [dict setObject:lat forKey:@"lat"];
        [dict setObject:longi forKey:@"long"];
    }
    
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
            self.permId = self.currentPerm.permId;
            NSError *error = response.responseError;
            if (![threadObj isCancelled]) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^(void)
                               {
                                   [self stopActivityIndicator];
                                   if (error) {
                                       [Utils displayAlert:[error localizedDescription] delegate:self];
                                       if (error.code == 200) {
                                           uploadSuccess = YES;
                                           //[self dismiss:nil];
                                       }
                                   } else {
                                       [Utils displayAlert:NSLocalizedString(@"UploadPermFailed", @"Failed to upload perm. Please try again later.") delegate:nil];
                                       [self dismiss:nil];
                                   }
                               });
                
            } 

        } else {
            self.currentPerm.fileData = self.fileData;
            UploadPermResponse *response =  [(CreatePermScreen_DataLoader *)loader uploadPerm:[self permInfo]];
            NSError *error = response.responseError;
            self.permId = response.permId;
            self.permIphoneLink = response.permIphoneLink;
            self.permAndroidLink = response.permAndroidLink;
            if (![threadObj isCancelled]) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void)
                               {
                                   [self stopActivityIndicator];
                                   if (error) {
                                       [Utils displayAlert:[error localizedDescription] delegate:self];
                                       if (error.code == 200) {
                                           uploadSuccess = YES;
                                           //[self dismiss:nil];
                                       }
                                   } else {
                                       [Utils displayAlert:NSLocalizedString(@"UploadPermFailed", @"Failed to upload perm. Please try again later.") delegate:nil];
                                       [self dismiss:nil];
                                   }
                               });
                
            }
        }
        
        
    }
    //[myLoader release];
    [pool drain];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (uploadSuccess) {
        if (!target) {
            BOOL shareKakao = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShareKakao"];
            if (shareKakao) {
                // Note: 
                // Url to open permping again : @"permping://"
                // This is registered in Permping-Info.plist , key : URL Types
                
                NSString *message = [NSString stringWithFormat:@"pindetails/%@", self.permId];
                NSString *executeUrl = [LAUNCH_APP_URL stringByAppendingFormat:@"pindetails/%@", self.permId]; 
                NSArray *array = [NSArray arrayWithObjects:@"os", @"iphone", @"devicetype", @"phone", @"installurl", self.permIphoneLink, @"executeurl", executeUrl,nil];
                NSString *url = [NSString stringWithFormat:@"%@ & %@", self.permIphoneLink, self.permAndroidLink];
                [[KakaoLinkCenter defaultCenter] openKakaoAppLinkWithMessage:message URL:url appBundleID:@"webactully" appVersion:@"2.0" appName:@"Permping App" metaInfoArray:array];
            }
        }
        [self dismiss:nil];
    }
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 2;
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
                cell.textLabel.text = [NSString stringWithFormat:@"%@ :", NSLocalizedString(@"Board", nil)];
            }
            if (self.selectedBoard) cell.detailTextLabel.text = self.selectedBoard.title;
            return cell;
        } else {
            static NSString *reuseIdentifier = @"placeReuseIdentifier";
            SwitchingTableCell *cell = (SwitchingTableCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (cell == nil) {
                cell = [[SwitchingTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = NSLocalizedString(@"Place", nil);
                cell.switching.tag = 0;
                [cell.switching addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
                if (target) {
                    cell.switching.enabled = NO;
                }
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
            cell.textLabel.text = NSLocalizedString(@"Facebook", nil);
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShareFacebook"]) {
                [cell.switching setOn:YES];
            }
        }/* else if (row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Twitter", nil);
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShareTwitter"]) {
                [cell.switching setOn:YES];
            }
        } */else {
            if (target) {
                cell.switching.enabled = NO;
            }
            cell.textLabel.text = NSLocalizedString(@"KakaoTalk", nil);
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
    } else {
        self.currentPerm.permDesc = cell.valueTextField.text;
    }
    UITableViewCell *cell2 = [permTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]; 
    if (cell2.detailTextLabel.text.length == 0) {
        [Utils displayAlert:@"Please select board." delegate:nil];
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

- (void)handleApplicationDidBecomeActive:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationDidBecomeActiveNotification object:nil];
    if ([CLLocationManager locationServicesEnabled] == YES && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
    } else {
        geoEnable = NO;
        SwitchingTableCell *cell = (SwitchingTableCell*)[permTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.switching setOn:NO];
    }
}

- (void)switchDidChangeValue:(id)sender {
    currentSwitch = (UISwitch*)sender;
    BOOL isOn = currentSwitch.isOn;
    if (currentSwitch.tag == 0) {
        if (currentSwitch.isOn) {
            if ([CLLocationManager locationServicesEnabled] == NO) {
                [currentSwitch setOn:NO];
                [Utils displayAlert:@"You currently have all location services for this device disabled." delegate:nil];
            } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
                       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
                [currentSwitch setOn:NO];
                [Utils displayAlert:@"This application is not authorized to use location services." delegate:nil];
            } else {
                if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidBecomeActive:) name:kApplicationDidBecomeActiveNotification object:nil];
                }
            }
            geoEnable = currentSwitch.isOn;
            if (geoEnable) {
                [self setupLocationManager];
            }
        }
        
    } else {
        NSString *key = @"";
        if (currentSwitch.tag == 1) {
            key = @"ShareFacebook";
            if (isOn && ![[AppData getInstance] fbLoggedIn]) {
                [currentSwitch setOn:NO];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socialNetworkLoginDidFinish:) name:kSocialNetworkDidLoginNotification object:nil];
                return;
            }
        }/* else if (currentSwitch.tag == 2) {
            key = @"ShareTwitter";
            if (isOn && ![[AppData getInstance] twitterLoggedIn:self]) {
                [currentSwitch setOn:NO];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socialNetworkLoginDidFinish:) name:kSocialNetworkDidLoginNotification object:nil];
                return;
            }
        } */else {
            key = @"ShareKakao";
            if (isOn) {
                BOOL canOpen = [[KakaoLinkCenter defaultCenter] canOpenKakaoLink];
                if (!canOpen) {
                    [currentSwitch setOn:NO];
                    [Utils displayAlert:@"Please install the Kakao Talk app." delegate:nil];
                }
            }
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

#pragma mark -
#pragma mark Location Manager
#pragma mark -
- (void)stopUpdatingLocation {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}

- (void)setupLocationManager {
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    if (newLocation.horizontalAccuracy < 0) return;
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        self.bestEffortAtLocation = newLocation;
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            [self stopUpdatingLocation];
        }
    }    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] != kCLErrorLocationUnknown) {
        geoEnable = NO;
        SwitchingTableCell *cell = (SwitchingTableCell*)[permTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.switching setOn:NO];
        [self stopUpdatingLocation];
    }
}
@end
