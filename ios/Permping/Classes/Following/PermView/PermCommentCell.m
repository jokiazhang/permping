//
//  PermCommentCell.m
//  Permping
//
//  Created by MAC on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermCommentCell.h"
#import "Webservices.h"

@implementation PermCommentCell
@synthesize avatarView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:avatarView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(WSComment*)in_comment {
    [comment release];
    comment = [in_comment retain];
    [self.avatarView setImageWithURL:[NSURL URLWithString:comment.user.userAvatar]];
    self.textLabel.text = comment.user.userName;
    self.detailTextLabel.text = comment.content;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    avatarView.frame = CGRectMake(10, 5, 34, 34);
    self.textLabel.frame = CGRectMake (50, 5, 250, 15);
    self.detailTextLabel.frame = CGRectMake(50, 25, 250, 20);
}

- (void)dealloc {
    [comment release];
    [avatarView release];
    [super dealloc];
}

@end
