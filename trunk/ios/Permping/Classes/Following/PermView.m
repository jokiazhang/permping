//
//  PermView.m
//  Permping
//
//  Created by MAC on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermView.h"
#import "Webservices.h"

@implementation PermView

@synthesize userAvatarView, usernameLabel, categoryLabel, imageView, commentLabel, timeLabel, repermButton, likeButton, commentButton, statusLabel, perm;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        userAvatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:userAvatarView];
        
        usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        usernameLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:usernameLabel];
        
        categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        categoryLabel.textAlignment = UITextAlignmentRight;
        categoryLabel.textColor = [UIColor grayColor];
        categoryLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:categoryLabel];
    
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:imageView];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:commentLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:timeLabel];
        
        repermButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [repermButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [repermButton setTitle:@"Reperm" forState:UIControlStateNormal];
        [self addSubview:repermButton];
        
        likeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [likeButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [self addSubview:likeButton];
        
        commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        [self addSubview:commentButton];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:statusLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    userAvatarView.frame = CGRectMake(0, 0, 35, 35);
    usernameLabel.frame = CGRectMake(40, 0, 200, 35);
    categoryLabel.frame = CGRectMake(250, 0, 70, 35);
    imageView.frame = CGRectMake(10, 40, 300, 200);
    commentLabel.frame = CGRectMake(10, 250, 300, 30);
    timeLabel.frame = CGRectMake(10, 290, 300, 30);
    repermButton.frame = CGRectMake(10, 330, 70, 37);
    likeButton.frame = CGRectMake(85, 330, 70, 37);
    commentButton.frame = CGRectMake(160, 330, 70, 37);
    statusLabel.frame = CGRectMake(10, 210, 300, 30);
}

- (void)setPerm:(WSPerm *)in_perm {
    [perm release];
    perm = [in_perm retain];
}

- (void)dealloc {
    [userAvatarView release];
    [usernameLabel release];
    [categoryLabel release];
    [imageView release];
    [commentLabel release];
    [timeLabel release];
    [repermButton release];
    [likeButton release];
    [commentButton release];
    [statusLabel release];
    [super dealloc];
}


@end
