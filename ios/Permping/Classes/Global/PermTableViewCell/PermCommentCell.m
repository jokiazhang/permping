//
//  PermCommentCell.m
//  Permping
//
//  Created by MAC on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermCommentCell.h"
#import "WSComment.h"
#import "WSUser.h"

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

- (void)setCellWithComment:(CommentModel*)in_comment{
    [self.avatarView setImageWithURL:[NSURL URLWithString:in_comment.commentUser.userAvatar]];
    self.textLabel.text = in_comment.commentUser.userAvatar;
    self.detailTextLabel.text = in_comment.content;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    avatarView.frame = CGRectMake(10, 5, 34, 34);
    self.textLabel.frame = CGRectMake (50, 5, 250, 15);
    self.detailTextLabel.frame = CGRectMake(50, 25, 250, 20);
}

- (void)dealloc {
    [avatarView release];
    [super dealloc];
}

@end
