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
#import "PermInfoCell.h"
#import "PermCommentCell.h"
#import "WSPerm.h"
//phong add
#import "PermModel.h"
#import "CommentModel.h"

@implementation PermsViewController
@synthesize permsArray;

- (void)dealloc {
    [permTableview release];
    [permsArray release];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    permTableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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

    [permTableview release]; permTableview = nil;
}

#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.permsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WSPerm *perm = [self.permsArray objectAtIndex:section];
    NSInteger count = 3 + perm.permComments.count;
    return MIN(count, 8); // max 5 comment;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 60.0;
    if (indexPath.row == 2) {
        h = 140.0;
    }
    return h;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PermModel *perm = [self.permsArray objectAtIndex:indexPath.section];
    NSInteger index = indexPath.row;
    if (index == 0) {
        static NSString *cellIdentifier = @"PermUserCell";
        PermUserCell *cell = (PermUserCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[PermUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        //phong remove
//        [cell setCellWithAvartarURLString:perm.permUser.userAvatar userName:perm.permUser.userName category:perm.permCategory];
        return cell;
    } else if (index == 1){
        static NSString *cellIdentifier = @"PermImageCell";
        PermImageCell *cell = (PermImageCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[PermImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        __block NSString *imageString = perm.permImage;
        [cell.permImageView setImageWithURL:[NSURL URLWithString:perm.permImage] success:^(UIImage *image) {
        } failure:^(NSError *error) {
            NSLog(@"fail image: %@", imageString);
        }];
        return cell;
    } else if (index == 2) {
        static NSString *cellIdentifier = @"PermInfoCell";
        PermInfoCell *cell = (PermInfoCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[PermInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        [cell setCellWithPerm:perm];
        return cell;
    } else {
        static NSString *cellIdentifier = @"PermCommentCell";
        PermCommentCell *cell = (PermCommentCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[PermCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        CommentModel *comment = [perm.permComments objectAtIndex:index-3];
        [cell setCellWithComment:comment];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[PermCommentCell class]]) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
}
@end
