//
//  PermInfoCell.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermInfoCell.h"
#import "WSPerm.h"
@implementation PermInfoCell
@synthesize commentLabel, descriptionLabel, repermButton, commentButton, likeButton, locationButton, statusLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *myContentView = self.contentView;
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.numberOfLines = 0;
        [myContentView addSubview:commentLabel];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont systemFontOfSize:13];
        descriptionLabel.textColor = [UIColor grayColor];
        [myContentView addSubview:descriptionLabel];
        
        repermButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [repermButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [repermButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [repermButton setTitle:@"Reperm" forState:UIControlStateNormal];
        [myContentView addSubview:repermButton];
        
        likeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [likeButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [likeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [myContentView addSubview:likeButton];
        
        commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [commentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        [myContentView addSubview:commentButton];
        
        locationButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [locationButton setImage:[UIImage imageNamed:@"location-btn"] forState:UIControlStateNormal];
        [myContentView addSubview:locationButton];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = [UIFont systemFontOfSize:13];
        statusLabel.textColor = [UIColor grayColor];
        [myContentView addSubview:statusLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat y;
    CGSize s;
    y = 10;
    s = [commentLabel.text sizeWithFont:commentLabel.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    commentLabel.frame = CGRectMake(10, y, 300, s.height);
    
    y = CGRectGetMaxY(commentLabel.frame) + 10;
    descriptionLabel.frame = CGRectMake(10, y, 300, 21);
    
    y = CGRectGetMaxY(descriptionLabel.frame) + 10;
    
    repermButton.frame = CGRectMake(10, y, 70, 37);
    likeButton.frame = CGRectMake(95, y, 70, 37);
    commentButton.frame = CGRectMake(180, y, 100, 37);
    
    y = CGRectGetMaxY(repermButton.frame) + 10;
    statusLabel.frame = CGRectMake(10, y, 300, 21);
    
    //NSLog(@"h: %f", y+21);
}

- (void)setCellWithPerm:(PermModel*)perm {
    self.commentLabel.text = perm.permDesc;
    self.descriptionLabel.text = @"No desc :D";
    self.statusLabel.text = [NSString stringWithFormat:@"Likes %@ Comments %@ Repin %@", perm.permLikeCount, perm.permCommentCount, perm.permRepinCount];
}

- (void)dealloc {
    [commentLabel release];
    [descriptionLabel release];
    [repermButton release];
    [commentButton release];
    [likeButton release];
    [locationButton release];
    [statusLabel release];
    [super dealloc];
}
@end
