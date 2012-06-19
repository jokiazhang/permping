//
//  PermInfoCell.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermInfoCell.h"
#import "Utility.h"
#import "AppData.h"

@implementation PermInfoCell
@synthesize commentLabel, descriptionLabel, repermButton, commentButton, likeButton, locationButton, statusLabel;
@synthesize delegate, perm;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *myContentView = self.contentView;
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.textColor = [Utility colorRefWithString:@"#4c566c"];
        commentLabel.numberOfLines = 0;
        commentLabel.font  = [UIFont systemFontOfSize:16];
        commentLabel.shadowColor = [UIColor whiteColor];
        commentLabel.shadowOffset = CGSizeMake(0, 2);
        [myContentView addSubview:commentLabel];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont systemFontOfSize:13];
        descriptionLabel.textColor = [UIColor grayColor];
        [myContentView addSubview:descriptionLabel];
        
        repermButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [repermButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [repermButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [repermButton setTitle:NSLocalizedString(@"Reperm", @"Reperm") forState:UIControlStateNormal];
        [repermButton setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
        [repermButton addTarget:self action:@selector(repermButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        [myContentView addSubview:repermButton];
        
        likeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [likeButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [likeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [likeButton setTitle:NSLocalizedString(@"Like", @"Like") forState:UIControlStateNormal];
        [likeButton setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(likePermButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        [myContentView addSubview:likeButton];
        
        commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"btn-background"] forState:UIControlStateNormal];
        [commentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [commentButton setTitle:NSLocalizedString(@"Comment", @"Comment") forState:UIControlStateNormal];
        [commentButton setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(commentPermButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        [myContentView addSubview:commentButton];
        
        locationButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [locationButton setImage:[UIImage imageNamed:@"location-btn"] forState:UIControlStateNormal];
        [locationButton addTarget:self action:@selector(locationButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
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
    commentButton.frame = CGRectMake(95, y, 100, 37);
    likeButton.frame = CGRectMake(210, y, 70, 37);
    locationButton.frame = CGRectMake(290, y, 20, 37);
    
    y = CGRectGetMaxY(repermButton.frame) + 10;
    statusLabel.frame = CGRectMake(10, y, 300, 21);
    
    //NSLog(@"h: %f, %f", y+21, y+21-s.height);
}

- (void)setCellWithPerm:(PermModel*)in_perm {
    self.perm = in_perm;
    self.commentLabel.text = perm.permDesc;
    self.descriptionLabel.text = perm.permDateMessage;
    NSString *like = ([in_perm.permUserlikeCount intValue]==0)?@"Like":@"Unlike";
    [likeButton setTitle:like forState:UIControlStateNormal];
    
    self.statusLabel.text = [NSString stringWithFormat:@"Likes %@ Comments %@ Repin %@", perm.permLikeCount, perm.permCommentCount, perm.permRepinCount];
    
    if ([[AppData getInstance] didLogin] && [[AppData getInstance].user.userId isEqualToString:in_perm.permUser.userId]) {
        likeButton.hidden = YES;
    } else {
        likeButton.hidden = NO;
    }
    
    if (in_perm.latitude && in_perm.longitude) {
        locationButton.hidden = NO;
    } else {
        locationButton.hidden = NO;
    }
}

- (void)likePermButtonDidTouch:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(likePermAtCell:)]) {
        [delegate likePermAtCell:self];
    }
}

- (void)commentPermButtonDidTouch:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(commentPermAtCell:)]) {
        [delegate commentPermAtCell:self];
    }
}

- (void)repermButtonDidTouch:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(repermPermAtCell:)]) {
        [delegate repermPermAtCell:self];
    }
}

- (void)locationButtonDidTouch:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(findLocationForPermAtCell:)]) {
        [delegate findLocationForPermAtCell:self];
    }
}

- (void)dealloc {
    [commentLabel release];
    [descriptionLabel release];
    [repermButton release];
    [commentButton release];
    [likeButton release];
    [locationButton release];
    [statusLabel release];
    self.perm = nil;
    [super dealloc];
}
@end
