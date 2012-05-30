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
#import "Utils.h"
//phong add
#import "PermModel.h"
#import "CommentModel.h"

@implementation PermsViewController
@synthesize permsArray;

- (void)dealloc {
    [permTableview release];
    [permsArray release];
    [permsImageHeight release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        permsImageHeight = [[NSMutableDictionary alloc] init];
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
    NSLog(@"numberOfSectionsInTableView: %d", self.permsArray.count);
    return [self.permsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PermModel *perm = [self.permsArray objectAtIndex:section];
    NSInteger seperator = (section==(self.permsArray.count-1))?0:1;
    NSInteger count = 3 + perm.permComments.count + seperator;

    //NSLog(@"section %d : %d, %d", section, count, perm.permComments.count);
    return MIN(count, 8+seperator); // max 5 comment;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = 60.0;
    PermModel *perm = [self.permsArray objectAtIndex:indexPath.section];
    if (indexPath.row == 1) {
        NSNumber *height = [permsImageHeight objectForKey:[NSString stringWithFormat:@"%d", indexPath.section]];
        if (height) {
            h = [height floatValue];
        }
    } else if (indexPath.row == 2) {
        CGSize s = [perm.permDesc sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
        h = 120 + s.height;
    } else if (indexPath.row - 3 == perm.permComments.count) { 
        h = 10;
    }
    return h;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PermModel *perm = [self.permsArray objectAtIndex:indexPath.section];
    NSInteger index = indexPath.row;
    NSInteger section = indexPath.section;
    if (index == 0) {
        static NSString *cellIdentifier = @"PermUserCell";
        PermUserCell *cell = (PermUserCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[PermUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }

        [cell setCellWithAvartarURLString:perm.permUser.userAvatar userName:perm.permUser.userName category:perm.permCategory];
        return cell;
    } else if (index == 1){
        static NSString *cellIdentifier = @"PermImageCell";
        PermImageCell *cell = (PermImageCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[PermImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        
        //NSLog(@"imageString: %@", perm.permImage);
        [cell.permImageView setImageWithURL:[NSURL URLWithString:perm.permImage] success:^(UIImage *image) {
            if (![permsImageHeight objectForKey:[NSString stringWithFormat:@"%d", section]]) {
                CGFloat height = [Utils sizeWithImage:image constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)].height;
                [permsImageHeight setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormat:@"%d", section]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [permTableview reloadData];
                });
            }
        } failure:^(NSError *error) {
            
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
    } else if (index == perm.permComments.count+3) {
        static NSString *cellIdentifier = @"SeperatorCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *seperator = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)] autorelease];
            seperator.tag = 333;
            seperator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            [cell.contentView addSubview:seperator];
        }
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
    } else if ([cell isKindOfClass:[UITableViewCell class]]) {
        UIView *v = [cell.contentView viewWithTag:333];
        v.frame = CGRectMake(10, cell.frame.size.height/2, cell.frame.size.width-20, 2);
    }
}
@end
