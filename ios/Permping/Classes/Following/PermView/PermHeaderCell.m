//
//  PermHeaderCell.m
//  Permping
//
//  Created by Andrew Duck on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermHeaderCell.h"
#import "Webservices.h"

@implementation PermHeaderCell
@synthesize avatarView, permImageView, ownerCommentLabel, descriptionLabel, statusLabel, repermButton, commentButton, likeButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *myContentView = self.contentView;
        avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [myContentView addSubview:avatarView];
        
        permImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [myContentView addSubview:permImageView];
        
        ownerCommentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        ownerCommentLabel.backgroundColor = [UIColor clearColor];
        ownerCommentLabel.numberOfLines = 0;
        [myContentView addSubview:ownerCommentLabel];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont systemFontOfSize:13];
        descriptionLabel.textColor = [UIColor grayColor];
        [myContentView addSubview:descriptionLabel];
        
        repermButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [repermButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [repermButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [repermButton setTitle:@"Reperm" forState:UIControlStateNormal];
        [self addSubview:repermButton];
        
        likeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [likeButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [likeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [self addSubview:likeButton];
        
        commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [commentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        [self addSubview:commentButton];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = [UIFont systemFontOfSize:13];
        statusLabel.textColor = [UIColor grayColor];
        [myContentView addSubview:statusLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake (60, 0, 120, 34);
    self.detailTextLabel.frame = CGRectMake(190, 0, 120, 34);
    CGFloat y;
    CGSize s;
    avatarView.frame = CGRectMake(10, 5, 34, 34);
    
    y = CGRectGetMaxY(avatarView.frame) + 10;
    permImageView.frame = CGRectMake(10, y, 300, 200);
    
    y = CGRectGetMaxY(permImageView.frame) + 10;
    s = [ownerCommentLabel.text sizeWithFont:ownerCommentLabel.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    ownerCommentLabel.frame = CGRectMake(10, y, 300, s.height);
    
    y = CGRectGetMaxY(ownerCommentLabel.frame) + 10;
    descriptionLabel.frame = CGRectMake(10, y, 300, 21);
    
    y = CGRectGetMaxY(descriptionLabel.frame) + 10;
    
    repermButton.frame = CGRectMake(10, y, 70, 37);
    likeButton.frame = CGRectMake(95, y, 70, 37);
    commentButton.frame = CGRectMake(180, y, 100, 37);
    
    y = CGRectGetMaxY(repermButton.frame) + 10;
    statusLabel.frame = CGRectMake(10, y, 300, 21);
}

- (void)setPerm:(WSPerm*)in_perm {
    [perm release];
    perm = [in_perm retain];
    [self.avatarView setImageWithURL:[NSURL URLWithString:perm.owner.userAvatar]];
    [self.textLabel setText:perm.owner.userName];
    [self.detailTextLabel setText:perm.permCategory];
    
    [self.permImageView setImageWithURL:[NSURL URLWithString:perm.permImage]];

    [self.ownerCommentLabel setText:perm.permOwnerComment];
    [self.descriptionLabel setText:perm.permDesc];
    [self.statusLabel setText:perm.permStatus];
}

- (void)dealloc {
    [avatarView release];
    [permImageView release];
    [ownerCommentLabel release];
    [descriptionLabel release];
    [statusLabel release];
    [repermButton release];
    [commentButton release];
    [likeButton release];
    [super dealloc];
}

@end
