//
//  FollowingViewController.m
//  Permping
//
//  Created by MAC on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FollowingViewController.h"
#import "JoinViewController.h"
#import "LoginViewController.h"
#import "PermHeaderCell.h"
#import "PermCommentCell.h"
#import "Webservices.h"
#import "JoinPopupDialog.h"

@implementation FollowingViewController
@synthesize permsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"FollowingTabTitle", @"Followers");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-item-following"];
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
    if (![self checkDidLogin]) {
        permTableview.tableHeaderView = tableHeaderView;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)loadPermsFromFile {
    NSString *file = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/permList.xml"];
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSError *error;
    NSMutableArray *perms = [[NSMutableArray alloc] init];
    TBXML *tbxml = [TBXML newTBXMLWithXMLData:data error:&error];
    if (tbxml.rootXMLElement) {
        TBXMLElement *child = tbxml.rootXMLElement->firstChild;
        do {
            if ([[TBXML elementName:child] isEqualToString:@"popularPerms"]) {
                TBXMLElement *item = child->firstChild;
                while (item) {
                    WSPerm *perm = [[WSPerm alloc] initWithXmlElement:item];
                    if (!perm.owner) {
                        perm.owner = self.user;
                    }
                    [perms addObject:perm];
                    [perm release];
                    item = item->nextSibling;
                }
            } else if([[TBXML elementName:child] isEqualToString:@"user"]) {
                self.user = [[[WSUser alloc] initWithXmlElement:child] autorelease];
            }
        } while ((child = child->nextSibling));
        self.permsArray = perms;
    }
    [tbxml release];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*PermListRequest *request = [[PermListRequest alloc] initWithToken:@""];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerResponse:) name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
	[[RequestManager sharedInstance] performRequest:request];*/
    
    [self loadPermsFromFile];
}

- (void)handleServerResponse: (NSNotification*)in_response {
	//NSLog(@"handleServerResponse: %@", in_response);
	
	/*ServerRequest *request = in_response.object;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:REQUESTMANAGER_REQUEST_TERMINATED_NOTIFICATION object:request];
	
	if (!request.result.error) {
		id result = request.result.object;
		if ([result isKindOfClass:[NSArray class]]) {
            
		}
	} else {
		NSLog(@"Failed to load permlist");
	}*/
}


#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.permsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WSPerm *perm = [self.permsArray objectAtIndex:section];
    NSInteger count = 1 + perm.permComments.count;
    return MIN(count, 6);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO :
    CGFloat h = 60.0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        h = 400;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        h = 420;
    }
    return h;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *permReuseIdentifier = @"PermCellIdentifier";
    static NSString *commentReuseIdentifier = @"CommentReuseIdentifier";
    WSPerm *perm = [self.permsArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        PermHeaderCell *cell = (PermHeaderCell*)[tableView dequeueReusableCellWithIdentifier:permReuseIdentifier];
        if (cell == nil) {
            cell = [[PermHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:permReuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setPerm:perm];
        return cell;
    } else {
        PermCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentReuseIdentifier];
        if (cell == nil) {
            cell = [[PermCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentReuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        WSComment *comment = [perm.permComments objectAtIndex:indexPath.row-1];
        [cell setComment:comment];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[PermCommentCell class]]) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
}

- (IBAction)joinButtonDidTouch:(id)sender {
    JoinViewController *controller = [[JoinViewController alloc] initWithNibName:@"JoinViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    /*JoinPopupDialog *dialog = [[JoinPopupDialog alloc] initWithDelegate:self];
    [dialog showWithScale:0.5];
    [dialog release];*/
}

- (IBAction)loginButtonDidTouch:(id)sender {
    LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
