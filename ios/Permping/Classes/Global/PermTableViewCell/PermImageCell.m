//
//  PermImageCell.m
//  Permping
//
//  Created by MAC on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PermImageCell.h"

@implementation PermImageCell
@synthesize permImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *myContentView = self.contentView;
        permImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        permImageView.backgroundColor = [UIColor clearColor];
        [myContentView addSubview:permImageView];
    }
    return self;
}

- (void)dealloc {
    [permImageView release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    permImageView.frame = self.bounds;
    if (permImageView.image) {
        CGFloat width = permImageView.image.size.width;
        if (width < 300) {
            permImageView.frame = CGRectInset(self.bounds, 10 + (300-width)/2, 0);
        } else {
            permImageView.frame = CGRectInset(self.bounds, 10, 0);
        }
    } else {
        UIView *activity = [permImageView viewWithTag:TAG_ACTIVITY_INDICATOR];
        if (activity) {
            activity.center = permImageView.center;
        }
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    permImageView.image = nil;
}

@end
