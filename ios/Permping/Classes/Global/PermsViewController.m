//
//  PermsViewController.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermsViewController.h"
#import "PermUserCell.h"
#import "PermImageCell.h"
#import "PermCommentCell.h"
#import "Utils.h"
//phong add
#import "CommentModel.h"
#import "FollowingScreen_DataLoader.h"
#import "Taglist_CloudResponse.h"
#import "AppData.h"
#import "CreatePermViewController.h"

#define kSeperatorCellTag 333
#define kSpinnerCellTag 123456

@interface PermsViewController ()
@property (nonatomic, retain) UITableView *permTableview;
@property (nonatomic, retain) NSMutableDictionary *permsImageHeight;
@property (nonatomic, retain) UILabel *noFoundLabel;
@end

@implementation PermsViewController
@synthesize permTableview, permsImageHeight;
@synthesize resultModel, noFoundLabel, selectedPerms;
@synthesize loadMoreSpinner;

- (void)dealloc {
    self.permTableview = nil;
    self.permsImageHeight = nil;
    self.resultModel = nil;
    self.noFoundLabel = nil;
    self.selectedPerms = nil;
    self.loadMoreSpinner = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)initCommentToolBar {
    if (commentToolBar) {
        [commentToolBar release]; commentToolBar = nil;
    }
    CGRect r = self.view.bounds;
    commentToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, r.size.height, r.size.width, 44)];
    
    commentTextField = [[[UITextField alloc] initWithFrame:CGRectMake(12, 7, 245, 31)] autorelease];
    commentTextField.backgroundColor = [UIColor whiteColor];
    commentTextField.borderStyle = UITextBorderStyleRoundedRect;
    commentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    commentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    commentTextField.delegate = self;
    commentTextField.text = @"";

    UIBarButtonItem *content = [[UIBarButtonItem alloc] initWithCustomView:commentTextField];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneCommentButtonDidTouch:)];
    commentToolBar.items = [NSArray arrayWithObjects:content, doneButton, nil];
    [content release];
    [doneButton release];
    
    [self.view addSubview:commentToolBar];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loadMoreSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    self.loadMoreSpinner.backgroundColor = [UIColor grayColor];
    self.loadMoreSpinner.tag = kSpinnerCellTag;
    [self initCommentToolBar];
    
    self.noFoundLabel = [[[UILabel alloc] initWithFrame:self.view.bounds] autorelease];
    noFoundLabel.textAlignment = UITextAlignmentCenter;
    noFoundLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    noFoundLabel.text = NSLocalizedString(@"NoFoundPerms", @"No found Perms");
    noFoundLabel.font = [UIFont systemFontOfSize:20];
    noFoundLabel.hidden = YES;
    [self.view addSubview:noFoundLabel];
    
    self.permTableview = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    permTableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    permTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    permTableview.backgroundColor = [UIColor clearColor];
    permTableview.delegate = self;
    permTableview.dataSource = self;
    [self.view addSubview:permTableview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.permsImageHeight = nil;
    self.permTableview = nil;
    self.noFoundLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([loadMoreSpinner superview]) {
        [loadMoreSpinner removeFromSuperview];
    }
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)resetData {
    self.resultModel.arrResults = nil;
    self.resultModel = [[[Taglist_NDModel alloc] init] autorelease];
    
    self.permsImageHeight = nil;
    self.permsImageHeight = [[[NSMutableDictionary alloc] init] autorelease];
    
    self.selectedPerms = nil;
    self.selectedPerms = [[[NSMutableArray alloc] init] autorelease];
}

- (void)finishLoadData {
    [self.permTableview reloadData];
    if (self.resultModel.arrResults.count == 0) {
        self.noFoundLabel.hidden = NO;
    } else {
        self.noFoundLabel.hidden = YES;
    }
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = [self.resultModel.arrResults count] + (self.resultModel.isFetching?1:0);
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (section >= [self.resultModel.arrResults count]) {
        number = 1; 
    } else {
        PermModel *perm = [self.resultModel.arrResults objectAtIndex:section];
        NSInteger seperator = (section==(self.resultModel.arrResults.count-1))?0:1;
        NSInteger count = 3 + perm.permComments.count + seperator;
        number = MIN(count, 8+seperator); // max 5 comment;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 60.0;
    if (indexPath.section < [resultModel.arrResults count]) {
        PermModel *perm = [self.resultModel.arrResults objectAtIndex:indexPath.section];
        if (indexPath.row == 1) {
            NSNumber *height = [permsImageHeight objectForKey:[NSString stringWithFormat:@"%d", indexPath.section]];
            if (height) {
                h = [height floatValue];
            }
        } else if (indexPath.row == 2) {
            CGSize s = [perm.permDesc sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
            h = 120 + s.height;
        } else if (indexPath.row - 3 == perm.permComments.count) { 
            h = 10;
        }
    }    
    return h;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    NSInteger section = indexPath.section;
    if (section < [resultModel.arrResults count]) {
        PermModel *perm = [self.resultModel.arrResults objectAtIndex:indexPath.section];
        if (index == 0) {
            static NSString *cellIdentifier = @"PermUserCell";
            PermUserCell *cell = (PermUserCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[PermUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            [cell setCellWithAvartarURLString:perm.permUser.userAvatar userName:perm.permUser.userName category:perm.permCategory];
            return cell;
        } else if (index == 1){
            static NSString *cellIdentifier = @"PermImageCell";
            PermImageCell *cell = (PermImageCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[PermImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            //NSLog(@"imageString: %@", perm.permImage);
            [cell.permImageView setImageWithURL:[NSURL URLWithString:perm.permImage] success:^(UIImage *image) {
                if (![permsImageHeight objectForKey:[NSString stringWithFormat:@"%d", section]]) {
                    CGFloat height = [Utils sizeWithImage:image constrainedToSize:CGSizeMake(300, 300)].height;
                    [permsImageHeight setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormat:@"%d", section]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [permTableview reloadData];
                    });
                }
            } failure:^(NSError *error) {
                
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

            return cell;
        } else if (index == 2) {
            static NSString *cellIdentifier = @"PermInfoCell";
            PermInfoCell *cell = (PermInfoCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[PermInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            [cell setCellWithPerm:perm];
            return cell;
        } else if (index == perm.permComments.count+3) {
            static NSString *cellIdentifier = @"SeperatorCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *seperator = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)] autorelease];
                seperator.tag = kSeperatorCellTag;
                seperator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
                [cell.contentView addSubview:seperator];
            }
            return cell;
        } else {
            static NSString *cellIdentifier = @"PermCommentCell";
            PermCommentCell *cell = (PermCommentCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[PermCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            CommentModel *comment = [perm.permComments objectAtIndex:index-3];
            [cell setCellWithComment:comment];
            return cell;
        }
        
        /*if ([loadMoreSpinner superview]) {
            [loadMoreSpinner stopAnimating];
            [loadMoreSpinner removeFromSuperview];
        }*/
    } else {
        //show spinner
        static NSString *cellIdentifier = @"TaglistCellSpinner";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        
        if (![loadMoreSpinner superview]) {
            [cell.contentView addSubview:self.loadMoreSpinner];
            if (![loadMoreSpinner isAnimating]) {
                [self.loadMoreSpinner startAnimating];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[PermCommentCell class]]) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    } else if ([cell isMemberOfClass:[UITableViewCell class]]) {
        UIView *v = [cell.contentView viewWithTag:kSeperatorCellTag];
        if (v) {
            v.frame = CGRectMake(10, cell.frame.size.height/2, cell.frame.size.width-20, 2);
        }
        v = [cell.contentView viewWithTag:kSpinnerCellTag];
        if (v) {
            self.loadMoreSpinner.frame = CGRectMake((cell.frame.size.width - self.loadMoreSpinner.frame.size.width) / 2, (44 - self.loadMoreSpinner.frame.size.height) / 2, self.loadMoreSpinner.frame.size.width, self.loadMoreSpinner.frame.size.height);
        }
    }
}

#pragma mark -
#pragma mark UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{    
    //check more item
    CGPoint point = [scrollView contentOffset];
    CGSize size = scrollView.contentSize;
    
    if ((size.height - point.y - 1 <= scrollView.frame.size.height) && [self.resultModel isHasMoreResult] && self.resultModel.isFetching == NO)
        {
            self.resultModel.isFetching = YES;
            
            //reload table 
            //[permTableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
            //start to get more feeds
            [self.dataLoaderThread cancel];
            self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(loadMoreDataForMe:thread:) dataObject:[self getMyDataLoader]];
        }
}


# pragma marm - Perm actions
- (void)likePermAtCell:(PermInfoCell*)cell {
    if ([[AppData getInstance] didLogin]) {
        [self.selectedPerms addObject:cell.perm];
        [self startActivityIndicator];
        self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(peformLikePermAction:thread:) dataObject:[self getMyDataLoader]];
    } else {
        NSLog(@"user did not login");
    }
}

- (void)commentPermAtCell:(PermInfoCell*)cell {
    if ([[AppData getInstance] didLogin]) {
        [commentTextField becomeFirstResponder];
        [self.selectedPerms addObject:cell.perm];
    }
}

- (void)repermPermAtCell:(PermInfoCell*)cell {
    CreatePermViewController *controller = [[CreatePermViewController alloc] initWithNibName:@"CreatePermViewController" bundle:nil];
    controller.currentPerm = cell.perm;
    [controller setTarget:self action:@selector(repermDidFinish:)];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (id)getDataLoaderWithPermAction {
    FollowingScreen_DataLoader *loader = [[FollowingScreen_DataLoader alloc] init];
    return [loader autorelease];
}

- (void)peformLikePermAction:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        NSString *userId = [[[AppData getInstance] user] userId];
        PermModel *perm = [[self.selectedPerms objectAtIndex:0] retain];
        NSInteger permIndex = [self.resultModel.arrResults indexOfObjectIdenticalTo:perm];
        [self.selectedPerms removeObjectAtIndex:0];
        PermActionResponse *response = [(FollowingScreen_DataLoader *)loader likePermWithId:perm.permId userId:userId];
        NSError *error = response.responseError;
        if (![threadObj isCancelled]) {
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               if (error) {
                                   [Utils displayAlert:[error localizedDescription] delegate:nil];
                               } else {
                                   if (permIndex < [self.resultModel.arrResults count]) {
                                       PermModel *perm = [self.resultModel.arrResults objectAtIndex:permIndex];
                                       perm.permLikeCount = response.totalLikes;
                                       if ([response.status isEqualToString:@"1"]) { // did like
                                           perm.permUserlikeCount = @"1";
                                       } else { // did unlike
                                           perm.permUserlikeCount = @"0";
                                       }
                                       [permTableview beginUpdates];
                                       [permTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:permIndex]] withRowAnimation:UITableViewRowAnimationFade];
                                       [permTableview endUpdates];
                                   }
                                   
                               }
                           });
        }
        [perm release];
    }
    //[myLoader release];
    [pool drain];
}

- (void)peformCommentPermAction:(id)loader thread:(id<ThreadManagementProtocol>)threadObj
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![threadObj isCancelled]) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           //[self initializeUIControls]; 
                           
                       });
        NSString *userId = [[[AppData getInstance] user] userId];
        PermModel *perm = [[self.selectedPerms objectAtIndex:0] retain];
        [self.selectedPerms removeObjectAtIndex:0];
        PermActionResponse *response = [(FollowingScreen_DataLoader *)loader commentPermWithId:userId userId:perm.permId content:commentTextField.text];
        NSError *error = response.responseError;
        if (![threadObj isCancelled]) {
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self stopActivityIndicator];
                               if (error) {
                                   [Utils displayAlert:[error localizedDescription] delegate:nil];
                               } else {
                                   
                               }
                           });
        }
        [perm release];
    }
    //[myLoader release];
    [pool drain];
}

- (void)doneCommentButtonDidTouch:(id)sender {
    if (![commentTextField.text isEqualToString:@""]) {
        [commentTextField resignFirstResponder];
        [self startActivityIndicator];
        self.dataLoaderThread = [[ThreadManager getInstance] dispatchToConcurrentBackgroundNormalPriorityQueueWithTarget:self selector:@selector(peformCommentPermAction:thread:) dataObject:[self getMyDataLoader]];
    } else {
        [Utils displayAlert:@"Please input your comment" delegate:nil];
    }
    
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    [self.view bringSubviewToFront:commentToolBar];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect frame = commentToolBar.frame;
	frame.origin.y = self.view.frame.size.height - 211.0;
	commentToolBar.frame = frame;
	
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect frame = commentToolBar.frame;
	frame.origin.y = self.view.frame.size.height;
	commentToolBar.frame = frame;
	
	[UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
