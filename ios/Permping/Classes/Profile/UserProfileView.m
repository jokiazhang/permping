//
//  UserProfileView.m
//  Permping
//
//  Created by MAC on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfileView.h"
#import "Webservices.h"

@implementation UserProfileView
@synthesize user;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 52, 52)];
        [self addSubview:avatarView];
        
        userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        userNameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:userNameLabel];
        
        permsNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        permsNumberLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:permsNumberLabel];
            
        boardTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        boardTableView.backgroundColor = [UIColor clearColor];
        boardTableView.delegate = self;
        boardTableView.dataSource = self;
        boardTableView.scrollEnabled = NO;
        [self addSubview:boardTableView];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    avatarView.frame = CGRectMake(10, 18, 52, 52);
    userNameLabel.frame = CGRectMake(70, 25, 150, 18);
    permsNumberLabel.frame = CGRectMake(70, 54, 150, 16);
    boardTableView.frame = CGRectMake(10, 95, 300, 44*4 + 20);
}


- (void)setUser:(WSUser *)in_user {
    [user release];
    user = [in_user retain];
    NSLog(@"userAvatar: %@", user.userAvatar);
    [avatarView setImageWithURL:[NSURL URLWithString:user.userAvatar]];
    userNameLabel.text= user.userName;
    permsNumberLabel.text = @"perms 15 followers 16";
    self.contentSize = CGSizeMake(320, 310);
}


#pragma mark - <UITableViewDelegate + DataSource> implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *boardReuseIdentifier = @"boardReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:boardReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:boardReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *title, *subTitle;
    if (indexPath.row == 0) {
        title = @"Create";
        subTitle = @"perms 15 followers 17";
    } else if (indexPath.row == 1) {
        title = @"People";
        subTitle = @"perms 10 follower 16";
    } else if (indexPath.row == 2) {
        title = @"Yeah Disney World!";
        subTitle = @"perms 16 followers 16";
    } else if (indexPath.row == 3) {
        title = @"House";
        subTitle = @"perms 43 follower 17";
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)dealloc {
    [avatarView release];
    [userNameLabel release];
    [permsNumberLabel release];
    [boardTableView release];
    [super dealloc];
}

@end
